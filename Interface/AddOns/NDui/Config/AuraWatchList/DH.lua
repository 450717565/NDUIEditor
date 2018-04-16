local B, C, L, DB = unpack(select(2, ...))
local module = NDui:GetModule("AurasTable")

-- DH的法术监控
local list = {
	["Player Aura"] = { -- 玩家光环组
		{AuraID = 163073, UnitID = "player"},--恶魔之魂
		{AuraID = 188501, UnitID = "player"},--幽灵视觉
	},
	["Target Aura"] = { -- 目标光环组
		{AuraID = 179057, UnitID = "target", Caster = "player"},--混乱新星
		{AuraID = 185245, UnitID = "target", Caster = "player"},--折磨
		{AuraID = 198813, UnitID = "target", Caster = "player"},--复仇回避
		{AuraID = 204490, UnitID = "target", Caster = "player"},--沉默咒符
		{AuraID = 204598, UnitID = "target", Caster = "player"},--烈焰咒符
		{AuraID = 204843, UnitID = "target", Caster = "player"},--锁链咒符
		{AuraID = 206491, UnitID = "target", Caster = "player"},--涅墨西斯
		{AuraID = 207407, UnitID = "target", Caster = "player"},--灵魂切削
		{AuraID = 207690, UnitID = "target", Caster = "player"},--血滴子
		{AuraID = 210003, UnitID = "target", Caster = "player"},--锋锐之刺
		{AuraID = 211053, UnitID = "target", Caster = "player"},--邪能弹幕
		{AuraID = 211881, UnitID = "target", Caster = "player"},--邪能爆发
		{AuraID = 212818, UnitID = "target", Caster = "player"},--猛烈的死亡
		{AuraID = 213405, UnitID = "target", Caster = "player"},--战刃大师
		{AuraID = 224509, UnitID = "target", Caster = "player"},--幽魂炸弹
		{AuraID = 247456, UnitID = "target", Caster = "player"},--脆弱
		--烈火烙印
		{AuraID = 207744, UnitID = "target", Caster = "player"},
		{AuraID = 207771, UnitID = "target", Caster = "player"},
	},
	["Player Special Aura"] = { -- 玩家重要光环组
		{AuraID = 178740, UnitID = "player"},--献祭光环
		{AuraID = 196555, UnitID = "player"},--虚空行走
		{AuraID = 203650, UnitID = "player"},--准备就绪
		{AuraID = 203819, UnitID = "player"},--恶魔尖刺
		{AuraID = 207693, UnitID = "player"},--灵魂盛宴
		{AuraID = 208628, UnitID = "player"},--势如破竹
		{AuraID = 211053, UnitID = "player"},--邪能弹幕
		{AuraID = 212800, UnitID = "player"},--疾影
		{AuraID = 212988, UnitID = "player"},--痛苦使者
		{AuraID = 218256, UnitID = "player"},--强化结界
		{AuraID = 218561, UnitID = "player", Value = true},--虹吸能量
		{AuraID = 227225, UnitID = "player", Value = true},--灵魂屏障
		{AuraID = 247253, UnitID = "player"},--剑刃扭转
		{AuraID = 247938, UnitID = "player"},--混乱之刃
		--恶魔变形
		{AuraID = 162264, UnitID = "player"},
		{AuraID = 187827, UnitID = "player"},
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
		--套装效果
		{AuraID = 252165, UnitID = "player"},
	},
	["Spell CD"] = { -- 技能冷却计时组
		{SpellID = 179057, UnitID = "player"},--混乱新星
		{SpellID = 183752, UnitID = "player"},--吞噬魔法
		{SpellID = 185245, UnitID = "player"},--折磨
		{SpellID = 188501, UnitID = "player"},--幽灵视觉
		{SpellID = 189110, UnitID = "player"},--地狱火撞击
		{SpellID = 195072, UnitID = "player"},--邪能冲撞
		{SpellID = 196555, UnitID = "player"},--虚空行走
		{SpellID = 196718, UnitID = "player"},--幻影打击
		{SpellID = 198013, UnitID = "player"},--眼棱
		{SpellID = 198589, UnitID = "player"},--疾影
		{SpellID = 198793, UnitID = "player"},--复仇回避
		{SpellID = 201467, UnitID = "player"},--伊利达雷之怒
		{SpellID = 202137, UnitID = "player"},--沉默咒符
		{SpellID = 202138, UnitID = "player"},--锁链咒符
		{SpellID = 204021, UnitID = "player"},--烈火烙印
		{SpellID = 204596, UnitID = "player"},--烈焰咒符
		{SpellID = 206491, UnitID = "player"},--涅墨西斯
		{SpellID = 207407, UnitID = "player"},--灵魂切削
		{SpellID = 207684, UnitID = "player"},--悲苦咒符
		{SpellID = 211053, UnitID = "player"},--邪能弹幕
		{SpellID = 211881, UnitID = "player"},--邪能爆发
		{SpellID = 212084, UnitID = "player"},--邪能毁灭
		{SpellID = 217832, UnitID = "player"},--禁锢
		{SpellID = 218256, UnitID = "player"},--强化结界
		{SpellID = 227225, UnitID = "player"},--灵魂壁障
		{SpellID = 236189, UnitID = "player"},--恶魔灌注
		{SpellID = 247938, UnitID = "player"},--混乱之刃
		--恶魔变形
		{SpellID = 187827, UnitID = "player"},
		{SpellID = 191427, UnitID = "player"},
	},
}

module:AddNewAuraWatch("DEMONHUNTER", list)