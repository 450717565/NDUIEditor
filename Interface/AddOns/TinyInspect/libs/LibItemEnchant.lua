
-------------------------------------
-- 物品附魔信息庫 Author: M
-------------------------------------

local MAJOR, MINOR = "LibItemEnchant.7000", 2
local lib = LibStub:NewLibrary(MAJOR, MINOR)

if not lib then return end

--Thanks to RRRRBUA(NGA) 七曜·星の痕(NGA)
local EnchantItemDB = {
	-- 争霸艾泽拉斯
	[5932] = 153430,
	[5933] = 153431,
	[5934] = 153434,
	[5935] = 153435,
	[5937] = 153437,
	[5938] = 153438,
	[5939] = 153439,
	[5940] = 153440,
	[5941] = 153441,
	[5942] = 153442,
	[5943] = 153443,
	[5944] = 153444,
	[5945] = 153445,
	[5946] = 153476,
	[5948] = 153478,
	[5949] = 153479,
	[5950] = 153480,
	[5955] = 158212,
	[5956] = 158327,
	[5957] = 158203,
	[5958] = 158377,
	[5962] = 159788,
	[5963] = 159786,
	[5964] = 159787,
	[5965] = 159785,
	[5966] = 159789,
	[6108] = 168446,
	[6109] = 168447,
	[6110] = 168448,
	[6111] = 168449,
	[6112] = 168593,
	[6148] = 168596,
	[6149] = 168592,
	[6150] = 168598,
	-- 暗影国度
	[6163] = 172357,
	[6164] = 172361,
	[6165] = 172358,
	[6166] = 172362,
	[6167] = 172359,
	[6168] = 172363,
	[6169] = 172360,
	[6170] = 172364,
	[6195] = 172921,
	[6196] = 172920,
	[6202] = 172410,
	[6203] = 172411,
	[6204] = 172412,
	[6205] = 172406,
	[6207] = 177661,
	[6208] = 177660,
	[6209] = 172407,
	[6210] = 172408,
	[6211] = 172419,
	[6212] = 172413,
	[6213] = 172418,
	[6214] = 177659,
	[6216] = 177716,
	[6217] = 177715,
	[6219] = 172414,
	[6220] = 172415,
	[6222] = 172416,
	[6223] = 172370,
	[6226] = 172367,
	[6227] = 172365,
	[6228] = 172368,
	[6229] = 172366,
	[6230] = 177962,
	[6265] = 183738,
}

--Data from: M, RRRRBUA(NGA), KibsItemLevel, 七曜·星の痕(NGA)
local EnchantSpellDB = {
	-- 符文熔铸
	[3368] = 53344,
	[3370] = 53343,
	[3847] = 62158,
	[6241] = 326805,
	[6242] = 326855,
	[6243] = 326911,
	[6244] = 326977,
	[6245] = 327082,
}

function lib:GetEnchantSpellID(ItemLink)
	local enchant = tonumber(string.match(ItemLink, "item:%d+:(%d+):"))
	if (enchant and EnchantSpellDB[enchant]) then
		return EnchantSpellDB[enchant], enchant
	end
	return nil, enchant
end

function lib:GetEnchantItemID(ItemLink)
	local enchant = tonumber(string.match(ItemLink, "item:%d+:(%d+):"))
	if (enchant and EnchantItemDB[enchant]) then
		return EnchantItemDB[enchant], enchant
	end
	return nil, enchant
end
