local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

do
	-- Reskin Garrison Portrait
	local replacedRoleTex = {
		["Adventures-Tank"] = "Soulbinds_Tree_Conduit_Icon_Protect",
		["Adventures-Healer"] = "ui_adv_health",
		["Adventures-DPS"] = "ui_adv_atk",
		["Adventures-DPS-Ranged"] = "Soulbinds_Tree_Conduit_Icon_Utility",
	}

	local function replaceFollowerRole(roleIcon, atlas)
		local newAtlas = replacedRoleTex[atlas]
		if newAtlas then
			roleIcon:SetAtlas(newAtlas)
		end
	end

	function Skins:ReskinFollowerPortrait()
		local levelFrame = self.Level or self.LevelText or self.LevelDisplayFrame
		if levelFrame then
			levelFrame:ClearAllPoints()
			levelFrame:SetPoint("BOTTOM", self, 0, 15)
			if levelFrame.LevelCircle then levelFrame.LevelCircle:Hide() end
		end

		if self.Highlight then self.Highlight:Hide() end
		if self.LevelCircle then self.LevelCircle:Hide() end
		if self.PuckBorder then self.PuckBorder:SetAlpha(0) end
		if self.LevelBorder then self.LevelBorder:SetAlpha(0) end

		local squareBG = B.CreateBDFrame(self.Portrait, 1, -C.mult)
		self.squareBG = squareBG

		if self.Empty then
			self.Empty:SetColorTexture(0, 0, 0, 0)
			self.Empty:SetAllPoints(squareBG)
		end

		if self.PortraitRing then
			self.PortraitRing:Hide()
			self.PortraitRingQuality:SetTexture("")
			self.PortraitRingCover:SetColorTexture(0, 0, 0, 0)
			self.PortraitRingCover:SetAllPoints(squareBG)
		end

		if self.HealthBar then
			self.HealthBar.Border:Hide()

			local roleIcon = self.HealthBar.RoleIcon
			roleIcon:ClearAllPoints()
			roleIcon:SetPoint("CENTER", squareBG, "TOPRIGHT")
			replaceFollowerRole(roleIcon, roleIcon:GetAtlas())
			hooksecurefunc(roleIcon, "SetAtlas", replaceFollowerRole)

			local background = self.HealthBar.Background
			background:SetAlpha(0)
			background:ClearAllPoints()
			background:SetPoint("TOPLEFT", squareBG, "BOTTOMLEFT", C.mult, 6)
			background:SetPoint("BOTTOMRIGHT", squareBG, "BOTTOMRIGHT", -C.mult, C.mult)
			self.HealthBar.Health:SetTexture(DB.normTex)
		end
	end

	function Skins:ReskinFollowerClass(size, point, x, y, relativeTo)
		relativeTo = relativeTo or self:GetParent()

		self:SetSize(size, size)
		self:ClearAllPoints()
		self:SetPoint(point, relativeTo, x, y)
		self:SetTexCoord(.18, .92, .08, .92)

		local bg = B.CreateBDFrame(self)
		return bg
	end

	-- Reskin MerchantItem
	function Skins:ReskinMerchantItem()
		B.StripTextures(self, 0)
		B.CreateBDFrame(self)
		self:SetHeight(44)

		local button = self.ItemButton
		B.StripTextures(button)
		button:ClearAllPoints()
		button:SetPoint("LEFT", self, 4, 0)

		local icbg = B.ReskinIcon(button.icon)
		B.ReskinHighlight(button, icbg)
		B.ReskinBorder(button.IconBorder, icbg)
		button.icbg = icbg

		local frameName = self:GetDebugName()
		local count = _G[frameName.."ItemButtonCount"]
		count:SetJustifyH("RIGHT")
		count:ClearAllPoints()
		count:SetPoint("BOTTOMRIGHT", icbg, "BOTTOMRIGHT", -1, 1)

		local stock = _G[frameName.."ItemButtonStock"]
		stock:SetJustifyH("RIGHT")
		stock:ClearAllPoints()
		stock:SetPoint("TOPRIGHT", icbg, "TOPRIGHT", -1, -1)

		local name = _G[frameName.."Name"]
		name:SetWidth(105)
		name:SetFontObject(Game12Font)
		name:SetWordWrap(true)
		name:SetJustifyH("LEFT")
		name:ClearAllPoints()
		name:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 4, 3)

		local money = _G[frameName.."MoneyFrame"]
		money:ClearAllPoints()
		money:SetPoint("BOTTOMLEFT", icbg, "BOTTOMRIGHT", 4, 4)
	end

	-- Reskin SearchBox
	function Skins:ReskinSearchBox()
		B.StripTextures(self)
		B.CleanTextures(self)

		local bg = B.CreateBDFrame(self, 0, 1)
		B.ReskinHighlight(self, bg, true)

		local icon = self.icon or self.Icon
		if icon then B.ReskinIcon(icon) end
	end

	-- Reskin SearchResult
	function Skins:ReskinSearchResult()
		if not self then return end

		local results = self.searchResults
		results:ClearAllPoints()
		results:Point("BOTTOMLEFT", self, "BOTTOMRIGHT", 10, 0)
		B.StripTextures(results, 0)
		B.CleanTextures(results)
		local bg = B.CreateBG(results, 0, 0, 5, 0)

		local frameName = self:GetDebugName()
		local closeButton = results.closeButton or (frameName and _G[frameName.."SearchResultsCloseButton"])
		B.ReskinClose(closeButton, bg)

		local bar = results.scrollFrame.scrollBar
		if bar then B.ReskinScroll(bar) end

		for i = 1, 9 do
			local button = results.scrollFrame.buttons[i]
			if button and not button.styled then
				B.StripTextures(button)

				local icbg = B.ReskinIcon(button.icon)
				button.icon.SetTexCoord = B.Dummy

				local bubg = B.CreateBGFrame(button, 2, 2, -2, -2, icbg)
				B.ReskinHighlight(button, bubg, true)

				local name = button.name
				name:ClearAllPoints()
				name:SetPoint("TOPLEFT", bubg, 4, -6)

				local path = button.path
				path:ClearAllPoints()
				path:SetPoint("BOTTOMLEFT", bubg, 4, 4)

				local type = button.resultType
				type:ClearAllPoints()
				type:SetPoint("RIGHT", bubg, -2, 0)

				button.styled = true
			end
		end
	end

	-- Reskin SortButton
	function Skins:ReskinSortButton()
		B.ReskinButton(self)
		B.ReskinHighlight(self, self)

		self:SetSize(26, 26)
		self:SetNormalTexture("Interface\\Icons\\INV_Pet_Broom")
		self:SetPushedTexture("Interface\\Icons\\INV_Pet_Broom")
	end

	-- Reskin RequiredMoneyText Color
	function Skins:ReskinRMTColor(r)
		if r == 0 then
			B.ReskinText(self, 1, 0, 0)
		elseif r == .2 then
			B.ReskinText(self, 0, 1, 0)
		end
	end

	-- Reskin Tutorial Button
	function Skins:ReskinTutorialButton(parent)
		self.Ring:Hide()
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", parent, "TOPLEFT", -12, 12)
	end

	function Skins:ReplaceIconString(text)
		if not text then text = self:GetText() end
		if not text or text == "" then return end

		local newText, count = gsub(text, "|T([^:]-):[%d+:]+|t", "|T%1:14:14:0:0:64:64:5:59:5:59|t")
		if count > 0 then self:SetFormattedText("%s", newText) end
	end
