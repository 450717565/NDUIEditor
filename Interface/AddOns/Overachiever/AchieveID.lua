
OVERACHIEVER_ACHID = {
	WorldExplorer = 46,		-- "World Explorer"
	LoveCritters = 1206,	-- "To All The Squirrels I've Loved Before"
	LoveCritters2 = 2557,	-- "To All The Squirrels Who Shared My Life"
	LoveCritters3 = 5548,	-- "To All the Squirrels Who Cared for Me"
	LoveCritters4 = 6350,	-- "To All the Squirrels I Once Caressed?"
	PestControl = 2556,		-- "Pest Control"
	WellRead = 1244,		-- "Well Read"
	HigherLearning = 1956,	-- "Higher Learning"

	TastesLikeChicken = 1832,	-- "Takes Like Chicken"
	HappyHour = 1833,		-- "It's Happy Hour Somewhere"
	CataclysmicallyDelicious = 5753,-- "Cataclysmically Delicious"
	DrownYourSorrows = 5754,	-- "Drown Your Sorrows"
	PandarenCuisine = 7329,		-- "Pandaren Cuisine"
	PandarenDelicacies = 7330,	-- "Pandaren Delicacies"
	DraenorCuisine = 9502,		-- "Draenor Cuisine"
	BrewfestDiet = 1185,		-- "The Brewfest Diet"
	DarkmoonFaireFeast = 6026,	-- "Fairegoer's Feast"

	RightAsRain = 5779,		-- "You'll Feel Right as Rain"

	Scavenger = 1257,			-- "The Scavenger"
	OutlandAngler = 1225,		-- "Outland Angler"
	NorthrendAngler = 1517,		-- "Northrend Angler"
	Limnologist = 5478,			-- "The Limnologist"
	Oceanographer = 5479,		-- "The Oceanographer"
	PandarianAngler = 7611,		-- "Pandarian Angler"
	DraenorAngler = 9462,		-- "Draenor Angler"

	GourmetOutland = 1800,		-- "The Outland Gourmet"
	GourmetNorthrend = 1779,	-- "The Northrend Gourmet" (last part)
	GourmetCataclysm = 5473,	-- "The Cataclysmic Gourmet" (last part)
	GourmetPandaren = 7327,		-- "The Pandaren Gourmet" (last part)
	--GourmetWinter = 1688,		-- "The Winter Veil Gourmet" -- requires proper season; waiting on season detection feature?
	GourmetDraenor = 9501,		-- "The Draenor Gourmet"
	LegionMenu = 10762,			-- "The Legion Menu"

	MediumRare = 1311,			-- "Medium Rare"
	BloodyRare = 1312,			-- "Bloody Rare"
	NorthernExposure = 2256,	-- "Northern Exposure"
	Frostbitten = 2257,			-- "Frostbitten"
	Glorious = 7439,			-- "Glorious!"

	StoodInTheFire = 5518,		-- "Stood in the Fire"
	SurveyingTheDamage = 4827,	-- "Surveying the Damage"
	WhaleShark = 4975,			-- "From Hell's Heart I Stab at Thee"

	LetItSnow = 1687,		-- "Let It Snow"
	FistfulOfLove = 1699,	-- "Fistful of Love"
	BunnyMaker = 2422,		-- "Shake Your Bunny-Maker"
	CheckYourHead = 291,	-- "Check Your Head"
	TurkeyLurkey = 3559,	-- "Turkey Lurkey"

	-- Statistics:
	Stat_ConsumeDrinks = 346,	-- "Beverages consumed"
	Stat_ConsumeFood = 347,		-- "Food eaten"
	--1774 "Different beverages consumed"
	--1775 "Different foods eaten"
};

local IsAlliance = UnitFactionGroup("player") == "Alliance"

