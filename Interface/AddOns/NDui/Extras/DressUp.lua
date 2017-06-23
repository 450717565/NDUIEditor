local BtnStrata = SideDressUpModelResetButton:GetFrameStrata()
local BtnLevel = SideDressUpModelResetButton:GetFrameLevel()

--自定义按钮创建函数
function CreateButton(name, frame, label, point, relativeTo, relativePoint, xOffset, yOffset, width, height)
	local name = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	name:SetWidth(width)
	name:SetHeight(height)
	name:SetAlpha(1.0)
	name:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)
	name:SetText(label)
	name:RegisterForClicks("AnyUp")
	name:SetHitRectInsets(0, 0, 0, 0)
	-- Aurora Reskin
	if IsAddOnLoaded("Aurora") then
		local F = unpack(Aurora)
		F.Reskin(name)
	end
	return name
end

--普通试衣间
local TabBtn = CreateButton("DressUpTabBtn", DressUpFrame, "单脱", "BOTTOMLEFT", DressUpFrame, "BOTTOMLEFT", 15, 79, 80, 22)
TabBtn:SetScript("OnClick", function()
	DressUpModel:UndressSlot(4)
	for i = 16, 19 do
		DressUpModel:UndressSlot(i)
	end
end)

local NudeBtn = CreateButton("DressUpNudeBtn", DressUpFrame, "全脱", "BOTTOMLEFT", DressUpFrame, "BOTTOMLEFT", 96, 79, 80, 22)
NudeBtn:SetScript("OnClick", function()
	for i = 1, 19 do
		DressUpModel:UndressSlot(i)
	end
end)

-- 侧边试衣间
local SideBtn = CreateButton("DressUpSideBtn", SideDressUpFrame, "单脱", "TOP", SideDressUpModelResetButton, "BOTTOMLEFT", -1, -2, 80, 22)
SideBtn:SetFrameStrata(BtnStrata)
SideBtn:SetFrameLevel(BtnLevel)
SideBtn:SetScript("OnClick", function()
	SideDressUpModel:UndressSlot(4)
	for i = 16, 19 do
		SideDressUpModel:UndressSlot(i)
	end
end)

local SideNudeBtn = CreateButton("DressUpSideNudeBtn", SideDressUpFrame, "全脱", "TOP", SideDressUpModelResetButton, "BOTTOMRIGHT", 1, -2, 80, 22)
SideNudeBtn:SetFrameStrata(BtnStrata)
SideNudeBtn:SetFrameLevel(BtnLevel)
SideNudeBtn:SetScript("OnClick", function()
	for i = 1, 19 do
		SideDressUpModel:UndressSlot(i)
	end
end)