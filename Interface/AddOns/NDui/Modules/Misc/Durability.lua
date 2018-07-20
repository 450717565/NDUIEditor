local _, ns = ...
local B, C, L, DB = unpack(ns)
local module = B:GetModule("Misc")

--[[
	在角色面板显示耐久度
]]
function module:ShowDurability()
	if not NDuiDB["Extras"]["Durability"] then return end

	local SLOTIDS = {}
	for _, slot in pairs({"Head", "Shoulder", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "MainHand", "SecondaryHand"}) do
		SLOTIDS[slot] = GetInventorySlotInfo(slot.."Slot")
	end

	local fontstrings = setmetatable({}, {
		__index = function(t,i)
			local gslot = _G["Character"..i.."Slot"]
			if not gslot then return end
			local fstr = B.CreateFS(gslot, DB.Font[2]+1, "", false, "BOTTOM", 1, 1)
			t[i] = fstr
			return fstr
		end,
	})

	local function RefreshData()
		for slot, id in pairs(SLOTIDS) do
			local v1, v2 = GetInventoryItemDurability(id)

			if v1 and v2 and v2 ~= 0 then
				local str = fontstrings[slot]
				str:SetFormattedText("%d%%", v1/v2*100)
			else
				local str = rawget(fontstrings, slot)
				if str then str:SetText(nil) end
			end
		end
	end

	B:RegisterEvent("PLAYER_ENTERING_WORLD", RefreshData)
	B:RegisterEvent("UPDATE_INVENTORY_DURABILITY", RefreshData)
end