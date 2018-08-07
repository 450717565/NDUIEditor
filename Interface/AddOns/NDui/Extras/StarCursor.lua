local B, C, L, DB = unpack(select(2, ...))

local frame = CreateFrame("Frame", nil, UIParent)
frame:SetFrameStrata("TOOLTIP")

local flash = frame:CreateTexture(nil, "ARTWORK")
flash:SetTexture(DB.newItemFlash)
flash:SetBlendMode("ADD")
flash:SetAlpha(.6)

local x, y, speed = 0, 0, 0
local function OnUpdate(_, elapsed)
	if not NDuiDB["Extras"]["StarCursor"] then return end
	local dX, dY = x, y
	x, y = GetCursorPosition()
	dX = x - dX
	dY = y - dY
	local weight = 2048 ^ - elapsed
	speed = math.min(weight * speed + (1 - weight) * math.sqrt(dX * dX + dY * dY) / elapsed, 1024)
	local size = speed / 10 - 20
	if size > 0 then
		local scale = UIParent:GetEffectiveScale()
		flash:SetSize(size, size)
		flash:SetPoint("CENTER", UIParent, "BOTTOMLEFT", (x + 0.5 * dX) / scale, (y + 0.5 * dY) / scale)
		flash:Show()
	else
		flash:Hide()
	end
end

frame:SetScript("OnUpdate", OnUpdate)