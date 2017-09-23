local GetItemInfo = GetItemInfo
local AllSuits = {}

local BODY_ID, TABARD_ID =4, 19 -- 可以没有项

local function ItemInfo(slot)
	local _
	local link, id, name, equipLoc, texture = GetInventoryItemLink("player", slot)
	if link then
		local _, _, id = string.find(link, "item:(%d+)")
		name, _, _, _, _, _, _, _, equipLoc, texture = GetItemInfo(id)
	end
	return texture, name, equipLoc, link
end

local function printMySuit(asuit)
    print("suitName "..asuit.suitName)

    for i=8,8 do
    local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4,
    Suffix, Unique, LinkLvl, Name = string.find(itemLink,
    "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
    print(asuit["item"..i].name.." tx "..asuit["item"..i].texture.." link "..asuit["item"..i].link.." "..Name)
    end
end

local function EquipedSuit2MySuit()
    local _, itemName, itemLevel, itemEquipLoc, itemTexture,itemLink
    local CurrentSuit = {}
    CurrentSuit.suitName = "定制套装1"
    for i=1,19 do
        CurrentSuit["item"..i] = {
            name = "",
            level = 0,
            texture = 0,
            link = "",
            desc = "",
        }
    end
    for i=1,19 do
        -- itemName, _, _, itemLevel, _, _,_, _, itemEquipLoc, itemTexture = GetItemInfo(itemID or "")
        -- print("i "..i.." level "..tostring(itemLevel).." itemEquipLoc "..tostring(itemEquipLoc).." itemText "..tostring(itemTexture))
        itemTexture,itemName,itemEquipLoc,itemLink = ItemInfo(i)
        if itemName then
            CurrentSuit["item"..i].name = itemName
            CurrentSuit["item"..i].texture = itemTexture
            CurrentSuit["item"..i].link = itemLink
        end
    end
    printMySuit(CurrentSuit)
end

function FilteredNamePlate:testdemo()
    EquipedSuit2MySuit()
    EquipItemByName("鹰爪护腿")
end