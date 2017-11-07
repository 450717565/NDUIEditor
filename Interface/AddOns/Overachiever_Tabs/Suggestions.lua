
--
--  Overachiever - Tabs: Suggestions.lua
--    by Tuhljin
--
--  If you don't wish to use the suggestions tab, feel free to delete this file or rename it (e.g. to
--  Suggestions_unused.lua). The addon's other features will work regardless.
--

local L = OVERACHIEVER_STRINGS
local GetAchievementInfo = Overachiever.GetAchievementInfo
local GetAchievementCriteriaInfo = Overachiever.GetAchievementCriteriaInfo

local LBZ = LibStub("LibBabble-SubZone-3.0"):GetUnstrictLookupTable()
local LBZR = LibStub("LibBabble-SubZone-3.0"):GetReverseLookupTable()
local LBI = LibStub:GetLibrary("LibBabble-Inventory-3.0"):GetLookupTable()
local LBIR = LibStub:GetLibrary("LibBabble-Inventory-3.0"):GetReverseLookupTable()

local RecentReminders = Overachiever.RecentReminders

local IsAlliance = UnitFactionGroup("player") == "Alliance"
local suggested = {}

local showHidden, numHidden = false, 0

local ZONE_RENAME = Overachiever.ZONE_RENAME

local ZONE_RENAME_REV = { -- lookup table so localizations can use their own renames
--	["What we're calling this zone (localized)"] = "The key we're using for this zone",
	[L.SUGGESTIONS_ZONERENAME_DALARAN_NORTHREND] = "Dalaran (Northrend)",
	[L.SUGGESTIONS_ZONERENAME_DALARAN_BROKENISLES] = "Dalaran (Broken Isles)",
	[L.SUGGESTIONS_ZONERENAME_SHADOWMOONVALLEY_OUTLAND] = "Shadowmoon Valley (Outland)",
	[L.SUGGESTIONS_ZONERENAME_SHADOWMOONVALLEY_DRAENOR] = "Shadowmoon Valley (Draenor)",
	[L.SUGGESTIONS_ZONERENAME_NAGRAND_OUTLAND] = "Nagrand (Outland)",
	[L.SUGGESTIONS_ZONERENAME_NAGRAND_DRAENOR] = "Nagrand (Draenor)",
	[L.SUGGESTIONS_ZONERENAME_KARAZHAN_LEGION] = "Return to Karazhan",
}

--[[
local function isAtGarrison()
  return C_Garrison.IsOnGarrisonMap()
  -- Not perfect (returns false when the map opens to garrison but player is on the very outskirts) but good enough. Combined with using e.g. "Lunarfall"
  -- for zone name lookup, it should work great.
end
--]]

local ZONE_SPECIAL_REDIR = {
  --["Garrison"] = isAtGarrison,
  ["Garrison"] = C_Garrison.IsOnGarrisonMap,
}

local function GetZoneSpecialOverride()
  for key,func in pairs(ZONE_SPECIAL_REDIR) do
    if (func()) then  return key;  end
  end
  return false
end



-- ZONE-SPECIFIC ACHIEVEMENTS
----------------------------------------------------

local ACHID_ZONE_NUMQUESTS
if (IsAlliance) then
  ACHID_ZONE_NUMQUESTS = {
  -- Kalimdor
	["Ashenvale"] = 4925,
	--["Azshara"] = nil,
	["Darkshore"] = 4928,
	["Desolace"] = 4930, -- faction neutral?
	--["Durotar"] = nil,
	["Dustwallow Marsh"] = 4929,
	["Felwood"] = 4931, -- faction neutral
	["Feralas"] = 4932,
	--["Moonglade"] = nil,
	--["Mulgore"] = nil,
	--["Northern Barrens"] = nil,
	["Silithus"] = 4934, -- faction neutral
	["Southern Barrens"] = 4937,
	["Stonetalon Mountains"] = 4936,
	["Tanaris"] = 4935, -- faction neutral
	--["Teldrassil"] = nil,
	["Thousand Needles"] = 4938, -- faction neutral
	["Un'Goro Crater"] = 4939, -- faction neutral
	["Winterspring"] = 4940, -- faction neutral
    -- Burning Crusade:
	--["Azuremyst Isle"] = nil,
	["Bloodmyst Isle"] = 4926,
    -- Cataclysm:
	["Mount Hyjal"] = 4870,
	["Uldum"] = 4872,
  -- Eastern Kingdoms
	["Arathi Highlands"] = 4896, -- faction neutral
	["Badlands"] = 4900, -- faction neutral
	["Blasted Lands"] = 4909, -- faction neutral
	["Burning Steppes"] = 4901, -- faction neutral
	["The Cape of Stranglethorn"] = 4905,
	--["Deadwind Pass"] = nil,
	--["Dun Morogh"] = nil,
	["Duskwood"] = 4903,
	["Eastern Plaguelands"] = 4892, -- faction neutral
	--["Elwynn Forest"] = nil,
	--["Hillsbrad Foothills"] = nil,
	["The Hinterlands"] = 4897, -- faction neutral
	["Loch Modan"] = 4899,
	["Northern Stranglethorn"] = 4906,
	["Redridge Mountains"] = 4902,
	["Searing Gorge"] = 4910, -- faction neutral
	--["Silverpine Forest"] = nil,
	["Swamp of Sorrows"] = 4904, -- faction neutral
	--["Tirisfal Glades"] = nil,
	["Western Plaguelands"] = 4893, -- faction neutral
	["Westfall"] = 4903,
	["Wetlands"] = 4899,
     -- Burning Crusade:
	--["Eversong Woods"] = nil,
	--["Ghostlands"] = nil,
	--["Isle of Quel'Danas"] = nil,
     -- Cataclysm:
	["Twilight Highlands"] = 4873,
	-- Vashj'ir:
	["Vashj'ir"] = 4869,
	["Kelp'thar Forest"] = 4869,
	["Shimmering Expanse"] = 4869,
	["Abyssal Depths"] = 4869,
  -- Outland
	["Blade's Edge Mountains"] = 1193,
	["Zangarmarsh"] = 1190,
	["Netherstorm"] = 1194,
	["Hellfire Peninsula"] = 1189,
	["Terokkar Forest"] = 1191,
	["Shadowmoon Valley (Outland)"] = 1195,
	["Nagrand (Outland)"] = 1192,
  -- Northrend
	["Icecrown"] = 40,
	["Dragonblight"] = 35,
	["Howling Fjord"] = 34,
	["Borean Tundra"] = 33,
	["Sholazar Basin"] = 39,
	["Zul'Drak"] = 36,
	["Grizzly Hills"] = 37,
	["The Storm Peaks"] = 38,
  -- Other (Cataclysm)
	["Deepholm"] = 4871, -- faction neutral
  }
else
  ACHID_ZONE_NUMQUESTS = {
  -- Kalimdor
	["Ashenvale"] = 4976,
	["Azshara"] = 4927,
	--["Darkshore"] = nil,
	["Desolace"] = 4930, -- faction neutral?
	--["Durotar"] = nil,
	["Dustwallow Marsh"] = 4978,
	["Felwood"] = 4931, -- faction neutral
	["Feralas"] = 4979,
	--["Moonglade"] = nil,
	--["Mulgore"] = nil,
	["Northern Barrens"] = 4933,
	["Silithus"] = 4934, -- faction neutral
	["Southern Barrens"] = 4981,
	["Stonetalon Mountains"] = 4980,
	["Tanaris"] = 4935, -- faction neutral
	--["Teldrassil"] = nil,
	["Thousand Needles"] = 4938, -- faction neutral
	["Un'Goro Crater"] = 4939, -- faction neutral
	["Winterspring"] = 4940, -- faction neutral
    -- Burning Crusade:
	--["Azuremyst Isle"] = nil,
	--["Bloodmyst Isle"] = nil,
    -- Cataclysm:
	["Mount Hyjal"] = 4870,
	["Uldum"] = 4872,
  -- Eastern Kingdoms
	["Arathi Highlands"] = 4896, -- faction neutral
	["Badlands"] = 4900, -- faction neutral
	["Blasted Lands"] = 4909, -- faction neutral
	["Burning Steppes"] = 4901, -- faction neutral
	["The Cape of Stranglethorn"] = 4905,
	--["Deadwind Pass"] = nil,
	--["Dun Morogh"] = nil,
	--["Duskwood"] = nil,
	["Eastern Plaguelands"] = 4892, -- faction neutral
	--["Elwynn Forest"] = nil,
	["Hillsbrad Foothills"] = 4895,
	["The Hinterlands"] = 4897, -- faction neutral
	--["Loch Modan"] = nil,
	["Northern Stranglethorn"] = 4906,
	--["Redridge Mountains"] = nil,
	["Searing Gorge"] = 4910, -- faction neutral
	["Silverpine Forest"] = 4894,
	["Swamp of Sorrows"] = 4904, -- faction neutral
	--["Tirisfal Glades"] = nil,
	["Western Plaguelands"] = 4893, -- faction neutral
	--["Westfall"] = nil,
	--["Wetlands"] = nil,
     -- Burning Crusade:
	--["Eversong Woods"] = nil,
	["Ghostlands"] = 4908,
	--["Isle of Quel'Danas"] = nil,
     -- Cataclysm:
	["Twilight Highlands"] = 5501,
	-- Vashj'ir:
	["Vashj'ir"] = 4982,
	["Kelp'thar Forest"] = 4982,
	["Shimmering Expanse"] = 4982,
	["Abyssal Depths"] = 4982,
  -- Outland
	["Blade's Edge Mountains"] = 1193,
	["Zangarmarsh"] = 1190,
	["Netherstorm"] = 1194,
	["Hellfire Peninsula"] = 1271,
	["Terokkar Forest"] = 1272,
	["Shadowmoon Valley (Outland)"] = 1195,
	["Nagrand (Outland)"] = 1273,
  -- Northrend
	["Icecrown"] = 40,
	["Dragonblight"] = 1359,
	["Howling Fjord"] = 1356,
	["Borean Tundra"] = 1358,
	["Sholazar Basin"] = 39,
	["Zul'Drak"] = 36,
	["Grizzly Hills"] = 1357,
	["The Storm Peaks"] = 38,
  -- Other (Cataclysm)
	["Deepholm"] = 4871, -- faction neutral
  }
end

-- Achievements common to class halls:
local achClassHall = {
	10994, -- A Glorious Campaign
	11223, -- Legendary Research
	11298, -- A Classy Outfit
	
	10461, -- Fighting with Style: Classic
	10747, -- Fighting with Style: Upgraded
	10748, -- Fighting with Style: Valorous
	10749, -- Fighting with Style: War-torn
	11612, -- Fighting with Style: Challenging
	10852, -- Artifact or Artifiction
	11171, -- Arsenal of Power
	11609, -- Power Unbound
	11144, -- Power Realized

	10706, -- Training the Troops
	11214, -- Many Missions
	11218, -- There's a Boss In There
	11219, -- Need Backup
	11220, -- Roster of Champions
}

local achDarkmoonFaire = {
	6019, 6021, 6023, 6027, 6028, 6029, 6032, 6026, 6025, 6022, 6020, IsAlliance and 6030 or 6031, 6332, 9250, 9885, 9894, 9983, 9755, 9756, 9770, 9786, 9780, 9793, 9800, 9806, 9812, 9819,
	-- Blight Boar concert:
	11918, -- Hey, You're a Rockstar!
	11921, -- Mosh Pit
	11920, -- Perfect Performance
	11919, -- Taking this Show on the Road
}
-- To get base data:
-- 1. /run Overachiever.Debug_GetIDsInCat(15101, true)
-- 2. /reload
-- 3. Look in WTF saved variables for: Overachiever_Settings.Debug_AchIDsInCat
-- Run again on a character of the other faction and compare, then, adjust for the faction-specific ones (e.g. "IsAlliance and 6030 or 6031").
-- But don't just leave it at that; look over them to see if there are any you ought to omit since they're redundant (perhaps because another achievement
-- in the list includes it as a criteria) or otherwise not worth suggesting.

local achDraenorGarrison = {
	IsAlliance and 9564 or 9562, -- Securing Draenor
	IsAlliance and 9491 or 9492, -- The Garrison Campaign

	IsAlliance and 9100 or 9545, -- More Plots
	IsAlliance and 9210 or 9132, -- Garrison Buddies
	IsAlliance and 9928 or 9901, -- Don't Call Me Junior
	IsAlliance and 9828 or 9897, -- Ten Hit Tunes
	8933, -- Staying Regular
	9094, -- Garrison Architect

	9099, -- Time for an Upgrade

	-- Unlock blueprints:
	9406, -- Working More Orders (2nd in series; 1st is 9405, "Working Some Orders")
	9463, -- Draenic Pet Battler
	9454, -- Draenic Seed Collector
	9453, -- Draenic Stone Collector
	9462, -- Draenor Angler
	9129, -- Filling the Ranks (3rd in series; 1st is 9110, "Following Up")
	9497, -- Finding Your Waystones
	9487, -- Got My Mind On My Draenor Money
	9565, -- Master Trapper (2nd in series; 1st is 9450, "The Trap Game")
	9526, -- Master of Mounts (2nd in series; 1st is 9538, "Intro to Husbandry")
	9523, -- Patrolling Draenor (2nd in series; 1st is 9146, "Patrol Mission Specialist")
	9468, -- Salvaging Pays Off
	IsAlliance and 9478 or 9477, -- Savage Friends
	9703, -- Stay Awhile and Listen
	9527, -- Terrific Technology
	9495, -- The Bone Collector
	9429, -- Upgrading the Mill

	-- Other building-specific:
	9076, -- Choppin' Some Logs
	9498, -- Wingman
	IsAlliance and 9738 or 9508, -- Warlord of Draenor
	IsAlliance and 9539 or 9705, -- Advanced Husbandry
	IsAlliance and 9540 or 9706, -- The Stable Master
}
local achDraenorGarrisonShipyard = {
	10177, -- Set Sail! (series)
	10170, -- Seaman
	10164, -- Master of the Seas
	10165, -- Ironsides
	IsAlliance and 10256 or 10258, -- Charting a Course
	10166, -- Naval Mechanics (broken?)
}

local achBrawlersGuild = {
	IsAlliance and 11558 or 11559, -- The First Rule of Brawler's Guild (series)
	11567, -- You Are Not The Contents Of Your Wallet
	11570, -- Educated Guesser
	11572, -- I Am Thrall's Complete Lack Of Surprise
	11573, -- Rumble Club
}

