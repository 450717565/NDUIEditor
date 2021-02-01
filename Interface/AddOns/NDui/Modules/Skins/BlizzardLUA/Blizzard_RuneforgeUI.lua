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

C.LUAThemes["Blizzard_RuneforgeUI"] = function()
	local frame = RuneforgeFrame
	B.ReskinClose(frame.CloseButton, frame, -70, -70)
	TT.ReskinTooltip(frame.ResultTooltip)
	hooksecurefunc(frame, "RefreshCurrencyDisplay", Reskin_RefreshCurrencyDisplay)

	local createFrame = frame.CreateFrame
	B.ReskinButton(createFrame.CraftItemButton)
	S.ReplaceIconString(createFrame.Cost.Text)

	local powerFrame = frame.CraftingFrame.PowerFrame
	B.ReskinFrame(powerFrame)
	hooksecurefunc(powerFrame.PowerList, "RefreshListDisplay", Reskin_RefreshListDisplay)

	local pageControl = powerFrame.PageControl
	B.ReskinArrow(pageControl.BackwardButton, "left")
	B.ReskinArrow(pageControl.ForwardButton, "right")

	local selector = frame.CraftingFrame.ModifierFrame.Selector
	B.ReskinFrame(selector)
end