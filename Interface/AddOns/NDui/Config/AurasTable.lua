local _, ns = ...
local B, C, L, DB = unpack(ns)
local module = B:RegisterModule("AurasTable")
local pairs, next, format, wipe = pairs, next, string.format, wipe

-- AuraWatch
local AuraWatchList = {}
local groups = {
	-- groups name = direction, interval, mode, iconsize, position, barwidth
	["Enchant Aura"]		= {"LEFT", 5, "ICON", 40, C.Auras.EnchantAuraPos},
	["Player Aura"]			= {"LEFT", 5, "ICON", 24, C.Auras.PlayerAuraPos},
	["Player Special Aura"]	= {"LEFT", 5, "ICON", 32, C.Auras.PlayerSpecialAuraPos},
	["Target Aura"]			= {"RIGHT", 5, "ICON", 32, C.Auras.TargetAuraPos},
	["Target Special Aura"]	= {"RIGHT", 5, "ICON", 40, C.Auras.TargetSpecialAuraPos},
	["Focus Special Aura"]	= {"RIGHT", 5, "ICON", 32, C.Auras.FocusSpecialAuraPos},
	["Raid Buff"]			= {"LEFT", 5, "ICON", 48, C.Auras.RaidBuffPos},
	["Raid Debuff"]			= {"RIGHT", 5, "ICON", 48, C.Auras.RaidDebuffPos},
	["Spell CD"]			= {"UP", 5, "BAR", 20, C.Auras.SpellCDPos, 150},
	["Enchant CD"]			= {"DOWN", 5, "BAR", 20, C.Auras.EnchantCDPos, 150},
	["Custom CD"]			= {"UP", 5, "BAR", 20, C.Auras.CustomCDPos, 150},
}

local function newAuraFormat(value)
	local newTable = {}
	for _, v in pairs(value) do
		local id = v.AuraID or v.SpellID or v.ItemID or v.SlotID or v.TotemID or v.IntID
		if id then
			newTable[id] = v
		end
	end
	return newTable
end

function module:AddNewAuraWatch(class, list)
	for _, k in pairs(list) do
		for _, v in pairs(k) do
			local spellID = v.AuraID or v.SpellID
			if spellID then
				local name = GetSpellInfo(spellID)
				if not name then
					wipe(v)
					if DB.isDeveloper then print(format("|cffFF0000Invalid spellID:|r '%s' %s", class, spellID)) end
				end
			end
		end
	end

	if class ~= "ALL" and class ~= DB.MyClass then return end
	if not AuraWatchList[class] then AuraWatchList[class] = {} end

	for name, v in pairs(list) do
		local direction, interval, mode, size, pos, width = unpack(groups[name])
		tinsert(AuraWatchList[class], {
			Name = name,
			Direction = direction,
			Interval = interval,
			Mode = mode,
			IconSize = size,
			Pos = pos,
			BarWidth = width,
			List = newAuraFormat(v)
		})
	end
end

function module:AddDeprecatedGroup()
	if not NDuiDB["AuraWatch"]["DeprecatedAuras"] then return end

	for name, value in pairs(C.DeprecatedAuras) do
		for _, list in pairs(AuraWatchList["ALL"]) do
			if list.Name == name then
				local newTable = newAuraFormat(value)
				for spellID, v in pairs(newTable) do
					list.List[spellID] = v
				end
			end
		end
	end
	wipe(C.DeprecatedAuras)
end

-- RaidFrame spells
local RaidBuffs = {}
function module:AddClassSpells(list)
	for class, value in pairs(list) do
		RaidBuffs[class] = value
	end
end

-- RaidFrame debuffs
local RaidDebuffs = {}
function module:RegisterDebuff(_, instID, _, spellID, level)
	local instName = EJ_GetInstanceInfo(instID)
	if not instName then
		if DB.isDeveloper then print("Invalid instance ID: "..instID) end
		return
	end

	if not RaidDebuffs[instName] then RaidDebuffs[instName] = {} end
	if level then
		if level > 6 then level = 6 end
	else
		level = 2
	end

	RaidDebuffs[instName][spellID] = level
end

-- Party watcher spells
function module:UpdatePartyWatcherSpells()
	if not next(NDuiADB["PartyWatcherSpells"]) then
		for spellID, duration in pairs(C.PartySpells) do
			local name = GetSpellInfo(spellID)
			if name then
				NDuiADB["PartyWatcherSpells"][spellID] = duration
			end
		end
	end
end

function module:OnLogin()
	for instName, value in pairs(RaidDebuffs) do
		for spell, priority in pairs(value) do
			if NDuiADB["RaidDebuffs"][instName] and NDuiADB["RaidDebuffs"][instName][spell] and NDuiADB["RaidDebuffs"][instName][spell] == priority then
				NDuiADB["RaidDebuffs"][instName][spell] = nil
			end
		end
	end
	for instName, value in pairs(NDuiADB["RaidDebuffs"]) do
		if not next(value) then
			NDuiADB["RaidDebuffs"][instName] = nil
		end
	end

	self:AddDeprecatedGroup()
	C.AuraWatchList = AuraWatchList
	C.RaidBuffs = RaidBuffs
	C.RaidDebuffs = RaidDebuffs

	if not NDuiADB["CornerBuffs"][DB.MyClass] then NDuiADB["CornerBuffs"][DB.MyClass] = {} end
	if not next(NDuiADB["CornerBuffs"][DB.MyClass]) then
		B.CopyTable(C.CornerBuffs[DB.MyClass], NDuiADB["CornerBuffs"][DB.MyClass])
	end

	self:UpdatePartyWatcherSpells()

	-- Filter bloodlust for healers
	local bloodlustList = {57723, 57724, 80354, 264689}
	local function filterBloodlust()
		for _, spellID in pairs(bloodlustList) do
			NDuiADB["CornerBuffs"][DB.MyClass][spellID] = DB.Role ~= "Healer" and {"BOTTOMLEFT", {1, .8, 0}, true} or nil
			C.RaidBuffs["WARNING"][spellID] = (DB.Role ~= "Healer")
		end
	end
	filterBloodlust()
	B:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", filterBloodlust)
end