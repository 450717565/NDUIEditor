local F, C = unpack(select(2, ...))

C.themes["Blizzard_GMSurveyUI"] = function()
	F.StripTextures(GMSurveyFrame, true)
	F.StripTextures(GMSurveyCommentFrame, true)

	F.SetBD(GMSurveyFrame, 0, 0, -32, 4)
	F.CreateBDFrame(GMSurveyCommentFrame, .25)

	for i = 1, 11 do
		F.CreateBD(_G["GMSurveyQuestion"..i], .25)
		F.CreateSD(_G["GMSurveyQuestion"..i])
		for j = 0, 5 do
			F.ReskinRadio(_G["GMSurveyQuestion"..i.."RadioButton"..j])
		end
	end

	F.Reskin(GMSurveySubmitButton)
	F.Reskin(GMSurveyCancelButton)
	F.ReskinClose(GMSurveyCloseButton, "TOPRIGHT", GMSurveyFrame, "TOPRIGHT", -36, -4)
	F.ReskinScroll(GMSurveyScrollFrameScrollBar)
end