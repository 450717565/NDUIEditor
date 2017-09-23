local B, C, L, DB = unpack(select(2, ...))

local size = 33
local width = 250
local height = 25
local points = {"CENTER", UIParent, "BOTTOM", 0, 250}

local function HideTip1()
	GameTooltip:Hide()
end

local function HideTip2()
	GameTooltip:Hide()
	ResetCursor()
end

local function ClickRoll(frame)
	RollOnLoot(frame.parent.rollid, frame.rolltype)
end

local rolltypes = {"need", "greed", "disenchant", [0] = "pass"}
local function SetTip(frame)
	GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
	GameTooltip:SetText(frame.tiptext)
	if not frame:IsEnabled() then
		GameTooltip:AddLine("|cff7FFF00"..frame.errtext)
	end
	for name,roll in pairs(frame.parent.rolls) do
		if roll == rolltypes[frame.rolltype] then
			GameTooltip:AddLine(name, 1, 1, 1)
		end
	end
	GameTooltip:Show()
end

local function SetItemTip(frame)
	if not frame.link then return end
	GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT")
	GameTooltip:SetHyperlink(frame.link)
	if IsShiftKeyDown() then GameTooltip_ShowCompareItem() end
	if IsModifiedClick("DRESSUP") then ShowInspectCursor() else ResetCursor() end
end

local function ItemOnUpdate(self)
	if IsShiftKeyDown() then GameTooltip_ShowCompareItem() end
	CursorOnUpdate(self)
end

local function LootClick(frame)
	if IsControlKeyDown() then
		DressUpItemLink(frame.link)
	elseif IsShiftKeyDown() then
		ChatEdit_InsertLink(frame.link)
	end
end

local cancelled_rolls = {}
local function OnEvent(frame, event, rollid)
	cancelled_rolls[rollid] = true
	if frame.rollid ~= rollid then return end

	frame.rollid = nil
	frame.time = nil
	frame:Hide()
end

local function StatusUpdate(frame)
	local t = GetLootRollTimeLeft(frame.parent.rollid)
	local perc = t / frame.parent.time
	frame.Spark:SetPoint("CENTER", frame, "LEFT", perc * frame:GetWidth(), 0)
	frame:SetValue(t)
end

local function CreateRollButton(parent, ntex, ptex, htex, rolltype, tiptext, ...)
	local f = CreateFrame("Button", nil, parent)
	f:SetPoint(...)
	f:SetSize(28, 28)
	f:SetNormalTexture(ntex)
	if ptex then f:SetPushedTexture(ptex) end
	f:SetHighlightTexture(htex)
	f.rolltype = rolltype
	f.parent = parent
	f.tiptext = tiptext
	f:SetScript("OnEnter", SetTip)
	f:SetScript("OnLeave", HideTip1)
	f:SetScript("OnClick", ClickRoll)
	f:SetMotionScriptsWhileDisabled(true)

	local txt = B.CreateFS(f, 10, "")
	txt:SetPoint("CENTER", 0, rolltype == 2 and 2 or rolltype == 0 and -1.2 or 0)

	return f, txt
end