local ACHID_ZONE_MISC = {
-- Kalimdor
	["Ashenvale"] = "4827:6",	-- "Surveying the Damage"
	["Azshara"] = { 5448, 5546, 5547 },	-- "Glutton for Fiery/Icy/Shadowy Punishment"
	["Darkshore"] = { "4827:4" },	-- "Surveying the Damage"
	["Desolace"] = "4827:8",	-- "Surveying the Damage"
	["Durotar"] = "4827:7",		-- "Surveying the Damage"
	["Molten Front"] = { 5859, 5866, 5867,	-- "Legacy of Leyara", "The Molten Front Offensive", "Flawless Victory", "Fireside Chat", "Master of the Molten Flow",
		5870, 5871, 5872, 5873, 5874, 5879 }, -- "King of the Spider-Hill", "Ready for Raiding II", "Death From Above", "Veteran of the Molten Front"
	["Mount Hyjal"] = { 4959, 5483,		-- "Beware of the 'Unbeatable?' Pterodactyl", "Bounce",
		5859, 5860, 5861, 5862, 5864,	-- "Legacy of Leyara", "The 'Unbeatable?' Pterodactyl: BEATEN.", "The Fiery Lords of Sethria's Roost", "Ludicrous Speed", "Gang War",
		5865, 5868, 5869 },		-- "Have... Have We Met?", "And the Meek Shall Inherit Kalimdor", "Infernal Ambassadors"
	["Southern Barrens"] = "4827:1",	-- "Surveying the Damage"
	["Tanaris"] = "4827:5",		-- "Surveying the Damage"
	["Thousand Needles"] = "4827:9",	-- "Surveying the Damage"
	["Uldum"] =			-- "Help the Bombardier! I'm the Bombardier!", "One Hump or Two?",
		{ 5317, 4888, 4961 },	-- "In a Thousand Years Even You Might be Worth Something"
	["Winterspring"] = 5443,	-- "E'ko Madness"
-- Eastern Kingdoms
	["The Cape of Stranglethorn"] =	-- "Master Angler of Azeroth",
		{ 306, 389, 396,	-- "Gurubashi Arena Master", "Gurubashi Arena Grand Master",
		  "4827:2" },		-- "Surveying the Damage"
	["Northern Stranglethorn"] =	-- Need to confirm where these two achievements belong since Cataclysm:
		{ 306, 940 },	-- "Master Angler of Azeroth", "The Green Hills of Stranglethorn"
	["Badlands"] = "4827:3",	-- "Surveying the Damage"
	["Eastern Plaguelands"] = 5442,	-- "Full Caravan"
	--Peacebloom vs. Ghouls achievements unavailable at this time:
	--["Hillsbrad Foothills"] = { 5364, 5365,	-- "Don't Want No Zombies on My Lawn", "Bloom and Doom",
	--			    "4827:13" },	-- "Surveying the Damage"
	["Hillsbrad Foothills"] = "4827:13",	-- "Surveying the Damage"
	["Loch Modan"] = "4827:12",		-- "Surveying the Damage"
	["Silverpine Forest"] = "4827:10",	-- "Surveying the Damage"
	["Tol Barad"] = { 4874, IsAlliance and 5489 or 5490,	-- "Breaking out of Tol Barad", "Master of Tol Barad"
			  IsAlliance and 5718 or 5719 },	-- "Just Another Day in Tol Barad"
	["Tol Barad Peninsula"] = IsAlliance and 5718 or 5719,	-- "Just Another Day in Tol Barad"
	["Twilight Highlands"] = { 5451, 4960,	-- "Consumed by Nightmare", "Round Three. Fight!",
				   "4958:3" },	-- "The First Rule of Ring of Blood is You Don't Talk About Ring of Blood"
	["Westfall"] = "4827:11",	-- "Surveying the Damage"
	-- Vashj'ir:
	["Vashj'ir"] = { 4975, 5452,		-- "From Hell's Heart I Stab at Thee", "Visions of Vashj'ir Past"
			 IsAlliance and 5318 or 5319 },	-- "20,000 Leagues Under the Sea"
	["Kelp'thar Forest"] = { 4975, 5452,	-- "From Hell's Heart I Stab at Thee", "Visions of Vashj'ir Past"
			 IsAlliance and 5318 or 5319 },	-- "20,000 Leagues Under the Sea"
	["Shimmering Expanse"] = { 4975, 5452,	-- "From Hell's Heart I Stab at Thee", "Visions of Vashj'ir Past"
			 IsAlliance and 5318 or 5319 },	-- "20,000 Leagues Under the Sea"
	["Abyssal Depths"] = { 4975, 5452,	-- "From Hell's Heart I Stab at Thee", "Visions of Vashj'ir Past"
			 IsAlliance and 5318 or 5319 },	-- "20,000 Leagues Under the Sea"
-- Outland
	["Blade's Edge Mountains"] = 1276,	-- "Blade's Edge Bomberman"
	["Nagrand (Outland)"] = { 939, "1576:1" },	-- "Hills Like White Elekk", "Of Blood and Anguish" -- RENAMED ZONE
	["Netherstorm"] = 545,		-- "Shave and a Haircut"
	["Shadowmoon Valley (Outland)"] = {}, -- RENAMED ZONE
	["Shattrath City"] =	-- "My Sack is "Gigantique"", "Old Man Barlowned", "Kickin' It Up a Notch",
		{ 1165, 905, 906, 903,  },	-- "Shattrath Divided"
	["Terokkar Forest"] = { 905, 1275 },	-- "Old Man Barlowned", "Bombs Away"
	["Zangarmarsh"] = 893,		-- "Cenarion War Hippogryph"
-- Northrend
	["Borean Tundra"] = 561,	-- "D.E.H.T.A's Little P.I.T.A."
	["Dragonblight"] = { 1277, 547 },	-- "Rapid Defense", "Veteran of the Wrathgate"
	["Dalaran (Northrend)"] = { 2096, 1956, 1958, 545, 1998, IsAlliance and 1782 or 1783, 3217 }, -- RENAMED ZONE
	["Grizzly Hills"] = { "1596:1" },	-- "Guru of Drakuru"
	["Icecrown"] = { SUBZONES = {
		["*Argent Tournament Grounds*The Ring of Champions*Argent Pavilion*The Argent Valiants' Ring*The Aspirants' Ring*The Alliance Valiants' Ring*Silver Covenant Pavilion*Sunreaver Pavilion*The Horde Valiants' Ring*"] =
			{ 2756, 2772, 2836, 2773, 3736 },
		-- "Argent Aspiration", "Tilted!", "Lance a Lot", "It's Just a Flesh Wound", "Pony Up!"
	} },
	["The Storm Peaks"] = 1428,	-- "Mine Sweeper"
	["Sholazar Basin"] =		-- "The Snows of Northrend", "Honorary Frenzyheart",
		{ 938, 961, 962, 952 },	-- "Savior of the Oracles", "Mercenary of Sholazar"
	["Zul'Drak"] = { "1576:2", "1596:2" },	-- "Of Blood and Anguish", "Guru of Drakuru"
	["Wintergrasp"] = { 1752, 2199, 1717, 1751, 1755, 1727, 1723 },
-- Darkmoon Faire
	["Darkmoon Island"] = achDarkmoonFaire,
	["Darkmoon Faire"] = achDarkmoonFaire,
	-- !! - not 100% certain which is needed; may be both; test when the faire's available
-- Other Cataclysm-related
	["Deepholm"] = { 5445, 5446, 5447, 5449 },	-- "Fungalophobia", "The Glop Family Line",
							-- "My Very Own Broodmother", "Rock Lover"
-- Pandaria
	["The Jade Forest"] = {
		IsAlliance and 6300 or 6534, -- Upjade Complete
		6550, -- Order of the Cloud Serpent
		7289, -- Shadow Hopper
		7290, -- How To Strain Your Dragon
		7291, -- In a Trail of Smoke
		7381, -- Restore Balance
	},
	["Krasarang Wilds"] = {
		IsAlliance and 6535 or 6536, -- Mighty Roamin' Krasaranger
		6547, -- The Anglers
		7518, -- Wanderers, Dreamers, and You
	},
	["Kun-Lai Summit"] = {
		6480, -- Settle Down, Bro
		IsAlliance and 6537 or 6538, -- Slum It in the Summit
		7386, -- Grand Expedition Yak
	},
	["Valley of the Four Winds"] = {
		6301, -- Rally the Valley
		6544, -- The Tillers
		6551, -- Friend on the Farm
		7292, -- Green Acres
		7293, -- Till the Break of Dawn
		7294, -- A Taste of Things to Come
		7295, -- Listen to the Drunk Fish
		7325, -- Now I'm the Master
		7502, -- Savior of Stoneplow
		6517, -- Extinction Event
	},
	["Townlong Steppes"] = {
		6539, -- One Steppe Foward, Two Steppes Back
		7299, -- Loner and a Rebel
	},
	["Dread Wastes"] = {
		6540, -- Dread Haste Makes Dread Waste
		6545, -- Klaxxi
		7312, -- Amber is the Color of My Energy
		7313, -- Stay Klaxxi
		7314, -- Test Drive
	},
	["Vale of Eternal Blossoms"] = {
		6546, -- The Golden Lotus
		7317, -- One Many Army
		7318, -- A Taste of History
		--7315 "Eternally in the Vale" is now a Feat of Strength
		7322, -- Roll Club
	},
	["Isle of Thunder"] = 8121, -- "Stormbreaker"
	["Timeless Isle"] = {
		8715, 8726, 8725, 8728, 8712, 8723, 8533, 8724, 8730, 8717
	},
-- Draenor
	["Ashran"] = {
		9102, -- Ashran Victory
		IsAlliance and 9104 or 9103, -- Bounty Hunter
		9105, -- Tour of Duty
		9106, -- Just for Me
		9216, -- High-value Targets
		IsAlliance and 9408 or 9217, -- Operation Counterattack
		IsAlliance and 9225 or 9224, -- Take Them Out
		9218, -- Grand Theft, 1st Degree
		9222, -- Divide and Conquer
		IsAlliance and 9256 or 9257, -- Rescue Operation
		IsAlliance and 9214 or 9215, -- Hero of Stormshield / Hero of Warspear
		IsAlliance and 9714 or 9715, -- Thy Kingdom Come
	},
	["Frostfire Ridge"] = {
		SUBZONES = {
			-- !! haven't tested these subzones
			["Bloodmaul Stronghold"] = { 9533, 9534, IsAlliance and 9530 or 9531 },
			["*Magnarok*Altar of Kron*Ascent of Frostfire*Refuse Pit*"] = { 9537, 9536, 9535 },
			["Iron Siegeworks"] = { 9710, 9711 }
		},
	},
	["Gorgrond"] = {
		IsAlliance and 8923 or 8924,
		9607, -- Make It a Bonus
		9400, -- Gorgrond Monster Hunter
		9401, -- Shredder Maniac
		9402, -- Prove Your Strength
		9423, -- Goliaths of Gorgrond
		SUBZONES = {
			--!! untested if subzone detection works properly for this one
			["Everbloom Wilds"] = { 9663, 9678, 9667, 9654, 9658 },
			["The Pit"] = { 9655, 9656, 9659 }
		},
	},
	["Nagrand (Draenor)"] = { -- RENAMED ZONE
		IsAlliance and 8927 or 8928, -- Nagrandeur
		IsAlliance and 9539 or 9705, -- Advanced Husbandry
		IsAlliance and 9540 or 9706, -- The Stable Master
		9615, -- With a Nagrand Cherry On Top
		SUBZONES = {
			-- !! haven't tested these subzones
			["Broken Precipice"] = { 9571, 9610 },
			["Mok'gol Watchpost"] = { 9548, 9541 },
			["Gorian Proving Grounds"] = 9617,
		},
	},
	["Spires of Arak"] = {
		IsAlliance and 8925 or 8926, -- Between Arak and a Hard Place
		9605, -- Arak Star
		9425, -- So Grossly Incandescent
		SUBZONES = {
			-- !! haven't tested these subzones
			["Skettis Ruins"] = { 9612, 9613 },
			["Lost Veil Anzu"] = { 9600, 9601 },
			["Pillars of Fate"] = { 9433, 9434, 9432 }, -- !! subzone might be "Shadowmoon Enclave" instead and/or might be in Shadowmoon Valley (or maybe need to cover both)
		},
	},
	["Shadowmoon Valley (Draenor)"] = { -- RENAMED ZONE
		SUBZONES = {
			-- !! haven't tested these subzones
			["*Darktide Roost*Darktide Strait*"] = { 9481, 9483, 9479 },
			["Socrethar's Rise"] = { 9437, 9436, 9435 },
		},
	},
	["Talador"] = {
		IsAlliance and 8920 or 8919, -- Don't Let the Tala-door Hit You on the Way Out
		9674, -- I Want More Talador
		SUBZONES = {
			["Shattrath City"] = { 9486, 9632, 9633, 9634, 9635, 9636, 9637, 9638 } -- !! haven't checked whether these all belong to this subzone (or multiple subzones? Harbor, City)
		},
	},
	["Tanaan Jungle"] = {
		10261, -- Jungle Treasure Hunter
		10259, -- Jungle Hunter
		10069, -- I Came, I Clawed, I Conquered
		10061, -- Hellbane
		IsAlliance and 10067 or 10074, -- In Pursuit of Gul'dan
		IsAlliance and 10068 or 10075, -- Draenor's Last Stand
		10071, -- The Legion Will NOT Conquer All
		IsAlliance and 10072 or 10265, -- Rumble in the Jungle (complete the above, and any in same series as one of the above, and the explore achievement)
		10052, -- Tiny Terrors in Tanaan
		IsAlliance and 10350 or 10349, -- Tanaan Diplomat
		--10334, -- Predator - Feat of Strength
	},
	["Garrison"] = achDraenorGarrison,
-- Legion
	["Azsuna"] = {
		11261, -- Adventurer of Azsuna
		10763, -- Azsuna Matata
		11175, -- Higher Dimensional Learning
		"11186:1", -- Tehd & Marius' Excellent Adventure
		11256, -- Treasures of Azsuna
		"11544:1", -- Defender of the Broken Isles
	},
	["Val'sharah"] = {
		11262, -- Adventurer of Val'sharah
		"11186:4", -- Tehd & Marius' Excellent Adventure
		10698, -- That's Val'sharah Folks!
		11258, -- Treasures of Val'sharah
		"11544:4", -- Defender of the Broken Isles
	},
	["Highmountain"] = {
		11264, -- Adventurer of Highmountain
		10059, -- Ain't No Mountain High Enough
		"11186:3", -- Tehd & Marius' Excellent Adventure
		11257, -- Treasures of Highmountain
		10774, -- Hatchling of the Talon
		--10398, -- "Drum Circle" - shows as red for some reason, both factions; comment out for now
		"11544:2", -- Defender of the Broken Isles
	},
	["Stormheim"] = {
		11263, -- Adventurer of Stormheim
		10627, -- Going Up
		"11186:2", -- Tehd & Marius' Excellent Adventure
		11259, -- Treasures of Stormheim
		10790, -- Vrykul Story, Bro
		10793, -- What a Ripoff!
		--11232, -- Lock, Stock and Two Smoking Goblins (starts in Dalaran which is available after "What a Ripoff!")
		"11544:3", -- Defender of the Broken Isles
	},
	["Suramar"] = {
		11265, -- Adventurer of Suramar
		11124, -- Good Suramaritan
		10756, -- Leyline Bling
		10617, -- Nightfallen But Not Forgotten
		11125, -- Now You're Thinking With Portals
		11260, -- Treasures of Suramar
		10778, -- The Nightfallen
		11133, -- Why Can't I Hold All This Mana?
		11340, -- Insurrection
	},
	--[[ ["Dalaran Sewers"] = {
		11066, -- Underbelly Tycoon
	}, --]]
	["Dalaran (Broken Isles)"] = { -- RENAMED ZONE
		10722, -- The Wish Remover
		11066, -- Underbelly Tycoon
	},
	["Broken Shore"] = {
		11731, -- A Magic Contribution
		11545, -- Legionfall Commander
		11735, -- Take Command
		11737, -- Disrupting the Nether
		11546, -- Breaching the Tomb
		11802, -- Bringing Home the Beacon
		11846, -- Champions of Legionfall
		11681, -- Crate Expectations
		11841, -- Naxt Victim
		11653, -- Paragon of the Broken Isles
		11786, -- Terrors of the Shore
		11787, -- The Gates of Hell
	},
-- Legion: Class Halls
	["Acherus: The Ebon Hold"] = achClassHall, -- Death knight
	["The Fel Hammer"] = achClassHall, -- Demon hunter
	["The Dreamgrove"] = achClassHall, -- Druid
	["Trueshot Lodge"] = achClassHall, -- Hunter
	["Hall of the Guardian"] = achClassHall, -- Mage
	["Temple of Five Dawns"] = achClassHall, -- Monk
	["Sanctum of Light"] = achClassHall, -- Paladin
	["Netherlight Temple"] = achClassHall, -- Priest
	["The Hall of Shadows"] = achClassHall, -- Rogue
	["The Heart of Azeroth"] = achClassHall, -- Shaman
	["Dreadscar Rift"] = achClassHall, -- Warlock
	["Skyhold"] = achClassHall, -- Warrior
}
ACHID_ZONE_MISC["Thunder Totem"] = ACHID_ZONE_MISC["Highmountain"] -- Make this quasi-subzone show suggestions from the main zone

