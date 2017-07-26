local AceAddon = LibStub("AceAddon-3.0")
local LookingForGroup = AceAddon:GetAddon("LookingForGroup")
local LookingForGroup_Icon = AceAddon:NewAddon("LookingForGroup_Icon")

local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("LookingForGroup_Icon",{
	type = "data source",
	icon = "Interface/Icons/INV_Misc_GroupNeedMore"
})

local AceConfigDialog = LibStub("AceConfigDialog-3.0")

function LDB:OnClick(button)
	if button == "RightButton" then
		LookingForGroup.GetAddon("LookingForGroup_CR").do_scan()
	elseif button == "MiddleButton" then
		local status,LookingForGroup_Options = pcall(AceAddon.GetAddon,AceAddon,"LookingForGroup_Options")
		if status then
			local sr = LookingForGroup_Options.option_table.args.search_result
			if sr then
				sr.args.back.func()
			end
		end
	else
		if AceConfigDialog.OpenFrames.LookingForGroup then
			AceConfigDialog:Close("LookingForGroup")
		else
			LookingForGroup:ChatCommand()
		end
	end
end

function LDB:OnEnter()
	GameTooltip:SetOwner(self)
	GameTooltip:ClearLines()
	GameTooltip:AddLine("LookingForGroup")
	local status,LookingForGroup_Options = pcall(AceAddon.GetAddon,AceAddon,"LookingForGroup_Options")
	if status then
		if LookingForGroup_Options.Background_Timer then
			GameTooltip:AddLine("|cff8080cc"..SEARCHING.."|r")
		end
		if LookingForGroup_Options.Background_ResultReceived() then
			GameTooltip:AddLine("|cffff00ff"..KBASE_SEARCH_RESULTS.."|r")
		end
	end
	GameTooltip:Show()
end

function LDB:OnLeave()
	GameTooltip:Hide()
end

local icon = LibStub("LibDBIcon-1.0")

function LookingForGroup_Icon:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("LookingForGroup_IconCharacterDB", {profile = {}})
	self.icon = LibStub("LibDBIcon-1.0"):Register("LookingForGroup_Icon",LDB,self.db.profile)
end

function LookingForGroup_Icon:OnEnable()
	if LookingForGroup.db.profile.enable_icon then
		icon:Show("LookingForGroup_Icon")
	else
		icon:Hide("LookingForGroup_Icon")
	end
end
