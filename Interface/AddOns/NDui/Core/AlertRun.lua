-------------------------------------------------------------------------------------
-- Credit Alleykat
-- Entering combat and alertrun function (can be used in anther ways)
------------------------------------------------------------------------------------
local _, ns = ...
local B, C, L, DB = unpack(ns)
local cr, cg, cb = DB.CC.r, DB.CC.g, DB.CC.b

local speed = .057799924
local point = {"CENTER", UIParent, "CENTER", -300, 180}

local GetNextChar = function(word, num)
	local bytes = word:byte(num)
	local shifts
	if not bytes then return "", num end
	if (bytes > 0 and bytes <= 127) then
		shifts = 1
	elseif (bytes >= 192 and bytes <= 223) then
		shifts = 2
	elseif (bytes >= 224 and bytes <= 239) then
		shifts = 3
	elseif (bytes >= 240 and bytes <= 247) then
		shifts = 4
	end
	return word:sub(num, num + shifts - 1), (num + shifts)
end

local flowingframe = CreateFrame("Frame", "AlertRun", UIParent)
flowingframe:RegisterEvent("PLAYER_LOGIN")
flowingframe:SetFrameStrata("HIGH")
flowingframe:SetHeight(64)
flowingframe:SetScript("OnEvent", function()
	B.Mover(flowingframe, "B.AlertRun", "AlertRun", point, 80, 30)
end)

local flowingtext = B.CreateFS(flowingframe, 24, "")
local rightchar = B.CreateFS(flowingframe, 60, "")

local count, length, step, word, strings, val, backstep

local nextstep = function()
	val, step = GetNextChar(word, step)
	flowingtext:SetText(strings)
	strings = strings..val
	val = string.upper(val)
	rightchar:SetText(val)
end

local backrun = CreateFrame("Frame")
backrun:Hide()

local updatestring = function(self, tm)
	count = count - tm
	if count < 0 then
		count = speed
		if step > length then
			self:Hide()

			flowingtext:SetText(strings)
			flowingtext:ClearAllPoints()
			flowingtext:SetPoint("RIGHT")
			flowingtext:SetJustifyH("RIGHT")

			rightchar:SetText("")
			rightchar:ClearAllPoints()
			rightchar:SetPoint("RIGHT",flowingtext,"LEFT")
			rightchar:SetJustifyH("RIGHT")

			count = 1.456789
			backrun:Show()
		else
			nextstep()
		end
	end
end

local updaterun = CreateFrame("Frame")
updaterun:SetScript("OnUpdate", updatestring)
updaterun:Hide()

local backstepf = function()
	local val = backstep
	local firstchar = ""
	local texttemp = ""
	local flagon = true
	while val <= length do
		local su
		su, val = GetNextChar(word, val)
		if flagon == true then
			backstep = val
			flagon = false
			firstchar = su
		else
			texttemp = texttemp..su
		end
	end
	firstchar = string.upper(firstchar)
	flowingtext:SetText(texttemp)
	rightchar:SetText(firstchar)
end

local rollback = function(self, tm)
	count = count - tm
	if count < 0 then
		count = speed
		if backstep > length then
			self:Hide()
			flowingtext:SetText("")
			rightchar:SetText("")
		else
			backstepf()
		end
	end
end

backrun:SetScript("OnUpdate", rollback)

function B.AlertRun(text, r, g, b)
	flowingframe:Hide()
	updaterun:Hide()
	backrun:Hide()
	flowingtext:SetText(text)

	local width = flowingtext:GetWidth()
	local colorr = r or cr
	local colorg = g or cg
	local colorb = b or cb

	flowingframe:SetWidth(width)
	flowingtext:SetTextColor(colorr*.95, colorg*.95, colorb*.95)
	rightchar:SetTextColor(colorr, colorg, colorb)

	word = text
	length = text:len()
	step, backstep = 1, 1
	count = speed
	strings = ""
	val = ""

	flowingtext:SetText("")
	flowingtext:ClearAllPoints()
	flowingtext:SetPoint("LEFT")
	flowingtext:SetJustifyH("LEFT")

	rightchar:SetText("")
	rightchar:ClearAllPoints()
	rightchar:SetPoint("LEFT",flowingtext,"RIGHT")
	rightchar:SetJustifyH("LEFT")

	updaterun:Show()
	flowingframe:Show()
end