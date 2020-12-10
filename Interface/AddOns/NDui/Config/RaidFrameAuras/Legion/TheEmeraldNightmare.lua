------------------------------------------------------------
-- TheEmeraldNightmare.lua
--
-- Abin
-- 2019/09/13
------------------------------------------------------------
local _, ns = ...
local B, C, L, DB = unpack(ns)
local AT = B:GetModule("AurasTable")

local TIER = 7 -- Legion
local INSTANCE = 768 -- The Emerald Nightmare
local BOSS

BOSS = 1703
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 203096)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 205043, 5)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 204463)

BOSS = 1738
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 208929)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 210984)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 209469, 5)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 208931)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 210099, 4)

BOSS = 1744
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 215443)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 210850)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 215288)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 210229, 4)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 215582, 4)

BOSS = 1667
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 198108)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 198006)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 197943, 5)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 197942, 5)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 197980)

BOSS = 1704
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 203110)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 203770, 5)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 203690)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 203124)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 203102)

BOSS = 1750
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 210279)

BOSS = 1726
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 206005)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 206651)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 209158)

BOSS = 0
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 222771)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 222786)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 222719)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 223912)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 221028)
