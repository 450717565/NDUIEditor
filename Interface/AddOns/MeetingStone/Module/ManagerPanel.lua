
BuildEnv(...)

ManagerPanel = Addon:NewModule(CreateFrame('Frame'), 'ManagerPanel', 'AceEvent-3.0', 'AceBucket-3.0')
local ApplicantsListFrame = nil
local ApplicantsListEditBox = nil

local CHECK_USEABLE_EVENTS = {
    'PARTY_LEADER_CHANGED',
    'GROUP_ROSTER_UPDATE',
    'UPDATE_BATTLEFIELD_STATUS',
    'LFG_UPDATE',
    'LFG_ROLE_CHECK_UPDATE',
    'LFG_PROPOSAL_UPDATE',
    'LFG_PROPOSAL_FAILED',
    'LFG_PROPOSAL_SUCCEEDED',
    'LFG_PROPOSAL_SHOW',
    'LFG_QUEUE_STATUS_UPDATE',
}
function HasCorruptionData(tag)
    -- Use this to optimize
end
function DoInspectAll()
    -- Need optimize
    if UnitName("party1") and CanInspect("party1") then
        NotifyInspect("party1")
    end
end
function ShowExportFrame(exportType)
    local currentRealm = GetRealmName()
    local outputText = ""
    if(exportType == 1) then
        local applicants = C_LFGList.GetApplicants();
        if(not applicants or #applicants == 0) then
            print("当前没有人申请")
            return
        end
        local applicants = C_LFGList.GetApplicants();
        if(not applicants or #applicants == 0) then
            print("当前没有人申请")
            return
        end
        local currentRealm = GetRealmName()
        for k,v in pairs(applicants) do
            applicantInfo = C_LFGList.GetApplicantInfo(v)
            for i=1,applicantInfo.numMembers,1 do
                local name = C_LFGList.GetApplicantMemberInfo(applicantInfo.applicantID, i)
                if string.find(name, "-") == nil then
                    name = name.."-"..currentRealm
                end
                outputText = outputText..name..'\n'
            end
        end
    else
        local partyPlayers = GetHomePartyInfo()
        if(not partyPlayers or #partyPlayers == 0) then
            print("当前不在队伍中")
            return
        end
        for k,v in pairs(partyPlayers) do
            local name = v
            if string.find(name, "-") == nil then
                name = name.."-"..GetRealmName()
            end
            outputText = outputText..name..'\n'
        end
    end
    if(ApplicantsListFrame ~= nil) then
    else 
        ApplicantsListFrame = CreateFrame("Frame", "ALFrame", UIParent, "DialogBoxFrame")
        ApplicantsListFrame:SetPoint("CENTER")
        ApplicantsListFrame:SetSize(300, 400)
        ApplicantsListFrame:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
            edgeSize = 16,
            insets = { left = 8, right = 6, top = 8, bottom = 8 },
        })
        ApplicantsListFrame:SetBackdropBorderColor(0, .44, .87, 0.5)
        ApplicantsListFrame:SetClampedToScreen(true)
        ApplicantsListEditBox = CreateFrame("EditBox", "ALEditBox", ApplicantsListFrame)
        ApplicantsListEditBox:SetPoint("TOPLEFT", ApplicantsListFrame,"TOPLEFT",20, -20);
        ApplicantsListEditBox:SetSize(260,360)
        ApplicantsListEditBox:SetMultiLine(true)
        ApplicantsListEditBox:SetAutoFocus(true)
        ApplicantsListEditBox:SetFontObject("ChatFontNormal")
        ApplicantsListEditBox:SetScript("OnEscapePressed", function() ApplicantsListFrame:Hide() end)
    end
    outputText = string.sub(outputText, 1, -2)
    ApplicantsListEditBox:SetText(outputText)
    ApplicantsListEditBox:HighlightText()
    ApplicantsListEditBox:SetEnabled(true)
    ApplicantsListFrame:Show()

end
function ManagerPanel:OnInitialize()
    GUI:Embed(self, 'Owner', 'Tab', 'Refresh')

    MainPanel:RegisterPanel(L['管理活动'], self, 5, 70)

    -- frames
    local FullBlocker = Addon:GetClass('Cover'):New(self) do
        FullBlocker:SetPoint('TOPLEFT', -3, 3)
        FullBlocker:SetPoint('BOTTOMRIGHT', 3, -3)
        FullBlocker:SetStyle('CIRCLE')
        FullBlocker:SetBackground([[Interface\DialogFrame\UI-DialogBox-Background-Dark]])
        FullBlocker:Hide()
    end

    local ApplicantListBlocker = Addon:GetClass('Cover'):New(self) do
        ApplicantListBlocker:SetPoint('TOPLEFT', 219, 0)
        ApplicantListBlocker:SetPoint('BOTTOMRIGHT')
        ApplicantListBlocker:SetStyle('LINE')
        ApplicantListBlocker:Hide()
    end

    local RefreshButton = Addon:GetClass('RefreshButton'):New(self) do
        RefreshButton:SetPoint('TOPRIGHT', self:GetOwner(), 'TOPRIGHT', -10, -23)
        RefreshButton:SetTooltip(LFG_LIST_REFRESH)
        RefreshButton:SetScript('OnClick', function()
            if self:HasActivity() then
                C_LFGList.RefreshApplicants()
            end
        end)
    end

    local ImportApplicantsButton = Addon:GetClass('RefreshButton'):New(self) do
        ImportApplicantsButton:SetPoint('RIGHT', RefreshButton, 'LEFT', -10, 0)
        ImportApplicantsButton:SetTooltip("导出目前的申请列表")
        ImportApplicantsButton:SetText("导出申请列表")
        ImportApplicantsButton:SetSize(120, 31)
        ImportApplicantsButton:SetScript('OnClick', function()
            ShowExportFrame(1)
        end)
    end

    
    local ImportGroupPlayersButton = Addon:GetClass('RefreshButton'):New(self) do
        ImportGroupPlayersButton:SetPoint('RIGHT', ImportApplicantsButton, 'LEFT', -10, 0)
        ImportGroupPlayersButton:SetTooltip("导出队伍玩家")
        ImportGroupPlayersButton:SetText("导出队伍玩家")
        ImportGroupPlayersButton:SetSize(120, 31)
        ImportGroupPlayersButton:SetScript('OnClick', function()
            ShowExportFrame(2)
        end)
    end


    self.FullBlocker = FullBlocker
    self.ApplicantListBlocker = ApplicantListBlocker
    self.RefreshButton = RefreshButton

    -- 检查是否可以创建活动
    self:RegisterBucketEvent(CHECK_USEABLE_EVENTS, 0.1, 'CheckUseable')

    self:RegisterMessage('MEETINGSTONE_CREATING_ACTIVITY', 'ShowCreatingBlocker')

    self:RegisterEvent('LFG_LIST_ENTRY_CREATION_FAILED', 'HideCreatingBlocker')
    self:RegisterEvent('LFG_LIST_ACTIVE_ENTRY_UPDATE', 'HideCreatingBlocker')

    self:SetScript('OnShow', self.CheckUseable)
end

function ManagerPanel:CheckUseable()
    C_LFGList.RefreshApplicants()

    local isLeader = IsGroupLeader()
    local isManager = IsActivityManager()
    local msg = LFGListUtil_GetActiveQueueMessage(false)

    self.RefreshButton:Disable()

    if self:HasActivity() then
        if isLeader or isManager then
            self.RefreshButton:Enable()
            self:SetApplicantListBlocker(false)
        else
            self:SetApplicantListBlocker(LFG_LIST_GROUP_FORMING)
        end
    else
        if isLeader then
            self:SetApplicantListBlocker(msg or L['请创建活动'])
        else
            self:SetApplicantListBlocker(msg or L['只有团长才能预创建队伍'])
        end
    end
    self:SendMessage('MEETINGSTONE_PERMISSION_UPDATE', isLeader and not msg, isManager)
end

function ManagerPanel:HasActivity()
    return C_LFGList.GetActiveEntryInfo()
end

function ManagerPanel:HideCreatingBlocker()
    self:SetBlocker(false)
    self:CheckUseable()
end

function ManagerPanel:ShowCreatingBlocker()
    self:SetBlocker(LFG_LIST_CREATING_ENTRY, true)
end

function ManagerPanel:SetBlocker(text, showIcon)
    self.FullBlocker:SetText(text, not showIcon)
    self.FullBlocker:SetShown(text)
    if text then
        self:SetApplicantListBlocker(false)
    end
end

function ManagerPanel:SetApplicantListBlocker(text)
    if text and not self.FullBlocker:IsVisible() then
        self.ApplicantListBlocker:SetText(text)
        self.ApplicantListBlocker:Show()
    else
        self.ApplicantListBlocker:Hide()
    end
end
