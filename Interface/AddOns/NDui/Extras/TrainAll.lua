local Event = CreateFrame("frame")
Event:RegisterEvent("ADDON_LOADED")

local Spot = 0
local Category, Found, Number, Cost, TrainAll
local Done = false

local function Pauseit()
	Spot = 0
	TrainAll()
end

function TrainAll()
	if Done == true then
		Spot = 0
		return
	end
	Number = GetNumTrainerServices()
	Found = false
	while Found == false do
		Spot = Spot + 1
		_,_,Category = GetTrainerServiceInfo(Spot)
		if Category == "available" then
			BuyTrainerService(Spot)
			C_Timer.After(0.3, Pauseit)
			Found = true
		end
		if Spot >= Number then
			Done = true
			break
		end
	end
end

local function Createit()
	local Button = CreateFrame("Button", "TrainAllButton",ClassTrainerFrame, "MagicButtonTemplate")
	Button:SetWidth(80)
	Button:SetHeight(22)
	Button:SetText("全部训练")
	Button:SetPoint("RIGHT", ClassTrainerTrainButton, "LEFT", -1, 0)
	-- Aurora Reskin
	if IsAddOnLoaded("Aurora") then
		local F = unpack(Aurora)
		F.Reskin(Button)
	end
	Button:SetScript("OnEnter", function()
		GameTooltip:SetOwner(Button,"ANCHOR_RIGHT")
		GameTooltip:SetText("学习所有技能需要："..GetMoneyString(Cost))
	end)
	Button:SetScript("OnLeave", function()
		GameTooltip_Hide()
	end)
	Button:SetScript("OnClick",function()
		Spot = 0
		Done = false
		TrainAll()
	end)
	hooksecurefunc("ClassTrainerFrame_Update",function()
	Cost = 0
	local Enable = false
		for i = 1, GetNumTrainerServices() do
			local _, _, Category = GetTrainerServiceInfo(i)
			if Category == "available" then
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

local function Woho(_, _, name)
	if name == "NDui" then
		if IsAddOnLoaded("Blizzard_TrainerUI") then
			Createit()
			Event:UnregisterEvent("ADDON_LOADED")
		end
	elseif name == "Blizzard_TrainerUI" then
		Createit()
		Event:UnregisterEvent("ADDON_LOADED")
	end
end

Event:SetScript("OnEvent", Woho)