local _, ns = ...
local B, C, L, DB = unpack(ns)
local module = B:GetModule("AurasTable")

-- DH的法术监控
local list = {
	["Player Aura"] = { -- 玩家光环组
		{AuraID = 163073, UnitID = "player"},--恶魔之魂
		{AuraID = 188501, UnitID = "player"},--幽灵视觉
	},
	["Target Aura"] = { -- 目标光环组
		{AuraID = 258883, UnitID = "target", Caster = "player"},--毁灭之痕
		{AuraID = 258860, UnitID = "target", Caster = "player"},--黑暗鞭笞
		{AuraID = 213405, UnitID = "target", Caster = "player"},--战刃大师
		{AuraID = 179057, UnitID = "target", Caster = "player"},--混乱新星
		{AuraID = 211881, UnitID = "target", Caster = "player"},--邪能爆发
		{AuraID = 206491, UnitID = "target", Caster = "player"},--涅墨西斯
		{AuraID = 198813, UnitID = "target", Caster = "player"},--复仇回避
		{AuraID = 210003, UnitID = "target", Caster = "player"},--锋锐之刺
		{AuraID = 204490, UnitID = "target", Caster = "player"},--沉默咒符
		{AuraID = 204598, UnitID = "target", Caster = "player"},--烈焰咒符
		{AuraID = 204843, UnitID = "target", Caster = "player"},--锁链咒符
		{AuraID = 268178, UnitID = "target", Caster = "player"},--虚空掠夺者
		{AuraID = 247456, UnitID = "target", Caster = "player"},--脆弱
		{AuraID = 207744, UnitID = "target", Caster = "player"},--烈火烙印
		--折磨
		{AuraID = 185245, UnitID = "target", Caster = "player"},
		{AuraID = 281854, UnitID = "target", Caster = "player"},
	},
	["Player Special Aura"] = { -- 玩家重要光环组
		{AuraID = 196555, UnitID = "player"},--虚空行走
		{AuraID = 212800, UnitID = "player"},--疾影
		{AuraID = 208628, UnitID = "player"},--势如破竹
		{AuraID = 203819, UnitID = "player"},--恶魔尖刺
		{AuraID = 207693, UnitID = "player"},--灵魂盛宴
		{AuraID = 203650, UnitID = "player"},--准备就绪
		{AuraID = 263648, UnitID = "player", Value = true},--灵魂屏障
		{AuraID = 272987, UnitID = "player", Value = true},--痛苦狂饮
		--恶魔变形
		{AuraID = 162264, UnitID = "player"},
		{AuraID = 187827, UnitID = "player"},
		--献祭光环
		{AuraID = 178740, UnitID = "player"},
		{AuraID = 258920, UnitID = "player"},
		--涅墨西斯
		{AuraID = 208579, UnitID = "player"},
		{AuraID = 208605, UnitID = "player"},
		{AuraID = 208607, UnitID = "player"},
		{AuraID = 208608, UnitID = "player"},
		{AuraID = 208609, UnitID = "player"},
		{AuraID = 208610, UnitID = "player"},
		{AuraID = 208611, UnitID = "player"},
		{AuraID = 208612, UnitID = "player"},
		{AuraID = 208613, UnitID = "player"},
		{AuraID = 208614, UnitID = "player"},
	},
	["Spell CD"] = { -- 技能冷却计时组
		{SpellID = 179057},--混乱新星
		{SpellID = 183752},--吞噬魔法
		{SpellID = 185245},--折磨
		{SpellID = 188501},--幽灵视觉
		{SpellID = 189110},--地狱火撞击
		{SpellID = 195072},--邪能冲撞
		{SpellID = 196555},--虚空行走
		{SpellID = 196718},--幻影打击
		{SpellID = 198013},--眼棱
		{SpellID = 198589},--疾影
		{SpellID = 198793},--复仇回避
		{SpellID = 202137},--沉默咒符
		{SpellID = 202138},--锁链咒符
		{SpellID = 204021},--烈火烙印
		{SpellID = 204596},--烈焰咒符
		{SpellID = 206491},--涅墨西斯
		{SpellID = 207684},--悲苦咒符
		{SpellID = 211881},--邪能爆发
		{SpellID = 212084},--邪能毁灭
		{SpellID = 217832},--禁锢
		{SpellID = 258860},--黑暗鞭笞
		{SpellID = 258925},--邪能弹幕
		{SpellID = 263648},--灵魂壁障
		--恶魔变形
		{SpellID = 187827},
		{SpellID = 191427},
	},
}

module:AddNewAuraWatch("DEMONHUNTER", list)