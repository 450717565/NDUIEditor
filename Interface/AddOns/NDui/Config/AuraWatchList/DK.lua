local _, ns = ...
local B, C, L, DB = unpack(ns)
local AT = B:GetModule("AurasTable")

-- DK的法术监控
local list = {
	["Player Aura"] = { -- 玩家光环组
		{AuraID =  48707, UnitID = "player", Value = true}, -- 反魔法护罩
		{AuraID = 326867, UnitID = "player", Value = true}, -- 护咒符文
		{AuraID =   3714, UnitID = "player"}, -- 冰霜之路
		{AuraID =  48265, UnitID = "player"}, -- 死亡脚步
		{AuraID =  48792, UnitID = "player"}, -- 冰封之韧
		{AuraID =  49039, UnitID = "player"}, -- 巫妖之躯
		{AuraID =  53365, UnitID = "player"}, -- 不洁之力
		{AuraID = 101568, UnitID = "player"}, -- 黑暗援助
		{AuraID = 188290, UnitID = "player"}, -- 枯萎凋零
		{AuraID = 212552, UnitID = "player"}, -- 幻影步
		{AuraID = 326808, UnitID = "player"}, -- 鲜血符文
		{AuraID = 326868, UnitID = "player"}, -- 倦怠
		{AuraID = 326918, UnitID = "player"}, -- 癔狂符文
		{AuraID = 326984, UnitID = "player"}, -- 无尽渴求符文
	},
	["Target Aura"] = { -- 目标光环组
		{AuraID =  51714, UnitID = "target", Caster = "player"}, -- 锋锐之霜
		{AuraID =  45524, UnitID = "target", Caster = "player"}, -- 寒冰锁链
		{AuraID =  51399, UnitID = "target", Caster = "player"}, -- 死亡之握
		{AuraID =  55078, UnitID = "target", Caster = "player"}, -- 血之疫病
		{AuraID =  55095, UnitID = "target", Caster = "player"}, -- 冰霜疫病
		{AuraID =  56222, UnitID = "target", Caster = "player"}, -- 黑暗命令
		{AuraID = 108194, UnitID = "target", Caster = "player"}, -- 窒息
		{AuraID = 115994, UnitID = "target", Caster = "player"}, -- 黑暗虫群
		{AuraID = 191587, UnitID = "target", Caster = "player"}, -- 恶性瘟疫
		{AuraID = 194310, UnitID = "target", Caster = "player"}, -- 溃烂之伤
		{AuraID = 206930, UnitID = "target", Caster = "player"}, -- 心脏打击
		{AuraID = 206931, UnitID = "target", Caster = "player"}, -- 饮血者
		{AuraID = 206940, UnitID = "target", Caster = "player"}, -- 鲜血印记
		{AuraID = 207167, UnitID = "target", Caster = "player"}, -- 致盲冰雨
		{AuraID = 211793, UnitID = "target", Caster = "player"}, -- 冷酷严冬
		{AuraID = 221562, UnitID = "target", Caster = "player"}, -- 窒息
		{AuraID = 273977, UnitID = "target", Caster = "player"}, -- 亡者之握
		{AuraID = 279303, UnitID = "target", Caster = "player"}, -- 冰霜巨龙之怒
		{AuraID = 343294, UnitID = "target", Caster = "player"}, -- 灵魂收割
	},
	["Special Aura"] = { -- 玩家重要光环组
		{AuraID =  77535, UnitID = "player", Value = true}, -- 鲜血护盾
		{AuraID = 152279, UnitID = "player", Flash = true}, -- 冰龙吐息
		{AuraID = 194679, UnitID = "player", Flash = true}, -- 符文分流
		{AuraID = 207203, UnitID = "player", Value = true}, -- 寒冰之盾
		{AuraID = 219809, UnitID = "player", Value = true}, -- 墓石
		{AuraID = 253595, UnitID = "player", Combat = true}, -- 酷寒突袭
		{AuraID = 281209, UnitID = "player", Combat = true}, -- 冷酷之心
		{AuraID =  47568, UnitID = "player"}, -- 符文武器增效
		{AuraID =  51124, UnitID = "player"}, -- 杀戮机器
		{AuraID =  51271, UnitID = "player"}, -- 冰霜之柱
		{AuraID =  51460, UnitID = "player"}, -- 符文腐蚀
		{AuraID =  55233, UnitID = "player"}, -- 吸血鬼之血
		{AuraID =  59052, UnitID = "player"}, -- 白霜
		{AuraID =  81141, UnitID = "player"}, -- 赤色天灾
		{AuraID =  81256, UnitID = "player"}, -- 符文刃舞
		{AuraID =  81340, UnitID = "player"}, -- 末日突降
		{AuraID = 115989, UnitID = "player"}, -- 黑暗虫群
		{AuraID = 194844, UnitID = "player"}, -- 白骨风暴
		{AuraID = 194879, UnitID = "player"}, -- 冰冷之爪
		{AuraID = 195181, UnitID = "player"}, -- 白骨之盾
		{AuraID = 196770, UnitID = "player"}, -- 冷酷严冬
		{AuraID = 207289, UnitID = "player"}, -- 邪恶狂乱
		{AuraID = 211805, UnitID = "player"}, -- 风暴汇聚
		{AuraID = 235599, UnitID = "player"}, -- 冷酷之心
		{AuraID = 273947, UnitID = "player"}, -- 鲜血禁闭
		{AuraID = 274009, UnitID = "player"}, -- 饮血
		{AuraID = 319255, UnitID = "player"}, -- 秽邪契约
		{AuraID = 321995, UnitID = "player"}, -- 霜符灵气
		{AuraID =  63560, UnitID = "pet"}, -- 黑暗突变
	},
}

AT:AddNewAuraWatch("DEATHKNIGHT", list)