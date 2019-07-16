local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local cr, cg, cb = C.r, C.g, C.b

	F.ReskinFrame(GossipFrame)
	F.ReskinButton(GossipFrameGreetingGoodbyeButton)
	F.ReskinScroll(GossipGreetingScrollFrameScrollBar)
	F.ReskinStatusBar(NPCFriendshipStatusBar, true)

	GossipGreetingText:SetTextColor(1, .8, 0)

	for i = 1, NUMGOSSIPBUTTONS do
		local button = _G["GossipTitleButton"..i]
		if button then
			button:SetHighlightTexture(C.media.bdTex)
			local hl = button:GetHighlightTexture()
			hl:SetColorTexture(cr, cg, cb, .25)
			hl:SetPoint("TOPLEFT", -C.mult, C.mult)
			hl:SetPoint("BOTTOMRIGHT", C.mult, -C.mult)

			if button:GetText() ~= nil then
				button:SetText(gsub(button:GetText(), ":32:32:0:0", ":32:32:0:0:64:64:5:59:5:59"))
			end
		end
	end
end)