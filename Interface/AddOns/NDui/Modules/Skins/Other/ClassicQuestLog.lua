local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

function Skins:ClassicQuestLog()
	if not IsAddOnLoaded("Classic Quest Log") then return end

	B.ReskinFrame(ClassicQuestLog)

	local chrome = ClassicQuestLog.chrome
	local countFrame = chrome.countFrame
	B.StripTextures(countFrame)
	countFrame:ClearAllPoints()
	countFrame:SetPoint("TOP", ClassicQuestLogTitleText, "BOTTOM", 0, -5)

	local buttons = {"abandonButton", "pushButton", "trackButton", "optionsButton", "closeButton"}
	for _, button in pairs(buttons) do
		B.ReskinButton(chrome[button])
	end

	-- LogScrollFrame
	B.ReskinScroll(ClassicQuestLogScrollFrameScrollBar)
	B.CreateBGFrame(ClassicQuestLogScrollFrame, 0, 2, 0, -2)

	local expandAll = ClassicQuestLogScrollFrame.expandAll
	B.ReskinCollapse(expandAll)

	expandAll:ClearAllPoints()
	expandAll:SetPoint("BOTTOM", ClassicQuestLogScrollFrame, "TOP", 0, 5)

	local normalText = expandAll.normalText
	normalText:ClearAllPoints()
	normalText:SetPoint("LEFT", expandAll:GetNormalTexture(), "RIGHT", 2, 1)

	hooksecurefunc(ClassicQuestLogScrollFrame, "UpdateLog", function(self)
		for i = 1, #self.buttons do
			local button = self.buttons[i]
			if not button.styled then
				B.ReskinCollapse(button)

				button.styled = true
			end
		end
	end)

	-- DetailScrollFrame
	B.ReskinScroll(ClassicQuestLogDetailScrollFrameScrollBar)
	B.CreateBGFrame(ClassicQuestLogDetailScrollFrame, 0, 2, 0, -2)

	-- OptionsScrollFrame
	B.ReskinScroll(ClassicQuestLogOptionsScrollFrameScrollBar)
	B.CreateBGFrame(ClassicQuestLogOptionsScrollFrame, 0, 2, 0, -2)

	local content = ClassicQuestLogOptionsScrollFrame.content
	B.StripTextures(content)
	B.ReskinClose(content.close)

	local checks = {"LockWindow", "ShowResizeGrip", "ShowLevels", "ShowTooltips", "SolidBackground", "ShowFromObjectiveTracker"}
	for _, check in pairs(checks) do
		B.ReskinCheck(content[check].check)
	end
end