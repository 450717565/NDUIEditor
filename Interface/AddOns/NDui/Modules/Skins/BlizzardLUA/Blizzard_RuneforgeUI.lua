local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")
local TT = B:GetModule("Tooltip")

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local function Reskin_RefreshCurrencyDisplay(self)
	for currencyFrame in self.CurrencyDisplay.currencyFramePool:EnumerateActive() do
		if not currencyFrame.hooked then
			S.ReplaceIconString(currencyFrame.Text)

			currencyFrame.hooked = true
		end
	end
end

local function Reskin_RefreshListDisplay(self)
	if not self.elements then return end

	for i = 1, self:GetNumElementFrames() do
		local button = self.elements[i]
		if button then
			if not button.icbg then
				button.Border:SetAlpha(0)
				button.CircleMask:Hide()
				button.SelectedTexture:SetAlpha(0)
				button.icbg = B.ReskinIcon(button.Icon)
			end

			if button.SelectedTexture and button.SelectedTexture:IsShown() then
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
	if self.currencyFramePool then
		for frame in self.currencyFramePool:EnumerateActive() do
			if not frame.hooked then
				replaceCurrencyDisplay(frame)
				hooksecurefunc(frame, "SetCurrencyFromID", replaceCurrencyDisplay)

				frame.hooked = true
			end
		end
	end
end

C.LUAThemes["Blizzard_RuneforgeUI"] = function()
	local frame = RuneforgeFrame
	B.ReskinClose(frame.CloseButton, frame, -70, -70)
	TT.ReskinTooltip(frame.ResultTooltip)

	local createFrame = frame.CreateFrame
	B.ReskinButton(createFrame.CraftItemButton)

	if not DB.isNewPatch then
		S.ReplaceIconString(createFrame.Cost.Text)
	else
		hooksecurefunc(frame.CurrencyDisplay, "SetCurrencies", Updat_SetCurrencies)
		hooksecurefunc(createFrame.Cost.Currencies, "SetCurrencies", Updat_SetCurrencies)
	end

	local powerFrame = frame.CraftingFrame.PowerFrame
	B.ReskinFrame(powerFrame)
	hooksecurefunc(powerFrame.PowerList, "RefreshListDisplay", Reskin_RefreshListDisplay)

	local pageControl = powerFrame.PageControl
	B.ReskinArrow(pageControl.BackwardButton, "left")
	B.ReskinArrow(pageControl.ForwardButton, "right")

	local selector = frame.CraftingFrame.ModifierFrame.Selector
	B.ReskinFrame(selector)
end