-- Functions
local _G = getfenv(0)
local pairs = _G.pairs;
-- Libraries
-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...
local LibStub = _G.LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name);

local function GetLocaleLibBabble(typ)
	local rettab = {}
	local tab = LibStub(typ):GetBaseLookupTable()
	local loctab = LibStub(typ):GetUnstrictLookupTable()
	for k,v in pairs(loctab) do
		rettab[k] = v;
	end
	for k,v in pairs(tab) do
		if not rettab[k] then
			rettab[k] = v;
		end
	end
	return rettab;
end
local BZ = GetLocaleLibBabble("LibBabble-SubZone-3.0");
local function mapFile(mapID)
	return HandyNotes:GetMapIDtoMapFile(mapID)
end

local DB = {}

private.DB = DB

DB.points = {
	--[[ structure:
	[mapFile] = { -- "_terrain1" etc will be stripped from attempts to fetch this
		[coord] = {
			label=[string], 		-- label: text that'll be the label, optional
			npc=[id], 				-- related npc id, used to display names in tooltip
			type=[string], 			-- the pre-define icon type which can be found in Constant.lua
			class=[CLASS NAME],		-- specified the class name so that this node will only be available for this class
			faction="FACTION",      -- shows only for selected faction
			note=[string],			-- additional notes for this node
			level=[number]			-- map level from dropdown
		},
	},
	--]]
	[mapFile(1014)] = { -- Dalaran Broken Isles
		[38296559] = { portal=true, level=10, label=format(L[" Portal to Stormwind \n Portal to Ironforge \n Portal to Darnasuss \n Portal to Exodar \n Portal to Shrine of Seven Stars"]), faction="Alliance" },
		[49354757] = { portal=true, level=10, label=L[" Caverns of Time \n Shattrath \n Wyrmrest Temple \n Dalaran Crater \n Karazhan"]  },
		[38747963] = { portal=true, level=12, label=format(L["Portal to Caverns of Time"]) },
		[35658549] = { portal=true, level=12, label=format(L["Portal to Shattrath"]) },
		[30798447] = { portal=true, level=12, label=format(L["Portal to Wyrmrest Temple"]) },
		[28777754] = { portal=true, level=12, label=format(L["Portal to Dalaran Crater, Alterac Mtn."]) },
		[31967150] = { portal=true, level=12, label=format(L["Portal to Karazhan"]) },
--		[] = { portal=true, level=10, label=format(L[" Portal to Ogrimmar \n Portal to Thunder Bluff \n Portal to Undercity \n Portal to Silvermoon \n Portal to Shrine of Two Moons"]), faction="Horde" },
	},
	[mapFile(1007)] = { -- Broken Isles
		[30712543] = { portal=true, label=format(L[" Portal to Dalaran \n Portal to Emerald Dreamway"]), class="DRUID" },
		[45666494] = { portal=true, label=format(L[" Portal to Stormwind \n Portal to Ironforge \n Portal to Darnasuss \n Portal to Exodar \n Portal to Shrine of Seven Stars \n Portal to Caverns of Time \n Portal to Shattrath \n Portal to Wyrmrest Temple \n Portal to Dalaran Crater \n Portal to Karazhan"]), faction="Alliance" },
		[45666495] = { portal=true, label=format(L[" Portal to Ogrimmar \n Portal to Thunder Bluff \n Portal to Undercity \n Portal to Silvermoon \n Portal to Shrine of Two Moons \n Portal to Caverns of Time \n Portal to Shattrath \n Portal to Wyrmrest Temple \n Portal to Dalaran Crater \n Portal to Karazhan"]), faction="Horde" },
	},
	[mapFile(1018)] = { -- Val'sharah
		[41742385] = { portal=true, label=format(L[" Portal to Dalaran \n Portal to Emerald Dreamway"]), class="DRUID" },
	},
	[mapFile(301)] = { -- Stormwind
		[48948733] = { portal=true, label=format(L[" Portal to Blasted Lands \n Portal to Hellfire Peninsula"]), faction="Alliance" },
		[87543524] = { portal=true, label=format(L["Portal to Ashran"]) },
		[22015670] = { boat=true, label=format(L["Boat to Darnassus"]), note=L["Rut'theran Village"], faction="Alliance" },
		[17592553] = { boat=true, label=format(L["Boat to Borean Tundra"]), note=L["Valiance Keep"], faction="Alliance" },
		[74481841] = { portal=true, label=format(L[" Portal to Tol Barad \n Portal ro Uldum \n Portal to Deepholm \n Portal to Vashj'ir \n Portal to Twilight Highlands \n Portal to Hyjal"]), faction="Alliance" },
--		[] = { portal=true, label=format(L["Portal to Pandaria"]), faction="Alliance" },
	},
--	[mapFile(321)] = { -- Ogrimmar
--		[] = { portal=true, label=format(L[" Portal to Blasted Lands \n Portal to Hellfire Peninsula"]), faction="Horde" },
--		[] = { zeplin=true, label=format(L["Zeplin to Undercity"]), note=L["Tirisfal Glades"], faction="Horde" },
--		[] = { zeplin=true, label=format(L["Zeplin to Thunder Bluff"]), note=L["Mulgore"], faction="Horde" },
--		[] = { portal=true, label=format(L[" Portal to Tol Barad \n Portal ro Uldum \n Portal to Deepholm \n Portal to Vashj'ir \n Portal to Twilight Highlands \n Portal to Hyjal"]), faction="Horde" },
--		[] = { portal=true, label=format(L["Portal to Pandaria"]) }
--		[] = { zeplin=true, label=format(L["Zeplin to Borean Tundra"]), note=L["Warsong Hold"], faction="Horde" },
--		[] = { zeplin=true, label=format(L["Zeplin to Stranglethorn Vale"]), note=L["Grom'gol Base Camp"], faction="Horde" },
--		},
--	[mapFile(382)] = { -- Undercity
--		[] = { portal=true, label=format(L[" Portal to Blasted Lands \n Portal to Hellfire Peninsula"]), faction="Horde" },
--		},
--	[mapFile(20)] = { -- Trisfal Glades
--		[] = { portal=true, label=format(L[" Portal to Blasted Lands \n Portal to Hellfire Peninsula"]), faction="Horde" },
--		[] = { zeplin=true, label=format(L["Zeplin to Ogrimmar"]), note=L["Durotar"], faction="Horde" },
--		[] = { zeplin=true, label=format(L["Zeplin to Stranglethorn Vale"]), note=L["Grom'gol Base Camp"], faction="Horde" },
--		[] = { zeplin=true, label=format(L["Zeplin to Howling Fjord"]), note=L["Vengeance Landing"], faction="Horde" },
--		},
--	[mapFile(362)] = { -- Thunder Bluff
--		[] = { portal=true, label=format(L[" Portal to Blasted Lands \n Portal to Hellfire Peninsula"]), faction="Horde" },
--		[] = { zeplin=true, label=format(L["Zeplin to Ogrimmar"]), note=L["Durotar"], faction="Horde" },
--		},
--	[mapFile(9)] = { -- Mulgore
--		[] = { portal=true, label=format(L[" Portal to Blasted Lands \n Portal to Hellfire Peninsula"]), faction="Horde" },
--		[] = { zeplin=true, label=format(L["Zeplin to Ogrimmar"]), note=L["Durotar"], faction="Horde" },
--		},
	[mapFile(40)] = { -- Wetlands
		[06216261] = { boat=true, label=format(L["Boat to Theramore"]), note=L["Dudswallow Marsh"], faction="Alliance" },
		[04415718] = { boat=true, label=format(L["Boat to Howling Fjord"]), note=L["Valgarde"], faction="Alliance" },
	},
	[mapFile(13)] = { -- Kalimdor
		[59276854] = { boat=true, label=format(L["Boat to Menethil Harbor"]), faction="Alliance" },
		[56835629] = { boat=true, label=format(L["Boat to Booty Bay"]) },
		[43181817] = { boat=true, label=format(L[" Boat to Stormwind \n Boat to Exodar"]), faction="Alliance" },
		[39551281] = { portal=true, label=format(L[" Portal to Hellfire Peninsula \n Portal ro Exodar"]), faction="Alliance" },
		[29992737] = { portal=true, label=format(L[" Portal to Hellfire Peninsula \n Portal ro Darnassus"]), faction="Alliance" },
		[29312826] = { boat=true, label=format(L["Boat to Darnassus"]) },
--		[] = { portal=true, label=format(L[" Portal to Blasted Lands \n Portal to Hellfire Peninsula"]), faction="Horde" },
--		[] = { zeplin=true, label=format(L["Zeplin to Ogrimmar"]), note=L["Durotar"], faction="Horde" },
--		[] = { zeplin=true, label=format(L["Ogrimmar Zeplins"]), note=L[" Zeplin to Thunder Bluff \n Zeplin to Undercity \n Zeplin to Grom'gol \n Zeplin to Borean Tundra"], faction="Horde" },

		},
	[mapFile(606)] = { -- Mount Hyjal
		[62522429] = { portal=true, label=format(L["Portal to Stormwind"]), faction="Alliance" },
	},
	[mapFile(640)] = { -- Deepholm
		[49485184] = { portal=true, label=format(L["Portal to Stormwind"]), faction="Alliance" },
	},
	[mapFile(709)] = { -- Tol Barad Peninsula
		[75255887] = { portal=true, label=format(L["Portal to Stormwind"]), faction="Alliance" },
	},
	[mapFile(11)] = { -- Northern Barrens
		[70307341] = { boat=true, label=format(L["Boat to Booty Bay"]) },
	},
	[mapFile(673)] = { -- Cape of Stranglethorn
		[38546670] = { boat=true, label=format(L["Boat to Ratchet"]) },
	},
	[mapFile(14)] = { -- Eastern Kingdom
		[41107209] = { boat=true, label=format(L["Stormwind Dock"]), note=L[" Boat to Darnassus \n Boat to Borean Tundra"], faction="Alliance" },
		[46885813] = { portal=true, label=format(L["Portal to Hellfire Peninsula"]), faction="Alliance" },
		[45995488] = { boat=true, label=format(L["Menethil Harbor"]), note=L[" Boat to Theramore \n Boat to Howling Fjord"], faction="Alliance" },
		[42999362] = { boat=true, label=format(L["Boat to Ratchet"]) },
--		[] = { zeplin=true, label=format(L["Grom'gol Base Camp"]), note=L[" Zeplin to Ogrimmar \n Zeplin to Undercity"], faction="Horde" },
--		[] = { zeplin=true, label=format(L["Trisfal Glades"]), note=L[" Zeplin to Ogrimmar \n Zeplin to Grom'gol Base Camp"], faction="Horde" },
	},
	[mapFile(465)] = { -- Hellfire Peninsula
		[89225101] = { portal=true, label=format(L["Portal to Stormwind"]), faction="Alliance" },
		[89234946] = { portal=true, label=format(L["Portal to  Ogrimmar"]), faction="Horde" },
	},
	[mapFile(481)] = { -- Shattrath
		[57224827] = { portal=true, label=format(L["Portal to Stormwind"]), faction="Alliance" },
		[48594200] = { portal=true, label=format(L["Portal to Isle of Quel'Danas"]) },
		[56834888] = { portal=true, label=format(L["Portal to  Ogrimmar"]), faction="Horde" },
	},
	[mapFile(466)] = { -- Outland
		[43886598] = { portal=true, label=format(L[" Portal to Stormwind \n Portal to Isle of Quel'Danas"]), faction="Alliance" },
		[43886599] = { portal=true, label=format(L[" Portal to Ogrimmar \n Portal to Isle of Quel'Danas"]), faction="Horde" },
		[69025230] = { portal=true, label=format(L["Portal to Stormwind"]), faction="Alliance" },
		[69025231] = { portal=true, label=format(L["Portal to Ogrimmar"]), faction="Horde" },
	},
	[mapFile(341)] = { -- Ironforge
		[27260699] = { portal=true, label=format(L["Portal to Hellfire Peninsula"]), faction="Alliance" },
		[48948733] = { portal=true, label=format(L["Portal to Blasted Lands"]), faction="Alliance" },
	},
	[mapFile(141)] = { -- Dudswallow Marsh
		[71625648] = { boat=true, label=format(L["Boat to Menethil Harbor"]), note=L["Wetlands"], faction="Alliance" },
	},
	[mapFile(381)] = { -- Darnassus
		[43997817] = { portal=true, label=format(L["Portal to Hellfire Peninsula"]), faction="Alliance" },
		[44247867] = { portal=true, label=format(L["Portal to Exodar"]), faction="Alliance" },
	},
	[mapFile(41)] = { -- Teldrassil
		[29085646] = { portal=true, label=format(L[" Portal to Hellfire Peninsula \n Portal to Exodar"]), faction="Alliance" },
		[54939412] = { boat=true, label=format(L["Boat to Stormwind"]), faction="Alliance" },
		[52048951] = { boat=true, label=format(L["Boat to Exodar"]), faction="Alliance" },
	},
	[mapFile(471)] = { -- Exodar
		[48156305] = { portal=true, label=format(L["Portal to Hellfire Peninsula"]), faction="Alliance" },
		[47616214] = { portal=true, label=format(L["Portal to Darnassus"]), faction="Alliance" },
	},
	[mapFile(464)] = { -- Azuremyst Isle
		[20125424] = { boat=true, label=format(L["Boat to Darnassus"]), faction="Alliance" },
	},
	[mapFile(504)] = { -- Dalaran Northrend
		[40086282] = { portal=true, level=1, label=format(L["Portal to Stormwind"]), faction="Alliance" },
--		[] = { portal=true, level=1, label=format(L["Portal to Ogrimmar"]), faction="Horde" },
	},
	[mapFile(510)] = { -- Crystalsong Forest
		[26194278] = { portal=true, label=format(L["Portal to Stormwind"]), faction="Alliance" },
		[33463169] = { portal=true, label=format(L["Portal to Ogrimmar"]), faction="Horde" },
	},
	[mapFile(485)] = { -- Northrend
		[47874119] = { portal=true, label=format(L["Portal to Stormwind"]), faction="Alliance" },
		[47894119] = { portal=true, label=format(L["Portal to Ogrimmar"]), faction="Horde" },
		[80748454] = { boat=true, label=format(L["Boat to Menethil Harbor"]), faction="Alliance" },
		[23117069] = { boat=true, label=format(L["Boat to Stormwind"]), faction="Alliance" },
		[46596733] = { boat=true, label=format(L[" Boat to Unu'Pe \n Boat to Kamagua"]) },
		[29306561] = { boat=true, label=format(L["Boat to Mpa'Ki Harbor"]) },
		[67738283] = { boat=true, label=format(L["Boat to Mpa'Ki Harbor"]) },
--		[] = { zeplin=true, label=format(L["Zeplin to Ogrimmar"]), note=L["Durotar"], faction="Horde" },
--		[] = { zeplin=true, label=format(L["Zeplin to Undercity"]), note=L["Trisfal Glades"], faction="Horde" },
	},
	[mapFile(488)] = { -- Dragonblight
		[47797887] = { boat=true, label=format(L["Boat to Unu'Pe"]) },
		[49847853] = { boat=true, label=format(L["Boat to Kamagua"]) },
	},
	[mapFile(486)] = { -- Borean Tundra
		[79015383] = { boat=true, label=format(L["Boat to Mpa'Ki"]) },
		[59946947] = { boat=true, label=format(L["Boat to Stormwind"]), faction="Alliance" },
--		[] = { zeplin=true, label=format(L["Zeplin to Ogrimmar"]), note=L["Durotar"], faction="Horde" },
	},
	[mapFile(491)] = { -- Howling Fjord
		[23295769] = { boat=true, label=format(L["Boat to Mpa'Ki"]) },
		[61506270] = { boat=true, label=format(L["Boat to Menethil Harbor"]), faction="Alliance" },
--		[] = { zeplin=true, label=format(L["Zeplin to Undercity"]), note=L["Trisfal Glades"], faction="Horde" },
	},
	[mapFile(811)] = { -- Vale of Eternal Blossoms
		[87276493] = { portal=true, label=format(L[" Portal to Stormwind \n Portal to Ironforge \n Portal to Darnasuss \n Portal to Exodar \n Portal to Shattrath \n Portal to Dalaran-Northrend"]), faction="Alliance" },
--		[] = { portal=true, label=format(L[" Portal to Ogrimmar \n Portal to Thunder Bluff \n Portal to Undercity \n Portal to Silvermoon \n Portal to Shattrath \n Portal to Dalaran-Northrend"]), faction="Horde" },
	},
	[mapFile(862)] = { -- Pandaria
		[54465630] = { portal=true, label=format(L[" Portal to Stormwind \n Portal to Ironforge \n Portal to Darnasuss \n Portal to Exodar \n Portal to Shattrath \n Portal to Dalaran-Northrend"]), faction="Alliance" },
		[29494649] = { portal=true, label=format(L["Portal to Isle of Thunder"]) },
--		[] = { portal=true, label=format(L[" Portal to Ogrimmar \n Portal to Thunder Bluff \n Portal to Undercity \n Portal to Silvermoon \n Portal to Shattrath \n Portal to Dalaran-Northrend"]), faction="Horde" },
	},
	[mapFile(810)] = { -- Townlong Steppes
		[49706870] = { portal=true, label=format(L["Portal to Isle of Thunder"]), faction="Alliance"},
		[50607340] = { portal=true, label=format(L["Portal to Isle of Thunder"]), faction="Horde"},
	},
	[mapFile(928)] = { -- Isle of Thunder
		[64707348] = { portal=true, label=format(L["Portal to Shado-Pan Garrison"]), faction="Alliance"},
	},
}