if (IsAlliance) then
  tinsert(ACHID_ZONE_MISC["Grizzly Hills"], 2016) -- "Grizzled Veteran"
  tinsert(ACHID_ZONE_MISC["Wintergrasp"], 1737) -- "Destruction Derby"
  --Currently a Feat of Strength but this may be a bug as I've seen reports that you can still get one. Then
  --again, maybe since it was much more difficult to get one previously, a FoS is meant to recognize that:
  --tinsert(ACHID_ZONE_MISC["Winterspring"], 3356) -- "Winterspring Frostsaber"
  tinsert(ACHID_ZONE_MISC["Twilight Highlands"], 5320) -- "King of the Mountain"
  tinsert(ACHID_ZONE_MISC["Twilight Highlands"], 5481) -- "Wildhammer Tour of Duty"
  tinsert(ACHID_ZONE_MISC["Darkshore"], 5453) -- "Ghosts in the Dark"
  -- As applicable, "City Defender", "Shave and a Haircut", "Fish or Cut Bait: <City>", "Let's Do Lunch: <City>":
  ACHID_ZONE_MISC["Stormwind City"] = { 388, 545, 5476, 5474 }
  ACHID_ZONE_MISC["Ironforge"] = { 388, 545, 5847, 5841 }
  ACHID_ZONE_MISC["Darnassus"] = { 388, 5848, 5842 }
  ACHID_ZONE_MISC["The Exodar"] = { 388 }
  -- "Wrath of the Alliance", faction leader kill, "For The Alliance!":
  ACHID_ZONE_MISC["Orgrimmar"] = { 604, 610, 614 }
  ACHID_ZONE_MISC["Thunder Bluff"] = { 604, 611, 614 }
  ACHID_ZONE_MISC["Undercity"] = { 604, 612, 614 }
  ACHID_ZONE_MISC["Silvermoon City"] = { 604, 613, 614 }
  -- "A Silver Confidant", "Champion of the Alliance":
  tinsert(ACHID_ZONE_MISC["Icecrown"], 3676)
  tinsert(ACHID_ZONE_MISC["Icecrown"], 2782)
  -- "Down Goes Van Rook" (there is no Horde equivalent, apparently)
  tinsert(ACHID_ZONE_MISC["Ashran"], 9228)

  tinsert(ACHID_ZONE_MISC["Shadowmoon Valley (Draenor)"], 8845) -- "As I Walk Through the Valley of the Shadow of Moon"
  tinsert(ACHID_ZONE_MISC["Shadowmoon Valley (Draenor)"], 9528) -- "On the Shadow's Trail"
  tinsert(ACHID_ZONE_MISC["Shadowmoon Valley (Draenor)"], 9602) -- "Shoot For the Moon"
  ACHID_ZONE_MISC["Lunarfall"] = achDraenorGarrison
  ACHID_ZONE_MISC["Shadowmoon Valley (Draenor)"].SUBZONES["Lunarfall Shipyard"] = achDraenorGarrisonShipyard

  ACHID_ZONE_MISC["Deeprun Tram"] = { SUBZONES = { ["Bizmo's Brawlpub"] = achBrawlersGuild } }

else
  tinsert(ACHID_ZONE_MISC["Azshara"], 5454) -- "Joy Ride"
  tinsert(ACHID_ZONE_MISC["Grizzly Hills"], 2017) -- "Grizzled Veteran"
  tinsert(ACHID_ZONE_MISC["Wintergrasp"], 2476)	-- "Destruction Derby"
  tinsert(ACHID_ZONE_MISC["Twilight Highlands"], 5482) -- "Dragonmaw Tour of Duty"
  tinsert(ACHID_ZONE_MISC["Twilight Highlands"], 5321) -- "King of the Mountain"
  -- As applicable, "City Defender", "Shave and a Haircut", "Fish or Cut Bait: <City>", "Let's Do Lunch: <City>":
  ACHID_ZONE_MISC["Orgrimmar"] = { 1006, 545, 5477, 5475 }
  ACHID_ZONE_MISC["Thunder Bluff"] = { 1006, 5849, 5843 }
  ACHID_ZONE_MISC["Undercity"] = { 1006, 545, 5850, 5844 }
  ACHID_ZONE_MISC["Silvermoon City"] = { 1006 }
  -- "Wrath of the Horde", faction leader kill, "For The Horde!":
  ACHID_ZONE_MISC["Stormwind City"] = { 603, 615, 619 }
  ACHID_ZONE_MISC["Ironforge"] = { 603, 616, 619 }
  ACHID_ZONE_MISC["Darnassus"] = { 603, 617, 619 }
  ACHID_ZONE_MISC["The Exodar"] = { 603, 618, 619 }
  -- "The Sunreavers", "Champion of the Horde":
  tinsert(ACHID_ZONE_MISC["Icecrown"], 3677)
  tinsert(ACHID_ZONE_MISC["Icecrown"], 2788)
  
  tinsert(ACHID_ZONE_MISC["Frostfire Ridge"], 8671) -- "You'll Get Caught Up in The... Frostfire!"
  tinsert(ACHID_ZONE_MISC["Frostfire Ridge"], 9606) -- "Frostfire Fridge"
  tinsert(ACHID_ZONE_MISC["Frostfire Ridge"], 9529) -- "On the Shadow's Trail"

  ACHID_ZONE_MISC["Frostwall"] = achDraenorGarrison -- !! name not 100% verified (have to run Horde char around outskirts of their garrison, refreshing suggestions, to test)
  ACHID_ZONE_MISC["Frostfire Ridge"].SUBZONES["Frostwall Shipyard"] = achDraenorGarrisonShipyard

  ACHID_ZONE_MISC["Brawl'gar Arena"] = achBrawlersGuild

end
-- "The Fishing Diplomat":
tinsert(ACHID_ZONE_MISC["Stormwind City"], "150:2")
tinsert(ACHID_ZONE_MISC["Orgrimmar"], "150:1")
-- "Old Crafty" and "Old Ironjaw":
tinsert(ACHID_ZONE_MISC["Orgrimmar"], 1836)
tinsert(ACHID_ZONE_MISC["Ironforge"], 1837)
-- "Big City Pet Brawlin' - Alliance":
tinsert(ACHID_ZONE_MISC["Stormwind City"], "6584:1")
tinsert(ACHID_ZONE_MISC["Ironforge"], "6584:2")
tinsert(ACHID_ZONE_MISC["Darnassus"], "6584:3")
tinsert(ACHID_ZONE_MISC["The Exodar"], "6584:4")
-- "Big City Pet Brawlin' - Horde":
tinsert(ACHID_ZONE_MISC["Orgrimmar"], "6621:1")
tinsert(ACHID_ZONE_MISC["Thunder Bluff"], "6621:2")
tinsert(ACHID_ZONE_MISC["Undercity"], "6621:3")
tinsert(ACHID_ZONE_MISC["Silvermoon City"], "6621:4")

ACHID_ZONE_MISC["City of Ironforge"] = ACHID_ZONE_MISC["Ironforge"]
ACHID_ZONE_MISC["Brawler's Guild"] = achBrawlersGuild -- alias

-- INSTANCES - ANY DIFFICULTY (any group size):
local ACHID_INSTANCES = {
-- Classic Dungeons
	["Ragefire Chasm"] = 629,
	["Wailing Caverns"] = 630,
	["Blackfathom Deeps"] = 632,
	["Stormwind Stockade"] = 633,		-- previously called "The Stockade"
	["Gnomeregan"] = 634,
	["Razorfen Kraul"] = 635,
	["Razorfen Downs"] = 636,
	["Uldaman"] = 638,
	["Zul'Farrak"] = 639,
	["Maraudon"] = 640,
	["Sunken Temple"] = 641,
	["Blackrock Depths"] = 642,
	["Lower Blackrock Spire"] = 643,
	--!! unavailable after Warlords of Draenor patch?-- ["Upper Blackrock Spire"] = { 1307, 2188 },	-- "Upper Blackrock Spire", "Leeeeeeeeeeeeeroy!"
	["Dire Maul"] = 644,
	["Stratholme"] = 646,
-- Classic Raids
	-- These are now Feats of Strength: ["Zul'Gurub"] = { 688, 560, 957 },	-- "Zul'Gurub", "Deadliest Catch", "Hero of the Zandalar"
	["Ruins of Ahn'Qiraj"] = 689,
	--["Onyxia's Lair"] = 684, -- This is now a Feat of Strength
	["The Molten Core"] = {
		686, 955,
		11741, -- So Hot Right Now
	},
	["Blackwing Lair"] = {
		685, -- Blackwing Lair (defeat Nefarion)
		11742, -- Dress in Lairs
	},
	["Temple of Ahn'Qiraj"] = {
		687, -- Temple of Ahn'Qiraj (defeat C'thun)
		11743, -- Accessor-Eyes
	},
	["Ahn'Qiraj Temple"] = 687,
