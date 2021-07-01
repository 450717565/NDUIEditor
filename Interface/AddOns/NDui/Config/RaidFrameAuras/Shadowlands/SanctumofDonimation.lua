
local _, ns = ...
local B, C, L, DB = unpack(ns)
local AT = B:GetModule("AurasTable")

local TIER = 9
local INSTANCE = 1193 -- 统御圣所
local BOSS

BOSS = 2435 -- 塔拉格鲁
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 347283) -- 捕食者之嚎
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 347286) -- 不散之惧
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 346986) -- 粉碎护甲
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 347991) -- 高塔之十
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 347269) -- 永恒锁链
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 346985) -- 压制
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 347274) -- 毁灭猛击

BOSS = 2442 -- 典狱长之眼
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 350606) -- 绝望倦怠
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 355240) -- 轻蔑
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 355245) -- 忿怒
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 349979) -- 牵引锁链
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 348074) -- 痛击长枪
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 351827) -- 蔓延痛苦
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 350763) -- 毁灭凝视

BOSS = 2439 -- 九武神
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 350287) -- 终约之歌
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 350542) -- 命运残片
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 350202) -- 无尽之击
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 350475) -- 灵魂穿透
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 350555) -- 命运碎片
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 350109) -- 布琳佳的悲恸挽歌
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 350483) -- 联结精华
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 350039) -- 阿尔苏拉的粉碎凝视
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 350184) -- 达丝琪拉的威猛冲击
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 350374) -- 愤怒之翼

BOSS = 2444 -- 耐奥祖的残迹
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 350073) -- 折磨
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 349890) -- 苦难
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 350469) -- 怨毒
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 354634) -- 怨恨
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 354479) -- 怨恨
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 354534) -- 怨恨

BOSS = 2445 -- 裂魂者多尔玛赞
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 353429) -- 饱受磨难
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 353023) -- 折磨
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 351787) -- 刑罚新星
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 350647) -- 折磨烙印
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 350422) -- 毁灭之刃
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 350851) -- 聚魂之河
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 354231) -- 灵魂镣铐
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 348987) -- 好战者枷锁
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 350927) -- 好战者枷锁

BOSS = 2443 -- 痛楚工匠莱兹纳尔
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 356472) -- 萦绕烈焰
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 355505) -- 影铸锁链
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 355506) -- 影铸锁链
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 348456) -- 烈焰套索陷阱
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 356870) -- 烈焰套索爆炸
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 355568) -- 十字刃斧
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 355786) -- 黑化护甲

BOSS = 2446 -- 初诞者的卫士
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 352394) -- 光辉能量
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 350496) -- 净除威胁
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 347359) -- 压制力场
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 355357) -- 湮灭
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 350732) -- 破甲
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 352833) -- 分解

BOSS = 2447 -- 命运撰写师罗-卡洛
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 354365) -- 恐怖征兆
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 350568) -- 永恒之唤
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 353435) -- 不堪重负
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 351680) -- 祈求宿命
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 353432) -- 命运重担
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 353693) -- 不稳增幅
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 350355) -- 宿命联结
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 353931) -- 扭曲命运

BOSS = 2440 -- 克尔苏加德
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 346530) -- 冰封毁灭
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 354289) -- 险恶瘴气
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 347454) -- 湮灭回响
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 347518) -- 湮灭回响
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 347292) -- 湮灭回响
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 348978) -- 灵魂疲惫
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 355389) -- 无情追击
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 357298) -- 冻结之缚
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 355137) -- 暗影之池
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 348638) -- 亡者归来
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 348760) -- 冰霜冲击

BOSS = 2441 -- 希尔瓦娜斯·风行者
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 349458) -- 统御锁链
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 347704) -- 黑暗帷幕
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 347607) -- 女妖的印记
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 347670) -- 暗影匕首
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 351117) -- 恐惧压迫
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 351870) -- 索命妖魂
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 351253) -- 女妖哀嚎
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 351451) -- 嗜睡诅咒
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 351092) -- 动荡能量
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 351091) -- 动荡能量
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 348064) -- 哀恸箭