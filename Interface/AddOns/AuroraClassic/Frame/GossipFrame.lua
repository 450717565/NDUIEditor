local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(GossipFrame)
	F.ReskinButton(GossipFrameGreetingGoodbyeButton)
	F.ReskinScroll(GossipGreetingScrollFrameScrollBar)
	F.ReskinStatusBar(NPCFriendshipStatusBar, true)

	GossipGreetingText:SetTextColor(1, .8, 0)

	local icon = NPCFriendshipStatusBar.icon
	icon:ClearAllPoints()
	icon:SetPoint("RIGHT", NPCFriendshipStatusBar, "LEFT", 0, -2)

	for i = 1, NUMGOSSIPBUTTONS do
		local button = _G["GossipTitleButton"..i]
		if button then
			F.ReskinTexture(button, button, true, nil, -C.mult)

			if button:GetText() ~= nil then
				button:SetText(gsub(button:GetText(), ":32:32:0:0", ":32:32:0:0:64:64:5:59:5:59"))
			end
		end
	end
end)