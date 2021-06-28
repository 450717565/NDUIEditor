local _, ns = ...
local B, C, L, DB = unpack(ns)

local tL, tR, tT, tB = unpack(DB.TexCoord)

-- Reskin Function
do
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
		"CircleMask",
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

	function B:ReskinFollowerPortrait()
		local portrait = self.Portrait

		local point, _, _, xOfs, yOfs = portrait:GetPoint()
		portrait:ClearAllPoints()
		if point == "CENTER" then
			portrait:SetPoint("CENTER", self, "CENTER")
		elseif B.Round(xOfs) == 6 and B.Round(yOfs) == -8 then
			portrait:SetInside(self, 4, 8)
		else
			portrait:SetInside(self, 2, 2)
		end

		local squareBG = B.CreateBDFrame(portrait, 1, -C.mult, true)
		squareBG:SetBackdropColor(5/255, 12/255, 30/255, 1)
		self.squareBG = squareBG

		for _, name in pairs(textures) do
			local tex = B.GetObject(self, name)
			if tex then
				tex:SetTexture("")
				tex:SetAlpha(0)
				tex:Hide()
			end
		end

		local levelFrame = self.Level or self.LevelText or self.LevelDisplayFrame
		if levelFrame then
			levelFrame:ClearAllPoints()
			levelFrame:SetPoint("BOTTOM", squareBG, "BOTTOM", 0, 5)

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

	function B:ReskinFollowerClass(size, point, x, y, relativeTo)
		relativeTo = relativeTo or self:GetParent()

		self:SetSize(size, size)
		self:ClearAllPoints()
		self:SetPoint(point, relativeTo, x, y)
		self:SetTexCoord(.18, .92, .08, .92)

		local bg = B.CreateBDFrame(self, 0, -C.mult)
		return bg
	end

	function B:ReskinMerchantItem()
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

	function B:ReskinSearchBox()
		B.StripTextures(self)
		B.CleanTextures(self)

		local bg = B.CreateBDFrame(self, 0, 1)
		B.ReskinHLTex(self, bg, true)

		local icon = self.icon or self.Icon
		if icon then B.ReskinIcon(icon) end
	end

	function B:ReskinSearchResult()
		if not self then return end

		local results = self.searchResults
		results:ClearAllPoints()
		results:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", 10, 0)
		B.StripTextures(results, 0)
		B.CleanTextures(results)
		local bg = B.CreateBG(results, 0, 0, 5, 0)

		local closeButton = B.GetObject(results, "closeButton") or B.GetObject(self, "SearchResultsCloseButton")
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

	function B:ReskinOptions()
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

	function B:ReskinRMTColor(r)
		if r == 0 then
			B.ReskinText(self, 1, 0, 0)
		elseif r == .2 then
			B.ReskinText(self, 0, 1, 0)
		end
	end

	function B:ReskinTutorialButton(parent)
		self.Ring:Hide()
		B.UpdatePoint(self, "TOPLEFT", parent, "TOPLEFT", -12, 12)
	end

	function B:FormatIconString(text)
		if not text then text = self:GetText() end
		if not text or text == "" then return end

		local newText, count = gsub(text, "|T([^:]-):[%d+:]+|t", "|T%1:14:14:0:0:64:64:5:59:5:59|t")
		if count > 0 then self:SetFormattedText("%s", newText) end
	end

	function B:ReplaceIconString()
		B.FormatIconString(self)
		hooksecurefunc(self, "SetText", B.FormatIconString)
	end

	function B:ReskinFont(size)
		local oldSize = select(2, self:GetFont())
		size = size or oldSize

		local fontSize = size*C.db["Skins"]["FontScale"]
		self:SetFont(DB.Font[1], fontSize, DB.Font[3])
		self:SetShadowColor(0, 0, 0, 0)
	end
end

-- Update Function
do
	function B.UpdateMerchantInfo()
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

	function B:UpdateFollowerQuality()
		if not self.quality or not self.squareBG then return end

		local r, g, b = B.GetQualityColor(quality)
		self.squareBG:SetBackdropBorderColor(r, g, b)
	end

	function B:UpdateTabAnchor()
		local text = B.GetObject(self, "Text")
		if text then
			text:SetJustifyH("CENTER")
			text:ClearAllPoints()
			text:SetPoint("CENTER")
		end
	end

	hooksecurefunc("PanelTemplates_SelectTab", B.UpdateTabAnchor)
	hooksecurefunc("PanelTemplates_DeselectTab", B.UpdateTabAnchor)
end

-- Skin Function
do
	function B.GetToggleDirection()
		local direc = C.db["Skins"]["ToggleDirection"]
		if direc == 1 then
			return "|", "|", "RIGHT", "LEFT", -2, 0, 20, 80
		elseif direc == 2 then
			return "|", "|", "LEFT", "RIGHT", 2, 0, 20, 80
		elseif direc == 3 then
			return "—", "—", "BOTTOM", "TOP", 0, 2, 80, 20
		else
			return "—", "—", "TOP", "BOTTOM", 0, -2, 80, 20
		end
	end

	local toggleFrames = {}

	local function CreateToggleButton(parent)
		local bu = CreateFrame("Button", nil, parent)
		bu:SetSize(20, 80)
		bu.text = B.CreateFS(bu, 18, nil, true)
		B.ReskinButton(bu, true)

		return bu
	end

	function B:CreateToggle()
		local close = CreateToggleButton(self)
		self.closeButton = close

		local open = CreateToggleButton(UIParent)
		open:Hide()
		self.openButton = open

		open:SetScript("OnClick", function()
			open:Hide()
		end)
		close:SetScript("OnClick", function()
			open:Show()
		end)

		B.SetToggleDirection(self)
		tinsert(toggleFrames, self)

		return open, close
	end

	function B:SetToggleDirection()
		local str1, str2, rel1, rel2, x, y, width, height = B.GetToggleDirection()
		local parent = self.bg
		local close = self.closeButton
		local open = self.openButton
		close:ClearAllPoints()
		close:SetPoint(rel1, parent, rel2, x, y)
		close:SetSize(width, height)
		close.text:SetText(str1)
		open:ClearAllPoints()
		open:SetPoint(rel1, parent, rel1, -x, -y)
		open:SetSize(width, height)
		open.text:SetText(str2)

		if C.db["Skins"]["ToggleDirection"] == 5 then
			close:SetAlpha(0)
			close:EnableMouse(false)
			open:SetAlpha(0)
			open:EnableMouse(false)
		else
			close:SetAlpha(1)
			close:EnableMouse(true)
			open:SetAlpha(1)
			open:EnableMouse(true)
		end
	end

	function B.RefreshToggleDirection()
		for _, frame in pairs(toggleFrames) do
			B.SetToggleDirection(frame)
		end
	end
end