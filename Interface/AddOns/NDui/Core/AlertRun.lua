-------------------------------------------------------------------------------------
-- Credit Alleykat
-- Entering combat and alertrun function (can be used in anther ways)
------------------------------------------------------------------------------------
local B, C, L, DB = unpack(select(2, ...))
local cr, cg, cb = DB.ClassColor.r, DB.ClassColor.g, DB.ClassColor.b

local speed = .057799924
local point = {"CENTER", UIParent, "CENTER", -300, 200}

local GetNextChar = function(word, num)
	local c = word:byte(num)
	local shift
	if not c then return "", num end
	if (c > 0 and c <= 127) then
		shift = 1
	elseif (c >= 192 and c <= 223) then
		shift = 2
	elseif (c >= 224 and c <= 239) then
		shift = 3
	elseif (c >= 240 and c <= 247) then
		shift = 4
	end
	return word:sub(num, num + shift - 1), (num + shift)
end

local updaterun = CreateFrame("Frame")

local flowingframe = CreateFrame("Frame", "AlertRun", UIParent)
flowingframe:SetFrameStrata("HIGH")
flowingframe:SetPoint("CENTER")
flowingframe:SetHeight(64)
B.Mover(flowingframe, L["AlertRun"], "AlertRun", point, 64, 30)

local flowingtext = B.CreateFS(flowingframe, 24, "")

local rightchar = B.CreateFS(flowingframe, 60, "")
rightchar:SetJustifyH("LEFT") -- left or right

local count, len, step, word, stringE, a, backstep

local nextstep = function()
	a,step = GetNextChar (word,step)
	flowingtext:SetText(stringE)
	stringE = stringE..a
	a = string.upper(a)
	rightchar:SetText(a)
end

local backrun = CreateFrame("Frame")
backrun:Hide()

local updatestring = function(self, t)
	count = count - t
	if count < 0 then
		count = speed
		if step > len then
			self:Hide()
			flowingtext:SetText(stringE)
			rightchar:SetText()
			flowingtext:ClearAllPoints()
			flowingtext:SetPoint("RIGHT")
			flowingtext:SetJustifyH("RIGHT")
			rightchar:ClearAllPoints()
			rightchar:SetPoint("RIGHT",flowingtext,"LEFT")
			rightchar:SetJustifyH("RIGHT")
			self:Hide()
			count = 1.456789
			backrun:Show()
		else
			nextstep()
		end
	end
end

updaterun:SetScript("OnUpdate", updatestring)
updaterun:Hide()

local backstepf = function()
	local a = backstep
	local firstchar
	local texttemp = ""
	local flagon = true
	while a <= len do
		local u
		u, a = GetNextChar(word, a)
		if flagon == true then
			backstep = a
			flagon = false
			firstchar = u
		else
			texttemp = texttemp..u
		end
	end
	flowingtext:SetText(texttemp)
	firstchar = string.upper(firstchar)
	rightchar:SetText(firstchar)
end

local rollback = function(self, t)
	count = count - t
	if count < 0 then
		count = speed
		if backstep > len then
			self:Hide()
			flowingtext:SetText()
			rightchar:SetText()
		else
			backstepf()
		end
	end
end

backrun:SetScript("OnUpdate", rollback)

B.AlertRun = function(text, r, g, b)
	flowingframe:Hide()
	updaterun:Hide()
	backrun:Hide()

	flowingtext:SetText(text)
	local width = flowingtext:GetWidth()

	local color1 = r or cr
	local color2 = g or cg
	local color3 = b or cb

	flowingtext:SetTextColor(color1*.95,color2*.95,color3*.95)
	rightchar:SetTextColor(color1,color2,color3)

	word = text
	len = text:len()
	step, backstep = 1, 1
	count = speed
	stringE = ""
	a = ""

	flowingtext:SetText("")
	flowingframe:SetWidth(width)
	flowingtext:ClearAllPoints()
	flowingtext:SetPoint("LEFT")
	flowingtext:SetJustifyH("LEFT")
	rightchar:ClearAllPoints()
	rightchar:SetPoint("LEFT",flowingtext,"RIGHT")
	rightchar:SetJustifyH("LEFT")

	rightchar:SetText("")
	updaterun:Show()
	flowingframe:Show()
end