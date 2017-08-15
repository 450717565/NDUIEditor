local addonName = "KibsItemLevel"
local addonNamespace = LibStub and LibStub(addonName .. "-1.0", true)
if not addonNamespace or addonNamespace.loaded.ItemStringInfo then return end
addonNamespace.loaded.ItemStringInfo = true

local L = addonNamespace.L

local ItemStringInfo = {}
ItemStringInfo.__index = ItemStringInfo

addonNamespace.ItemStringInfo = ItemStringInfo

function ItemStringInfo:new(itemString)
    local _type, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId, linkLevel, specializationID, reforgeId, unknown1, unknown2, unknown3, unknown4

    if type(itemString) == "string" then
        itemString = string.match(itemString, "^|%x%x%x%x%x%x%x%x%x|H([^|]+)|h") or itemString
        _type, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId, linkLevel, specializationID, reforgeId, unknown1, unknown2, unknown3, unknown4 = strsplit(
            ":",
            itemString
        )
    end

    return setmetatable({
        itemString = itemString,
        type = _type,
        itemId = tonumber(itemId) or 0,
        enchantId = tonumber(enchantId) or 0,
        jewelId1 = tonumber(jewelId1) or 0,
        jewelId2 = tonumber(jewelId2) or 0,
        jewelId3 = tonumber(jewelId3) or 0,
        jewelId4 = tonumber(jewelId4) or 0,
        suffixId = tonumber(suffixId) or 0,
        uniqueId = tonumber(uniqueId) or 0,
        linkLevel = tonumber(linkLevel) or 0,
        specializationID = tonumber(specializationID) or 0,
        reforgeId = tonumber(reforgeId) or 0,
        unknown1 = tonumber(unknown1) or 0,
        unknown2 = tonumber(unknown2) or 0,
        unknown3 = tonumber(unknown3) or 0,
        unknown4 = tonumber(unknown4) or 0,
        itemLevel = false,
        upgrades = nil,
    }, self)
end

function ItemStringInfo:getItemString()
    return self.itemString
end

function ItemStringInfo:getStrippedInfo()
    return ItemStringInfo:new(
        self.type
        .. ":" .. self.itemId
        .. ":" .. 0
        .. ":" .. 0
        .. ":" .. 0
        .. ":" .. 0
        .. ":" .. 0
        .. ":" .. self.suffixId
        .. ":" .. self.uniqueId
        .. ":" .. self.linkLevel
        .. ":" .. self.specializationID
        .. ":" .. self.reforgeId
        .. ":" .. self.unknown1
        .. ":" .. self.unknown2
        .. ":" .. self.unknown3
        .. ":" .. self.unknown4
    )
end

function ItemStringInfo:getLink()
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(self.itemString)
    return itemLink
end

function ItemStringInfo:getEnchantInfo()
    return self.enchantId ~= 0 and addonNamespace.ItemEnchantInfo:new(self.enchantId) or nil
end

function ItemStringInfo:getTextureName()
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(self.itemString)
    return itemTexture
end

function ItemStringInfo:isTwoHandedWeapon()
    local _, _, _, _, _, _, _, _, itemEquipLoc, _, _, _, _ = GetItemInfo(self.itemString)
    return itemEquipLoc == 'INVTYPE_2HWEAPON' or itemEquipLoc == 'INVTYPE_RANGED' or itemEquipLoc == 'INVTYPE_RANGEDRIGHT'
end

function ItemStringInfo:getQualityColor()
    local quality = select(3, GetItemInfo(self.itemString));

    if quality then
        return select(4, GetItemQualityColor(quality))
    end

    return nil
end

local InvisibleTooltip = CreateFrame("GameTooltip", addonName .. "InvisibleTooltip", nil, "GameTooltipTemplate")

local BLOOD = 'Blood'
local SHADOW = 'Shadow'
local IRON = 'Iron'
local FROST = 'Frost'
local FIRE = 'Fire'
local FEL = 'Fel'
local ARCANE = 'Arcane'
local LIFE = 'Life'
local STORM = 'Wind'
local HOLY = 'Holy'

