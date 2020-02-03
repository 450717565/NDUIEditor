-------------------------------------
-- 战网好友显示角色信息
-- Author:M
-------------------------------------

local B, C, L, DB = unpack(select(2, ...))
local Extras = B:GetModule("Extras")

--職業顔色值
local LOCAL_CLASS_INFO = {}

do
	local localClass, class
	for i = 1, GetNumClasses() do
		localClass, class = GetClassInfo(i)
		LOCAL_CLASS_INFO[localClass] = DB.ClassColors[class] or NORMAL_FONT_COLOR
		LOCAL_CLASS_INFO[localClass].class = class
	end
end

hooksecurefunc("ChatEdit_UpdateHeader", function(editBox)
	if not editBox.nametip then
		local nametip = CreateFrame("Frame", nil, editBox)
		nametip:SetPoint("BOTTOMLEFT", editBox, "TOPLEFT", 30, 2)
		nametip:SetSize(150, 20)
		editBox.nametip = nametip

		local icon = editBox.nametip:CreateTexture(nil, "BORDER")
		icon:SetSize(20, 20)
		icon:SetPoint("LEFT", 0, 0)
		icon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
		editBox.nametip.icon = icon

		local name = B.CreateFS(editBox.nametip, 16)
		name:ClearAllPoints()
		name:SetPoint("LEFT", icon, "RIGHT", 0, 0)
		name:SetJustifyH("LEFT")
		editBox.nametip.name = name

		local level = B.CreateFS(editBox.nametip, 12)
		level:ClearAllPoints()
		level:SetPoint("BOTTOM", icon, "TOP", 0, 0)
		level:SetTextColor(1, .8, 0)
		level:SetJustifyH("CENTER")
		editBox.nametip.level = level

		local faction = UnitFactionGroup("player")
		editBox.nametip.faction = faction
	end
	if editBox:GetAttribute("chatType") == "BN_WHISPER" then
		local bname = editBox:GetAttribute("tellTarget")
		local _, numBNetOnline = BNGetNumFriends()
		for i = 1, numBNetOnline do
			local _, accountName, _, _, _, bnetIDGameAccount, client = BNGetFriendInfo(i)
			if bname == accountName and client == "WoW" and bnetIDGameAccount then
				local gameInfo = C_BattleNet.GetGameAccountInfoByID(bnetIDGameAccount)
				local name = gameInfo.characterName
				local faction = gameInfo.factionName
				local class = gameInfo.className
				local area = gameInfo.areaName
				local level = gameInfo.characterLevel
				local color = LOCAL_CLASS_INFO[class]

				editBox.nametip.name:SetText(name)
				editBox.nametip.name:SetTextColor(color.r, color.g, color.b)
				editBox.nametip.level:SetText(level)

				if editBox.nametip.faction == faction then
					editBox.nametip.icon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
					editBox.nametip.icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[color.class]))
				else
					editBox.nametip.icon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..faction)
					editBox.nametip.icon:SetTexCoord(0, 44/64, 0, 44/64)
				end

				return editBox.nametip:Show()
			end
		end
		editBox.nametip:Hide()
	else
		editBox.nametip:Hide()
	end
end)