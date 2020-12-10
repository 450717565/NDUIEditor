local _, ns = ...
local B, C, L, DB = unpack(ns)
local AT = B:GetModule("AurasTable")

local TIER = 8
local INSTANCE = 1031 -- 奥迪尔
local BOSS

BOSS = 2168 -- 塔罗克
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 275270) -- 锁定
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 278889) -- 赤红迸发
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 278888)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 271225)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 271224)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 275189) -- 硬化血脉
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 275205) -- 变大的心脏

BOSS = 2167 -- 纯净圣母
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 267787) -- 消毒打击
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 268277) -- 净化烈焰
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 268253) -- 奥迪尔防御射线
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 268095) -- 精华荡涤
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 268198) -- 粘附腐化
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 267821) -- 防御矩阵

BOSS = 2146 -- 腐臭吞噬者
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 262313) -- 恶臭沼气
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 262314) -- 腐烂恶臭
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 262292) -- 腐败反刍

BOSS = 2169 -- 泽克沃兹
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 265237) -- 粉碎
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 265264) -- 虚空鞭笞
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 265360) -- 翻滚欺诈
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 265646, 5) -- 腐化者的意志
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 265662, 6) -- 腐化者的契约
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 270620) -- 灵能冲击波
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 270589) -- 虚空之嚎

BOSS = 2166 -- 维克提斯
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 265129, 6) -- 终极菌体
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 267160, 6)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 267161, 6)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 267162, 6)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 267163, 6)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 267164, 6)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 265178) -- 进化痛苦
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 265212) -- 育种
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 274990, 5) -- 破裂损伤
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 265127, 1) -- 持续感染

BOSS = 2195 -- 重生者祖尔
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 274358) -- 破裂之血
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 273434) -- 绝望深渊
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 274271) -- 死亡之愿
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 278890) -- 剧烈失血
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 273365) -- 黑暗启示
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 272018) -- 黑暗吸收
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 274195, 1) -- 堕落之血

BOSS = 2194 -- 拆解者米斯拉克斯
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 274693) -- 精华撕裂
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 272146, 1) -- 毁灭
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 272407) -- 湮灭之球
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 272536) -- 毁灭迫近

BOSS = 2147 -- 戈霍恩
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 272506) -- 爆炸腐蚀
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 263235) -- 鲜血盛宴
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 267700) -- 戈霍恩的凝视
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 263227, 1) -- 腐败之血
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 263372) -- 能量矩阵
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 267409) -- 黑暗交易
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 267430) -- 折磨
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 270287) -- 疫病之地