local function CreateRollFrame()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetSize(width, size)
	frame:SetScript("OnEvent", OnEvent)
	frame:RegisterEvent("CANCEL_LOOT_ROLL")
	frame:Hide()

	local button = CreateFrame("Button", nil, frame)
	button:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT")
	button:SetSize(size, size)
	button:SetScript("OnEnter", SetItemTip)
	button:SetScript("OnLeave", HideTip2)
	button:SetScript("OnUpdate", ItemOnUpdate)
	button:SetScript("OnClick", LootClick)
	B.CreateSD(button, 3, 3)
	frame.button = button

	local icBD = CreateFrame("Frame", nil, button)
	icBD:SetAllPoints()
	B.CreateBD(icBD, .5, 1, true)
	frame.icBD = icBD

	local icon = icBD:CreateTexture(nil, "ARTWORK")
	icon:SetAlpha(.8)
	icon:SetTexCoord(.08, .92, .08, .92)
	icon:SetPoint("TOPLEFT", 1, -1)
	icon:SetPoint("BOTTOMRIGHT", -1, 1)
	frame.icon = icon

	local status = CreateFrame("StatusBar", nil, frame)
	status:SetSize(width-40, 10)
	status:SetPoint("BOTTOMLEFT", button, "BOTTOMRIGHT", 5, 0)
	status:SetScript("OnUpdate", StatusUpdate)
	status:SetFrameLevel(status:GetFrameLevel()-1)
	B.CreateSB(status, true)
	frame.status = status

	status.parent = frame

	local need, needtext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-Dice-Up", "Interface\\Buttons\\UI-GroupLoot-Dice-Highlight", "Interface\\Buttons\\UI-GroupLoot-Dice-Down", 1, NEED, "BOTTOMLEFT", frame.status, "BOTTOMLEFT", 5, -1)
	local greed, greedtext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-Coin-Up", "Interface\\Buttons\\UI-GroupLoot-Coin-Highlight", "Interface\\Buttons\\UI-GroupLoot-Coin-Down", 2, GREED, "LEFT", need, "RIGHT", 0, -3)
	local disenchant, dctext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-DE-Up", "Interface\\Buttons\\UI-GroupLoot-DE-Highlight", "Interface\\Buttons\\UI-GroupLoot-DE-Down", 3, ROLL_DISENCHANT, "LEFT", greed, "RIGHT", 0, 3)
	local pass, passtext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-Pass-Up", nil, "Interface\\Buttons\\UI-GroupLoot-Pass-Down", 0, PASS, "BOTTOMRIGHT", frame.status, "BOTTOMRIGHT", 32, -3)

	frame.needbutt, frame.greedbutt, frame.disenchantbutt = need, greed, disenchant
	frame.need, frame.greed, frame.pass, frame.disenchant = needtext, greedtext, passtext, dctext

	local ilvl = B.CreateFS(icBD, 14, "", false, "BOTTOMRIGHT", -1, 1)
	ilvl:SetJustifyH("RIGHT")
	frame.ilvl = ilvl

	local bind = B.CreateFS(frame, 13, "")
	bind:SetJustifyH("LEFT")
	bind:SetPoint("LEFT", disenchant or greed, "RIGHT", 0, -1)
	frame.fsbind = bind

	local loot = B.CreateFS(frame, 14, "")
	loot:SetJustifyH("LEFT")
	loot:SetPoint("LEFT", bind, "RIGHT", 2, 0)
	loot:SetPoint("RIGHT", frame, "RIGHT", -2, 0)
	frame.fsloot = loot

	frame.rolls = {}

	return frame
end

local LightRoll = CreateFrame("Button", "LightRoll", UIParent)
LightRoll:SetSize(width, height)

local frames = {}