OVERACHIEVER_MOB_CRIT = {
	-- For achievements where Overachiever's "kill" criteria lookup doesn't work, e.g. due to the asset ID being for quests instead of NPCs for some
	-- reason. Format: [<mob ID>] = { <achievement ID>, <ach's criteria index>[, <2nd achievement ID>, <2nd ach's criteria index>[, ...]] }  ()

	-- Adventurer of Azsuna:
	[90244] = { 11261, 10 }, -- Unbound Rift (start w/object)
	[90505] = { 11261, 11 }, -- Syphonus & Leodrath
	[90803] = { 11261, 12 }, -- Cache of Infernals (start w/object)
	[91115] = { 11261, 14 }, -- Tide Behemoth
	[91100] = { 11261, 16 }, -- Marius & Tehd versus a Fel Lord
	[91579] = { 11261, 17 }, -- Marius & Tehd versus a Doomlord
	[105938] = { 11261, 18 }, -- Marius & Tehd versus Felbats
	[112637] = { 11261, 22 }, -- Treacherous Stallions (1/2)
	[112636] = { 11261, 22 }, -- Treacherous Stallions (2/2)
	[107657] = { 11261, 23 }, -- Arcanist Shal'iman
	[107113] = { 11261, 24 }, -- Vorthax
	[107269] = { 11261, 25 }, -- Inquisitor Tivos (mark portal object?)
	[89016] = { 11261, 26 }, -- Ravyn-Drath
	-- Adventurer of Val'sharah
	[93654] = { 11262, 7 }, -- Elindya Featherlight (start w/friendly NPC)
	--[] = { 11262, 8 }, -- Antydas Nightcaller
	[94414] = { 11262, 9 }, -- Haunted Manor (start w/object)
	[94485] = { 11262, 10 }, -- Purging the River (start w/friendly NPC? though I usually just see it wandering)
	[95123] = { 11262, 11 }, -- Grelda the Hag
	[95221] = { 11262, 12 }, -- Old Bear Trap (start w/object (or NPC-thing?))
	[95318] = { 11262, 13 }, -- Perrexx the Corruptor
	[97504] = { 11262, 14 }, -- Wraithtalon
	[97517] = { 11262, 15 }, -- Dreadbog
	[98241] = { 11262, 16 }, -- Lyrath Moonfeather
	[109708] = { 11262, 17 }, -- Undgrell Attack
	[110562] = { 11262, 18 }, -- Bahagar
	[92104] = { 11262, 19 }, -- Unguarded Thistleleaf Treasure (start w/object, end w/object)
	[93679] = { 11262, 20 }, -- Marius & Tehd versus a Satyr
	-- Adventurer of Highmountain:
	[101077] = { 11264, 1 }, -- Sekhan
	[97653] = { 11264, 2 }, -- The Beastly Boxer
	[97933] = { 11264, 3 }, -- Crab Rider Grmlrml
	[97345] = { 11264, 4 }, -- Crawshuk the Hungry
	[96590] = { 11264, 5 }, -- Gurbog da Basher
	[97326] = { 11264, 6 }, -- Hartli the Snatcher
	[95872] = { 11264, 7 }, -- Skywhisker Taskmaster
	[100302] = { 11264, 8 }, -- Unethical Adventurers (1/5)
	[109498] = { 11264, 8 }, -- Unethical Adventurers (2/5)
	[100303] = { 11264, 8 }, -- Unethical Adventurers (3/5)
	[109501] = { 11264, 8 }, -- Unethical Adventurers (4/5)
	[109500] = { 11264, 8 }, -- Unethical Adventurers (5/5)
	[97203] = { 11264, 9 }, -- The Exiled Shaman
	--[] = { 11264, 10 }, -- Beastmaster Pao'lek (friendly NPC starts: 97215)
	[96410] = { 11264, 11 }, -- Majestic Elderhorn
	[97449] = { 11264, 12 }, -- Bristlemaul
	[97593] = { 11264, 13 }, -- Scout Harefoot (start w/friendly NPC)
	[95204] = { 11264, 14 }, -- Oubdob da Smasher
	[98299] = { 11264, 15 }, -- Bodash the Hoarder
	[100232] = { 11264, 16 }, -- Amateur Hunters (1/3)
	[100230] = { 11264, 16 }, -- Amateur Hunters (2/3)
	[100231] = { 11264, 16 }, -- Amateur Hunters (3/3)
	[97102] = { 11264, 17 }, -- Totally Safe Treasure Chest (start w/object)
	[100495] = { 11264, 18 }, -- Devouring Darkness (start w/object)
	[96621] = { 11264, 19 }, -- Mellok, Son of Torok
	[98024] = { 11264, 20 }, -- Luggut the Eggeater
	[97093] = { 11264, 21 }, -- Shara Felbreath
	[98890] = { 11264, 22 }, -- Slumbering Bear
	[98311] = { 11264, 23 }, -- Captured Survivor (start w/friendly NPC)
	-- Adventurer of Stormheim:
	[91529] = { 11263, 1 }, -- Glimar Ironfist
	[91795] = { 11263, 2 }, -- Stormwing Matriarch
	[98225] = { 11263, 3 }, -- Fathnyr
	[91874] = { 11263, 4 }, -- Bladesquall
	[91895] = { 11263, 5 }, -- Thane's Mead Hall (1/4)
	[91893] = { 11263, 5 }, -- Thane's Mead Hall (2/4)
	[91894] = { 11263, 5 }, -- Thane's Mead Hall (3/4)
	[91892] = { 11263, 5 }, -- Thane's Mead Hall (4/4)
	[92040] = { 11263, 6 }, -- Fenri
	[92152] = { 11263, 7 },	-- Whitewater Typhoon
	[92599] = { 11263, 8 }, -- Worg Pack
	[IsAlliance and 92631 or 92604] = { 11263, 9 }, -- Worgen Stalkers or Forsaken Deathsquad (1/4)
	[IsAlliance and 92634 or 92613] = { 11263, 9 }, -- Worgen Stalkers or Forsaken Deathsquad (2/4)
	[IsAlliance and 92626 or 92609] = { 11263, 9 }, -- Worgen Stalkers or Forsaken Deathsquad (3/4)
	[IsAlliance and 92633 or 92611] = { 11263, 9 }, -- Worgen Stalkers or Forsaken Deathsquad (4/4)
	[92685] = { 11263, 10 }, -- Helmouth Raiders (start w/object)
	[92751] = { 11263, 11 }, -- Ivory Sentinel
	[92763] = { 11263, 12 }, -- The Nameless King (start w/object)
	[93166] = { 11263, 13 }, -- Lost Ettin
	[93371] = { 11263, 14 }, -- Mordvigbjorn
	[93401] = { 11263, 15 }, -- Urgev the Flayer
	[94413] = { 11263, 16 }, -- Isel the Hammer
	[97630] = { 11263, 17 }, -- Soulthirster
	[98188] = { 11263, 18 }, -- Egyl the Enduring
	[98268] = { 11263, 19 }, -- Tarben
	[98421] = { 11263, 20 }, -- Kottr Vondyr
	[98503] = { 11263, 21 }, -- Grrvrgull the Conquerer
	[107926] = { 11263, 22 }, -- Hannval the Butcher
	[110363] = { 11263, 23 }, -- Roteye
	[90139] = { 11263, 24 }, -- Marius & Tehd versus an Inquisitor
	-- Adventurer of Suramar:
	[99610] = { 11265, 1 }, -- Garvulg
	[99792] = { 11265, 2 }, -- Elfbane
	[100864] = { 11265, 3 }, -- Cora'kar
	[103183] = { 11265, 4 }, -- Rok'nash
	[103214] = { 11265, 5 }, -- Har'kess the Insatiable
	[103223] = { 11265, 6 }, -- Hertha Grimdottir
	[103575] = { 11265, 7 }, -- Reef Lord Raj'his
	[103841] = { 11265, 8 }, -- Shadowquil
	[105547] = { 11265, 9 }, -- Rauren
	[106351] = { 11265, 10 }, -- Artificer Lothaire
	[107846] = { 11265, 11 }, -- Pinchshank
	[109054] = { 11265, 12 }, -- Shal'an
	[109954] = { 11265, 13 }, -- Magister Phaedris
	[110024] = { 11265, 14 }, -- Mal'Dreth the Corrupter
	[110340] = { 11265, 15 }, -- Myonix
	[110438] = { 11265, 16 }, -- Seigemaster Aedrin
	[110577] = { 11265, 17 }, -- Oreth the Vile
	[110656] = { 11265, 18 }, -- Arcanist Lylandre
	[110726] = { 11265, 19 }, -- Cadraeus
	[110824] = { 11265, 20 }, -- Tideclaw
	[110832] = { 11265, 21 }, -- Gorgroth (summoned by an item?)
	[110870] = { 11265, 22 }, -- Apothecary Faldren
	[110944] = { 11265, 23 }, -- Guardian Thor'el
	[111063] = { 11265, 24 }, -- Randril
	[111197] = { 11265, 25 }, -- Anax
	[111329] = { 11265, 26 }, -- Matron Hagatha
	[111649] = { 11265, 27 }, -- Ambassador D'vwinn
	[111651] = { 11265, 28 }, -- Degren
	[111653] = { 11265, 29 }, -- Miasu
	[112497] = { 11265, 30 }, -- Maia the White
	[112802] = { 11265, 31 }, -- Mar'tura
	[102303] = { 11265, 32 }, -- Lieutenant Strathmar
};

