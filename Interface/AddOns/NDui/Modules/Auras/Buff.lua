local _, ns = ...
local B, C, L, DB = unpack(ns)
local module = B:RegisterModule("Auras")

local BuffFrame, PlayerFrame, DebuffTypeColor, UnitAura = BuffFrame, PlayerFrame, DebuffTypeColor, UnitAura
local NUM_TEMP_ENCHANT_FRAMES = NUM_TEMP_ENCHANT_FRAMES or 3
local buffsPerRow, buffSize, margin, offset = C.Auras.IconsPerRow, C.Auras.IconSize - 2, C.Auras.Spacing, 10
local debuffsPerRow, debuffSize = C.Auras.IconsPerRow - 4, C.Auras.IconSize + 3
local parentFrame, buffAnchor, debuffAnchor
local format, mod, unpack = string.format, mod, unpack

function module:OnLogin()
	parentFrame = CreateFrame("Frame", nil, UIParent)
	parentFrame:SetSize(buffSize, buffSize)
	buffAnchor = B.Mover(parentFrame, "Buffs", "BuffAnchor", C.Auras.BuffPos, (buffSize + margin)*buffsPerRow, (buffSize + offset)*3)
	debuffAnchor = B.Mover(parentFrame, "Debuffs", "DebuffAnchor", {"TOPRIGHT", buffAnchor, "BOTTOMRIGHT", 0, -offset}, (debuffSize + margin)*debuffsPerRow, (debuffSize + offset)*2)
	parentFrame:ClearAllPoints()
	parentFrame:SetPoint("TOPRIGHT", buffAnchor)

	for i = 1, 3 do
		local enchant = _G["TempEnchant"..i]
		enchant:ClearAllPoints()
		if i == 1 then
			enchant:SetPoint("TOPRIGHT", buffAnchor)
		else
			enchant:SetPoint("TOPRIGHT", _G["TempEnchant"..(i-1)], "TOPLEFT", -margin, 0)
		end
	end
	TempEnchant3:Hide()
	BuffFrame.ignoreFramePositionManager = true

	-- Elements
	if DB.MyClass == "MONK" then
		self:MonkStatue()
	elseif DB.MyClass == "SHAMAN" then
		self:Totems()
	end
	self:InitReminder()
end

function module:StyleAuraButton(bu, isDebuff)
	if not bu or bu.styled then return end
	local name = bu:GetName()

	local iconSize, fontSize = buffSize, DB.Font[2]
	if isDebuff then iconSize, fontSize = debuffSize, DB.Font[2] + 2 end

	local border = _G[name.."Border"]
	if border then border:Hide() end

	local icon = _G[name.."Icon"]
	icon:SetAllPoints()
	icon:SetTexCoord(unpack(DB.TexCoord))
	icon:SetDrawLayer("BACKGROUND", 1)

	local duration = _G[name.."Duration"]
	duration:ClearAllPoints()
	duration:SetPoint("TOP", bu, "BOTTOM", 1, 2)
	duration:SetFont(DB.Font[1], fontSize, DB.Font[3])

	local count = _G[name.."Count"]
	count:ClearAllPoints()
	count:SetParent(bu)
	count:SetPoint("TOPRIGHT", bu, "TOPRIGHT", -1, -3)
	count:SetFont(DB.Font[1], fontSize, DB.Font[3])

	bu:SetSize(iconSize, iconSize)
	bu.HL = bu:CreateTexture(nil, "HIGHLIGHT")
	bu.HL:SetColorTexture(1, 1, 1, .25)
	bu.HL:SetAllPoints(icon)
	B.CreateSD(bu, 3, 3)

	bu.styled = true
end

