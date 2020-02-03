local B, C, L, DB = unpack(select(2, ...))
local S = B:GetModule("Skins")

function S:ClassicQuestLog()
	if not NDuiDB["Skins"]["BlizzardSkins"] then return end
	if not IsAddOnLoaded("ClassicQuestLog") then return end

	B.ReskinFrame(ClassicQuestLog)

	local resizeGrip = ClassicQuestLog.resizeGrip
	B.StripTextures(resizeGrip)
	B.ReskinButton(resizeGrip)

	local count = ClassicQuestLog.count
	B.StripTextures(count)
	count:ClearAllPoints()
	count:SetPoint("TOP", ClassicQuestLog.title, "BOTTOM", 0, -5)

	local buttons = {"abandon", "push", "track", "options", "close"}
	for _, button in pairs(buttons) do
		B.ReskinButton(ClassicQuestLog[button])
	end

	local optionsFrame = ClassicQuestLog.optionsFrame
	B.ReskinFrame(optionsFrame)

	local checks = {"UndockWindow", "LockWindow", "ShowResizeGrip", "ShowLevels", "ShowTooltips", "SolidBackground", "UseClassicSkin"}
	for _, check in pairs(checks) do
		B.ReskinCheck(optionsFrame[check])
	end

	ClassicQuestLogDetailScrollFrame.DetailBG:Hide()
	B.ReskinScroll(ClassicQuestLogDetailScrollFrameScrollBar)
	B.CreateBDFrame(ClassicQuestLogDetailScrollFrame, 0)

	ClassicQuestLogScrollFrame.BG:Hide()
	B.ReskinScroll(ClassicQuestLogScrollFrameScrollBar)
	B.CreateBDFrame(ClassicQuestLogScrollFrame, 0)

	local expandAll = ClassicQuestLogScrollFrame.expandAll
	B.StripTextures(expandAll)
	B.ReskinButton(expandAll)

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