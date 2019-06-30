local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	-- PVPMatchScoreboard
	F.ReskinFrame(PVPMatchScoreboard)
	PVPMatchScoreboard:HookScript("OnShow", F.StripTextures)

	local Content = PVPMatchScoreboard.Content
	F.StripTextures(Content)

	local ScrollFrame = Content.ScrollFrame
	F.StripTextures(ScrollFrame)
	F.ReskinScroll(ScrollFrame.ScrollBar)

	local TabContainer = Content.TabContainer
	F.StripTextures(TabContainer)
	for i = 1, 3 do
		F.ReskinTab(TabContainer.TabGroup["Tab"..i])
	end

	local bg = F.CreateBDFrame(Content, 0)
	bg:SetPoint("BOTTOMRIGHT", TabContainer.InsetBorderTop, 4, -1)

	-- PVPMatchResults
	F.ReskinFrame(PVPMatchResults)
	PVPMatchResults:HookScript("OnShow", F.StripTextures)
	F.StripTextures(PVPMatchResults.overlay)

	local buttonContainer = PVPMatchResults.buttonContainer
	F.ReskinButton(buttonContainer.leaveButton)
	F.ReskinButton(buttonContainer.requeueButton)

	local content = PVPMatchResults.content
	F.StripTextures(content)
	F.StripTextures(content.earningsArt)

	local scrollFrame = content.scrollFrame
	F.StripTextures(scrollFrame)
	F.ReskinScroll(scrollFrame.scrollBar)

	local tabContainer = content.tabContainer
	F.StripTextures(tabContainer)
	for i = 1, 3 do
		F.ReskinTab(tabContainer.tabGroup["tab"..i])
	end

	local bg = F.CreateBDFrame(content, 0)
	bg:SetPoint("BOTTOMRIGHT", tabContainer.InsetBorderTop, 4, -1)
end)