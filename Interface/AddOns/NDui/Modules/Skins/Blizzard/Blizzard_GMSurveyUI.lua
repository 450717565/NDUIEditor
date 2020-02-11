local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_GMSurveyUI"] = function()
	B.StripTextures(GMSurveyFrame)
	B.SetBDFrame(GMSurveyFrame, 0, 0, -32, 4)

	B.StripTextures(GMSurveyCommentFrame)
	B.CreateBDFrame(GMSurveyCommentFrame, 0)

	B.ReskinClose(GMSurveyCloseButton, "TOPRIGHT", GMSurveyFrame, "TOPRIGHT", -36, -4)
	B.ReskinButton(GMSurveySubmitButton)
	B.ReskinButton(GMSurveyCancelButton)
	B.ReskinScroll(GMSurveyScrollFrameScrollBar)

	for i = 1, 11 do
		local frame = "GMSurveyQuestion"..i

		B.CreateBDFrame(_G[frame], 0)
		for j = 0, 5 do
			B.ReskinRadio(_G[frame.."RadioButton"..j])
		end
	end
end