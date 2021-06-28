local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_PVPReadyDialog(self, _, _, _, _, _, role)
	if self.roleIcon:IsShown() then
		self.roleIcon.texture:SetTexCoord(B.GetRoleTexCoord(role))
	end
end

C.OnLoginThemes["PVPReadyDialog"] = function()
	B.ReskinFrame(PVPReadyDialog)
	B.ReskinButton(PVPReadyDialog.enterButton)
	B.ReskinButton(PVPReadyDialog.leaveButton)
	B.ReskinRoleIcon(PVPReadyDialogRoleIconTexture)

	hooksecurefunc("PVPReadyDialog_Display", Reskin_PVPReadyDialog)
end

C.OnLoginThemes["PVPMatchScoreboard"] = function()
	B.ReskinFrame(PVPMatchScoreboard)
	PVPMatchScoreboard:HookScript("OnShow", B.StripTextures)

	local Content = PVPMatchScoreboard.Content
	B.StripTextures(Content)

	local ScrollFrame = Content.ScrollFrame
	B.ReskinScroll(ScrollFrame.ScrollBar)

	local TabContainer = Content.TabContainer
	B.StripTextures(TabContainer)
	for i = 1, 3 do
		B.ReskinTab(TabContainer.TabGroup["Tab"..i])
	end

	local bg = B.CreateBDFrame(Content)
	bg:SetPoint("BOTTOMRIGHT", TabContainer.InsetBorderTop, 4, -1)
end

C.OnLoginThemes["PVPMatchResults"] = function()
	B.ReskinFrame(PVPMatchResults)
	PVPMatchResults:HookScript("OnShow", B.StripTextures)
	B.StripTextures(PVPMatchResults.overlay)

	local buttonContainer = PVPMatchResults.buttonContainer
	B.ReskinButton(buttonContainer.leaveButton)
	B.ReskinButton(buttonContainer.requeueButton)

	local content = PVPMatchResults.content
	B.StripTextures(content)
	B.StripTextures(content.earningsArt)

	local scrollFrame = content.scrollFrame
	B.ReskinScroll(scrollFrame.scrollBar)

	local tabContainer = content.tabContainer
	B.StripTextures(tabContainer)
	for i = 1, 3 do
		B.ReskinTab(tabContainer.tabGroup["tab"..i])
	end

	local bg = B.CreateBDFrame(content)
	bg:SetPoint("BOTTOMRIGHT", tabContainer.InsetBorderTop, 4, -1)
end