local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")
local TT = B:GetModule("Tooltip")

----------------------------
-- Credit: AddOnSkins_MeetingStone by hokohuang
-- 修改：雨夜独行客
----------------------------

local function strToPath(str)
	local path = {}
	for v in string.gmatch(str, "([^\.]+)") do
		table.insert(path, v)
	end
	return path
end

local function getValue(pathStr, tbl)
	local keys = strToPath(pathStr)
	local value
	for _, key in pairs(keys) do
		value = value and value[key] or tbl[key]
	end
	return value
end

local function StripMS_Textures(self)
	if self.NineSlice then self.NineSlice:Hide() end

	if self.GetNumRegions then
		for i = 1, self:GetNumRegions() do
			local region = select(i, self:GetRegions())
			if region and region.IsObjectType and region:IsObjectType("Texture") then
				region:SetAlpha(0)
				region:Hide()
			end
		end
	end
end

local function ReskinMS_Button(self)
	for i = 1, self:GetNumChildren() do
		local child = select(i, self:GetChildren())
		if child:IsObjectType("Button") and child.Icon and child.Text then
			B.StripTextures(child, 11)
			B.ReskinIcon(child.Icon)

			child.HL = child:CreateTexture(nil, "HIGHLIGHT")
			child.HL:SetColorTexture(1, 1, 1, .25)
			child.HL:SetAllPoints(child.Icon)
		end
	end
end

local function ReskinMS_PageButton(self)
	local left = self.ScrollUpButton
	local right = self.ScrollDownButton

	B.ReskinArrow(left, "left", 20)
	B.ReskinArrow(right, "right", 20)
	right:SetPoint("LEFT", left, "RIGHT", 10, 0)
end

local function ReskinMS_ALFrame()
	if ALFrame and not ALFrame.styled then
		B.ReskinFrame(ALFrame)
		B.ReskinButton(ALFrameButton)

		ALFrame.styled = true
	end
end

local function Reskin_AutoCompleteFrame(self)
	for i = 1, #self.buttons do
		local button = self:GetButton(i)
		if not button.styled and button:IsShown() then
			B.StripTextures(button)
			B.ReskinButton(button)

			button.styled = true
		end
	end
end

local function Reskin_DropMenu(self, level, ...)
	level = level or 1
	local menu = self.menuList[level]
	if menu and not menu.styled then
		TT.ReskinTooltip(menu)

		local scrollBar = menu.GetScrollBar and menu:GetScrollBar()
		if scrollBar then B.ReskinScroll(scrollBar) end
	end
end

local function Reskin_DropMenuItem(self)
	self.Arrow:SetTexture(DB.arrowTex.."right")
	self.Arrow:SetSize(14, 14)
end

local function Reskin_TabView(self)
	for i = 1, self:GetItemCount() do
		local tab = self:GetButton(i)
		if not tab.styled then
			B.ReskinTab(tab)
			B.ReskinHighlight(tab.Flash, tab)

			if tab.icon then B.ReskinIcon(tab.icon) end

			tab.styled = true
		end

		if i > 1 then
			tab:ClearAllPoints()
			tab:SetPoint("LEFT", self:GetButton(i-1), "RIGHT", -(15+C.mult), 0)
		end
	end
end

local function Reskin_ListView(self)
	for i = 1, #self.buttons do
		local button = self:GetButton(i)
		if not button.styled and button:IsShown() then
			B.StripTextures(button)
			B.ReskinButton(button)
			B.ReskinHighlight(button:GetCheckedTexture(), button, true, true)

			if button.Option then
				B.ReskinButton(button.Option.InviteButton)
				B.ReskinDecline(button.Option.DeclineButton)
			end

			if button.Summary then
				B.ReskinDecline(button.Summary.CancelButton)
			end

			button.styled = true
		end
	end
end

