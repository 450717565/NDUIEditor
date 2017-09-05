-- Credits: Katjes (HandyNotes_LegionRaresTreasures)
local Argus = LibStub("AceAddon-3.0"):NewAddon("ArgusRaresTreasures", "AceBucket-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes", true)
if not HandyNotes then return end

local iconDefaults = {
    skull_grey = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\RareWhite.blp",
    skull_purple = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\RarePurple.blp",
    skull_blue = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\RareBlue.blp",
    skull_yellow = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\RareYellow.blp",
    battle_pet = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\BattlePet.blp",
	treasure = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\Treasure.blp",
	portal = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\Portal.blp",
	default = "Interface\\Icons\\TRADE_ARCHAEOLOGY_CHESTOFTINYGLASSANIMALS",
}
local itemTypeMisc = 0;
local itemTypePet = 1;
local itemTypeMount = 2;
local itemTypeToy = 3;
local itemTypeTransmog = 4;

Argus.nodes = { }

local nodes = Argus.nodes
local isTomTomloaded = false
local isDBMloaded = false
local isCanIMogItloaded = false

-- [XXXXYYYY] = { questId, icon, group, label, loot, note, search },
-- /run local find="Crimson Slavermaw"; for i,mid in ipairs(C_MountJournal.GetMountIDs()) do local n,_,_,_,_,_,_,_,_,_,c,j=C_MountJournal.GetMountInfoByID(mid); if ( n == find ) then print(j .. " " .. n); end end
-- /run local find="Uuna's Doll"; for i=0,2500 do local n=C_PetJournal.GetPetInfoBySpeciesID(i); if ( n == find ) then print(i .. " " .. n); end end

