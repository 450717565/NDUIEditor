SERVERHOP_VERSION = GetAddOnMetadata("ServerHop", "Version")

-- GUI
SERVERHOP_WIDTH = 240
SERVERHOP_HEIGHT = 130

ServerHop = CreateFrame("Frame",nil,UIParent)
ServerHop:SetPoint("CENTER",0,0)
ServerHop:SetFrameStrata("HIGH")
ServerHop:SetFrameLevel(1)
ServerHop:SetWidth(SERVERHOP_WIDTH)
ServerHop:SetHeight(SERVERHOP_HEIGHT)
ServerHop:SetMovable(true)
ServerHop:EnableMouse(true)
ServerHop:RegisterForDrag("LeftButton")
ServerHop:SetScript("OnDragStart", ServerHop.StartMoving)
ServerHop:SetScript("OnDragStop", ServerHop.StopMovingOrSizing)
ServerHop:Hide()

-- Toggle button attached to LFGListFrame
local toggleButton = CreateFrame("Button",nil,LFGListFrame,"UIPanelButtonTemplate")
toggleButton:SetSize(65,22)
toggleButton:SetPoint("BOTTOM",LFGListFrame,"BOTTOM",-3,4)
toggleButton:SetText("跨服")
toggleButton:SetScript("OnClick", function(btn)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

	if ServerHop:IsShown() then
		ServerHop:Hide()
	else
		ServerHop:Show()
	end
end)

toggleButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(SERVERHOP_TOGGLE)
	GameTooltip:Show()
end)
toggleButton:SetScript("OnLeave", function(self) GameTooltip:Hide() end)

if IsAddOnLoaded("Aurora") then
	local F, C = unpack(Aurora)
	F.Reskin(toggleButton)
end

SLASH_SERVERHOP1 = "/sh" SLASH_SERVERHOP2 = "/serverhop"
SlashCmdList["SERVERHOP"] = function(msg, editbox)
	if ServerHop:IsShown() then
		ServerHop:Hide()
	else
		ServerHop:Show()
	end
end

-- Variables
ServerHop.var = CreateFrame("Frame")
-- Custom Search Declarations
ServerHop.var.addonSearchRequest = false
-- Host mode
ServerHop.var.hosting = false
ServerHop.var.defaultComment = "Hosted by Server Hop addon for hopping."
ServerHop.var.currentZone = 1
ServerHop.var.inOrderHall = false

ServerHop.var.pvpList = {}
ServerHop.var.minimapDB = {
	global = {
		minimap = {hide = false}
	}
}

-- Tables
ServerHop.tables = {}
ServerHop.tables.LeadersBL = {}
ServerHop.tables.TabCategories = {}
ServerHop.tables.Zones = {}
-- Functions
function ServerHop_GatherPvPRealms(region)
	ServerHop.var.pvpList = {}
	for k,v in pairs(ServerHop_Realmlist) do
		if v.region == region and v.pvp == true then
			local blizzname = v.name:gsub("[%s]+", "")
			ServerHop.var.pvpList[blizzname] = true
		end
	end
end

function NotInGroup()
	return (not IsInGroup() and not IsInRaid())
end

function canJoinGroup()
	return (not IsInGroup()) or (UnitIsGroupLeader('player') and not IsInRaid())
end

function ServerHop_GetRealm(region, name)
	for index, info in pairs(ServerHop_Realmlist) do
		if info.region == region and info.name == name then
			return info;
		end
	end

	return nil;
end

function PlayerRealm(fullname)
	fullname = fullname or "???-???"
	local name, realm = strsplit(_G.REALM_SEPARATORS, fullname)
	realm = realm or GetRealmName();
	return realm;
end

function ServerHop:GetZoneList()
	for i=1,500 do
		local name,subname,cat = C_LFGList.GetActivityInfo(i)
		if cat == 1 then
			table.insert(ServerHop.tables.Zones,i)
		end
	end
end

function ServerHop:GetMyZoneID()
	-- remove garrisons
	if C_Garrison.IsPlayerInGarrison(LE_GARRISON_TYPE_7_0) or C_Garrison.IsPlayerInGarrison(LE_GARRISON_TYPE_6_0) then ServerHop.var.inOrderHall = true return 1 end

	for k,v in pairs(ServerHop.tables.Zones) do
		if C_LFGList.GetActivityInfoExpensive(v) then
			return v
		end
	end
	-- no such zone, return 1
	return 1
end

local origChatFrame_OnHyperlinkShow = ChatFrame_OnHyperlinkShow

ChatFrame_OnHyperlinkShow = function(...)
	local chatFrame, link, text, button = ...
	if type(text) == "string" and text:match("sehopW") and not IsModifiedClick() then
		ServerHop:Show()
	else
		return origChatFrame_OnHyperlinkShow(...)
	end
end

function ServerHop:Log(log,msg)
	print("\124cff71d5ff\124HsehopW:123\124h[Server Hop]\124h\124r ["..log.."]: "..msg)
end