local _, ns = ...
local B, C, L, DB = unpack(ns)
local AT = B:GetModule("AurasTable")

local TIER = 8 -- BfA
local INSTANCE -- 5人本

INSTANCE = 1023 -- 围攻伯拉勒斯
AT:RegisterDebuff(TIER, INSTANCE, 0, 257169) -- 恐惧咆哮
AT:RegisterDebuff(TIER, INSTANCE, 0, 257168) -- 诅咒挥砍
AT:RegisterDebuff(TIER, INSTANCE, 0, 272588) -- 腐烂伤口
AT:RegisterDebuff(TIER, INSTANCE, 0, 272571) -- 窒息之水
AT:RegisterDebuff(TIER, INSTANCE, 0, 274991) -- 腐败之水
AT:RegisterDebuff(TIER, INSTANCE, 0, 275835) -- 钉刺之毒覆膜
AT:RegisterDebuff(TIER, INSTANCE, 0, 273930) -- 妨害切割
AT:RegisterDebuff(TIER, INSTANCE, 0, 257292) -- 沉重挥砍
AT:RegisterDebuff(TIER, INSTANCE, 0, 261428) -- 刽子手的套索
AT:RegisterDebuff(TIER, INSTANCE, 0, 256897) -- 咬合之颚
AT:RegisterDebuff(TIER, INSTANCE, 0, 272874) -- 践踏
AT:RegisterDebuff(TIER, INSTANCE, 0, 273470) -- 一枪毙命
AT:RegisterDebuff(TIER, INSTANCE, 0, 272834) -- 粘稠的口水
AT:RegisterDebuff(TIER, INSTANCE, 0, 272713) -- 碾压重击

INSTANCE = 1022 -- 地渊孢林
AT:RegisterDebuff(TIER, INSTANCE, 0, 278961, 6) -- 衰弱意志
AT:RegisterDebuff(TIER, INSTANCE, 0, 265468) -- 枯萎诅咒
AT:RegisterDebuff(TIER, INSTANCE, 0, 259714) -- 腐烂孢子
AT:RegisterDebuff(TIER, INSTANCE, 0, 272180) -- 湮灭之球
AT:RegisterDebuff(TIER, INSTANCE, 0, 272609) -- 疯狂凝视
AT:RegisterDebuff(TIER, INSTANCE, 0, 269301) -- 腐败之血
AT:RegisterDebuff(TIER, INSTANCE, 0, 265533) -- 鲜血之喉
AT:RegisterDebuff(TIER, INSTANCE, 0, 265019) -- 狂野顺劈斩
AT:RegisterDebuff(TIER, INSTANCE, 0, 265377) -- 抓钩诱捕
AT:RegisterDebuff(TIER, INSTANCE, 0, 265625) -- 黑暗预兆
AT:RegisterDebuff(TIER, INSTANCE, 0, 260685) -- 戈霍恩之蚀
AT:RegisterDebuff(TIER, INSTANCE, 0, 266107) -- 嗜血成性
AT:RegisterDebuff(TIER, INSTANCE, 0, 260455) -- 锯齿利牙

INSTANCE = 1030 -- 塞塔里斯神庙
AT:RegisterDebuff(TIER, INSTANCE, 0, 269686) -- 瘟疫
AT:RegisterDebuff(TIER, INSTANCE, 0, 268013) -- 烈焰震击
AT:RegisterDebuff(TIER, INSTANCE, 0, 268008) -- 毒蛇诱惑
AT:RegisterDebuff(TIER, INSTANCE, 0, 273563) -- 神经毒素
AT:RegisterDebuff(TIER, INSTANCE, 0, 272657) -- 毒性吐息
AT:RegisterDebuff(TIER, INSTANCE, 0, 267027) -- 细胞毒素
AT:RegisterDebuff(TIER, INSTANCE, 0, 272699) -- 毒性喷吐
AT:RegisterDebuff(TIER, INSTANCE, 0, 263371) -- 导电
AT:RegisterDebuff(TIER, INSTANCE, 0, 272655) -- 黄沙冲刷
AT:RegisterDebuff(TIER, INSTANCE, 0, 263914) -- 盲目之沙
AT:RegisterDebuff(TIER, INSTANCE, 0, 263958) -- 缠绕的蛇群
AT:RegisterDebuff(TIER, INSTANCE, 0, 266923) -- 充电
AT:RegisterDebuff(TIER, INSTANCE, 0, 268007) -- 心脏打击