-- Antoran Wastes
nodes["ArgusCore"] = {
	[52702950] = { questId=48822, icon="skull_grey", group="rare_aw", label="监视者艾瓦", search="监视者", loot=nil, note=nil },
	[63902090] = { questId=48809, icon="skull_blue", group="rare_aw", label="普希拉", search="普希拉", loot={ { 152903, itemTypeMount, 981 } }, note="洞穴入口在东南方 - 从东面的桥到达那里。" },
	[53103580] = { questId=48810, icon="skull_blue", group="rare_aw", label="弗拉克苏尔", search="弗拉克苏尔", loot={ { 152903, itemTypeMount, 981 } }, note=nil },
	[63225754] = { questId=48811, icon="skull_grey", group="rare_aw", label="维农", search="维农", loot=nil, note="洞穴入口在东北方，从蜘蛛区域 66, 54.1" },
	[64304820] = { questId=48812, icon="skull_blue", group="rare_aw", label="瓦加", search="瓦加", loot={ { 153190, itemTypeMisc } }, note=nil },
	[62405380] = { questId=48813, icon="skull_grey", group="rare_aw", label="萨卡尔中尉", search="中尉", loot=nil, note=nil },
	[61906430] = { questId=48814, icon="skull_blue", group="rare_aw", label="愤怒领主亚雷兹", search="愤怒领主", loot={ { 153126, itemTypeToy } }, note=nil },
	[60674831] = { questId=48815, icon="skull_grey", group="rare_aw", label="审判官维斯洛兹", search="审判官", loot={ { 151543, itemTypeMisc } }, note=nil },
	[80206230] = { questId=48816, icon="portal", group="rare_aw", label="传送到指挥官泰克拉兹", loot=nil, note=nil },
	[82006600] = { questId=48816, icon="skull_grey", group="rare_aw", label="指挥官泰克拉兹", search="指挥官", loot=nil, note="使用偏西的传送门位于 80.2, 62.3 到达船上" },
	[73207080] = { questId=48817, icon="skull_blue", group="rare_aw", label="雷尔瓦将军", search="将军", loot={ { 153324, itemTypeTransmog, "盾牌" } }, note=nil },
	[75605650] = { questId=48818, icon="skull_grey", group="rare_aw", label="全知者萨纳里安", search="全知者", loot=nil, note=nil },
	[50905530] = { questId=48820, icon="skull_grey", group="rare_aw", label="裂世者斯库尔", search="裂世者", loot=nil, note=nil },
	[63812199] = { questId=48821, icon="skull_blue", group="rare_aw", label="驯犬大师克拉克斯", search="驯犬大师", loot={ { 152790, itemTypeMount, 955 } }, note=nil },
	[55702190] = { questId=48824, icon="skull_blue", group="rare_aw", label="虚空守望者瓦苏拉", search="虚空守望者", loot={ { 153319, itemTypeTransmog, "双手锤" } }, note=nil },
	[60902290] = { questId=48865, icon="skull_grey", group="rare_aw", label="首席炼金师蒙库鲁斯", search="首席炼金师", loot=nil, note=nil },
	[54003800] = { questId=48966, icon="skull_blue", group="rare_aw", label="千面吞噬者", search="千面", loot={ { 153195, itemTypePet, 2136 } }, note=nil },
	[77177319] = { questId=48967, icon="portal", group="rare_aw", label="传送到中队指挥官维沙克斯", loot=nil, note="第一步先从不朽虚无行者身上找到碎裂的传送门发生器。然后从艾瑞达战术顾问、魔誓侍从身上收集导电护套，弧光电路，能量电池，使用碎裂的传送门发生器把它们组合起来打开去往维沙克斯的传送门。" },
	[84368118] = { questId=48967, icon="skull_blue", group="rare_aw", label="中队指挥官维沙克斯", search="中队指挥官", loot={ { 153253, itemTypeToy } }, note="使用传送门位于 77.2, 73.2 上船" },
	[58001200] = { questId=48968, icon="skull_blue", group="rare_aw", label="末日法师苏帕克斯", search="末日法师", loot={ { 153194, itemTypeToy } }, note=nil },
	[66981777] = { questId=48970, icon="skull_blue", group="rare_aw", label="主母罗苏拉", search="主母", loot={ { 152903, itemTypeMount, 981 }, { 153252, itemTypePet, 2135 } }, note="洞穴入口在东南方 - 从东面的桥到达那里。收集洞里小鬼掉的100个小鬼的肉。使用它做一份黑暗料理扔进绿池子里召唤主母。" },
	[64948290] = { questId=48971, icon="skull_blue", group="rare_aw", label="先知雷兹拉", search="先知", loot={ { 153293, itemTypeToy } }, note="使用观察者之地共鸣器打开传送门。收集500个恶魔之眼把它交给位于 60.2, 45.4 的全视者奥利克斯换取。" },
	[61703720] = { questId=49183, icon="skull_blue", group="rare_aw", label="疱喉", search="疱喉", loot={ { 152905, itemTypeMount, 979 } }, note=nil },
	[57403290] = { questId=49240, icon="skull_blue", group="rare_aw", label="妖女伊森黛拉", search="妖女", loot={ { 153327, itemTypeTransmog, "匕首" } }, note=nil },
	[56204550] = { questId=49241, icon="skull_grey", group="rare_aw", label="加尔佐斯", search="加尔佐斯", loot=nil, note=nil },


	[59804030] = { questId=0, icon="battle_pet", group="pet_aw", label="小乌祖", loot=nil, note=nil },
	[76707390] = { questId=0, icon="battle_pet", group="pet_aw", label="小型克西斯号", loot=nil, note=nil },
	[51604140] = { questId=0, icon="battle_pet", group="pet_aw", label="凝视者", loot=nil, note=nil },
	[56605420] = { questId=0, icon="battle_pet", group="pet_aw", label="小胖", loot=nil, note=nil },
	[56102870] = { questId=0, icon="battle_pet", group="pet_aw", label="啮耳者", loot=nil, note=nil },
	[64106600] = { questId=0, icon="battle_pet", group="pet_aw", label="小贼", loot=nil, note=nil },

	-- 48382
	[67546980] = { questId=48382, icon="treasure", group="treasure_aw", label="48382", loot=nil, note="建筑物内" },
	[67466226] = { questId=48382, icon="treasure", group="treasure_aw", label="48382", loot=nil, note=nil },
	[71326946] = { questId=48382, icon="treasure", group="treasure_aw", label="48382", loot=nil, note="在哈多克斯边上" },
	[58066806] = { questId=48382, icon="treasure", group="treasure_aw", label="48382", loot=nil, note=nil }, -- Doe
	-- 48383
	[56903570] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note=nil },
	[57633179] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note=nil },
	[52182918] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note=nil },
	[58174021] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note=nil },
	[51863409] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note=nil },
	[55133930] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note=nil },
	[58413097] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note="建筑物内，第一层" },
	-- 48384
	[60872900] = { questId=48384, icon="treasure", group="treasure_aw", label="48384", loot=nil, note=nil },
	[59081942] = { questId=48384, icon="treasure", group="treasure_aw", label="48384", loot=nil, note="建筑物内" },
	[64152305] = { questId=48384, icon="treasure", group="treasure_aw", label="48384", loot=nil, note="驯犬大师克拉克斯洞穴内" },
	[66621709] = { questId=48384, icon="treasure", group="treasure_aw", label="48384", loot=nil, note="小鬼洞穴内，主母罗苏拉旁边" },
	[63682571] = { questId=48384, icon="treasure", group="treasure_aw", label="48384", loot=nil, note=nil },
	[61862236] = { questId=48384, icon="treasure", group="treasure_aw", label="48384", loot=nil, note="外面，首席炼金师蒙库鲁斯旁边" },
	-- 48385
	[50605720] = { questId=48385, icon="treasure", group="treasure_aw", label="48385", loot=nil, note=nil },
	[50655715] = { questId=48385, icon="treasure", group="treasure_aw", label="48385", loot=nil, note=nil },
	[55544743] = { questId=48385, icon="treasure", group="treasure_aw", label="48385", loot=nil, note=nil },
	[57135124] = { questId=48385, icon="treasure", group="treasure_aw", label="48385", loot=nil, note=nil },
	[55915425] = { questId=48385, icon="treasure", group="treasure_aw", label="48385", loot=nil, note=nil }, -- Doe
	-- 48387
	[69403965] = { questId=48387, icon="treasure", group="treasure_aw", label="48387", loot=nil, note=nil },
	[66643654] = { questId=48387, icon="treasure", group="treasure_aw", label="48387", loot=nil, note=nil },
	[68983342] = { questId=48387, icon="treasure", group="treasure_aw", label="48387", loot=nil, note=nil },
	[65522831] = { questId=48387, icon="treasure", group="treasure_aw", label="48387", loot=nil, note="桥下" },
	[63613643] = { questId=48387, icon="treasure", group="treasure_aw", label="48387", loot=nil, note=nil }, -- Doe
	-- 48388
	[51502610] = { questId=48388, icon="treasure", group="treasure_aw", label="48388", loot=nil, note=nil },
	[59261743] = { questId=48388, icon="treasure", group="treasure_aw", label="48388", loot=nil, note=nil },
	[55921387] = { questId=48388, icon="treasure", group="treasure_aw", label="48388", loot=nil, note=nil },
	[55841722] = { questId=48388, icon="treasure", group="treasure_aw", label="48388", loot=nil, note=nil },
	[55622042] = { questId=48388, icon="treasure", group="treasure_aw", label="48388", loot=nil, note="虚空守望者瓦苏拉边上，条上岩石斜坡" },
	-- 48389
	[64305040] = { questId=48389, icon="treasure", group="treasure_aw", label="48389", loot=nil, note=nil },
	[60254351] = { questId=48389, icon="treasure", group="treasure_aw", label="48389", loot=nil, note=nil },
	[65514081] = { questId=48389, icon="treasure", group="treasure_aw", label="48389", loot=nil, note=nil },
	[60304675] = { questId=48389, icon="treasure", group="treasure_aw", label="48389", loot=nil, note=nil },
	[65345192] = { questId=48389, icon="treasure", group="treasure_aw", label="48389", loot=nil, note="瓦加后面的洞穴内" },
	-- 48390
	[81306860] = { questId=48390, icon="treasure", group="treasure_aw", label="48390", loot=nil, note="在船上" },
	[80406152] = { questId=48390, icon="treasure", group="treasure_aw", label="48390", loot=nil, note=nil },
	[82566503] = { questId=48390, icon="treasure", group="treasure_aw", label="48390", loot=nil, note="在船上" },
	[73316858] = { questId=48390, icon="treasure", group="treasure_aw", label="48390", loot=nil, note="雷尔瓦将军顶层边上" },
	[77127529] = { questId=48390, icon="treasure", group="treasure_aw", label="48390", loot=nil, note="维沙克斯传送门旁边" },
	-- 48391
	[64135867] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note="在维农的巢穴内" },
	[67404790] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note=nil },
	[63615622] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note="在维农的巢穴内" },
	[65005049] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note="蜘蛛区域外" },
	[63035762] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note="在维农的巢穴内" },
	[65185507] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note="上面入口到蜘蛛区域" },
	[68095075] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note="蜘蛛区域小洞穴内" },
	-- Ancient Legion War Cache
	[65973977] = { questId=49018, icon="treasure", group="treasure_aw", label="48391", loot={ { 153308, itemTypeTransmog, "单手锤" } }, note="小心跳下到小洞穴。滑翔会很有帮助。" },
}

