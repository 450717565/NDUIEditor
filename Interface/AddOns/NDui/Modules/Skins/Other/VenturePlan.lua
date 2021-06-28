local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

local tL, tR, tT, tB = unpack(DB.TexCoord)

local function Reskin_RewardFrame(self, rew)
	if not rew then return end

	if not self.icbg then
		self.icbg = B.ReskinIcon(self.Icon)

		self.RarityBorder:Hide()

		self.Quantity:SetJustifyH("RIGHT")
		self.Quantity:ClearAllPoints()
		self.Quantity:SetPoint("BOTTOMRIGHT", self.icbg, "BOTTOMRIGHT", 1, 0)
	end

	local r, g, b = 1, 1, 1
	if rew == "xp" then
		r, g, b = 1, 0, 1	-- 基础经验
	elseif rew.followerXP then
		r, g, b = 0, 1, 0	-- 奖励经验
	elseif rew.currencyID then
		if rew.currencyID == 0 then
			r, g, b = 1, 1, 0	-- 金币奖励
		else
			local ci_1 = C_CurrencyInfo.GetCurrencyContainerInfo(rew.currencyID, rew.quantity)	-- 声望奖章
			local ci_2 = C_CurrencyInfo.GetCurrencyInfo(rew.currencyID)	-- 其他货币
			r, g, b = B.GetQualityColor((ci_1 and ci_1.quality) or (ci_2 and ci_2.quality))
		end
	elseif rew.itemID then
		if C_Item.IsAnimaItemByID(rew.itemID) then
			self.Icon:SetTexture(3528288)

			local mult = B.GetAnimaMultiplier(rew.itemID)
			if mult then
				local total = rew.quantity * mult
				self.Quantity:SetText(total)
			end
		else
			local itemSolt = B.GetItemSlot(rew.itemLink or rew.itemID)
			self.Quantity:SetText(itemSolt or "")
		end

		local itemQuality = select(3,GetItemInfo(rew.itemLink or rew.itemID))
		r, g, b = B.GetQualityColor(itemQuality)
	end

	if self.icbg then
		self.icbg:SetBackdropBorderColor(r, g, b)
	end
end

function Skins:VenturePlan()
	if not IsAddOnLoaded("VenturePlan") then return end

	function VPEX_OnUIObjectCreated(otype, widget, peek)
		if widget:IsObjectType("Frame") then
			if otype == "CopyBoxUI" then
				B.ReskinButton(widget.ResetButton)
				B.ReskinClose(widget.CloseButton2, nil, -12, -12)
				B.ReskinInput(widget.FirstInputBox)
				B.ReskinInput(widget.SecondInputBox)
				B.ReskinText(widget.Intro, 1, 1, 1)
				B.ReskinText(widget.FirstInputBoxLabel, 1, .8, 0)
				B.ReskinText(widget.SecondInputBoxLabel, 1, .8, 0)
				B.ReskinText(widget.VersionText, 1, 1, 1)
			elseif otype == "FollowerList" then
				B.StripTextures(widget)
				B.CreateBDFrame(widget)
			elseif otype == "FollowerListButton" then
				peek("TextLabel"):SetFontObject("Game12Font")
			elseif otype == "IconButton" then
				local icbg = B.CreateBDFrame(widget)
				B.ReskinHLTex(widget, icbg)
				B.ReskinCPTex(widget, icbg)

				local icon = widget:GetNormalTexture()
				icon:SetTexCoord(tL, tR, tT, tB)
				icon:SetInside(icbg)

				local Icon = widget.Icon
				Icon:SetTexCoord(tL, tR, tT, tB)
				Icon:SetInside(icbg)
			elseif otype == "ILButton" then
				widget:DisableDrawLayer("BACKGROUND")

				B.CreateBGFrame(widget, -4, 2, 2, -2)
				B.ReskinIcon(widget.Icon)
			elseif otype == "MissionButton" then
				B.ReskinText(peek("Description"), 1, 1, 1)
				B.ReskinText(peek("enemyHP"), 0, 1, 0)
				B.ReskinText(peek("enemyATK"), 0, 1, 0)
				B.ReskinText(peek("animaCost"), 0, 1, 0)
				B.ReskinText(peek("duration"), 1, 1, 0)

				local cdtFont = widget.CDTDisplay:GetFontString()
				B.ReskinText(cdtFont, 1, 1, 0)

				local ViewButton = peek("ViewButton")
				B.ReskinButton(ViewButton)

				local DoomRunButton = peek("DoomRunButton")
				B.ReskinButton(DoomRunButton)
				DoomRunButton:SetSize(24, 24)
				DoomRunButton:ClearAllPoints()
				DoomRunButton:SetPoint("RIGHT", ViewButton, "LEFT", -1, 0)

				local TentativeClear = peek("TentativeClear")
				B.ReskinButton(TentativeClear)
				TentativeClear:SetSize(24, 24)
				TentativeClear:ClearAllPoints()
				TentativeClear:SetPoint("RIGHT", ViewButton, "LEFT", -1, 0)
			elseif otype == "MissionList" then
				B.StripTextures(widget)

				local background = widget:GetChildren()
				B.StripTextures(background)
			elseif otype == "MissionPage" then
				B.StripTextures(widget)
				B.ReskinButton(peek("UnButton"))
			elseif otype == "MissionToast" then
				widget.Background:Hide()
				widget.Detail:SetFontObject("Game13Font")
				B.CreateBG(widget)
			elseif otype == "ProgressBar" then
				B.StripTextures(widget)
				B.CreateBDFrame(widget, 0, -C.mult)
			elseif otype == "RewardFrame" then
				hooksecurefunc(widget, "SetReward", Reskin_RewardFrame)
			end
		end
	end
end

C.OnLoginThemes["VenturePlan"] = Skins.VenturePlan