INSTANCE = 1002 -- 托尔达戈
AT:RegisterDebuff(TIER, INSTANCE, 0, 260067, 6) -- 恶毒槌击
AT:RegisterDebuff(TIER, INSTANCE, 0, 258128) -- 衰弱怒吼
AT:RegisterDebuff(TIER, INSTANCE, 0, 265889) -- 火把攻击
AT:RegisterDebuff(TIER, INSTANCE, 0, 257791) -- 恐惧咆哮
AT:RegisterDebuff(TIER, INSTANCE, 0, 258864) -- 火力压制
AT:RegisterDebuff(TIER, INSTANCE, 0, 257028) -- 点火器
AT:RegisterDebuff(TIER, INSTANCE, 0, 258917) -- 正义烈焰
AT:RegisterDebuff(TIER, INSTANCE, 0, 257777) -- 断筋剃刀
AT:RegisterDebuff(TIER, INSTANCE, 0, 258079) -- 巨口噬咬
AT:RegisterDebuff(TIER, INSTANCE, 0, 258058) -- 挤压
AT:RegisterDebuff(TIER, INSTANCE, 0, 260016) -- 瘙痒叮咬
AT:RegisterDebuff(TIER, INSTANCE, 0, 257119) -- 流沙陷阱
AT:RegisterDebuff(TIER, INSTANCE, 0, 258313) -- 手铐
AT:RegisterDebuff(TIER, INSTANCE, 0, 259711) -- 全面紧闭
AT:RegisterDebuff(TIER, INSTANCE, 0, 256201) -- 爆炎弹
AT:RegisterDebuff(TIER, INSTANCE, 0, 256101) -- 爆炸
AT:RegisterDebuff(TIER, INSTANCE, 0, 256044) -- 致命狙击
AT:RegisterDebuff(TIER, INSTANCE, 0, 256474) -- 竭心毒剂

INSTANCE = 1012 -- 暴富矿区
AT:RegisterDebuff(TIER, INSTANCE, 0, 263074) -- 溃烂撕咬
AT:RegisterDebuff(TIER, INSTANCE, 0, 280605) -- 脑部冻结
AT:RegisterDebuff(TIER, INSTANCE, 0, 257337) -- 电击之爪
AT:RegisterDebuff(TIER, INSTANCE, 0, 270882) -- 炽然的艾泽里特
AT:RegisterDebuff(TIER, INSTANCE, 0, 268797) -- 转化：敌人变粘液
AT:RegisterDebuff(TIER, INSTANCE, 0, 259856) -- 化学灼烧
AT:RegisterDebuff(TIER, INSTANCE, 0, 269302) -- 淬毒之刃
AT:RegisterDebuff(TIER, INSTANCE, 0, 280604) -- 冰镇汽水
AT:RegisterDebuff(TIER, INSTANCE, 0, 257371) -- 催泪毒气
AT:RegisterDebuff(TIER, INSTANCE, 0, 257544) -- 锯齿切割
AT:RegisterDebuff(TIER, INSTANCE, 0, 268846) -- 回声之刃
AT:RegisterDebuff(TIER, INSTANCE, 0, 262794) -- 能量鞭笞
AT:RegisterDebuff(TIER, INSTANCE, 0, 262513) -- 艾泽里特觅心者
AT:RegisterDebuff(TIER, INSTANCE, 0, 260829) -- 自控导弹
AT:RegisterDebuff(TIER, INSTANCE, 0, 260838)
AT:RegisterDebuff(TIER, INSTANCE, 0, 263637) -- 晾衣绳

