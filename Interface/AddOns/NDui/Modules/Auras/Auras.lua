local _, ns = ...
local B, C, L, DB = unpack(ns)
local Auras = B:RegisterModule("Auras")

local _G = getfenv(0)
local format, floor, strmatch, select, unpack = format, floor, strmatch, select, unpack
local DebuffTypeColor = _G.DebuffTypeColor
local UnitAura, GetTime = UnitAura, GetTime
local GetInventoryItemQuality, GetInventoryItemTexture, GetItemQualityColor, GetWeaponEnchantInfo = GetInventoryItemQuality, GetInventoryItemTexture, GetItemQualityColor, GetWeaponEnchantInfo

local tL, tR, tT, tB = unpack(DB.TexCoord)

function Auras:OnLogin()
	-- Config
	Auras.settings = {
		Buffs = {
			offset = 12,
			size = C.db["Auras"]["BuffSize"],
			wrapAfter = C.db["Auras"]["BuffsPerRow"],
			maxWraps = 3,
			reverseGrow = C.db["Auras"]["ReverseBuffs"],
		},
		Debuffs = {
			offset = 12,
			size = C.db["Auras"]["DebuffSize"],
			wrapAfter = C.db["Auras"]["DebuffsPerRow"],
			maxWraps = 2,
			reverseGrow = C.db["Auras"]["ReverseDebuffs"],
		},
	}

	-- HideBlizz
	B.HideObject(_G.BuffFrame)
	B.HideObject(_G.TemporaryEnchantFrame)

	-- Movers
	Auras.BuffFrame = Auras:CreateAuraHeader("HELPFUL")
	Auras.BuffFrame.mover = B.Mover(Auras.BuffFrame, "Buffs", "BuffAnchor", C.Auras.BuffPos)
	Auras.BuffFrame:ClearAllPoints()
	Auras.BuffFrame:SetPoint("TOPRIGHT", Auras.BuffFrame.mover)

	Auras.DebuffFrame = Auras:CreateAuraHeader("HARMFUL")
	Auras.DebuffFrame.mover = B.Mover(Auras.DebuffFrame, "Debuffs", "DebuffAnchor", {"TOPRIGHT", Auras.BuffFrame.mover, "BOTTOMRIGHT", 0, -12})
	Auras.DebuffFrame:ClearAllPoints()
	Auras.DebuffFrame:SetPoint("TOPRIGHT", Auras.DebuffFrame.mover)

	-- Elements
	Auras:Totems()
	Auras:InitReminder()
end

function Auras:UpdateTimer(elapsed)
	if self.offset then
		local expiration = select(self.offset, GetWeaponEnchantInfo())
		if expiration then
			self.timeLeft = expiration / 1e3
		else
			self.timeLeft = 0
		end
	else
		self.timeLeft = self.timeLeft - elapsed
	end

	if self.nextUpdate > 0 then
		self.nextUpdate = self.nextUpdate - elapsed
		return
	end

	if self.timeLeft >= 0 then
		local timer, nextUpdate = B.FormatTime(self.timeLeft, true)
		self.nextUpdate = nextUpdate
		self.timer:SetText(timer)
	end
end

function Auras:UpdateAuras(button, index)
	local filter = button:GetParent():GetAttribute("filter")
	local unit = button:GetParent():GetAttribute("unit")
	local name, texture, count, debuffType, duration, expirationTime, _, _, _, spellID = UnitAura(unit, index, filter)

	if name then
		if duration > 0 and expirationTime then
			local timeLeft = expirationTime - GetTime()
			if not button.timeLeft then
				button.nextUpdate = -1
				button.timeLeft = timeLeft
				button:SetScript("OnUpdate", Auras.UpdateTimer)
			else
				button.timeLeft = timeLeft
			end
			button.nextUpdate = -1
			Auras.UpdateTimer(button, 0)
		else
			button.timeLeft = nil
			button.timer:SetText("")
			button:SetScript("OnUpdate", nil)
		end

		if count and count > 1 then
			button.count:SetText(count)
		else
			button.count:SetText("")
		end

		if filter == "HARMFUL" then
			local color = DebuffTypeColor[debuffType or "none"]
			button.bubg:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			button.bubg:SetBackdropBorderColor(0, 0, 0)
		end

		button.spellID = spellID
		button.icon:SetTexture(texture)
		button.offset = nil
	end
end

function Auras:UpdateTempEnchant(button, index)
	local quality = GetInventoryItemQuality("player", index)
	button.icon:SetTexture(GetInventoryItemTexture("player", index))

	local offset = 2
	local weapon = button:GetDebugName():sub(-1)
	if strmatch(weapon, "2") then
		offset = 6
	end

	if quality then
		local r, g, b = GetItemQualityColor(quality or 1)
		button.bubg:SetBackdropBorderColor(r, g, b)
	end

	local expirationTime = select(offset, GetWeaponEnchantInfo())
	if expirationTime then
		button.offset = offset
		button:SetScript("OnUpdate", Auras.UpdateTimer)
		button.nextUpdate = -1
		Auras.UpdateTimer(button, 0)
	else
		button.offset = nil
		button.timeLeft = nil
		button:SetScript("OnUpdate", nil)
		button.timer:SetText("")
	end
end

function Auras:OnAttributeChanged(attribute, value)
	if attribute == "index" then
		Auras:UpdateAuras(self, value)
	elseif attribute == "target-slot" then
		Auras:UpdateTempEnchant(self, value)
	end
