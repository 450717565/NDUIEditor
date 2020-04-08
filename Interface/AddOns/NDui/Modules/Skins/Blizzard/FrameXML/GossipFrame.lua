local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	local gsub = string.gsub

	NORMAL_QUEST_DISPLAY = gsub(NORMAL_QUEST_DISPLAY, "000000", "ffffff")
	TRIVIAL_QUEST_DISPLAY = gsub(TRIVIAL_QUEST_DISPLAY, "000000", "ffffff")
	IGNORED_QUEST_DISPLAY = gsub(IGNORED_QUEST_DISPLAY, "000000", "ffffff")

	B.ReskinFrame(GossipFrame)
	B.ReskinButton(GossipFrameGreetingGoodbyeButton)
	B.ReskinScroll(GossipGreetingScrollFrameScrollBar)
	B.ReskinStatusBar(NPCFriendshipStatusBar, true)

	GossipGreetingText:SetTextColor(1, .8, 0)

	local icon = NPCFriendshipStatusBar.icon
	icon:ClearAllPoints()
	icon:SetPoint("RIGHT", NPCFriendshipStatusBar, "LEFT", 0, -2)

	for i = 1, NUMGOSSIPBUTTONS do
		local button = _G["GossipTitleButton"..i]
		if button then
			B.ReskinHighlight(button, button, true)
			local hl = button:GetHighlightTexture()
			hl:SetOutside()

			if button:GetText() ~= nil then
				button:SetText(gsub(button:GetText(), ":32:32:0:0", ":32:32:0:0:64:64:5:59:5:59"))
			end
		end
	end
end)