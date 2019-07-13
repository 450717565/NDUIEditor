local F, C = unpack(select(2, ...))

C.themes["Classic Quest Log"] = function()
	F.ReskinFrame(ClassicQuestLog)

	local resizeGrip = ClassicQuestLog.resizeGrip
	F.StripTextures(resizeGrip, true)
	F.ReskinButton(resizeGrip)

	local count = ClassicQuestLog.count
	F.StripTextures(count)
	count:ClearAllPoints()
	count:SetPoint("TOP", ClassicQuestLog.title, "BOTTOM", 0, -5)

	local buttons = {"abandon", "push", "track", "options", "close"}
	for _, button in pairs(buttons) do
		F.ReskinButton(ClassicQuestLog[button])
	end

	local optionsFrame = ClassicQuestLog.optionsFrame
	F.ReskinFrame(optionsFrame)

	local checks = {"UndockWindow", "LockWindow", "ShowResizeGrip", "ShowLevels", "ShowTooltips", "SolidBackground", "UseClassicSkin"}
	for _, check in pairs(checks) do
		F.ReskinCheck(optionsFrame[check])
	end

	ClassicQuestLogDetailScrollFrame.DetailBG:Hide()
	F.ReskinScroll(ClassicQuestLogDetailScrollFrameScrollBar)
	F.CreateBDFrame(ClassicQuestLogDetailScrollFrame, 0)

	ClassicQuestLogScrollFrame.BG:Hide()
	F.ReskinScroll(ClassicQuestLogScrollFrameScrollBar)
	F.CreateBDFrame(ClassicQuestLogScrollFrame, 0)

	local expandAll = ClassicQuestLogScrollFrame.expandAll
	F.StripTextures(expandAll)
	F.ReskinButton(expandAll)

	expandAll:SetSize(64, 24)
	expandAll:ClearAllPoints()
	expandAll:SetPoint("BOTTOM", ClassicQuestLogScrollFrame, "TOP", 0, 5)

	local icon = expandAll:GetNormalTexture()
	icon:ClearAllPoints()
	icon:SetPoint("LEFT", expandAll, "LEFT", 5, 0)

	local text = expandAll.normalText
	text:ClearAllPoints()
	text:SetPoint("LEFT", icon, "RIGHT", 2, 0)
end