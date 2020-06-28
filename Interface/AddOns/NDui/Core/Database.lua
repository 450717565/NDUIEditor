local _, ns = ...
local B, C, L, DB = unpack(ns)

local bit_band, bit_bor = bit.band, bit.bor
local COMBATLOG_OBJECT_AFFILIATION_MINE = COMBATLOG_OBJECT_AFFILIATION_MINE or 0x00000001
local GetSpecialization, GetSpecializationInfo = GetSpecialization, GetSpecializationInfo

DB.Version = GetAddOnMetadata("NDui", "Version")
DB.Support = GetAddOnMetadata("NDui", "X-Support")
DB.Client = GetLocale()
DB.ScreenWidth, DB.ScreenHeight = GetPhysicalScreenSize()
DB.isNewPatch = GetBuildInfo() == "8.3.0" -- keep it for future purpose

-- Colors
DB.MyName = UnitName("player")
DB.MyRealm = GetRealmName()
DB.MyClass = select(2, UnitClass("player"))
DB.MyFaction = UnitFactionGroup("player")
DB.ClassList = {}
for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
	DB.ClassList[v] = k
end
DB.ClassColors = {}
local classColors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
for class, value in pairs(classColors) do
	DB.ClassColors[class] = {}
	DB.ClassColors[class] = {r = value.r, g = value.g, b = value.b, colorStr = value.colorStr}
end
DB.r, DB.g, DB.b = DB.ClassColors[DB.MyClass].r, DB.ClassColors[DB.MyClass].g, DB.ClassColors[DB.MyClass].b
DB.MyColor = format("|cff%02x%02x%02x", DB.r*255, DB.g*255, DB.b*255)
DB.InfoColor = "|cff99ccff" --.6,.8,1
DB.GreyColor = "|cff7b8489"

-- Fonts
DB.Font = {STANDARD_TEXT_FONT, 12, "OUTLINE"}
DB.LineString = DB.MyColor.."————————|r"
DB.Separator = DB.MyColor.." | |r"

-- Textures
local Media = "Interface\\Addons\\NDui\\Media\\"
DB.arrowTex = Media.."arrowTex_"
DB.bgTex = Media.."bgTex"
DB.glowTex = Media.."glowTex"

DB.normTex = Media.."Texture\\texture_1"

DB.chatLogo = Media.."Hutu\\logoSmall"
DB.logoTex = Media.."Hutu\\logo"
DB.microTex = Media.."Hutu\\Menu\\"
DB.rolesTex = Media.."Hutu\\RoleIcons"

DB.arrowBottom = Media.."Arrow\\arrow-bottom"
DB.arrowDown = Media.."Arrow\\arrow-down"
DB.arrowLeft = Media.."Arrow\\arrow-left"
DB.arrowRight = Media.."Arrow\\arrow-right"
DB.arrowTop = Media.."Arrow\\arrow-top"
DB.arrowUp = Media.."Arrow\\arrow-up"

DB.checked = Media.."Button\\checked"
DB.flash = Media.."Button\\flash"
DB.normal = Media.."Button\\normal"
DB.pushed = Media.."Button\\pushed"

DB.bdTex = "Interface\\ChatFrame\\ChatFrameBackground"
DB.binTex = "Interface\\HelpFrame\\ReportLagIcon-Loot"
DB.copyTex = "Interface\\Buttons\\UI-GuildButton-PublicNote-Up"
DB.creditTex = "Interface\\HelpFrame\\HelpIcon-KnowledgeBase"
DB.eyeTex = "Interface\\Minimap\\Raid_Icon"
DB.garrTex = "Interface\\HelpFrame\\HelpIcon-ReportLag"
DB.gearTex = "Interface\\WorldMap\\Gear_64"
DB.mailTex = "Interface\\Minimap\\Tracking\\Mailbox"
DB.newItemFlash = "Interface\\Cooldown\\star4"
DB.objectTex = "Warfronts-BaseMapIcons-Horde-Barracks-Minimap"
DB.questTex = "adventureguide-microbutton-alert"
DB.sparkTex = "Interface\\CastingBar\\UI-CastingBar-Spark"

