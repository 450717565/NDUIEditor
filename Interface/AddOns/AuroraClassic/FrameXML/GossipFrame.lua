local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	GossipGreetingScrollFrameTop:Hide()
	GossipGreetingScrollFrameBottom:Hide()
	GossipGreetingScrollFrameMiddle:Hide()
	select(19, GossipFrame:GetRegions()):Hide()
	GossipGreetingText:SetTextColor(1, 1, 1)

	for i = 1, 4 do
		_G["NPCFriendshipStatusBarNotch"..i]:SetColorTexture(0, 0, 0)
		_G["NPCFriendshipStatusBarNotch"..i]:SetSize(2, 16)
	end

	NPCFriendshipStatusBar.icon:SetPoint("TOPLEFT", -30, 7)
	NPCFriendshipStatusBar:GetRegions():Hide()
	select(7, NPCFriendshipStatusBar:GetRegions()):Hide()
	F.ReskinStatusBar(NPCFriendshipStatusBar, false, false)

	F.ReskinPortraitFrame(GossipFrame, true)
	F.Reskin(GossipFrameGreetingGoodbyeButton)
	F.ReskinScroll(GossipGreetingScrollFrameScrollBar)

	GossipFrame:HookScript("OnShow", function()
		C_Timer.After(.01, function()
			local index = 1
			local titleButton = _G["GossipTitleButton"..index]
			while titleButton do
				if titleButton:GetText() ~= nil then
					titleButton:SetText(string.gsub(titleButton:GetText(), ":32:32:0:0", ":32:32:0:0:64:64:5:59:5:59"))
				end
				index = index + 1
				titleButton = _G["GossipTitleButton"..index]
			end
		end)
	end)
end)