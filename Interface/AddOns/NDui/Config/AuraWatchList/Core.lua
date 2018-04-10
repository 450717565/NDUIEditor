local B, C, L, DB = unpack(select(2, ...))
local module = NDui:GetModule("AurasTable")

local groups = {
	-- groups name = direction, interval, mode, iconsize, position, barwidth
	["Enchant Aura"]		= {"LEFT", 5, "ICON", 40, C.Auras.EnchantAuraPos},
	["Player Aura"]			= {"LEFT", 5, "ICON", 24, C.Auras.PlayerAuraPos},
	["Player Special Aura"]	= {"LEFT", 5, "ICON", 32, C.Auras.PlayerSpecialAuraPos},
	["Target Aura"]			= {"RIGHT", 5, "ICON", 24, C.Auras.TargetAuraPos},
	["Target Special Aura"]	= {"RIGHT", 5, "ICON", 32, C.Auras.TargetSpecialAuraPos},
	["Focus Special Aura"]	= {"RIGHT", 5, "ICON", 32, C.Auras.FocusSpecialAuraPos},
	["Spell CD"]			= {"UP", 5, "BAR", 20, C.Auras.SpellCDPos, 150},
	["Enchant CD"]			= {"UP", 5, "BAR", 20, C.Auras.EnchantCDPos, 150},
	["Internal CD"]			= {"UP", 5, "BAR", 20, C.Auras.InternalCDPos, 150},
	["Raid Buff"]			= {"LEFT", 5, "ICON", 48, C.Auras.RaidBuffPos},
	["Raid Debuff"]			= {"RIGHT", 5, "ICON", 48, C.Auras.RaidDebuffPos},
}

function module:AddNewAuraWatch(class, list)
	if not C.AuraWatchList then C.AuraWatchList = {} end
	if not C.AuraWatchList[class] then C.AuraWatchList[class] = {} end

	for name, v in pairs(list) do
		local direction, interval, mode, size, pos, width = unpack(groups[name])
		local newList = {
			Name = name,
			Direction = direction,
			Interval = interval,
			Mode = mode,
			IconSize = size,
			Pos = pos,
			BarWidth = width,
			List = v
		}
		tinsert(C.AuraWatchList[class], newList)
	end
end
