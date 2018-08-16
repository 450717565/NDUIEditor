local _, ns = ...
local B, C, L, DB = unpack(ns)
local module = B:GetModule("AurasTable")

-- DK的法术监控
local list = {
	["Player Aura"] = { -- 玩家光环组
		{AuraID = 3714, UnitID = "player"},--冰霜之路
		{AuraID = 48265, UnitID = "player"},--死亡脚步
		{AuraID = 48707, UnitID = "player"},--反魔法护罩
		{AuraID = 48792, UnitID = "player"},--冰封之韧
		{AuraID = 53365, UnitID = "player"},--不洁之力
		{AuraID = 101568, UnitID = "player"},--黑暗援助
		{AuraID = 111673, UnitID = "pet"},--控制亡灵
		{AuraID = 180612, UnitID = "player"},--最近使用过灵界打击
		{AuraID = 188290, UnitID = "player"},--枯萎凋零
	},
	["Target Aura"] = { -- 目标光环组
		{AuraID = 45524, UnitID = "target", Caster = "player"},--寒冰锁链
		{AuraID = 51399, UnitID = "target", Caster = "player"},--死亡之握
		{AuraID = 55078, UnitID = "target", Caster = "player"},--血之疫病
		{AuraID = 55095, UnitID = "target", Caster = "player"},--冰霜疫病
		{AuraID = 56222, UnitID = "target", Caster = "player"},--黑暗命令
		{AuraID = 108194, UnitID = "target", Caster = "player"},--窒息
		{AuraID = 130736, UnitID = "target", Caster = "player"},--灵魂收割
		{AuraID = 143375, UnitID = "target", Caster = "player"},--枯萎之握
		{AuraID = 156004, UnitID = "target", Caster = "player"},--亵渎
		{AuraID = 190780, UnitID = "target", Caster = "player"},--冰霜吐息
		{AuraID = 191587, UnitID = "target", Caster = "player"},--恶性瘟疫
		{AuraID = 191748, UnitID = "target", Caster = "player"},--诸界之灾
		{AuraID = 194310, UnitID = "target", Caster = "player"},--溃烂之伤
		{AuraID = 196782, UnitID = "target", Caster = "player"},--爆发
		{AuraID = 206930, UnitID = "target", Caster = "player"},--心脏打击
		{AuraID = 206931, UnitID = "target", Caster = "player"},--饮血者
		{AuraID = 206940, UnitID = "target", Caster = "player"},--鲜血印记
		{AuraID = 206977, UnitID = "target", Caster = "player"},--血之镜像
		{AuraID = 207167, UnitID = "target", Caster = "player"},--致盲冰雨
		{AuraID = 208278, UnitID = "target", Caster = "player"},--衰弱感染
		{AuraID = 211793, UnitID = "target", Caster = "player"},--冷酷严冬
		{AuraID = 212764, UnitID = "target", Caster = "player"},--苍白行者
		{AuraID = 221562, UnitID = "target", Caster = "player"},--窒息
		{AuraID = 248406, UnitID = "target", Caster = "player"},--冷酷之心
		--凛冬将至
		{AuraID = 207171, UnitID = "target", Caster = "player"},
		{AuraID = 211794, UnitID = "target", Caster = "player"},
	},
	["Player Special Aura"] = { -- 玩家重要光环组
		{AuraID = 51124, UnitID = "player"},--杀戮机器
		{AuraID = 51271, UnitID = "player"},--冰霜之柱
		{AuraID = 51460, UnitID = "player"},--符文腐蚀
		{AuraID = 55233, UnitID = "player"},--吸血鬼之血
		{AuraID = 59052, UnitID = "player"},--白霜
		{AuraID = 63560, UnitID = "pet"},--黑暗突变
		{AuraID = 77535, UnitID = "player", Value = true},--鲜血护盾
		{AuraID = 81141, UnitID = "player"},--赤色天灾
		{AuraID = 81256, UnitID = "player"},--符文刃舞
		{AuraID = 81340, UnitID = "player"},--末日突降
		{AuraID = 115989, UnitID = "player"},--邪恶虫群
		{AuraID = 152279, UnitID = "player"},--冰龙吐息
		{AuraID = 193320, UnitID = "player", Value = true},--永恒脐带
		{AuraID = 194679, UnitID = "player"},--符文分流
		{AuraID = 194844, UnitID = "player"},--白骨风暴
		{AuraID = 194879, UnitID = "player"},--冰冷之爪
		{AuraID = 194918, UnitID = "player"},--凋零符文武器
		{AuraID = 195181, UnitID = "player"},--白骨之盾
		{AuraID = 196770, UnitID = "player"},--冷库严冬
		{AuraID = 196770, UnitID = "player"},--冷酷严冬
		{AuraID = 204957, UnitID = "player"},--冰冻灵魂
		{AuraID = 205725, UnitID = "player"},--反魔法屏障
		{AuraID = 206977, UnitID = "player"},--鲜血镜像
		{AuraID = 47568, UnitID = "player"},--符文武器增效
		{AuraID = 207203, UnitID = "player", Value = true},--寒冰之盾
		{AuraID = 207256, UnitID = "player"},--湮灭
		{AuraID = 207289, UnitID = "player"},--邪恶狂乱
		{AuraID = 207319, UnitID = "player"},--血肉之盾
		{AuraID = 211805, UnitID = "player"},--风暴汇聚
		{AuraID = 212552, UnitID = "player"},--幽魂步
		{AuraID = 213003, UnitID = "player"},--灵魂吞噬
		{AuraID = 215377, UnitID = "player"},--巨口饿了
		{AuraID = 215711, UnitID = "player"},--灵魂收割
		{AuraID = 216974, UnitID = "player"},--坏疽
		{AuraID = 218100, UnitID = "player"},--亵渎
		{AuraID = 281209, UnitID = "player", Combat = true},--冷酷之心
		{AuraID = 219809, UnitID = "player", Value = true},--墓石
		{AuraID = 240558, UnitID = "player", Value = true},--饮魂者
		{AuraID = 253595, UnitID = "player", Combat = true},--酷寒突袭
		{AuraID = 273947, UnitID = "player"},--鲜血禁闭
		{AuraID = 274009, UnitID = "player"},--饮血
		{AuraID = 272723, UnitID = "player"},--冰霜堡垒
	},
	["Spell CD"] = { -- 技能冷却计时组
		{SpellID = 46584, UnitID = "player"},--亡者复生
		{SpellID = 47528, UnitID = "player"},--心灵冰冻
		{SpellID = 47568, UnitID = "player"},--符文武器增效
		{SpellID = 48707, UnitID = "player"},--反魔法护罩
		{SpellID = 48743, UnitID = "player"},--天灾契约
		{SpellID = 48792, UnitID = "player"},--冰封之韧
		{SpellID = 49028, UnitID = "player"},--符文刃舞
		{SpellID = 49206, UnitID = "player"},--召唤石鬼像
		{SpellID = 49576, UnitID = "player"},--死亡之握
		{SpellID = 51271, UnitID = "player"},--冰霜之柱
		{SpellID = 55233, UnitID = "player"},--吸血鬼之血
		{SpellID = 56222, UnitID = "player"},--黑暗命令
		{SpellID = 57330, UnitID = "player"},--寒冬号角
		{SpellID = 61999, UnitID = "player"},--复活盟友
		{SpellID = 63560, UnitID = "player"},--黑暗突变
		{SpellID = 108194, UnitID = "player"},--窒息
		{SpellID = 108199, UnitID = "player"},--血魔之握
		{SpellID = 127344, UnitID = "player"},--邪爆
		{SpellID = 130736, UnitID = "player"},--灵魂收割
		{SpellID = 152279, UnitID = "player"},--冰龙吐息
		{SpellID = 194844, UnitID = "player"},--白骨风暴
		{SpellID = 194918, UnitID = "player"},--凋零符文武器
		{SpellID = 206977, UnitID = "player"},--血之镜像
		{SpellID = 207167, UnitID = "player"},--致盲冰雨
		{SpellID = 207256, UnitID = "player"},--湮灭
		{SpellID = 207289, UnitID = "player"},--邪恶狂乱
		{SpellID = 207349, UnitID = "player"},--黑暗仲裁者
		{SpellID = 210764, UnitID = "player"},--符文打击
		{SpellID = 212552, UnitID = "player"},--幽魂步
		{SpellID = 219809, UnitID = "player"},--墓石
		{SpellID = 220143, UnitID = "player"},--天启
		{SpellID = 221562, UnitID = "player"},--窒息
		{SpellID = 274156, UnitID = "player"},--吞噬
		{SpellID = 279302, UnitID = "player"},--冰霜巨龙之怒
	},
}

module:AddNewAuraWatch("DEATHKNIGHT", list)