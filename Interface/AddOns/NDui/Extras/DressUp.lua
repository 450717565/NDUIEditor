local BtnStrata = SideDressUpModelResetButton:GetFrameStrata()
local BtnLevel = SideDressUpModelResetButton:GetFrameLevel()

--自定义按钮创建函数
local function CreateButton(name, frame, label, width, height, point, relativeTo, relativePoint, xOffset, yOffset)
	local name = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	name:SetWidth(width)
	name:SetHeight(height)
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
local TabBtn = CreateButton("DressUpTabBtn", DressUpFrame, "单脱", 75, 22, "RIGHT", DressUpFrameResetButton, "LEFT", -2, 0)
TabBtn:SetScript("OnClick", function()
	DressUpModel:UndressSlot(4)
	for i = 16, 19 do
		DressUpModel:UndressSlot(i)
	end
end)

local NudeBtn = CreateButton("DressUpNudeBtn", DressUpFrame, "全脱", 75, 22, "RIGHT", DressUpFrameResetButton, "LEFT", -79, 0)
NudeBtn:SetScript("OnClick", function()
	for i = 1, 19 do
		DressUpModel:UndressSlot(i)
	end
end)

-- 侧边试衣间
local SideBtn = CreateButton("DressUpSideBtn", SideDressUpFrame, "单脱", 80, 22, "TOP", SideDressUpModelResetButton, "BOTTOMLEFT", -1, -2)
SideBtn:SetFrameStrata(BtnStrata)
SideBtn:SetFrameLevel(BtnLevel)
SideBtn:SetScript("OnClick", function()
	SideDressUpModel:UndressSlot(4)
	for i = 16, 19 do
		SideDressUpModel:UndressSlot(i)
	end
end)

local SideNudeBtn = CreateButton("DressUpSideNudeBtn", SideDressUpFrame, "全脱", 80, 22, "TOP", SideDressUpModelResetButton, "BOTTOMRIGHT", 1, -2)
SideNudeBtn:SetFrameStrata(BtnStrata)
SideNudeBtn:SetFrameLevel(BtnLevel)
SideNudeBtn:SetScript("OnClick", function()
	for i = 1, 19 do
		SideDressUpModel:UndressSlot(i)
	end
end)