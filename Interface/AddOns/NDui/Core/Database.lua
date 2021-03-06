local _, ns = ...
local B, C, L, DB = unpack(ns)

local bit_band, bit_bor = bit.band, bit.bor
local COMBATLOG_OBJECT_AFFILIATION_MINE = COMBATLOG_OBJECT_AFFILIATION_MINE or 0x00000001
local GetSpecialization, GetSpecializationInfo = GetSpecialization, GetSpecializationInfo

DB.Version = GetAddOnMetadata("NDui", "Version")
DB.Support = GetAddOnMetadata("NDui", "X-Support")
DB.Client = GetLocale()
DB.ScreenWidth, DB.ScreenHeight = GetPhysicalScreenSize()
DB.isNewPatch = select(4, GetBuildInfo()) >= 90100 -- 9.1.0

-- Deprecated
LE_ITEM_QUALITY_POOR = Enum.ItemQuality.Poor
LE_ITEM_QUALITY_COMMON = Enum.ItemQuality.Common
LE_ITEM_QUALITY_UNCOMMON = Enum.ItemQuality.Uncommon
LE_ITEM_QUALITY_RARE = Enum.ItemQuality.Rare
LE_ITEM_QUALITY_EPIC = Enum.ItemQuality.Epic
LE_ITEM_QUALITY_LEGENDARY = Enum.ItemQuality.Legendary
LE_ITEM_QUALITY_ARTIFACT = Enum.ItemQuality.Artifact
LE_ITEM_QUALITY_HEIRLOOM = Enum.ItemQuality.Heirloom

-- Colors
DB.MyName = UnitName("player")
DB.MyRealm = GetRealmName()
DB.MyFullName = DB.MyName.."-"..DB.MyRealm
DB.MyClass = select(2, UnitClass("player"))
DB.MyFaction = UnitFactionGroup("player")

DB.ClassList = {}
for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
	DB.ClassList[v] = k
end

DB.ClassColors = {}
local classColors = RAID_CLASS_COLORS or CUSTOM_CLASS_COLORS
for class, value in pairs(classColors) do
	DB.ClassColors[class] = {}
	DB.ClassColors[class] = {r = value.r, g = value.g, b = value.b, colorStr = value.colorStr}
end
DB.cr, DB.cg, DB.cb = DB.ClassColors[DB.MyClass].r, DB.ClassColors[DB.MyClass].g, DB.ClassColors[DB.MyClass].b

DB.QualityColors = {}
local qualityColors = ITEM_QUALITY_COLORS or BAG_ITEM_QUALITY_COLORS
for index, value in pairs(qualityColors) do
	DB.QualityColors[index] = {}
	DB.QualityColors[index] = {r = value.r, g = value.g, b = value.b, hex = value.hex, colorStr = value.color}
end

local color = CreateColor(0, 0, 0, 1)
local hex = color:GenerateHexColorMarkup()
DB.QualityColors[-1] = {r = 0, g = 0, b = 0, hex = hex, colorStr = color}

DB.MyColor = format("|cff%02x%02x%02x", DB.cr*255, DB.cg*255, DB.cb*255)
DB.InfoColor = "|cff99CCFF" --.6, .8, 1
DB.GreyColor = "|cff7F7F7F" --.5, .5, .5

-- Fonts
DB.Font = {STANDARD_TEXT_FONT, 12, "OUTLINE"}
DB.LineString = DB.MyColor.."————————|r"
DB.Separator = DB.MyColor.." | |r"
DB.NDuiString = DB.MyColor.."NDui:|r"

-- Textures
local Media = "Interface\\Addons\\NDui\\Media\\"
DB.chatLogo = Media.."Logo\\chatLogo"
DB.logoTex = Media.."Logo\\logoTex"
DB.afdianTex = Media.."Logo\\Afdian"
DB.patreonTex = Media.."Logo\\Patreon"

DB.arrowTex = Media.."Reskin\\arrowTex_"
DB.backdropTex = Media.."Reskin\\backdropTex"
DB.closeTex = Media.."Reskin\\closeTex"
DB.rolesTex = Media.."Reskin\\rolesTex"
DB.shadowTex = Media.."Reskin\\shadowTex"
DB.blankTex = Media.."Reskin\\blankTex"

DB.menuTex = Media.."Menu\\"
DB.targetTex = Media.."Target\\targetTex_"
DB.normTex = Media.."Texture\\normTex_"
DB.restingTex = Media.."Other\\Resting"
DB.rotationRigh = Media.."Other\\RotationRigh"

DB.bgTex = "Interface\\ChatFrame\\ChatFrameBackground"
DB.binTex = "Interface\\HelpFrame\\ReportLagIcon-Loot"
DB.classTex = "Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES"
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
DB.yesTex = "Interface\\RaidFrame\\ReadyCheck-Ready"
DB.noTex = "Interface\\RaidFrame\\ReadyCheck-NotReady"