INSTANCE = 1021 -- 维克雷斯庄园
AT:RegisterDebuff(TIER, INSTANCE, 0, 260741, 6) -- 锯齿荨麻
AT:RegisterDebuff(TIER, INSTANCE, 0, 260703) -- 不稳定的符文印记
AT:RegisterDebuff(TIER, INSTANCE, 0, 263905) -- 符文劈斩
AT:RegisterDebuff(TIER, INSTANCE, 0, 265880) -- 恐惧印记
AT:RegisterDebuff(TIER, INSTANCE, 0, 265882) -- 萦绕恐惧
AT:RegisterDebuff(TIER, INSTANCE, 0, 264105) -- 符文印记
AT:RegisterDebuff(TIER, INSTANCE, 0, 264050) -- 被感染的荆棘
AT:RegisterDebuff(TIER, INSTANCE, 0, 261440) -- 恶性病原体
AT:RegisterDebuff(TIER, INSTANCE, 0, 263891) -- 缠绕荆棘
AT:RegisterDebuff(TIER, INSTANCE, 0, 264378) -- 碎裂灵魂
AT:RegisterDebuff(TIER, INSTANCE, 0, 266035) -- 碎骨片
AT:RegisterDebuff(TIER, INSTANCE, 0, 266036) -- 吸取精华
AT:RegisterDebuff(TIER, INSTANCE, 0, 260907) -- 灵魂操控
AT:RegisterDebuff(TIER, INSTANCE, 0, 264556) -- 刺裂打击
AT:RegisterDebuff(TIER, INSTANCE, 0, 265760) -- 荆棘弹幕
AT:RegisterDebuff(TIER, INSTANCE, 0, 260551) -- 灵魂荆棘
AT:RegisterDebuff(TIER, INSTANCE, 0, 263943) -- 蚀刻
AT:RegisterDebuff(TIER, INSTANCE, 0, 265881) -- 腐烂之触
AT:RegisterDebuff(TIER, INSTANCE, 0, 261438) -- 污秽攻击
AT:RegisterDebuff(TIER, INSTANCE, 0, 268202) -- 死亡棱镜
AT:RegisterDebuff(TIER, INSTANCE, 0, 268086) -- 恐怖光环

INSTANCE = 1001 -- 自由镇
AT:RegisterDebuff(TIER, INSTANCE, 0, 258875, 6) -- 眩晕酒桶
AT:RegisterDebuff(TIER, INSTANCE, 0, 274389) -- 捕鼠陷阱
AT:RegisterDebuff(TIER, INSTANCE, 0, 258323) -- 感染之伤
AT:RegisterDebuff(TIER, INSTANCE, 0, 257775) -- 瘟疫步
AT:RegisterDebuff(TIER, INSTANCE, 0, 257908, 6) -- 浸油之刃
AT:RegisterDebuff(TIER, INSTANCE, 0, 257436) -- 毒性打击
AT:RegisterDebuff(TIER, INSTANCE, 0, 274555) -- 污染之咬
AT:RegisterDebuff(TIER, INSTANCE, 0, 256363) -- 裂伤拳
AT:RegisterDebuff(TIER, INSTANCE, 0, 281357, 1) -- 水鼠啤酒
AT:RegisterDebuff(TIER, INSTANCE, 0, 278467, 3) -- 腐蚀酒

INSTANCE = 1041 -- 诸王之眠
AT:RegisterDebuff(TIER, INSTANCE, 0, 265773) -- 吐金
AT:RegisterDebuff(TIER, INSTANCE, 0, 271640) -- 黑暗启示
AT:RegisterDebuff(TIER, INSTANCE, 0, 270492) -- 妖术
AT:RegisterDebuff(TIER, INSTANCE, 0, 267763) -- 恶疾排放
AT:RegisterDebuff(TIER, INSTANCE, 0, 276031) -- 深渊绝望
AT:RegisterDebuff(TIER, INSTANCE, 0, 270920) -- 诱惑
AT:RegisterDebuff(TIER, INSTANCE, 0, 270865) -- 隐秘刀刃
AT:RegisterDebuff(TIER, INSTANCE, 0, 271564) -- 防腐液
AT:RegisterDebuff(TIER, INSTANCE, 0, 270507) -- 毒幕
AT:RegisterDebuff(TIER, INSTANCE, 0, 267273) -- 毒性新星
AT:RegisterDebuff(TIER, INSTANCE, 0, 270003) -- 压制猛击
AT:RegisterDebuff(TIER, INSTANCE, 0, 270084) -- 飞斧弹幕
AT:RegisterDebuff(TIER, INSTANCE, 0, 267618) -- 排干体液
AT:RegisterDebuff(TIER, INSTANCE, 0, 267626) -- 干枯
AT:RegisterDebuff(TIER, INSTANCE, 0, 270487) -- 切裂之刃
AT:RegisterDebuff(TIER, INSTANCE, 0, 266238) -- 粉碎防御
AT:RegisterDebuff(TIER, INSTANCE, 0, 266231) -- 斩首之斧
AT:RegisterDebuff(TIER, INSTANCE, 0, 266191) -- 回旋飞斧
AT:RegisterDebuff(TIER, INSTANCE, 0, 272388) -- 暗影弹幕
AT:RegisterDebuff(TIER, INSTANCE, 0, 268796) -- 穿刺长矛
AT:RegisterDebuff(TIER, INSTANCE, 0, 270289) -- 净化光线

