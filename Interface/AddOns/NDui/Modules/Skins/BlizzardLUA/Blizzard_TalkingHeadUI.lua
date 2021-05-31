local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_TalkingHeadFrame()
	local frame = TalkingHeadFrame

	B.StripTextures(frame.PortraitFrame)
	B.StripTextures(frame.BackgroundFrame)

	B.ReskinText(frame.NameFrame.Name, 1, .8, 0)
	B.ReskinText(frame.TextFrame.Text, 1, 1, 1)

	local MainFrame = frame.MainFrame
	B.StripTextures(MainFrame.Model)

	if not MainFrame.styled then
		B.ReskinFrame(MainFrame)
		B.CreateBDFrame(MainFrame.Model, 0, -C.mult)

		MainFrame.styled = true
	end
end

C.LUAThemes["Blizzard_TalkingHeadUI"] = function()
	TalkingHeadFrame:SetScale(UIParent:GetScale())

	hooksecurefunc("TalkingHeadFrame_PlayCurrent", Reskin_TalkingHeadFrame)
end