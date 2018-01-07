local B, C, L, DB = unpack(select(2, ...))

if UnitLevel("player") < 100 then return end

local itemList = {
-- 随从箱子
	[139879] = true,	--勇士装备箱
	[141344] = true,	--破碎群岛贡品
	[146948] = true,	--破碎群岛贡品
	[147432] = true,	--勇士装备
	[147905] = true,	--勇士装备柜
	[150924] = true,	--破碎群岛高级贡品
	[153132] = true,	--阿古斯勇士装备箱
-- 声望徽章
	[139020] = true,
	[139021] = true,
	[139023] = true,
	[139024] = true,
	[139025] = true,
	[139026] = true,
	[141987] = true,
	[141988] = true,
	[141989] = true,
	[141990] = true,
	[141991] = true,
	[141992] = true,
	[146935] = true,
	[146936] = true,
	[146937] = true,
	[146938] = true,
	[146939] = true,
	[146940] = true,
	[146949] = true,
	[147410] = true,
	[147411] = true,
	[147412] = true,
	[147413] = true,
	[147414] = true,
	[147415] = true,
	[147727] = true,
	[152956] = true,
	[152958] = true,
	[152959] = true,
	[152961] = true,
}

local itemLink, bag, slot
local Cache = {}
local point = {"CENTER", UIParent, "BOTTOM", -245, 130}

local ABF = CreateFrame("Frame", "AutoButtonFrame", UIParent)
ABF:SetSize(48, 48)
ABF:EnableMouse(true)
ABF:SetClampedToScreen(true)

local ABB = CreateFrame("Button", "AutoButtonButton", ABF, "ActionButtonTemplate, SecureActionButtonTemplate")
ABB:SetAllPoints()

ABB:SetScript("OnHide", function(self)
	self:SetAttribute("type", nil)
	self:SetAttribute("item", nil)
end)

ABB:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetHyperlink(itemLink)
end)

ABB:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

local function ScanBags()
	for bag = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			local itemLink = GetContainerItemLink(bag, slot)
			if itemLink and itemLink:match("item:%d") then
				if Cache[itemLink] then
					return itemLink, bag, slot
				else
					if IsArtifactPowerItem(itemLink) or itemList[GetItemInfoInstant(itemLink)] then
						Cache[itemLink] = true
						return itemLink, bag, slot
					end
				end
			end
		end
	end
	return nil
end

local function UpdateItem(self)
	if (not InCombatLockdown()) or (not UnitHasVehicleUI("player")) then
		itemLink, bag, slot = ScanBags()
		if itemLink then
			self:SetAttribute("type", "item")
			self:SetAttribute("item", bag.." "..slot)
			local itemTexture = GetItemIcon(itemLink)
			self.icon:SetTexture(itemTexture)
			local start, duration, enable = GetContainerItemCooldown(bag, slot)
			if duration > 0 then
				self.cooldown:SetCooldown(start, duration)
				self.cooldown:SetAllPoints(self.icon)
			end
			self:Show()
			if self:IsMouseOver() then
				GameTooltip:SetHyperlink(itemLink)
			end
			GameTooltip:Show()
		else
			self:Hide()
			GameTooltip:Hide()
		end
	end
end

ABF:RegisterEvent("BAG_UPDATE_DELAYED")
ABF:RegisterEvent("PET_BATTLE_CLOSE")
ABF:RegisterEvent("PET_BATTLE_OPENING_START")
ABF:RegisterEvent("PLAYER_LOGIN")
ABF:RegisterEvent("PLAYER_REGEN_DISABLED")
ABF:RegisterEvent("PLAYER_REGEN_ENABLED")
ABF:RegisterEvent("UNIT_ENTERED_VEHICLE")
ABF:RegisterEvent("UNIT_EXITED_VEHICLE")

ABF:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		B.Mover(ABF, "AutoButton", "AutoButton", point)
	elseif event == "BAG_UPDATE_DELAYED" then
		UpdateItem(ABB)
	elseif event == "PLAYER_REGEN_DISABLED" or event == "PET_BATTLE_OPENING_START" or (event == "UNIT_ENTERED_VEHICLE" and ... == "player" and not InCombatLockdown()) then
		self:UnregisterEvent("BAG_UPDATE_DELAYED")
		ABF:Hide()
		GameTooltip:Hide()
	elseif event == "PLAYER_REGEN_ENABLED" or event == "PET_BATTLE_CLOSE" or (event == "UNIT_EXITED_VEHICLE" and ... == "player") then
		self:RegisterEvent("BAG_UPDATE_DELAYED")
		UpdateItem(ABB)
		ABF:Show()
		GameTooltip:Show()
	end
end)

-- Aurora Reskin
if IsAddOnLoaded("Aurora") then
	local F = unpack(Aurora)
	F.ReskinIconStyle(ABB)
end