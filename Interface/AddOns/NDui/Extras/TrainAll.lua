local B, C, L, DB = unpack(select(2, ...))

-- Game version 8.0.1
local event = CreateFrame("frame")
event:RegisterEvent("ADDON_LOADED")
local spot = 0
local cani, found, Numskills, Cost, TrainAll
local done = false

local function pauseit()
	spot = 0
	TrainAll()
end

function TrainAll()
	if done == true then
		spot = 0
		return
	end
	Numskills = GetNumTrainerServices()
	found = false
	while found == false do
		spot = spot + 1
		_, cani = GetTrainerServiceInfo(spot)
		if cani == "available" then
			BuyTrainerService(spot)
			C_Timer.After(0.3, pauseit)
			found = true
		end
		if spot >= Numskills then
			done = true
			break
		end
	end
end



local function createit()
	local Button = CreateFrame("Button", "TrainAllButton",ClassTrainerFrame, "MagicButtonTemplate")
	Button:SetWidth(80)
	Button:SetHeight(22)
	Button:SetText(L["Train All"])
	Button:SetPoint("RIGHT", ClassTrainerTrainButton, "LEFT", -2, 0)
	-- Aurora Reskin
	if IsAddOnLoaded("AuroraClassic") then
		local F = unpack(AuroraClassic)
		F.Reskin(Button)
	end
	Button:SetScript("OnEnter", function()
		GameTooltip:SetOwner(Button,"ANCHOR_RIGHT")
		GameTooltip:SetText(L["Train All Need"]..GetMoneyString(Cost))
	end)
	Button:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	Button:SetScript("ONClick",function()
		spot = 0
		done = false
		TrainAll()
	end)

	hooksecurefunc("ClassTrainerFrame_Update",function()
		Cost = 0
		local Enable = false
		for i = 1, GetNumTrainerServices() do
			local _, cani = GetTrainerServiceInfo(i)
			if cani == "available" then
				Cost = Cost + GetTrainerServiceCost(i)
				TrainAllButton:Enable()
				Enable = true
			end
		end
		if Enable == false then
			TrainAllButton:Disable()
		end
	end)
end

local function woho(_, _, name)
	if name == "NDui" then
		if IsAddOnLoaded("Blizzard_TrainerUI") then
			createit()
			event:UnregisterEvent("ADDON_LOADED")
		end
	elseif name == "Blizzard_TrainerUI" then
		createit()
		event:UnregisterEvent("ADDON_LOADED")
	end
end

event:SetScript("OnEvent", woho)