local f = CreateRollFrame() -- Create one for good measure
f:SetPoint("BOTTOMLEFT", next(frames) and frames[#frames] or LightRoll, "TOPLEFT", 0, 5)
table.insert(frames, f)

local function GetFrame()
	for i,f in ipairs(frames) do
		if not f.rollid then return f end
	end

	local f = CreateRollFrame()
	f:SetPoint("BOTTOMLEFT", next(frames) and frames[#frames] or LightRoll, "TOPLEFT", 0, 5)
	table.insert(frames, f)
	return f
end

local function FindFrame(rollid)
	for _,f in ipairs(frames) do
		if f.rollid == rollid then return f end
	end
end

local typemap = {[0] = "pass", "need", "greed", "disenchant"}
local function UpdateRoll(i, rolltype)
	local num = 0
	local rollid, itemLink, numPlayers, isDone = C_LootHistory.GetItem(i)

	if isDone or not numPlayers then return end

	local f = FindFrame(rollid)
	if not f then return end

	for j = 1, numPlayers do
		local name, class, thisrolltype = C_LootHistory.GetPlayerInfo(i, j)
		f.rolls[name] = typemap[thisrolltype]
		if rolltype == thisrolltype then num = num + 1 end
	end

	f[typemap[rolltype]]:SetText(num)
end

local function START_LOOT_ROLL(rollid, time)
	if cancelled_rolls[rollid] then return end

	local f = GetFrame()
	f.rollid = rollid
	f.time = time
	for i in pairs(f.rolls) do f.rolls[i] = nil end
	f.need:SetText(0)
	f.greed:SetText(0)
	f.pass:SetText(0)
	f.disenchant:SetText(0)

	local texture, name, count, quality, bop, canNeed, canGreed, canDisenchant, reasonNeed, reasonGreed, reasonDisenchant, deSkillRequired = GetLootRollItemInfo(rollid)
	f.icon:SetTexture(texture)
	f.button.link = GetLootRollItemLink(rollid)

	if canNeed then
		f.needbutt:Enable()
		f.needbutt:SetAlpha(1.0)
		SetDesaturation(f.needbutt:GetNormalTexture(), false)
	else
		f.needbutt:Disable()
		f.needbutt:SetAlpha(0.35)
		SetDesaturation(f.needbutt:GetNormalTexture(), true)
		f.needbutt.errtext = _G["LOOT_ROLL_INELIGIBLE_REASON"..reasonNeed]
	end

	if canGreed then
		f.greedbutt:Enable()
		f.greedbutt:SetAlpha(1.0)
		SetDesaturation(f.greedbutt:GetNormalTexture(), false)
	else
		f.greedbutt:Disable()
		f.greedbutt:SetAlpha(0.35)
		SetDesaturation(f.greedbutt:GetNormalTexture(), true)
		f.greedbutt.errtext = _G["LOOT_ROLL_INELIGIBLE_REASON"..reasonGreed]
	end

	if canDisenchant then
		f.disenchantbutt:Enable()
		f.disenchantbutt:SetAlpha(1.0)
		SetDesaturation(f.disenchantbutt:GetNormalTexture(), false)
	else
		f.disenchantbutt:Disable()
		f.disenchantbutt:SetAlpha(0.35)
		SetDesaturation(f.disenchantbutt:GetNormalTexture(), true)
		f.disenchantbutt.errtext = format(_G["LOOT_ROLL_INELIGIBLE_REASON"..reasonDisenchant], deSkillRequired)
	end

	if f.button.link and quality > 0 then
		local itemLvl = B.GetItemLevel(f.button.link, quality)
		f.ilvl:SetText(itemLvl)
		f.ilvl:Show()
	else
		f.ilvl:Hide()
	end

	local color = BAG_ITEM_QUALITY_COLORS[quality]
	f.fsloot:SetText(name)
	f.fsloot:SetTextColor(color.r, color.g, color.b)

	f:SetBackdropBorderColor(color.r, color.g, color.b, 1)
	f.icBD:SetBackdropBorderColor(color.r, color.g, color.b, 1)

	f.status:SetMinMaxValues(0, time)
	f.status:SetValue(time)

	f.fsbind:SetText(not bop and "BoE" or "")

	f:SetPoint("CENTER", WorldFrame, "CENTER")
	f:Show()
end

local function LOOT_HISTORY_ROLL_CHANGED(rollindex, playerindex)
	local _, _, rolltype = C_LootHistory.GetPlayerInfo(rollindex, playerindex)
	UpdateRoll(rollindex, rolltype)
end

LightRoll:RegisterEvent("ADDON_LOADED")
LightRoll:SetScript("OnEvent", function(frame, event, addon)
	B.Mover(LightRoll, "LightRoll", "LightRoll", points, width, height)

	LightRoll:UnregisterEvent("ADDON_LOADED")
	LightRoll:RegisterEvent("START_LOOT_ROLL")
	LightRoll:RegisterEvent("LOOT_HISTORY_ROLL_CHANGED")
	UIParent:UnregisterEvent("START_LOOT_ROLL")
	UIParent:UnregisterEvent("CANCEL_LOOT_ROLL")

	LightRoll:SetScript("OnEvent", function(frame, event, ...)
		if event == "LOOT_HISTORY_ROLL_CHANGED" then
			return LOOT_HISTORY_ROLL_CHANGED(...)
		else
			return START_LOOT_ROLL(...)
		end
	end)
end)