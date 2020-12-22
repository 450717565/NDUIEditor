local _, ns = ...
local B, C, L, DB = unpack(ns)
local Extras = B:GetModule("Extras")
-----------------
-- Credit: ElvUI
-- 修改：雨夜独行客
-----------------

local GuidCache = {}
local ClassNames = {}
local chatEvents = DB.ChatEvents

local isCalling = false
function Extras:GetPlayerInfoByGUID(guid)
	if isCalling then return end

	local data = GuidCache[guid]
	if not data then
		isCalling = true
		local ok, localizedClass, englishClass, localizedRace, englishRace, sex, name, realm = pcall(GetPlayerInfoByGUID, guid)
		isCalling = false

		if not (ok and englishClass) then return end

		if realm == '' then realm = nil end
		local nameWithRealm
		if name and name ~= '' then
			nameWithRealm = (realm and name..'-'..realm) or name..'-'..DB.MyRealm
		end

		data = {
			localizedClass = localizedClass,
			englishClass = englishClass,
			localizedRace = localizedRace,
			englishRace = englishRace,
			sex = sex,
			name = name,
			realm = realm,
			nameWithRealm = nameWithRealm,
		}

		if name then
			ClassNames[strlower(name)] = englishClass
		end
		if nameWithRealm then
			ClassNames[strlower(nameWithRealm)] = englishClass
		end

		GuidCache[guid] = data
	end

	return data
end

function Extras:ClassFilter(message)
	local isFirstWord, rebuiltString

	for word in gmatch(message, '%s-%S+%s*') do
		local tempWord = gsub(word,'^[%s%p]-([^%s%p]+)([%-]?[^%s%p]-)[%s%p]*$','%1%2')
		local lowerCaseWord = strlower(tempWord)

		local classMatch = ClassNames[lowerCaseWord]
		local wordMatch = classMatch and lowerCaseWord

		if wordMatch then
			local r, g, b = B.ClassColor(classMatch)
			word = gsub(word, gsub(tempWord, '%-','%%-'), format('\124cff%.2x%.2x%.2x%s\124r', r*255, g*255, b*255, tempWord))
		end

		if not isFirstWord then
			rebuiltString = word
			isFirstWord = true
		else
			rebuiltString = format('%s%s', rebuiltString, word)
		end
	end

	return rebuiltString
end

function Extras:UpdateBubbleColor()
	local backdrop = self.backdrop
	local str = backdrop and backdrop.String
	local text = str and str:GetText()
	local rebuiltString = text and Extras:ClassFilter(text)

	if rebuiltString then
		str:SetText(RemoveExtraSpaces(rebuiltString))
	end
end

function Extras:HookBubble(frame, backdrop)
	if frame.isHooked then return end

	if not frame.backdrop then
		frame.backdrop = backdrop
		frame:HookScript('OnShow', Extras.UpdateBubbleColor)
		Extras.UpdateBubbleColor(frame)
	end

	frame.isHooked = true
end

function Extras:UpdateChatColor(event, msg, ...)
	msg = Extras:ClassFilter(msg) or msg
	return false, msg, ...
end

function Extras:ChatClassColor()
	ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", Extras.UpdateChatColor)
	for _, event in pairs(chatEvents) do
		ChatFrame_AddMessageEventFilter(event, Extras.UpdateChatColor)
	end

	hooksecurefunc("GetPlayerInfoByGUID",function(...)
		Extras:GetPlayerInfoByGUID(...)
	end)
end