end

function Auras:UpdateOptions()
	Auras.settings.Buffs.size = C.db["Auras"]["BuffSize"]
	Auras.settings.Buffs.wrapAfter = C.db["Auras"]["BuffsPerRow"]
	Auras.settings.Buffs.reverseGrow = C.db["Auras"]["ReverseBuffs"]
	Auras.settings.Debuffs.size = C.db["Auras"]["DebuffSize"]
	Auras.settings.Debuffs.wrapAfter = C.db["Auras"]["DebuffsPerRow"]
	Auras.settings.Debuffs.reverseGrow = C.db["Auras"]["ReverseDebuffs"]
end

function Auras:UpdateHeader(header)
	local cfg = Auras.settings.Debuffs
	if header:GetAttribute("filter") == "HELPFUL" then
		cfg = Auras.settings.Buffs
		header:SetAttribute("consolidateTo", 0)
		header:SetAttribute("weaponTemplate", format("NDuiAuraTemplate%d", cfg.size))
	end

	header:SetAttribute("separateOwn", 1)
	header:SetAttribute("sortMethod", "INDEX")
	header:SetAttribute("sortDirection", "+")
	header:SetAttribute("wrapAfter", cfg.wrapAfter)
	header:SetAttribute("maxWraps", cfg.maxWraps)
	header:SetAttribute("point", cfg.reverseGrow and "TOPLEFT" or "TOPRIGHT")
	header:SetAttribute("minWidth", (cfg.size + C.margin)*cfg.wrapAfter)
	header:SetAttribute("minHeight", (cfg.size + cfg.offset)*cfg.maxWraps)
	header:SetAttribute("xOffset", (cfg.reverseGrow and 1 or -1) * (cfg.size + C.margin))
	header:SetAttribute("yOffset", 0)
	header:SetAttribute("wrapXOffset", 0)
	header:SetAttribute("wrapYOffset", -(cfg.size + cfg.offset))
	header:SetAttribute("template", format("NDuiAuraTemplate%d", cfg.size))

	local fontSize = B.Round(cfg.size/30*12)
	local index = 1
	local child = select(index, header:GetChildren())
	while child do
		if (B.Round(child:GetWidth() * 100) / 100) ~= cfg.size then
			child:SetSize(cfg.size, cfg.size)
		end

		child.count:SetFont(DB.Font[1], fontSize, DB.Font[3])
		child.timer:SetFont(DB.Font[1], fontSize, DB.Font[3])

		--Blizzard bug fix, icons arent being hidden when you reduce the amount of maximum buttons
		if index > (cfg.maxWraps * cfg.wrapAfter) and child:IsShown() then
			child:Hide()
		end

		index = index + 1
		child = select(index, header:GetChildren())
	end
end

function Auras:CreateAuraHeader(filter)
	local name = "NDuiPlayerDebuffs"
	if filter == "HELPFUL" then name = "NDuiPlayerBuffs" end

	local header = CreateFrame("Frame", name, UIParent, "SecureAuraHeaderTemplate")
	header:SetClampedToScreen(true)
	header:SetAttribute("unit", "player")
	header:SetAttribute("filter", filter)
	RegisterStateDriver(header, "visibility", "[petbattle] hide; show")
	RegisterAttributeDriver(header, "unit", "[vehicleui] vehicle; player")

	if filter == "HELPFUL" then
		header:SetAttribute("consolidateDuration", -1)
		header:SetAttribute("includeWeapons", 1)
	end

	Auras:UpdateHeader(header)
	header:Show()

	return header
end

function Auras:RemoveSpellFromIgnoreList()
	if IsAltKeyDown() and IsControlKeyDown() and self.spellID and C.db["AuraWatchList"]["IgnoreSpells"][self.spellID] then
		C.db["AuraWatchList"]["IgnoreSpells"][self.spellID] = nil
		print(format(L["RemoveFromIgnoreList"], DB.NDuiString, self.spellID))
	end
end

function Auras:CreateAuraIcon(button)
	local header = button:GetParent()
	local cfg = Auras.settings.Debuffs
	if header:GetAttribute("filter") == "HELPFUL" then
		cfg = Auras.settings.Buffs
	end
	local fontSize = B.Round(cfg.size/30*12)

	local bubg = B.CreateBDFrame(button)
	button.bubg = bubg

	local icon = button:CreateTexture(nil, "BORDER")
	icon:SetTexCoord(tL, tR, tT, tB)
	icon:SetInside(bubg)
	button.icon = icon

	local highlight = button:CreateTexture(nil, "HIGHLIGHT")
	highlight:SetColorTexture(1, 1, 1, .25)
	highlight:SetInside(bubg)
	button.highlight = highlight

	local count = button:CreateFontString(nil, "ARTWORK")
	count:SetPoint("TOPRIGHT", -1, -3)
	count:SetFont(DB.Font[1], fontSize, DB.Font[3])
	button.count = count

	local timer = button:CreateFontString(nil, "ARTWORK")
	timer:SetPoint("TOP", button, "BOTTOM", 1, 2)
	timer:SetFont(DB.Font[1], fontSize, DB.Font[3])
	button.timer = timer

	button:SetScript("OnAttributeChanged", Auras.OnAttributeChanged)
	button:HookScript("OnMouseDown", Auras.RemoveSpellFromIgnoreList)
end