-- Burning Crusade
	["Auchenai Crypts"] = 666,
	["The Mechanar"] = 658,
	-- This is now a Feat of Strength: ["Zul'Aman"] = 691,
	["The Blood Furnace"] = 648,
	["Hellfire Ramparts"] = 647,
	["Mana-Tombs"] = 651,
	["The Botanica"] = 659,
	["Shadow Labyrinth"] = 654,
	["Sunwell Plateau"] = {
		698, -- Sunwell Plateau (defeat Kil'jaeden)
		11749, -- Suns Out, Thori'dals Out
	},
	["Black Temple"] = {
		697, -- The Black Temple (defeat Illidan Stormrage)
		11748, -- Black is the New Black
		11869, -- I'll Hold These For You Until You Get Out (timewalking)
	},
	["Hyjal Summit"] = 695,			-- "The Battle for Mount Hyjal"
	["Tempest Keep"] = {
		696,
		11747, -- Merely a Set  (!! - zone name "The Eye"?)
	},
	["Sethekk Halls"] = 653,
	["Old Hillsbrad Foothills"] = 652,	-- "The Escape From Durnholde"
	["The Black Morass"] = 655,		-- "Opening of the Dark Portal"
	["Magtheridon's Lair"] = {
		693,
		11746, -- Outlandish Style
	},
	["Gruul's Lair"] = {
		692,
		11746, -- Outlandish Style
	},
	["Karazhan"] = {
		690,
		11746, -- Outlandish Style
	},
	["The Steamvault"] = 656,
	["Serpentshrine Cavern"] = {
		694, 144,	-- "Serpentshrine Cavern", "The Lurker Above"
		11747, -- Merely a Set
	}, 
	["The Shattered Halls"] = 657,
	["The Slave Pens"] = 649,
	["The Underbog"] = 650,			-- "Underbog"
	["Magisters' Terrace"] = 661,		-- "Magister's Terrace"
	["The Arcatraz"] = 660,
-- Lich King Dungeons
	["The Culling of Stratholme"] = 479,
	["Utgarde Keep"] = 477,
	["Drak'Tharon Keep"] = 482,
	["Gundrak"] = 484,
	["Ahn'kahet: The Old Kingdom"] = 481,
	["Halls of Stone"] = 485,
	["Utgarde Pinnacle"] = 488,
	["The Oculus"] = 487,
	["Halls of Lightning"] = 486,
	["The Nexus"] = 478,
	["The Violet Hold"] = 483,
	["Azjol-Nerub"] = 480,
	["Trial of the Champion"] = {
		IsAlliance and 4296 or 3778,
		11752, -- Style of the Crusader
	},
	["The Forge of Souls"] = 4516,
	["Halls of Reflection"] = 4518,
	["Pit of Saron"] = 4517,
-- Lich King Raids
	--["Naxxramas"] = 11744, -- Drop Dead, Gorgeous (feat of strength - for old Naxxramas, not WotLK, though gear obtainable from black market AH)
	["Naxxramas"] = 11750, -- Undying Aesthetic
	["Icecrown Citadel"] = 11753, -- Winter Catalog
	["Ulduar"] = 11751, -- Mogg-Saron

-- Cataclysm Dungeons
	-- Heroic only, but these dungeons are heroic only so it may as well always show up if suggesting for the zone:
	["Zul'Aman"] = { 5769, 5858, 5760, 5761, 5750 },  -- "Heroic: Zul'Aman", "Bear-ly Made It", "Ring Out!", "Hex Mix", "Tunnel Vision"
	["Zul'Gurub"] = { 5768, 5765, 5743, 5762, 5759, 5744 },  -- "Heroic: Zul'Gurub", "Here, Kitty Kitty...", "It's Not Easy Being Green", "Ohganot So Fast!", "Spirit Twister", "Gurubashi Headhunter"
-- Cataclysm Raids
	["Blackwing Descent"] = 11754, -- Glamour of Twilight -- !! add others for this raid!
	["The Bastion of Twilight"] = 11754, -- Glamour of Twilight -- !! add others for this raid! and confirm "The" in name.
	["Firelands"] = {
		5802, 5828, 5855, -- "Firelands", "Glory of the Firelands Raider", "Ragnar-O's"
		11755, -- Hot Couture
	},
	["Dragon Soul"] = {
		6169, -- Glory of the Dragon Soul Raider
		6175,
		6106,
		6107,
		6177,
		11756, -- Wardrobe of the Old Gods
	},

-- Pandaria Dungeons
	["Gate of the Setting Sun"] = 6945, -- "Mantid Swarm"
	["Stormstout Brewery"] = { 6400, 6402 }, -- "How Did He Get Up There?", "Ling-Ting's Herbal Journey"
	["Scarlet Monastery"] = 6946, -- "Empowered Spiritualist"
-- Pandaria Raids
	["Heart of Fear"] = {
		6718, 6845, 6936, 6518, 6683, 6553, 6937, 6922, -- "The Dread Approach", "Nightmare of Shek'zeer", "Candle in the Wind", "I Heard You Like Amber...", "Less Than Three", "Like An Arrow to the Face", "Overzealous", "Timing is Everything"
		11757, -- Sha of Fabulous
	},
	["Mogu'shan Vaults"] = { 6458, 6844, 6674, 6687, 6823, 6455, 7056, 6686 }, -- "Guardians of Mogu'shan", "The Vault of Mysteries", "Anything You Can Do, I Can Do Better...", "Getting Hot in Here", "Must Love Dogs", "Show Me Your Moves!", "Sorry, Were You Looking for This?", "Straight Six"
	["Terrace of Endless Spring"] = {
		6689, 6824, 6717, 6825, 6933, -- "Terrace of Endless Spring", "Face Clutchers", "Power Overwhelming", "The Mind-Killer", "Who's Got Two Green Thumbs?"
		11757, -- Sha of Fabulous
	},
	["Throne of Thunder"] = {
		8070, 8071, 8069, 8072, -- "Forgotten Depths", "Halls of Flesh-Shaping", "Last Stand of the Zandalari", "Pinnacle of Storms"
		8037, 8087, 8090, 8094, 8073, 8082, 8098, 8081, 8086, -- "Genetically Unmodified Organism", "Can't Touch This", "A Complete Circuit", "Lightning Overload", "Cage Match", "Head Case", "You Said Crossing the Streams Was Bad", "Ritualist Who?", "From Dusk 'til Dawn"
		-- 8089 "I Thought He Was Supposed to Be Hard?" is now a Feat of Strength
		11758, -- Thunderwear
	},
	["Siege of Orgrimmar"] = {
		8454, 8458, 8459, 8461, 8462, -- "Glory of the Orgrimmar Raider", "Vale of Eternal Sorrows", "Gates of Retribution", "The Underhold", "Downfall"
		IsAlliance and 8679 or 8680, -- "Conqueror of Orgrimmar" or "Liberator of Orgrimmar"
		11759, -- Yaass'shaarj
	},

-- Draenor Dungeons
-- !! not 100% sure on these zone names
	["Auchindoun"] = 9039,
	["Bloodmaul Slag Mines"] = 9037,
	["Grimrail Depot"] = 9043,
	["Iron Docks"] = 9038,
	["Shadowmoon Burial Grounds"] = 9041,
	["Skyreach"] = 8843,
	["The Everbloom"] = 9044,
	["Upper Blackrock Spire"] = 9042,
-- Draenor Raids
	["Highmaul"] = { 8975, 8987, 8958, 8948, 8947, 8988, 8977, 8974, 8976, 8986 },
	["Blackrock Foundry"] = {
		8978, 8979, 8930, 8980, 8929, 8983, 8981, 8982, 8984, 8952, 8989, 8990, 8991, 8992,
		11740, -- Make it W-orc W-orc
	},
	["Hellfire Citadel"] = {
		10026, 10057, 10013, 9972, 9979, 9988, 10086, 9989, 10012, 10087, 10030, 10073, 10023, 10024, 10025, 10020, 10019,
		11631, -- Extreme Makeover: Fel Edition
	},

-- Legion Dungeons
	["Eye of Azshara"] = 10780, -- "Eye of Azshara" (chain)
	["Darkheart Thicket"] = 10783,
	["Halls of Valor"] = 10786,
	["Neltharion's Lair"] = {
		10996, -- Got to Ketchum All
		10795, -- "Neltharion's Lair" (chain)
	},
	["Assault on Violet Hold"] = 10798,
	["Vault of the Wardens"] = 10801,
	["Black Rook Hold"] = {
		10709, -- You Used to Scrawl Me In Your Fel Tome
		10804, -- "Black Rook Hold" (chain)
	},
	["Maw of Souls"] = 10807,
	["Return to Karazhan"] = { -- RENAMED ZONE.  !! Double check
		11429, -- Return to Karazhan
		11433, -- Burn After Reading
		11338, -- Dine and Bash
		11430, -- One Night in Karazhan
		11432, -- Scared Straight
		11335, -- Season Tickets
	},
	["Cathedral of Eternal Night"] = 11700,
-- Legion Raids
	["The Emerald Nightmare"] = {
		10555, -- Buggy Fight
		10663, -- Imagined Dragons World Tour
		10753, -- Scare Bear
		10755, -- I Attack the Darkness
		10771, -- Webbing Crashers
		10772, -- Use the Force(s)
		10818, -- Darkbough
		10819, -- Tormented Guardians
		10820, -- Rift of Aln
		10830, -- Took the Red Eye Down
	},
	["The Nighthold"] = {
		10575, -- Burning Bridges
		10678, -- Cage Rematch
		10696, -- I've Got My Eyes On You
		10697, -- Grand Opening
		10699, -- Infinitesimal
		10704, -- Not For You
		10742, -- Gluten Free
		10754, -- Fruit of All Evil
		10817, -- A Change In Scenery
		10829, -- Arcing Aqueducts
		10837, -- Royal Athenaeum
		10838, -- Nightspire
		10839, -- Betrayer's Rise
		10851, -- Elementalry!
		11628, -- That's So Last Millenium
	},
	["Trial of Valor"] = { -- !! double check this zone name
		11394, -- Trial of Valor (series)
		11386, -- Boneafide Tri Tip
		11377, -- Patient Zero
		11762, -- Can I Get A Helya
	},
	["Tomb of Sargeras"] = {
		11763, -- Glory of the Tomb Raider
		11789, -- Chamber of the Avatar
		11790, -- Deceiver's Fall
		11760, -- Retro Trend
		11788, -- Wailing Halls
	},

-- Legion Scenarios
	["The Deaths of Chromie"] = 11941,
}
-- Aliases
ACHID_INSTANCES["Molten Core"] = ACHID_INSTANCES["The Molten Core"]
--ACHID_INSTANCES["Hall of Blackhand"] = ACHID_INSTANCES["Upper Blackrock Spire"]
ACHID_INSTANCES["Violet Hold"] = ACHID_INSTANCES["Assault on Violet Hold"]

-- Battlegrounds
ACHID_INSTANCES["The Battle for Gilneas"] = 5258
ACHID_INSTANCES["Eye of the Storm"] = { 1171, 587, 1258, 211 }
ACHID_INSTANCES["Silvershard Mines"] = 7106
ACHID_INSTANCES["Strand of the Ancients"] = 2194
ACHID_INSTANCES["Twin Peaks"] = 5223  -- "Master of Twin Peaks"
ACHID_INSTANCES["Wildhammer Stronghold"] = 5223  -- Also part of Twin Peaks
ACHID_INSTANCES["Dragonmaw Stronghold"] = 5223  -- Also part of Twin Peaks
ACHID_INSTANCES["Temple of Kotmogu"] = 6981 -- "Master of Temple of Kotmogu"
ACHID_INSTANCES["Deepwind Gorge"] = 8360 -- "Master of Deepwind Gorge"
if (IsAlliance) then
	ACHID_INSTANCES["Alterac Valley"] = { 1167, 907, 226 }
	ACHID_INSTANCES["Arathi Basin"] = { 1169, 907 }
	ACHID_INSTANCES["Warsong Gulch"] = { 1172, 1259, 907 }
	ACHID_INSTANCES["Isle of Conquest"] = { 3857, 3845, 3846 }

else
	ACHID_INSTANCES["Alterac Valley"] = { 1167, 714, 226 }
	ACHID_INSTANCES["Arathi Basin"] = { 1169, 714 }
	ACHID_INSTANCES["Warsong Gulch"] = { 1172, 1259, 714 }
	ACHID_INSTANCES["Isle of Conquest"] = { 3957, 3845, 4176 }
end
-- For all battlegrounds:
local ACHID_BATTLEGROUNDS = { 238, 245, IsAlliance and 246 or 1005, 247, 229, 227, 231, 1785 }

-- INSTANCES - NORMAL ONLY (any group size):
local ACHID_INSTANCES_NORMAL = {
-- Classic Dungeons
	["The Deadmines"] = 628,
	["Shadowfang Keep"] = 631,
	["Scarlet Monastery"] = 637,
	["Scholomance"] = 645,
-- Cataclysm Dungeons
	["Lost City of the Tol'vir"] = 4848,
	["Blackrock Caverns"] = 4833,
	["Grim Batol"] = 4840,
	["The Vortex Pinnacle"] = 4847, -- Need to confirm zone name.
	["Halls of Origination"] = 4841,
	["The Stonecore"] = 4846,
	["Throne of the Tides"] = 4839,
-- Pandaria Dungeons
	["Mogu'shan Palace"] = 6755,
	["Shado-Pan Monastery"] = 6469,
	["Stormstout Brewery"] = 6457,
	["Temple of the Jade Serpent"] = 6757,
	["Scarlet Halls"] = 7413,
}

-- INSTANCES - HEROIC ONLY (any group size):
local ACHID_INSTANCES_HEROIC = {
-- Burning Crusade
	["Auchenai Crypts"] = 672,
	["The Blood Furnace"] = 668,
	["The Slave Pens"] = 669,
	["Hellfire Ramparts"] = 667,
	["Mana-Tombs"] = 671,
	["The Underbog"] = 670,			-- "Heroic: Underbog"
	["Old Hillsbrad Foothills"] = 673,	-- "Heroic: The Escape From Durnholde"
	["Magisters' Terrace"] = 682,		-- "Heroic: Magister's Terrace"
	["The Arcatraz"] = 681,
	["The Mechanar"] = 679,
	["The Shattered Halls"] = 678,
	["The Steamvault"] = 677,
	["The Botanica"] = 680,
	["The Black Morass"] = 676,		-- "Heroic: Opening of the Dark Portal"
	["Shadow Labyrinth"] = 675,
	["Sethekk Halls"] = 674,
-- Lich King Dungeons
	["Halls of Stone"] = { 496, 1866, 2154, 2155 },
	["Gundrak"] = { 495, 2040, 2152, 1864, 2058 },
	["Azjol-Nerub"] = { 491, 1860, 1296, 1297 },
	["Halls of Lightning"] = { 497, 2042, 1867, 1834 },
	["Utgarde Keep"] = { 489, 1919 },
	["The Nexus"] = { 490, 2037, 2036, 2150 },
	["Drak'Tharon Keep"] = { 493, 2039, 2057, 2151 },
	["Ahn'kahet: The Old Kingdom"] = { 492, 2056, 1862, 2038 }, --removed: 1861
	["The Oculus"] = { 498, 1868, 1871, 2044, 2045, 2046 },
	["The Violet Hold"] = { 494, 2153, 1865, 2041, 1816 },
	["The Culling of Stratholme"] = { 500, 1872, 1817 },
	["Utgarde Pinnacle"] = { 499, 1873, 2043, 2156, 2157 },
	["Trial of the Champion"] = { IsAlliance and 4298 or 4297, 3802, 3803, 3804 },
	["The Forge of Souls"] = { 4519, 4522, 4523 },
	["Halls of Reflection"] = { 4521, 4526 },
	["Pit of Saron"] = { 4520, 4524, 4525 },
-- Cataclysm Dungeons
	["Lost City of the Tol'vir"] = { 5291, 5292, 5066, 5290 },
	["Blackrock Caverns"] = { 5282, 5284, 5281, 5060, 5283 },
	["Shadowfang Keep"] = { 5505, 5093, 5503, 5504 },
	["Grim Batol"] = { 5298, 5062, 5297 },
	["The Vortex Pinnacle"] = { 5289, 5064, 5288 },
	["Halls of Origination"] = { 5296, 5065, 5293, 5294, 5295 },
	["The Deadmines"] = { 5083, 5370, 5369, 5368, 5367, 5366, 5371 },
	["The Stonecore"] = { 5063, 5287 },
	["Throne of the Tides"] = { 5061, 5285, 5286 },
-- Cataclysm Raids
	["Dragon Soul"] = { 6115, 6116, },
-- Pandaria Dungeons
	["Gate of the Setting Sun"] = { 6759, 6479, 6476 },
	["Mogu'shan Palace"] = { 6478, 6756, 6713, 6736 },
	["Shado-Pan Monastery"] = { 6470, 6471, 6477, 6472 },
	["Siege of Niuzao Temple"] = { 6763, 6485, 6822, 6688 },
	["Stormstout Brewery"] = { 6456, 6420, 6089 },
	["Temple of the Jade Serpent"] = { 6758, 6475, 6460, 6671 },
	["Scarlet Halls"] = { 6760, 6684, 6427 },
	["Scarlet Monastery"] = { 6761, 6929, 6928 },
	["Scholomance"] = { 6762, 6531, 6394, 6396, 6821 },
-- Pandaria Raids
	["Heart of Fear"] = { 6729, 6726, 6727, 6730, 6725, 6728 },
	["Mogu'shan Vaults"] = { 6723, 6720, 6722, 6721, 6719, 6724 },
	["Terrace of Endless Spring"] = { 6733, 6731, 6734, 6732 },
	["Throne of Thunder"] = { 8124, 8067 }, -- "Glory of the Thundering Raider", "Heroic: Lei Shen"
	["Siege of Orgrimmar"] = {
		8463, 8465, 8466, 8467, 8468, 8469, 8470, -- "Heroic: Immerseus", "Heroic: Fallen Protectors", "Heroic: Norushen", "Heroic: Sha of Pride", "Heroic: Galakras", "Heroic: Iron Juggernaut", "Heroic: Kor'kron Dark Shaman",
		8471, 8472, 8478, 8479, 8480, 8481, 8482, -- "Heroic: General Nazgrim", "Heroic: Malkorok", "Heroic: Spoils of Pandaria", "Heroic: Thok the Bloodthirsty", "Heroic: Siegecrafter Blackfuse", "Heroic: Paragons of the Klaxxi", "Heroic: Garrosh Hellscream"
	},

-- Draenor Dungeons
	["Auchindoun"] = { 9023, 9551, 9552 },
	["Bloodmaul Slag Mines"] = { 8993, 9005, 9008 },
	["Grimrail Depot"] = { 9024, 9007 },
	["Iron Docks"] = { 9081, 9083, 9082 },
	["Shadowmoon Burial Grounds"] = { 9018, 9025, 9026 },
	["Skyreach"] = { 9033, 9035,9034, 9036 },
	["The Everbloom"] = {
		9493, -- They Burn, Burn, Burn
		9017, -- Water Management
		9223, -- Weed Whacker
	},
	["Upper Blackrock Spire"] = { 9045, 9058, 9056, 9057 },
}
-- Aliases
--ACHID_INSTANCES_HEROIC["Hall of Blackhand"] = ACHID_INSTANCES_HEROIC["Upper Blackrock Spire"]

