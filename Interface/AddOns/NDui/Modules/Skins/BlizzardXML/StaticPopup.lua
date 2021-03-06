local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_StaticPopup(which, _, _, data)
	local info = StaticPopupDialogs[which]
	if not info then return end

	local dialog = nil
	dialog = StaticPopup_FindVisible(which, data)

	if not dialog then
		local index = 1
		if info.preferredIndex then
			index = info.preferredIndex
		end
		for i = index, STATICPOPUP_NUMDIALOGS do
			local frame = _G["StaticPopup"..i]
			if not frame:IsShown() then
				dialog = frame

				break
			end
		end

		if not dialog and info.preferredIndex then
			for i = 1, info.preferredIndex do
				local frame = _G["StaticPopup"..i]
				if not frame:IsShown() then
					dialog = frame

					break
				end
			end
		end
	end
end

C.OnLoginThemes["StaticPopup"] = function()
	for i = 1, 4 do
		local main = "StaticPopup"..i

		local frame = _G[main]
		B.ReskinFrame(frame, "none")
		B.ReskinButton(frame["extraButton"])

		for j = 1, 4 do
			B.ReskinButton(frame["button"..j])
		end

		local edit = _G[main.."EditBox"]
		B.ReskinInput(edit, 20)

		local item = _G[main.."ItemFrame"]
		B.StripTextures(item)

		local name = _G[main.."ItemFrameNameFrame"]
		name:Hide()

		local icon = _G[main.."ItemFrameIconTexture"]
		local icbg = B.ReskinIcon(icon)
		B.ReskinHLTex(item, icbg)
		B.ReskinBorder(item.IconBorder, icbg)

		local gold = _G[main.."MoneyInputFrameGold"]
		B.ReskinInput(gold)

		local silver = _G[main.."MoneyInputFrameSilver"]
		silver:ClearAllPoints()
		silver:SetPoint("LEFT", gold, "RIGHT", 1, 0)
		B.ReskinInput(silver)

		local copper = _G[main.."MoneyInputFrameCopper"]
		copper:ClearAllPoints()
		copper:SetPoint("LEFT", silver, "RIGHT", 1, 0)
		B.ReskinInput(copper)
	end

	hooksecurefunc("StaticPopup_Show", Reskin_StaticPopup)
end