-- $Id: DB.lua 64 2017-06-11 14:28:30Z arith $
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
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)
local faction = UnitFactionGroup("player")

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
			note=[string],			-- additional notes for this node
		},
	},
	--]]
	["Acherus"] = { -- Death Knight
		[50225054] = { mission=true, dungeonLevel=2, label=ADVENTURE_MAP_TITLE, note=ORDER_HALL_MISSIONS },
		[41057399] = { recruiter=true, dungeonLevel=2, label=L["Dark Summoner Marogh <Risen Horde Recruiter>"], npc=106435, note=CAPACITANCE_START_RECRUITMENT },
		[53376858] = { recruiter=true, dungeonLevel=1, label=L["Korgaz Deadaxe <Ebon Soldier Recruiter>"], npc=106436, note=CAPACITANCE_START_RECRUITMENT },
		[22003200] = { recruiter=true, dungeonLevel=2, label=L["Eran Droll <Ebon Knight Frostreavers Recruiter>"], npc=120135, note=L["Requires Frost and Death order advancement"] },
		[25382043] = { recruiter=true, dungeonLevel=2, label=L["Winter Payne"], npc=111634, note=L["Frost Crux"].."\n"..L["Requires Frost Wyrm work order advancement"] },
		[49785586] = { research=true, dungeonLevel=2, label=L["Illanna Dreadmoore <Ebon Blade Archivist>"], npc=97111, note=L["Artifact Research"] },
		[51793238] = { armaments=true, dungeonLevel=1, label=L["Dead Collector Bane <Champion Armaments>"], npc=110410, note=L["Champion Armaments"] },
		[61116036] = { artifact=true, dungeonLevel=1, label=L["Soul Forge"], class="DEATHKNIGHT", note=ARTIFACT_POWER },
		[43923760] = { quartermaster=true, dungeonLevel=1, label=L["Quartermaster Ozorg <Rare Goods Vendor>"], npc=93550, note=L["Class Hall Quartermaster"] },
		[47775389] = { classUpgrade=true, dungeonLevel=2, label=L["Archivist Zubashi <Class Hall Upgrades>"], npc=97485, note=ORDER_HALL_TALENT_TITLE  },
		[34473669] = { portal=true, dungeonLevel=2, label=L["Portal to another floor"],  },
		[24803369] = { portal=true, dungeonLevel=2, label=format(L["Portal to %s"], BZ["Dalaran"]),  },
		[33333528] = { portal=true, dungeonLevel=1, label=L["Portal to another floor"],  },
		[49705126] = { others=true, dungeonLevel=2, label=L["Siouxsie the Banshee <Mission Specialist>"], npc=93568 },
		[50925065] = { others=true, dungeonLevel=2, label=L["Highlord Darion Mograine"], npc=93437 },
		[63206960] = { others=true, dungeonLevel=2, label=L["Lord Thorval"], npc=93491 },
		[58193105] = { others=true, dungeonLevel=2, label=L["Amal'thazad"], npc=93555 },
		[25532885] = { others=true, dungeonLevel=2, label=MINIMAP_TRACKING_FLIGHTMASTER, type="flight" },
		[59896068] = { others=true, dungeonLevel=1, label=L["Grand Master Siegesmith Corvus"], npc=97072 },
		[61004836] = { others=true, dungeonLevel=1, label=L["Lady Alistra <Death Knight Trainer>"], npc=93509 },
		[54287469] = { lightsHeart=true, dungeonLevel=1, label=L["Light's Heart"], },
		[36255607] = { others=true, dungeonLevel=1, label=L["Salanar the Horseman"], npc=111480 },
	},
	["DemonHunterOrderHallTerrain"] = { -- Demon Hunter
		[58935364] = { mission=true, dungeonLevel=2, label=ADVENTURE_MAP_TITLE, note=ORDER_HALL_MISSIONS },
		[56285416] = { recruiter=true, dungeonLevel=2, label=L["Battlelord Gaardoun <Ashtongue Captain>"], npc=103025, note=CAPACITANCE_START_RECRUITMENT },
		[58623885] = { recruiter=true, dungeonLevel=2, label=L["Ariana Fireheart <Illidari>"], npc=103760, note=CAPACITANCE_START_RECRUITMENT },
		[56207480] = { recruiter=true, dungeonLevel=2, label=L["Tormented Shivarra <Shivarra Recruiter>"], npc=120140, note=CAPACITANCE_START_RECRUITMENT.."\n"..L["Requires Blades of Death order advancement"] },
		[58236907] = { recruiter=true, dungeonLevel=2, label=L["Evelune Soulreaver <Wrath of the Order>"], npc=111775, note=L["Empowered Rift Core"].."\n"..L["Requires Fel Hammer's Wrath order advancement"] },
		[54315981] = { sealOrder=true, dungeonLevel=3, label=L["Seer Aleis <Seal of Broken Fate Shipment>"], npc=112992, note=L["Seal of Broken Fate"].."\n"..L["Requires Focused War Effort order advancement"] },
		[62007501] = { research=true, dungeonLevel=3, label=L["Vahu the Weathered <Illidari Researcher>"], npc=111736, note=L["Artifact Research"] },
		[60044331] = { armaments=true, dungeonLevel=2, label=L["Slitesh <Armaments Requisitioner>"], npc=110433, note=L["Champion Armaments"] },
		[58442679] = { artifact=true, dungeonLevel=3, label=L["Cursed Forge of the Nathrezim"], class="DEMONHUNTER", note=ARTIFACT_POWER },
		[57804351] = { quartermaster=true, dungeonLevel=2, label=L["Falara Nightsong <Illidari Provisioner>"], npc=112407, note=L["Class Hall Quartermaster"] },
		[54976271] = { classUpgrade=true, dungeonLevel=3, label=L["Loramus Thalipedes <Class Hall Upgrades>"], npc=108527, note=ORDER_HALL_TALENT_TITLE  },
		[59379144] = { portal=true, dungeonLevel=2, label=L["Illidari Gateway"], },
		[58411659] = { portal=true, dungeonLevel=2, label=L["Illidari Gateway"], },
		[58575789] = { others=true, dungeonLevel=2, label=L["Kayn Sunfury <Illidari>"], npc=108572 },
		[59325767] = { others=true, dungeonLevel=2, label=L["Kor'vas Bloodthorn <Illidari>"], npc=108250 },
		[57605231] = { others=true, dungeonLevel=2, label=L["Belath Dawnblade <Illidari>"], npc=108782 },
		[60024878] = { others=true, dungeonLevel=2, label=L["Matron Mother Malevolence <Shivarra Captain>"], npc=98632 },
		[58684311] = { lightsHeart=true, dungeonLevel=2, label=L["Light's Heart"], },
		[60883864] = { others=true, dungeonLevel=2, label=L["Izal Whitemoon <Illidari Trainer>"], npc=109965 },
		[56223899] = { others=true, dungeonLevel=2, label=L["Asha Ravensong <Illidari>"], npc=108326 },
		[56692929] = { others=true, dungeonLevel=3, label=L["Seer Akalu <Nathrezim Scholar>"], npc=109596 },
		[58715371] = { others=true, dungeonLevel=3, label=L["Empowered Nether Crucible"] },
		[59057512] = { others=true, dungeonLevel=3, label=L["Jace Darkweaver <Illidari>"], npc=98646 },
	},
	["TheDreamgrove"] = { -- Druid
		[52415079] = { mission=true, label=ADVENTURE_MAP_TITLE, note=ORDER_HALL_MISSIONS },
		[38483422] = { recruiter=true, label=L["Yaris Darkclaw <Recruiter>"], npc=106442, note=CAPACITANCE_START_RECRUITMENT },
		[36332544] = { recruiter=true, label=L["Sister Lilith <Recruiter>"], npc=108393, note=CAPACITANCE_START_RECRUITMENT },
		[43256329] = { recruiter=true, label=L["Treant Sapling <Ancient of War Tender>"], npc= 111786, note=CAPACITANCE_START_RECRUITMENT.."\n"..L["Requires Ancient of War order advancement"] },
		[29944293] = { recruiter=true, label=L["Shalorn Star <Dreamgrove Warden Recruiter>"], npc=108391, note=L["Requires Wardens of the Grove order advancement"] },
		-- sealOrder TBD
		[33883255] = { research=true, label=L["Celadine the Fatekeeper <Dreamgrove Researcher>"], npc=111737, note=L["Artifact Research"] },
		[30525359] = { artifact=true, label=L["Seed of Ages"], class="DRUID", note=ARTIFACT_POWER },
		[32782925] = { classUpgrade=true, label=L["Leafbeard the Storied <Ancient of Lore>"], npc=97989, note=ORDER_HALL_TALENT_TITLE  },
		[40031778] = { quartermaster=true, label=L["Amurra Thistledew <Proprietor>"], npc=112323, note=L["Class Hall Quartermaster"] },
		[55562222] = { portal=true, label=format(L["Portal to %s"], BZ["Emerald Dreamway"]), },
		[56564308] = { portal=true, label=format(L["Portal to %s"], BZ["Dalaran"]), },
		[52595141] = { others=true, label=L["Skylord Omnuron <Mission Specialist>"], npc=98002 },
		[52295276] = { others=true, label=L["Mylune"], npc=113525 },
		[59335318] = { others=true, label=L["Zen'kiki"], npc=104240 },
		[60165211] = { lightsHeart=true, label=L["Light's Heart"], },
		[44665195] = { others=true, label=L["Rensar Greathoof <Archdruid of the Grove>"], npc=101195 },
		[45205187] = { others=true, label=L["Lyessa Bloomwatcher <Guardian of G'Hanir>"], npc=104577 },
		[44595005] = { others=true, label=L["Keeper Remulos"], npc=103832 },
		[31715214] = { others=true, label=L["Tender Daranelle"], npc=109612 },
	},
	["TrueshotLodge"] = { -- Hunter
		[42484656] = { mission=true, label=ADVENTURE_MAP_TITLE, note=ORDER_HALL_MISSIONS },
		[42883776] = { recruiter=true, label=L["Lenara <Recruiter>"], npc=106444, note=CAPACITANCE_START_RECRUITMENT },
		[57733260] = { recruiter=true, label=L["Sampson <Recruiter>"], npc=106446, note=CAPACITANCE_START_RECRUITMENT },
		[51003160] = { recruiter=true, label=L["Nighthuntress Silus <Nightborne Hunters Recruiter>"], npc=106445, note=L["Requires Born of the Night order advancement"] },
		[43234858] = { sealOrder=true, label=L["Tu'Las the Gifted <Seal of Broken Fate Shipment>"], npc=110816, note=L["Seal of Broken Fate"].."\n"..L["Requires Unseen Path order advancement"] },
		[52575434] = { research=true, label=L["Holt Thunderhorn <Lore and Legends>"], npc=98737, note=L["Artifact Research"] },
		[58674880] = { armaments=true, label=L["Berger the Steadfast <Champion Armaments>"], npc=110412, note=L["Champion Armaments"] },
		[58635110] = { classUpgrade=true, label=L["Survivalist Bahn <Class Hall Upgrades>"], npc=108050, note=ORDER_HALL_TALENT_TITLE  },
		[44574885] = { quartermaster=true, label=L["Outfitter Reynolds <Unseen Path>"], npc=103693, note=L["Class Hall Quartermaster"] },
		[47455351] = { artifact=true, label=L["Altar of the Eternal Hunt"], class="HUNTER", note=ARTIFACT_POWER },
		[48614331] = { portal=true, label=format(L["Portal to %s"], BZ["Dalaran"]),  },
		[43422631] = { others=true, label=L["Emmarel Shadewarden <Unseen Path>"], npc=107973 },
		[58773179] = { others=true, label=L["Pan the Kind Hand <Stable Master>"], npc=100661, type="stableMaster" },
		[47255388] = { others=true, label=L["Altar Keeper Biehn"], npc=102940 },
		[42794697] = { others=true, label=L["Tactician Tinderfell <Unseen Path>"], npc=103023 },
		[44454495] = { others=true, label=L["Image of Mimiron"], npc=110424 },
		[40022846] = { others=true, flight=true, label=L["Great Eagle"], npc=109572, class="HUNTER" },
		[47394343] = { lightsHeart=true, label=L["Light's Heart"], },
	},
	["MageClassShrine"] = { -- Mage
		[81346105] = { mission=true, dungeonLevel=1, label=ADVENTURE_MAP_TITLE, note=ORDER_HALL_MISSIONS },
		[87904753] = { recruiter=true, dungeonLevel=1, label=L["Archmage Omniara <Recruiter>"], npc=106377, note=CAPACITANCE_START_RECRUITMENT },
		[47743202] = { recruiter=true, dungeonLevel=1, label=L["Grand Conjurer Mimic <Mage Recruiter Extraordinaire>"], npc=106433, note=CAPACITANCE_START_RECRUITMENT },
		[81342831] = { recruiter=true, dungeonLevel=1, label=L["Guardian Alar <Kirin Tor Guardians Recruiter>"], npc=106434, note=CAPACITANCE_START_RECRUITMENT.."\n"..L["Requires Guardians of the Kirin Tor order advancement"] },
		[78065295] = { recruiter=true, dungeonLevel=1, label=L["Conjurer Awlyn"], npc=111734, note=L["Focusing Crystal"].."\n"..L["Requires Might of Dalaran order advancement"] },
		-- sealOrder TBD
		[64615027] = { research=true, dungeonLevel=2, label=L["Edirah <Tirisgarde Researcher>"], npc=110624, note=L["Artifact Research"] },
		[82875672] = { armaments=true, dungeonLevel=1, label=L["Minuette <Armament Summoner>"], npc=110427, note=L["Champion Armaments"] },
		[74912892] = { classUpgrade=true, dungeonLevel=1, label=L["Chronicler Elrianne <Class Hall Upgrades>"], npc=108331, note=ORDER_HALL_TALENT_TITLE  },
		[59824246] = { artifact=true, dungeonLevel=2, label=L["Forge of the Guardian"], class="MAGE", note=ARTIFACT_POWER },
		[44685796] = { quartermaster=true, dungeonLevel=2, label=L["Jackson Watkins <Tirisgarde Quartermaster>"], npc=112440, note=L["Class Hall Quartermaster"] },
		[80956300] = { others=true, dungeonLevel=1, label=L["Archmage Melis <Mistress of Flame>"], npc=108515 },
		[84073260] = { lightsHeart=true, dungeonLevel=1, label=L["Light's Heart"], },
		[37114833] = { others=true, dungeonLevel=1, label=L["Ari"], npc=109307 },
		[63463743] = { others=true, dungeonLevel=2, label=L["Magister Varenthas <High Forgeguard>"], npc=109642 },
		[57289046] = { portal=true, dungeonLevel=1, label=format(L["Portal to %s"], BZ["Dalaran"]),  },
		[67154168] = { portal=true, dungeonLevel=1, label=L["Teleportation Nexus"], note=format(L["Portal to %s"], BZ["Stormheim"]),  },
		[66704673] = { portal=true, dungeonLevel=1, label=L["Teleportation Nexus"], note=format(L["Portal to %s"], BZ["Val'sharah"]),  },
		[55023947] = { portal=true, dungeonLevel=1, label=L["Teleportation Nexus"], note=format(L["Portal to %s"], BZ["Azsuna"]),  },
		[54604451] = { portal=true, dungeonLevel=1, label=L["Teleportation Nexus"], note=format(L["Portal to %s"], BZ["Highmountain"]),  },
		[60285200] = { portal=true, dungeonLevel=1, label=L["Teleportation Nexus"], note=format(L["Portal to %s"], BZ["Suramar"]),  },
	},
	["MonkOrderHallTheWanderingIsle"] = { -- Monk
		[52966022] = { mission=true, label=ADVENTURE_MAP_TITLE, note=ORDER_HALL_MISSIONS },
		[54445714] = { recruiter=true, label=L["Gin Lai <Tiger Troop Trainer>"], npc=105019, note=CAPACITANCE_START_RECRUITMENT },
		[53335975] = { recruiter=true, label=L["Tianji <Ox Troop Trainer>"], npc=105015, note=CAPACITANCE_START_RECRUITMENT },
		[54405880] = { recruiter=true, label=L["Tianili <Celestial Trainer>"], npc=106538, note=CAPACITANCE_START_RECRUITMENT .."\n"..L["Requires Celestial Favor order advancement"] },
		[51805560] = { recruiter=true, label=L["Master Swoo <Masters of Serenity Recruiter>"], npc=120145, note=L["Requires Masters of the Path order advancement"] },
		-- sealOrder TBD
		[46704669] = { research=true, label=L["Lorewalker Cho <Head Archivist>"], npc=106942, note=L["Artifact Research"] },
		[51464800] = { artifact=true, label=L["Forge of the Roaring Mountain"], class="MONK", note=ARTIFACT_POWER },
		[53045977] = { classUpgrade=true, label=L["Number Nine Jia <Class Hall Upgrades>"], npc=98939, note=ORDER_HALL_TALENT_TITLE  },
		[50335914] = { quartermaster=true, label=L["Caydori Brightstar <Purveyor of Rare Goods>"], npc=112338, note=L["Class Hall Quartermaster"] },
		[50045440] = { portal=true, label=format(L["Portal to %s"], BZ["Peak of Serenity"]),  },
		[52395712] = { portal=true, label=format(L["Portal to %s"], BZ["Dalaran"]),  },
		[51394838] = { others=true, label=L["Iron-Body Ponshu <Senior Master Ox>"] },
		[51764811] = { lightsHeart=true, label=L["Light's Heart"], },
		[52765975] = { others=true, label=L["Master Hsu <Mission Master>"], npc=99179 },
		[52545781] = { others=true, label=L["High Elder Cloudfall"], npc=104744 },
		[54795663] = { others=true, label=L["Elder Xang <Monk Trainer>"], npc=101749 },
	},
	["PaladinClassShrine"] = { -- Paladin
		[53427865] = { mission=true, dungeonLevel=20, label=ADVENTURE_MAP_TITLE, note=ORDER_HALL_MISSIONS },
		[53295617] = { recruiter=true, dungeonLevel=20, label=L["Commander Ansela <Silver Hand Recruiter>"], npc=106447, note=CAPACITANCE_START_RECRUITMENT },
		[58893898] = { recruiter=true, dungeonLevel=20, label=L["Commander Born <Silver Hand Officer Recruiter>"], npc=106448, note=CAPACITANCE_START_RECRUITMENT },
		[75103456] = { recruiter=true, dungeonLevel=20, label=L["Terric the Illuminator"], npc=111772, note=L["Silver Hand Orders"].."\n"..L["Requires Grand Crusade order advancement"] },
		[62914473] = { recruiter=true, dungeonLevel=20, label=L["Crusader Kern <Silver Hand Crusader Recruiter>"], npc=120146, note=L["Requires Silver Hand Crusaders order advancement"] },
		[49127655] = { sealOrder=true, dungeonLevel=20, label=L["Librarian Lightmorne <Seal of Broken Fate Shipment>"], npc=112986, note=L["Seal of Broken Fate"].."\n"..L["Requires Holy Purpose order advancement"] },
		[37775731] = { research=true, dungeonLevel=20, label=L["Sister Elda <Keeper of the Ancient Tomes>"], npc=91190, note=L["Artifact Research"] },
		[54044961] = { armaments=true, dungeonLevel=20, label=L["Kristoff <Armaments Requisitioner>"], npc=110434, note=L["Champion Armaments"] },
		[39895652] = { classUpgrade=true, dungeonLevel=20, label=L["Sir Alamande Graythorn <Class Hall Upgrades>"], npc=109901, note=ORDER_HALL_TALENT_TITLE  },
		[41366115] = { quartermaster=true, dungeonLevel=20, label=L["Eadric the Pure <Quartermaster>"], npc=100196, note=L["Class Hall Quartermaster"] },
		[72752391] = { artifact=true, dungeonLevel=20, label=L["Altar of Ancient Kings"], class="PALADIN", note=ARTIFACT_POWER },
		[37666405] = { portal=true, dungeonLevel=20, label=format(L["Portal to %s"], BZ["Dalaran"]),  },
		[52476919] = { lightsHeart=true, dungeonLevel=20, label=L["Light's Heart"], },
		[52297812] = { others=true, dungeonLevel=20, label=L["Lord Grayson Shadowbreaker <Mission Specialist>"], npc=90250 },
		[70992844] = { others=true, dungeonLevel=20, label=L["Valgar Highforge <Grand Smith of the Order>"], npc=90261 },
		[39197445] = { others=true, dungeonLevel=20, label=L["Charger Saddle"], object=252389 },
	},
	["NetherlightTemple"] = { -- Priest, Netherlight Temple
		[49704720] = { mission=true, dungeonLevel=1, label=L["Command Map"], note=ORDER_HALL_MISSIONS },
		[40882759] = { recruiter=true, dungeonLevel=1, label=L["Grand Anchorite Gesslar <Recruiter>"], npc=106450, note=CAPACITANCE_START_RECRUITMENT },
		[40865394] = { recruiter=true, dungeonLevel=1, label=L["Vicar Eliza <Recruiter>"], npc=106451, note=CAPACITANCE_START_RECRUITMENT },
		[57365501] = { recruiter=true, dungeonLevel=1, label=L["High Priestess Mourn <Recruiter>"], npc=120160, note=CAPACITANCE_START_RECRUITMENT.."\n"..L["Requires Hooded Priests order advancement"] },
		[59402917] = { sealOrder=true, dungeonLevel=1, label=L["Truth <Seal of Broken Fate Shipment>"], npc=110819, note=L["Seal of Broken Fate"].."\n"..L["Requires Blessed Seals order advancement"] },
		[59852805] = { research=true, dungeonLevel=1, label=L["Juvess the Duskwhisperer <Keeper of Scrolls>"], npc=111738, note=L["Artifact Research"] },
		[45492658] = { armaments=true, dungeonLevel=1, label=L["Lilith <Armament Supplier>"], npc=110595, note=L["Champion Armaments"] },
		[56014078] = { classUpgrade=true, dungeonLevel=1, label=L["Archon Torias <Class Hall Upgrades>"], npc=110725, note=ORDER_HALL_TALENT_TITLE  },
		[49792262] = { artifact=true, dungeonLevel=1, label=L["Altar of Light and Shadow"], class="PRIEST", note=ARTIFACT_POWER },
		[38632384] = { quartermaster=true, dungeonLevel=1, label=L["Meridelle Lightspark <Logistics>"], npc=112401, note=L["Class Hall Quartermaster"] },
		[49758061] = { portal=true, dungeonLevel=1, label=format(L["Portal to %s"], BZ["Dalaran"]),  },
		[49792612] = { lightsHeart=true, dungeonLevel=1, label=L["Light's Heart"], npc=113857, },
		[48792296] = { others=true, dungeonLevel=1, label=L["Betild Deepanvil <Master Artificer>"], npc=102709 },
		[39485327] = { others=true, dungeonLevel=1, label=L["Dark Cleric Cecille <Priest Trainer>"], npc=112576 },
		[51574782] = { others=true, dungeonLevel=1, label=L["Alonsus Faol <Bishop of Secrets>"], npc=110564 },
		[75944029] = { others=true, dungeonLevel=1, label=L["Light Well"], object=252162 },
		[23234030] = { others=true, dungeonLevel=1, label=L["Shadow Well"], object=252160 },
	},
	["Dalaran70"] = { -- Rogue and Dalaran for other classes
		[36644514] = { mission=true, dungeonLevel=4, label=ADVENTURE_MAP_TITLE, note=ORDER_HALL_MISSIONS },
		[31882674] = { recruiter=true, dungeonLevel=4, label=L["Lonika Stillblade <Rogue Academy Proprietor>"], npc=105979, note=CAPACITANCE_START_RECRUITMENT },
		[48174120] = { recruiter=true, dungeonLevel=4, label=L["Yancey Grillsen <Bloodsail Recruiter>"], npc=106083, note=CAPACITANCE_START_RECRUITMENT },
		[45897777] = { recruiter=true, dungeonLevel=4, label=L["Laura Stern <Recruiter>"], npc=120162, note=CAPACITANCE_START_RECRUITMENT.."\n"..L["Requires Ravenholdt's Finest order advancement"] },
		[61355108] = { sealOrder=true, dungeonLevel=4, label=L["Scythe <Seal of Broken Fate Shipment>"], npc=110820, note=L["Seal of Broken Fate"].."\n"..L["Requires Plunder order advancement"] },
		[37937007] = { research=true, dungeonLevel=4, label=L["Filius Sparkstache <Archivist>"], npc=102641, note=L["Artifact Research"] },
		[26903685] = { quartermaster=true, dungeonLevel=4, label=L["Kelsey Steelspark <Quartermaster>"], npc=105986, note=L["Class Hall Quartermaster"] },
		[26956177] = { artifact=true, dungeonLevel=4, label=L["Crucible of the Uncrowned"], class="ROGUE", note=ARTIFACT_POWER },
		[45966931] = { classUpgrade=true, dungeonLevel=4, label=L["Winstone Wolfe <The Wolf>"], npc=105998, note=ORDER_HALL_TALENT_TITLE  },
		[37784488] = { others=true, dungeonLevel=4, label=L["Nikki the Gossip <Tales fo Adventure and Profit>"], npc=98092 },
		[36824336] = { others=true, dungeonLevel=4, label=L["Vanessa VanCleef"], npc=102550 },
		[40785458] = { lightsHeart=true, dungeonLevel=4, label=L["Light's Heart"], },
		[30115537] = { others=true, dungeonLevel=4, label=L["Lorena Belle <Master Smuggler>"], npc=109609 },
		[30667027] = { others=true, dungeonLevel=4, label=L["Marin Noggenfogger <Baron of Gadgetzan>"], npc=102591 },
		[41417816] = { others=true, dungeonLevel=4, label=L["Lord Jorach Ravenholdt"], npc=101513 },
		[40737537] = { others=true, dungeonLevel=4, label=L["Valeera Sanguinar"], npc=98102 },
		[29582187] = { portal=true, dungeonLevel=4, label=format(L["Knocker - %s"], BZ["Tanks for Everything"]), class="ROGUE" },
		[46642578] = { portal=true, dungeonLevel=10, label=format(L["Knocker - %s"], BZ["Tanks for Everything"]), class="ROGUE" },
		[78918261] = { portal=true, dungeonLevel=4, label=format(L["Knocker - %s"], BZ["Glorious Goods"]), class="ROGUE" },
		[53057004] = { portal=true, dungeonLevel=10, label=format(L["Knocker - %s"], BZ["Glorious Goods"]), class="ROGUE" },
		[39672151] = { portal=true, dungeonLevel=4, label=format(L["Knocker - %s"], BZ["One More Glass"]), class="ROGUE" },
		[54293277] = { portal=true, dungeonLevel=10, label=format(L["Knocker - %s"], BZ["One More Glass"]), class="ROGUE" },
	-- ground floor for other class
		[75254723] = { portal=true, dungeonLevel=10, spell=192085, class="WARRIOR" },
		[72934115] = { flight=true, dungeonLevel=10, label=L["Great Eagle"], npc=109572, class="HUNTER" },
	},
	["MaelstromShaman"] = { -- Shaman
		[33645923] = { mission=true, label=ADVENTURE_MAP_TITLE, note=ORDER_HALL_MISSIONS },
		[30545877] = { recruiter=true, label=L["Summoner Morn <Elemental Summoner>"], npc=106457, note=CAPACITANCE_START_RECRUITMENT },
		[29254276] = { recruiter=true, label=L["Felinda Frye <Earthwarden Recruiter>"], npc=112208, note=CAPACITANCE_START_RECRUITMENT },
		[34003480] = { recruiter=true, label=L["Marick Ven <Earthen Ring Protectors Recruiter>"], npc=120165, note=CAPACITANCE_START_RECRUITMENT.."\n"..L["Requires Ring of Earth order advancement"] },
		[31935148] = { recruiter=true, label=L["Alexor <The Ascended>"], npc=109829, note=CAPACITANCE_START_RECRUITMENT.."\n"..L["Requires \"Rise!\" order advancement"] },
		[31153510] = { sealOrder=true, label=L["Bath'rah the Windwatcher <Seal of Broken Fate Shipment>"], npc=112299, note=L["Seal of Broken Fate"].."\n"..L["Requires Spirit Walk order advancement"] },
		[32564961] = { research=true, label=L["Gorma Windspeaker <Keeper of Legends>"], npc=111739, note=L["Artifact Research"] },
		[33385820] = { classUpgrade=true, label=L["Journeyman Goldmine <Class Hall Upgrades>"], npc=112199, note=ORDER_HALL_TALENT_TITLE  },
		[37184577] = { artifact=true, label=L["Ancient Elemental Altar"], class="SHAMAN", note=ARTIFACT_POWER },
		[30326071] = { quartermaster=true, label=L["Flamesmith Lanying <Earthen Ring Quartermaster>"], npc=112318, note=L["Class Hall Quartermaster"] },
		[29805194] = { portal=true, label=format(L["Portal to %s"], BZ["Dalaran"]),  },
		[26704137] = { portal=true, label=format(L["Portal to %s"], BZ["Vortex Pinnacle"]),  },
		[36208008] = { others=true, label=L["Aggra <Shaman Trainer>"], npc=99531 },
		[29977744] = { others=true, label=L["Maelstrom Pillar"] },
		[29447788] = { others=true, label=L["Elementalist Janai <Earthen Ring>"], npc=109464 },
		[33056044] = { others=true, label=L["Advisor Sevel <The Earthen Ring>"], npc=96746 },
		[34654313] = { others=true, label=L["Gavan Grayfeather <Ears of the Maelstrom>"], npc=112262 },
		[31332964] = { others=true, label=L["Tribemother Torra <Shaman Trainer>"], npc=111922 },
		[25215023] = { others=true, label=L["Puzzlemaster Lo <The Earthen Ring>"], npc=103004 },
		[32493270] = { lightsHeart=true, label=L["Light's Heart"], },
	},
	["WarlockClassShrine"] = { -- Warlock
		[66724823] = { mission=true, label=L["Dreadscar Battle Plans"], note=ORDER_HALL_MISSIONS },
		[61515179] = { recruiter=true, label=L["Jared <Recruiter>"], npc=106217, note=CAPACITANCE_START_RECRUITMENT },
		[66703029] = { recruiter=true, label=L["Imp Mother Dyala <Recruiter>"], npc=106216, note=CAPACITANCE_START_RECRUITMENT },
		[53002240] = { recruiter=true, label=L["Galen Foul <Demon Summoner>"], npc=120166, note=CAPACITANCE_START_RECRUITMENT.."\n"..L["Requires Demonic Brutes order advancement"] },
		[49442491] = { recruiter=true, label=L["Demonia Pickerin"], npc=113371, note=L["Demonic Phylactery"].."\n"..L["Requires Demonia Pickerin order advancement"] },
		[57054108] = { research=true, label=L["Mile Raitheborne <Head Archivist>"], npc=111740, note=L["Artifact Research"] },
		[57325258] = { armaments=true, label=L["Murr"], npc=110408, note=L["Champion Armaments"] },
		[33792790] = { artifact=true, label=L["Felblood Altar"], class="WARLOCK", note=ARTIFACT_POWER },
		[75853708] = { portal=true, label=format(L["Portal to %s"], BZ["Dalaran"]),  },
		[55304105] = { classUpgrade=true, label=L["Archivist Melinda <Class Hall Upgrades>"], npc=108018, note=ORDER_HALL_TALENT_TITLE  },
		[58793268] = { quartermaster=true, label=L["Gigi Gigavoid <Black Harvest Quartermaster>"], npc=112434, note=L["Class Hall Quartermaster"] },
		[51972136] = { portal=true, label=L["Demonic Gateway"],  },
		[35773313] = { others=true, label=L["Unjari Feltongue <The Heartbearer>"], npc=109686 },
		[37703124] = { others=true, label=L["Calydus"], npc=101097 },
		[67024645] = { others=true, label=L["Gakin the Darkbinder <Mission Strategist>"], npc=106199 },
		[55253719] = { others=true, label=L["Ritssyn Flamescowl <Council of the Black Harvest>"], npc=105018 },
		[53123252] = { lightsHeart=true, label=L["Light's Heart"], },
	},
	["ValhallasWarriorOrderHome"] = { -- Warrior
		[59141200] = { mission=true, dungeonLevel=1, label=L["Eye of Odyn"], note=ORDER_HALL_MISSIONS },
		[62391499] = { recruiter=true, dungeonLevel=1, label=L["Captain Hjalmar Stahlstrom <Recruiter>"], npc=106459, note=CAPACITANCE_START_RECRUITMENT },
		[55681507] = { recruiter=true, dungeonLevel=1, label=L["Savyn Valorborn <Recruiter>"], npc=106460, note=CAPACITANCE_START_RECRUITMENT },
		[54771738] = { recruiter=true, dungeonLevel=1, label=(faction == "Alliance") and L["Matthew Glensorrow <Recruiter>"] or L["Sharak Tor <Recruiter>"], npc=(faction == "Alliance") and 120077 or 106461, note=L["Requires Strike Hard order advancement"] },
		[72773026] = { recruiter=true, dungeonLevel=1, label=L["Matilda Skoptidottir"], npc=111774, note=L["Horn of War"].."\n"..L["Requires Val'kyr Call order advancement"] },
		[45082826] = { research=true, dungeonLevel=1, label=L["Fjornson Stonecarver <Keeper of Legends>"], npc=111741, note=L["Artifact Research"] },
		[62322593] = { armaments=true, dungeonLevel=1, label=L["Haklang Ulfsson <Armaments Requisitioner>"], npc=110437, note=L["Champion Armaments"] },
		[46522887] = { classUpgrade=true, dungeonLevel=1, label=L["Einar the Runecaster <Class Hall Upgrades>"], npc=107994, note=ORDER_HALL_TALENT_TITLE  },
		[55972661] = { quartermaster=true, dungeonLevel=1, label=L["Quartermaster Durnolf"], npc=112392, note=L["Class Hall Quartermaster"] },
		[39423590] = { artifact=true, dungeonLevel=1, label=L["Forge of Odyn"], class="WARRIOR", note=ARTIFACT_POWER },
		[45343014] = { lightsHeart=true, dungeonLevel=1, label=L["Light's Heart"], npc=113857, },
		[40973722] = { others=true, dungeonLevel=1, label=L["Master Smith Helgar"], npc=96586, type="yellowButton" },
		[58332497] = { others=true, dungeonLevel=1, label=L["Aerylia <Stormflight Master>"], npc=96679, type="yellowButton" },
		[59851314] = { others=true, dungeonLevel=1, label=L["Skyseer Ghrent"], npc=100635 },
		[72953766] = { others=true, dungeonLevel=1, label=L["Weaponmaster Asvard <Warrior Trainer>"], npc=112577 },
		[58318561] = { others=true, dungeonLevel=1, label=L["Odyn"], npc=96469 },
		[55988437] = { others=true, dungeonLevel=1, label=L["Hymdall"], npc=107987 },
	},
	[mapFile(1021)] = { -- Broken Shore
		[44826132] = { portal=true, spell=192085, class="WARRIOR" },
	},
	[mapFile(1015)] = { -- Azsuna
		[47572808] = { portal=true, spell=192085, class="WARRIOR" },
		[57951515] = { portal=true, label=L["Teleportation Nexus"], note=format(L["Portal to %s"], BZ["Hall of the Guardian"]), class="MAGE" },
		[50967990] = { flight=true, label=L["Great Eagle"], npc=109572, class="HUNTER" },
		[24544312] = { flight=true, label=L["Great Eagle"], npc=109572, class="HUNTER" },
	},
	[mapFile(1018)] = { -- Val'sharah
		[54707490] = { portal=true, spell=192085, class="WARRIOR" },
		[51255610] = { portal=true, label=L["Teleportation Nexus"], note=format(L["Portal to %s"], BZ["Hall of the Guardian"]), class="MAGE" },
		[44321507] = { flight=true, label=L["Great Eagle"], npc=109572, class="HUNTER" },
		[41932172] = { portal=true, label=format(L["Portal to %s"], BZ["Emerald Dreamway"]), class="DRUID" }, -- The Dreamgrove
	},
	[mapFile(1080)] = { -- Thunder Totem
		[39794219] = { portal=true, spell=192085, class="WARRIOR" },
	},
	[mapFile(1024)] = { -- Highmountain
		[46115998] = { portal=true, spell=192085, class="WARRIOR" },
		[31416381] = { portal=true, label=L["Teleportation Nexus"], note=format(L["Portal to %s"], BZ["Hall of the Guardian"]), class="MAGE" },
		[56666776] = { flight=true, label=L["Great Eagle"], npc=109572, class="HUNTER" },
	},
	[mapFile(1017)] = { -- Stormheim
		[60175227] = { portal=true, spell=192085, class="WARRIOR" },
		[31346051] = { portal=true, label=L["Teleportation Nexus"], note=format(L["Portal to %s"], BZ["Hall of the Guardian"]), class="MAGE" },
		[45923577] = { flight=true, label=L["Great Eagle"], npc=109572, class="HUNTER" },
		[38097919] = { flight=true, label=L["Great Eagle"], npc=109572, class="HUNTER" },
	},
	[mapFile(1033)] = { -- Suramar
		[33084820] = { portal=true, spell=192085, class="WARRIOR" },
		[33435044] = { portal=true, label=L["Teleportation Nexus"], note=format(L["Portal to %s"], BZ["Hall of the Guardian"]), class="MAGE" },
		[70207105] = { flight=true, label=L["Great Eagle"], npc=109572, class="HUNTER" },
		[41328282] = { flight=true, label=L["Great Eagle"], npc=109572, class="HUNTER" },
	},
	[mapFile(1007)] = { -- Broken Isles
		-- Druid
		[30792486] = { portal=true, label=format(L["Portal to %s"], BZ["Emerald Dreamway"]), class="DRUID" }, -- The Dreamgrove
		-- Mage
		[33543470] = { portal=true, label=L["Teleportation Nexus"], note=format(L["Portal to %s"], BZ["Hall of the Guardian"]), class="MAGE" }, -- Val'sharah
		[37614873] = { portal=true, label=L["Teleportation Nexus"], note=format(L["Portal to %s"], BZ["Hall of the Guardian"]), class="MAGE" }, -- Azsuna
		[40522634] = { portal=true, label=L["Teleportation Nexus"], note=format(L["Portal to %s"], BZ["Hall of the Guardian"]), class="MAGE" }, -- Highmountain
		[52473524] = { portal=true, label=L["Teleportation Nexus"], note=format(L["Portal to %s"], BZ["Hall of the Guardian"]), class="MAGE" }, -- Stormheim
		[44054525] = { portal=true, label=L["Teleportation Nexus"], note=format(L["Portal to %s"], BZ["Hall of the Guardian"]), class="MAGE" }, -- Suramar
		-- Hunter
		[25945853] = { flight=true, label=L["Great Eagle"], npc=109572, class="HUNTER" }, -- Azsuna
		[35187140] = { flight=true, label=L["Great Eagle"], npc=109572, class="HUNTER" }, -- Azsuna
		[31512270] = { flight=true, label=L["Great Eagle"], npc=109572, class="HUNTER" }, -- Val'sharah
		[49992781] = { flight=true, label=L["Great Eagle"], npc=109572, class="HUNTER" }, -- Highmountain
		[41292094] = { flight=true, label=L["Great Eagle"], npc=109572, class="HUNTER" }, -- Highmountain
		[54554100] = { flight=true, label=L["Great Eagle"], npc=109572, class="HUNTER" }, -- Stormheim
		[56972762] = { flight=true, label=L["Great Eagle"], npc=109572, class="HUNTER" }, -- Stormheim
		[46375480] = { flight=true, label=L["Great Eagle"], npc=109572, class="HUNTER" }, -- Suramar
		[54885133] = { flight=true, label=L["Great Eagle"], npc=109572, class="HUNTER" }, -- Suramar
		-- Warrior
		[46966454] = { portal=true, spell=192085, class="WARRIOR" }, -- Dalaran
		[33995327] = { portal=true, spell=192085, class="WARRIOR" }, -- Azsuna
		[61353270] = { portal=true, spell=192085, class="WARRIOR" }, -- Stormheim
		[34554020] = { portal=true, spell=192085, class="WARRIOR" }, -- Val'sharah
		[46032488] = { portal=true, spell=192085, class="WARRIOR" }, -- Highmountain
		[43944459] = { portal=true, spell=192085, class="WARRIOR" }, -- Suramar
		[52607039] = { portal=true, spell=192085, class="WARRIOR" }, -- Broken Shore
	},
	[mapFile(1048)] = { -- Emerald Dreamway
		[44592362] = { portal=true, label=format(L["Portal to %s"], BZ["The Dreamgrove"]), class="DRUID" },
		[31442466] = { portal=true, label=format(L["Portal to %s"], BZ["Grizzly Hills"]), class="DRUID" },
		[22203921] = { portal=true, label=format(L["Portal to %s"], BZ["Feralas"]), class="DRUID" },
		[25918178] = { portal=true, label=format(L["Portal to %s"], BZ["Moonglade"]), class="DRUID" },
		[39166996] = { portal=true, label=format(L["Portal to %s"], BZ["Duskwood"]), class="DRUID" },
		[48736345] = { portal=true, label=format(L["Portal to %s"], BZ["The Hinterlands"]), class="DRUID" },
		[52635138] = { portal=true, label=format(L["Portal to %s"], BZ["Mount Hyjal"]), class="DRUID" },
	},
	-- Northrend
	[mapFile(485)] = { -- Northrend
		[73075158] = { portal=true, L["Portal"], class="DRUID" }, -- Grizzly Hills
	},
	[mapFile(490)] = { -- Grizzly Hills
		[50362937] = { portal=true, label=format(L["Portal to %s"], BZ["Emerald Dreamway"]), class="DRUID" },
	},
	-- Kalimdor
	[mapFile(13)] = { -- Kalimdor
		[41286383] = { portal=true, L["Portal"], class="DRUID" }, -- Feralas
		[54402134] = { portal=true, L["Portal"], class="DRUID" }, -- Moonglade
		[55712998] = { portal=true, L["Portal"], class="DRUID" }, -- Mount Hyjal
	},
	[mapFile(121)] = { -- Feralas
		[51291076] = { portal=true, label=format(L["Portal to %s"], BZ["Emerald Dreamway"]), class="DRUID" },
	},
	[mapFile(241)] = { -- Moonglade
		[67585994] = { portal=true, label=format(L["Portal to %s"], BZ["Emerald Dreamway"]), class="DRUID" },
	},
	[mapFile(606)] = { -- Mount Hyjal
		[59072614] = { portal=true, label=format(L["Portal to %s"], BZ["Emerald Dreamway"]), class="DRUID" },
	},
	-- Eastern Kingdom
	[mapFile(14)] = { -- Eastern Kingdom
		[45647930] = { portal=true, L["Portal"], class="DRUID" }, -- Duskwood
		[54353789] = { portal=true, L["Portal"], class="DRUID" }, -- The Hinterlands
	},
	[mapFile(34)] = { -- Duskwood
		[46573587] = { portal=true, label=format(L["Portal to %s"], BZ["Emerald Dreamway"]), class="DRUID" },
	},
	[mapFile(26)] = { -- The Hinterlands
		[62322271] = { portal=true, label=format(L["Portal to %s"], BZ["Emerald Dreamway"]), class="DRUID" },
	},
	-- World
	["World"] = {
		[56593757] = { portal=true, L["Portal"], class="DRUID" }, -- The Dreamgrove
		[57091776] = { portal=true, L["Portal"], class="DRUID" }, -- Grizzly Hills
		[15106137] = { portal=true, L["Portal"], class="DRUID" }, -- Feralas
		[22753655] = { portal=true, L["Portal"], class="DRUID" }, -- Moonglade
		[23524158] = { portal=true, L["Portal"], class="DRUID" }, -- Mount Hyjal
		[84317124] = { portal=true, L["Portal"], class="DRUID" }, -- Duskwood
		[89884473] = { portal=true, L["Portal"], class="DRUID" }, -- The Hinterlands
	}
}
