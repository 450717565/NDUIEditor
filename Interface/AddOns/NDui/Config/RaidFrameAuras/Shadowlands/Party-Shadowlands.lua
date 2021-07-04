local _, ns = ...
local B, C, L, DB = unpack(ns)
local AT = B:GetModule("AurasTable")

local TIER = 9
local INSTANCE -- 5人本

INSTANCE = 1194 -- 塔扎维什，帷纱集市
AT:RegisterSeasonSpells(TIER, INSTANCE)
AT:RegisterDebuff(TIER, INSTANCE, 0, 356011) -- 光线切分者
AT:RegisterDebuff(TIER, INSTANCE, 0, 347949, 6) -- 审讯
AT:RegisterDebuff(TIER, INSTANCE, 0, 345770) -- 扣押违禁品
AT:RegisterDebuff(TIER, INSTANCE, 0, 355915) -- 约束雕文
AT:RegisterDebuff(TIER, INSTANCE, 0, 346962) -- 现金汇款
AT:RegisterDebuff(TIER, INSTANCE, 0, 349627) -- 暴食
AT:RegisterDebuff(TIER, INSTANCE, 0, 347481) -- 奥能手里波
AT:RegisterDebuff(TIER, INSTANCE, 0, 350804) -- 坍缩能量
AT:RegisterDebuff(TIER, INSTANCE, 0, 350885) -- 超光速震荡
AT:RegisterDebuff(TIER, INSTANCE, 0, 351101) -- 能量碎片
AT:RegisterDebuff(TIER, INSTANCE, 0, 350013) -- 暴食盛宴
AT:RegisterDebuff(TIER, INSTANCE, 0, 355641) -- 闪烁
AT:RegisterDebuff(TIER, INSTANCE, 0, 355451) -- 逆流
AT:RegisterDebuff(TIER, INSTANCE, 0, 351956) -- 高价值目标
AT:RegisterDebuff(TIER, INSTANCE, 0, 346297) -- 动荡爆炸
AT:RegisterDebuff(TIER, INSTANCE, 0, 347728) -- 群殴
AT:RegisterDebuff(TIER, INSTANCE, 0, 356408) -- 大地践踏
AT:RegisterDebuff(TIER, INSTANCE, 0, 347744) -- 迅斩
AT:RegisterDebuff(TIER, INSTANCE, 0, 350134) -- 永恒吐息
AT:RegisterDebuff(TIER, INSTANCE, 0, 355465) -- 投掷巨石

INSTANCE = 1187 -- 伤逝剧场
AT:RegisterSeasonSpells(TIER, INSTANCE)
AT:RegisterDebuff(TIER, INSTANCE, 0, 333299) -- 荒芜诅咒
AT:RegisterDebuff(TIER, INSTANCE, 0, 333301) -- 荒芜诅咒
AT:RegisterDebuff(TIER, INSTANCE, 0, 319539) -- 无魂者
AT:RegisterDebuff(TIER, INSTANCE, 0, 326892) -- 锁定
AT:RegisterDebuff(TIER, INSTANCE, 0, 321768) -- 上钩了
AT:RegisterDebuff(TIER, INSTANCE, 0, 323825) -- 攫取裂隙
AT:RegisterDebuff(TIER, INSTANCE, 0, 333231) -- 灼热之陨
AT:RegisterDebuff(TIER, INSTANCE, 0, 330532) -- 锯齿箭
AT:RegisterDebuff(TIER, INSTANCE, 0, 342675) -- 骨矛
AT:RegisterDebuff(TIER, INSTANCE, 0, 323831) -- 死亡之攫
AT:RegisterDebuff(TIER, INSTANCE, 0, 330608) -- 邪恶爆发
AT:RegisterDebuff(TIER, INSTANCE, 0, 330868) -- 通灵箭雨
AT:RegisterDebuff(TIER, INSTANCE, 0, 323750) -- 邪恶毒气
AT:RegisterDebuff(TIER, INSTANCE, 0, 323406) -- 锯齿创口
AT:RegisterDebuff(TIER, INSTANCE, 0, 330700) -- 腐烂凋零
AT:RegisterDebuff(TIER, INSTANCE, 0, 319626) -- 幻影寄生
AT:RegisterDebuff(TIER, INSTANCE, 0, 324449) -- 死亡具象
AT:RegisterDebuff(TIER, INSTANCE, 0, 341949) -- 枯萎凋零

