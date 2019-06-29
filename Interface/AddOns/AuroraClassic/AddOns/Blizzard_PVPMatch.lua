local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(PVPMatchScoreboard)

	local Content = PVPMatchScoreboard.Content
	F.StripTextures(Content)
	F.ReskinScroll(Content.ScrollFrame.ScrollBar)
	F.StripTextures(Content.TabContainer)
	for i = 1, 3 do
		F.ReskinTab(Content.TabContainer.TabGroup["Tab"..i])
	end

	F.ReskinFrame(PVPMatchResults)
	F.ReskinButton(PVPMatchResults.buttonContainer.leaveButton)
	F.ReskinButton(PVPMatchResults.buttonContainer.requeueButton)

	local content = PVPMatchResults.content
	F.StripTextures(content)
	F.StripTextures(content.earningsArt)
	F.ReskinScroll(content.scrollFrame.scrollBar)
	F.StripTextures(content.tabContainer)
	for i = 1, 3 do
		F.ReskinTab(content.tabContainer.tabGroup["tab"..i])
	end
end)