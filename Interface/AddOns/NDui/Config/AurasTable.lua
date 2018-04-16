local B, C, L, DB = unpack(select(2, ...))
local module = NDui:RegisterModule("AurasTable")

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
	["Enchant CD"]			= {"UP", 5, "BAR", 20, C.Auras.EnchantCDPos, 150},
	["Internal CD"]			= {"UP", 5, "BAR", 20, C.Auras.InternalCDPos, 150},
}

-- AuraWatch
local AuraWatchList = {}
function module:AddNewAuraWatch(class, list)
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
			List = v
		})
	end
end

-- RaidFrame spells
local RaidBuffs = {}
function module:AddClassSpells(list)
	for class, value in pairs(list) do
		if class == "ALL" or class == DB.MyClass then
			RaidBuffs[class] = value
		end
	end
end

-- RaidFrame debuffs
local RaidDebuffs = {}
function module:RegisterDebuff(_, instID, _, spellID, level)
	local instName = EJ_GetInstanceInfo(instID)
	if not instName then print("Invalid instance ID: "..instID) return end

	if not RaidDebuffs[instName] then RaidDebuffs[instName] = {} end
	if level then
		if level > 6 then level = 6 end
	else
		level = 2
	end

	RaidDebuffs[instName][spellID] = level
end

function module:OnLogin()
	if not NDuiDB["AuraWatchList"] then NDuiDB["AuraWatchList"] = {} end
	if not NDuiDB["Internal CD"] then NDuiDB["Internal CD"] = {} end
	if not NDuiADB["RaidDebuffs"] then NDuiADB["RaidDebuffs"] = {} end
	local newTable = {}
	for _, value in pairs(NDuiADB["RaidDebuffs"]) do
		if value then
			local instName, spellID, priority = unpack(value)
			if not newTable[instName] then newTable[instName] = {} end
			newTable[instName][spellID] = priority
		end
	end
	B.CopyTable(newTable, RaidDebuffs)

	C.AuraWatchList = AuraWatchList
	C.RaidBuffs = RaidBuffs
	C.RaidDebuffs = RaidDebuffs
end