-- Krokuun
nodes["ArgusSurface"] = {
	[44390734] = { questId=48561, icon="skull_grey", group="rare_kr", label="卡扎杜姆", search="卡扎杜姆", loot=nil, note="入口在东南位于 50.3, 17.3" },
	[33007600] = { questId=48562, icon="skull_grey", group="rare_kr", label="指挥官萨森纳尔", search="萨森纳尔", loot=nil, note=nil },
	[44505870] = { questId=48564, icon="skull_blue", group="rare_kr", label="指挥官安达西斯", search="安达西斯", loot={ { 153255, itemTypeTransmog, "单手锤" } }, note=nil },
	[53403090] = { questId=48565, icon="skull_blue", group="rare_kr", label="苏薇西娅姐妹", search="姐妹", loot={ { 153124, itemTypeToy } }, note=nil },
	[58007480] = { questId=48627, icon="skull_grey", group="rare_kr", label="攻城大师沃兰", search="攻城大师", loot=nil, note=nil },
	[55508020] = { questId=48628, icon="skull_blue", group="rare_kr", label="恶毒者泰勒斯塔", search="恶毒者", loot={ { 153329, itemTypeTransmog, "匕首" } }, note=nil },
	[38145920] = { questId=48563, icon="skull_blue", group="rare_kr", label="指挥官维卡娅", search="维卡娅", loot={ { 153299, itemTypeTransmog, "单手剑" } }, note="路径起始点在东，位于 42, 57.1" },
	[60802080] = { questId=48629, icon="skull_grey", group="rare_kr", label="背弃者瓦加斯", search="背弃者", loot=nil, note=nil },
	[69605750] = { questId=48664, icon="skull_blue", group="rare_kr", label="分选者泰瑞克", search="分选者", loot={ { 153263, itemTypeTransmog, "单手斧" } }, note=nil },
	[69708050] = { questId=48665, icon="skull_grey", group="rare_kr", label="焦油喷吐者", search="焦油", loot=nil, note=nil },
	[41707020] = { questId=48666, icon="skull_grey", group="rare_kr", label="鬼母拉格拉丝", search="鬼母", loot=nil, note=nil },
	[70503370] = { questId=48667, icon="skull_blue", group="rare_kr", label="纳罗瓦", search="纳罗瓦", loot={ { 153190, itemTypeMisc } }, note=nil },

	[43005200] = { questId=0, icon="battle_pet", group="pet_kr", label="梦魇之焰", loot=nil, note=nil },
	[51506380] = { questId=0, icon="battle_pet", group="pet_kr", label="污染之爪", loot=nil, note=nil },
	[66847263] = { questId=0, icon="battle_pet", group="pet_kr", label="毁灭之蹄", loot=nil, note=nil },
	[29605790] = { questId=0, icon="battle_pet", group="pet_kr", label="死亡之啸", loot=nil, note=nil },
	[39606650] = { questId=0, icon="battle_pet", group="pet_kr", label="小牙", loot=nil, note=nil },
	[58302970] = { questId=0, icon="battle_pet", group="pet_kr", label="小脏", loot=nil, note=nil },

	-- 47752
	[56108050] = { questId=47752, icon="treasure", group="treasure_kr", label="47752", loot=nil, note=nil },
	[55555863] = { questId=47752, icon="treasure", group="treasure_kr", label="47752", loot=nil, note="跳上岩石，起点偏西" },
	[52185431] = { questId=47752, icon="treasure", group="treasure_kr", label="47752", loot=nil, note="位于第一次看到奥蕾莉亚的上面" },
	[50405122] = { questId=47752, icon="treasure", group="treasure_kr", label="47752", loot=nil, note="位于第一次看到奥蕾莉亚的上面" },
	[57005472] = { questId=47752, icon="treasure", group="treasure_kr", label="47752", loot=nil, note="岩层下面，窄小地面上" }, -- Doe
	-- 47753
	[51425958] = { questId=47753, icon="treasure", group="treasure_kr", label="47753", loot=nil, note="恶毒者泰勒斯塔建筑物内" },
	[53137304] = { questId=47753, icon="treasure", group="treasure_kr", label="47753", loot=nil, note=nil },
	[55228114] = { questId=47753, icon="treasure", group="treasure_kr", label="47753", loot=nil, note=nil },
	[56118037] = { questId=47753, icon="treasure", group="treasure_kr", label="47753", loot=nil, note="恶毒者泰勒斯塔建筑物外" },
	-- 47997
	[45876777] = { questId=47997, icon="treasure", group="treasure_kr", label="47997", loot=nil, note="岩石下，桥旁边" },
	[45797753] = { questId=47997, icon="treasure", group="treasure_kr", label="47997", loot=nil, note=nil }, -- Doe
	-- 47999
	[62592581] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note=nil },
	[59763951] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note=nil },
	[59071884] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note="上面，岩石后面" },
	[61643520] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note=nil },
	[61463580] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note="建筑物内" },
	[59603052] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note="桥面上" },
	[60891852] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note="背弃者瓦加斯后面小屋内" },
	-- 48000
	[70907370] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note=nil },
	[74136784] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note=nil },
	[75136432] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note=nil },
	[69605772] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note=nil },
	[69787836] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note="跳上斜坡到达" },
	[68566054] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note="分选者泰瑞克洞穴前面" },
	[72896482] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note=nil },
	[71827536] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note=nil }, -- Doe
	-- 48336
	[33515510] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note=nil },
	[32047441] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note=nil },
	[27196668] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note=nil },
	[31936750] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note=nil },
	[35415637] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note="地面，在去往泽尼达尔入口下面的前方" },
	[29645761] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note="洞穴内" },
	[40526067] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note="黄色小屋内" }, -- Doe
	-- 48339
	[68533891] = { questId=48339, icon="treasure", group="treasure_kr", label="48339", loot=nil, note=nil },
	[63054240] = { questId=48339, icon="treasure", group="treasure_kr", label="48339", loot=nil, note=nil },
	[64964156] = { questId=48339, icon="treasure", group="treasure_kr", label="48339", loot=nil, note=nil },
	[73393438] = { questId=48339, icon="treasure", group="treasure_kr", label="48339", loot=nil, note=nil },
	[72243202] = { questId=48339, icon="treasure", group="treasure_kr", label="48339", loot=nil, note="巨大头骨后面" }, -- Doe
	[65983499] = { questId=48339, icon="treasure", group="treasure_kr", label="48339", loot=nil, note=nil },

}

