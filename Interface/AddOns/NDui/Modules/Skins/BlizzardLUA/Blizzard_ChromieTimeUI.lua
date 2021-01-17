local _, ns = ...
local B, C, L, DB = unpack(ns)

--/run LoadAddOn"Blizzard_ChromieTimeUI" ChromieTimeFrame:Show()
C.LUAThemes["Blizzard_ChromieTimeUI"] = function()
	local frame = ChromieTimeFrame

	B.ReskinFrame(frame)
	B.ReskinButton(frame.SelectButton)

	local title = frame.Title
	B.StripTextures(title)
	title.Text:SetFontObject(SystemFont_Huge1)
	B.ReskinText(title.Text, 1, .8, 0)

	local infoFrame = frame.CurrentlySelectedExpansionInfoFrame
	B.ReskinText(infoFrame.Name, 1, .8, 0)
	B.ReskinText(infoFrame.Description, 1, 1, 1)
	infoFrame.Background:Hide()
end