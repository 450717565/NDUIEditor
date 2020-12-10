------------------------------------------------------------
-- TrialofValor.lua
--
-- Abin
-- 2016/11/10
------------------------------------------------------------
local _, ns = ...
local B, C, L, DB = unpack(ns)
local AT = B:GetModule("AurasTable")

local TIER = 7 -- Legion
local INSTANCE = 861 -- Trial of Valor
local BOSS

BOSS = 1819
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 228030, 5)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 229584)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 197961)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 228683)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 227959)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 228915)

BOSS = 1830
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 227539)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 227566)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 227570)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 228226)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 228246, 4)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 228250)

BOSS = 1829
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 227903)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 228058)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 228054, 5)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 193367)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 227982, 4)
AT:RegisterDebuff(TIER, INSTANCE, BOSS, 232488, 4)