nodes["ArgusCitadelSpire"] = {
	[38954032] = { questId=48561, icon="skull_grey", group="rare_kr", label="卡扎杜姆", loot=nil, note=nil },
}

-- Mac'Aree
nodes["ArgusMacAree"] = {
	[55705990] = { questId=0, icon="skull_blue", group="rare_ma", label="牧羊人卡沃斯", loot=nil, note=nil },
	[43806020] = { questId=0, icon="skull_grey", group="rare_ma", label="嗜血的巴鲁特", loot=nil, note=nil },
	[36302360] = { questId=0, icon="skull_grey", group="rare_ma", label="警卫泰诺斯", loot=nil, note=nil },
	[33704750] = { questId=0, icon="skull_blue", group="rare_ma", label="毒尾天鳍鳐", loot=nil, note=nil },
	[27202980] = { questId=0, icon="skull_grey", group="rare_ma", label="法鲁克队长", loot=nil, note=nil },
	[30304040] = { questId=0, icon="skull_grey", group="rare_ma", label="阿塔克松", loot=nil, note=nil },
	[35505870] = { questId=0, icon="skull_grey", group="rare_ma", label="混沌先驱", loot=nil, note="位于第二层。" },
	[48504090] = { questId=0, icon="skull_grey", group="rare_ma", label="杰德尼勇士沃鲁斯克", loot=nil, note=nil },
	[58003090] = { questId=0, icon="skull_grey", group="rare_ma", label="监视者伊索纳", loot=nil, note=nil },
	[61405020] = { questId=0, icon="skull_grey", group="rare_ma", label="导师塔拉娜", loot=nil, note=nil },
	[56801450] = { questId=0, icon="skull_grey", group="rare_ma", label="指挥官泽斯加尔", loot=nil, note=nil },
	[49505280] = { questId=0, icon="skull_grey", group="rare_ma", label="最后的希里索恩", loot=nil, note=nil },
	[44607160] = { questId=0, icon="skull_grey", group="rare_ma", label="暗影法师沃伦", loot=nil, note=nil },
	[65306750] = { questId=0, icon="skull_grey", group="rare_ma", label="灵魂扭曲的畸体", loot=nil, note=nil },
	[38705580] = { questId=0, icon="skull_blue", group="rare_ma", label="苍白的卡拉", loot=nil, note=nil },
	[41301160] = { questId=0, icon="skull_grey", group="rare_ma", label="麦芬大盗费舍尔", loot=nil, note=nil },
	[63806460] = { questId=0, icon="skull_grey", group="rare_ma", label="警卫库洛", loot=nil, note=nil },
	[39206660] = { questId=0, icon="skull_grey", group="rare_ma", label="清醒者图瑞克", loot=nil, note=nil },
	[35203720] = { questId=0, icon="skull_grey", group="rare_ma", label="乌伯拉利斯", loot=nil, note=nil },
	[70404670] = { questId=0, icon="skull_grey", group="rare_ma", label="厄运者索洛里斯", loot=nil, note=nil },
	[44204980] = { questId=0, icon="skull_blue", group="rare_ma", label="沙布尔", loot=nil, note=nil },
	[59203770] = { questId=0, icon="skull_grey", group="rare_ma", label="监视者伊比达", loot=nil, note=nil },
	[60402970] = { questId=0, icon="skull_grey", group="rare_ma", label="监视者伊莫拉", loot=nil, note=nil },
	[64002950] = { questId=0, icon="skull_grey", group="rare_ma", label="万千之主祖尔坦", loot=nil, note=nil },
	[49700990] = { questId=0, icon="skull_blue", group="rare_ma", label="吞噬者斯克里格", loot=nil, note=nil },

	[60007110] = { questId=0, icon="battle_pet", group="pet_ma", label="烁光之翼", loot=nil, note=nil },
	[67604390] = { questId=0, icon="battle_pet", group="pet_ma", label="巴基", loot=nil, note=nil },
	[74703620] = { questId=0, icon="battle_pet", group="pet_ma", label="马库斯", loot=nil, note=nil },
	[69705190] = { questId=0, icon="battle_pet", group="pet_ma", label="鼠鼠", loot=nil, note=nil },
	[31903120] = { questId=0, icon="battle_pet", group="pet_ma", label="阿古斯的腐化之血", loot=nil, note=nil },
	[36005410] = { questId=0, icon="battle_pet", group="pet_ma", label="曳影兽", loot=nil, note=nil },
}


