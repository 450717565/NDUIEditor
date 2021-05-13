local _, ns = ...
local B, C, L, DB = unpack(ns)
local Auras = B:GetModule("Auras")

local pairs, tinsert, next = pairs, table.insert, next
local GetSpecialization, GetZonePVPInfo, GetItemCooldown = GetSpecialization, GetZonePVPInfo, GetItemCooldown
local UnitIsDeadOrGhost, UnitInVehicle, InCombatLockdown = UnitIsDeadOrGhost, UnitInVehicle, InCombatLockdown
local IsInInstance, IsPlayerSpell, UnitBuff, GetSpellTexture = IsInInstance, IsPlayerSpell, UnitBuff, GetSpellTexture
local GetWeaponEnchantInfo, IsEquippedItem = GetWeaponEnchantInfo, IsEquippedItem

local groups = DB.ReminderBuffs[DB.MyClass]
local iconSize = 36
local frames, parentFrame = {}
local auraEvents = {
	"UNIT_EXITED_VEHICLE",
	"UNIT_ENTERED_VEHICLE",
	"PLAYER_REGEN_ENABLED",
	"PLAYER_REGEN_DISABLED",
	"PLAYER_ENTERING_WORLD",
	"PLAYER_EQUIPMENT_CHANGED",
}

function Auras:Reminder_Update(cfg)
	local frame = cfg.frame
	local combat = cfg.combat
	local depend = cfg.depend
	local equip = cfg.equip
	local instance = cfg.instance
	local itemID = cfg.itemID
	local pvp = cfg.pvp
	local spec = cfg.spec
	local weaponIndex = cfg.weaponIndex

	local isPlayerSpell, isRightSpec, isEquipped, isInCombat, isInInstance, isInPVP = true, true, true
	local inInst, instType = IsInInstance()

	if itemID then
		local count = GetItemCount(itemID)
		local start, duration = GetItemCooldown(itemID)

		if equip and not IsEquippedItem(itemID) then isEquipped = false end
		if count == 0 or (not isEquipped) or (start and duration and duration > 1.5) then -- check item cooldown
			frame:Hide()
			return
		end
	end

	if depend and not IsPlayerSpell(depend) then isPlayerSpell = false end
	if spec and spec ~= GetSpecialization() then isRightSpec = false end
	if combat and InCombatLockdown() then isInCombat = true end
	if instance and inInst and (instType == "scenario" or instType == "party" or instType == "raid") then isInInstance = true end
	if pvp and (instType == "arena" or instType == "pvp" or GetZonePVPInfo() == "combat") then isInPVP = true end
	if not combat and not instance and not pvp then isInCombat, isInInstance, isInPVP = true, true, true end

	frame:Hide()
	if isPlayerSpell and isRightSpec and (isInCombat or isInInstance or isInPVP) and not UnitInVehicle("player") and not UnitIsDeadOrGhost("player") then
		if weaponIndex then
			local hasMainHandEnchant, _, _, _, hasOffHandEnchant = GetWeaponEnchantInfo()
			if (hasMainHandEnchant and weaponIndex == 1) or (hasOffHandEnchant and weaponIndex == 2) then
				frame:Hide()
				return
			end
		else
			local index = 1
			while true do
				local name, _, _, _, _, _, _, _, _, spellID = UnitBuff("player", index)
				if not name then break end
				if name and cfg.spells[spellID] then
					frame:Hide()
					return
				end

				index = index + 1
			end
		end
		frame:Show()
	end
end

function Auras:Reminder_Create(cfg)
	local frame = CreateFrame("Frame", nil, parentFrame)
	frame:SetSize(iconSize, iconSize)
	B.PixelIcon(frame)
	B.CreateSD(frame)
	local texture = cfg.texture
	if not texture then
		for spellID in pairs(cfg.spells) do
			texture = GetSpellTexture(spellID)
			break
		end
	end
	frame.Icon:SetTexture(texture)
	frame.text = B.CreateFS(frame, 14, ADDON_MISSING)
	frame.text:ClearAllPoints()
	frame.text:SetPoint("CENTER", frame, "TOP", 0, 0)
	frame:Hide()
	cfg.frame = frame

	tinsert(frames, frame)
end

function Auras:Reminder_UpdateAnchor()
	local index = 0
	local offset = iconSize + 5
	for _, frame in next, frames do
		if frame:IsShown() then
			frame:SetPoint("LEFT", offset * index, 0)
			index = index + 1
		end
	end
	parentFrame:SetWidth(offset * index)
end

function Auras:Reminder_OnEvent()
	for _, cfg in pairs(groups) do
		if not cfg.frame then Auras:Reminder_Create(cfg) end
		Auras:Reminder_Update(cfg)
	end
	Auras:Reminder_UpdateAnchor()
end

function Auras:Reminder_AddItemGroup()
	for _, value in pairs(DB.ReminderBuffs["ITEMS"]) do
		if not value.disable and GetItemCount(value.itemID) > 0 then
			if not value.texture then
				value.texture = GetItemIcon(value.itemID)
			end
			if not groups then groups = {} end
			tinsert(groups, value)
		end
	end
end

function Auras:InitReminder()
	Auras:Reminder_AddItemGroup()

	if not groups or not next(groups) then return end

	if C.db["Auras"]["Reminder"] then
		if not parentFrame then
			parentFrame = CreateFrame("Frame", nil, UIParent)
			parentFrame:SetPoint("TOPRIGHT", UIParent, "TOP", -200, -200)
			parentFrame:SetSize(iconSize, iconSize)
		end

		parentFrame:Show()
		B:RegisterEvent("UNIT_AURA", Auras.Reminder_OnEvent, "player")

		for _, event in pairs(auraEvents) do
			B:RegisterEvent(event, Auras.Reminder_OnEvent)
		end
	else
		if parentFrame then
			parentFrame:Hide()
			B:UnregisterEvent("UNIT_AURA", Auras.Reminder_OnEvent)

			for _, event in pairs(auraEvents) do
				B:UnregisterEvent(event, Auras.Reminder_OnEvent)
			end
		end
	end
end