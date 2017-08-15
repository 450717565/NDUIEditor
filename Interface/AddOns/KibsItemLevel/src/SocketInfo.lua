local addonName = "KibsItemLevel"
local addonNamespace = LibStub and LibStub(addonName .. "-1.0", true)
if not addonNamespace or addonNamespace.loaded.SocketInfo then return end
addonNamespace.loaded.SocketInfo = true

local L = addonNamespace.L

local SocketInfo = {
    TYPE = {
        UNKNOWN = 0,
        PRISMATIC = 1,
        RED = 2,
        BLUE = 3,
        YELLOW = 4,
        META = 5,
    }
}
SocketInfo.__index = SocketInfo

addonNamespace.SocketInfo = SocketInfo

function SocketInfo:new(typeId, gemItemInfo, relicType, missingGemText)
    return setmetatable({
        typeId = typeId,
        gemItemInfo = gemItemInfo,
        relicType = relicType,
        missingGemText = missingGemText,
    }, self)
end

function SocketInfo:getTypeId()
    return self.typeId
end

function SocketInfo:isEmpty()
    return self.gemItemInfo == nil
end

function SocketInfo:getGem()
    return self.gemItemInfo
end

function SocketInfo:getTextureName()
    return ({
        [self.TYPE.PRISMATIC] = "INTERFACE/ITEMSOCKETINGFRAME/UI-EmptySocket-Prismatic",
        [self.TYPE.RED] = "INTERFACE/ITEMSOCKETINGFRAME/UI-EmptySocket-Red",
        [self.TYPE.BLUE] = "INTERFACE/ITEMSOCKETINGFRAME/UI-EmptySocket-Blue",
        [self.TYPE.YELLOW] = "INTERFACE/ITEMSOCKETINGFRAME/UI-EmptySocket-Yellow",
        [self.TYPE.META] = "INTERFACE/ITEMSOCKETINGFRAME/UI-EmptySocket-Meta",
        [self.TYPE.UNKNOWN] = "INTERFACE/ICONS/INV_Misc_QuestionMark",
    })[self.typeId]
end

function SocketInfo:getRelicType()
    return self.relicType
end

function SocketInfo:getMissingGemText()
    return self.missingGemText ~= nil and self.missingGemText or L['Missing gem']
end