local function GetItem(ID)
    if (ID == "1220" or ID == "1508") then
        local currency, _, _ = GetCurrencyInfo(ID)

        if (currency ~= nil) then
            return currency
        else
            return "Error loading CurrencyID"
        end
    else
        local _, item, _, _, _, _, _, _, _, _ = GetItemInfo(ID)

        if (item ~= nil) then
            return item
        else
            return "Error loading ItemID"
        end
    end
end 

local function GetIcon(ID)
    if (ID == "1220") then
        local _, _, icon = GetCurrencyInfo(ID)

        if (icon ~= nil) then
            return icon
        else
            return "Interface\\Icons\\inv_misc_questionmark"
        end
    else
		local _, _, _, _, icon = GetItemInfoInstant(ID)
        --local _, _, _, _, _, _, _, _, _, icon = GetItemInfo(ID)

        if (icon ~= nil) then
            return icon
        else
            return "Interface\\Icons\\inv_misc_questionmark"
        end
    end
end

function Argus:OnEnter(mapFile, coord)
    if (not nodes[mapFile][coord]) then return end
    
    local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip

    if ( self:GetCenter() > UIParent:GetCenter() ) then
        tooltip:SetOwner(self, "ANCHOR_LEFT")
    else
        tooltip:SetOwner(self, "ANCHOR_RIGHT")
    end

    tooltip:SetText(nodes[mapFile][coord]["label"])
    if (	( Argus.db.profile.show_loot == true ) and
			( nodes[mapFile][coord]["loot"] ~= nil ) and
			( type(nodes[mapFile][coord]["loot"]) == "table" ) ) then
		local ii;
		local loot = nodes[mapFile][coord]["loot"];
		for ii = 1, #loot do
			-- loot
			if ( loot[ii][2] == itemTypeMount ) then
				-- check mount known
				local n,_,_,_,_,_,_,_,_,_,c,j=C_MountJournal.GetMountInfoByID( loot[ii][3] );
				if ( c == true ) then
					tooltip:AddLine(("" .. GetItem(loot[ii][1]) .. " (|cFF00FF00已学会坐骑|r)"), nil, nil, nil, true)
				else
					tooltip:AddLine(("" .. GetItem(loot[ii][1]) .. " (|cFFFF0000坐骑缺少|r)"), nil, nil, nil, true)
				end
			elseif ( loot[ii][2] == itemTypePet ) then
				-- check pet quantity
				local n,m = C_PetJournal.GetNumCollectedInfo( loot[ii][3] );
				tooltip:AddLine(("" .. GetItem(loot[ii][1]) .. " (宠物 " .. n .. "/" .. m .. ")"), nil, nil, nil, true)
			elseif ( loot[ii][2] == itemTypeToy ) then
				-- check toy known
				if ( PlayerHasToy( loot[ii][1] ) == true ) then
					tooltip:AddLine(("" .. GetItem(loot[ii][1]) .. " (|cFF00FF00已学会玩具|r)"), nil, nil, nil, true)
				else
					tooltip:AddLine(("" .. GetItem(loot[ii][1]) .. " (|cFFFF0000玩具缺少|r)"), nil, nil, nil, true)
				end
			elseif ( isCanIMogItloaded == true and loot[ii][2] == itemTypeTransmog ) then
				-- check transmog known with canimogit
				local _,itemLink = GetItemInfo( loot[ii][1] );
				if ( itemLink ~= nil ) then
					if ( CanIMogIt:PlayerKnowsTransmog( itemLink ) ) then
						tooltip:AddLine(("" .. GetItem(loot[ii][1]) .. " (|cFF00FF00" .. loot[ii][3] .. "|r)"), nil, nil, nil, true)
					else
						tooltip:AddLine(("" .. GetItem(loot[ii][1]) .. " (|cFFFF0000" .. loot[ii][3] .. "|r)"), nil, nil, nil, true)
					end
				else
					tooltip:AddLine(("" .. GetItem(loot[ii][1]) .. " (" .. loot[ii][3] .. ")"), nil, nil, nil, true)
				end
			elseif ( loot[ii][2] == itemTypeTransmog ) then
				-- show transmog without check
				tooltip:AddLine(("" .. GetItem(loot[ii][1]) .. " (" .. loot[ii][3] .. ")"), nil, nil, nil, true)
			else
				-- default show itemLink
				tooltip:AddLine(("" .. GetItem(loot[ii][1])), nil, nil, nil, true)
			end
		end
    end
	if ( Argus.db.profile.show_notes == true and nodes[mapFile][coord]["note"] and nodes[mapFile][coord]["note"] ~= nil ) then
		-- note
		tooltip:AddLine(("" .. nodes[mapFile][coord]["note"]), nil, nil, nil, true)
	end

    tooltip:Show()
