-- $Id: DB.lua 30 2017-07-19 09:59:37Z arith $
-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
-- Functions
local _G = getfenv(0)
local pairs = _G.pairs;
-- Libraries
-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...
local LibStub = _G.LibStub
local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes")
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name);

local function mapFile(mapID)
	return HandyNotes:GetMapIDtoMapFile(mapID)
end

local DB = {}

private.DB = DB

DB.points = {
	--[[ structure:
	[mapFile] = { -- "_terrain1" etc will be stripped from attempts to fetch this
		[coord] = {
			quest=[number],		-- quest ID if available
			dungeonLevel=[number], 	-- dungeondungeonLevel if needed
			npc=[id], 		-- related npc id, used to display names in tooltip
			label=[string], 	-- label: text that'll be the label
			note=[string],		-- additional notes for this node
		},
	},
	--]]
	[mapFile(1066)] = { -- Assault on Violet Hold
	},
	[mapFile(1081)] = { -- Black Rook Hold
		[29200647] = {
			dungeonLevel = 1,
			type = "portal",
			label = L["Entrance"],
		},
		[18883767] = {
			dungeonLevel = 1,
			npc = 98538,
			label = L["Lady Velandras Ravencrest"],
		},
		[51033568] = {
			dungeonLevel = 1,
			npc = 98521,
			label = L["Lord Etheldrin Ravencrest"],
		},
		[56292498] = {
			dungeonLevel = 3,
			npc = 112725,
			label = L["Kalyndras <Rook's Quartermaster>"],
		},
		-- Achievement: You Used to Scrawl Me In Your Fel Tome, ID:10709
		[52818472] = {
			dungeonLevel = 1,
			object = 252385,
			achievement = 10709,
			criteria = 31357,
			label = L["Torn Page"],
			type = "yellowButton",
		},
		[32295185] = {
			dungeonLevel = 2,
			object = 252387,
			achievement = 10709,
			criteria = 31359,
			label = L["Dog-Eared Page"],
			type = "yellowButton",
		},
		[56234193] = {
			dungeonLevel = 2,
			object = 252386,
			achievement = 10709,
			criteria = 31358,
			label = L["Worn-Edged Page"],
			type = "yellowButton",
		},
		[51514897] = {
			dungeonLevel = 3,
			object = 252388,
			achievement = 10709,
			criteria = 31360,
			label = L["Singed Page"],
			type = "yellowButton",
		},
		[46665929] = {
			dungeonLevel = 5,
			object = 252390,
			achievement = 10709,
			criteria = 31361,
			label = L["Ink-splattered Page"],
			type = "yellowButton",
		},
		[70967389] = {
			dungeonLevel = 5,
			object = 252391,
			achievement = 10709,
			criteria = 31362,
			label = L["Hastily-Scrawled Page"],
			type = "yellowButton",
		},
		-- Black Rook Hold: Heavy, But Helpful
		[16565833] = {
			dungeonLevel = 3,
			quest = 39349,
			item = 136812,
			label = L["Sabelite Sulfate"],
			type = "yellowButton",
		},
		
		-- Black Rook Hold: ... With Fire!
		[70008486] = {
			quest = 43711,
			dungeonLevel = 1,
			npc = 98637,
			label = L["Ancient Widow"],
		},
		-- Black Rook Hold: The Mad Arcanist
		[37096265] = {
			quest = 43712,
			dungeonLevel = 2,
			npc = 111068,
			label = L["Archmage Galeorn"],
		},
		-- Black Rook Hold: The Sorrow
		[55367962] = {
			quest = 43642,
			dungeonLevel = 1, 
			npc = 110993,
			label = L["General Tel'arn"],
		},
		[57898002] = {
			quest = 43642,
			dungeonLevel = 1, 
			npc = 110995,
			label = L["Ranger General Feleor"],
		},
		-- Black Rook Hold: Traitor's Demise
		[65636935] = {
			quest = 43762,
			dungeonLevel = 5, 
			npc = 111361,
			label = L["Kelorn Nightblade"],
		},
		-- Black Rook Hold: Worst of the Worst
		[30306741] = {
			quest = 43714,
			dungeonLevel = 3,
			npc = 111290,
			label = L["Braxas the Fleshcarver"],
		},
	},
	[mapFile(1146)] = { -- Cathedral of Eternal Night
		[46609106] = {
			dungeonLevel = 1,
			type = "portal",
			label = L["Entrance"],
		},
		-- Cathedral of Eternal Night: Infernal Dead
		[59322101] = {
			quest = 46868,
			dungeonLevel = 1,
			npc = 120715,
			label = L["Raga'yut"],
		},
	},
	[mapFile(1087)] = { -- Court of Stars
		-- Court of Stars: Bring Me the Eyes
		[57557573] = {
			quest = 42769,
			dungeonLevel = 1,
			npc = 108740,
			label = L["Velimar"],
		},
		-- Court of Stars: Disarming the Watch; no specific rare boss
		-- Court of Stars: The Deceitful Student
		[44854042] = {
			quest = 42784,
			dungeonLevel = 1,
			npc = 108796,
			label = L["Arcanist Malrodi"],
		},
		-- Court of Stars: They Bloom at Night; no specific rare boss
		-- Court of Stars: Wraith in the Machine
		[24991503] = {
			quest = 42764,
			dungeonLevel = 1,
			npc = 108701,
			label = L["Arcanist Malrodi"],
		},
	},
	[mapFile(1067)] = { -- Darkheart Thicket
		[36581548] = {
			type = "portal",
			label = L["Entrance"],
		},
		-- Darkheart Thicket: A Burden to Bear; no specific rare boss
		-- Darkheart Thicket: Kudzilla
		[38998510] = {
			quest = 42743,
			npc = 99362,
			label = L["Kudzilla"],
		},
		-- Darkheart Thicket: Mythana
		[26573661] = {
			quest = 42714,
			npc = 101641,
			label = L["Mythana"],
		},
		-- Darkheart Thicket: Preserving the Preservers
		[26711794] = {
			quest = 42744,
			npc = 108460,
			label = L["Injured Preserver Druid"],
			type = "yellowButton",
		},
		[31851984] = {
			quest = 42744,
			npc = 108460,
			label = L["Injured Preserver Druid"],
			type = "yellowButton",
		},
		[27303686] = {
			quest = 42744,
			npc = 108460,
			label = L["Injured Preserver Druid"],
			type = "yellowButton",
		},
		[38118485] = {
			quest = 42744,
			npc = 108460,
			label = L["Injured Preserver Druid"],
			type = "yellowButton",
		},
		[55762836] = {
			quest = 42744,
			npc = 108460,
			label = L["Injured Preserver Druid"],
			type = "yellowButton",
		},
		-- Darkheart Thicket: Rage Rot
		[19532347] = {
			quest = 42742,
			npc = 101660,
			label = L["Mythana"],
		},
	},
	[mapFile(1046)] = { -- Eye of Azshara
		[49278833] = {
			type = "portal",
			label = L["Entrance"],
		},
		[62675812] = {
			type = "yellowButton",
			quest = 39331,
			object = 248930,
			item = 127873,
			label = L["Crate of Corks"], -- pick up to get Advanced Corks
		},
		-- Eye of Azshara: A Tough Shell
		[87873459] = {
			quest = 42723,
			npc = 101467,
			label = L["Jaggen-Ra"],
		},
		-- Eye of Azshara: Azsunian Pearls; objects in several locations
		-- Eye of Azshara: Dread End
		[26563071] = {
			quest = 42746,
			npc = 108543,
			label = L["Dread Captain Thedon"],
		},
		-- Eye of Azshara: Slug It Out
		[33304966] = {
			quest = 42713,
			npc = 91788,
			label = L["Shellmaw"],
		},
		-- Eye of Azshara: Termination Claws
		[40202920] = {
			quest = 42712,
			npc = 101411,
			label = L["Gom Crabbar"],
		},
	},
	[mapFile(1041)] = { -- Halls of Valor
		[47580874] = {
			dungeonLevel = 2,
			type = "portal",
			label = L["Entrance"],
		},
		[38907367] = {
			dungeonLevel = 2,
			type = "portal",
			label = L["Portal"],
		},
		-- Halls of Valor: A Gift for Vethir; items inside halls of valor which should be a bit easy to be found
		-- Halls of Valor: A Worthy Challenge
		[47486741] = {
			dungeonLevel = 2,
			quest = 42241,
			npc = 106320,
			label = L["Volynd Stormbringer"],
		},
		-- Halls of Valor: Deeds of the Past; items inside halls of valor which should be a bit easy to be found
		-- Halls of Valor: Ponderous Poaching
		[24286477] = {
			dungeonLevel = 1,
			quest = 42240,
			npc = 96647,
			label = L["Earlnoc the Beastbreaker"],
		},
		-- Halls of Valor: The Bear King
		[59016086] = {
			dungeonLevel = 1,
			quest = 42239,
			npc = 99802,
			label = L["Arthfael"],
		},
		-- Fenryr
		[36033345] = {
			dungeonLevel = 1,
			npc = 99868,
			label = L["Fenryr"],
			note = L["Fenryr's western spawn point"],
		},
		[55856517] = {
			dungeonLevel = 1,
			npc = 99868,
			label = L["Fenryr"],
			note = L["Fenryr's eastern spawn point"],
		},
		[68732717] = {
			dungeonLevel = 1,
			type = "portal",
			label = L["Portal"],
		},
	},
	[mapFile(1042)] = { -- Maw of Souls
		[46308458] = {
			dungeonLevel = 1,
			type = "portal",
			label = L["Entrance"],
		},
		[56922400] = {
			dungeonLevel = 1, 
			type = "portal",
			label = L["Echoing Horn of the Damned"],
		},
		-- Maw of Souls: From Hell's Mouth
		[45456606] = {
			dungeonLevel = 2,
			quest = 42780,
			npc = 103045,
			label = L["Plaguemaw"],
		},
		-- Maw of Souls: Menace of the Seas
		[51785575] = {
			dungeonLevel = 2,
			quest = 42757,
			npc = 108494,
			label = L["Soulfiend Tagerma <Corruptor of the Seas>"],
		},
		-- Maw of Souls: Return of the Beast
		[51846590] = {
			dungeonLevel = 2,
			quest = 42788,
			npc = 103605,
			label = L["Shroudseeker"],
		},
	},
	[mapFile(1065)] = { -- Neltharion's Lair
		[89195472] = {
			type = "portal",
			label = L["Entrance"],
		},
		[88203756] = {
			npc = 111746,
			icon = "Interface\\MERCHANTFRAME\\UI-BuyBack-Icon",
			label = L["Mushroom Merchant"],
		},
		[44084800] = {
			quest = 39335,
			type = "yellowButton",
			item = 127874,
			object = 249024,
			label = L["Precipitating Powder"],
		},
		-- Neltharion's Lair: Blighted Bat
		[34768055] = {
			quest = 41866,
			npc = 103199,
			label = L["Ragoul"],
		},
		-- Neltharion's Lair: Crystalline Crusher
		[67648680] = {
			quest = 41864,
			npc = 103247,
			label = L["Ultanok"],
		},
		-- Neltharion's Lair: Mother of Stone
		[43231098] = {
			quest = 41865,
			npc = 103271,
			label = L["Kraxa <Mother of Gnashers>"],
		},
		-- Neltharion's Lair: Neltharion's Treasure
		[50315450] = {
			quest = 41211,
			object = 247348,
			item = 138783, -- Glittering Memento
			type = "yellowButton",
			label = L["Neltharion's Treasure"],
		},
--[[		[59087550] = {
			quest = 41211,
			object = 247348,
			type = "yellowButton",
			label = L["Neltharion's Treasure"],
		},
		[57049857] = {
			quest = 41211,
			object = 247348,
			type = "yellowButton",
			label = L["Neltharion's Treasure"],
		},]]
		-- Neltharion's Lair: Stonedark Slaves
		[53628118] = {
			quest = 41857,
			npc = 103597,
			label = L["Understone Lasher"],
		},
	},
	[mapFile(1115)] = { -- Return to Karazhan
		-- entrance
		[64086045] = {
			dungeonLevel = 6, 
			type = "portal",
			label = L["Entrance"],
		},
		-- Soul Fragment
		[27333631] = {
			dungeonLevel = 4, 
			quest = 44734,
			--npc = 115105,
			spell = 235422,
			type = "yellowButton",
			label = L["Opera Hall Soul Fragment"],
		},
		[82032082] = {
			dungeonLevel = 4, 
			quest = 44734,
			--npc = 115013,
			spell = 235418,
			type = "yellowButton",
			label = L["Guest Chambers Soul Fragment"],
		},
		[23606258] = {
			dungeonLevel = 3, 
			quest = 44734,
			--npc = 115103,
			spell = 235419,
			type = "yellowButton",
			label = L["Banquet Hall Soul Fragment"],
		},
		[74352005] = {
			dungeonLevel = 1, 
			quest = 44734,
			--npc = 115101,
			spell = 235421,
			type = "yellowButton",
			label = L["Servant Quarters Soul Fragment"],
		},
		[44717557] = {
			dungeonLevel = 9, 
			quest = 44734,
			--npc = 115113,
			spell = 235417,
			type = "yellowButton",
			label = L["Menagerie Soul Fragment"],
		},
		-- portal
		[75222055] = {
			dungeonLevel = 1, 
			type = "portal",
			label = L["Portal"],
		},
		-- portal
		[51397567] = {
			dungeonLevel = 9, 
			type = "portal",
			label = L["Portal"],
		},
		[09252514] = {
			dungeonLevel = 12, 
			quest = 45238,
			item = 143537,
			icon = "Interface\\ICONS\\inv_misc_qirajicrystal_04",
			label = L["Mana Focus"],
		},
		[10273322] = {
			dungeonLevel = 12, 
			type = "portal",
			label = L["Portal"],
		},
	},
	[mapFile(1079)] = { -- The Arcway
		[47682114] = {
			type = "portal",
			label = L["Portal"],
		},
		[22176429] = {
			quest = 42491,
			item = 138394,
			type = "yellowButton",
			label = L["Suramar Leyline Map"],
		},
		-- The Arcway: Arcanist Down
		[58165367] = {
			quest = 43639,
			npc = 111060,
			label = L["Arcanist Naran"],
		},
		-- The Arcway: Clogged Drain
		[47868145] = {
			quest = 43637,
			npc = 111021,
			label = L["Sludge Face"],
		},
		-- The Arcway: Creeping Suspicions
		-- The Arcway: Silver Serpent
		[48004236] = {
			quest = 43640,
			npc = 111052,
			label = L["Silver Serpent"],
		},
		-- The Arcway: Wandering Plague
		[37934847] = {
			quest = 43641,
			npc = 111057,
			label = L["The Rat King"],
		},
	},
	[mapFile(1094)] = { -- The Emerald Nightmare
	},
	[mapFile(1088)] = { -- The Nighthold
		[25508836] = {
			dungeonLevel = 1,
			type = "portal",
			label = L["Portal"],
		},
		[55863583] = {
			dungeonLevel = 3,
			type = "portal",
			label = L["Portal"],
		},
		[37016460] = {
			dungeonLevel = 3,
			type = "portal",
			label = L["Portal"],
		},
		[48844650] = {
			dungeonLevel = 3,
			type = "portal",
			label = L["Portal"],
		},
		[44105401] = {
			dungeonLevel = 3,
			type = "portal",
			label = L["Portal"],
		},
		[29432304] = {
			dungeonLevel = 7,
			type = "portal",
			label = L["Portal"],
		},
		-- The Nighthold: Creepy Crawlers
		[48526454] = {
			dungeonLevel = 2, 
			quest = 44934,
			npc = 116008,
			label = L["Kar'zun"],
		},
		-- The Nighthold: Ettin Your Foot In The Door
		[42796181] = {
			dungeonLevel = 1, 
			quest = 44932,
			npc = 115914,
			label = L["Torm the Brute"],
		},
		-- The Nighthold: Focused Power
		[45034811] = {
			dungeonLevel = 3, 
			quest = 44937,
			npc = 116395,
			label = L["Nightwell Diviner"],
		},
		-- The Nighthold: Gilded Guardian
		[47103015] = {
			dungeonLevel = 2, 
			quest = 44935,
			npc = 112712,
			label = L["Gilded Guardian <Spellblade's Construct>"],
		},
		-- The Nighthold: Love Tap
--[[		[47103015] = { -- location unknown
			dungeonLevel = 3, 
			quest = 44938,
			npc = 117240,
			label = L["Wily Sycophant"],
		},]]
		-- The Nighthold: Seeds of Destruction
		[57114732] = {
			dungeonLevel = 4, 
			quest = 44939,
			npc = 115853,
			label = L["Doomlash"],
		},
		-- The Nighthold: Supply Routes
		[19655976] = {
			dungeonLevel = 3, 
			quest = 44936,
			npc = 116004,
			label = L["Flightmaster Volnath <Flight Master>"],
		},
		-- The Nighthold: Wailing In The Night
		[38944374] = {
			dungeonLevel = 1, 
			quest = 44933,
			npc = 115847,
			label = L["Ariadne"],
		},
	},
	[mapFile(1147)] = { -- Tomb of Sargeras
	--[[
		-- Tomb of Sargeras: Legend of the Deep
		[00000000] = { -- location unknown
			dungeonLevel = 1, 
			quest = 46500,
			npc = 120022,
			label = L["Deepmaw"],
		},
		-- Tomb of Sargeras: Lost But Not Forgotten
		[00000000] = { -- location unknown
			dungeonLevel = 1, 
			quest = 46505,
			npc = 120009,
			label = L["Naisha"],
		},
		-- Tomb of Sargeras: Life After Death
		[00000000] = { -- location unknown
			dungeonLevel = 1, 
			quest = 46506,
			npc = 120019,
			label = L["Ryul the Fading"],
		},
	]]
		-- Tomb of Sargeras: The Dread Stalker
		[60258599] = { 
			dungeonLevel = 3, 
			quest = 46507,
			npc = 120013,
			label = L["The Dread Stalker"],
		},
		-- Tomb of Sargeras: Azshara's Reach
		[63595512] = { 
			dungeonLevel = 2, 
			quest = 46508,
			npc = 120003,
			label = L["Warlord Darjah"],
		},
	},
	[mapFile(1114)] = { -- Trial of Valor
		-- no WQ here so far
	},
	[mapFile(1045)] = { -- Vault of the Wardens
		[69087682] = {
			dungeonLevel = 1,
			type = "portal",
			label = L["Portal"],
		},
		[46631642] = {
			dungeonLevel = 2,
			quest = 39341,
			npc = 105824,
			label = L["Grimoira <Devourer of Entrails>"],
			note = L["Requires Skaggldrynk"],
		},
		[54633548] = {
			dungeonLevel = 3,
			quest = 44486,
			object = 258979,
			type = "yellowButton",
			label = L["Fel-Ravaged Tome"],
		},
		-- Vault of the Wardens: A Grim Matter; items collecting
		-- Vault of the Wardens: How'd He Get Up There?
		[24282694] = {
			dungeonLevel = 1, 
			quest = 42926,
			npc = 96579,
			label = L["Frenzied Animus <Vortex, Arcane Enchanted, Dampening, Mortar, Lightning Enchanted>"],
		},
		-- Vault of the Wardens: Startup Sequence; no rare boss
	},
}