--[[
function Overachiever.Debug_WHICHCRIT(id)
	print("Examining "..id..".")
	local c, name, crittype = 0
	local s = ""
	local num = GetAchievementNumCriteria(id)
	for i=1,num do
		name, crittype = GetAchievementCriteriaInfo(id, i)
		if (crittype == 27) then
			print("- quest type:|cff7eff00", id, i, name)
			c = c + 1
			s = s.."\n  [] = { "..id..", "..i.." }, -- "..name
		elseif (crittype == 0) then  --print("- kill type:", id, i, name);
		else  print("! unexpected type ("..crittype.."):", id, i, name);
		end
	end
	print("Done.",c,"out of",num,"are quest type.")
	return s
end
--/run error(WHICHCRIT(11261)) -- Adventurer of Azsuna
--/run error(WHICHCRIT(11262)) -- Adventurer of Val'sharah
--/run error(WHICHCRIT(11264)) -- Adventurer of Highmountain
--/run error(WHICHCRIT(11263)) -- Adventurer of Stormheim
--/run error(WHICHCRIT(11265)) -- Adventurer of Suramar
--]]


-- Battleground Timed Wins:
OVERACHIEVER_BGTIMERID = {
	-- Format: [<Achievement ID>] = <Instance Map ID>. See: http://wow.gamepedia.com/InstanceMapID#Battlegrounds
	[201] = 489, -- Warsong Expedience (Warsong Gulch) [working around bug]
	[159] = 529, -- Let's Get This Done (Arathi Basin) [working around bug]
	[214] = 566, -- Flurry (Eye of the Storm)
	[226] = 30, -- The Alterac Blitz (Alterac Valley) -- worked when not present (but needs to be present bc separate option now)
	-- none for Isle of Conquest
	[1310] = 607, -- Storm the Beach (Strand of the Ancients) -- this is for the attack round only, not whole match
	[5254] = 761, -- Newbs to Plowshares (Battle for Gilneas) [working around bug]
	[5216] = 726, -- Peak Speed (Twin Peaks) [working around bug]
	-- none for Silvershard Mines
	-- none for Temple of Kotmogu
	-- none for Deepwind Gorge
	-- not instanced: [1755] = -1, -- Within Our Grasp (Wintergrasp)
	-- none for Tol Barad
	-- none for Ashran
}
OVERACHIEVER_BGTIMERID_RATED = {
	[214] = 968, -- Flurry (Eye of the Storm)
}

