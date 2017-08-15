local addonName = "KibsItemLevel"
local addonNamespace = LibStub and LibStub(addonName .. "-1.0", true)
if not addonNamespace or addonNamespace.loaded.Debug then return end
addonNamespace.loaded.Debug = true

local queue = {}
local printer

addonNamespace.Debug = function(...)
    if printer then
        printer(...)
    else
        table.insert(queue, { ... })
    end
end

addonNamespace.SetDebugPrinter = function(callback)
    printer = callback

    if printer then
        for _, args in ipairs(queue) do
            printer(unpack(args))
        end

        queue = {}
    end
end
