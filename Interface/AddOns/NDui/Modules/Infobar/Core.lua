local _, ns = ...
local B, C, L, DB = unpack(ns)
local IB = B:RegisterModule("Infobar")
local tinsert, pairs, unpack = table.insert, pairs, unpack

function IB:GetMoneyString(money, formatted)
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

function IB:RegisterInfobar(name, point)
	if not self.modules then self.modules = {} end

	local info = CreateFrame("Frame", nil, UIParent)
	info:SetHitRectInsets(0, 0, -10, -10)
	info.text = B.CreateFS(info, C.Infobar.FontSize)
	info.text:ClearAllPoints()
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

function IB:LoadInfobar(info)
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

function IB:BackgroundLines()
	if not C.db["Skins"]["InfobarLine"] then return end

	local cr, cg, cb = DB.cr, DB.cg, DB.cb
	local color = C.db["Skins"]["LineColor"]
	if not C.db["Skins"]["ClassLine"] then cr, cg, cb = color.r, color.g, color.b end

	local parent = UIParent
	local width, height = 450, 18
	local anchors = {
		[1] = {"TOPLEFT", -3, C.alpha, 0, C.alpha, 0},
		[2] = {"BOTTOMRIGHT", 3, 0, C.alpha, 0, C.alpha},
	}
	for _, v in pairs(anchors) do
		local frame = CreateFrame("Frame", nil, parent)
		frame:SetPoint(v[1], parent, v[1], 0, v[2])
		frame:SetSize(width, height)
		frame:SetFrameStrata("BACKGROUND")

		local tex = B.CreateGA(frame, "H", 0, 0, 0, v[3], v[4], width, height)
		tex:SetPoint("CENTER")
		local bottomLine = B.CreateGA(frame, "H", cr, cg, cb, v[5], v[6], width, C.mult*2)
		bottomLine:SetPoint("TOP", frame, "BOTTOM")
		local topLine = B.CreateGA(frame, "H", cr, cg, cb, v[5], v[6], width, C.mult*2)
		topLine:SetPoint("BOTTOM", frame, "TOP")
	end
end

function IB:OnLogin()
	if NDuiADB["DisableInfobars"] then return end

	if not self.modules then return end
	for _, info in pairs(self.modules) do
		self:LoadInfobar(info)
	end

	self:BackgroundLines()
	self.loginTime = GetTime()

	if not C.Infobar.AutoAnchor then return end
	for index, info in pairs(self.modules) do
		if index == 1 or index == 6 then
			info.text:SetPoint(unpack(info.point))
		elseif index < 6 then
			info.text:SetPoint("LEFT", self.modules[index-1], "RIGHT", 30, 0)
			info.text:SetJustifyH("LEFT")
		else
			info.text:SetPoint("RIGHT", self.modules[index-1], "LEFT", -30, 0)
			info.text:SetJustifyH("RIGHT")
		end
	end
end