--!! 202 1502 (horde) -- blizzard actually triggered it for BOTH factions! silly
--!! 5221 5222 fire, walk with me (both factions again)

-- Look up the achievement ID of the given zone's exploration achievement, whatever the localization.
-- Using zone names alone isn't reliable because the achievement names don't always use the zone's name as given by
-- functions like GetRealZoneText() with some localizations.

OVERACHIEVER_EXPLOREZONEID = {
-- Kalimdor:
	["Ashenvale"] = 845,
	["Azshara"] = 852,
	["Darkshore"] = 844,
	["Desolace"] = 848,
	["Durotar"] = 728,
	["Dustwallow Marsh"] = 850,
	["Felwood"] = 853,
	["Feralas"] = 849,
	["Moonglade"] = 855,
	["Mulgore"] = 736,
	["Northern Barrens"] = 750,
	["Silithus"] = 856,
	["Southern Barrens"] = 4996,
	["Stonetalon Mountains"] = 847,
	["Tanaris"] = 851,
	["Teldrassil"] = 842,
	["Thousand Needles"] = 846,
	["Un'Goro Crater"] = 854,
	["Winterspring"] = 857,
   -- Burning Crusade:
	["Azuremyst Isle"] = 860,
	["Bloodmyst Isle"] = 861,
   -- Cataclysm:
	["Mount Hyjal"] = 4863,
	["Uldum"] = 4865,
-- Eastern Kingdoms:
	["Arathi Highlands"] = 761,
	["Badlands"] = 765,
	["Blasted Lands"] = 766,
	["Burning Steppes"] = 775,
	["The Cape of Stranglethorn"] = 4995,
	["Deadwind Pass"] = 777,
	["Dun Morogh"] = 627,
	["Duskwood"] = 778,
	["Eastern Plaguelands"] = 771,
	["Elwynn Forest"] = 776,
	["Hillsbrad Foothills"] = 772,
	["The Hinterlands"] = 773,
	["Loch Modan"] = 779,
	["Northern Stranglethorn"] = 781,
	["Redridge Mountains"] = 780,
	["Searing Gorge"] = 774,
	["Silverpine Forest"] = 769,
	["Swamp of Sorrows"] = 782,
	["Tirisfal Glades"] = 768,
	["Western Plaguelands"] = 770,
	["Westfall"] = 802,
	["Wetlands"] = 841,
	-- Zone removed: ["Alterac Mountains"] = 760,
   -- Burning Crusade:
	["Eversong Woods"] = 859,
	["Ghostlands"] = 858,
	["Isle of Quel'Danas"] = 868,
   -- Cataclysm:
	--["Tol Barad"] = 4867,           -- This achievement ("Explore Tol Barad") was removed from the game
	--["Tol Barad Peninsula"] = 4867, -- due to it being buggy. Note that it may return in a future patch.
	["Twilight Highlands"] = 4866,
	-- Vashj'ir:
	["Vashj'ir"] = 4825,
	["Kelp'thar Forest"] = 4825,
	["Shimmering Expanse"] = 4825,
	["Abyssal Depths"] = 4825,
-- Outland:
	["Blade's Edge Mountains"] = 865,
	["Hellfire Peninsula"] = 862,
	["Nagrand (Outland)"] = 866, -- RENAMED ZONE
	["Netherstorm"] = 843,
	["Shadowmoon Valley (Outland)"] = 864, -- RENAMED ZONE
	["Terokkar Forest"] = 867,
	["Zangarmarsh"] = 863,
-- Northrend:
	["Borean Tundra"] = 1264,
	["Crystalsong Forest"] = 1457,
	["Dragonblight"] = 1265,
	["Grizzly Hills"] = 1266,
	["Howling Fjord"] = 1263,
	["Icecrown"] = 1270,
	["Sholazar Basin"] = 1268,
	["The Storm Peaks"] = 1269,
	["Zul'Drak"] = 1267,
-- Other Cataclysm-related:
	["Deepholm"] = 4864,
-- Pandaria:
	["The Jade Forest"] = 6351,
	["Krasarang Wilds"] = 6975,
	["Kun-Lai Summit"] = 6976,
	["Valley of the Four Winds"] = 6969,
	["Townlong Steppes"] = 6977,
	["Dread Wastes"] = 6978,
	["Vale of Eternal Blossoms"] = 6979,
-- Draenor
	["Frostfire Ridge"] = 8937,
	["Shadowmoon Valley (Draenor)"] = 8938,
	["Gorgrond"] = 8939,
	["Talador"] = 8940,
	["Spires of Arak"] = 8941,
	["Nagrand (Draenor)"] = 8942,
	["Tanaan Jungle"] = 10260,
-- Legion
	["Azsuna"] = 10665,
	["Val'sharah"] = 10666,
	["Highmountain"] = 10667,
	["Stormheim"] = 10668,
	["Suramar"] = 10669,
	["Broken Shore"] = 11543,
};
OVERACHIEVER_EXPLOREZONEID["Thunder Totem"] = OVERACHIEVER_EXPLOREZONEID["Highmountain"]
-- "Explore Cataclysm": 4868