INSTANCE = 1183 -- 凋魂之殇
AT:RegisterSeasonSpells(TIER, INSTANCE)
AT:RegisterDebuff(TIER, INSTANCE, 0, 336258) -- 落单狩猎
AT:RegisterDebuff(TIER, INSTANCE, 0, 331818) -- 暗影伏击
AT:RegisterDebuff(TIER, INSTANCE, 0, 333353) -- 暗影伏击
AT:RegisterDebuff(TIER, INSTANCE, 0, 329110) -- 软泥注射
AT:RegisterDebuff(TIER, INSTANCE, 0, 325552) -- 毒性裂击
AT:RegisterDebuff(TIER, INSTANCE, 0, 336301) -- 裹体之网
AT:RegisterDebuff(TIER, INSTANCE, 0, 322358) -- 燃灼菌株
AT:RegisterDebuff(TIER, INSTANCE, 0, 322410) -- 凋零污秽
AT:RegisterDebuff(TIER, INSTANCE, 0, 328180) -- 攫握感染
AT:RegisterDebuff(TIER, INSTANCE, 0, 320542) -- 荒芜凋零
AT:RegisterDebuff(TIER, INSTANCE, 0, 340355) -- 急速感染
AT:RegisterDebuff(TIER, INSTANCE, 0, 328395) -- 剧毒打击
AT:RegisterDebuff(TIER, INSTANCE, 0, 320512) -- 侵蚀爪击
AT:RegisterDebuff(TIER, INSTANCE, 0, 333406) -- 伏击
AT:RegisterDebuff(TIER, INSTANCE, 0, 332397) -- 覆体缠网
AT:RegisterDebuff(TIER, INSTANCE, 0, 330069) -- 凝结魔药
AT:RegisterDebuff(TIER, INSTANCE, 0, 331399) -- 感染毒雨

INSTANCE = 1184 -- 塞兹仙林的迷雾
AT:RegisterSeasonSpells(TIER, INSTANCE)
AT:RegisterDebuff(TIER, INSTANCE, 0, 325027) -- 荆棘爆发
AT:RegisterDebuff(TIER, INSTANCE, 0, 323043) -- 放血
AT:RegisterDebuff(TIER, INSTANCE, 0, 322557) -- 灵魂分裂
AT:RegisterDebuff(TIER, INSTANCE, 0, 331172) -- 心灵连接
AT:RegisterDebuff(TIER, INSTANCE, 0, 322563) -- 被标记的猎物
AT:RegisterDebuff(TIER, INSTANCE, 0, 341198) -- 易燃爆炸
AT:RegisterDebuff(TIER, INSTANCE, 0, 325418) -- 不稳定的酸液
AT:RegisterDebuff(TIER, INSTANCE, 0, 326092) -- 衰弱毒药
AT:RegisterDebuff(TIER, INSTANCE, 0, 325021) -- 纱雾撕裂
AT:RegisterDebuff(TIER, INSTANCE, 0, 325224) -- 心能注入
AT:RegisterDebuff(TIER, INSTANCE, 0, 322486) -- 过度生长
AT:RegisterDebuff(TIER, INSTANCE, 0, 322487) -- 过度生长
AT:RegisterDebuff(TIER, INSTANCE, 0, 323137) -- 迷乱花粉
AT:RegisterDebuff(TIER, INSTANCE, 0, 328756) -- 憎恨之容
AT:RegisterDebuff(TIER, INSTANCE, 0, 321828) -- 肉饼蛋糕
AT:RegisterDebuff(TIER, INSTANCE, 0, 340191) -- 再生辐光
AT:RegisterDebuff(TIER, INSTANCE, 0, 321891) -- 鬼抓人锁定