local ACHID_INSTANCES_HEROIC_PLUS = {
-- Draenor Dungeons
	["Auchindoun"] = "9619:3", -- Savage Hero
	["Bloodmaul Slag Mines"] = "9619:1",
	["Grimrail Depot"] = "9619:6",
	["Iron Docks"] = "9619:2",
	["Shadowmoon Burial Grounds"] = "9619:7",
	["Skyreach"] = "9619:4",
	["The Everbloom"] = "9619:5",
	["Upper Blackrock Spire"] = "9619:8",
-- Draenor Raids
	["Highmaul"] = "9619:9",
	["Blackrock Foundry"] = "9619:10",
-- Legion Dungeons
	["Return to Karazhan"] = 11929,
}
-- Aliases
--ACHID_INSTANCES_HEROIC_PLUS["Hall of Blackhand"] = ACHID_INSTANCES_HEROIC_PLUS["Upper Blackrock Spire"]

-- INSTANCES - 10-MAN ONLY (normal or heroic):
local ACHID_INSTANCES_10 = {
-- Lich King Raids
	["Naxxramas"] = { 2146, 576, 578, 572, 1856, 2176, 2178, 2180, 568, 1996, 1997, 1858, 564, 2182, 2184,
		566, 574, 562 }, -- 2187 "The Undying" is now a Feat of Strength
	["Onyxia's Lair"] = { 4396, 4402, 4403, 4404 },
	["The Eye of Eternity"] = { 622, 1874, 2148, 1869 },
	["The Obsidian Sanctum"] = { 1876, 2047, 2049, 2050, 2051, 624 },
	["Ulduar"] = { 2957, 2894, -- 2903 "Champion of Ulduar" is now a Feat of Strength
		SUBZONES = {
			--["*Formation Grounds*The Colossal Forge*Razorscale's Aerie*The Scrapyard*"] = 2886, -- Siege
			["Formation Grounds"] = { 3097, 2905, 2907, 2909, 2911, 2913 },
			["Razorscale's Aerie"] = { 2919, 2923 },
			["The Colossal Forge"] = { 2925, 2927, 2930 },
			["The Scrapyard"] = { 2931, 2933, 2934, 2937, 3058 },

			--["*The Assembly of Iron*The Shattered Walkway*The Observation Ring*"] = 2888, -- Antechamber
			["The Assembly of Iron"] = { 2939, 2940, 2941, 2945, 2947 },
			["The Shattered Walkway"] = { 2951, 2953, 2955, 2959 },
			["The Observation Ring"] = { 3006, 3076 },

			--["*The Spark of Imagination*The Conservatory of Life*The Clash of Thunder*The Halls of Winter*"] = 2890, -- Keepers
			["The Halls of Winter"] = { 2961, 2963, 2967, 3182, 2969 },
			["The Clash of Thunder"] = { 2971, 2973, 2975, 2977 },
			["The Conservatory of Life"] = { 2979, 2980, 2985, 2982, 3177 },
			["The Spark of Imagination"] = { 2989, 3138, 3180 },

			--["*The Descent into Madness*The Prison of Yogg-Saron*"] = 2892, -- Descent
			["The Descent into Madness"] = { 2996, 3181 },
			["The Prison of Yogg-Saron"] = { 3009, 3157, 3008, 3012, 3014, 3015 },

			["The Celestial Planetarium"] = { 3036, 3003 }, -- Alganon
			  -- 3004 "He Feeds On Your Tears (10 player)" and 3316 "Herald of the Titans" are now Feats of Strength
		},
	},
	["Vault of Archavon"] = { 1722, 3136, 3836, 4016 },
	["Trial of the Crusader"] = { 3917, 3936, 3798, 3799, 3800, 3996, 3797 },
	["Icecrown Citadel"] = { 4580, 4601, 4534, 4538, 4577, 4535, 4536, 4537, 4578, 4581, 4539, 4579, 4582 },
}

-- INSTANCES - 25-MAN ONLY (normal or heroic):
local ACHID_INSTANCES_25 = {
-- Lich King Raids
	["Naxxramas"] = { 579, 565, 577, 575, 2177, 563, 567, 1857, 569, 573, 1859, 2139, 2181, 2183, 2185,
		2147, 2140, 2179 },
		-- made Feats of Strength: 2186
	["Onyxia's Lair"] = { 4397, 4405, 4406, 4407 },
	["The Eye of Eternity"] = { 623, 1875, 1870, 2149 },
	["The Obsidian Sanctum"] = { 625, 2048, 2052, 2053, 2054, 1877 },
	["Ulduar"] = { 2958, 2895, -- 2904 "Conqueror of Ulduar" is now a Feat of Strength
		SUBZONES = {
			--["*Formation Grounds*The Colossal Forge*Razorscale's Aerie*The Scrapyard*"] = 2887, -- Siege
			["Formation Grounds"] = { 3098, 2906, 2908, 2910, 2912, 2918 },
			["Razorscale's Aerie"] = { 2921, 2924 },
			["The Colossal Forge"] = { 2926, 2928, 2929 },
			["The Scrapyard"] = { 2932, 2935, 2936, 2938, 3059 },

			--["*The Assembly of Iron*The Shattered Walkway*The Observation Ring*"] = 2889, -- Antechamber
			["The Assembly of Iron"] = { 2942, 2943, 2944, 2946, 2948 },
			["The Shattered Walkway"] = { 2952, 2954, 2956, 2960 },
			["The Observation Ring"] = { 3007, 3077 },

			--["*The Spark of Imagination*The Conservatory of Life*The Clash of Thunder*The Halls of Winter*"] = 2891, -- Keepers
			["The Halls of Winter"] = { 2962, 2965, 2968, 3184, 2970 },
			["The Clash of Thunder"] = { 2972, 2974, 2976, 2978 },
			["The Conservatory of Life"] = { 3118, 2981, 2984, 2983, 3185 },
			["The Spark of Imagination"] = { 3237, 2995, 3189 },

			--["*The Descent into Madness*The Prison of Yogg-Saron*"] = 2893, -- Descent
			["The Descent into Madness"] = { 2997, 3188 },
			["The Prison of Yogg-Saron"] = { 3011, 3161, 3010, 3013, 3017, 3016 },

			["The Celestial Planetarium"] = { 3037, 3002 }, -- Alganon
			  -- 3005 "He Feeds On Your Tears (25 player)" is now a Feat of Strength
		},
	},
	["Vault of Archavon"] = { 1721, 3137, 3837, 4017 },
	["Trial of the Crusader"] = { 3916, 3937, 3815, 3816, 3997, 3813 }, -- removed 3814
	["Icecrown Citadel"] = { 4620, 4621, 4610, 4614, 4615, 4611, 4612, 4613, 4616, 4622, 4618, 4619, 4617 },
}

-- INSTANCES - NORMAL 10-MAN ONLY:
local ACHID_INSTANCES_10_NORMAL = {
	["Icecrown Citadel"] = 4532,
	["The Ruby Sanctum"] = { -- !! Need to confirm zone name.
		4817,
		--11669, -- Unholy Determination (added in 7.2. currently unknown if this is obtainable and how; might not be part of the normal instance at all)
	}
}

