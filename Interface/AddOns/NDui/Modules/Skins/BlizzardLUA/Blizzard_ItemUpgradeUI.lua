local _, ns = ...
local B, C, L, DB = unpack(ns)

local tL, tR, tT, tB = unpack(DB.TexCoord)

local function Reskin_ItemUpgradeFrame()
	local icon, _, quality = GetItemUpgradeItemInfo()
	local r, g, b = B.GetQualityColor(quality)
	local ItemButton = ItemUpgradeFrame.ItemButton

	if icon then
		ItemButton.IconTexture:SetTexCoord(tL, tR, tT, tB)
		ItemButton.icbg:SetBackdropBorderColor(r, g, b)
		ItemButton.bubg:SetBackdropBorderColor(r, g, b)
	else
		ItemButton.IconTexture:SetTexture("")
		ItemButton.icbg:SetBackdropBorderColor(0, 0, 0)
		ItemButton.bubg:SetBackdropBorderColor(0, 0, 0)
	end
end

C.OnLoadThemes["Blizzard_ItemUpgradeUI"] = function()
	B.ReskinFrame(ItemUpgradeFrame)

	B.StripTextures(ItemUpgradeFrameMoneyFrame)
	B.StripTextures(ItemUpgradeFrame.ButtonFrame)
	B.ReskinButton(ItemUpgradeFrameUpgradeButton)
	B.ReskinIcon(ItemUpgradeFrameMoneyFrame.Currency.icon)

	local ItemButton = ItemUpgradeFrame.ItemButton
	B.StripTextures(ItemButton)
	local icbg = B.ReskinIcon(ItemButton.IconTexture)
	B.ReskinHLTex(ItemButton, icbg)
	ItemButton.icbg = icbg

	local TextFrame = ItemUpgradeFrame.TextFrame
	B.StripTextures(TextFrame)
	local bubg = B.CreateBGFrame(TextFrame, 2, 0, -10, 0, icbg)
	ItemButton.bubg = bubg

	hooksecurefunc("ItemUpgradeFrame_Update", Reskin_ItemUpgradeFrame)

	if DB.isNewPatch then
		B.ReskinDropDown(ItemUpgradeFrame.UpgradeLevelDropDown.DropDownMenu)
	end
end