local relicSlots = {
    -- Death Knight

    -- Blood
    [250] = { BLOOD, SHADOW, IRON },
    -- Frost
    [251] = { FROST, SHADOW, FROST },
    -- Unholy
    [252] = { FIRE, SHADOW, BLOOD },

    -- Demon Hunter

    -- Havoc
    [577] = { FEL, SHADOW, FEL },
    -- Vengeance
    [581] = { IRON, ARCANE, FEL },

    -- Druid

    -- Balance
    [102] = { ARCANE, LIFE, ARCANE },
    -- Feral
    [103] = { FROST, BLOOD, LIFE },
    -- Guardian
    [104] = { FIRE, BLOOD, LIFE },
    -- Restoration
    [105] = { LIFE, FROST, LIFE },

    -- Hunter

    -- Beast Mastery
    [253] = { STORM, ARCANE, IRON },
    -- Marksmanship
    [254] = { STORM, BLOOD, LIFE },
    -- Survival
    [255] = { STORM, IRON, BLOOD },

    -- Mage

    -- Arcane
    [62] = { ARCANE, FROST, ARCANE },
    -- Fire
    [63] = { FIRE, ARCANE, FIRE },
    -- Frost
    [64] = { FROST, ARCANE, FROST },

    -- Monk

    -- Brewmaster
    [268] = { LIFE, STORM, IRON },
    -- Mistweaver
    [270] = { FROST, LIFE, STORM },
    -- Windwalker
    [269] = { STORM, IRON, STORM },

    -- Paladin

    -- Holy
    [65] = { HOLY, LIFE, HOLY },
    -- Protection
    [66] = { HOLY, IRON, ARCANE },
    -- Retribution
    [70] = { HOLY, FIRE, HOLY },

    -- Priest

    -- Discipline
    [256] = { HOLY, SHADOW, HOLY },
    -- Holy
    [257] = { HOLY, LIFE, HOLY },
    -- Shadow
    [258] = { SHADOW, BLOOD, SHADOW },

    -- Rogue

    -- Assassination
    [259] = { SHADOW, IRON, BLOOD },
    -- Outlaw
    [260] = { BLOOD, IRON, STORM },
    -- Subtlety
    [261] = { FEL, SHADOW, FEL },

    -- Shaman

    -- Elemental
    [262] = { STORM, FROST, STORM },
    -- Enhancement
    [263] = { FIRE, IRON, STORM },
    -- Restoration
    [264] = { LIFE, FROST, LIFE },

    -- Warlock

    -- Affliction
    [265] = { SHADOW, BLOOD, SHADOW },
    -- Demonology
    [266] = { SHADOW, FIRE, FEL },
    -- Destruction
    [267] = { FEL, FIRE, FEL },

    -- Warrior

    -- Arms
    [71] = { IRON, BLOOD, SHADOW },
    -- Fury
    [72] = { FIRE, STORM, IRON },
    -- Protection
    [73] = { IRON, BLOOD, FIRE },
}

local missingRelicText = {
    [BLOOD] = L['Missing Blood relic'],
    [SHADOW] = L['Missing Shadow relic'],
    [IRON] = L['Missing Iron relic'],
    [FROST] = L['Missing Frost relic'],
    [FIRE] = L['Missing Fire relic'],
    [FEL] = L['Missing Fel relic'],
    [ARCANE] = L['Missing Arcane relic'],
    [LIFE] = L['Missing Life relic'],
    [STORM] = L['Missing Wind relic'],
    [HOLY] = L['Missing Holy relic'],
}

