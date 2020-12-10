local _, ns = ...
local B, C, L, DB = unpack(ns)
local AT = B:GetModule("AurasTable")

local TIER = 7 -- Legion
local INSTANCE = 946 -- 燃烧王座
local BOSS

BOSS = 1992	-- 加洛西灭世者
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 246220)	-- 邪能轰炸
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 244410)	-- 屠戮
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 245294)	-- 强化屠戮
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 246920)	-- 错乱屠戮
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 244590)	-- 炽熔邪能

BOSS = 1987	-- 萨格拉斯的恶犬
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 251445)	-- 闷烧
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 245098)	-- 腐蚀
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 244768)	-- 荒芜凝视
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 244072)	-- 熔火之触
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 244091)	-- 烧焦
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 248815)	-- 点燃
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 254429)	-- 黑暗压迫
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 248819)	-- 虹吸腐蚀
--AT:RegisterDebuff(TIER, INSTANCE, BOSS, 244055)	-- 暗影触痕
--AT:RegisterDebuff(TIER, INSTANCE, BOSS, 244054)	-- 烈焰触痕
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 245022)	-- 炽然

BOSS = 1997	-- 安托兰统帅议会
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 257974)	-- 混乱脉冲
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 244892)	-- 弱点攻击
--AT:RegisterDebuff(TIER, INSTANCE, BOSS, 253290)	-- 熵能爆裂
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 244737)	-- 震荡手雷
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 244748)	-- 震晕
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 244172, 5)	-- 灵能突袭
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 253306)	-- 灵能创伤
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 244910)	-- 邪能护盾

BOSS = 1985	-- 传送门守护者哈萨贝尔
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 244016)	-- 时空裂隙
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 246208)	-- 酸性之网
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 244613)	-- 永燃烈焰
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 244849)	-- 腐蚀烂泥
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 245075)	-- 饥饿幽影
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 245118)	-- 饱足幽影
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 244949, 5)	-- 邪丝缠缚
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 244915)	-- 吸取精华
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 245050)	-- 欺骗幻境
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 245040)	-- 腐蚀

BOSS = 2025	-- 生命的缚誓者艾欧娜尔
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 248795)	-- 邪能池
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 248332)	-- 邪能之雨
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 249017)	-- 反馈-奥术奇点
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 250693)	-- 奥能累积
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 249014)	-- 反馈-邪污足迹
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 250140)	-- 邪污足迹
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 249015)	-- 反馈-燃烧的余烬
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 250691)	-- 燃烧的余烬
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 249016)	-- 反馈-目标锁定

BOSS = 2009 -- 猎魂者伊墨纳尔
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 247367)	-- 震击之枪
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 250255)	-- 强化震击之枪
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 255029)	-- 催眠气罐
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 247565)	-- 催眠毒气
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 247687)	-- 撕裂
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 247932)	-- 霰弹爆破
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 248070)	-- 强化霰弹爆破
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 254183)	-- 灼伤皮肤
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 247641)	-- 静滞陷阱
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 250224)	-- 震晕
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 248321)	-- 洪荒烈火
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 247716)	-- 充能轰炸

BOSS = 2004 -- 金加洛斯
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 245919)	-- 熔铸之击
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 245770)	-- 屠戮
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 249686)	-- 轰鸣屠戮
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 246698)	-- 破坏

BOSS = 1983 -- 瓦里玛萨斯
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 243961)	-- 哀难
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 244005)	-- 黑暗裂隙
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 244094, 5)	-- 冥魂之拥
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 248732)	-- 毁灭回响
--AT:RegisterDebuff(TIER, INSTANCE, BOSS, 243968)	-- 烈焰折磨
--AT:RegisterDebuff(TIER, INSTANCE, BOSS, 243977)	-- 冰霜折磨
--AT:RegisterDebuff(TIER, INSTANCE, BOSS, 243980)	-- 邪能折磨
--AT:RegisterDebuff(TIER, INSTANCE, BOSS, 243973)	-- 暗影折磨

BOSS = 1986 -- 破坏魔女巫会
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 244899)	-- 火焰打击
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 245634)	-- 飞旋的军刀
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 253520)	-- 爆裂冲击
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 253020)	-- 黑暗风暴
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 245518)	-- 快速冻结
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 245586)	-- 冷凝之血
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 250757)	-- 宇宙之光
--AT:RegisterDebuff(TIER, INSTANCE, BOSS, 253753)	-- 恐惧
--AT:RegisterDebuff(TIER, INSTANCE, BOSS, 253697)	-- 冰霜之球
--AT:RegisterDebuff(TIER, INSTANCE, BOSS, 250097)	-- 阿曼苏尔的诡诈

BOSS = 1984 -- 阿格拉玛
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 245990)	-- 泰沙拉克之触
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 254452)	-- 饕餮烈焰
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 244736)	-- 烈焰之迹
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 244291)	-- 破敌者
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 255060)	-- 强化破敌者
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 247079, 5)	-- 强化撕裂烈焰
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 244912)	-- 烈焰喷薄

BOSS = 2031 -- 寂灭者阿古斯
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 248167)	-- 死亡之雾
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 248396)	-- 灵魂凋零
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 248499)	-- 巨镰横扫
--AT:RegisterDebuff(TIER, INSTANCE, BOSS, 258646)	-- 天空之赐
--AT:RegisterDebuff(TIER, INSTANCE, BOSS, 253903)	-- 天空之力
--AT:RegisterDebuff(TIER, INSTANCE, BOSS, 258647)	-- 海洋之赐
--AT:RegisterDebuff(TIER, INSTANCE, BOSS, 253901)	-- 海洋之力
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 250669)	-- 灵魂爆发
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 251570)	-- 灵魂炸弹
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 255199)	-- 阿格拉玛的化身
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 255200)	-- 阿格拉玛的恩赐
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 252729)	-- 宇宙射线
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 252616)	-- 宇宙道标
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 257299)	-- 怒火余烬
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 258039)	-- 死亡之镰
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 256899)	-- 灵魂引爆

BOSS = 0	-- 小怪
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 249297)	-- 重构之焰