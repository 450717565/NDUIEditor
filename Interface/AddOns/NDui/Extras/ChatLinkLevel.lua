------------------------------------------------ 聊天超鏈接增加物品等級 (支持大祕境鑰匙等級)-- @Author:M----------------------------------------------local B, C, L, DB = unpack(select(2, ...))local function ChatItemLevel(Hyperlink)	local itemLink = string.match(Hyperlink, "|H(.-)|h")	local _, _, itemRarity, _, _, _, itemSubType, _, itemEquipLoc, itemTexture, _, itemClassID, itemSubClassID, bindType = GetItemInfo(itemLink)	if not itemTexture then return end	local slotText, totalText	local level = NDui:GetItemLevel(itemLink, itemRarity)	if itemEquipLoc and string.find(itemEquipLoc, "INVTYPE_") then		slotText = _G[itemEquipLoc] or ""	end	if itemEquipLoc and string.find(itemEquipLoc, "INVTYPE_FEET") then		slotText = L["Feet"] or ""	elseif itemEquipLoc and string.find(itemEquipLoc, "INVTYPE_HAND") then		slotText = L["Hands"] or ""	elseif itemEquipLoc and string.find(itemEquipLoc, "INVTYPE_HOLDABLE") then		slotText = INVTYPE_WEAPONOFFHAND or ""	elseif itemEquipLoc and string.find(itemEquipLoc, "INVTYPE_SHIELD") then		slotText = itemSubType or ""	elseif itemSubType and string.find(itemSubType, RELICSLOT) then		slotText = RELICSLOT or ""	elseif (itemClassID and itemClassID == 15 and itemSubClassID) and (itemSubClassID == 2 or itemSubClassID == 5) then		slotText = (itemSubClassID == 2 and PET) or (itemSubClassID == 5 and itemSubType) or ""	end	if bindType and (bindType == 2 or bindType == 3) then		slotText = (bindType == 2 and "BoE") or (bindType == 3 and "BoU") or ""	end	if level and slotText then		totalText = "<"..level.."-"..slotText..">"	elseif level then		totalText = "<"..level..">"	elseif slotText then		totalText = "<"..slotText..">"	else		totalText = ""	end	if totalText then		Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h[%1"..totalText.."]|h")	end	return Hyperlinkendlocal function KeystoneLevel(Hyperlink)	local map, level, name = string.match(Hyperlink, "|Hkeystone:(%d+):(%d+):.-|h(.-)|h")	if (map and level and name and not string.find(name, level)) then		name = C_ChallengeMode.GetMapInfo(map)		Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h["..name.."+"..level.."]|h")	end	return Hyperlinkendlocal function filter(self, event, msg, ...)	msg = msg:gsub("(|Hitem:%d+:.-|h.-|h)", ChatItemLevel)	msg = msg:gsub("(|Hkeystone:%d+:%d+:.-|h.-|h)", KeystoneLevel)	return false, msg, ...endChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filter)ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filter)ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filter)ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD_LEADER", filter)ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", filter)ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter)ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE", filter)ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_LEADER", filter)ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", filter)ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filter)ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", filter)ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", filter)ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filter)ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", filter)ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", filter)ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", filter)