DB.LeftButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t "
DB.RightButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:410|t "
DB.ScrollButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t "
DB.AFKTex = "|T"..FRIENDS_TEXTURE_AFK..":14:14:0:0:16:16:1:15:1:15|t"
DB.DNDTex = "|T"..FRIENDS_TEXTURE_DND..":14:14:0:0:16:16:1:15:1:15|t"

-- Others
DB.TexCoord = {.08, .92, .08, .92}
DB.MythicLoot = {0, 213, 216, 220, 220, 223, 226, 226, 226, 229, 229, 233, 233, 233, 236}
DB.WeeklyLoot = {0, 226, 229, 233, 236, 236, 239, 242, 242, 246, 246, 249, 249, 252, 252}
DB.Slots = {
	"Head",
	"Neck",
	"Shoulder",
	"Shirt",
	"Chest",
	"Waist",
	"Legs",
	"Feet",
	"Wrist",
	"Hands",
	"Finger0",
	"Finger1",
	"Trinket0",
	"Trinket1",
	"Back",
	"MainHand",
	"SecondaryHand",
	"Tabard",
}
DB.ChatEvents = {
	"CHAT_MSG_BATTLEGROUND",
	"CHAT_MSG_BATTLEGROUND_LEADER",
	"CHAT_MSG_BN_WHISPER",
	"CHAT_MSG_BN_WHISPER_INFORM",
	"CHAT_MSG_EMOTE",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_INSTANCE_CHAT",
	"CHAT_MSG_INSTANCE_CHAT_LEADER",
	"CHAT_MSG_OFFICER",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_RAID",
	"CHAT_MSG_RAID_LEADER",
	"CHAT_MSG_RAID_WARNING",
	"CHAT_MSG_SAY",
	"CHAT_MSG_TEXT_EMOTE",
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_WHISPER_INFORM",
	"CHAT_MSG_YELL",
}
DB.ItemTooltips = {
	EmbeddedItemTooltip,
	GameTooltip,
	GameTooltipTooltip,
	ItemRefShoppingTooltip1,
	ItemRefShoppingTooltip2,
	ItemRefTooltip,
	ShoppingTooltip1,
	ShoppingTooltip2,
}

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
		307166,	-- 大锅
		307185,	-- 通用合剂
		307187,	-- 耐力合剂
	},
	[2] = {     -- 进食充分
		104273, -- 250敏捷，BUFF名一致
	},
	[3] = {     -- 10%智力
		1459,
		264760,
	},
	[4] = {     -- 10%耐力
		21562,
		264764,
	},
	[5] = {     -- 10%攻强
		6673,
		264761,
	},
	[6] = {     -- 符文
		270058,
	},
}

-- Reminder Buffs Checklist
DB.ReminderBuffs = {
	ITEMS = {
		{	itemID = 178715, -- 唤雾者的陶笛
			spells = {
				[330067] = true, -- 全能
				[332299] = true, -- 爆击
				[332300] = true, -- 急速
				[332301] = true, -- 精通
			},
			equip = true,
			instance = true,
			combat = true,
		},
		{	itemID = 178742, -- 瓶装毒素饰品
			spells = {
				[345545] = true,
			},
			equip = true,
			instance = true,
			combat = true,
		},
		{	itemID = 174906, -- 属性符文
			spells = {
				[317065] = true,
				[270058] = true,
			},
			instance = true,
			disable = true,
		},
		{	itemID = 185818, -- 究极秘术
			spells = {
				[351952] = true,
			},
			equip = true,
			instance = true,
			combat = true,
		},
	},
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
		{	spells = {
				[192106] = true,	-- 闪电之盾
				[974] = true,		-- 大地之盾
				[52127] = true,		-- 水之护盾
			},
			depend = 192106,
			combat = true,
			instance = true,
			pvp = true,
		},
		{	spells = {
				[33757] = true,		-- 风怒武器
			},
			depend = 33757,
			combat = true,
			instance = true,
			pvp = true,
			weaponIndex = 1,
			spec = 2,
		},
		{	spells = {
				[318038] = true,	-- 火舌武器
			},
			depend = 318038,
			combat = true,
			instance = true,
			pvp = true,
			weaponIndex = 2,
			spec = 2,
		},
	},
	ROGUE = {
		{	spells = {	-- 伤害类毒药
				[2823] = true,		-- 致命药膏
				[8679] = true,		-- 致伤药膏
				[315584] = true,	-- 速效药膏
			},
			texture = 132273,
			depend = 315584,
			combat = true,
			instance = true,
			pvp = true,
		},
		{	spells = {	-- 效果类毒药
				[3408] = true,		-- 减速药膏
				[5761] = true,		-- 迟钝药膏
			},
			depend = 3408,
			pvp = true,
		},
	},
}