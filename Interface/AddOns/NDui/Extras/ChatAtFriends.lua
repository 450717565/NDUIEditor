-------------------------------------
-- 密语战网时，显示好友WOW角色信息
-- Author:M
-------------------------------------

local _, ns = ...
local B, C, L, DB = unpack(ns)

local LOCAL_CLASS_INFO = {}
do
	local localClass, class
	for i = 1, GetNumClasses() do
		localClass, class = GetClassInfo(i)
		LOCAL_CLASS_INFO[localClass] = DB.ClassColors[class] or NORMAL_FONT_COLOR
		LOCAL_CLASS_INFO[localClass].class = class
	end
end

local function GetWowFriendAccountInfo(friendIndex)
	local gameAccountInfo
	local accountInfo = C_BattleNet.GetFriendAccountInfo(friendIndex)
	local numGameAccounts = C_BattleNet.GetFriendNumGameAccounts(friendIndex)
	if numGameAccounts > 1 then
		for i = 1, numGameAccounts do
			gameAccountInfo = C_BattleNet.GetFriendGameAccountInfo(friendIndex, i)
			if gameAccountInfo and gameAccountInfo.clientProgram == BNET_CLIENT_WOW then
				return {
						bname = accountInfo.accountName,
						name  = gameAccountInfo.characterName,
						level = gameAccountInfo.characterLevel,
						class = gameAccountInfo.className,
						area  = gameAccountInfo.areaName,
						faction = gameAccountInfo.factionName,
						isBNet  = true,
					  }
			end
		end
	elseif accountInfo and accountInfo.gameAccountInfo.clientProgram == BNET_CLIENT_WOW then
		return {
				bname = accountInfo.accountName,
				name  = accountInfo.gameAccountInfo.characterName,
				level = accountInfo.gameAccountInfo.characterLevel,
				class = accountInfo.gameAccountInfo.className,
				area  = accountInfo.gameAccountInfo.areaName,
				faction = accountInfo.gameAccountInfo.factionName,
				isBNet = true,
			  }
	end
end

local function ShowBNetWoWAccountInfo(editBox, info)
	local bname = editBox:GetAttribute("tellTarget")
	if info and info.bname == bname then
		local classInfo = LOCAL_CLASS_INFO[info.class]
		editBox.nametip.name:SetText(info.name)
		editBox.nametip.level:SetText(info.level)
		editBox.nametip.name:SetTextColor(classInfo.r, classInfo.g, classInfo.b)
		if (editBox.nametip.faction == info.faction) then
			editBox.nametip.icon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
			editBox.nametip.icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classInfo.class]))
		else
			editBox.nametip.icon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..info.faction)
			editBox.nametip.icon:SetTexCoord(0, 44/64, 0, 44/64)
		end
		editBox.nametip:Show()

		return true
	end
end

hooksecurefunc("ChatEdit_UpdateHeader", function(editBox)
	if not editBox.nametip then
		local nametip = CreateFrame("Frame", nil, editBox)
		nametip:SetSize(150, 20)
		nametip:SetPoint("BOTTOMLEFT", editBox, "TOPLEFT", 30, 2)
		editBox.nametip = nametip

		local icon = editBox.nametip:CreateTexture(nil, "BORDER")
		icon:SetSize(20, 20)
		icon:SetPoint("LEFT", 0, 0)
		icon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
		editBox.nametip.icon = icon

		local name = B.CreateFS(editBox.nametip, 16)
		name:SetJustifyH("LEFT")
		B.UpdatePoint(name, "LEFT", icon, "RIGHT", 0, 0)
		editBox.nametip.name = name

		local level = B.CreateFS(editBox.nametip, 12)
		B.ReskinText(level, 1, .8, 0)
		B.UpdatePoint(level, "BOTTOM", icon, "TOP", 0, 0)
		editBox.nametip.level = level

		local faction = UnitFactionGroup("player")
		editBox.nametip.faction = faction
	end

	if editBox:GetAttribute("chatType") == "BN_WHISPER" then
		local numBNetTotal, numBNetOnline, numBNetFavorite, numBNetFavoriteOnline = BNGetNumFriends()
		local bnetFriendIndex = 0
		for i = 1, numBNetFavorite do
			bnetFriendIndex = bnetFriendIndex + 1
			if (ShowBNetWoWAccountInfo(editBox,GetWowFriendAccountInfo(bnetFriendIndex))) then
				return
			end
		end
		for i = 1, numBNetOnline - numBNetFavoriteOnline do
			bnetFriendIndex = bnetFriendIndex + 1
			if (ShowBNetWoWAccountInfo(editBox,GetWowFriendAccountInfo(bnetFriendIndex))) then
				return
			end
		end
	else
		editBox.nametip:Hide()
	end
end)