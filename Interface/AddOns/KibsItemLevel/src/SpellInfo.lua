local addonName = "KibsItemLevel"
local addonNamespace = LibStub and LibStub(addonName .. "-1.0", true)
if not addonNamespace or addonNamespace.loaded.SpellInfo then return end
addonNamespace.loaded.SpellInfo = true

local SpellInfo = {}
SpellInfo.__index = SpellInfo

addonNamespace.SpellInfo = SpellInfo

function SpellInfo:new(itemString)
    local _type, spellId

    if type(itemString) == "string" then
        itemString = string.match(itemString,"^|%x%x%x%x%x%x%x%x%x|H([^|]+)|h") or itemString
        _type, spellId = strsplit(
            ":",
            itemString
        )
    end

    return setmetatable({
        itemString = itemString,
        type = _type,
        spellId = tonumber(spellId) or 0,
    }, self)
end

function SpellInfo:getLink()
    return GetSpellLink(self.spellId) or "|cffffd000|Henchant:"..self.spellId.."|h["..GetSpellInfo(self.spellId).."]|h|r"
end

function SpellInfo:getTextureName()
    return GetSpellTexture(self.spellId)
end
