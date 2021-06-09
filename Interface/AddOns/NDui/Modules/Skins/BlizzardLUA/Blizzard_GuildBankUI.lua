local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_GuildBankPopupFrame(self)
	self:ClearAllPoints()
	self:SetPoint("TOPLEFT", GuildBankFrame, "TOPRIGHT", 42, 0)

	for i = 1, NUM_GUILDBANK_ICONS_PER_ROW * NUM_GUILDBANK_ICON_ROWS do
		local buttons = "GuildBankPopupButton"..i

		local button = _G[buttons]
		local icon = _G[buttons.."Icon"]

		if button and not button.styled then
			B.StripTextures(button)

			local icbg = B.ReskinIcon(icon)
			B.ReskinCPTex(button, icbg)
			B.ReskinHLTex(button, icbg)

			button.styled = true
		end
	end
end

C.LUAThemes["Blizzard_GuildBankUI"] = function()
	B.ReskinFrame(GuildBankFrame)
	B.ReskinInput(GuildItemSearchBox)

	B.ReskinFrame(GuildBankPopupFrame)
	B.ReskinInput(GuildBankPopupEditBox)

	B.ReskinFrameTab(GuildBankFrame, 4)

	B.StripTextures(GuildBankEmblemFrame, 0)
	B.StripTextures(GuildBankMoneyFrameBackground)

	GuildBankPopupFrame:SetHeight(525)
	GuildBankFrameWithdrawButton:ClearAllPoints()
	GuildBankFrameWithdrawButton:SetPoint("RIGHT", GuildBankFrameDepositButton, "LEFT", -1, 0)

	local buttons = {
		GuildBankFrameWithdrawButton,
		GuildBankFrameDepositButton,
		GuildBankFramePurchaseButton,
		GuildBankPopupOkayButton,
		GuildBankPopupCancelButton,
		GuildBankInfoSaveButton,
	}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end

	local scrolls = {
		GuildBankTransactionsScrollFrameScrollBar,
		GuildBankInfoScrollFrameScrollBar,
		GuildBankPopupScrollFrameScrollBar,
	}
	for _, scroll in pairs(scrolls) do
		B.ReskinScroll(scroll)
	end

	for i = 1, 8 do
		local tabs = "GuildBankTab"..i

		local tab = _G[tabs]
		B.StripTextures(tab)

		local button = _G[tabs.."Button"]
		B.StripTextures(button)
		button:SetSize(32, 32)

		local icon = _G[tabs.."ButtonIconTexture"]
		local icbg = B.ReskinIcon(icon)
		B.ReskinHLTex(button, icbg)
		B.ReskinCPTex(button, icbg)

		if i == 1 then
			tab:ClearAllPoints()
			tab:SetPoint("TOPLEFT", GuildBankFrame, "TOPRIGHT", 1, -25)
		end
	end

	for i = 1, NUM_GUILDBANK_COLUMNS do
		local buttons = "GuildBankColumn"..i

		B.StripTextures(_G[buttons])

		for j = 1, NUM_SLOTS_PER_GUILDBANK_GROUP do
			local button = _G[buttons.."Button"..j]
			B.CleanTextures(button)

			local icbg = B.ReskinIcon(button.icon)
			B.ReskinHLTex(button, icbg)

			local border = button.IconBorder
			B.ReskinBorder(border, icbg)

			local search = button.searchOverlay
			search:SetAllPoints(icbg)
		end
	end

	GuildBankPopupFrame:HookScript("OnShow", Reskin_GuildBankPopupFrame)
end