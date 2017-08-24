local B, C, L, DB = unpack(select(2, ...))

if UnitLevel("player") < 100 then return end

local itemLink, bag, slot
local Cache = {}
local point = {"CENTER", UIParent, "BOTTOM", -245, 130}

local APUF = CreateFrame("Frame", "ArtifactPowerUserFrame", UIParent)
APUF:SetSize(48, 48)
APUF:EnableMouse(true)
APUF:SetClampedToScreen(true)

local APU = CreateFrame("Button", "ArtifactPowerUserButton", APUF, "ActionButtonTemplate, SecureActionButtonTemplate")
APU:SetAllPoints()

APU:SetScript("OnHide", function(self)
	self:SetAttribute("type", nil)
	self:SetAttribute("item", nil)
end)

APU:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetHyperlink(itemLink)
end)

APU:SetScript("OnLeave", function(self)
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
					if IsArtifactPowerItem(itemLink) then
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
	if not InCombatLockdown() then
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

APUF:RegisterEvent("PLAYER_LOGIN")
APUF:RegisterEvent("BAG_UPDATE_DELAYED")
APUF:RegisterEvent("PLAYER_REGEN_DISABLED")
APUF:RegisterEvent("PLAYER_REGEN_ENABLED")
APUF:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_LOGIN" then
		B.Mover(APUF, "APU", "ArtifactPowerUser", point)
	elseif event == "BAG_UPDATE_DELAYED" then
		UpdateItem(APU)
	elseif event == "PLAYER_REGEN_DISABLED" then
		self:UnregisterEvent("BAG_UPDATE_DELAYED")
		APUF:Hide()
		GameTooltip:Hide()
	elseif event == "PLAYER_REGEN_ENABLED" then
		self:RegisterEvent("BAG_UPDATE_DELAYED")
		UpdateItem(APU)
		APUF:Show()
		GameTooltip:Show()
	end
end)

-- Aurora Reskin
if IsAddOnLoaded("Aurora") then
	local F = unpack(Aurora)
	F.ReskinIconStyle(APU)
end