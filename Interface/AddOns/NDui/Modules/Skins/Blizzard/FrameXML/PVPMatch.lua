local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	-- PVPMatchScoreboard
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

	local bg = B.CreateBDFrame(Content, 0)
	bg:SetPoint("BOTTOMRIGHT", TabContainer.InsetBorderTop, 4, -1)

	-- PVPMatchResults
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

	local bg = B.CreateBDFrame(content, 0)
	bg:SetPoint("BOTTOMRIGHT", tabContainer.InsetBorderTop, 4, -1)
end)