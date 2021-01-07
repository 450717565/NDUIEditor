local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_TalkingHeadFrame()
	B.StripTextures(TalkingHeadFrame.PortraitFrame)
	B.StripTextures(TalkingHeadFrame.BackgroundFrame)

	B.ReskinText(TalkingHeadFrame.NameFrame.Name, 1, .8, 0)
	B.ReskinText(TalkingHeadFrame.TextFrame.Text, 1, 1, 1)

	local MainFrame = TalkingHeadFrame.MainFrame
	B.StripTextures(MainFrame.Model)

	if not MainFrame.styled then
		B.CreateBDFrame(MainFrame.Model)

		MainFrame.styled = true
	end
end

C.LUAThemes["Blizzard_TalkingHeadUI"] = function()
	TalkingHeadFrame:SetScale(UIParent:GetScale())

	B.ReskinFrame(TalkingHeadFrame.MainFrame)

	hooksecurefunc("TalkingHeadFrame_PlayCurrent", Reskin_TalkingHeadFrame)
end