local _, ns = ...
local B, C, L, DB = unpack(ns)
local module = B:GetModule("AurasTable")

-- 武僧的法术监控
local list = {
	["Player Aura"] = { -- 玩家光环组
		{AuraID = 119085, UnitID = "player"},--真气突
		{AuraID = 101643, UnitID = "player"},--魂体双分
		{AuraID = 196608, UnitID = "player"},--猛虎之眼
		{AuraID = 116841, UnitID = "player"},--迅如猛虎
		{AuraID = 122278, UnitID = "player"},--躯不坏
		{AuraID = 122783, UnitID = "player"},--散魔功
		{AuraID = 101546, UnitID = "player"},--神鹤引项踢
		--碧玉疾风
		{AuraID = 116847, UnitID = "player"},
		{AuraID = 196725, UnitID = "player"},
	},
	["Target Aura"] = { -- 目标光环组
		{AuraID = 196608, UnitID = "target", Caster = "player"},--猛虎之眼
		{AuraID = 213063, UnitID = "target", Caster = "player"},--月之暗面
		{AuraID = 228287, UnitID = "target", Caster = "player"},--神鹤印记
		{AuraID = 117952, UnitID = "target", Caster = "player"},--碎玉闪电
		{AuraID = 116189, UnitID = "target", Caster = "player"},--豪镇八方
		{AuraID = 115804, UnitID = "target", Caster = "player"},--致死之伤
		{AuraID = 115080, UnitID = "target", Caster = "player", Value = true},--轮回之触
		{AuraID = 123586, UnitID = "target", Caster = "player"},--翔龙在天
		{AuraID = 205320, UnitID = "target", Caster = "player"},--风领主之击
		{AuraID = 116841, UnitID = "target", Caster = "player"},--迅如猛虎
		{AuraID = 119381, UnitID = "target", Caster = "player"},--扫堂腿
		{AuraID = 121253, UnitID = "target", Caster = "player"},--醉酿投
		{AuraID = 214326, UnitID = "target", Caster = "player"},--爆炸酒桶
		{AuraID = 123725, UnitID = "target", Caster = "player"},--火焰之息
		{AuraID = 116849, UnitID = "target", Caster = "player", Value = true},--作茧缚命
		{AuraID = 119611, UnitID = "target", Caster = "player"},--复苏之雾
		{AuraID = 198909, UnitID = "target", Caster = "player"},--赤精之歌
		{AuraID = 199387, UnitID = "target", Caster = "player"},--魂体束缚
		{AuraID = 124682, UnitID = "target", Caster = "player"},--氤氲之雾
		{AuraID = 191840, UnitID = "target", Caster = "player"},--精华之泉
		{AuraID = 196733, UnitID = "target", Caster = "player"},--特别快递
		--金刚震
		{AuraID = 116706, UnitID = "target", Caster = "player"},
		{AuraID = 116095, UnitID = "target", Caster = "player"},
		--业报之触
		{AuraID = 122470, UnitID = "target", Caster = "player"},
		{AuraID = 124280, UnitID = "target", Caster = "player", Value = true},
	},
	["Player Special Aura"] = { -- 玩家重要光环组
		{AuraID = 125174, UnitID = "player"},--业报之触
		{AuraID = 242387, UnitID = "player"},--雷拳之怒
		{AuraID = 115176, UnitID = "player"},--禅悟冥想
		{AuraID = 199668, UnitID = "player"},--玉珑的祝福
		{AuraID = 213177, UnitID = "player"},--利涉大川
		{AuraID = 213341, UnitID = "player"},--胆略
		{AuraID = 227678, UnitID = "player"},--天才学徒
		{AuraID = 199407, UnitID = "player"},--脚步轻盈
		{AuraID = 213114, UnitID = "player"},--隐世大师的禁忌之触
		{AuraID = 195321, UnitID = "player"},--转化力量
		{AuraID = 129914, UnitID = "player", Combat = true},--力贯千钧
		{AuraID = 116768, UnitID = "player"},--幻灭踢
		{AuraID = 137639, UnitID = "player"},--风火雷电
		{AuraID = 152173, UnitID = "player"},--屏气凝神
		{AuraID = 120954, UnitID = "player"},--壮胆酒
		{AuraID = 215479, UnitID = "player"},--铁骨酒
		{AuraID = 214373, UnitID = "player"},--酒有余香
		{AuraID = 199888, UnitID = "player"},--神龙之雾
		{AuraID = 197206, UnitID = "player"},--升腾状态
		{AuraID = 116680, UnitID = "player"},--雷光茶
		{AuraID = 197908, UnitID = "player"},--法力茶
		{AuraID = 196741, UnitID = "player"},--连击
		{AuraID = 247255, UnitID = "player"},--点穴踢
		{AuraID = 228563, UnitID = "player"},--幻灭连击
		{AuraID = 195630, UnitID = "player"},--醉拳大师
		{AuraID = 195381, UnitID = "player"},--治疗之风
		{AuraID = 202090, UnitID = "player"},--禅院教诲
		--生生不息
		{AuraID = 197916, UnitID = "player"},
		{AuraID = 197919, UnitID = "player"},
		--橙装效果
		{AuraID = 216509, UnitID = "player", Text = "双重复苏"},
		{AuraID = 216992, UnitID = "player", Text = "三倍贯通"},
		{AuraID = 216995, UnitID = "player", Text = "瞬发氤氲"},
		{AuraID = 217000, UnitID = "player", Text = "加速泉水"},
		{AuraID = 217006, UnitID = "player", Text = "免费活血"},
	},
	["Spell CD"] = { -- 技能冷却计时组
		{SpellID = 123986, UnitID = "player"},--真气爆裂
		{SpellID = 115098, UnitID = "player"},--真气波
		{SpellID = 115008, UnitID = "player"},--真气突
		{SpellID = 116841, UnitID = "player"},--迅如猛虎
		{SpellID = 115288, UnitID = "player"},--豪能酒
		{SpellID = 116844, UnitID = "player"},--平心之环
		{SpellID = 119381, UnitID = "player"},--扫堂腿
		{SpellID = 122281, UnitID = "player"},--金创药
		{SpellID = 122783, UnitID = "player"},--散魔功
		{SpellID = 122278, UnitID = "player"},--躯不坏
		{SpellID = 123904, UnitID = "player"},--白虎下凡
		{SpellID = 152173, UnitID = "player"},--屏气凝神
		{SpellID = 115399, UnitID = "player"},--玄牛酒
		{SpellID = 115315, UnitID = "player"},--玄牛雕像
		{SpellID = 132578, UnitID = "player"},--玄牛砮皂
		{SpellID = 124081, UnitID = "player"},--禅意波
		{SpellID = 197945, UnitID = "player"},--踏雾而行
		{SpellID = 198898, UnitID = "player"},--赤精之歌
		{SpellID = 198664, UnitID = "player"},--朱鹤赤精
		{SpellID = 115313, UnitID = "player"},--青龙雕像
		{SpellID = 197908, UnitID = "player"},--法力茶
		{SpellID = 122470, UnitID = "player"},--业报之触
		{SpellID = 115078, UnitID = "player"},--分筋错骨
		{SpellID = 116705, UnitID = "player"},--切喉手
		{SpellID = 115546, UnitID = "player"},--嚎镇八方
		{SpellID = 109132, UnitID = "player"},--滚地翻
		{SpellID = 101545, UnitID = "player"},--翔龙在天
		{SpellID = 115080, UnitID = "player"},--轮回之触
		{SpellID = 137639, UnitID = "player"},--风火雷电
		{SpellID = 101643, UnitID = "player"},--魂体双分
		{SpellID = 119996, UnitID = "player"},--魂体双分：转移
		{SpellID = 115203, UnitID = "player"},--壮胆酒
		{SpellID = 115310, UnitID = "player"},--还魂术
		{SpellID = 115181, UnitID = "player"},--火焰之息
		{SpellID = 115176, UnitID = "player"},--禅悟冥想
		{SpellID = 116849, UnitID = "player"},--作茧缚命
		{SpellID = 115151, UnitID = "player"},--复苏之雾
		{SpellID = 116680, UnitID = "player"},--雷光聚神茶
		{SpellID = 205320, UnitID = "player"},--风领主之击
		{SpellID = 214326, UnitID = "player"},--爆炸酒桶
		--清创生血
		{SpellID = 218146, UnitID = "player"},
		{SpellID = 115450, UnitID = "player"},
	},
}

module:AddNewAuraWatch("MONK", list)