end

-- Update Function
do
	-- Update MerchantInfo
	function Skins.UpdateMerchantInfo()
		local numItems = GetMerchantNumItems()
		for i = 1, MERCHANT_ITEMS_PER_PAGE do
			local index = (MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE + i
			if index > numItems then return end

			local item = _G["MerchantItem"..i]
			local frameName = item:GetDebugName()
			local name = _G[frameName.."Name"]
			local button = _G[frameName.."ItemButton"]
			local money = _G[frameName.."MoneyFrame"]
			local currency = _G[frameName.."AltCurrencyFrame"]

			if button and button:IsShown() then
				money:ClearAllPoints()
				if name:GetNumLines() > 1 then
					money:SetPoint("BOTTOMLEFT", button.icbg, "BOTTOMRIGHT", 4, -1)
				else
					money:SetPoint("BOTTOMLEFT", button.icbg, "BOTTOMRIGHT", 4, 4)
				end

				currency:ClearAllPoints()
				if money:IsShown() then
					currency:SetPoint("LEFT", money, "RIGHT", -10, 0)
				else
					currency:SetPoint("LEFT", money, "LEFT", 0, 0)
				end
			end
		end
	end

	-- Update PortraitColor
	function Skins:UpdateFollowerQuality()
		if not self.quality or not self.squareBG then return end

		local r, g, b = GetItemQualityColor(self.quality or 1)
		self.squareBG:SetBackdropBorderColor(r, g, b)
	end

	function Skins:UpdateTabAnchor()
		local frameName = self:GetDebugName()
		local text = self.Text or (frameName and _G[frameName.."Text"])
		if text then
			text:SetJustifyH("CENTER")
			text:ClearAllPoints()
			text:SetPoint("CENTER")
		end
	end

	hooksecurefunc("PanelTemplates_SelectTab", Skins.UpdateTabAnchor)
	hooksecurefunc("PanelTemplates_DeselectTab", Skins.UpdateTabAnchor)
end
