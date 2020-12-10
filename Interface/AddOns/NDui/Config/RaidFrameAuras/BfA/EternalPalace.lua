local _, ns = ...
local B, C, L, DB = unpack(ns)
local AT = B:GetModule("AurasTable")

local TIER = 8
local INSTANCE = 1179 -- 永恒王宫
local BOSS

BOSS = 2352 -- 深渊指挥官西瓦拉
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 294711) -- 冰霜烙印
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 294715) -- 剧毒烙印
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 295795) -- 冻结之血
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 300701) -- 白霜
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 300705) -- 败血之地
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 295348, 6) -- 溢流寒霜
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 295421, 6) -- 溢流毒液
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 300883) -- 倒置之疾
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 294847) -- 不稳定混合物
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 295807, 6) -- 冻结之血
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 295850, 6) -- 癫狂

BOSS = 2347 -- 黑水巨鳗
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 298428) -- 暴食
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 292127, 6) -- 墨黑深渊
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 292138) -- 辐光生物质
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 292167) -- 剧毒脊刺
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 301180) -- 冲流
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 298595) -- 发光的钉刺
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 292307, 6) -- 深渊凝视
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 301494) -- 尖锐脊刺

BOSS = 2353 -- 艾萨拉之辉
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 296566) -- 海潮之拳
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 296737, 6) -- 奥术炸弹
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 296746) -- 奥术炸弹
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 299152) -- 翻滚之水

BOSS = 2354 -- 艾什凡女勋爵
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 296725) -- 壶蔓猛击
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 296693) -- 浸水
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 296752) -- 锋利的珊瑚
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 302992) -- 咸水气泡
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 297333)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 297397)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 296938) -- 艾泽里特弧光
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 296941)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 296942)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 296939)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 296940)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 296943)

BOSS = 2351 -- 奥戈佐亚
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 298156) -- 麻痹钉刺
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 298459) -- 羊水喷发
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 295779, 6) -- 水舞长枪

BOSS = 2359 -- 女王法庭
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 303630) -- 爆裂之黯
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 301830) -- 帕什玛之触
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 301832) -- 疯狂热诚
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 296851, 6) -- 狂热裁决
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 299914) -- 狂热冲锋
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 300545) -- 力量决裂
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 304410, 6) -- 重复行动
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 304128) -- 缓刑
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 297586, 6) -- 承受折磨

BOSS = 2349 -- 扎库尔，尼奥罗萨先驱
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 298192) -- 黑暗虚空
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 295480) -- 心智锁链
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 295495)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 300133, 6) -- 折断
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 292963, 6) -- 惊惧
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 293509, 6) -- 惊惧
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 295327, 6) -- 碎裂心智
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 296018, 6) -- 癫狂惊惧
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 296015) -- 腐蚀谵妄

BOSS = 2361 -- 艾萨拉女王
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 298569) -- 干涸灵魂
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 298014) -- 冰爆
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 298018, 6) -- 冻结
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 298756) -- 锯齿之锋
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 298781) -- 奥术宝珠
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 303825, 6) -- 溺水
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 302999) -- 奥术易伤
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 303657, 6) -- 奥术震爆