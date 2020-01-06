local _, ns = ...
local B, C, L, DB = unpack(ns)
local M = B:GetModule("Misc")
if not M then return end
-------------------------------------
-- Pet Quick Filter, by Windrunner
-- NDui MOD
-------------------------------------
local ipairs = ipairs

local function loadPetFilter()
	local cr, cg, cb = DB.r, DB.g, DB.b

	PetJournalListScrollFrame:SetPoint("TOPLEFT", PetJournalLeftInset, 3, -60)
	if PetJournalEnhancedListScrollFrame then
		PetJournalEnhancedListScrollFrame:SetPoint("TOPLEFT", PetJournalLeftInset, 3, -60)
	end

	local function QuickFilter_Function(self, button)
		local activeCount = 0
		for petType in ipairs(PET_TYPE_SUFFIX) do
			local btn = _G["PetJournalQuickFilterButton"..petType]
			if button == "LeftButton" then
				if self == btn then
					btn.isActive = not btn.isActive
				elseif not IsShiftKeyDown() then
					btn.isActive = false
				end
			elseif button == "RightButton" and (self == btn) then
				btn.isActive = not btn.isActive
			end

			if btn.isActive then
				btn:SetBackdropBorderColor(cr, cg, cb)
				activeCount = activeCount + 1
			else
				btn:SetBackdropBorderColor(0, 0, 0)
			end
			C_PetJournal.SetPetTypeFilter(btn.petType, btn.isActive)
		end

		if activeCount == 0 then
			C_PetJournal.SetAllPetTypesChecked(true)
		end

		-- PetJournalEnhanced support
		if PetJournalEnhanced then
			local PJE = PetJournalEnhanced
			if PJE.modules and PJE.modules.Sorting then
				PJE.modules.Sorting:UpdatePets()
			elseif PJE.UpdatePets then
				PJE:UpdatePets()
			end
		end
	end

	-- Create the pet type buttons, sorted according weakness
	-- Humanoid > Dragonkin > Magic > Flying > Aquatic > Elemental > Mechanical > Beast > Critter > Undead
	local activeCount = 0
	for petIndex, petType in ipairs({1, 2, 6, 3, 9, 7, 10, 8, 5, 4}) do
		local btn = CreateFrame("Button", "PetJournalQuickFilterButton"..petIndex, PetJournal)
		btn:SetSize(22, 22)
		btn:SetPoint("TOPLEFT", PetJournalLeftInset, 6 + 25 * (petIndex-1), -35)
		B.PixelIcon(btn, "Interface\\Icons\\Icon_PetFamily_"..PET_TYPE_SUFFIX[petType], true)

		if C_PetJournal.IsPetTypeChecked(petType) then
			btn.isActive = true
			btn:SetBackdropBorderColor(cr, cg, cb)
			activeCount = activeCount + 1
		else
			btn.isActive = false
		end
		btn.petType = petType
		btn:SetScript("OnMouseUp", QuickFilter_Function)
	end

	if #PET_TYPE_SUFFIX == activeCount then
		for petIndex in ipairs(PET_TYPE_SUFFIX) do
			local btn = _G["PetJournalQuickFilterButton"..petIndex]
			btn.isActive = false
			btn:SetBackdropBorderColor(0, 0, 0)
		end
	end
end

function M:PetFilterTab()
	if not NDuiDB["Misc"]["PetFilter"] then return end

	local function onLoad(event, addon)
		if addon == "Blizzard_Collections" then
			loadPetFilter()
			B:UnregisterEvent(event, onLoad)
		end
	end

	if IsAddOnLoaded("Blizzard_Collections") then
		loadPetFilter()
	else
		B:RegisterEvent("ADDON_LOADED", onLoad)
	end
end