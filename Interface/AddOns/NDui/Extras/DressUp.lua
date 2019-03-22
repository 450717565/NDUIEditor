local B, C, L, DB, F = unpack(select(2, ...))

local ResetStrata = SideDressUpModelResetButton:GetFrameStrata()
local ResetLevel = SideDressUpModelResetButton:GetFrameLevel()

--自定义按钮创建函数
local function CreateButton(name, frame, label, width, height, point, relativeTo, relativePoint, xOffset, yOffset)
	local name = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	name:SetSize(width, height)
	name:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)
	name:SetText(label)
	name:RegisterForClicks("AnyUp")
	name:SetHitRectInsets(0, 0, 0, 0)

	if F then F.ReskinButton(name) end

	return name
end

--普通试衣间
local DOneNake = CreateButton("DressUpOneNake", DressUpFrame, L["One Nake"], 75, 22, "RIGHT", DressUpFrameResetButton, "LEFT", -2, 0)
DOneNake:SetScript("OnClick", function()
	DressUpModel:UndressSlot(4)
	for i = 16, 19 do
		DressUpModel:UndressSlot(i)
	end
end)

local DAllNake = CreateButton("DressUpAllNake", DressUpFrame, L["All Nake"], 75, 22, "RIGHT", DOneNake, "LEFT", -2, 0)
DAllNake:SetScript("OnClick", function()
	for i = 1, 19 do
		DressUpModel:UndressSlot(i)
	end
end)

-- 侧边试衣间
local SOneNake = CreateButton("SideDressUpOneNake", SideDressUpFrame, L["One Nake"], 80, 22, "TOP", SideDressUpModelResetButton, "BOTTOMLEFT", -1, -2)
SOneNake:SetFrameStrata(ResetStrata)
SOneNake:SetFrameLevel(ResetLevel)
SOneNake:SetScript("OnClick", function()
	SideDressUpModel:UndressSlot(4)
	for i = 16, 19 do
		SideDressUpModel:UndressSlot(i)
	end
end)

local SAllNake = CreateButton("SideDressUpOneNake", SideDressUpFrame, L["All Nake"], 80, 22, "TOP", SideDressUpModelResetButton, "BOTTOMRIGHT", 1, -2)
SAllNake:SetFrameStrata(ResetStrata)
SAllNake:SetFrameLevel(ResetLevel)
SAllNake:SetScript("OnClick", function()
	for i = 1, 19 do
		SideDressUpModel:UndressSlot(i)
	end
end)