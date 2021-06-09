local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")
local TT = B:GetModule("Tooltip")

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local function Update_SelectTab(self, tab)
	local id = tab and tab:GetID() or 0
	if (not QuestScrollFrame.Contents:IsShown() and not QuestMapFrame.DetailsFrame:IsShown()) or id == 1 then
		WQT_TabNormal.HL:Show()
		WQT_TabWorld.HL:Hide()
	elseif id == 2 then
		WQT_TabWorld.HL:Show()
		WQT_TabNormal.HL:Hide()
	end
end

local function Reskin_ScrollBar(self)
	B.StripTextures(self)

	local thumb = self.thumbTexture
	if thumb then
		thumb:SetAlpha(0)
		thumb:SetWidth(18)
		self.thumb = thumb

		self.bgTex = B.CreateBGFrame(thumb, 0, -3, 0, 3)

		B.SetupHook(self)
	end
end

local function Reskin_Rewards(button)
	for index = 1, 4 do
		local reward = button.Rewards["Reward"..index]
		if reward then
			if not reward.styled then
				local icbg = B.ReskinIcon(reward.Icon)
				B.ReskinBorder(reward.IconBorder, icbg)

				reward.styled = true
			end

			reward:ClearAllPoints()
			if index == 1 then
				reward:SetPoint("RIGHT", button, "RIGHT", -5, 0)
			else
				reward:SetPoint("RIGHT", button.Rewards["Reward"..(index-1)].icbg, "LEFT", -2, 0)
			end
		end
	end
end

local function Reskin_Category(category)
	B.StripTextures(category)
	B.ReskinButton(category)

	for _, setting in pairs(category.settings) do
		if setting.DropDown then
			B.ReskinDropDown(setting.DropDown)
		end

		if setting.Slider then
			B.ReskinSlider(setting.Slider)
		end

		if setting.TextBox then
			B.ReskinInput(setting.TextBox)
		end

		if setting.Button then
			B.ReskinButton(setting.Button)
		end

		if setting.CheckBox then
			B.ReskinCheck(setting.CheckBox)
		end

		if setting.ResetButton then
			B.ReskinButton(setting.ResetButton)
		end

		if setting.Picker then
			B.ReskinButton(setting.Picker)
			setting.Picker.Color:SetInside(setting.Picker.bgTex, 0, 0)
		end
	end
end

function Skins:WorldQuestTab()
	if not IsAddOnLoaded("WorldQuestTab") then return end

	B.StripTextures(WQT_OverlayFrame)
	B.StripTextures(WQT_OverlayFrame.DetailFrame)
	B.StripTextures(WQT_QuestLogFiller)
	B.StripTextures(WQT_QuestScrollFrame.DetailFrame)
	B.StripTextures(WQT_SettingsFrame)
	B.StripTextures(WQT_VersionFrame)
	B.StripTextures(WQT_WorldQuestFrame, 0)

	Reskin_ScrollBar(WQT_SettingsFrame.ScrollFrame.ScrollBar)
	Reskin_ScrollBar(WQT_VersionFrame.scrollBar)

	B.ReskinButton(WQT_WorldQuestFrameSettingsButton)
	B.ReskinClose(WQT_OverlayFrame.CloseButton)
	B.ReskinDropDown(WQT_WorldQuestFrameSortButton)
	B.ReskinFilter(WQT_WorldQuestFrameFilterButton)
	B.ReskinScroll(WQT_QuestScrollFrameScrollBar)

	Reskin_Rewards(WQT_SettingsQuestListPreview.Preview)

	for _, tab in pairs {WQT_TabNormal, WQT_TabWorld} do
		B.StripTextures(tab, 2)
		B.ReskinButton(tab)

		local icon = tab.Icon
		icon:ClearAllPoints()
		icon:SetPoint("CENTER")

		B.ReskinHLTex(tab.Hider, tab.bgTex)

		tab.HL = tab:CreateTexture(nil, "ARTWORK")
		tab.HL:SetTexture(DB.bgTex)
		tab.HL:SetVertexColor(cr, cg, cb, .25)
		tab.HL:SetInside(tab.bgTex)
		tab.HL:Hide()
	end

	hooksecurefunc(WQT_WorldQuestFrame, "SelectTab", Update_SelectTab)

	for _, button in pairs(WQT_QuestScrollFrame.buttons) do
		Reskin_Rewards(button)

		local Faction = button.Faction
		Faction.Ring:Hide()

		local Title = button.Title
		Title:ClearAllPoints()
		Title:SetPoint("BOTTOMLEFT", Faction, "RIGHT", 0, 0)

		local Time = button.Time
		Time:ClearAllPoints()
		Time:SetPoint("TOPLEFT", Faction, "RIGHT", 5, 0)

		local Highlight = button.Highlight
		B.StripTextures(Highlight)
		Highlight.HL = Highlight:CreateTexture(nil, "ARTWORK")
		Highlight.HL:SetTexture(DB.bgTex)
		Highlight.HL:SetVertexColor(cr, cg, cb, .25)
		Highlight.HL:SetInside()
	end

	local ADDT = LibStub("AddonDropDownTemplates-2.0", true)
	if ADDT then
		local orgiGetFrame = ADDT.GetFrame
		ADDT.GetFrame = function(...)
			local frame = orgiGetFrame(...)
			B.StripTextures(frame)
			TT.ReskinTooltip(frame)

			return frame
		end
	end

	local function Reskin_Settings(event)
		for _, category in pairs(WQT_SettingsFrame.categories) do
			Reskin_Category(category)

			local numSubs = #category.subCategories
			if numSubs > 0 then
				for i = 1, numSubs do
					Reskin_Category(category.subCategories[i])
				end
			end
		end

		B:UnregisterEvent(event, Reskin_Settings)
	end
	B:RegisterEvent("PLAYER_ENTERING_WORLD", Reskin_Settings)
end