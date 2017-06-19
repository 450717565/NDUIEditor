local _, addonNamespace = ...

local ItemEnchantInfo = {}
ItemEnchantInfo.__index = ItemEnchantInfo

addonNamespace.ItemEnchantInfo = ItemEnchantInfo

local CONSUMABLE_ID = 1
local RECEIPE_ID = 2
local FORMULA_ID = 3

local db = {
	-- WoD:

	-- Enchant Ring
	[5284] = { 110617, 158907, 118448 }, -- Breath of Critical Strike
	[5297] = { 110618, 158908, 118449 }, -- Breath of Haste
	[5299] = { 110619, 158909, 118450 }, -- Breath of Mastery
	[5301] = { 110620, 158910, 118451 }, -- Breath of Multistrike
	[5303] = { 110621, 158911, 118452 }, -- Breath of Versatility
	[5324] = { 110638, 158914, 118453 }, -- Gift of Critical Strike
	[5325] = { 110639, 158915, 118454 }, -- Gift of Haste
	[5326] = { 110640, 158916, 118455 }, -- Gift of Mastery
	[5327] = { 110641, 158917, 118456 }, -- Gift of Multistrike
	[5328] = { 110642, 158918, 118457 }, -- Gift of Versatility

	-- Enchant Neck
	[5285] = { 110624, 158892, 118438 }, -- Breath of Critical Strike
	[5292] = { 110625, 158893, 118439 }, -- Breath of Haste
	[5293] = { 110626, 158894, 118440 }, -- Breath of Mastery
	[5294] = { 110627, 158895, 118441 }, -- Breath of Multistrike
	[5295] = { 110628, 158896, 118442 }, -- Breath of Versatility
	[5317] = { 110645, 158899, 118443 }, -- Gift of Critical Strike
	[5318] = { 110646, 158900, 118444 }, -- Gift of Haste
	[5319] = { 110647, 158901, 118445 }, -- Gift of Mastery
	[5320] = { 110648, 158902, 118446 }, -- Gift of Multistrike
	[5321] = { 110649, 158903, 118447 }, -- Gift of Versatility

	-- Enchant Cloak
	[5281] = { 110631, 158877, 118394 }, -- Breath of Critical Strike
	[5298] = { 110632, 158878, 118429 }, -- Breath of Haste
	[5300] = { 110633, 158879, 118430 }, -- Breath of Mastery
	[5302] = { 110634, 158880, 118431 }, -- Breath of Multistrike
	[5304] = { 110635, 158881, 118432 }, -- Breath of Versatility
	[5310] = { 110652, 158884, 118433 }, -- Gift of Critical Strike
	[5311] = { 110653, 158885, 118434 }, -- Gift of Haste
	[5312] = { 110654, 158886, 118435 }, -- Gift of Mastery
	[5313] = { 110655, 158887, 118436 }, -- Gift of Multistrike
	[5314] = { 110656, 158889, 118437 }, -- Gift of Versatility

	-- Enchant Ranged Weapon
	[5275] = { 109120, 156050, 118477 }, -- Oglethorpe's Missile Splitter
	[5276] = { 109122, 156061, 118478 }, -- Megawatt Filament
	[5383] = { 118008, 173287, 118495 }, -- Hemet's Heartseeker

	-- Enchant Fishing Pole
	[5357] = { 116117, 170886, nil }, -- Rook's Lucky Fishin' Line

	-- Enchant Weapon
	[5330] = { 110682, 159235, 159235 }, -- Mark of the Thunderlord
	[5331] = { 112093, 159236, 159236 }, -- Mark of the Shattered Hand
	[5335] = { 112115, 159673, 159673 }, -- Mark of Shadowmoon
	[5336] = { 112160, 159674, 159674 }, -- Mark of Blackrock
	[5337] = { 112164, 159671, 159671 }, -- Mark of Warsong
	[5334] = { 112165, 159672, 159672 }, -- Mark of the Frostwolf
	[5352] = { 115973, 170627, 170627 }, -- Glory of the Thunderlord
	[5353] = { 115975, 170628, 170628 }, -- Glory of the Shadowmoon
	[5354] = { 115976, 170629, 170629 }, -- Glory of the Blackrock
	[5355] = { 115977, 170630, 170630 }, -- Glory of the Warsong
	[5356] = { 115978, 170631, 170631 }, -- Glory of the Frostwolf

	-- Death Knight Runes

	[3368] = { nil, 53344, nil }, -- 堕落十字军符文
	[3370] = { nil, 53343, nil }, -- 冰锋符文
	[3847] = { nil, 62158, nil }, -- 石肤石像鬼符文

	-- 军团再临:

	-- 手指
	[5423] = { 128537, 190866, 128562 }, -- 爆击真言
	[5424] = { 128538, 190867, 128563 }, -- 急速真言
	[5425] = { 128539, 190868, 128564 }, -- 精通真言
	[5426] = { 128540, 190869, 128565 }, -- 全能真言
	[5427] = { 128541, 190870, 128566 }, -- 爆击之缚
	[5428] = { 128542, 190871, 128567 }, -- 急速之缚
	[5429] = { 128543, 190872, 128568 }, -- 精通之缚
	[5430] = { 128544, 190873, 128569 }, -- 全能之缚

	-- 背部
	[5431] = { 128545, 190874, 128570 }, -- 力量真言
	[5432] = { 128546, 190875, 128571 }, -- 敏捷真言
	[5433] = { 128547, 190876, 128572 }, -- 智力真言
	[5434] = { 128548, 190877, 128573 }, -- 力量之缚
	[5435] = { 128549, 190878, 128574 }, -- 敏捷之缚
	[5436] = { 128550, 190879, 128575 }, -- 智力之缚

	-- 颈部
	[5437] = { 128551, 190892, 128576 }, -- 利爪之印
	[5438] = { 128552, 190893, 128577 }, -- 远程大军之印
	[5439] = { 128553, 190894, 128578 }, -- 隐匿萨特之印
	[5889] = { 141908, 228402, 141911 }, -- 厚皮之印
	[5890] = { 141909, 228405, 141912 }, -- 受训士兵之印
	[5891] = { 141910, 228408, 141913 }, -- 古代女祭司之印
	[5895] = { 144304, 235695, 144308 }, -- 精通之印
	[5896] = { 144305, 235696, 144309 }, -- 全能之印
	[5897] = { 144306, 235697, 144310 }, -- 急速之印
	[5898] = { 144307, 235698, 144311 }, -- 致命之印

	-- 手部
	[5444] = { 128558, 190988, 128617 }, -- 军团草药学
	[5445] = { 128559, 190989, 128618 }, -- 军团采矿
	[5446] = { 128560, 190990, 128619 }, -- 军团剥皮
	[5447] = { 128561, 190991, 128620 }, -- 军团勘测

	-- 肩部
	[5440] = { 128554, 190954, nil }, -- 拾荒者之赐
	[5441] = { 140213, 190955, nil }, -- 寻宝者之赐
	[5442] = { 140214, 190956, nil }, -- 收割者之赐
	[5443] = { 140215, 190957, nil }, -- 屠戮者之赐
	[5881] = { 140217, 222851, nil }, -- 回收者之赐
	[5882] = { 140218, 222852, nil }, -- 觅法者之赐
	[5883] = { 140219, 222853, nil }, -- 猎血者之赐
	[5888] = { 141861, 228139, nil }, -- 虚空之赐
	[5899] = { 144328, 235731, nil }, -- 工匠的恩赐
	[5900] = { 144346, 235794, nil }, -- 动物管理员的恩赐

}

function ItemEnchantInfo:new(enchantId)
	return setmetatable({ enchantId = tonumber(enchantId), }, self)
end

function ItemEnchantInfo:getId()
	return self.enchantId
end

function ItemEnchantInfo:getConsumableItem()
	local rec = db[self.enchantId]
	return rec and rec[CONSUMABLE_ID] and addonNamespace.ItemStringInfo:new("item:"..rec[CONSUMABLE_ID]..":0:0:0:0:0:0:0:0:0:0")
end

function ItemEnchantInfo:getReceipeSpell()
	local rec = db[self.enchantId]
	return rec and rec[RECEIPE_ID] and addonNamespace.SpellInfo:new("spell:"..rec[RECEIPE_ID])
end

function ItemEnchantInfo:getFormulaItem()
	local rec = db[self.enchantId]
	return rec and rec[FORMULA_ID] and addonNamespace.ItemStringInfo:new("item:"..rec[FORMULA_ID]..":0:0:0:0:0:0:0:0:0:0")
end
