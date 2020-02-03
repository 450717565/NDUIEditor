local B, C, L, DB = unpack(select(2, ...))
local Extras = B:GetModule("Extras")

function Extras.DU_CreateButton(name, frame, label, width, height, point, relativeTo, relativePoint, xOffset, yOffset)
	local name = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	name:SetSize(width, height)
	name:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)
	name:SetText(label)
	name:RegisterForClicks("AnyUp")
	name:SetHitRectInsets(0, 0, 0, 0)

	B.ReskinButton(name)

	return name
end

function Extras:DressUp()
	local ResetButton = SideDressUpFrame.ResetButton
	local ResetStrata = ResetButton:GetFrameStrata()
	local ResetLevel = ResetButton:GetFrameLevel()

	--普通试衣间
	local DOneNake = self.DU_CreateButton("DressUpOneNake", DressUpFrame, L["One Nake"], 75, 22, "RIGHT", DressUpFrameResetButton, "LEFT", -2, 0)
	DOneNake:SetScript("OnClick", function()
		local ModelScene = DressUpFrame.ModelScene:GetPlayerActor()
		ModelScene:UndressSlot(4)
		for i = 16, 19 do
			ModelScene:UndressSlot(i)
		end
	end)

	local DAllNake = self.DU_CreateButton("DressUpAllNake", DressUpFrame, L["All Nake"], 75, 22, "RIGHT", DOneNake, "LEFT", -2, 0)
	DAllNake:SetScript("OnClick", function()
		local ModelScene = DressUpFrame.ModelScene:GetPlayerActor()
		for i = 1, 19 do
			ModelScene:UndressSlot(i)
		end
	end)

	-- 侧边试衣间
	local SOneNake = self.DU_CreateButton("SideDressUpOneNake", SideDressUpFrame, L["One Nake"], 80, 22, "BOTTOM", ResetButton, "TOPLEFT", -1, 2)
	SOneNake:SetFrameStrata(ResetStrata)
	SOneNake:SetFrameLevel(ResetLevel)
	SOneNake:SetScript("OnClick", function()
		local SideModelScene = SideDressUpFrame.ModelScene:GetPlayerActor()
		SideModelScene:UndressSlot(4)
		for i = 16, 19 do
			SideModelScene:UndressSlot(i)
		end
	end)

	local SAllNake = self.DU_CreateButton("SideDressUpOneNake", SideDressUpFrame, L["All Nake"], 80, 22, "BOTTOM", ResetButton, "TOPRIGHT", 1, 2)
	SAllNake:SetFrameStrata(ResetStrata)
	SAllNake:SetFrameLevel(ResetLevel)
	SAllNake:SetScript("OnClick", function()
		local SideModelScene = SideDressUpFrame.ModelScene:GetPlayerActor()
		for i = 1, 19 do
			SideModelScene:UndressSlot(i)
		end
	end)
end