DB.TexCoord = {.08, .92, .08, .92}
DB.LeftButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t "
DB.RightButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t "
DB.ScrollButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t "
DB.AFKTex = "|T"..FRIENDS_TEXTURE_AFK..":14:14:0:0:16:16:1:15:1:15|t"
DB.DNDTex = "|T"..FRIENDS_TEXTURE_DND..":14:14:0:0:16:16:1:15:1:15|t"

DB.Space = 3
DB.Alpha = .8
DB.Slots = {"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand", "SecondaryHand", "Tabard"}
DB.MythicLoot =  {0, 435, 435, 440, 445, 445, 450, 455, 455, 455, 460, 460, 460, 465, 465}
DB.WeeklyLoot =  {0, 440, 445, 450, 450, 455, 460, 460, 460, 465, 465, 470, 470, 470, 475}

-- Flags
function DB:IsMyPet(flags)
	return bit_band(flags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0
end
DB.PartyPetFlags = bit_bor(COMBATLOG_OBJECT_AFFILIATION_PARTY, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PET)
DB.RaidPetFlags = bit_bor(COMBATLOG_OBJECT_AFFILIATION_RAID, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PET)

-- RoleUpdater
local function CheckRole()
	local tree = GetSpecialization()
	if not tree then return end
	local _, _, _, _, role, stat = GetSpecializationInfo(tree)
	if role == "TANK" then
		DB.Role = "Tank"
	elseif role == "HEALER" then
		DB.Role = "Healer"
	elseif role == "DAMAGER" then
		if stat == 4 then	--1力量，2敏捷，4智力
			DB.Role = "Caster"
		else
			DB.Role = "Melee"
		end
	end
end
B:RegisterEvent("PLAYER_LOGIN", CheckRole)
B:RegisterEvent("PLAYER_TALENT_UPDATE", CheckRole)

-- Raidbuff Checklist
DB.BuffList = {
	[1] = {		-- 合剂
		--251836,	-- 敏捷238
		--251837,	-- 智力238
		--251838,	-- 耐力238
		--251839,	-- 力量238
		298836,	-- 敏捷360
		298837,	-- 智力360
		298839,	-- 耐力360
		298841,	-- 力量360
	},
	[2] = { -- 进食充分
		104273, -- 250敏捷，BUFF名一致
	},
	[3] = { -- 10%智力
		1459,
		264760,
	},
	[4] = { -- 10%耐力
		21562,
		264764,
	},
	[5] = { -- 10%攻强
		6673,
		264761,
	},
	[6] = { -- 符文
		270058,
	},
}

-- Reminder Buffs Checklist
DB.ReminderBuffs = {
	MAGE = {
		{	spells = {	-- 奥术魔宠
				[210126] = true,
			},
			depend = 205022,
			spec = 1,
			combat = true,
			instance = true,
			pvp = true,
		},
		{	spells = {	-- 奥术智慧
				[1459] = true,
			},
			depend = 1459,
			instance = true,
		},
	},
	PRIEST = {
		{	spells = {	-- 真言术耐
				[21562] = true,
			},
			depend = 21562,
			instance = true,
		},
	},
	WARRIOR = {
		{	spells = {	-- 战斗怒吼
				[6673] = true,
			},
			depend = 6673,
			instance = true,
		},
	},
	SHAMAN = {
		{	spells = {	-- 闪电之盾
				[192106] = true,
			},
			depend = 192106,
			combat = true,
			instance = true,
			pvp = true,
		},
	},
	ROGUE = {
		{	spells = {	-- 伤害类毒药
				[2823] = true,		-- 致命药膏
				[8679] = true,		-- 致伤药膏
			},
			spec = 1,
			combat = true,
			instance = true,
			pvp = true,
		},
		{	spells = {	-- 效果类毒药
				[3408] = true,		-- 减速药膏
			},
			spec = 1,
			pvp = true,
		},
	},
}
