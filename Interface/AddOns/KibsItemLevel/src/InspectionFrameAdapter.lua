local addonName = "KibsItemLevel"
local addonNamespace = LibStub and LibStub(addonName .. "-1.0", true)
if not addonNamespace or addonNamespace.loaded.InspectionFrameAdapter then return end
addonNamespace.loaded.InspectionFrameAdapter = true

local InspectionFrameAdapter = {}
local InspectionFrameAdapterMetaTable = { __index = InspectionFrameAdapter }

setmetatable(InspectionFrameAdapter, { __index = addonNamespace.FrameAdapter })

function InspectionFrameAdapter:new()
    local instance = addonNamespace.FrameAdapter:new(InspectModelFrame, PaperDollFrame, 'Inspect')

    instance.messages = {
        contentChanged = 'InspectionFrameAdapter.contentChanged',
    }

    setmetatable(instance, InspectionFrameAdapterMetaTable)

    instance:RegisterEvent("UNIT_INVENTORY_CHANGED", function(event, unit)
        if unit ~= 'player' then
            instance:Debug("UNIT_INVENTORY_CHANGED", unit)
            instance:SendMessage(instance.messages.contentChanged)
        end
    end)

    instance:RegisterEvent("INSPECT_READY", function()
        instance:Debug("INSPECT_READY")
        instance:SendMessage(instance.messages.contentChanged)
    end)

    return instance
end

function InspectionFrameAdapter:Debug(...)
    addonNamespace.Debug('InspectionFrameAdapter', ...)
end

function InspectionFrameAdapter:GetUnit()
    return InspectFrame.unit
end

function InspectionFrameAdapter:Debug(...)
    addonNamespace.Debug('InspectionFrameAdapter:', ...)
end

addonNamespace.InspectionFrameAdapter = InspectionFrameAdapter
