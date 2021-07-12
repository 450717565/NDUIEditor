local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local SKIN = B:GetModule("Skins")

function SKIN:HandyNotes()
	if not IsAddOnLoaded("HandyNotes") then return end

	B.ReskinFrame(HNEditFrame)
	B.ReskinButton(HNEditFrame.okbutton)
	B.ReskinButton(HNEditFrame.cancelbutton)
	B.ReskinCheck(HNEditFrame.continentcheckbox)
	B.ReskinInput(HNEditFrame.titleinputframe)

	B.StripTextures(HNEditFrame.descframe)
	B.CreateBDFrame(HNEditFrame.descframe)

	B.ReskinDropDown(HandyNotes_IconDropDown)
	B.ReskinScroll(HandyNotes_EditScrollFrameScrollBar)

	if IsAddOnLoaded("HandyNotes_Shadowlands") then
		B.ReskinSlider(HandyNotes_ShadowlandsAlphaMenuSliderOption.Slider)
		B.ReskinSlider(HandyNotes_ShadowlandsScaleMenuSliderOption.Slider)
	end
end

C.OnLoginThemes["HandyNotes"] = SKIN.HandyNotes