INSTANCE = 1188 -- 彼界
AT:RegisterSeasonSpells(TIER, INSTANCE)
AT:RegisterDebuff(TIER, INSTANCE, 0, 320786) -- 势不可挡
AT:RegisterDebuff(TIER, INSTANCE, 0, 334913) -- 死亡之主
AT:RegisterDebuff(TIER, INSTANCE, 0, 325725) -- 寰宇操控
AT:RegisterDebuff(TIER, INSTANCE, 0, 328987) -- 狂热
AT:RegisterDebuff(TIER, INSTANCE, 0, 334496) -- 催眠光粉
AT:RegisterDebuff(TIER, INSTANCE, 0, 339978) -- 安抚迷雾
AT:RegisterDebuff(TIER, INSTANCE, 0, 333250) -- 放血之击
AT:RegisterDebuff(TIER, INSTANCE, 0, 322746) -- 堕落之血
AT:RegisterDebuff(TIER, INSTANCE, 0, 330434) -- 电锯
AT:RegisterDebuff(TIER, INSTANCE, 0, 320144) -- 电锯
AT:RegisterDebuff(TIER, INSTANCE, 0, 331847) -- W-00F
AT:RegisterDebuff(TIER, INSTANCE, 0, 327649) -- 粉碎灵魂
AT:RegisterDebuff(TIER, INSTANCE, 0, 331379) -- 润滑剂
AT:RegisterDebuff(TIER, INSTANCE, 0, 332678) -- 龟裂创伤
AT:RegisterDebuff(TIER, INSTANCE, 0, 323687) -- 奥术闪电
AT:RegisterDebuff(TIER, INSTANCE, 0, 323692) -- 奥术易伤
AT:RegisterDebuff(TIER, INSTANCE, 0, 334535) -- 啄裂

INSTANCE = 1186 -- 晋升高塔
AT:RegisterSeasonSpells(TIER, INSTANCE)
AT:RegisterDebuff(TIER, INSTANCE, 0, 338729) -- 充能践踏
AT:RegisterDebuff(TIER, INSTANCE, 0, 327481) -- 黑暗长枪
AT:RegisterDebuff(TIER, INSTANCE, 0, 322818) -- 失去信心
AT:RegisterDebuff(TIER, INSTANCE, 0, 322817) -- 疑云密布
AT:RegisterDebuff(TIER, INSTANCE, 0, 324154) -- 暗影迅步
AT:RegisterDebuff(TIER, INSTANCE, 0, 335805) -- 执政官的壁垒
AT:RegisterDebuff(TIER, INSTANCE, 0, 317661) -- 险恶毒液
AT:RegisterDebuff(TIER, INSTANCE, 0, 328331) -- 严刑逼供
AT:RegisterDebuff(TIER, INSTANCE, 0, 323195) -- 净化冲击波
AT:RegisterDebuff(TIER, INSTANCE, 0, 328453) -- 压迫
AT:RegisterDebuff(TIER, INSTANCE, 0, 331997) -- 心能澎湃
AT:RegisterDebuff(TIER, INSTANCE, 0, 324205) -- 炫目闪光
AT:RegisterDebuff(TIER, INSTANCE, 0, 331251) -- 深度联结
AT:RegisterDebuff(TIER, INSTANCE, 0, 341215) -- 动荡心能
AT:RegisterDebuff(TIER, INSTANCE, 0, 323792) -- 心能力场
AT:RegisterDebuff(TIER, INSTANCE, 0, 330683) -- 原始心能
AT:RegisterDebuff(TIER, INSTANCE, 0, 328434) -- 胁迫
AT:RegisterDebuff(TIER, INSTANCE, 0, 27638)  -- 斜掠

INSTANCE = 1185 -- 赎罪大厅
AT:RegisterSeasonSpells(TIER, INSTANCE)
AT:RegisterDebuff(TIER, INSTANCE, 0, 335338) -- 哀伤仪式
AT:RegisterDebuff(TIER, INSTANCE, 0, 326891) -- 痛楚
AT:RegisterDebuff(TIER, INSTANCE, 0, 329321) -- 锯齿横扫
AT:RegisterDebuff(TIER, INSTANCE, 0, 344993) -- 锯齿横扫
AT:RegisterDebuff(TIER, INSTANCE, 0, 319603) -- 羁石诅咒
AT:RegisterDebuff(TIER, INSTANCE, 0, 319611) -- 变成石头
AT:RegisterDebuff(TIER, INSTANCE, 0, 325876) -- 湮灭诅咒
AT:RegisterDebuff(TIER, INSTANCE, 0, 326632) -- 石化血脉
AT:RegisterDebuff(TIER, INSTANCE, 0, 323650) -- 萦绕锁定
AT:RegisterDebuff(TIER, INSTANCE, 0, 326874) -- 脚踝撕咬
AT:RegisterDebuff(TIER, INSTANCE, 0, 340446) -- 嫉妒之印