end

local isMoving = false
local info = {}
local clickedMapFile = nil
local clickedCoord = nil

local function LRTHideDBMArrow()
    DBM.Arrow:Hide(true)
end

local function LRTDisableTreasure(button, mapFile, coord)
    if (nodes[mapFile][coord]["questId"] ~= nil) then
        Argus.db.char[mapFile .. coord .. nodes[mapFile][coord]["questId"]] = true;
    end

    Argus:Refresh()
end

local function LRTResetDB()
    table.wipe(Argus.db.char)
    Argus:Refresh()
end

local function LRTaddtoTomTom(button, mapFile, coord)
    if isTomTomloaded == true then
        local mapId = HandyNotes:GetMapFiletoMapID(mapFile)
        local x, y = HandyNotes:getXY(coord)
        local desc = nodes[mapFile][coord]["label"];

        TomTom:AddMFWaypoint(mapId, nil, x, y, {
            title = desc,
            persistent = nil,
            minimap = true,
            world = true
        })
    end
end

local function LRTAddDBMArrow(button, mapFile, coord)
    if isDBMloaded == true then
        local mapId = HandyNotes:GetMapFiletoMapID(mapFile)
        local x, y = HandyNotes:getXY(coord)
        local desc = nodes[mapFile][coord][2];

        if not DBMArrow.Desc:IsShown() then
            DBMArrow.Desc:Show()
        end

        x = x*100
        y = y*100
        DBMArrow.Desc:SetText(desc)
        DBM.Arrow:ShowRunTo(x, y, nil, nil, true)
    end
end

local finderFrame = CreateFrame("Frame");
finderFrame:SetScript("OnEvent", function( self, event )
	self:UnregisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED");
	-- LFGListFrame.SearchPanel.SearchBox:SetText(self.search);
end );

local function LRTLFRsearch( button, search, label )
	if ( search ~= nil ) then
		finderFrame.search = search;
		local c,zone,_,_,name = C_LFGList.GetActiveEntryInfo();
		if c == true then
			if ( UnitIsGroupLeader("player") ) then
				print( "旧队伍失效。再次点击查找队伍 " .. label .. "." );
				C_LFGList.RemoveListing();
			else
				print( "权限不足。你不是队长。" );
			end
		else
			if not GroupFinderFrame:IsVisible() then
				PVEFrame_ShowFrame("GroupFinderFrame");
			end
			GroupFinderFrameGroupButton4:Click();
			LFGListFrame.SearchPanel.SearchBox:SetText( search );
			LFGListCategorySelection_SelectCategory( LFGListFrame.CategorySelection, 6, 0 );
			LFGListFrame.SearchPanel.SearchBox:SetText( search );
			LFGListCategorySelectionFindGroupButton_OnClick( LFGListFrame.CategorySelection.FindGroupButton );			
			LFGListFrame.SearchPanel.SearchBox:SetText( search );
			
			finderFrame:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED")
		end
	end
end

local function LRTLFRcreate( button, label )
	local c,zone,_,_,name = C_LFGList.GetActiveEntryInfo();
	if c == true and name ~= label then
		if ( UnitIsGroupLeader("player") ) then
			print( "旧队伍失效。再次点击查找队伍 " .. label .. "." );
			C_LFGList.RemoveListing();
		else
			print( "权限不足。你不是队长。" );
		end
	elseif ( c == false ) then
		print( "创建队伍 " .. label .. "." );
		-- 16 = custom
		C_LFGList.CreateListing(16,label,0,0,"","Created with HandyNotes_Argus",true)
	end
end

