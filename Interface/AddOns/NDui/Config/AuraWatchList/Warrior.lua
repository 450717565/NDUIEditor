local B, C, L, DB = unpack(select(2, ...))
local module = NDui:GetModule("AurasTable")

-- 战士的法术监控
local list = {
	["Player Aura"] = { -- 玩家光环组
		{AuraID =  32216, UnitID = "player"},--胜利
		{AuraID = 107574, UnitID = "player"},--天神下凡
		{AuraID =   1719, UnitID = "player"},--战吼
		{AuraID =  18499, UnitID = "player"},--狂暴之怒
		{AuraID = 202164, UnitID = "player"},--腾跃步伐
		{AuraID =  46924, UnitID = "player"},--剑刃风暴
	},
	["Target Aura"] = { -- 目标光环组
		{AuraID =    355, UnitID = "target", Caster = "player"},--嘲讽
		{AuraID = 105771, UnitID = "target", Caster = "player"},--冲锋：定身
		{AuraID =   7922, UnitID = "target", Caster = "player"},--冲锋：昏迷
		{AuraID =   1160, UnitID = "target", Caster = "player"},--挫志怒吼
		{AuraID = 115767, UnitID = "target", Caster = "player"},--重伤
		{AuraID =   6343, UnitID = "target", Caster = "player"},--雷霆一击
		{AuraID = 132169, UnitID = "target", Caster = "player"},--风暴之锤
		{AuraID = 132168, UnitID = "target", Caster = "player"},--震荡波
		{AuraID =  12323, UnitID = "target", Caster = "player"},--刺耳怒吼
		{AuraID =   5246, UnitID = "target", Caster = "player"},--破胆
		{AuraID = 208086, UnitID = "target", Caster = "player"},--巨人打击
		{AuraID =   1715, UnitID = "target", Caster = "player"},--断筋
		{AuraID = 115804, UnitID = "target", Caster = "player"},--致死之伤
		{AuraID =    772, UnitID = "target", Caster = "player"},--撕裂
		{AuraID = 113344, UnitID = "target", Caster = "player"},--浴血奋战
		{AuraID = 205546, UnitID = "target", Caster = "player"},--奥丁之怒
		{AuraID = 215537, UnitID = "target", Caster = "player"},--创伤
	},
	["Player Special Aura"] = { -- 玩家重要光环组
		{AuraID = 215570, UnitID = "player"},--摧枯拉朽
		{AuraID = 200954, UnitID = "player"},--战争疤痕
		{AuraID = 184362, UnitID = "player"},--激怒
		{AuraID = 202225, UnitID = "player"},--狂怒冲锋
		{AuraID = 215572, UnitID = "player"},--暴乱狂战士
		{AuraID =  12292, UnitID = "player"},--浴血奋战
		{AuraID = 202539, UnitID = "player"},--狂乱
		{AuraID = 206333, UnitID = "player"},--血腥气息
		{AuraID = 118000, UnitID = "player"},--巨龙怒吼
		{AuraID = 200977, UnitID = "player"},--无匹之力
		{AuraID =  85739, UnitID = "player"},--血肉顺劈
		{AuraID = 184364, UnitID = "player"},--狂暴回复
		{AuraID = 200986, UnitID = "player"},--奥丁的勇士
		{AuraID = 201009, UnitID = "player"},--主宰
		{AuraID = 215562, UnitID = "player"},--战争机器
		{AuraID = 206316, UnitID = "player"},--屠杀
		{AuraID = 200979, UnitID = "player"},--感受死亡
		{AuraID = 200953, UnitID = "player"},--狂暴
		{AuraID = 118038, UnitID = "player"},--剑在人在
		{AuraID = 197690, UnitID = "player"},--防御姿态
		{AuraID = 188923, UnitID = "player"},--顺劈斩
		{AuraID =  60503, UnitID = "player"},--压制
		{AuraID = 209706, UnitID = "player"},--粉碎防御
		{AuraID = 209484, UnitID = "player"},--战术优势
		{AuraID = 207982, UnitID = "player"},--怒火聚焦：武器
		{AuraID = 202289, UnitID = "player"},--狂暴复兴
		{AuraID = 125565, UnitID = "player"},--挫志怒吼
		{AuraID = 227744, UnitID = "player"},--破坏者
		{AuraID = 203524, UnitID = "player"},--奈萨里奥之怒
		{AuraID =  23920, UnitID = "player"},--法术反射
		{AuraID =    871, UnitID = "player"},--盾墙
		{AuraID =  12975, UnitID = "player"},--破釜沉舟
		{AuraID = 132404, UnitID = "player"},--盾牌格挡
		{AuraID = 122510, UnitID = "player"},--最后通牒
		{AuraID = 202602, UnitID = "player"},--投入战斗
		{AuraID = 188783, UnitID = "player"},--维库之力
		{AuraID = 204488, UnitID = "player"},--怒火聚焦：防护
		{AuraID = 203581, UnitID = "player"},--龙鳞
		{AuraID = 189064, UnitID = "player"},--大地之鳞
		{AuraID = 190456, UnitID = "player", Value = true},--无视痛苦
		--报复
		{AuraID = 202573, UnitID = "player"},
		{AuraID = 202574, UnitID = "player"},
	},
	["Spell CD"] = { -- 技能冷却计时组
		{SpellID =  46968, UnitID = "player"},--震荡波
		{SpellID = 107570, UnitID = "player"},--风暴之锤
		{SpellID = 107574, UnitID = "player"},--天神下凡
		{SpellID =  12292, UnitID = "player"},--浴血奋战
		{SpellID = 118000, UnitID = "player"},--巨龙咆哮
		{SpellID = 197690, UnitID = "player"},--防御姿态
		{SpellID = 202168, UnitID = "player"},--胜利在望
		{SpellID = 205545, UnitID = "player"},--奥丁之怒
		{SpellID = 209577, UnitID = "player"},--灭战者
		{SpellID = 203524, UnitID = "player"},--奈萨里奥之怒
		{SpellID =    100, UnitID = "player"},--冲锋
		{SpellID =  97462, UnitID = "player"},--命令怒吼
		{SpellID =    355, UnitID = "player"},--嘲讽
		{SpellID =   1719, UnitID = "player"},--战吼
		{SpellID =   6552, UnitID = "player"},--拳击
		{SpellID = 184364, UnitID = "player"},--狂怒回复
		{SpellID =  18499, UnitID = "player"},--狂暴之怒
		{SpellID =   5246, UnitID = "player"},--破胆怒吼
		{SpellID =  57755, UnitID = "player"},--英勇投掷
		{SpellID =   6544, UnitID = "player"},--英勇飞跃
		{SpellID = 118038, UnitID = "player"},--剑在人在
		{SpellID = 167105, UnitID = "player"},--巨人打击
		{SpellID = 198304, UnitID = "player"},--援护
		{SpellID =   1160, UnitID = "player"},--挫志怒吼
		{SpellID =  23920, UnitID = "player"},--法术反射
		{SpellID =    871, UnitID = "player"},--盾墙
		{SpellID =   2565, UnitID = "player"},--盾牌格挡
		{SpellID =  12975, UnitID = "player"},--破釜沉舟
		--破坏者
		{SpellID = 152277, UnitID = "player"},
		{SpellID = 228920, UnitID = "player"},
		--剑刃风暴
		{SpellID =  46924, UnitID = "player"},
		{SpellID = 227847, UnitID = "player"},
	},
}

module:AddNewAuraWatch("WARRIOR", list)