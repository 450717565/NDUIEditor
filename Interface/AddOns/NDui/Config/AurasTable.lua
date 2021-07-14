local _, ns = ...
local B, C, L, DB = unpack(ns)
local AT = B:RegisterModule("AurasTable")

local pairs, next, format, wipe, unpack = pairs, next, format, wipe, unpack
local GetSpellInfo = GetSpellInfo
local EJ_GetInstanceInfo = EJ_GetInstanceInfo

-- SeasonSpells
local SEASON_SPELLS = {
	[209858] = 2, -- 死疽
	[240443] = 2, -- 爆裂
	[240559] = 2, -- 重伤
	[342494] = 2, -- 狂妄吹嘘，S1
	[355732] = 2, -- 融化灵魂
	[356666] = 2, -- 刺骨之寒
	[356667] = 2, -- 刺骨之寒
	[356925] = 2, -- 屠戮
	[358777] = 2, -- 痛苦之链
}
function AT:RegisterSeasonSpells(TIER, INSTANCE)
	for spellID, priority in pairs(SEASON_SPELLS) do
		AT:RegisterDebuff(TIER, INSTANCE, 0, spellID, priority)
	end
end

-- AuraWatch
local AuraWatchList = {}
local groups = {
	-- groups name = direction, interval, mode, iconsize, position, barwidth
	["Player Aura"] = {"LEFT", 5, "ICON", 24, C.Auras.PlayerAuraPos},
	["Special Aura"] = {"LEFT", 5, "ICON", 32, C.Auras.SpecialAuraPos},
	["Target Aura"] = {"RIGHT", 5, "ICON", 32, C.Auras.TargetAuraPos},
	["Focus Aura"] = {"RIGHT", 5, "ICON", 32, C.Auras.FocusAuraPos},
	["Enchant Aura"] = {"LEFT", 5, "ICON", 40, C.Auras.EnchantAuraPos},
	["Warning Aura"] = {"RIGHT", 5, "ICON", 40, C.Auras.WarningAuraPos},
	["Raid Buff"] = {"LEFT", 5, "ICON", 48, C.Auras.RaidBuffPos},
	["Raid Debuff"] = {"RIGHT", 5, "ICON", 48, C.Auras.RaidDebuffPos},
	["Spell CD"] = {"UP", 5, "BAR", 20, C.Auras.SpellCDPos, 150},
	["InternalCD"] = {"DOWN", 5, "BAR", 20, C.Auras.InternalCDPos, 150},
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

function AT:AddNewAuraWatch(class, list)
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

function AT:AddDeprecatedGroup()
	if not C.db["AuraWatch"]["DeprecatedAuras"] then return end

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
function AT:AddClassSpells(list)
	for class, value in pairs(list) do
		RaidBuffs[class] = value
	end
end

-- RaidFrame debuffs
local RaidDebuffs = {}
function AT:RegisterDebuff(_, instID, _, spellID, level)
	local instName = EJ_GetInstanceInfo(instID)
	if not instName then
		if DB.isDeveloper then print("Invalid instance ID："..instID) end
		return
	end

	if not RaidDebuffs[instName] then RaidDebuffs[instName] = {} end
	if not level then level = 2 end
	if level > 6 then level = 6 end

	RaidDebuffs[instName][spellID] = level
end

-- Party watcher spells
function AT:CheckPartySpells()
	for spellID, duration in pairs(C.PartySpells) do
		local name = GetSpellInfo(spellID)
		if name then
			local modDuration = NDuiADB["PartySpells"][spellID]
			if modDuration and modDuration == duration then
				NDuiADB["PartySpells"][spellID] = nil
			end
		else
			if DB.isDeveloper then print("Invalid partyspell ID: "..spellID) end
		end
	end
end

function AT:CheckCornerSpells()
	if not NDuiADB["CornerSpells"][DB.MyClass] then NDuiADB["CornerSpells"][DB.MyClass] = {} end
	local data = C.CornerBuffs[DB.MyClass]
	if not data then return end

	for spellID in pairs(data) do
		local name = GetSpellInfo(spellID)
		if not name then
			if DB.isDeveloper then print("Invalid cornerspell ID: "..spellID) end
		end
	end

	for spellID, value in pairs(NDuiADB["CornerSpells"][DB.MyClass]) do
		if not next(value) and C.CornerBuffs[DB.MyClass][spellID] == nil then
			NDuiADB["CornerSpells"][DB.MyClass][spellID] = nil
		end
	end
end

function AT:CheckMajorSpells()
	for spellID in pairs(C.MajorSpells) do
		local name = GetSpellInfo(spellID)
		if name then
			if NDuiADB["MajorSpells"][spellID] then
				NDuiADB["MajorSpells"][spellID] = nil
			end
		else
			if DB.isDeveloper then print("Invalid majorspells ID: "..spellID) end
		end
	end

	for spellID, value in pairs(NDuiADB["MajorSpells"]) do
		if value == false and C.MajorSpells[spellID] == nil then
			NDuiADB["MajorSpells"][spellID] = nil
		end
	end
end

function AT:OnLogin()
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

	AT:AddDeprecatedGroup()
	C.AuraWatchList = AuraWatchList
	C.RaidBuffs = RaidBuffs
	C.RaidDebuffs = RaidDebuffs

	AT:CheckPartySpells()
	AT:CheckCornerSpells()
	AT:CheckMajorSpells()
end