local B, C, L, DB = unpack(select(2, ...))
local module = NDui:RegisterModule("Bags")
local cargBags = NDui.cargBags

function module:OnLogin()
	if not NDuiDB["Bags"]["Enable"] then return end

	local Bags = cargBags:NewImplementation("Bags")
	Bags:RegisterBlizzard()
	local f = {}

	local function highlightFunction(button, match)
		button:SetAlpha(match and 1 or .3)
	end

	function Bags:OnInit()
		local onlyBags = function(item) return item.bagID >= 0 and item.bagID <= 4 end
		local onlyBank = function(item) return item.bagID == -1 or item.bagID >= 5 and item.bagID <= 11 end
		local onlyReagent = function(item) return item.bagID == -3 end
		local MyContainer = Bags:GetContainerClass()

		f.main = MyContainer:New("Main", {
			Columns = NDuiDB["Bags"]["BagsWidth"],
			Scale = NDuiDB["Bags"]["BagsScale"],
			Bags = "bags",
			Movable = true,
		})
		f.main:SetFilter(onlyBags, true)
		f.main:SetPoint("RIGHT", -70, -100)

		f.bank = MyContainer:New("Bank", {
			Columns = NDuiDB["Bags"]["BankWidth"],
			Scale = NDuiDB["Bags"]["BagsScale"],
			Bags = "bank",
			Movable = true,
		})
		f.bank:SetFilter(onlyBank, true)
		f.bank:SetPoint("BOTTOMRIGHT", f.main, "BOTTOMLEFT", -20, 0)
		f.bank:Hide()

		f.reagent = MyContainer:New("Reagent", {
			Columns = NDuiDB["Bags"]["BankWidth"],
			Scale = NDuiDB["Bags"]["BagsScale"],
			Bags = "bankreagent",
			Movable = true,
		})
		f.reagent:SetFilter(onlyReagent, true)
		f.reagent:SetPoint("BOTTOMLEFT", f.bank)
		f.reagent:Hide()
	end

	function Bags:OnBankOpened()
		BankFrame:Show()
		self:GetContainer("Bank"):Show()
	end

	function Bags:OnBankClosed()
		BankFrame.selectedTab = 1
		BankFrame:Hide()
		self:GetContainer("Bank"):Hide()
		self:GetContainer("Reagent"):Hide()
		ReagentBankFrame:Hide()
	end

	local MyButton = Bags:GetItemButtonClass()
	MyButton:Scaffold("Default")

	local iconSize = NDuiDB["Bags"]["IconSize"]
	function MyButton:OnCreate()
		self:SetNormalTexture(nil)
		self:SetPushedTexture(nil)
		self:GetHighlightTexture():SetColorTexture(1, 1, 1, .3)
		self:SetSize(iconSize, iconSize)
		self:SetFrameLevel(3)

		self.Icon:SetAllPoints()
		self.Icon:SetTexCoord(unpack(DB.TexCoord))
		self.Count:SetPoint("BOTTOMRIGHT", 0, 0)
		self.Count:SetFont(unpack(DB.Font))

		self.Border = CreateFrame("Frame", nil, self)
		self.Border:SetPoint("TOPLEFT", -1.2, 1.2)
		self.Border:SetPoint("BOTTOMRIGHT", 1.2, -1.2)
		self.Border:SetBackdrop({ bgFile = DB.bdTex	})
		self.Border:SetBackdropColor(0, 0, 0, 0)
		self.Border:SetFrameLevel(2)

		self.BG = CreateFrame("Frame", nil, self)
		self.BG:SetPoint("TOPLEFT", -1.2, 1.2)
		self.BG:SetPoint("BOTTOMRIGHT", 1.2, -1.2)
		self.BG:SetBackdrop({
			bgFile = DB.bdTex, edgeFile = DB.bdTex, edgeSize = 1.2,
		})
		self.BG:SetBackdropColor(.2, .2, .2, .5)
		self.BG:SetBackdropBorderColor(0, 0, 0, 1)
		self.BG:SetFrameLevel(0)

		self.Junk = self:CreateTexture(nil, "ARTWORK")
		self.Junk:SetAtlas("bags-junkcoin")
		self.Junk:SetSize(20, 20)
		self.Junk:SetPoint("TOPRIGHT", 1, 0)

		self.Quest = B.CreateFS(self, 30, "!", false, "LEFT", 3, 0)
		self.Quest:SetTextColor(1, .8, 0)

		if NDuiDB["Bags"]["Artifact"] then
			self.Artifact = self:CreateTexture(nil, "ARTWORK")
			self.Artifact:SetAtlas("collections-icon-favorites")
			self.Artifact:SetSize(35, 35)
			self.Artifact:SetPoint("TOPLEFT", -12, 10)
		end

		if NDuiDB["Bags"]["BagsiLvl"] or NDuiDB["Bags"]["SlotInfo"] then
			self.iLvl = B.CreateFS(self, 12, "", false, "BOTTOMRIGHT", 0, 0)
			self.SlotInfo = B.CreateFS(self, 12, "", false, "TOPLEFT", 1, -2)
		end

		if NDuiDB["Bags"]["NewItemGlow"] then
			local flash = self:CreateTexture(nil, "ARTWORK")
			flash:SetTexture(DB.newItemFlash)
			flash:SetPoint("TOPLEFT", -20, 20)
			flash:SetPoint("BOTTOMRIGHT", 20, -20)
			flash:SetBlendMode("ADD")
			flash:SetAlpha(0)
			local anim = flash:CreateAnimationGroup()
			anim:SetLooping("REPEAT")
			anim.rota = anim:CreateAnimation("Rotation")
			anim.rota:SetDuration(1)
			anim.rota:SetDegrees(-90)
			anim.fader = anim:CreateAnimation("Alpha")
			anim.fader:SetFromAlpha(0)
			anim.fader:SetToAlpha(.8)
			anim.fader:SetDuration(.5)
			anim.fader:SetSmoothing("OUT")
			anim.fader2 = anim:CreateAnimation("Alpha")
			anim.fader2:SetStartDelay(.5)
			anim.fader2:SetFromAlpha(.8)
			anim.fader2:SetToAlpha(0)
			anim.fader2:SetDuration(.8)
			anim.fader2:SetSmoothing("OUT")
			self:HookScript("OnHide", function() if anim:IsPlaying() then anim:Stop() end end)

			self.anim = anim
		end

		if NDuiDB["Bags"]["PreferPower"] > 1 then
			local protect = self:CreateTexture(nil, "ARTWORK")
			protect:SetTexture("Interface\\PETBATTLES\\DeadPetIcon")
			protect:SetAllPoints()
			protect:SetAlpha(0)
			self.powerProtect = protect
		end
	end

	local function isPowerInWrongSpec()
		if NDuiDB["Bags"]["PreferPower"] == 1 then return end
		local spec = GetSpecialization()
		if spec and spec + 1 ~= NDuiDB["Bags"]["PreferPower"] then
			return true
		end
	end

	function MyButton:OnUpdate(item)
		local rarity = item.rarity
		local color = BAG_ITEM_QUALITY_COLORS[rarity]
		self.Junk:SetAlpha(0)
		self.Quest:SetAlpha(0)

		if item.questID and not item.questActive then
			self.Border:SetBackdropColor(.8, .8, 0, 1)
			self.Quest:SetAlpha(1)
		elseif item.questID or item.isQuestItem then
			self.Border:SetBackdropColor(.8, .8, 0, 1)
		elseif rarity then
			if rarity > 0 and color then
				self.Border:SetBackdropColor(color.r, color.g, color.b, 1)
			else
				self.Border:SetBackdropColor(0, 0, 0, 0)
			end

			if rarity == LE_ITEM_QUALITY_POOR and item.sellPrice > 0 then
				self.Junk:SetAlpha(1)
			end
		else
			self.Border:SetBackdropColor(0, 0, 0, 0)
		end

		self.ShowNewItems = NDuiDB["Bags"]["NewItemGlow"]

		if NDuiDB["Bags"]["Artifact"] then
			self.Artifact:SetAlpha(0)
			if (rarity and rarity == LE_ITEM_QUALITY_ARTIFACT) or (item.id and item.id == 138019) then
				self.Artifact:SetAlpha(1)
			end
		end

		if NDuiDB["Bags"]["BagsiLvl"] or NDuiDB["Bags"]["SlotInfo"] then
			self.iLvl:SetText("")
			self.SlotInfo:SetText("")
			local link = GetContainerItemLink(item.bagID, item.slotID)
			if link
			and (rarity and rarity > 1)
			and ((item.level and item.level > 0) and (item.subType == EJ_LOOT_SLOT_FILTER_ARTIFACT_RELIC or (item.equipLoc ~= "" and item.equipLoc ~= "INVTYPE_TABARD" and item.equipLoc ~= "INVTYPE_BODY")))
			or ((item.classID and item.classID == 15) and (item.subclassID and item.subclassID == 2 ))
			or ((item.classID and item.classID == 15) and (item.subclassID and item.subclassID == 5 )) then
				local level = NDui:GetItemLevel(item.link, rarity)
				local itemID, itemType, itemSubType, itemEquipLoc, iconFileDataID, itemClassID, itemSubClassID = GetItemInfoInstant(link)
				if NDuiDB["Bags"]["BagsiLvl"] then
					self.iLvl:SetText(level)
				end
				if NDuiDB["Bags"]["SlotInfo"] then
					local slotText = ""
					if itemEquipLoc and string.find(itemEquipLoc, "INVTYPE_") then
						slotText = _G[itemEquipLoc] or ""
					end
					if itemEquipLoc and string.find(itemEquipLoc, "INVTYPE_FEET") then
						slotText = L["Feet"] or ""
					elseif itemEquipLoc and string.find(itemEquipLoc, "INVTYPE_HAND") then
						slotText = L["Hands"] or ""
					elseif itemEquipLoc and string.find(itemEquipLoc, "INVTYPE_HOLDABLE") then
						slotText = INVTYPE_WEAPONOFFHAND or ""
					elseif itemEquipLoc and string.find(itemEquipLoc, "INVTYPE_SHIELD") then
						slotText = itemSubType or ""
					elseif itemSubType and string.find(itemSubType, RELICSLOT) then
						slotText = RELICSLOT or ""
					elseif (itemClassID and itemClassID == 15) and (itemSubClassID and itemSubClassID == 2) then
						slotText = PET or ""
					elseif (itemClassID and itemClassID == 15) and (itemSubClassID and itemSubClassID == 5) then
						slotText = itemSubType or ""
					end
					if string.len(slotText) > 9 then
						slotText = ""
					end
					self.SlotInfo:SetText(slotText)
				end
			end
		end

		if NDuiDB["Bags"]["PreferPower"] > 1 then
			if isPowerInWrongSpec() and item.link and IsArtifactPowerItem(item.link) then
				self.powerProtect:SetAlpha(1)
			else
				self.powerProtect:SetAlpha(0)
			end
		end
	end

	local BagButton = Bags:GetClass("BagButton", true, "BagButton")
	function BagButton:OnCreate()
		self:SetNormalTexture(nil)
		self:SetHighlightTexture(nil)
		self:SetPushedTexture(nil)
		self:SetCheckedTexture(DB.textures.pushed)
		self:GetCheckedTexture():SetVertexColor(.3, .9, .9, .5)
		self.Icon:SetPoint("TOPLEFT", self, "TOPLEFT", 2, -2)
		self.Icon:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -2, 2)
		self.Icon:SetTexCoord(unpack(DB.TexCoord))
		self.HL = self:CreateTexture(nil, "HIGHLIGHT")
		self.HL:SetColorTexture(1, 1, 1, .3)
		self.HL:SetAllPoints(self.Icon)
	end

	local MyContainer = Bags:GetContainerClass()
	function MyContainer:OnContentsChanged()
		self:SortButtons("bagSlot")
		local width, height = self:LayoutButtons("grid", self.Settings.Columns, 7, 10, -10)
		self:SetSize(width + 20, height + 45)
	end

	local function ReverseSort()
		C_Timer.After(.5, function()
			for bag = 0, 4 do
				local numSlots = GetContainerNumSlots(bag)
				for slot = 1, numSlots do
					local texture, _, locked = GetContainerItemInfo(bag, slot)
					if texture and not locked then
						PickupContainerItem(bag, slot)
						PickupContainerItem(bag, numSlots+1 - slot)
					end
				end
			end
		end)
	end

	function MyContainer:OnCreate(name, settings)
		self.Settings = settings
		B.CreateBD(self, .6)
		B.CreateTex(self)

		self:SetParent(settings.Parent or Bags)
		self:SetFrameStrata("HIGH")
		self:SetClampedToScreen(true)
		settings.Columns = settings.Columns
		self:SetScale(settings.Scale)

		if settings.Movable then
			self:SetMovable(true)
			self:RegisterForClicks("LeftButton")
			self:SetScript("OnMouseDown", function()
				self:ClearAllPoints()
				self:StartMoving()
			end)
			self:SetScript("OnMouseUp", self.StopMovingOrSizing)
		end

		local infoFrame = CreateFrame("Button", nil, self)
		infoFrame:SetPoint("BOTTOMRIGHT", -50, 0)
		infoFrame:SetWidth(220)
		infoFrame:SetHeight(32)

		local search = self:SpawnPlugin("SearchBar", infoFrame)
		search.highlightFunction = highlightFunction
		search.isGlobal = true
		search:SetPoint("LEFT", infoFrame, "LEFT", 0, 5)
		search.Left:SetTexture(nil)
		search.Right:SetTexture(nil)
		search.Center:SetTexture(nil)
		local sbg = CreateFrame("Frame", nil, search)
		sbg:SetPoint("CENTER", search, "CENTER")
		sbg:SetSize(230, 20)
		sbg:SetFrameLevel(0)
		B.CreateBD(sbg)

		local tagDisplay = self:SpawnPlugin("TagDisplay", "[money]", infoFrame)
		tagDisplay:SetFont(unpack(DB.Font))
		tagDisplay:SetPoint("RIGHT", infoFrame, "RIGHT",0,0)
		B.CreateFS(infoFrame, 14, SEARCH, true, "LEFT", 0, 1)

		local SortButton = B.CreateButton(self, 60, 20, L["Sort"])
		SortButton:SetPoint("BOTTOMLEFT", 5, 7)
		SortButton:SetScript("OnClick", function()
			if name == "Bank" then
				SortBankBags()
			elseif name == "Reagent" then
				SortReagentBankBags()
			else
				if NDuiDB["Bags"]["ReverseSort"] then
					if InCombatLockdown() then
						UIErrorsFrame:AddMessage(DB.InfoColor..ERR_NOT_IN_COMBAT)
					else
						SortBags()
						ReverseSort()
					end
				else
					SortBags()
				end
			end
		end)

		local closebutton = B.CreateButton(self, 20, 20, "X")
		closebutton:SetPoint("BOTTOMRIGHT", -5, 7)
		closebutton:SetScript("OnClick", CloseAllBags)

		if name == "Main" or name == "Bank" then
			local bagBar = self:SpawnPlugin("BagBar", settings.Bags)
			bagBar:SetSize(bagBar:LayoutButtons("grid", 7))
			bagBar:SetScale(.8)
			bagBar.highlightFunction = highlightFunction
			bagBar.isGlobal = true
			bagBar:Hide()
			self.BagBar = bagBar
			bagBar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 10, -10)
			local bg = CreateFrame("Frame", nil, bagBar)
			bg:SetPoint("TOPLEFT", -10, 10)
			bg:SetPoint("BOTTOMRIGHT", -115, -10)
			B.CreateBD(bg)
			B.CreateTex(bg)

			local bagToggle = B.CreateButton(self, 60, 20, BAGSLOT)
			bagToggle:SetPoint("LEFT", SortButton, "RIGHT", 6, 0)
			bagToggle:SetScript("OnClick", function()
				if self.BagBar:IsShown() then
					self.BagBar:Hide()
				else
					self.BagBar:Show()
				end
			end)

			if name == "Bank" then
				bg:SetPoint("TOPLEFT", -10, 10)
				bg:SetPoint("BOTTOMRIGHT", 10, -10)

				local switch = B.CreateButton(self, 70, 20, REAGENT_BANK)
				switch:SetPoint("LEFT", bagToggle, "RIGHT", 6, 0)
				switch:RegisterForClicks("AnyUp")
				switch:SetScript("OnClick", function(self, button)
					if not IsReagentBankUnlocked() then
						StaticPopup_Show("CONFIRM_BUY_REAGENTBANK_TAB")
					else
						PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
						ReagentBankFrame:Show()
						BankFrame.selectedTab = 2
						f.reagent:Show()
						f.bank:Hide()
						if button == "RightButton" then
							DepositReagentBank()
						end
					end
				end)
			end
		elseif name == "Reagent" then
			local deposit = B.CreateButton(self, 100, 20, REAGENTBANK_DEPOSIT)
			deposit:SetPoint("LEFT", SortButton, "RIGHT", 6, 0)
			deposit:SetScript("OnClick", DepositReagentBank)

			local switch = B.CreateButton(self, 70, 20, BANK)
			switch:SetPoint("LEFT", deposit, "RIGHT", 6, 0)
			switch:SetScript("OnClick", function()
				PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
				ReagentBankFrame:Hide()
				BankFrame.selectedTab = 1
				f.reagent:Hide()
				f.bank:Show()
			end)
		end

		-- Add Sound
		self:HookScript("OnShow", function() PlaySound(SOUNDKIT.IG_BACKPACK_OPEN) end)
		self:HookScript("OnHide", function() PlaySound(SOUNDKIT.IG_BACKPACK_CLOSE) end)
	end

	-- Fix Containter Bug
	local function getRightFix() return BagsBank:GetRight() end
	BankFrame.GetRight = getRightFix

	-- Cleanup Bags Order
	SetSortBagsRightToLeft(not NDuiDB["Bags"]["ReverseSort"])
	SetInsertItemsLeftToRight(false)
end