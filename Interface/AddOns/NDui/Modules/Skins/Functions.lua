local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

local tL, tR, tT, tB = unpack(DB.TexCoord)

do
	-- Reskin Garrison Portrait
	local replacedRoleTex = {
		["Adventures-Tank"] = "Soulbinds_Tree_Conduit_Icon_Protect",
		["Adventures-Healer"] = "ui_adv_health",
		["Adventures-DPS"] = "ui_adv_atk",
		["Adventures-DPS-Ranged"] = "ui_adv_atk",
	}

	local function replaceFollowerRole(roleIcon, atlas)
		local newAtlas = replacedRoleTex[atlas]
		if newAtlas then
			roleIcon:SetAtlas(newAtlas)
		end
	end

	local textures = {
		"Empty",
		"Highlight",
		"LevelBorder",
		"LevelCircle",
		"PortraitRing",
		"PortraitRingCover",
		"PortraitRingQuality",
		"PuckBorder",
		"TroopStackBorder1",
		"TroopStackBorder2",
	}

	function Skins:ReskinFollowerPortrait()
		local squareBG = B.CreateBDFrame(self.Portrait, 1, -C.mult, true)
		self.squareBG = squareBG

		for _, name in pairs(textures) do
			local tex = self[name]
			if tex then
				tex:SetAlpha(0)
				tex:SetTexture("")
			end
		end

		local levelFrame = self.Level or self.LevelText or self.LevelDisplayFrame
		if levelFrame then
			levelFrame:ClearAllPoints()
			levelFrame:SetPoint("BOTTOM", self, 0, 15)

			if levelFrame.LevelCircle then
				levelFrame.LevelCircle:SetAlpha(0)
			end
		end

		if self.HealthBar then
			self.HealthBar.Border:SetAlpha(0)
			self.HealthBar.Health:SetTexture(DB.normTex)
			self.HealthBar.HealthValue:ClearAllPoints()
			self.HealthBar.HealthValue:SetPoint("CENTER", self.HealthBar, "CENTER")

			local roleIcon = self.HealthBar.RoleIcon
			roleIcon:ClearAllPoints()
			roleIcon:SetPoint("CENTER", squareBG, "TOPRIGHT")
			replaceFollowerRole(roleIcon, roleIcon:GetAtlas())
			hooksecurefunc(roleIcon, "SetAtlas", replaceFollowerRole)

			local backGround = self.HealthBar.Background
			backGround:SetAlpha(0)
			backGround:ClearAllPoints()
			backGround:SetPoint("TOPLEFT", squareBG, "BOTTOMLEFT", C.mult, 6)
			backGround:SetPoint("BOTTOMRIGHT", squareBG, "BOTTOMRIGHT", -C.mult, C.mult)
		end
	end

	function Skins:ReskinFollowerClass(size, point, x, y, relativeTo)
		relativeTo = relativeTo or self:GetParent()

		self:SetSize(size, size)
		self:ClearAllPoints()
		self:SetPoint(point, relativeTo, x, y)
		self:SetTexCoord(.18, .92, .08, .92)

		local bg = B.CreateBDFrame(self, 0, -C.mult)
		return bg
	end

	-- Reskin MerchantItem
	function Skins:ReskinMerchantItem()
		B.StripTextures(self, 0)
		B.CreateBDFrame(self)
		self:SetHeight(44)

		local button = B.GetObject(self, "ItemButton")
		B.StripTextures(button)
		button:ClearAllPoints()
		button:SetPoint("LEFT", self, 4, 0)

		local icbg = B.ReskinIcon(button.icon)
		B.ReskinHLTex(button, icbg)
		B.ReskinBorder(button.IconBorder, icbg)
		button.icbg = icbg

		local count = B.GetObject(self, "ItemButtonCount")
		count:SetJustifyH("RIGHT")
		count:ClearAllPoints()
		count:SetPoint("BOTTOMRIGHT", icbg, "BOTTOMRIGHT", 0, 1)

		local stock = B.GetObject(self, "ItemButtonStock")
		stock:SetJustifyH("RIGHT")
		stock:ClearAllPoints()
		stock:SetPoint("TOPRIGHT", icbg, "TOPRIGHT", 0, -1)

		local name = B.GetObject(self, "Name")
		name:SetWidth(105)
		name:SetFontObject(Game12Font)
		name:SetWordWrap(true)
		name:SetJustifyH("LEFT")
		name:ClearAllPoints()
		name:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 4, 3)

		local money = B.GetObject(self, "MoneyFrame")
		money:ClearAllPoints()
		money:SetPoint("BOTTOMLEFT", icbg, "BOTTOMRIGHT", 4, 4)
	end

	-- Reskin SearchBox
	function Skins:ReskinSearchBox()
		B.StripTextures(self)
		B.CleanTextures(self)

		local bg = B.CreateBDFrame(self, 0, 1)
		B.ReskinHLTex(self, bg, true)

		local icon = self.icon or self.Icon
		if icon then B.ReskinIcon(icon) end
	end

	-- Reskin SearchResult
	function Skins:ReskinSearchResult()
		if not self then return end

		local results = self.searchResults
		results:ClearAllPoints()
		results:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", 10, 0)
		B.StripTextures(results, 0)
		B.CleanTextures(results)
		local bg = B.CreateBG(results, 0, 0, 5, 0)

		local closeButton = results.closeButton or B.GetObject(self, "SearchResultsCloseButton")
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
				B.ReskinHLTex(button, bubg, true)

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

	function Skins:ReskinOptions()
		for _, name in pairs(self) do
			local panel = _G[name]
			if panel then
				local children = {panel:GetChildren()}
				for _, child in pairs(children) do
					if child:IsObjectType("CheckButton") then
						B.ReskinCheck(child)
					elseif child:IsObjectType("Button") then
						B.ReskinButton(child)
					elseif child:IsObjectType("Slider") then
						B.ReskinSlider(child)
					elseif child:IsObjectType("Frame") and child.Left and child.Middle and child.Right then
						B.ReskinDropDown(child)
					end
				end
			else
				if DB.isDeveloper then print(name, "not found.") end
			end
		end
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

	-- Replace Icon String
	function Skins:FormatIconString(text)
		if not text then text = self:GetText() end
		if not text or text == "" then return end

		local newText, count = gsub(text, "|T([^:]-):[%d+:]+|t", "|T%1:14:14:0:0:64:64:5:59:5:59|t")
		if count > 0 then self:SetFormattedText("%s", newText) end
	end

	function Skins:ReplaceIconString()
		Skins.FormatIconString(self)
		hooksecurefunc(self, "SetText", Skins.FormatIconString)
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
			local name = B.GetObject(item, "Name")
			local money = B.GetObject(item, "MoneyFrame")
			local button = B.GetObject(item, "ItemButton")
			local currency = B.GetObject(item, "AltCurrencyFrame")

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

			local link = GetMerchantItemLink(index)
			if link then
				local classID = select(12, GetItemInfo(link))
				if classID and classID == LE_ITEM_CLASS_QUESTITEM then
					name:SetTextColor(1, 1, 0)
					button.icbg:SetBackdropBorderColor(1, 1, 0)
				end
			end
		end
	end

	-- Update PortraitColor
	function Skins:UpdateFollowerQuality()
		if not self.quality or not self.squareBG then return end

		local r, g, b = B.GetQualityColor(quality)
		self.squareBG:SetBackdropBorderColor(r, g, b)
	end

	function Skins:UpdateTabAnchor()
		local text = B.GetObject(self, "Text")
		if text then
			text:SetJustifyH("CENTER")
			text:ClearAllPoints()
			text:SetPoint("CENTER")
		end
	end

	hooksecurefunc("PanelTemplates_SelectTab", Skins.UpdateTabAnchor)
	hooksecurefunc("PanelTemplates_DeselectTab", Skins.UpdateTabAnchor)
end