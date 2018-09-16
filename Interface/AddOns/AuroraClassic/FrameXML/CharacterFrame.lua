local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	CharacterFrameInsetRight:DisableDrawLayer("BACKGROUND")
	CharacterFrameInsetRight:DisableDrawLayer("BORDER")

	F.ReskinPortraitFrame(CharacterFrame, true)
	F.StripTextures(CharacterModelFrame, true)

	for i = 1, 3 do
		F.ReskinTab(_G["CharacterFrameTab"..i])
	end
end)