local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Tooltip_OnUpdate(self)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(format(L["Train All Need"], self.Count, GetCoinTextureString(self.Cost)))
end

local function Button_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
	Tooltip_OnUpdate(self)
	GameTooltip:Show()
end

local function Button_OnLeave()
	GameTooltip:Hide()
end

local function Button_OnClick()
	for i = 1, GetNumTrainerServices() do
		if select(2, GetTrainerServiceInfo(i)) == "available" then
			BuyTrainerService(i)
		end
	end
end

local function CreateIt()
	local Button = CreateFrame("Button", "TrainAllButton", ClassTrainerFrame, "MagicButtonTemplate")
	Button:SetSize(80, 22)
	Button:SetText(L["Train All"])
	Button:SetScript("OnEnter", Button_OnEnter)
	Button:SetScript("OnLeave", Button_OnLeave)
	Button:SetScript("OnClick", Button_OnClick)

	B.ReskinButton(Button)
	B.UpdatePoint(Button, "RIGHT", ClassTrainerTrainButton, "LEFT", -2, 0)

	hooksecurefunc("ClassTrainerFrame_Update",function()
		local sum, total = 0, 0;
		for i = 1, GetNumTrainerServices() do
			if select(2, GetTrainerServiceInfo(i)) == "available" then
				sum = sum + 1
				total = total + GetTrainerServiceCost(i)
			end
		end

		Button:SetEnabled(sum > 0)
		Button.Count = sum
		Button.Cost = total
	end)
end

B.LoadWithAddOn("Blizzard_TrainerUI", CreateIt, true)