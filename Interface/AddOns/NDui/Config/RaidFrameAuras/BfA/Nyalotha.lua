local _, ns = ...
local B, C, L, DB = unpack(ns)
local AT = B:GetModule("AurasTable")

local TIER = 8
local INSTANCE = 1180 -- 尼奥罗萨，觉醒之城
local BOSS

BOSS = 2368 -- 黑龙帝王拉希奥
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 306015) -- 灼烧护甲
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 306163, 6) -- 万物尽焚
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 313959) -- 灼热气泡
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 314347) -- 毒扼
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 309733) -- 疯狂燃烧
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 307053) -- 岩浆池
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 313250) -- 蠕行疯狂

BOSS = 2365 -- 玛乌特
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 307399) -- 暗影之伤
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 307806) -- 吞噬魔法
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 307586) -- 噬魔深渊
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 306301) -- 禁忌法力
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 314993, 6) -- 吸取精华
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 315025) -- 远古诅咒

BOSS = 2369 -- 先知斯基特拉
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 307785) -- 扭曲心智
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 307784) -- 困惑心智
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 308059) -- 暗影震击
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 309652) -- 虚幻之蚀
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 307950) -- 心智剥离
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 313215) -- 颤涌镜像

BOSS = 2377 -- 黑暗审判官夏奈什
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 311551) -- 深渊打击
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 312406) -- 虚空觉醒
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 314298) -- 末日迫近
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 306311) -- 灵魂鞭笞
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 305575) -- 仪式领域
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 316211) -- 恐惧浪潮

BOSS = 2372 -- 主脑
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 313461) -- 腐蚀
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 315311) -- 毁灭
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 313672) -- 酸液池
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 314593) -- 麻痹毒液
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 313460) -- 虚化
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 310402) -- 吞食狂热

BOSS = 2367 -- 无厌者夏德哈
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 307471) -- 碾压
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 307472) -- 融解
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 307358) -- 衰弱唾液
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 306928) -- 幽影吐息
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 308177) -- 熵能聚合
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 306930) -- 熵能暗息
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 314736) -- 毒泡流溢
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 306929) -- 翻滚毒息
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 318078, 6) -- 锁定
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 309704) -- 腐蚀涂层

BOSS = 2373 -- 德雷阿佳丝
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 310246) -- 虚空之握
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 310277) -- 动荡之种
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 310309) -- 动荡易伤
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 310358) -- 狂乱低语
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 310361) -- 不羁狂乱
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 310406) -- 虚空闪耀
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 308377) -- 虚化脓液
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 317001) -- 暗影排异
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 310552) -- 精神鞭笞
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 310563) -- 背叛低语
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 310567) -- 背叛者

BOSS = 2374 -- 伊格诺斯，重生之蚀
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 309961) -- 恩佐斯之眼
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 311367) -- 腐蚀者之触
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 310322) -- 腐蚀沼泽
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 312486) -- 轮回噩梦
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 311159) -- 诅咒之血
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 315094) -- 锁定
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 313759) -- 诅咒之血

BOSS = 2370 -- 维克修娜
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 307359) -- 绝望
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 307020) -- 暮光之息
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 307019) -- 虚空腐蚀
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 306981) -- 虚空之赐
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 310224, 6) -- 毁灭
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 307314) -- 渗透暗影
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 307343) -- 暗影残渣
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 307250) -- 暮光屠戮
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 315769) -- 屠戮
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 307284) -- 恐怖降临
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 307645) -- 黑暗之心
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 310323) -- 荒芜
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 315932) -- 蛮力重击

BOSS = 2364 -- 虚无者莱登
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 306819) -- 虚化重击
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 306279) -- 动荡暴露
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 306273) -- 不稳定的生命
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 306637) -- 不稳定的虚空爆发
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 309777) -- 虚空污秽
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 313227) -- 腐坏伤口
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 310019, 6) -- 充能锁链
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 310022, 6) -- 充能锁链
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 315252) -- 恐怖炼狱
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 316065) -- 腐化存续

BOSS = 2366 -- 恩佐斯的外壳
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 307832) -- 恩佐斯的仆从
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 313334) -- 恩佐斯之赐
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 306973) -- 疯狂炸弹
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 306984) -- 狂乱炸弹
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 313364) -- 精神腐烂
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 315954) -- 漆黑伤疤
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 307044) -- 梦魇抗原
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 307011) -- 疯狂繁衍

BOSS = 2375 -- 腐蚀者恩佐斯
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 314889) -- 探视心智
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 315624) -- 心智受限
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 309991) -- 痛楚
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 313609) -- 恩佐斯之赐
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 308996) -- 恩佐斯的仆从
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 316711) -- 意志摧毁
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 313400) -- 堕落心灵
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 316542, 6) -- 妄念
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 316541, 6) -- 妄念
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 310042) -- 混乱爆发
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 313793) -- 狂乱之火
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 313610) -- 精神腐烂
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 309698) -- 虚空鞭笞
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 311392) -- 心灵之握
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 310073) -- 心灵之握
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 313184) -- 突触震击
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 310331) -- 虚空凝视
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 312155) -- 碎裂自我
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 315675) -- 碎裂自我
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 315672) -- 碎裂自我
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 310134) -- 疯狂聚现
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 312866) -- 灾变烈焰
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 315772) -- 心灵之握