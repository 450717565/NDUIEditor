local B, C, L, DB, F = unpack(select(2, ...))

local spot = 0
local rank, found, nums, cost
local done = false

local function PauseIt()
	spot = 0
	TrainIt()
end

local function TrainIt()
	if done == true then
		spot = 0
		return
	end
	nums = GetNumTrainerServices()
	found = false
	while found == false do
		spot = spot + 1
		rank = select(2, GetTrainerServiceInfo(spot))
		if rank == "available" then
			BuyTrainerService(spot)
			C_Timer.After(0.3, PauseIt)
			found = true
		end
		if spot >= nums then
			done = true
			break
		end
	end
end

local function CreateIt()
	local Button = CreateFrame("Button", "TrainAllButton",ClassTrainerFrame, "MagicButtonTemplate")
	Button:SetWidth(80)
	Button:SetHeight(22)
	Button:SetText(L["Train All"])
	Button:SetPoint("RIGHT", ClassTrainerTrainButton, "LEFT", -2, 0)

	if F then F.ReskinButton(Button) end

	Button:SetScript("OnEnter", function()
		GameTooltip:SetOwner(Button,"ANCHOR_RIGHT")
		GameTooltip:SetText(L["Train All Need"]..GetMoneyString(cost))
	end)
	Button:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	Button:SetScript("ONClick",function()
		spot = 0
		done = false
		TrainIt()
	end)

	hooksecurefunc("ClassTrainerFrame_Update",function()
		cost = 0
		local Enable = false
		for i = 1, GetNumTrainerServices() do
			local _, rank = GetTrainerServiceInfo(i)
			if rank == "available" then
				cost = cost + GetTrainerServiceCost(i)
				TrainAllButton:Enable()
				Enable = true
			end
		end
		if Enable == false then
			TrainAllButton:Disable()
		end
	end)
end

local function BuildIt(event, addon)
	if addon == "Blizzard_TrainerUI" then
		CreateIt()
		B:UnregisterEvent(event, BuildIt)
	end
end

B:RegisterEvent("ADDON_LOADED", BuildIt)