local LBZ = LibStub("LibBabble-SubZone-3.0");
LBZ = LBZ:GetReverseLookupTable()

function Overachiever.ExploreZoneIDLookup(zoneName)
  local z = LBZ[zoneName] or zoneName
  z = Overachiever.GetZoneKey(z)
  return OVERACHIEVER_EXPLOREZONEID[z]
end


--[[ These categories no longer exist!:
OVERACHIEVER_CATEGORY_HEROIC = {
	[14921] = true, -- Lich King Dungeon
	[14923] = true, -- Lich King 25-Player Raid
};
OVERACHIEVER_CATEGORY_25 = {
	[14923] = true,			-- Lich King 25-Player Raid
	[14962] = true,			-- Secrets of Ulduar 25-Player Raid
	[15002] = true,			-- Call of the Crusade 25-Player Raid
	[15042] = true,			-- Fall of the Lich King 25-Player Raid
};
--]]

OVERACHIEVER_HEROIC_CRITERIA = {
	[1658] =			-- "Champion of the Frozen Wastes"
		{ [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true,		  
		  [12] = true, [13] = true, [14] = true, [15] = true },
--[[ this data seems wrong. was this achievement changed at some point or has it always been wrong?
		{ [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, [10] = true, [11] = true, [12] = true,
		  [13] = true, [14] = true, [15] = true },
--]]
};



-- ZONE RENAMES AND LOOKUP BY MAP ID (helps handle issues where a zone name is used multiple times)
-- To find a zone's map ID, open the map to it and use: /dump GetCurrentMapAreaID()
Overachiever.ZONE_RENAME = {
--[[
	["Zone's real name"] = {
		[one of the map IDs] = "The key we're using for this zone",
	},
--]]
	["Dalaran"] = {
		[504] = "Dalaran (Northrend)",
		[1014] = "Dalaran (Broken Isles)",
	},
	["Shadowmoon Valley"] = {
		[473] = "Shadowmoon Valley (Outland)",
		[947] = "Shadowmoon Valley (Draenor)",
	}
	,
	["Nagrand"] = {
		[477] = "Nagrand (Outland)",
		[950] = "Nagrand (Draenor)",
	},
	["Karazhan"] = { -- !! double check
		[1115] = "Return to Karazhan",
	},
}
-- If adding to this, don't forget to add to ZONE_RENAME_REV in Overachiever_Tabs\Suggestions.lua as well.

local ZONE_RENAME = Overachiever.ZONE_RENAME


function Overachiever.GetZoneKey(zoneName) -- zoneName here is expected to be in English
  if (ZONE_RENAME[zoneName]) then
    local mapID = Overachiever.GetCurrentMapID()
    if (mapID and ZONE_RENAME[zoneName][mapID]) then
      --Overachiever.chatprint(zoneName .. " got renamed to " .. ZONE_RENAME[zoneName][mapID])
      return ZONE_RENAME[zoneName][mapID]
    end
  end
  return zoneName
end

function Overachiever.GetCurrentMapID()
  local prevContinent
  local prevMap, isContinent = GetCurrentMapAreaID()
  local prevLevel = GetCurrentMapDungeonLevel()
  if (not prevMap or prevMap < 0 or isContinent) then
    prevContinent = GetCurrentMapContinent()
  end

  SetMapToCurrentZone()
  local id = GetCurrentMapAreaID()

  if (prevContinent) then
    SetMapZoom(prevContinent)
  else
    local level = GetCurrentMapDungeonLevel()
    if (prevMap and (prevMap ~= id or (prevLevel ~= level and prevLevel == 0))) then
      SetMapByID(prevMap)
    end
    if (prevLevel and prevLevel > 0) then
      SetDungeonMapLevel(prevLevel)
    end
  end
  return id
end

