local B, C, L, DB = unpack(select(2, ...))
local S = B:GetModule("Skins")
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

local function stripTextures(self)
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

function S:MeetingStone()
	if not IsAddOnLoaded("MeetingStone") then return end

	local MSEnv = LibStub:GetLibrary("NetEaseEnv-1.0")._NSList.MeetingStone
	local GUI = LibStub("NetEaseGUI-2.0")

	if not MSEnv or not GUI then return end

	-- Panel
	local Panels = {"MainPanel", "ExchangePanel", "BrowsePanel.AdvFilterPanel"}
	for _, v in pairs(Panels) do
		local frame = getValue(v, MSEnv)
		if frame then
			stripTextures(frame)

			if frame.Inset then stripTextures(frame.Inset) end
			if frame.Inset2 then stripTextures(frame.Inset2) end
			if frame.PortraitFrame then frame.PortraitFrame:SetAlpha(0) end
			if frame.CloseButton then B.ReskinClose(frame.CloseButton) end

			B.CreateBG(frame)
		end
	end

	-- AdvFilterPanel
	local Browse = MSEnv.BrowsePanel
	for i, box in ipairs(Browse.filters) do
		B.ReskinCheck(box.Check)
		B.ReskinInput(box.MaxBox)
		B.ReskinInput(box.MinBox)

		box.styled = true
	end

	local AdvFilterPanel = Browse.AdvFilterPanel
	AdvFilterPanel:SetPoint("TOPLEFT", MSEnv.MainPanel, "TOPRIGHT", 3, -30)
	for i = 1, AdvFilterPanel:GetNumChildren() do
		local child = select(i, AdvFilterPanel:GetChildren())
		if child:IsObjectType("Button") and not child:GetText() then
			B.ReskinClose(child)

			break
		end
	end

	-- CreatePanel
	local CreatePanel = MSEnv.CreatePanel
	select(1, CreatePanel:GetChildren()):Hide()
	B.StripTextures(CreatePanel)
	B.ReskinCheck(CreatePanel.PrivateGroup)
	B.CreateBDFrame(CreatePanel.MemberWidget, 0)
	B.CreateBDFrame(CreatePanel.MiscWidget, 0)

	local InfoWidget = CreatePanel.InfoWidget
	B.StripTextures(InfoWidget)
	local infoBG = B.CreateBDFrame(InfoWidget, 0)
	infoBG:SetPoint("TOPLEFT", C.mult, C.mult)
	infoBG:SetPoint("BOTTOMRIGHT", -C.mult, -C.mult)

	local CreateWidget = CreatePanel.CreateWidget
	for i = 1, CreateWidget:GetNumChildren() do
		local child = select(i, CreateWidget:GetChildren())
		B.StripTextures(child)
		B.CreateBDFrame(child, 0)
	end

	-- Button
	local Buttons = {"BrowsePanel.SignUpButton", "CreatePanel.CreateButton", "CreatePanel.DisbandButton", "BrowsePanel.NoResultBlocker.Button", "RecentPanel.BatchDeleteButton", "BrowsePanel.RefreshFilterButton", "BrowsePanel.ResetFilterButton", "MallPanel.PurchaseButton"}
	for _, v in pairs(Buttons) do
		local button = getValue(v, MSEnv)
		if button then
			B.ReskinButton(button)
		end
	end

	local StretchButtons = {"BrowsePanel.AdvButton", "BrowsePanel.RefreshButton", "ManagerPanel.RefreshButton"}
	for _, v in pairs(StretchButtons) do
		local button = getValue(v, MSEnv)
		if button then
			button:SetHeight(26)
			B.ReskinButton(button)
		end
	end

	-- Dropdown
	local Dropdowns = {"BrowsePanel.ActivityDropdown", "CreatePanel.ActivityType", "RecentPanel.ActivityDropdown", "RecentPanel.ClassDropdown", "RecentPanel.RoleDropdown"}
	for _, v in pairs(Dropdowns) do
		local dropdown = getValue(v, MSEnv)
		if dropdown then
			dropdown.Button = dropdown.MenuButton
			B.ReskinDropDown(dropdown)
		end
	end

	-- DropMenu
	local DropMenu = GUI:GetClass("DropMenu")
	hooksecurefunc(DropMenu, "Constructor", TT.ReskinTooltip)
	hooksecurefunc(DropMenu, "Toggle", TT.ReskinTooltip)

	-- Tab
	local TabView = GUI:GetClass("TabView")
	hooksecurefunc(TabView, "UpdateItems", function(self)
		for i = 1, self:GetItemCount() do
			local tab = self:GetButton(i)
			if not tab.styled then
				B.ReskinTab(tab)

				tab.styled = true
			end

			if i > 1 then
				tab:ClearAllPoints()
				tab:Point("LEFT", self:GetButton(i-1), "RIGHT", -(15+C.mult), 0)
			end
		end
	end)

	-- GridView
	local GridViews = {"ApplicantPanel.ApplicantList", "BrowsePanel.ActivityList", "RecentPanel.MemberList"}
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
	hooksecurefunc(ListView, "UpdateItems", function(self)
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
	end)

	-- EditBox
	local EditBoxes = {"CreatePanel.HonorLevel", "CreatePanel.ItemLevel", "RecentPanel.SearchInput"}
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
	local DataBroker = MSEnv.DataBroker.BrokerPanel
	B.ReskinButton(DataBroker)

	if not MeetingStone_QuickJoin then return end  -- version check

	B.ReskinCheck(MeetingStone_QuickJoin)

	local AdvFilter = MSEnv.BrowsePanel.AdvFilterPanel
	for i = 1, AdvFilter.Inset:GetNumChildren() do
		local child = select(i, AdvFilter.Inset:GetChildren())
		if child.Check and not child.styled then
			B.ReskinCheck(child.Check)
		end
	end

	local function reskinALFrame()
		if ALFrame and not ALFrame.styled then
			B.ReskinFrame(ALFrame)
			B.ReskinButton(ALFrameButton)

			ALFrame.styled = true
		end
	end

	local ManagerPanel = MSEnv.ManagerPanel
	for i = 1, ManagerPanel:GetNumChildren() do
		local child = select(i, ManagerPanel:GetChildren())
		if child:IsObjectType("Button") and child.Icon and child.Text and not child.styled then
			child:SetHeight(26)
			B.ReskinButton(child)

			child:HookScript("PostClick", reskinALFrame)
		end
	end
end
