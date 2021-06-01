local _, ns = ...
local B, C, L, DB = unpack(ns)
local AT = B:GetModule("AurasTable")

-- DH的法术监控
local list = {
	["Player Aura"] = { -- 玩家光环组
		{AuraID = 163073, UnitID = "player"}, -- 恶魔之魂
		{AuraID = 188501, UnitID = "player"}, -- 幽灵视觉
		{AuraID = 258920, UnitID = "player"}, -- 献祭光环
	},
	["Target Aura"] = { -- 目标光环组
		{AuraID = 179057, UnitID = "target", Caster = "player"}, -- 混乱新星
		{AuraID = 185245, UnitID = "target", Caster = "player"}, -- 折磨
		{AuraID = 198813, UnitID = "target", Caster = "player"}, -- 复仇回避
		{AuraID = 204490, UnitID = "target", Caster = "player"}, -- 沉默咒符
		{AuraID = 204598, UnitID = "target", Caster = "player"}, -- 烈焰咒符
		{AuraID = 204843, UnitID = "target", Caster = "player"}, -- 锁链咒符
		{AuraID = 207685, UnitID = "target", Caster = "player"}, -- 悲苦咒符
		{AuraID = 207771, UnitID = "target", Caster = "player"}, -- 烈火烙印
		{AuraID = 211881, UnitID = "target", Caster = "player"}, -- 邪能爆发
		{AuraID = 213405, UnitID = "target", Caster = "player"}, -- 战刃大师
		{AuraID = 247456, UnitID = "target", Caster = "player"}, -- 脆弱
		{AuraID = 258883, UnitID = "target", Caster = "player"}, -- 毁灭之痕
		{AuraID = 268178, UnitID = "target", Caster = "player"}, -- 虚空掠夺者
		{AuraID = 320338, UnitID = "target", Caster = "player"}, -- 精华破碎
	},
	["Special Aura"] = { -- 玩家重要光环组
		{AuraID = 162264, UnitID = "player"}, -- 恶魔变形（浩劫）
		{AuraID = 187827, UnitID = "player"}, -- 恶魔变形（复仇）
		{AuraID = 196555, UnitID = "player"}, -- 虚空行走
		{AuraID = 203650, UnitID = "player"}, -- 准备就绪
		{AuraID = 203819, UnitID = "player"}, -- 恶魔尖刺
		{AuraID = 207693, UnitID = "player"}, -- 灵魂盛宴
		{AuraID = 208628, UnitID = "player"}, -- 势如破竹
		{AuraID = 212800, UnitID = "player"}, -- 疾影
		{AuraID = 343312, UnitID = "player"}, -- 狂怒凝视
		{AuraID = 347462, UnitID = "player"}, -- 释放混沌
		{AuraID = 263648, UnitID = "player", Value = true}, -- 灵魂壁障
		{AuraID = 326863, UnitID = "player", Value = true}, -- 毁灭壁垒
		{AuraID = 343013, UnitID = "player", Value = true}, -- 痛苦狂欢
	},
}

AT:AddNewAuraWatch("DEMONHUNTER", list)