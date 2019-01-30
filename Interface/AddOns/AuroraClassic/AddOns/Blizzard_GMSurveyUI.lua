local F, C = unpack(select(2, ...))

C.themes["Blizzard_GMSurveyUI"] = function()
	F.StripTextures(GMSurveyFrame, true)
	F.StripTextures(GMSurveyCommentFrame, true)

	F.SetBDFrame(GMSurveyFrame, 0, 0, -32, 4)
	F.CreateBDFrame(GMSurveyCommentFrame, 0)

	for i = 1, 11 do
		F.CreateBDFrame(_G["GMSurveyQuestion"..i], 0)
		for j = 0, 5 do
			F.ReskinRadio(_G["GMSurveyQuestion"..i.."RadioButton"..j])
		end
	end

	F.ReskinButton(GMSurveySubmitButton)
	F.ReskinButton(GMSurveyCancelButton)
	F.ReskinClose(GMSurveyCloseButton, "TOPRIGHT", GMSurveyFrame, "TOPRIGHT", -36, -4)
	F.ReskinScroll(GMSurveyScrollFrameScrollBar)
end