function module:ReskinBuffs()
	local buff, previousBuff, aboveBuff, index
	local numBuffs = 0
	local slack = BuffFrame.numEnchants

	for i = 1, BUFF_ACTUAL_DISPLAY do
		buff = _G["BuffButton"..i]
		module:StyleAuraButton(buff)

		numBuffs = numBuffs + 1
		index = numBuffs + slack
		buff:ClearAllPoints()
		if index > 1 and mod(index, buffsPerRow) == 1 then
			if index == buffsPerRow + 1 then
				buff:SetPoint("TOP", parentFrame, "BOTTOM", 0, -offset)
			else
				buff:SetPoint("TOP", aboveBuff, "BOTTOM", 0, -offset)
			end
			aboveBuff = buff
		elseif numBuffs == 1 and slack == 0 then
			buff:SetPoint("TOPRIGHT", buffAnchor)
		elseif numBuffs == 1 and slack > 0 then
			buff:SetPoint("TOPRIGHT", _G["TempEnchant"..slack], "TOPLEFT", -margin, 0)
		else
			buff:SetPoint("RIGHT", previousBuff, "LEFT", -margin, 0)
		end
		previousBuff = buff
	end
end
hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", module.ReskinBuffs)

function module:ReskinTempEnchant()
	for i = 1, NUM_TEMP_ENCHANT_FRAMES do
		local bu = _G["TempEnchant"..i]
		module:StyleAuraButton(bu)
	end
end
hooksecurefunc("TemporaryEnchantFrame_Update", module.ReskinTempEnchant)

function module.ReskinDebuffs(buttonName, i)
	local debuff = _G[buttonName..i]
	module:StyleAuraButton(debuff, true)

	debuff:ClearAllPoints()
	if i > 1 and mod(i, debuffsPerRow) == 1 then
		debuff:SetPoint("TOP", _G[buttonName..(i-debuffsPerRow)], "BOTTOM", 0, -offset)
	elseif i == 1 then
		debuff:SetPoint("TOPRIGHT", debuffAnchor)
	else
		debuff:SetPoint("RIGHT", _G[buttonName..(i-1)], "LEFT", -margin, 0)
	end
end
hooksecurefunc("DebuffButton_UpdateAnchors", module.ReskinDebuffs)

function module.UpdateDebuffBorder(buttonName, index, filter)
	local unit = PlayerFrame.unit
	local name, _, _, debuffType = UnitAura(unit, index, filter)
	if not name then return end
	local bu = _G[buttonName..index]
	if not (bu and bu.Shadow) then return end

	if filter == "HARMFUL" then
		local color = DebuffTypeColor[debuffType or "none"]
		bu.Shadow:SetBackdropBorderColor(color.r, color.g, color.b)
	end
end
hooksecurefunc("AuraButton_Update", module.UpdateDebuffBorder)

function module:FlashOnEnd()
	if self.timeLeft < 10 then
		self:SetAlpha(BuffFrame.BuffAlphaValue)
	else
		self:SetAlpha(1)
	end
end
hooksecurefunc("AuraButton_OnUpdate", module.FlashOnEnd)

function module.FormatAuraTime(s)
	local d, h, m, str = 0, 0, 0
	if s >= 86400 then
		d = s/86400
		s = s%86400
	end
	if s >= 3600 then
		h = s/3600
		s = s%3600
	end
	if s >= 60 then
		m = s/60
		s = s%60
	end
	if d > 0 then
		str = format("%d "..DB.MyColor..L["Days"], d)
	elseif h > 0 then
		str = format("%d "..DB.MyColor..L["Hours"], h)
	elseif m >= 10 then
		str = format("%d "..DB.MyColor..L["Minutes"], m)
	elseif m > 0 and m < 10 then
		str = format("%.2d:%.2d", m, s)
	else
		if s <= 5 then
			str = format("|cffff0000%.1f|r", s) -- red
		elseif s <= 10 then
			str = format("|cffffff00%.1f|r", s) -- yellow
		else
			str = format("%d "..DB.MyColor..L["Seconds"], s)
		end
	end

	return str
end

function module.UpdateDurationColor(button, timeLeft)
	local duration = button.duration
	if SHOW_BUFF_DURATIONS == "1" and timeLeft then
		duration:SetFormattedText(module.FormatAuraTime(timeLeft))
		duration:SetTextColor(1, 1, 1)
		duration:Show()
	else
		duration:Hide()
	end
end
hooksecurefunc("AuraButton_UpdateDuration", module.UpdateDurationColor)