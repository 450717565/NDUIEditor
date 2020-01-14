local _, ns = ...
local B, C, L, DB, F = unpack(ns)
local module = B:GetModule("AurasTable")

-- DK的法术监控
local list = {
	["Player Aura"] = { -- 玩家光环组
		{AuraID = 101568, UnitID = "player"},--黑暗援助
		{AuraID = 111673, UnitID = "pet"},--控制亡灵
		{AuraID = 180612, UnitID = "player"},--最近使用过灵界打击
		{AuraID = 188290, UnitID = "player"},--枯萎凋零
		{AuraID = 3714, UnitID = "player"},--冰霜之路
		{AuraID = 48265, UnitID = "player"},--死亡脚步
		{AuraID = 48707, UnitID = "player", Value = true},--反魔法护罩
		{AuraID = 48792, UnitID = "player"},--冰封之韧
		{AuraID = 53365, UnitID = "player"},--不洁之力
	},
	["Target Aura"] = { -- 目标光环组
		{AuraID = 108194, UnitID = "target", Caster = "player"},--窒息
		{AuraID = 115994, UnitID = "target", Caster = "player"},--邪恶虫群
		{AuraID = 130736, UnitID = "target", Caster = "player"},--灵魂收割
		{AuraID = 191587, UnitID = "target", Caster = "player"},--恶性瘟疫
		{AuraID = 194310, UnitID = "target", Caster = "player"},--溃烂之伤
		{AuraID = 196782, UnitID = "target", Caster = "player"},--爆发
		{AuraID = 199969, UnitID = "target", Caster = "player"},--游荡疫病
		{AuraID = 200646, UnitID = "target", Caster = "player"},--邪恶畸变
		{AuraID = 203173, UnitID = "target", Caster = "player"},--死亡锁链
		{AuraID = 204206, UnitID = "target", Caster = "player"},--冰冻
		{AuraID = 206891, UnitID = "target", Caster = "player"},--恐吓
		{AuraID = 206930, UnitID = "target", Caster = "player"},--心脏打击
		{AuraID = 206931, UnitID = "target", Caster = "player"},--饮血者
		{AuraID = 206940, UnitID = "target", Caster = "player"},--鲜血印记
		{AuraID = 207167, UnitID = "target", Caster = "player"},--致盲冰雨
		{AuraID = 210141, UnitID = "target", Caster = "player"},--僵尸爆破
		{AuraID = 211793, UnitID = "target", Caster = "player"},--冷酷严冬
		{AuraID = 212610, UnitID = "target", Caster = "player"},--行尸走肉
		{AuraID = 221562, UnitID = "target", Caster = "player"},--窒息
		{AuraID = 223929, UnitID = "target", Caster = "player", Value = true},--死疽伤口
		{AuraID = 233395, UnitID = "target", Caster = "player"},--严寒中心
		{AuraID = 233397, UnitID = "target", Caster = "player"},--神志不清
		{AuraID = 279303, UnitID = "target", Caster = "player"},--冰霜吐息
		{AuraID = 45524, UnitID = "target", Caster = "player"},--寒冰锁链
		{AuraID = 47476, UnitID = "target", Caster = "player"},--窒息
		{AuraID = 51399, UnitID = "target", Caster = "player"},--死亡之握
		{AuraID = 55078, UnitID = "target", Caster = "player"},--血之疫病
		{AuraID = 55095, UnitID = "target", Caster = "player"},--冰霜疫病
		{AuraID = 56222, UnitID = "target", Caster = "player"},--黑暗命令
	},
	["Player Special Aura"] = { -- 玩家重要光环组
		{AuraID = 115989, UnitID = "player"},--邪恶虫群
		{AuraID = 145629, UnitID = "player"},--反魔法领域
		{AuraID = 152279, UnitID = "player", Flash = true},--冰龙吐息
		{AuraID = 194679, UnitID = "player"},--符文分流
		{AuraID = 194844, UnitID = "player"},--白骨风暴
		{AuraID = 194879, UnitID = "player"},--冰冷之爪
		{AuraID = 195181, UnitID = "player"},--白骨之盾
		{AuraID = 196770, UnitID = "player"},--冷库严冬
		{AuraID = 207203, UnitID = "player", Value = true},--寒冰之盾
		{AuraID = 207289, UnitID = "player"},--邪恶狂乱
		{AuraID = 211805, UnitID = "player"},--风暴汇聚
		{AuraID = 212552, UnitID = "player"},--幽魂步
		{AuraID = 215711, UnitID = "player"},--灵魂收割
		{AuraID = 219809, UnitID = "player", Value = true},--墓石
		{AuraID = 233411, UnitID = "player"},--血债血偿
		{AuraID = 273947, UnitID = "player"},--鲜血禁闭
		{AuraID = 274009, UnitID = "player"},--饮血
		{AuraID = 279942, UnitID = "player"},--冻土行者
		{AuraID = 281209, UnitID = "player", Stack = 20, Flash = true, Combat = true},--冷酷之心
		{AuraID = 47568, UnitID = "player"},--符文武器增效
		{AuraID = 51124, UnitID = "player"},--杀戮机器
		{AuraID = 51271, UnitID = "player", Value = true},--冰霜之柱
		{AuraID = 51460, UnitID = "player"},--符文腐蚀
		{AuraID = 55233, UnitID = "player"},--吸血鬼之血
		{AuraID = 59052, UnitID = "player"},--白霜
		{AuraID = 63560, UnitID = "pet"},--黑暗突变
		{AuraID = 77535, UnitID = "player", Value = true},--鲜血护盾
		{AuraID = 81141, UnitID = "player"},--赤色天灾
		{AuraID = 81256, UnitID = "player"},--符文刃舞
		{AuraID = 81340, UnitID = "player"},--末日突降
	},
	["Spell CD"] = { -- 技能冷却计时组
		{SpellID = 108194},--窒息
		{SpellID = 108199},--血魔之握
		{SpellID = 127344},--邪爆
		{SpellID = 130736},--灵魂收割
		{SpellID = 152279},--冰龙吐息
		{SpellID = 194844},--白骨风暴
		{SpellID = 203173},--死亡锁链
		{SpellID = 204160},--寒冰联结
		{SpellID = 206940},--鲜血印记
		{SpellID = 207018},--杀戮意图
		{SpellID = 207167},--致盲冰雨
		{SpellID = 207289},--邪恶狂乱
		{SpellID = 210764},--符文打击
		{SpellID = 212552},--幽魂步
		{SpellID = 219809},--墓石
		{SpellID = 221562},--窒息
		{SpellID = 274156},--吞噬
		{SpellID = 275699},--天启
		{SpellID = 279302},--冰霜巨龙之怒
		{SpellID = 46584},--亡者复生
		{SpellID = 47476},--窒息
		{SpellID = 47528},--心灵冰冻
		{SpellID = 47568},--符文武器增效
		{SpellID = 48265},--死亡脚步
		{SpellID = 48707},--反魔法护罩
		{SpellID = 48743},--天灾契约
		{SpellID = 48792},--冰封之韧
		{SpellID = 49028},--符文刃舞
		{SpellID = 49206},--召唤石鬼像
		{SpellID = 49576},--死亡之握
		{SpellID = 51052},--反魔法领域
		{SpellID = 51271},--冰霜之柱
		{SpellID = 55233},--吸血鬼之血
		{SpellID = 56222},--黑暗命令
		{SpellID = 57330},--寒冬号角
		{SpellID = 61999},--复活盟友
		{SpellID = 63560},--黑暗突变
		{SpellID = 77606},--黑暗模拟
	},
}

module:AddNewAuraWatch("DEATHKNIGHT", list)