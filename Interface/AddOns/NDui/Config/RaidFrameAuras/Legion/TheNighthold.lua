local _, ns = ...
local B, C, L, DB = unpack(ns)
local AT = B:GetModule("AurasTable")

local TIER = 7 -- Legion
local INSTANCE = 786 -- The Nighthold
local BOSS

BOSS = 1706	-- 斯考匹隆
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 204531)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 204284, 5)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 204483)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 211659)

BOSS = 1725	-- 时空畸体
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 206607)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 219966, 5)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 219965, 5)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 219964, 5)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 206617, 4)

BOSS = 1731	-- 崔利艾克斯
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 208506)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 206788)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 206641)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 208924)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 214583)

BOSS = 1751	-- 魔剑士奥鲁瑞尔
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 212587)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 213328)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 212494)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 212647, 4)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 213621, 5)

BOSS = 1762	-- 提克迪奥斯
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 206480, 4)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 206365)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 212795, 5)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 216040, 5)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 208230)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 206466)

BOSS = 1713	-- 克洛苏斯
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 205348)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 205420)

BOSS = 1761	-- 植物学家
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 218424)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 218780)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 218438)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 218502)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 218809, 5)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 218342, 5)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 220114)		-- achievement
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 219235)

BOSS = 1732	-- 占星师艾塔乌斯
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 206936)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 205649)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 206464)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 207720, 5)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 206603, 5)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 206398, 5)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 206585)

BOSS = 1743	-- 大魔导师艾丽桑德
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 210387)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 209244, 5)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 209598, 5)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 209973, 5)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 209549)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 227856)

BOSS = 1737	-- 古尔丹
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 206222, 4)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 206221, 4)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 206883)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 206896)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 206875)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 209454, 5)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 221728, 5)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 221606, 5)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 210339, 4)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 208802, 3)