local artifactItemIdToSpecId = {
    -- Death Knight

    -- Blood
    [128402] = 250, -- Maw of the Damned
    -- Frost
    [128293] = 251, -- Blades of the Fallen Prince
    [128292] = 251, -- Blades of the Fallen Prince
    -- Unholy
    [128403] = 252, -- Apocalypse

    -- Demon Hunter

    -- Havoc
    [127829] = 577, -- Twinblades of the Deceiver
    [127830] = 577, -- Twinblades of the Deceiver
    -- Vengeance
    [128831] = 581, -- Aldrachi Warblades
    [128832] = 581, -- Aldrachi Warblades

    -- Druid

    -- Balance
    [128858] = 102, -- Scythe of Elune
    -- Feral
    [128860] = 103, -- Fangs of Ashamane
    [128859] = 103, -- Fangs of Ashamane
    -- Guardian
    [128822] = 104, -- Claws of Ursoc
    [128821] = 104, -- Claws of Ursoc
    -- Restoration
    [128306] = 105, -- G'Hanir, the Mother Tree

    -- Hunter

    -- Beast Mastery
    [128861] = 253, -- Titanstrike
    -- Marksmanship
    [128826] = 254, -- Thas'dorah, Legacy of the Windrunners
    -- Survival
    [128808] = 255, -- Talonclaw

    -- Mage

    -- Arcane
    [127857] = 62, -- Aluneth
    -- Fire
    [128820] = 63, -- Felo'melorn
    [133959] = 63, -- Heart of the Phoenix
    -- Frost
    [128862] = 64, -- Ebonchill

    -- Monk

    -- Brewmaster
    [128938] = 268, -- Fu Zan, the Wanderer's Companion
    -- Mistweaver
    [128937] = 270, -- Sheilun, Staff of the Mists
    -- Windwalker
    [128940] = 269, -- Fists of the Heavens
    [133948] = 269, -- Fists of the Heavens

    -- Paladin

    -- Holy
    [128824] = 65, -- Tome of the Silver Hand
    [139621] = 65, -- The Watcher's Hammer
    [128823] = 65, -- The Silver Hand
    -- Protection
    [128867] = 66, -- Oathseeker
    [128866] = 66, -- Truthguard
    -- Retribution
    [120978] = 70, -- Ashbringer

    -- Priest

    -- Discipline
    [128868] = 256, -- Light's Wrath
    -- Holy
    [128825] = 257, -- T'uure, Beacon of the Naaru
    [136858] = 257, -- Darkened T'uure
    -- Shadow
    [128827] = 258, -- Xal'atath, Blade of the Black Empire
    [133958] = 258, -- Secrets of the Void

    -- Rogue

    -- Assassination
    [128870] = 259, -- The Kingslayers
    [128869] = 259, -- The Kingslayers
    -- Outlaw
    [128872] = 260, -- The Dreadblades
    [134552] = 260, -- The Dreadblades
    -- Subtlety
    [128479] = 261, -- Fangs of the Devourer
    [128476] = 261, -- Fangs of the Devourer

    -- Shaman

    -- Elemental
    [128935] = 262, -- The Fist of Ra-den
    [128936] = 262, -- The Highkeeper's Ward
    [139439] = 262, -- The Highkeeper's Ward
    -- Enhancement
    [128819] = 263, -- Doomhammer
    [128873] = 263, -- Fury of the Stonemother
    [136593] = 263, -- Doomhammer Offhand Appearance Record (referenced by actual item)
    -- Restoration
    [128911] = 264, -- Sharas'dal, Scepter of Tides
    [128934] = 264, -- Shield of the Sea Queen

    -- Warlock

    -- Affliction
    [128942] = 265, -- Ulthalesh, the Deadwind Harvester
    -- Demonology
    [137246] = 266, -- Spine of Thal'kiel
    [128943] = 266, -- Skull of the Man'ari
    -- Destruction
    [128941] = 267, -- Scepter of Sargeras

    -- Warrior

    -- Arms
    [128910] = 71, -- Strom'kar, the Warbreaker
    -- Fury
    [128908] = 72, -- Warswords of the Valarjar
    [134553] = 72, -- Warswords of the Valarjar
    -- Protection
    [128289] = 73, -- Scale of the Earth-Warder
    [128288] = 73, -- Scaleshard

    -- Fishing
    [133755] = nil, -- Underlight Angler
}

function ItemStringInfo:GetSpecIdByArtifact()
    return artifactItemIdToSpecId[self.itemId]
end

function ItemStringInfo:_getArtifactSockets(link)
    local result = {}
    local specId = self:GetSpecIdByArtifact()

    for i = 1, 3 do
        -- TODO: get real relic slot texture
        local _, gemItemLink = GetItemGem(self:getLink(), i)
        table.insert(
            result,
            1,
            addonNamespace.SocketInfo:new(
                addonNamespace.SocketInfo.TYPE.PRISMATIC,
                gemItemLink and ItemStringInfo:new(gemItemLink) or nil
                --relicSlots[specId][i]
                --missingRelicText[relicSlots[specId][i]]
            )
        )
    end

    return result