function Skins:MeetingStone()
	if not IsAddOnLoaded("MeetingStone") and not IsAddOnLoaded("MeetingStonePlus") then return end

	local MS = LibStub("AceAddon-3.0"):GetAddon("MeetingStone")
	local MSEnv = LibStub("NetEaseEnv-1.0")._NSList[MS.baseName]
	local GUI = LibStub("NetEaseGUI-2.0")

	if not MS or not MSEnv or not GUI then return end

	-- Panel
	local Panels = {
		"BrowsePanel.AdvFilterPanel",
		"MainPanel",
	}
	for _, v in pairs(Panels) do
		local frame = getValue(v, MSEnv)
		if frame then
			StripMS_Textures(frame)

			if frame.Inset then StripMS_Textures(frame.Inset) end
			if frame.Inset2 then StripMS_Textures(frame.Inset2) end
			if frame.PortraitFrame then frame.PortraitFrame:SetAlpha(0) end
			if frame.CloseButton then B.ReskinClose(frame.CloseButton) end

			B.CreateBG(frame)
		end
	end

	-- AdvFilterPanel
	local BrowsePanel = MSEnv.BrowsePanel
	for i, box in pairs(BrowsePanel.filters) do
		B.ReskinCheck(box.Check)
		B.ReskinInput(box.MaxBox)
		B.ReskinInput(box.MinBox)

		box.styled = true
	end

	local AdvFilterPanel = BrowsePanel.AdvFilterPanel
	AdvFilterPanel:SetPoint("TOPLEFT", MSEnv.MainPanel, "TOPRIGHT", 3, -30)
	for i = 1, AdvFilterPanel:GetNumChildren() do
		local child = select(i, AdvFilterPanel:GetChildren())
		if child:IsObjectType("Button") and not child:GetText() then
			B.ReskinClose(child)

			break
		end
	end

	local AutoCompleteFrame = BrowsePanel.AutoCompleteFrame
	B.StripTextures(AutoCompleteFrame)
	B.ReskinScroll(AutoCompleteFrame:GetScrollBar())

	hooksecurefunc(AutoCompleteFrame, "UpdateItems", Reskin_AutoCompleteFrame)

	-- CreatePanel
	local CreatePanel = MSEnv.CreatePanel
	select(1, CreatePanel:GetChildren()):Hide()
	B.StripTextures(CreatePanel)
	B.ReskinCheck(CreatePanel.PrivateGroup)
	B.CreateBDFrame(CreatePanel.MemberWidget)
	B.CreateBDFrame(CreatePanel.MiscWidget)

	local InfoWidget = CreatePanel.InfoWidget
	B.StripTextures(InfoWidget)
	B.CreateBGFrame(InfoWidget, 1, 1, -1, -1)

	local CreateWidget = CreatePanel.CreateWidget
	for i = 1, CreateWidget:GetNumChildren() do
		local child = select(i, CreateWidget:GetChildren())
		B.StripTextures(child)
		B.CreateBDFrame(child)
	end

	-- Button
	local Buttons = {
		"BrowsePanel.NoResultBlocker.Button",
		"BrowsePanel.RefreshFilterButton",
		"BrowsePanel.ResetFilterButton",
		"BrowsePanel.SignUpButton",
		"CreatePanel.CreateButton",
		"CreatePanel.DisbandButton",
		"MallPanel.PurchaseButton",
		"RecentPanel.BatchDeleteButton",
	}
	for _, v in pairs(Buttons) do
		local button = getValue(v, MSEnv)
		if button then
			B.ReskinButton(button)
		end
	end

	local StretchButtons = {
		"BrowsePanel.AdvButton",
		"BrowsePanel.RefreshButton",
		"ManagerPanel.RefreshButton",
	}
	for _, v in pairs(StretchButtons) do
		local button = getValue(v, MSEnv)
		if button then
			button:SetHeight(26)
			B.ReskinButton(button)
		end
	end

	-- Dropdown
	local Dropdowns = {
		"BrowsePanel.ActivityDropdown",
		"CreatePanel.ActivityType",
		"RecentPanel.ActivityDropdown",
		"RecentPanel.ClassDropdown",
		"RecentPanel.RoleDropdown",
	}
	for _, v in pairs(Dropdowns) do
		local dropdown = getValue(v, MSEnv)
		if dropdown then
			dropdown.Button = dropdown.MenuButton
			B.ReskinDropDown(dropdown)
		end
	end

	-- DropMenu
	local DropMenu = GUI:GetClass("DropMenu")
	hooksecurefunc(DropMenu, "Open", Reskin_DropMenu)

	local DropMenuItem = GUI:GetClass("DropMenuItem")
	hooksecurefunc(DropMenuItem, "SetHasArrow", Reskin_DropMenuItem)

	-- Tab
	local TabView = GUI:GetClass("TabView")
	hooksecurefunc(TabView, "UpdateItems", Reskin_TabView)

	-- GridView
	local GridViews = {
		"ApplicantPanel.ApplicantList",
		"BrowsePanel.ActivityList",
		"RecentPanel.MemberList",
	}
	for _, v in pairs(GridViews) do
		local grid = getValue(v, MSEnv)
		if grid and not grid.styled then
			for index, button in pairs(grid.sortButtons) do
				B.StripTextures(button, 0)
				B.ReskinButton(button)
				button.Arrow:SetAlpha(1)

				local width = button:GetWidth()-2
				button:SetWidth(width)

				if index > 1 then
					local p1, p2, p3 = button:GetPoint()
					button:ClearAllPoints()
					button:SetPoint(p1, p2, p3, 1, 0)
				end
			end
			B.ReskinScroll(grid:GetScrollBar())

			grid.styled = true
		end
	end

	local ListView = GUI:GetClass("ListView")
	hooksecurefunc(ListView, "UpdateItems", Reskin_ListView)

	-- EditBox
	local EditBoxes = {
		"CreatePanel.HonorLevel",
		"CreatePanel.ItemLevel",
		"RecentPanel.SearchInput",
	}
	for _, v in pairs(EditBoxes) do
		local input = getValue(v, MSEnv)
		if input then
			B.ReskinInput(input)
		end
	end

	-- Tooltip
	local Tooltip = GUI:GetClass("Tooltip")
	TT.ReskinTooltip(Tooltip:GetGlobalTooltip())
	TT.ReskinTooltip(MSEnv.MainPanel.GameTooltip)

	-- DataBroker
	local DataBroker = MSEnv.DataBroker
	B.ReskinButton(DataBroker.BrokerPanel)
	DataBroker.BrokerIcon:SetPoint("LEFT", 8, 0)

	-- Misc
	if MSEnv.ADDON_REGIONSUPPORT then
		local MallPanel = MS:GetModule("MallPanel")
		B.StripTextures(MallPanel.CategoryList:GetParent())
		B.ReskinButton(MallPanel.PurchaseButton)
		ReskinMS_Button(MallPanel)

		local RewardPanel = MS:GetModule("RewardPanel")
		B.ReskinButton(RewardPanel.ConfirmButton)
		B.ReskinInput(RewardPanel.InputBox)

		B.StripTextures(MSEnv.ActivitiesParent)
		ReskinMS_Button(MSEnv.ActivitiesParent)
		B.ReskinScroll(MSEnv.ActivitiesSummary.Summary.ScrollBar)

		local WalkthroughPanel = MS:GetModule("WalkthroughPanel", true)
		if WalkthroughPanel then
			B.ReskinScroll(WalkthroughPanel.SummaryHtml.ScrollBar)
		end
	end

	-- App
	B.StripTextures(MSEnv.AppParent)
	ReskinMS_PageButton(MSEnv.AppFollowQueryPanel.QueryList.ScrollBar)
	ReskinMS_PageButton(MSEnv.AppFollowPanel.FollowList.ScrollBar)

	if not MeetingStone_QuickJoin then return end  -- version check

	B.ReskinCheck(MeetingStone_QuickJoin)

	for i = 1, AdvFilterPanel.Inset:GetNumChildren() do
		local child = select(i, AdvFilterPanel.Inset:GetChildren())
		if child.Check and not child.styled then
			B.ReskinCheck(child.Check)
		end
	end

	local ManagerPanel = MSEnv.ManagerPanel
	for i = 1, ManagerPanel:GetNumChildren() do
		local child = select(i, ManagerPanel:GetChildren())
		if child:IsObjectType("Button") and child.Icon and child.Text and not child.styled then
			child:SetHeight(26)
			B.ReskinButton(child)

			child:HookScript("PostClick", ReskinMS_ALFrame)
		end
	end

	local ApplicantListBlocker = ManagerPanel.ApplicantListBlocker
	B.StripTextures(ApplicantListBlocker)
	B.CreateBDFrame(ApplicantListBlocker, 0, 2)
end