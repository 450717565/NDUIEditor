local LookingForGroup = LibStub("AceAddon-3.0"):GetAddon("LookingForGroup")
local LookingForGroup_Options = LibStub("AceAddon-3.0"):GetAddon("LookingForGroup_Options")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")


function LookingForGroup_Options.Background_Timer_Stop()
	if LookingForGroup_Options.Background_Timer then
		LookingForGroup_Options:CancelTimer(LookingForGroup_Options.Background_Timer)
		LookingForGroup_Options.Background_Timer = nil
	end
end

function LookingForGroup_Options.Background_Timer_Start(...)
	LookingForGroup_Options.Background_Timer_Stop()
	if not LookingForGroup.db.profile.hardware then
		LookingForGroup_Options.Background_Timer = LookingForGroup_Options:ScheduleTimer(...)
	end
end

function LookingForGroup_Options.Background_Sceduled_Timer_Start(...)
	LookingForGroup_Options.Background_Timer_Stop()
	LookingForGroup_Options.Background_Timer = LookingForGroup_Options:ScheduleRepeatingTimer(...)
end

local isplaying

function LookingForGroup_Options.Background_NoSearchResult_StartMusic()
	if isplaying ~= nil and isplaying ~= true then
		if LookingForGroup_Options.db.profile.background_enable_music then
			StopMusic()
		end
	end
	isplaying = nil
end

function LookingForGroup_Options.Background_ResultReceived()
	return isplaying
end

function LookingForGroup_Options.Background_Notifing_Music()
	if isplaying == nil then
		if AceConfigDialog.OpenFrames.LookingForGroup then
			isplaying = true
		else
			isplaying = LookingForGroup_Options.db.profile.background_music
			if LookingForGroup_Options.db.profile.background_enable_music then
				PlayMusic(isplaying)
			end
			if LookingForGroup_Options.db.profile.background_message then
				LookingForGroup:Print("|cffff00ff"..KBASE_SEARCH_RESULTS.."|r")
			end
		end
	end
end
