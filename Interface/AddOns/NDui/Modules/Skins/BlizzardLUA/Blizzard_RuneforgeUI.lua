local _, ns = ...
local B, C, L, DB = unpack(ns)
local TT = B:GetModule("Tooltip")

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local function Reskin_RefreshCurrencyDisplay(self)
	if not self.CurrencyDisplay.currencyFramePool then return end

	for currencyFrame in self.CurrencyDisplay.currencyFramePool:EnumerateActive() do
		if currencyFrame and not currencyFrame.hooked then
			B.ReplaceIconString(currencyFrame.Text)

			currencyFrame.hooked = true
		end
	end
end

local function Reskin_RefreshListDisplay(self)
	if not self.elements then return end

	for i = 1, self:GetNumElementFrames() do
		local button = self.elements[i]
		if button and not button.icbg then
			B.StripTextures(button, 1)
			button.icbg = B.ReskinIcon(button.Icon)
		end

		button.icbg:SetShown(button.Icon:IsShown())
	end
end

local function Reskin_GenerateSelections(self)
	if not self.selectionPool then return end

	for button in self.selectionPool:EnumerateActive() do
		if button then
			button.IconBorder:Hide()

			if not button.icbg then
				B.StripTextures(button, 1)

				button.icbg = B.ReskinIcon(button.icon)
			end

			local atlas = button.StateTexture:GetAtlas()
			if atlas == "runecarving-menu-reagent-selected" or atlas == "runecarving-menu-reagent-selectedother" then
				button.icbg:SetBackdropBorderColor(cr, cg, cb)
			else
				button.icbg:SetBackdropBorderColor(0, 0, 0)
			end
		end
	end
end

local function replaceCurrencyDisplay(self)
	if not self.currencyID then return end

	local text = GetCurrencyString(self.currencyID, self.amount, self.colorCode, self.abbreviate)
	local newText, count = gsub(text, "|T([^:]-):[%d+:]+|t", "|T%1:14:14:0:0:64:64:5:59:5:59|t")
	if count > 0 then self:SetText(newText) end
end

local function Updat_SetCurrencies(self)
	if not self.currencyFramePool then return end

	for frame in self.currencyFramePool:EnumerateActive() do
		if frame and not frame.hooked then
			replaceCurrencyDisplay(frame)
			hooksecurefunc(frame, "SetCurrencyFromID", replaceCurrencyDisplay)

			frame.hooked = true
		end
	end
end

C.OnLoadThemes["Blizzard_RuneforgeUI"] = function()
	local frame = RuneforgeFrame
	B.ReskinClose(frame.CloseButton, frame, -70, -70)
	TT.ReskinTooltip(frame.ResultTooltip)
	hooksecurefunc(frame.CurrencyDisplay, "SetCurrencies", Updat_SetCurrencies)

	local createFrame = frame.CreateFrame
	B.ReskinButton(createFrame.CraftItemButton)
	hooksecurefunc(createFrame.Cost.Currencies, "SetCurrencies", Updat_SetCurrencies)

	local powerFrame = frame.CraftingFrame.PowerFrame
	B.StripTextures(powerFrame)
	B.CreateBG(powerFrame)
	hooksecurefunc(powerFrame.PowerList, "RefreshListDisplay", Reskin_RefreshListDisplay)

	local pageControl = powerFrame.PageControl
	B.ReskinArrow(pageControl.BackwardButton, "left")
	B.ReskinArrow(pageControl.ForwardButton, "right")

	local selector = frame.CraftingFrame.ModifierFrame.Selector
	B.StripTextures(selector)
	B.CreateBG(selector)
	hooksecurefunc(selector, "GenerateSelections", Reskin_GenerateSelections)
end