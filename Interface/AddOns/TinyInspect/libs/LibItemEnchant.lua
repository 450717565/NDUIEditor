
-------------------------------------
-- 物品附魔信息庫 Author: M
-------------------------------------

local MAJOR, MINOR = "LibItemEnchant.7000", 1
local lib = LibStub:NewLibrary(MAJOR, MINOR)

if not lib then return end

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
}

local EnchantSpellDB = {
	-- 符文熔铸
	[3847] = 62158,
	[3368] = 53344,
	[3370] = 53343,
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
