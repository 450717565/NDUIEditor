local F, C = unpack(select(2, ...))

C.themes["Blizzard_TalkingHeadUI"] = function()
	local TalkingHeadFrame = TalkingHeadFrame
	TalkingHeadFrame:SetScale(.9)

	local PortraitFrame = TalkingHeadFrame.PortraitFrame
	F.StripTextures(PortraitFrame)
	PortraitFrame.Portrait:SetAtlas(nil)
	PortraitFrame.Portrait.SetAtlas = F.dummy

	local Model = TalkingHeadFrame.MainFrame.Model
	Model:SetPoint("TOPLEFT", 30, -27)
	Model:SetSize(100, 100)
	Model.PortraitBg:SetAtlas(nil)
	Model.PortraitBg.SetAtlas = F.dummy

	local Name = TalkingHeadFrame.NameFrame.Name
	Name:SetTextColor(1, .8, 0)
	Name.SetTextColor = F.dummy
	Name:SetShadowColor(0, 0, 0, 0)

	local Text = TalkingHeadFrame.TextFrame.Text
	Text:SetTextColor(1, 1, 1)
	Text.SetTextColor = F.dummy
	Text:SetShadowColor(0, 0, 0, 0)

	local CloseButton = TalkingHeadFrame.MainFrame.CloseButton
	F.ReskinClose(CloseButton)
	CloseButton:ClearAllPoints()
	CloseButton:SetPoint("TOPRIGHT", -25, -25)
end