-- INSTANCES - HEROIC 10-MAN ONLY:
local ACHID_INSTANCES_10_HEROIC = {
	["Trial of the Crusader"] = 3918, -- 3808 "A Tribute to Skill (10 player)" is now a Feat of Strength
	["Icecrown Citadel"] = 4636,
	["The Ruby Sanctum"] = 4818, -- Need to confirm zone name.
-- Cataclysm Raids
	["Firelands"] = 5803,	-- "Heroic: Ragnaros" (can be 10 or 25 apparently but putting it here allows detection that it's a raid when getting Suggestions outside it)
}

-- INSTANCES - NORMAL 25-MAN ONLY:
local ACHID_INSTANCES_25_NORMAL = {
	["Icecrown Citadel"] = 4608,
	["The Ruby Sanctum"] = 4815, -- Need to confirm zone name.
}

-- INSTANCES - HEROIC 25-MAN ONLY:
local ACHID_INSTANCES_25_HEROIC = {
	["Trial of the Crusader"] = { 3812 }, -- 3817 "A Tribute to Skill (25 player)" is now a Feat of Strength
	["Icecrown Citadel"] = 4637,
	["The Ruby Sanctum"] = 4816, -- Need to confirm zone name.
-- Cataclysm Raids
	["Firelands"] = 5803,	-- "Heroic: Ragnaros" (can be 10 or 25 apparently but putting it here allows detection that it's a raid when getting Suggestions outside it)
}

-- INSTANCES - MYTHIC ONLY (any group size):
local ACHID_INSTANCES_MYTHIC = {
-- Draenor Dungeons
	["The Everbloom"] = {
		"9619:5", -- Savage Hero
	},

-- Legion Dungeons
	["Eye of Azshara"] = {
		10456, -- But You Say He's Just a Friend
		10458, -- Ready for Raiding V
		10457, -- Stay Salty
	},
	["Darkheart Thicket"] = {
		10769, -- Burning Down the House
		10766, -- Egg-cellent!
	},
	["Halls of Valor"] = {
		10542, -- I Got What You Mead
		10544, -- Stag Party
		10543, -- Surge Protector
	},
	["Neltharion's Lair"] = 10875, -- Can't Eat Just One
	["Assault on Violet Hold"] = {
		10554, -- I Made a Food!
		10553, -- You're Just Making It WORSE!
	},
	["Vault of the Wardens"] = {
		10707, -- A Specter, Illuminated
		10679, -- I Ain't Even Cold
		10680, -- Who's Afraid of the Dark?
	},
	["Black Rook Hold"] = {
		10711, -- Adds? More Like Bads
		10710, -- Black Rook Moan
	},
	["Maw of Souls"] = {
		10411, -- Helheim Hath No Fury
		10413, -- Instant Karma
		10412, -- Poor Unfortunate Souls
	},
	["The Arcway"] = {
		10773, -- Arcanic Cling
		10775, -- Clean House
		10813, -- Mythic: The Arcway
		10776, -- No Time to Waste
	},
	["Court of Stars"] = {
		10611, -- Dropping Some Eaves
		10816, -- Mythic: Court of Stars
		10610, -- Waiting for Gerdo
	},
	["Cathedral of Eternal Night"] = {
		11769, -- A Steamy Romance Saga
		11768, -- Boom Bloom
		11703, -- Master of Shadows
	},
-- Legion Raids
	["The Emerald Nightmare"] = {
		10821, -- Mythic: Nythendra
		10822, -- Mythic: Elerethe Renferal
		10823, -- Mythic: Il'gynoth
		10824, -- Mythic: Ursoc
		10825, -- Mythic: Dragons of Nightmare
		10826, -- Mythic: Cenarius
		10827, -- Mythic: Xavius
	},
	["The Nighthold"] = {
		10840, -- Mythic: Skorpyron
		10842, -- Mythic: Anomaly
		10843, -- Mythic: Trilliax
		10844, -- Mythic: Aluriel
		10845, -- Mythic: Star Augur Etraeus
		10846, -- Mythic: High Botanist Tel'arn
		10847, -- Mythic: Tichondrius
		10848, -- Mythic: Krosus
		10849, -- Mythic: Grand Magistrix Elisande
		10850, -- Mythic: Gul'dan
	},
	["Trial of Valor"] = { -- !! double check this zone name
		11397, -- Mythic: Guarm
		11398, -- Mythic: Helya
		11396, -- Mythic: Odyn
		11387, -- The Chosen
		11337, -- You Runed Everything!
	},
	["Tomb of Sargeras"] = {
		11774, 11780, 11767, 11775, 11781, 11779, 11776, 11777, 11778,
	},
}


local ACHID_HOLIDAY = {
	["Darkmoon Faire"] = achDarkmoonFaire,
	["Lunar Festival"] = {
		913, -- To Honor One's Elders
		605, -- A Coin of Ancestry
	},
	["Love is in the Air"] = {
		1693, -- Fool For Love
		1694, -- Lovely Luck Is On Your Side
		1700, -- Perma-Peddle
		4624, -- Tough Love
		9389, -- It Might Just Save Your Life
		9394, -- They Really Love Me! (last of series starting with "Love Magnet"; put here directly since it has a reward)
	},
	["Noblegarden"] = {
		2798, -- Noble Gardener
		249, -- Dressed for the Occasion
		248, -- Sunday's Finest
	},
	["Children's Week"] = {
		1793, -- For the Children
		275, -- Veteran Nanny
	},
	["Midsummer Fire Festival"] = {
		IsAlliance and 1038 or 1039, -- "The Flame Warden" or "The Flame Keeper"
		IsAlliance and 1034 or 1036, -- The Fires of Azeroth
		IsAlliance and 8045 or 8044, -- "Flame Warden of Pandaria" or "Flame Keeper of Pandaria"
		IsAlliance and 11283 or 11284, -- "Flame Warden of Draenor" or "Flame Keeper of Draenor"
		IsAlliance and 11280 or 11282, -- "Flame Warden of the Broken Isles" or "Flame Keeper of the Broken Isles"
		IsAlliance and 1035 or 1037, -- "Desecration of the Horde" or "Desecration of the Alliance"
		IsAlliance and 8042 or 8043, -- Extinguishing Pandaria
		IsAlliance and 11276 or 11277, -- Extinguishing Draenor
		IsAlliance and 11278 or 11279, -- Extinguishing the Broken Isles
	},
	["Pirates' Day"] = 3457, -- The Captain's Booty
	["Brewfest"] = {
		1683, -- Brewmaster (includes many other achievements)
		1183, -- Brew of the Year
		IsAlliance and 1184 or 1203, -- Strange Brew
		1260, -- Almost Blind Luck
		293,  -- Disturbing the Peace
	},
	["Hallow's End"] = {
		1656,  -- Hallowed Be Thy Name
		971,   -- Tricks and Treats of Azeroth
		IsAlliance and 5836 or 5835,  -- Tricks and Treats of Northrend
		IsAlliance and 5837 or 5838,  -- Tricks and Treats of the Cataclysm
		IsAlliance and 7601 or 7602,  -- Tricks and Treats of Pandaria
		979,   -- The Mask Task
		284,   -- A Mask for All Occasions
		10365, -- A Frightening Friend
	},
	["Day of the Dead"] = {
		3456, -- Dead Man's Party
		9426, -- To the Afterlife
	},
	["Pilgrim's Bounty"] = {
		3478, -- Pilgrim
		IsAlliance and 3556 or 3557, -- Pilgrim's Paunch
		3558, -- Sharing is Caring
		3559, -- Turkey Lurkey
		IsAlliance and 3576 or 3577, -- Now We're Cookin'
		3578, -- The Turkinator
		3579, -- "FOOD FIGHT!"
		IsAlliance and 3580 or 3581, -- Pilgrim's Peril
		3582, -- Terokkar Turkey Time
		IsAlliance and 3596 or 3597, -- Pilgrim's Progress
	},
	["Feast of Winter Veil"] = {
		1691,  -- Merrymaker
		IsAlliance and 5853 or 5854, -- A-Caroling We Will Go
		1295,  -- Crashin' & Thrashin'
		IsAlliance and 4436 or 4437,  -- BB King
		8699,  -- The Danger Zone
		10353, -- Iron Armada
	},
	-- Aliases:  (since Overachiever.HOLIDAY_REV has these point to a different key, we don't need them to point to a table here)
}
-- Aliases:
ACHID_HOLIDAY["Winter Veil"] = ACHID_HOLIDAY["Feast of Winter Veil"]
ACHID_HOLIDAY["Midsummer"] = ACHID_HOLIDAY["Midsummer Fire Festival"]


-- Create reverse lookup table for L.SUBZONES:
local SUBZONES_REV = {}
for k,v in pairs(L.SUBZONES) do  SUBZONES_REV[v] = k;  end

local function ZoneLookup(zoneName, isSub, subz)
  zoneName = zoneName or subz or ""
  local trimz = strtrim(zoneName)
  local result = isSub and SUBZONES_REV[trimz] or LBZR[trimz] or LBZR[zoneName] or trimz
  if (not isSub) then  result = Overachiever.GetZoneKey(result);  end
  --[[
  if (not isSub and ZONE_RENAME[result]) then
    local mapID = Overachiever.GetCurrentMapID()
	if (mapID and ZONE_RENAME[result][mapID]) then
      --Overachiever.chatprint(result .. " got renamed to " .. ZONE_RENAME[result][mapID])
      return ZONE_RENAME[result][mapID]
	end
  end
  --]]
  return result
end


-- TRADESKILL ACHIEVEMENTS
----------------------------------------------------

local ACHID_TRADESKILL = {
	["Cooking"] = { 1563, 5845 },	-- "Hail to the Chef", "A Bunch of Lunch"
	["Fishing"] = { 1516, 5478, 5479, 5851 }, -- "Accomplished Angler", "The Limnologist", "The Oceanographer", "Gone Fishin'"
}

local ACHID_TRADESKILL_ZONE = {
	["Cooking"] = {
		["Dalaran"] = { 1998, IsAlliance and 1782 or 1783, 3217, 3296 },
			-- "Dalaran Cooking Award", "Our Daily Bread", "Chasing Marcia", "Cooking with Style"
		["Shattrath City"] = 906	-- "Kickin' It Up a Notch"
        },
	["Fishing"] = {
		["Dalaran"] = { 2096, 1958 },		-- "The Coin Master", "I Smell A Giant Rat"
		["Ironforge"] = { 1837 },		-- "Old Ironjaw"
		["Orgrimmar"] = {1836, "150:1"},	-- "Old Crafty", "The Fishing Diplomat"
		["Serpentshrine Cavern"] = 144,		-- "The Lurker Above"
		["Shattrath City"] = 905,		-- "Old Man Barlowned"
		["Stormwind City"] = { "150:2" },	-- "The Fishing Diplomat"
		["Terokkar Forest"] = { 905, 726 },	-- "Old Man Barlowned", "Mr. Pinchy's Magical Crawdad Box"
		--Feat of Strength: ["Zul'Gurub"] = 560,		-- "Deadliest Catch"

		-- "Master Angler of Azeroth":
		["The Cape of Stranglethorn"] = 306,
		["Northern Stranglethorn"] = 306, -- Need to confirm it belongs in both zones
		["Howling Fjord"] = 306,
		["Grizzly Hills"] = 306,
		["Borean Tundra"] = 306,
		["Sholazar Basin"] = 306,
		["Dragonblight"] = 306,
		["Crystalsong Forest"] = 306,
		["Icecrown"] = 306,
		["Zul'Drak"] = 306,
        }
}
if (IsAlliance) then
  tinsert(ACHID_TRADESKILL_ZONE["Fishing"]["Stormwind City"], 5476)	-- "Fish or Cut Bait: Stormwind"
  tinsert(ACHID_TRADESKILL_ZONE["Fishing"]["Ironforge"], 5847)		-- "Fish or Cut Bait: Ironforge"
  ACHID_TRADESKILL_ZONE["Fishing"]["Darnassus"] = 5848			-- "Fish or Cut Bait: Darnassus"
  ACHID_TRADESKILL_ZONE["Cooking"]["Stormwind City"] = 5474		-- "Let's Do Lunch: Stormwind"
  ACHID_TRADESKILL_ZONE["Cooking"]["Ironforge"] = 5841			-- "Let's Do Lunch: Ironforge"
  ACHID_TRADESKILL_ZONE["Cooking"]["Darnassus"] = 5842			-- "Let's Do Lunch: Darnassus"
else
  tinsert(ACHID_TRADESKILL_ZONE["Fishing"]["Orgrimmar"], 5477)		-- "Fish or Cut Bait: Orgrimmar"
  ACHID_TRADESKILL_ZONE["Fishing"]["Thunder Bluff"] = 5849		-- "Fish or Cut Bait: Thunder Bluff"
  ACHID_TRADESKILL_ZONE["Fishing"]["Undercity"] = 5850			-- "Fish or Cut Bait: Undercity"
  ACHID_TRADESKILL_ZONE["Cooking"]["Orgrimmar"] = 5475			-- "Let's Do Lunch: Orgrimmar"
  ACHID_TRADESKILL_ZONE["Cooking"]["Thunder Bluff"] = 5843		-- "Let's Do Lunch: Thunder Bluff"
  ACHID_TRADESKILL_ZONE["Cooking"]["Undercity"] = 5844			-- "Let's Do Lunch: Undercity"
end

ACHID_TRADESKILL_ZONE["Fishing"]["City of Ironforge"] = ACHID_TRADESKILL_ZONE["Fishing"]["Ironforge"]

local ACHID_TRADESKILL_BG = { Cooking = 1785 }	-- "Dinner Impossible"



-- SUGGESTIONS TAB CREATION AND HANDLING
----------------------------------------------------

local VARS, VARS_CHAR
local frame, panel, sortdrop
local LocationsList, EditZoneOverride, subzdrop, subzdrop_menu, subzdrop_Update = {}
local diffdrop, raidsizedrop
local RefreshBtn, ResetBtn, NoSuggestionsLabel, ResultsLabel
local ShowHiddenCheckbox

--WHAT = LocationsList

local function SortDrop_OnSelect(self, value)
  VARS.SuggestionsSort = value
  frame.sort = value
  frame:ForceUpdate(true)
end

local function OnLoad(v, ver, vc)
  VARS = v
  VARS_CHAR = vc
  sortdrop:SetSelectedValue(VARS.SuggestionsSort or 0)
end

frame, panel = Overachiever.BuildNewTab("Overachiever_SuggestionsFrame", L.SUGGESTIONS_TAB,
                "Interface\\AddOns\\Overachiever_Tabs\\SuggestionsWatermark", L.SUGGESTIONS_HELP, OnLoad,
                ACHIEVEMENT_FILTER_INCOMPLETE)
frame.AchList_checkprev = true

sortdrop = TjDropDownMenu.CreateDropDown("Overachiever_SuggestionsFrameSortDrop", panel, {
  {
    text = L.TAB_SORT_NAME,
    value = 0
  },
  {
    text = L.TAB_SORT_COMPLETE,
    value = 1
  },
  {
    text = L.TAB_SORT_POINTS,
    value = 2
  },
  {
    text = L.TAB_SORT_ID,
    value = 3
  };
})
sortdrop:SetLabel(L.TAB_SORT, true)
sortdrop:SetPoint("TOPLEFT", panel, "TOPLEFT", -16, -22)
sortdrop:OnSelect(SortDrop_OnSelect)

local CurrentSubzone

local function Refresh_Add(...)
  local id, _, complete, nextid
  local hidden = VARS_CHAR and VARS_CHAR.SuggestionsHidden
  for i=1, select("#", ...) do
    id = select(i, ...)
    if (id) then

      if (type(id) == "table") then
        Refresh_Add(unpack(id))
        if (id.SUBZONES) then
          for subz, subzsuggest in pairs(id.SUBZONES) do
            if (subz == CurrentSubzone or strfind(subz, "*"..CurrentSubzone.."*", 1, true)) then
            -- Asterisks surround subzone names since they aren't used in any actual subzone names.
              Refresh_Add(subzsuggest)
            end
          end
        end

      elseif (type(id) == "string") then
        local crit
        id, crit = strsplit(":", id)
        id, crit = tonumber(id), tonumber(crit)
        if (showHidden or not hidden or not hidden[id]) then
          _, _, _, complete = GetAchievementInfo(id)
          if (complete) then
            nextid, complete = GetNextAchievement(id)
            if (nextid) then
              local name = GetAchievementCriteriaInfo(id, crit)
              while (complete and GetAchievementCriteriaInfo(nextid, crit) == name) do
              -- Find first incomplete achievement in the chain that has this criteria:
                id = nextid
                nextid, complete = GetNextAchievement(id)
              end
              if (nextid and GetAchievementCriteriaInfo(nextid, crit) == name) then
                id = nextid
              end
            end
          end
          suggested[id] = crit
        -- Known limitation (of no consequence at this time due to which suggestions actually use this feature):
        -- If an achievement is suggested due to multiple criteria, only one of them is reflected by this.
        -- (A future fix may involve making it a table when there's more than one, though it would need to check
        -- against adding the same criteria number twice.)
        else
          numHidden = numHidden + 1
        end

      else
        _, _, _, complete = GetAchievementInfo(id)
        if (complete) then
          nextid, complete = GetNextAchievement(id)
          if (nextid) then
            while (complete) do  -- Find first incomplete achievement in the chain:
              id = nextid
              nextid, complete = GetNextAchievement(id)
            end
            id = nextid or id
          end
        end
        if (showHidden or not hidden or not hidden[id]) then
          suggested[id] = true
        else
          numHidden = numHidden + 1
        end
      end

    end
  end
end

local TradeskillSuggestions

local Refresh_lastcount, Refresh_stoploop = 0

local function Refresh(self, instanceRetry)
  if (not frame:IsVisible() or Refresh_stoploop) then  return;  end
  if (self == RefreshBtn or self == EditZoneOverride) then  PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);  end
  Refresh_stoploop = true

  wipe(suggested)
  EditZoneOverride:ClearFocus()
  CurrentSubzone = ZoneLookup(GetSubZoneText(), true)
  local inputtext = strtrim(EditZoneOverride:GetText())
  local zone = LocationsList[ strlower(inputtext) ]
  local textoverride = false
  local instanceTry
  if (zone) then
    textoverride = true
    zone = LocationsList[zone]
    EditZoneOverride:SetText(zone)
    EditZoneOverride:SetTextColor(1, 1, 1)
    if (self ~= subzdrop) then  subzdrop_Update(zone);  end
    local subz = subzdrop:GetSelectedValue()
    if (subz ~= 0) then  CurrentSubzone = subz;  end
  else
    if (instanceRetry ~= true) then -- check specifically against true because it could be "LeftButton"
      zone = GetZoneSpecialOverride()
      if (not zone and IsInInstance()) then
	    instanceTry = true
	    zone = ZoneLookup(GetInstanceInfo(), nil, CurrentSubzone)
		--zone = "fake place force retry"
	  end
	end
    if (not zone) then
	  instanceTry = false
	  zone = ZoneLookup(GetRealZoneText(), nil, CurrentSubzone)
	end
    if (inputtext and inputtext ~= "") then  EditZoneOverride:SetTextColor(0.75, 0.1, 0.1);  end
    --Refresh_stoploop = true
    subzdrop:SetMenu(subzdrop_menu)
    --Refresh_stoploop = nil
    subzdrop:Disable()
  end
  --print(zone)

  local instype, heroicD, mythicD, challenge, twentyfive, heroicR, mythicR = Overachiever.GetDifficulty()

  -- Check for difficulty override:
  local val = diffdrop:GetSelectedValue()
  if (val ~= 0) then
    heroicD = val == 2 and true or false
    heroicR = heroicD
    mythicD = val == 3 and true or false
    mythicR = mythicD
  end
  val = raidsizedrop:GetSelectedValue()
  if (val ~= 0) then
    twentyfive = val == 25 and true or false
  end

  numHidden = 0

  -- Suggestions based on an open tradeskill window or whether a fishing pole is equipped:
  TradeskillSuggestions = select(2, C_TradeSkillUI.GetTradeSkillLine())
  local tradeskill = LBIR[TradeskillSuggestions]
  if (not ACHID_TRADESKILL[tradeskill] and IsEquippedItemType(LBI["Fishing Poles"])) then
    TradeskillSuggestions, tradeskill = LBI["Fishing"], "Fishing"
  end
  if (ACHID_TRADESKILL[tradeskill]) then
    Refresh_Add(ACHID_TRADESKILL[tradeskill])
    if (ACHID_TRADESKILL_ZONE[tradeskill]) then
      Refresh_Add(ACHID_TRADESKILL_ZONE[tradeskill][zone])
    end
    if (instype == "pvp") then  -- If in a battleground:
      Refresh_Add(ACHID_TRADESKILL_BG[tradeskill])
    end
  elseif (textoverride and zone == L.SUGGESTIONS_HIDDENLOCATION) then
    if (VARS_CHAR.SuggestionsHidden) then
      for id in pairs(VARS_CHAR.SuggestionsHidden) do
        suggested[id] = true
      end
    end
    
  else
    TradeskillSuggestions = nil

  -- Suggestions for your location:
    if (instype and not textoverride) then  -- If in an instance:
      Refresh_Add(ACHID_INSTANCES[zone])
      if (instype == "pvp") then  -- If in a battleground:
        Refresh_Add(ACHID_BATTLEGROUNDS)
      end

      if (heroicD or heroicR) then
        if (twentyfive) then
          Refresh_Add(ACHID_INSTANCES_HEROIC[zone], ACHID_INSTANCES_HEROIC_PLUS[zone], ACHID_INSTANCES_25[zone], ACHID_INSTANCES_25_HEROIC[zone])
        else
          Refresh_Add(ACHID_INSTANCES_HEROIC[zone], ACHID_INSTANCES_HEROIC_PLUS[zone], ACHID_INSTANCES_10[zone], ACHID_INSTANCES_10_HEROIC[zone])
        end
      else
        if (twentyfive) then
          Refresh_Add(ACHID_INSTANCES_NORMAL[zone], ACHID_INSTANCES_25[zone], ACHID_INSTANCES_25_NORMAL[zone])
        else
          Refresh_Add(ACHID_INSTANCES_NORMAL[zone], ACHID_INSTANCES_10[zone], ACHID_INSTANCES_10_NORMAL[zone])
        end
      end

      if (mythicD or mythicR) then
        Refresh_Add(ACHID_INSTANCES_MYTHIC[zone], ACHID_INSTANCES_HEROIC_PLUS[zone])
        -- No need to check twentyfive; that's a legacy classification and the dungeons/raids with mythic-only achievements don't use it.
      end

    else
      Refresh_Add(Overachiever.ExploreZoneIDLookup(zone), ACHID_ZONE_NUMQUESTS[zone], ACHID_ZONE_MISC[zone])
      -- Also look for instance achievements for an instance you're near if we can look it up easily (since many zones
      -- have subzones with the instance name when you're near the instance entrance and some instance entrances are
      -- actually in their own "zone" using the instance's zone name):
      Refresh_Add(ACHID_INSTANCES[CurrentSubzone] or ACHID_INSTANCES[zone])

      local ach10, ach25 = ACHID_INSTANCES_10[CurrentSubzone] or ACHID_INSTANCES_10[zone], ACHID_INSTANCES_25[CurrentSubzone] or ACHID_INSTANCES_25[zone]
      local achH10, achH25 = ACHID_INSTANCES_10_HEROIC[CurrentSubzone] or ACHID_INSTANCES_10_HEROIC[zone], ACHID_INSTANCES_25_HEROIC[CurrentSubzone] or ACHID_INSTANCES_25_HEROIC[zone]
      local achN10, achN25 = ACHID_INSTANCES_10_NORMAL[CurrentSubzone] or ACHID_INSTANCES_10_NORMAL[zone], ACHID_INSTANCES_25_NORMAL[CurrentSubzone] or ACHID_INSTANCES_25_NORMAL[zone]

      if (ach10 or ach25 or achH10 or achH25 or achN10 or achN25) then
      -- If there are 10-man or 25-man specific achievements, this is a raid:
        if (heroicR) then
          if (twentyfive) then
            Refresh_Add(ACHID_INSTANCES_HEROIC[CurrentSubzone] or ACHID_INSTANCES_HEROIC[zone],
				ACHID_INSTANCES_HEROIC_PLUS[CurrentSubzone] or ACHID_INSTANCES_HEROIC_PLUS[zone],
				ach25, achH25)
          else
            Refresh_Add(ACHID_INSTANCES_HEROIC[CurrentSubzone] or ACHID_INSTANCES_HEROIC[zone],
				ACHID_INSTANCES_HEROIC_PLUS[CurrentSubzone] or ACHID_INSTANCES_HEROIC_PLUS[zone],
				ach10, achH10)
          end
        else
          if (twentyfive) then
            Refresh_Add(ACHID_INSTANCES_NORMAL[CurrentSubzone] or ACHID_INSTANCES_NORMAL[zone], ach25, achN25)
          else
            Refresh_Add(ACHID_INSTANCES_NORMAL[CurrentSubzone] or ACHID_INSTANCES_NORMAL[zone], ach10, achN10)
          end
        end
      -- Not a raid (or at least no 10-man vs 25-man specific suggestions):
      elseif (heroicD) then
        Refresh_Add(ACHID_INSTANCES_HEROIC[CurrentSubzone] or ACHID_INSTANCES_HEROIC[zone],
			ACHID_INSTANCES_HEROIC_PLUS[CurrentSubzone] or ACHID_INSTANCES_HEROIC_PLUS[zone])
      else
        Refresh_Add(ACHID_INSTANCES_NORMAL[CurrentSubzone] or ACHID_INSTANCES_NORMAL[zone])
      end

      if (mythicD or mythicR) then
	    Refresh_Add(ACHID_INSTANCES_MYTHIC[CurrentSubzone] or ACHID_INSTANCES_MYTHIC[zone],
			ACHID_INSTANCES_HEROIC_PLUS[CurrentSubzone] or ACHID_INSTANCES_HEROIC_PLUS[zone])
      end
    end

    if (textoverride) then
      Refresh_Add(ACHID_HOLIDAY[zone])
    end

  end

  -- Suggestions from recent reminders:
  Overachiever.RecentReminders_Check()
  for id in pairs(RecentReminders) do
    suggested[id] = true
  end

  local list, count = frame.AchList, 0
  wipe(list)
  local critlist = frame.AchList_criteria and wipe(frame.AchList_criteria)
  if (not critlist) then
    critlist = {}
    frame.AchList_criteria = critlist
  end
  for id,v in pairs(suggested) do
    count = count + 1
    list[count] = id
    if (v ~= true) then
      critlist[id] = v
    end
  end

  if (count == 0 and instanceTry) then
    Refresh_stoploop = nil
    return Refresh(nil, true)
  end

  if (self ~= panel or Refresh_lastcount ~= count) then
    Overachiever_SuggestionsFrameContainerScrollBar:SetValue(0)
  end
  frame:ForceUpdate(true)
  Refresh_lastcount = count
  Refresh_stoploop = nil
end

function frame.SetNumListed(num)
  if (num > 0 or numHidden > 0) then
    NoSuggestionsLabel:Hide()
    if (TradeskillSuggestions) then
      if (numHidden > 0) then
        ResultsLabel:SetText(L.SUGGESTIONS_RESULTS_TRADESKILL_HIDDEN:format(TradeskillSuggestions, num, numHidden))
      else
        ResultsLabel:SetText(L.SUGGESTIONS_RESULTS_TRADESKILL:format(TradeskillSuggestions, num))
      end
    else
      if (numHidden > 0) then
        ResultsLabel:SetText(L.SUGGESTIONS_RESULTS_HIDDEN:format(num, numHidden))
      else
        ResultsLabel:SetText(L.SUGGESTIONS_RESULTS:format(num))
      end
    end
  end
  if (num == 0) then
    NoSuggestionsLabel:Show()
    if (TradeskillSuggestions) then
      NoSuggestionsLabel:SetText(L.SUGGESTIONS_EMPTY_TRADESKILL:format(TradeskillSuggestions))
    else
      NoSuggestionsLabel:SetText(L.SUGGESTIONS_EMPTY)
    end
    if (numHidden < 1) then  ResultsLabel:SetText(" ");  end
  end
end

RefreshBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
RefreshBtn:SetWidth(75); RefreshBtn:SetHeight(21)
--RefreshBtn:SetPoint("TOPLEFT", sortdrop, "BOTTOMLEFT", 16, -14)
RefreshBtn:SetText(L.SUGGESTIONS_REFRESH)
RefreshBtn:SetScript("OnClick", Refresh)

ResultsLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
ResultsLabel:SetPoint("TOPLEFT", RefreshBtn, "BOTTOMLEFT", 0, -8)
ResultsLabel:SetWidth(178)
ResultsLabel:SetJustifyH("LEFT")
ResultsLabel:SetText(" ")

panel:SetScript("OnShow", Refresh)

NoSuggestionsLabel = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
NoSuggestionsLabel:SetPoint("TOP", frame, "TOP", 0, -189)
NoSuggestionsLabel:SetText(L.SUGGESTIONS_EMPTY)
NoSuggestionsLabel:SetWidth(490)

frame:RegisterEvent("TRADE_SKILL_SHOW")
frame:RegisterEvent("TRADE_SKILL_CLOSE")
frame:SetScript("OnEvent", Refresh)


ShowHiddenCheckbox = CreateFrame("CheckButton", "Overachiever_SuggestionsFrameShowHiddenCheckbox", panel, "InterfaceOptionsCheckButtonTemplate")
--ShowHiddenCheckbox:SetPoint("LEFT", sortdrop, "LEFT", 14, 0); ShowHiddenCheckbox:SetPoint("TOP", BaseLabel, "BOTTOM", 0, -24);
--ShowHiddenCheckbox:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 0, 2)
ShowHiddenCheckbox:SetPoint("LEFT", sortdrop, "LEFT", 14, 0)
ShowHiddenCheckbox:SetPoint("BOTTOM", panel, "BOTTOM", 0, 0)
Overachiever_SuggestionsFrameShowHiddenCheckboxText:SetText(L.SUGGESTIONS_SHOWHIDDEN)
Overachiever_SuggestionsFrameShowHiddenCheckboxText:SetJustifyH("LEFT")
ShowHiddenCheckbox:SetHitRectInsets(0, -1 * min(Overachiever_SuggestionsFrameShowHiddenCheckboxText:GetWidth() + 8, 155), 0, 0)

ShowHiddenCheckbox:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
  GameTooltip:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
  GameTooltip:AddLine(L.SUGGESTIONS_SHOWHIDDEN_TIP, nil, nil, nil, 1)
  GameTooltip:AddLine(L.SUGGESTIONS_SHOWHIDDEN_TIP2, nil, nil, nil, 1)
  GameTooltip:Show()
end)
ShowHiddenCheckbox:SetScript("OnLeave", GameTooltip_Hide)
ShowHiddenCheckbox:SetScript("OnClick", function(self)
  if (self:GetChecked()) then
    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
    showHidden = true
    Refresh(panel)
  else
    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
    showHidden = false
    Refresh(panel)
  end
end)