local function generateMenu(button, level)
    if (not level) then return end

    for k in pairs(info) do info[k] = nil end

    if (level == 1) then
        info.isTitle = 1
        info.text = "Argus"
        info.notCheckable = 1
        UIDropDownMenu_AddButton(info, level)
        
        info.disabled = nil
        info.isTitle = nil
        info.notCheckable = nil

		if ( (string.find(nodes[clickedMapFile][clickedCoord]["group"], "rare") ~= nil)) then

		info.text = "查找队伍"
			if ( nodes[clickedMapFile][clickedCoord]["search"] ~= nil ) then
				info.func = LRTLFRsearch
				info.arg1 = nodes[clickedMapFile][clickedCoord]["search"]
				info.arg2 = nodes[clickedMapFile][clickedCoord]["label"]
				UIDropDownMenu_AddButton(info, level)
			end

			info.text = "创建查找队伍正在列出"
			info.func = LRTLFRcreate
			info.arg1 = nodes[clickedMapFile][clickedCoord]["label"]
			UIDropDownMenu_AddButton(info, level)
		end

        info.text = "从地图移除此物件"
        info.func = LRTDisableTreasure
        info.arg1 = clickedMapFile
        info.arg2 = clickedCoord
        UIDropDownMenu_AddButton(info, level)
        
        if isTomTomloaded == true then
            info.text = "在 TomTom 添加此路径点位置"
            info.func = LRTaddtoTomTom
            info.arg1 = clickedMapFile
            info.arg2 = clickedCoord
            UIDropDownMenu_AddButton(info, level)
        end

        if isDBMloaded == true then
            info.text = "在 DBM 中添加此财宝箭头"
            info.func = LRTAddDBMArrow
            info.arg1 = clickedMapFile
            info.arg2 = clickedCoord
            UIDropDownMenu_AddButton(info, level)
            
            info.text = "隐藏 DBM 箭头"
            info.func = LRTHideDBMArrow
            UIDropDownMenu_AddButton(info, level)
        end

        info.text = CLOSE
        info.func = function() CloseDropDownMenus() end
        info.arg1 = nil
        info.arg2 = nil
        info.notCheckable = 1
        UIDropDownMenu_AddButton(info, level)

        info.text = "恢复已移除物件"
        info.func = LRTResetDB
        info.arg1 = nil
        info.arg2 = nil
        info.notCheckable = 1
        UIDropDownMenu_AddButton(info, level)
        
    end
end

local HandyNotes_ArgusDropdownMenu = CreateFrame("Frame", "HandyNotes_ArgusDropdownMenu")
HandyNotes_ArgusDropdownMenu.displayMode = "MENU"
HandyNotes_ArgusDropdownMenu.initialize = generateMenu

function Argus:OnClick(button, down, mapFile, coord)
    if button == "RightButton" and down then
		-- context menu
        clickedMapFile = mapFile
        clickedCoord = coord
        ToggleDropDownMenu(1, nil, HandyNotes_ArgusDropdownMenu, self, 0, 0)
	elseif button == "MiddleButton" and down then
		-- create group
		if ( (string.find(nodes[mapFile][coord]["group"], "rare") ~= nil)) then
			LRTLFRcreate( nil, nodes[mapFile][coord]["label"] );
		end
	elseif button == "LeftButton" and down then
		-- find group
		LRTLFRsearch( nil, nodes[mapFile][coord]["search"], nodes[mapFile][coord]["label"] );
    end
end

function Argus:OnLeave(mapFile, coord)
    if self:GetParent() == WorldMapButton then
        WorldMapTooltip:Hide()
    else
        GameTooltip:Hide()
    end
end

local options = {
    type = "group",
    name = "阿古斯稀有和财宝",
    desc = "阿古斯稀有和财宝位置",
    get = function(info) return Argus.db.profile[info.arg] end,
    set = function(info, v) Argus.db.profile[info.arg] = v; Argus:Refresh() end,
    args = {
        desc = {
            name = "常用设置",
            type = "description",
            order = 0,
        },
        icon_scale_treasures = {
            type = "range",
            name = "财宝图标大小",
            desc = "图标的大小",
            min = 0.25, max = 3, step = 0.01,
            arg = "icon_scale_treasures",
            order = 1,
        },
        icon_scale_rares = {
            type = "range",
            name = "稀有图标大小",
            desc = "图标的大小",
            min = 0.25, max = 3, step = 0.01,
            arg = "icon_scale_rares",
            order = 2,
        },
        icon_alpha = {
            type = "range",
            name = "图标透明度",
            desc = "图标的透明度",
            min = 0, max = 1, step = 0.01,
            arg = "icon_alpha",
            order = 20,
        },
        VisibilityOptions = {
            type = "group",
            name = "可见性设定",
            desc = "可见性设定",
            args = {
                VisibilityGroup = {
                    type = "group",
                    order = 0,
                    name = "选择哪些区域要显示什么：",
                    inline = true,
                    args = {
                        groupAW = {
                            type = "header",
                            name = "安托兰废土",
                            desc = "安托兰废土",
                            order = 0,
                        },
                        treasureAW = {
                            type = "toggle",
                            arg = "treasure_aw",
                            name = "财宝",
                            desc = "财宝会提供很多物品",
                            order = 1,
                            width = "normal",
                        },
                        rareAW = {
                            type = "toggle",
                            arg = "rare_aw",
                            name = "稀有",
                            desc = "稀有刷新",
                            order = 2,
                            width = "normal",
                        },
                        petAW = {
                            type = "toggle",
                            arg = "pet_aw",
                            name = "战斗宠物",
                            order = 3,
                            width = "normal",
                        },
                        groupKR = {
                            type = "header",
                            name = "克罗库恩",
                            desc = "克罗库恩",
                            order = 10,
                        },  
                        treasureKR = {
                            type = "toggle",
                            arg = "treasure_kr",
                            name = "财宝",
                            desc = "财宝会提供很多物品",
                            width = "normal",
                            order = 11,
                        },
                        rareKR = {
                            type = "toggle",
                            arg = "rare_kr",
                            name = "稀有",
                            desc = "稀有刷新",
                            width = "normal",
                            order = 12,
                        },
                        petKR = {
                            type = "toggle",
                            arg = "pet_kr",
                            name = "战斗宠物",
                            width = "normal",
                            order = 13,
                        },
                        groupMA = {
                            type = "header",
                            name = "玛凯雷",
                            desc = "玛凯雷",
                            order = 20,
                        },  
                        treasureMA = {
                            type = "toggle",
                            arg = "treasure_ma",
                            name = "财宝",
                            desc = "财宝会提供很多物品",
                            width = "normal",
                            order = 21,
                        },
                        rareMA = {
                            type = "toggle",
                            arg = "rare_ma",
                            name = "稀有",
                            desc = "稀有刷新",
                            width = "normal",
                            order = 22,
                        },  
                        petMA = {
                            type = "toggle",
                            arg = "pet_ma",
                            name = "战斗宠物",
                            width = "normal",
                            order = 23,
                        },  
                    },
                },
                alwaysshowrares = {
                    type = "toggle",
                    arg = "alwaysshowrares",
                    name = "总是显示已拾取的稀有",
                    desc = "显示每个稀有无论是否已拾取状态",
                    order = 100,
                    width = "full",
                },
                alwaysshowtreasures = {
                    type = "toggle",
                    arg = "alwaysshowtreasures",
                    name = "总是显示已拾取的财宝",
                    desc = "显示每个财宝无论是否已拾取状态",
                    order = 101,
                    width = "full",
                },
                show_loot = {
                    type = "toggle",
                    arg = "show_loot",
                    name = "显示掉落",
                    desc = "显示每个财宝/稀有的掉落",
                    order = 102,
                },
                show_notes = {
                    type = "toggle",
                    arg = "show_notes",
                    name = "显示注释",
                    desc = "当可用时显示每个财宝/稀有的注释",
                    order = 103,
                },
            },
        },
    },
}

