local _, ns = ...
local B, C, L, DB = unpack(ns)
local AT = B:GetModule("AurasTable")

local TIER = 9
local INSTANCE = 1190 -- 纳斯利亚堡
local BOSS
-- Credit: Luckyone, ElvUI
BOSS = 2393 -- 啸翼
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 328897) -- 抽干
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 330713) -- 耳鸣之痛

BOSS = 2429 -- 猎手阿尔迪莫
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 335304) -- 寻罪箭
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 334971) -- 锯齿利爪
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 335111) -- 猎手印记
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 335112) -- 猎手印记
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 335113) -- 猎手印记
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 334945) -- 深红痛击
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 334852) -- 石化嚎叫

BOSS = 2428 -- 饥饿的毁灭者
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 334228) -- 不稳定的喷发
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 329298) -- 暴食瘴气

BOSS = 2422 -- 太阳之王的救赎
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 333002) -- 劣民印记
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 326078) -- 灌注者的恩赐
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 325251) -- 骄傲之罪
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 339251) -- 干涸之魂
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 341475) -- 猩红乱舞
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 341473) -- 猩红乱舞
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 328479) -- 锁定目标
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 328889) -- 至高惩戒

BOSS = 2418 -- 技师赛·墨克斯
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 327902) -- 锁定
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 326302) -- 静滞陷阱
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 325236) -- 毁灭符文
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 327414) -- 附身
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 340860) -- 枯萎之触
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 328468) -- 空间撕裂
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 328448) -- 空间撕裂

BOSS = 2420 -- 伊涅瓦·暗脉女勋爵
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 325936) -- 共享认知
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 335396) -- 隐秘欲望
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 324982) -- 共受苦难
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 324983) -- 共受苦难
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 332664) -- 浓缩心能
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 325382) -- 扭曲欲望

BOSS = 2426 -- 猩红议会
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 327773) -- 吸取精华
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 327052) -- 吸取精华
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 346651) -- 吸取精华
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 328334) -- 战术冲锋
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 330848) -- 跳错了
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 331706) -- 红字
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 331636) -- 黑暗伴舞
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 331637) -- 黑暗伴舞

BOSS = 2394 -- 泥拳
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 335470) -- 锁链猛击
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 339181) -- 锁链猛击
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 331209) -- 怨恨凝视
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 335293) -- 锁链联结
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 335295) -- 粉碎锁链
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 342419) -- 锁起来
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 342420) -- 锁起来
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 332572) -- 碎石飞落

BOSS = 2425 -- 石裔干将
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 334498) -- 地震岩层
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 337643) -- 立足不稳
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 334765) -- 石化碎裂
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 333377) -- 邪恶印记
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 334616) -- 石化
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 334541) -- 石化诅咒
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 339690) -- 晶化
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 342655) -- 不稳定的心能灌注
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 342698) -- 不稳定的心能感染
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 343881) -- 锯齿撕裂

BOSS = 2424 -- 德纳修斯大帝
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 326851) -- 血债
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 327796) -- 罐装心能
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 327992) -- 荒芜
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 328276) -- 悔悟之行
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 326699) -- 罪孽烦扰
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 329181) -- 毁灭痛苦
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 335873) -- 积恨
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 329951) -- 穿刺
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 327039) -- 喂食时间
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 327089) -- 喂食时间
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 332794) -- 致命灵巧