local _, ns = ...
local B, C, L, DB = unpack(ns)
local AT = B:GetModule("AurasTable")

local TIER = 8
local INSTANCE = 1177 -- 风暴熔炉
local BOSS

BOSS = 2328 -- 无眠秘党
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 282384) -- 精神割裂
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 282566) -- 力量应许
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 282743) -- 风暴湮灭
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 282738) -- 虚空之拥
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 282589) -- 脑髓侵袭
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 287876) -- 黑暗吞噬
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 282432, 6) -- 粉碎之凝
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 282621) -- 终焉见证
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 282517) -- 恐惧回响
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 282540) -- 死亡化身

BOSS = 2332 -- 乌纳特，虚空先驱
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 284851) -- 末日之触
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 285652, 6) -- 贪食折磨
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 285345, 6) -- 恩佐斯的癫狂之眼
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 285562) -- 不可知的恐惧
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 285477) -- 渊黯
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 285367) -- 恩佐斯的穿刺凝视
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 285685) -- 恩佐斯之赐：疯狂
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 284804) -- 深渊护持
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 284733, 6) -- 虚空之拥