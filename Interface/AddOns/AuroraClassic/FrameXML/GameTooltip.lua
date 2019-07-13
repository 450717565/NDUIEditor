local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinClose(ItemRefCloseButton)
	F.ReskinClose(FloatingBattlePetTooltip.CloseButton)
	F.ReskinClose(FloatingPetBattleAbilityTooltip.CloseButton)

	if not AuroraConfig.tooltips then return end

	hooksecurefunc("GameTooltip_SetBackdropStyle", function(self)
		if not self.auroraTip then return end
		self:SetBackdrop(nil)
	end)

	local tooltips = {
		ChatMenu,
		EmoteMenu,
		LanguageMenu,
		VoiceMacroMenu,
		GameTooltip,
		EmbeddedItemTooltip,
		ItemRefTooltip,
		ItemRefShoppingTooltip1,
		ItemRefShoppingTooltip2,
		ShoppingTooltip1,
		ShoppingTooltip2,
		AutoCompleteBox,
		FriendsTooltip,
		GeneralDockManagerOverflowButtonList,
		ReputationParagonTooltip,
		NamePlateTooltip,
		QueueStatusFrame,
		BattlePetTooltip,
		PetBattlePrimaryAbilityTooltip,
		PetBattlePrimaryUnitTooltip,
		FloatingBattlePetTooltip,
		FloatingPetBattleAbilityTooltip,
		IMECandidatesFrame,
	}
	for _, tooltip in pairs(tooltips) do
		F.ReskinTooltip(tooltip)
	end

	C_Timer.After(5, function()
		if LibDBIconTooltip then
			F.ReskinTooltip(LibDBIconTooltip)
		end
	end)

	local StatusBar = _G["GameTooltipStatusBar"]
	StatusBar:ClearAllPoints()
	StatusBar:SetPoint("BOTTOMLEFT", _G["GameTooltip"], "TOPLEFT", 0, 5)
	StatusBar:SetPoint("BOTTOMRIGHT", _G["GameTooltip"], "TOPRIGHT", 0, 5)
	StatusBar:SetHeight(5)
	F.ReskinStatusBar(StatusBar)

	PetBattlePrimaryUnitTooltip.Delimiter:SetColorTexture(0, 0, 0)
	PetBattlePrimaryUnitTooltip.Delimiter:SetHeight(C.mult)
	PetBattlePrimaryAbilityTooltip.Delimiter1:SetHeight(C.mult)
	PetBattlePrimaryAbilityTooltip.Delimiter1:SetColorTexture(0, 0, 0)
	PetBattlePrimaryAbilityTooltip.Delimiter2:SetHeight(C.mult)
	PetBattlePrimaryAbilityTooltip.Delimiter2:SetColorTexture(0, 0, 0)
	FloatingPetBattleAbilityTooltip.Delimiter1:SetHeight(C.mult)
	FloatingPetBattleAbilityTooltip.Delimiter1:SetColorTexture(0, 0, 0)
	FloatingPetBattleAbilityTooltip.Delimiter2:SetHeight(C.mult)
	FloatingPetBattleAbilityTooltip.Delimiter2:SetColorTexture(0, 0, 0)
	FloatingBattlePetTooltip.Delimiter:SetColorTexture(0, 0, 0)
	FloatingBattlePetTooltip.Delimiter:SetHeight(C.mult)

	-- Tooltip rewards icon
	local function updateBackdropColor(self, r, g, b)
		self:GetParent().bg:SetBackdropBorderColor(r, g, b)
	end

	local function resetBackdropColor(self)
		self:GetParent().bg:SetBackdropBorderColor(0, 0, 0)
	end

	local function reskinRewardIcon(self)
		self.Icon:SetTexCoord(.08, .92, .08, .92)
		self.bg = F.CreateBDFrame(self.Icon)

		local iconBorder = self.IconBorder
		iconBorder:SetAlpha(0)
		hooksecurefunc(iconBorder, "SetVertexColor", updateBackdropColor)
		hooksecurefunc(iconBorder, "Hide", resetBackdropColor)
	end

	reskinRewardIcon(GameTooltip.ItemTooltip)
	reskinRewardIcon(EmbeddedItemTooltip.ItemTooltip)

	-- Other addons
	local listener = CreateFrame("Frame")
	listener:RegisterEvent("ADDON_LOADED")
	listener:SetScript("OnEvent", function(_, _, addon)
		if addon == "MethodDungeonTools" then
			local styledMDT
			hooksecurefunc(MethodDungeonTools, "ShowInterface", function()
				if not styledMDT then
					F.ReskinTooltip(MethodDungeonTools.tooltip)
					F.ReskinTooltip(MethodDungeonTools.pullTooltip)
					styledMDT = true
				end
			end)
		elseif addon == "BattlePetBreedID" then
			hooksecurefunc("BPBID_SetBreedTooltip", function(parent)
				if parent == FloatingBattlePetTooltip then
					F.ReskinTooltip(BPBID_BreedTooltip2)
				else
					F.ReskinTooltip(BPBID_BreedTooltip)
				end
			end)
		end
	end)
end)