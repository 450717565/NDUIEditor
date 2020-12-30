local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_GossipFormat(button, textFormat, text)
	local newFormat, count = string.gsub(textFormat, "000000", "ffffff")
	if count > 0 then
		button:SetFormattedText(newFormat, text)
	end
end

local replacedGossipColor = {
	["000000"] = "ffffff",
	["414141"] = "7b8489", -- lighter color for some gossip options
}

local function Reskin_GossipText(button, text)
	if text and text ~= "" then
		local newText, count = string.gsub(text, ":32:32:0:0", ":32:32:0:0:64:64:5:59:5:59") -- replace icon texture
		if count > 0 then
			text = newText
			button:SetFormattedText("%s", text)
		end

		local colorStr, rawText = string.match(text, "|c[fF][fF](%x%x%x%x%x%x)(.-)|r")
		colorStr = replacedGossipColor[colorStr]
		if colorStr and rawText then
			button:SetFormattedText("|cff%s%s|r", colorStr, rawText)
		end
	end
end

local function Reskin_TitleButton(self)
	for button in self.titleButtonPool:EnumerateActive() do
		if not button.styled then
			B.ReskinHighlight(button, button, true)
			local hl = button:GetHighlightTexture()
			hl:SetOutside()

			Reskin_GossipText(button, button:GetText())

			if button.SetText then
				hooksecurefunc(button, "SetText", Reskin_GossipText)
			end
			if button.SetFormattedText then
				hooksecurefunc(button, "SetFormattedText", Reskin_GossipFormat)
			end

			button.styled = true
		end
	end
end

tinsert(C.XMLThemes, function()
	-- GossipFrame
	do
		B.ReskinFrame(GossipFrame)
		B.ReskinButton(GossipFrameGreetingGoodbyeButton)
		B.ReskinScroll(GossipGreetingScrollFrameScrollBar)
		B.ReskinStatusBar(NPCFriendshipStatusBar, true)
		B.ReskinText(GossipGreetingText, 1, .8, 0)
		B.ReskinText(QuestFont, 1, 1, 1)

		local icon = NPCFriendshipStatusBar.icon
		icon:ClearAllPoints()
		icon:SetPoint("RIGHT", NPCFriendshipStatusBar, "LEFT", 0, -2)

		hooksecurefunc("GossipFrameUpdate", function(self)
			Reskin_TitleButton(GossipFrame)
		end)

		QuestFrameGreetingPanel:HookScript("OnShow", function(self)
			Reskin_TitleButton(self)
		end)
	end

	-- ItemTextFrame
	do
		B.ReskinFrame(ItemTextFrame)
		B.ReskinScroll(ItemTextScrollFrameScrollBar)
		B.ReskinArrow(ItemTextPrevPageButton, "left")
		B.ReskinArrow(ItemTextNextPageButton, "right")
	end
end)