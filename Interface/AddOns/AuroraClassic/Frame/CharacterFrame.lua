local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(CharacterFrame)
	F.SetupTabStyle(CharacterFrame, 3)

	F.StripTextures(CharacterModelFrame, true)
end)