end

function ItemStringInfo:_getTooltipSockets(link)
    -- Based on Bimbo add-on code

    local result = {}
    local n = 30

    for i = 1, n do
        local texture = _G[InvisibleTooltip:GetName().."Texture"..i]
        if texture then
            texture:SetTexture(nil)
        end
    end

    InvisibleTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
    InvisibleTooltip:SetHyperlink(link)

    for i = 1, n do
        local texture = _G[InvisibleTooltip:GetName().."Texture"..i]
        local textureName = texture and texture:GetTexture()

        if textureName then
            local map = {
                ["INTERFACE/ITEMSOCKETINGFRAME/UI-EMPTYSOCKET-PRISMATIC"] = addonNamespace.SocketInfo.TYPE.PRISMATIC,
                ["INTERFACE/ITEMSOCKETINGFRAME/UI-EMPTYSOCKET-RED"] = addonNamespace.SocketInfo.TYPE.RED,
                ["INTERFACE/ITEMSOCKETINGFRAME/UI-EMPTYSOCKET-BLUE"] = addonNamespace.SocketInfo.TYPE.BLUE,
                ["INTERFACE/ITEMSOCKETINGFRAME/UI-EMPTYSOCKET-YELLOW"] = addonNamespace.SocketInfo.TYPE.YELLOW,
                ["INTERFACE/ITEMSOCKETINGFRAME/UI-EMPTYSOCKET-META"] = addonNamespace.SocketInfo.TYPE.META,
            }

            local canonicalTextureName = string.gsub(string.upper(textureName), "\\", "/")
            local socketTypeId = map[canonicalTextureName] or addonNamespace.SocketInfo.TYPE.UNKNOWN
            local _, gemItemLink = GetItemGem(self:getLink(), i)

            table.insert(result, addonNamespace.SocketInfo:new(socketTypeId, gemItemLink and ItemStringInfo:new(gemItemLink) or nil))
        end
    end

    return result
end

function ItemStringInfo:getSockets()
    local link = self:getStrippedInfo():getLink()

    if not link then
        return {}
    elseif self:IsArtifact() and self:_getArtifactItemLevel() > 750 then
        return self:_getArtifactSockets(link)
    else
        return self:_getTooltipSockets(link)
    end
end

function ItemStringInfo:IsArtifact()
    local quality = select(3, GetItemInfo(self.itemString))
    return quality == 6
end

function ItemStringInfo:_getArtifactItemLevel()
    local link = self:getLink()
    return select(4, GetItemInfo(link))
end

function ItemStringInfo:_getTooltipItemLevel()
    local link = self:getLink()

    if link then
        InvisibleTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
        InvisibleTooltip:SetHyperlink(self:getLink())

        for i = 2, 5 do
            local text = _G[InvisibleTooltip:GetName() .. "TextLeft" .. i]

            if text then
                local result = tonumber((text:GetText() or ""):match("%d+$") or "0")
                if result > 0 then
                    return result
                end
            end
        end
    end

    return nil
end

function ItemStringInfo:getItemLevel()
    if self.itemLevel == false then
        if self:IsArtifact() then
            self.itemLevel = self:_getArtifactItemLevel()
        else
            self.itemLevel = self:_getTooltipItemLevel()
        end
    end

    return self.itemLevel
end

function ItemStringInfo:GetUpgrades()
    if not self.upgrades then
        self.upgrades = { nil, nil }

        local link = self:getLink()

        if link then
            InvisibleTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
            InvisibleTooltip:SetHyperlink(self:getLink())

            for i = 1, 5 do
                local text = _G[InvisibleTooltip:GetName() .. "TextLeft" .. i]

                if text then
                    local current, max = (text:GetText() or ""):match("(%d+)/(%d+)$")
                    if current and max then
                        self.upgrades = { current, max }
                        break
                    end
                end
            end
        end
    end

    return unpack(self.upgrades)
end