-- SUPPORT FOR OTHER ADDONS
----------------------------------------------------

-- Open suggestions tables up for other addons to read or manipulate:
Overachiever.SUGGESTIONS = {
	zone_numquests = ACHID_ZONE_NUMQUESTS,
	zone = ACHID_ZONE_MISC,
	--zone_id = ACHID_ZONEID_MISC,
	instance = ACHID_INSTANCES,
	bg = ACHID_BATTLEGROUNDS,
	instance_normal = ACHID_INSTANCES_NORMAL,
	instance_heroic = ACHID_INSTANCES_HEROIC,
	instance_heroic_plus = ACHID_INSTANCES_HEROIC_PLUS,
	instance_10 = ACHID_INSTANCES_10,
	instance_25 = ACHID_INSTANCES_25,
	instance_10_normal = ACHID_INSTANCES_10_NORMAL,
	instance_10_heroic = ACHID_INSTANCES_10_HEROIC,
	instance_25_normal = ACHID_INSTANCES_25_NORMAL,
	instance_25_heroic = ACHID_INSTANCES_25_HEROIC,
	instance_mythic = ACHID_INSTANCES_MYTHIC,
	tradeskill = ACHID_TRADESKILL,
	tradeskill_zone = ACHID_TRADESKILL_ZONE,
	tradeskill_bg = ACHID_TRADESKILL_BG,
	holiday = ACHID_HOLIDAY,
}



-- ZONE/INSTANCE OVERRIDE INPUT
----------------------------------------------------

