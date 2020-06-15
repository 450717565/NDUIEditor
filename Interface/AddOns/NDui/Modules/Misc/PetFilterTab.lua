local _, ns = ...
local B, C, L, DB = unpack(ns)
local M = B:GetModule("Misc")

-- Credit: PetJournal_QuickFilter, Integer
local PET_TYPE_SUFFIX = PET_TYPE_SUFFIX
local ipairs, IsShiftKeyDown = ipairs, IsShiftKeyDown
local C_PetJournal_SetPetTypeFilter = C_PetJournal.SetPetTypeFilter
local C_PetJournal_IsPetTypeChecked = C_PetJournal.IsPetTypeChecked
local C_PetJournal_SetAllPetTypesChecked = C_PetJournal.SetAllPetTypesChecked
local cr, cg, cb = DB.r, DB.g, DB.b

function M:PetTabs_Click(button)
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
		C_PetJournal_SetPetTypeFilter(btn.petType, btn.isActive)
	end

	if activeCount == 0 then
		C_PetJournal_SetAllPetTypesChecked(true)
	end
end

function M:PetTabs_Create()
	PetJournalListScrollFrame:SetPoint("TOPLEFT", PetJournalLeftInset, 3, -60)

	-- Create the pet type buttons, sorted according weakness
	-- Humanoid > Dragonkin > Magic > Flying > Aquatic > Elemental > Mechanical > Beast > Critter > Undead
	local activeCount = 0
	for petIndex, petType in ipairs({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}) do
		local btn = CreateFrame("Button", "PetJournalQuickFilterButton"..petIndex, PetJournal)
		btn:SetSize(22, 22)
		btn:SetPoint("TOPLEFT", PetJournalLeftInset, 7 + 25 * (petIndex-1), -34)
		B.PixelIcon(btn, "Interface\\Icons\\Icon_PetFamily_"..PET_TYPE_SUFFIX[petType], true)

		if C_PetJournal_IsPetTypeChecked(petType) then
			btn.isActive = true
			btn:SetBackdropBorderColor(cr, cg, cb)
			activeCount = activeCount + 1
		else
			btn.isActive = false
		end
		btn.petType = petType
		btn:SetScript("OnMouseUp", M.PetTabs_Click)
	end

	if activeCount == #PET_TYPE_SUFFIX then
		for petIndex in ipairs(PET_TYPE_SUFFIX) do
			local btn = _G["PetJournalQuickFilterButton"..petIndex]
			btn.isActive = false
			btn:SetBackdropBorderColor(0, 0, 0)
		end
	end
end

function M:PetTabs_Load(addon)
	if addon == "Blizzard_Collections" then
		M:PetTabs_Create()
		B:UnregisterEvent(self, M.PetTabs_Load)
	end
end

function M:PetTabs_Init()
	if not NDuiDB["Misc"]["PetFilter"] then return end

	if IsAddOnLoaded("Blizzard_Collections") then
		M:PetTabs_Create()
	else
		B:RegisterEvent("ADDON_LOADED", M.PetTabs_Load)
	end
end
M:RegisterMisc("PetFilterTab", M.PetTabs_Init)