INSTANCE = 1189 -- 赤红深渊
AT:RegisterSeasonSpells(TIER, INSTANCE)
AT:RegisterDebuff(TIER, INSTANCE, 0, 326827) -- 恐惧之缚
AT:RegisterDebuff(TIER, INSTANCE, 0, 326836) -- 镇压诅咒
AT:RegisterDebuff(TIER, INSTANCE, 0, 322554) -- 严惩
AT:RegisterDebuff(TIER, INSTANCE, 0, 321038) -- 烦扰之魂
AT:RegisterDebuff(TIER, INSTANCE, 0, 328593) -- 苦痛刑罚
AT:RegisterDebuff(TIER, INSTANCE, 0, 325254) -- 钢铁尖刺
AT:RegisterDebuff(TIER, INSTANCE, 0, 335306) -- 尖刺镣铐
AT:RegisterDebuff(TIER, INSTANCE, 0, 327814) -- 邪恶创口
AT:RegisterDebuff(TIER, INSTANCE, 0, 331415) -- 邪恶创口
AT:RegisterDebuff(TIER, INSTANCE, 0, 328737) -- 光辉残片
AT:RegisterDebuff(TIER, INSTANCE, 0, 324092) -- 闪耀光辉
AT:RegisterDebuff(TIER, INSTANCE, 0, 322429) -- 撕裂切割
AT:RegisterDebuff(TIER, INSTANCE, 0, 334653) -- 饱餐

INSTANCE = 1182 -- 通灵战潮
AT:RegisterSeasonSpells(TIER, INSTANCE)
AT:RegisterDebuff(TIER, INSTANCE, 0, 321821) -- 作呕喷吐
AT:RegisterDebuff(TIER, INSTANCE, 0, 323365) -- 黑暗纠缠
AT:RegisterDebuff(TIER, INSTANCE, 0, 338353) -- 瘀液喷撒
AT:RegisterDebuff(TIER, INSTANCE, 0, 333485) -- 疾病之云
AT:RegisterDebuff(TIER, INSTANCE, 0, 338357) -- 暴锤
AT:RegisterDebuff(TIER, INSTANCE, 0, 328181) -- 冷冽之寒
AT:RegisterDebuff(TIER, INSTANCE, 0, 320170) -- 通灵箭
AT:RegisterDebuff(TIER, INSTANCE, 0, 323464) -- 黑暗脓液
AT:RegisterDebuff(TIER, INSTANCE, 0, 323198) -- 黑暗放逐
AT:RegisterDebuff(TIER, INSTANCE, 0, 327401) -- 共受苦难
AT:RegisterDebuff(TIER, INSTANCE, 0, 327397) -- 严酷命运
AT:RegisterDebuff(TIER, INSTANCE, 0, 322681) -- 肉钩
AT:RegisterDebuff(TIER, INSTANCE, 0, 333492) -- 通灵粘液
AT:RegisterDebuff(TIER, INSTANCE, 0, 321807) -- 白骨剥离
AT:RegisterDebuff(TIER, INSTANCE, 0, 323347) -- 黑暗纠缠
AT:RegisterDebuff(TIER, INSTANCE, 0, 320788) -- 冻结之缚
AT:RegisterDebuff(TIER, INSTANCE, 0, 320839) -- 衰弱
AT:RegisterDebuff(TIER, INSTANCE, 0, 343556) -- 病态凝视
AT:RegisterDebuff(TIER, INSTANCE, 0, 338606) -- 病态凝视
AT:RegisterDebuff(TIER, INSTANCE, 0, 343504) -- 黑暗之握
AT:RegisterDebuff(TIER, INSTANCE, 0, 324381) -- 霜寒之镰
AT:RegisterDebuff(TIER, INSTANCE, 0, 320573) -- 暗影之井
AT:RegisterDebuff(TIER, INSTANCE, 0, 334748) -- 排干体液
AT:RegisterDebuff(TIER, INSTANCE, 0, 333489) -- 通灵吐息
AT:RegisterDebuff(TIER, INSTANCE, 0, 320717) -- 鲜血饥渴