EditZoneOverride = CreateFrame("EditBox", "Overachiever_SuggestionsFrameZoneOverrideEdit", panel, "InputBoxTemplate")
EditZoneOverride:SetWidth(170); EditZoneOverride:SetHeight(16)
EditZoneOverride:SetAutoFocus(false)
EditZoneOverride:SetPoint("TOPLEFT", sortdrop, "BOTTOMLEFT", 22, -19)
do
  local label = EditZoneOverride:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
  label:SetPoint("BOTTOMLEFT", EditZoneOverride, "TOPLEFT", -6, 4)
  label:SetText(L.SUGGESTIONS_LOCATION)

  -- CREATE LIST OF VALID LOCATIONS:
  -- Add all zones to the list:
  local zonetab = {}
  for i=1,select("#",Overachiever.GetMapContinents_names()) do  zonetab[i] = { Overachiever.GetMapZones_names(i) };  end
  for i,tab in ipairs(zonetab) do
    for n,z in ipairs(tab) do
	  if (not ZONE_RENAME[LBZR[z] or z]) then  -- Omit zones that we use a different name for so we don't create a confusing autocomplete (e.g. people type "Dalaran" but get no suggestions because we put them somewhere else).
	    suggested[z] = true -- Already localized so no need for LBZ here.
	  --else  Overachiever.chatprint("omitting "..z)
	  end
	end
  end
  zonetab = nil
  -- Add instances for which we have suggestions:
  local locallookup = nil
  local function addtolist(list, ...)
    local tab
    for i=1,select("#", ...) do
      tab = select(i, ...)
      for k,v in pairs(tab) do
	    list[ (locallookup and locallookup[k]) or LBZ[k] or ZONE_RENAME_REV[k] or k ] = true  -- Add localized version of zone/instance names.
		--print("adding: k = "..(LBZ[k] or k)..(LBZ[k] and "" or "no LBZ[k]"))
		if (Overachiever_Debug and (not (locallookup and locallookup[k])) and not LBZ[k] and not ZONE_RENAME_REV[k]) then  print("POSSIBLE ERROR - no LBZ lookup found for "..k);  end
	  end
    end
  end
  addtolist(suggested, ACHID_INSTANCES, ACHID_INSTANCES_NORMAL, ACHID_INSTANCES_HEROIC, ACHID_INSTANCES_HEROIC_PLUS,
            ACHID_INSTANCES_10, ACHID_INSTANCES_25, ACHID_INSTANCES_10_NORMAL, ACHID_INSTANCES_25_NORMAL,
            ACHID_INSTANCES_10_HEROIC, ACHID_INSTANCES_25_HEROIC, ACHID_INSTANCES_MYTHIC)
  addtolist(suggested, ACHID_ZONE_MISC); -- Required for "unlisted" zones like Molten Front (doesn't appear in GetMapContinents/GetMapZones scan)
  locallookup = Overachiever.HOLIDAY_REV
  addtolist(suggested, ACHID_HOLIDAY); -- These aren't actual zones but we want the user to be able to look them up by name.
  locallookup = nil
  addtolist = nil

  suggested[L.SUGGESTIONS_HIDDENLOCATION] = true  -- Add another special location, this for Hidden suggestions

  -- Arrange into alphabetically-sorted array:
  local count = 0
  for k in pairs(suggested) do
    count = count + 1
    LocationsList[count] = k
	--print("adding "..k)
  end
  wipe(suggested)
  sort(LocationsList)
  -- Cross-reference by lowercase key to place in the array:
  for i,v in ipairs(LocationsList) do  LocationsList[strlower(v)] = i;  end
end

EditZoneOverride:SetScript("OnEnterPressed", Refresh)

local function findFirstLocation(text)
  if (strtrim(text) == "") then  return;  end
  local len = strlen(text)
  for i,v in ipairs(LocationsList) do
    if (strsub(strlower(v), 1, len) == text) then  return i, v, len, text;  end
  end
end

EditZoneOverride:SetScript("OnEditFocusGained", function(self)
  self:SetTextColor(1, 1, 1)
  self:HighlightText()
  CloseMenus()
end)

EditZoneOverride:SetScript("OnChar", function(self)
  local i, v, len = findFirstLocation(strlower(self:GetText()))
  if (i) then
    self:SetText(v)
    self:HighlightText(len, strlen(v))
    self:SetCursorPosition(len)
  end
end)

EditZoneOverride:SetScript("OnTabPressed", function(self)
  local text = strlower(self:GetText())
  local text2, len
  if (text == "") then
    text2 = LocationsList[IsShiftKeyDown() and #LocationsList or 1]
    len = 0
  elseif (not LocationsList[text]) then
    len = self:GetUTF8CursorPosition()
    if (len == 0) then
      text2 = LocationsList[IsShiftKeyDown() and #LocationsList or 1]
    else
      text = strsub(text, 1, len)
      if (IsShiftKeyDown()) then
        for i = #LocationsList, 1, -1 do
          if (strsub(strlower(LocationsList[i]), 1, len) == text) then
            text2 = LocationsList[i]
            break;
          end
        end
      else
        local i
        i, text2, len = findFirstLocation(text)
      end
    end
  else
    local i, v
    i, v, len, text = findFirstLocation(text)
    if (i) then
      local pos = self:GetUTF8CursorPosition()
      text = strsub(text, 1, pos)
      len = strlen(text)
      local mod = IsShiftKeyDown() and -1 or 1
      repeat
        i = i + mod
        text2 = LocationsList[i]
        if (not text2) then  i = (mod == 1 and 0) or #LocationsList + 1;  end
      until (text2 and strsub(strlower(text2), 1, pos) == text)
    end
  end
  if (text2) then
    self:SetText(text2)
    self:HighlightText(len, strlen(text2))
    self:SetCursorPosition(len)
  end
end)

EditZoneOverride:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
  GameTooltip:AddLine(L.SUGGESTIONS_LOCATION_TIP, 1, 1, 1)
  GameTooltip:AddLine(L.SUGGESTIONS_LOCATION_TIP2, nil, nil, nil, 1)
  GameTooltip:Show()
end)

EditZoneOverride:SetScript("OnLeave", function(self)
  GameTooltip:Hide()
end)


subzdrop_menu = {  {  text = L.SUGGESTIONS_LOCATION_NOSUBZONE, value = 0  };  }
subzdrop = TjDropDownMenu.CreateDropDown("Overachiever_SuggestionsFrameSubzoneDrop", panel, subzdrop_menu)
subzdrop:SetLabel(L.SUGGESTIONS_LOCATION_SUBZONE, true)
subzdrop:SetPoint("LEFT", sortdrop, "LEFT")
subzdrop:SetPoint("TOP", EditZoneOverride, "BOTTOM", 0, -21)
subzdrop:SetDropDownWidth(158)
subzdrop:OnSelect(Refresh)

do
  local menu

  local function addtosubzlist(list, key, ...)
    local tab
    for i=1,select("#", ...) do
      tab = select(i, ...)
      tab = tab[key]
      tab = type(tab) == "table" and tab.SUBZONES
      if (tab) then
        for k in pairs(tab) do
          if (strsub(k, 1, 1) == "*") then
            for subz in gmatch(k, "%*?([^%*]+)%*") do  list[ L.SUBZONES[subz] or subz ] = true;  end
          else
            list[ L.SUBZONES[k] or k ] = true
          end
        end
      end
    end
  end

  function subzdrop_Update(zone)
    menu = menu or {}
    if (menu[zone] == nil) then
      local tab = {}
      addtosubzlist(suggested, zone, ACHID_ZONE_MISC, ACHID_INSTANCES, ACHID_INSTANCES_10, ACHID_INSTANCES_25,
                ACHID_INSTANCES_10_NORMAL, ACHID_INSTANCES_25_NORMAL, ACHID_INSTANCES_10_HEROIC, ACHID_INSTANCES_25_HEROIC)
      -- Arrange into alphabetically-sorted array:
      local count = 0
      for k in pairs(suggested) do
        count = count + 1
        tab[count] = k
      end
      wipe(suggested)
      if (count > 0) then
        sort(tab)  -- Sort alphabetically.
        -- Turn into dropdown menu format:
        for i,name in ipairs(tab) do  tab[i] = {  text = name, value = name  };  end
        tinsert(tab, 1, {  text = L.SUGGESTIONS_LOCATION_NOSUBZONE, value = 0  })
        menu[zone] = tab
        subzdrop:SetMenu(tab)
        subzdrop:SetSelectedValue(0)
        subzdrop:Enable()
        return;
      else
        menu[zone] = false
      end
    end
    if (menu[zone]) then
      subzdrop:SetMenu(menu[zone])
      subzdrop:Enable()
    else
      subzdrop:SetMenu(subzdrop_menu)
      subzdrop:Disable()
    end
  end
end

local orig_subzdropBtn_OnClick = Overachiever_SuggestionsFrameSubzoneDropButton:GetScript("OnClick")
Overachiever_SuggestionsFrameSubzoneDropButton:SetScript("OnClick", function(...)
  Refresh()
  if (subzdrop:IsEnabled()) then  orig_subzdropBtn_OnClick(...);  end
end)


-- Override for Normal/Heroic and group size
diffdrop = TjDropDownMenu.CreateDropDown("Overachiever_SuggestionsFrameDiffDrop", panel, {
  {
    text = L.SUGGESTIONS_DIFFICULTY_AUTO,
    value = 0
  },
  {
    text = L.SUGGESTIONS_DIFFICULTY_NORMAL,
    value = 1
  },
  {
    text = L.SUGGESTIONS_DIFFICULTY_HEROIC,
    value = 2
  },
  {
    text = L.SUGGESTIONS_DIFFICULTY_MYTHIC,
    value = 3
  };
})
diffdrop:SetLabel(L.SUGGESTIONS_DIFFICULTY, true)
diffdrop:SetPoint("TOPLEFT", subzdrop, "BOTTOMLEFT", 0, -18)
diffdrop:OnSelect(Refresh)

raidsizedrop = TjDropDownMenu.CreateDropDown("Overachiever_SuggestionsFrameRaidSizeDrop", panel, {
  {
    text = L.SUGGESTIONS_RAIDSIZE_AUTO,
    value = 0
  },
  {
    text = L.SUGGESTIONS_RAIDSIZE_10,
    value = 10
  },
  {
    text = L.SUGGESTIONS_RAIDSIZE_25,
    value = 25
  };
})
raidsizedrop:SetLabel(L.SUGGESTIONS_RAIDSIZE, true)
raidsizedrop:SetPoint("TOPLEFT", diffdrop, "BOTTOMLEFT", 0, -18)
raidsizedrop:OnSelect(Refresh)



RefreshBtn:SetPoint("TOPLEFT", raidsizedrop, "BOTTOMLEFT", 16, -14)

ResetBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
ResetBtn:SetWidth(75); ResetBtn:SetHeight(21)
ResetBtn:SetPoint("LEFT", RefreshBtn, "RIGHT", 4, 0)
ResetBtn:SetText(L.SEARCH_RESET)
ResetBtn:SetScript("OnClick", function(self)
  PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
  EditZoneOverride:SetText("")
  Refresh()
end)



-- MISCELLANEOUS
----------------------------------------------------

function Overachiever.OpenSuggestionsTab(text)
	EditZoneOverride:SetText(text)
	if (Overachiever.GetSelectedTab() == frame) then
		Overachiever.OpenTab_frame(frame)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	else
		Overachiever.OpenTab_frame(frame, true)
	end
end

function frame.ShouldCrossOut(id)
	return VARS_CHAR.SuggestionsHidden and VARS_CHAR.SuggestionsHidden[id]
end

function frame.HandleRightClick(id)
	if (not IsShiftKeyDown()) then  return;  end
	if (VARS_CHAR.SuggestionsHidden and VARS_CHAR.SuggestionsHidden[id]) then
		VARS_CHAR.SuggestionsHidden[id] = nil
		if (next(VARS_CHAR.SuggestionsHidden) == nil) then -- Is the table empty?
			VARS_CHAR.SuggestionsHidden = nil
		end
	else
		if (not VARS_CHAR.SuggestionsHidden) then  VARS_CHAR.SuggestionsHidden = {};  end
		VARS_CHAR.SuggestionsHidden[id] = true
	end
	Refresh(panel)
end

--[[
local function grabFromCategory(cat, ...)
  wipe(suggested)
  -- Get achievements in the category except those with a previous one in the chain that are also in the category:
  local id, prev, p2
  for i = 1, GetCategoryNumAchievements(cat) do
    id = GetAchievementInfo(cat, i)
	if (id) then
      prev, p2 = nil, GetPreviousAchievement(id)
      while (p2 and GetAchievementCategory(p2) == cat) do
        prev = p2
        p2 = GetPreviousAchievement(id)
      end
      suggested[ (prev or id) ] = true
	end
  end
  -- Add achievements specified by function call (useful for meta-achievements in a different category):
  for i=1, select("#", ...) do
    id = select(i, ...)
    suggested[id] = true
  end
  -- Fold achievements into their meta-achievements on the list:
  local tab, _, critType, assetID = {}
  for id in pairs(suggested) do
    for i=1,GetAchievementNumCriteria(id) do
      _, critType, _, _, _, _, _, assetID = GetAchievementCriteriaInfo(id, i)
      if (critType == 8 and suggested[assetID]) then
        tab[assetID] = true -- Not removed immediately in case there are meta-achievements within meta-achievements
      end
    end
  end
  for assetID in pairs(tab) do  suggested[assetID] = nil;  end
  -- Format list:
  local count = 0
  wipe(tab)
  for id in pairs(suggested) do
    count = count + 1
    tab[count] = id
  end
  return tab
end
--]]

-- ULDUAR 10: Results from grabFromCategory(14961, 2957):
--	{ 2894, 2903, 2905, 2907, 2909, 2911, 2913, 2919, 2925, 2927, 2931, 2933, 2934, 2937, 2939, 2940, 2945, 2947, 2951, 2955, 2957, 2959, 2961, 2963, 2967, 2969, 2971, 2973, 2975, 2977, 2979, 2980, 2982, 2985, 2989, 2996, 3003, 3004, 3008, 3009, 3012, 3014, 3015, 3036, 3076, 3097, 3138, 3157, 3177, 3316 }
-- ULDUAR 25: Results from grabFromCategory(14962, 2958):
--	{ 2895, 2904, 2906, 2908, 2910, 2912, 2918, 2921, 2926, 2928, 2932, 2935, 2936, 2938, 2942, 2943, 2946, 2948, 2952, 2956, 2958, 2960, 2962, 2965, 2968, 2970, 2972, 2974, 2976, 2978, 2981, 2983, 2984, 2995, 2997, 3002, 3005, 3010, 3011, 3013, 3016, 3017, 3037, 3077, 3098, 3118, 3161, 3185, 3237 }

--[[
-- /run Overachiever.Debug_GetIDsInCat( GetAchievementCategory(GetTrackedAchievements()) )
function Overachiever.Debug_GetIDsInCat(cat, simple)
  local tab = Overachiever_Settings.Debug_AchIDsInCat
  if (not tab) then  Overachiever_Settings.Debug_AchIDsInCat = {};  tab = Overachiever_Settings.Debug_AchIDsInCat;  end
  local catname = GetCategoryInfo(cat)
  tab[catname] = {}
  local subtab = tab[catname]
  local id, n
  for i=1,GetCategoryNumAchievements(cat) do
    id, n = GetAchievementInfo(cat, i)
    if (id) then
      if (simple) then
        subtab[i] = id
      else
        subtab[n] = id
      end
    end
  end
  if (simple) then  tab[catname] = table.concat(tab[catname], ", ");  end
end
--]]

--[[
-- /run Overachiever.Debug_GetMissingAch()
local function getAchIDsFromTab(from, to)
  for k,v in pairs(from) do
    if (type(v) == "table") then
      getAchIDsFromTab(v, to)
    else
      if (type(v) == "string") then
        local id, crit = strsplit(":", v)
        id, crit = tonumber(id) or id, tonumber(crit) or crit
        to[id] = to[id] or {}
        to[id][crit] = true
      else
        to[v] = to[v] or false
      end
    end
  end
end
--local isAchievementInUI = Overachiever.IsAchievementInUI
--local function isPreviousAchievementInUI(id)
--  id = GetPreviousAchievement(id)
--  if (id) then
--    if (isAchievementInUI(id)) then  return true;  end
--    return isPreviousAchievementInUI(id)
--  end
--end
local FEAT_OF_STRENGTH_ID = 81;
local GUILD_FEAT_OF_STRENGTH_ID = 15093;

function Overachiever.Debug_GetMissingAch()
  wipe(suggested)
  getAchIDsFromTab(Overachiever.SUGGESTIONS, suggested)
  getAchIDsFromTab(OVERACHIEVER_ACHID, suggested)
  getAchIDsFromTab(OVERACHIEVER_EXPLOREZONEID, suggested)
  local count = 0
  for id, crit in pairs(suggested) do
    if (type(id) ~= "number") then
      print("Invalid ID type:",id,type(id))
      count = count + 1
    elseif (GetAchievementInfo(id)) then
      --if (not isAchievementInUI(id, true) and not isPreviousAchievementInUI(id)) then
      --  print(GetAchievementLink(id),"is not found in the UI for this character.")
      --  count = count + 1
      local cat = GetAchievementCategory(id)
      if (cat == FEAT_OF_STRENGTH_ID or cat == GUILD_FEAT_OF_STRENGTH_ID) then
        print(GetAchievementLink(id)," ("..id..") is a Feat of Strength.")
        count = count + 1
      elseif (crit) then
        local num = GetAchievementNumCriteria(id)
        for c in pairs(crit) do
          if (c > num) then
            print(GetAchievementLink(id),"is missing criteria #"..(tostring(c) or "<?>"))
            count = count + 1
          end
        end
      end
    else
      print("Missing ID:",id..(crit and " (with criteria)" or ""))
      count = count + 1
    end
  end
  print("Overachiever.Debug_GetMissingAch():",count,"problems found.")
end
--]]


-- Thanks to chrisnolanca for many of the WoD changes.
-- https://github.com/ChrisNolan/OverachieverContinued/compare/WoDchanges


-- where? !!
-- 11607 They See Me Rolling