function Argus:OnInitialize()
    local defaults = {
        profile = {
            icon_scale_treasures = 1.5,
            icon_scale_rares = 1.5,
            icon_alpha = 1.00,
            alwaysshowrares = false,
            alwaysshowtreasures = false,
            save = true,
            treasure_aw = true,
            treasure_kr = true,
            treasure_ma = true,
            rare_aw = true,
            rare_kr = true,
            rare_ma = true,
			pet_aw = true,
			pet_kr = true,
			pet_ma = true,
            show_loot = true,
            show_notes = true,
        },
    }

    self.db = LibStub("AceDB-3.0"):New("HandyNotesArgusDB", defaults, "Default")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "WorldEnter")
end

function Argus:WorldEnter()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:ScheduleTimer("RegisterWithHandyNotes", 8)
	self:ScheduleTimer("LoadCheck", 6)
end

function Argus:RegisterWithHandyNotes()
    do
		local currentMapFile = "";
        local function iter(t, prestate)
            if not t then return nil end

            local coord, node = next(t, prestate)

            while coord do
                if (node["questId"] and self.db.profile[node["group"]] and not Argus:HasBeenLooted(currentMapFile,coord,node)) then
					-- preload items
                    if ((node["loot"] ~= nil) and (type(node["loot"]) == "table")) then
						local ii
						for ii = 1, #node["loot"] do
							GetIcon(node["loot"][ii][1])
						end
                    end

                    return coord, nil, iconDefaults[node["icon"]], Argus.db.profile.icon_scale_rares, Argus.db.profile.icon_alpha
                end

                coord, node = next(t, coord)
            end
        end

        function Argus:GetNodes(mapFile, isMinimapUpdate, dungeonLevel)
			currentMapFile = mapFile;
            return iter, nodes[mapFile], nil
        end
    end

    HandyNotes:RegisterPluginDB("HandyNotesArgus", self, options)
    self:RegisterBucketEvent({ "LOOT_CLOSED" }, 2, "Refresh")
    self:Refresh()
end
 
function Argus:Refresh()
    self:SendMessage("HandyNotes_NotifyUpdate", "HandyNotesArgus")
end

function Argus:HasBeenLooted(mapFile,coord,node)
    if (self.db.profile.alwaysshowtreasures and (string.find(node["group"], "treasure") ~= nil)) then return false end
    if (self.db.profile.alwaysshowrares and (string.find(node["group"], "rare") ~= nil)) then return false end
    if (node["questId"] and node["questId"] == 0) then return false end
    if (Argus.db.char[mapFile .. coord .. node["questId"]] and self.db.profile.save) then return true end
    if (IsQuestFlaggedCompleted(node["questId"])) then
        return true
    end

    return false
end

function Argus:LoadCheck()
	if (IsAddOnLoaded("TomTom")) then 
		isTomTomloaded = true
	end

	if (IsAddOnLoaded("DBM-Core")) then 
		isDBMloaded = true
	end

	if (IsAddOnLoaded("CanIMogIt")) then 
		isCanIMogItloaded = true
	end

	if isDBMloaded == true then
		local ArrowDesc = DBMArrow:CreateFontString(nil, "OVERLAY", "GameTooltipText")
		ArrowDesc:SetWidth(400)
		ArrowDesc:SetHeight(100)
		ArrowDesc:SetPoint("CENTER", DBMArrow, "CENTER", 0, -35)
		ArrowDesc:SetTextColor(1, 1, 1, 1)
		ArrowDesc:SetJustifyH("CENTER")
		DBMArrow.Desc = ArrowDesc
	end
end