INSTANCE = 968 -- 阿塔达萨
AT:RegisterDebuff(TIER, INSTANCE, 0, 252781) -- 不稳定的妖术
AT:RegisterDebuff(TIER, INSTANCE, 0, 250096) -- 毁灭痛苦
AT:RegisterDebuff(TIER, INSTANCE, 0, 253562) -- 野火
AT:RegisterDebuff(TIER, INSTANCE, 0, 255582) -- 熔化的黄金
AT:RegisterDebuff(TIER, INSTANCE, 0, 255041) -- 惊骇尖啸
AT:RegisterDebuff(TIER, INSTANCE, 0, 255371) -- 恐惧之面
AT:RegisterDebuff(TIER, INSTANCE, 0, 252687) -- 毒牙攻击
AT:RegisterDebuff(TIER, INSTANCE, 0, 254959) -- 灵魂燃烧
AT:RegisterDebuff(TIER, INSTANCE, 0, 255814) -- 撕裂重殴
AT:RegisterDebuff(TIER, INSTANCE, 0, 255421) -- 吞噬
AT:RegisterDebuff(TIER, INSTANCE, 0, 255434) -- 锯齿
AT:RegisterDebuff(TIER, INSTANCE, 0, 256577) -- 灵魂盛宴
AT:RegisterDebuff(TIER, INSTANCE, 0, 255558) -- 污血

INSTANCE = 1036 -- 风暴神殿
AT:RegisterDebuff(TIER, INSTANCE, 0, 264560) -- 窒息海潮
AT:RegisterDebuff(TIER, INSTANCE, 0, 268233) -- 电化震击
AT:RegisterDebuff(TIER, INSTANCE, 0, 268322) -- 溺毙者之触
AT:RegisterDebuff(TIER, INSTANCE, 0, 268896) -- 心灵撕裂
AT:RegisterDebuff(TIER, INSTANCE, 0, 267034) -- 力量的低语
AT:RegisterDebuff(TIER, INSTANCE, 0, 276268) -- 沉重打击
AT:RegisterDebuff(TIER, INSTANCE, 0, 264166) -- 逆流
AT:RegisterDebuff(TIER, INSTANCE, 0, 264526) -- 深海之握
AT:RegisterDebuff(TIER, INSTANCE, 0, 274633) -- 碎甲重击
AT:RegisterDebuff(TIER, INSTANCE, 0, 268214, 6) -- 割肉
AT:RegisterDebuff(TIER, INSTANCE, 0, 267818) -- 切割冲击
AT:RegisterDebuff(TIER, INSTANCE, 0, 268309) -- 无尽黑暗
AT:RegisterDebuff(TIER, INSTANCE, 0, 268317) -- 撕裂大脑
AT:RegisterDebuff(TIER, INSTANCE, 0, 268391) -- 心智突袭
AT:RegisterDebuff(TIER, INSTANCE, 0, 274720) -- 深渊打击
AT:RegisterDebuff(TIER, INSTANCE, 0, 267037) -- 力量的低语
AT:RegisterDebuff(TIER, INSTANCE, 0, 276286) -- 切割旋风

INSTANCE = 1178 -- 麦卡贡
AT:RegisterDebuff(TIER, INSTANCE, 0, 298259, 6) -- 束缚粘液
AT:RegisterDebuff(TIER, INSTANCE, 0, 297257) -- 电荷充能
AT:RegisterDebuff(TIER, INSTANCE, 0, 303885) -- 爆裂喷发
AT:RegisterDebuff(TIER, INSTANCE, 0, 291928) -- 超荷电磁炮
AT:RegisterDebuff(TIER, INSTANCE, 0, 292267) -- 超荷电磁炮
AT:RegisterDebuff(TIER, INSTANCE, 0, 305699) -- 锁定
AT:RegisterDebuff(TIER, INSTANCE, 0, 285443) -- 烈焰火炮
AT:RegisterDebuff(TIER, INSTANCE, 0, 301712) -- 突袭
AT:RegisterDebuff(TIER, INSTANCE, 0, 302274) -- 爆裂冲击
AT:RegisterDebuff(TIER, INSTANCE, 0, 298669) -- 跳电
AT:RegisterDebuff(TIER, INSTANCE, 0, 294929) -- 烈焰撕咬