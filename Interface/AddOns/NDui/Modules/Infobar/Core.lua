local _, ns = ...
local B, C, L, DB = unpack(ns)
local module = B:RegisterModule("Infobar")
local tinsert, pairs, unpack = table.insert, pairs, unpack

function module:GetMoneyString(money, formatted)
	if money > 0 then
		if formatted then
			return format("%s%s", B.FormatNumb(money / 1e4), GOLD_AMOUNT_SYMBOL)
		else
			local moneyString = ""
			local gold = floor(money / 1e4)
			if gold > 0 then
				moneyString = gold..GOLD_AMOUNT_SYMBOL
			end
			local silver = floor((money - (gold * 1e4)) / 100)
			if silver > 0 then
				moneyString = moneyString.." "..silver..SILVER_AMOUNT_SYMBOL
			end
			local copper = mod(money, 100)
			if copper > 0 then
				moneyString = moneyString.." "..copper..COPPER_AMOUNT_SYMBOL
			end
			return moneyString
		end
	else
		return "0"..COPPER_AMOUNT_SYMBOL
	end
end

function module:RegisterInfobar(name, point)
	if not self.modules then self.modules = {} end

	local info = CreateFrame("Frame", nil, UIParent)
	info:SetHitRectInsets(0, 0, -10, -10)
	info.text = info:CreateFontString(nil, "OVERLAY")
	info.text:SetFont(DB.Font[1], C.Infobar.FontSize, DB.Font[3])
	if C.Infobar.AutoAnchor then
		info.point = point
	else
		info.text:SetPoint(unpack(point))
	end
	info:SetAllPoints(info.text)
	info.name = name
	tinsert(self.modules, info)

	return info
end

function module:LoadInfobar(info)
	if info.eventList then
		for _, event in pairs(info.eventList) do
			info:RegisterEvent(event)
		end
		info:SetScript("OnEvent", info.onEvent)
	end
	if info.onEnter then
		info:SetScript("OnEnter", info.onEnter)
	end
	if info.onLeave then
		info:SetScript("OnLeave", info.onLeave)
	end
	if info.onMouseUp then
		info:SetScript("OnMouseUp", info.onMouseUp)
	end
	if info.onUpdate then
		info:SetScript("OnUpdate", info.onUpdate)
	end
end

function module:BackgroundLines()
	if not NDuiDB["Skins"]["InfobarLine"] then return end

	local cr, cg, cb = DB.r, DB.g, DB.b
	local color = NDuiDB["Skins"]["LineColor"]
	if not NDuiDB["Skins"]["ClassLine"] then cr, cg, cb = color.r, color.g, color.b end

	-- TOPLEFT
	local InfobarLineTL = CreateFrame("Frame", nil, UIParent)
	InfobarLineTL:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, -5)
	B.CreateGA(InfobarLineTL, 600, 18, "Horizontal", 0, 0, 0, .5, 0)
	local InfobarLineTL1 = CreateFrame("Frame", nil, InfobarLineTL)
	InfobarLineTL1:SetPoint("BOTTOM", InfobarLineTL, "TOP")
	B.CreateGA(InfobarLineTL1, 600, C.mult*2, "Horizontal", cr, cg, cb, DB.Alpha, 0)
	local InfobarLineTL2 = CreateFrame("Frame", nil, InfobarLineTL)
	InfobarLineTL2:SetPoint("TOP", InfobarLineTL, "BOTTOM")
	B.CreateGA(InfobarLineTL2, 600, C.mult*2, "Horizontal", cr, cg, cb, DB.Alpha, 0)

	-- BOTTOMRIGHT
	local InfobarLineBR = CreateFrame("Frame", nil, UIParent)
	InfobarLineBR:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 5)
	B.CreateGA(InfobarLineBR, 450, 18, "Horizontal", 0, 0, 0, 0, .5)
	local InfobarLineBR1 = CreateFrame("Frame", nil, InfobarLineBR)
	InfobarLineBR1:SetPoint("BOTTOM", InfobarLineBR, "TOP")
	B.CreateGA(InfobarLineBR1, 450, C.mult*2, "Horizontal", cr, cg, cb, 0, DB.Alpha)
	local InfobarLineBR2 = CreateFrame("Frame", nil, InfobarLineBR)
	InfobarLineBR2:SetPoint("TOP", InfobarLineBR, "BOTTOM")
	B.CreateGA(InfobarLineBR2, 450, C.mult*2, "Horizontal", cr, cg, cb, 0, DB.Alpha)
end

function module:OnLogin()
	if NDuiADB["DisableInfobars"] then return end

	if not self.modules then return end
	for _, info in pairs(self.modules) do
		self:LoadInfobar(info)
	end

	self.loginTime = GetTime()

	if not C.Infobar.AutoAnchor then return end
	for index, info in pairs(self.modules) do
		if index == 1 or index == 5 then
			info.text:SetPoint(unpack(info.point))
		elseif index < 5 then
			info.text:SetPoint("LEFT", self.modules[index-1], "RIGHT", 30, 0)
			info.text:SetJustifyH("LEFT")
		else
			info.text:SetPoint("RIGHT", self.modules[index-1], "LEFT", -30, 0)
			info.text:SetJustifyH("RIGHT")
		end
	end

	self:BackgroundLines()
end