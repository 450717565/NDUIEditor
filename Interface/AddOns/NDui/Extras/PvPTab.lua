local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function (event, ...)
    local bindSet = GetCurrentBindingSet()
    local pvpType = GetZonePVPInfo()
    local _, zoneType = IsInInstance()

    if zoneType == "arena" or zoneType == "pvp" or pvpType == "combat" or event == "DUEL_REQUESTED" then
        SetBinding("TAB", "TARGETNEARESTENEMYPLAYER")
        SetBinding("SHIFT-TAB", "TARGETPREVIOUSENEMYPLAYER")
		--print("TAB目标选择增强功能 |cff00FF00已开启")
    else
        SetBinding("TAB", "TARGETNEARESTENEMY")
        SetBinding("SHIFT-TAB", "TARGETPREVIOUSENEMY")
		--print("TAB目标选择增强功能 |cffFF0000已关闭")
    end

    SaveBindings(bindSet)
end)

frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame:RegisterEvent("DUEL_REQUESTED")
frame:RegisterEvent("DUEL_FINISHED")