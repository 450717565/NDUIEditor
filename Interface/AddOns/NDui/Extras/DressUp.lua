local _, ns = ...
local B, C, L, DB = unpack(ns)
local Extras = B:GetModule("Extras")

function Extras.DU_CreateButton(name, frame, label, width, height, point, relativeTo, relativePoint, xOffset, yOffset)
	local button = CreateFrame("Button", name, frame, "UIPanelButtonTemplate")
	button:SetSize(width, height)
	button:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)
	button:SetText(label)

	B.ReskinButton(button)

	relativeTo:HookScript("OnShow", function()
		button:Show()
	end)

	relativeTo:HookScript("OnHide", function()
		button:Hide()
	end)

	return button
end

function Extras.DOneNake_OnClick()
	local ModelScene = DressUpFrame.ModelScene:GetPlayerActor()
	ModelScene:UndressSlot(4)
	for i = 16, 19 do
		ModelScene:UndressSlot(i)
	end
end

function Extras.DAllNake_OnClick()
	local ModelScene = DressUpFrame.ModelScene:GetPlayerActor()
	for i = 1, 19 do
		ModelScene:UndressSlot(i)
	end
end

function Extras.SOneNake_OnClick()
	local SideModelScene = SideDressUpFrame.ModelScene:GetPlayerActor()
	SideModelScene:UndressSlot(4)
	for i = 16, 19 do
		SideModelScene:UndressSlot(i)
	end
end

function Extras.SAllNake_OnClick()
	local SideModelScene = SideDressUpFrame.ModelScene:GetPlayerActor()
	for i = 1, 19 do
		SideModelScene:UndressSlot(i)
	end
end

function Extras:DressUp()
	--普通试衣间
	local DOneNake = self.DU_CreateButton("DressUpOneNake", DressUpFrame, L["One Nake"], 75, 22, "RIGHT", DressUpFrameResetButton, "LEFT", -2, 0)
	DOneNake:SetScript("OnClick", Extras.DOneNake_OnClick)

	local DAllNake = self.DU_CreateButton("DressUpAllNake", DressUpFrame, L["All Nake"], 75, 22, "RIGHT", DOneNake, "LEFT", -2, 0)
	DAllNake:SetScript("OnClick", Extras.DAllNake_OnClick)

	-- 侧边试衣间
	local ResetButton = SideDressUpFrame.ResetButton
	local ResetStrata = ResetButton:GetFrameStrata()
	local ResetLevel = ResetButton:GetFrameLevel()

	local SOneNake = self.DU_CreateButton("SideDressUpOneNake", SideDressUpFrame, L["One Nake"], 80, 22, "BOTTOM", ResetButton, "TOPLEFT", -1, 2)
	SOneNake:SetFrameStrata(ResetStrata)
	SOneNake:SetFrameLevel(ResetLevel)
	SOneNake:SetScript("OnClick", Extras.SOneNake_OnClick)

	local SAllNake = self.DU_CreateButton("SideDressUpOneNake", SideDressUpFrame, L["All Nake"], 80, 22, "BOTTOM", ResetButton, "TOPRIGHT", 1, 2)
	SAllNake:SetFrameStrata(ResetStrata)
	SAllNake:SetFrameLevel(ResetLevel)
	SAllNake:SetScript("OnClick", Extras.SAllNake_OnClick)
end