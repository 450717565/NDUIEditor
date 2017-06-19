local myname, ns = ...

ns.defaults = {
    profile = {
        -- found = false,
        icon_scale = 1.5,
        icon_alpha = 1.0,
        icon_item = true,
    },
    char = {
        hidden = {
            ['*'] = {},
        },
    },
}

ns.options = {
    type = "group",
    name = "瞬灭水晶位置",
    desc = "失落的角鹰兽（坐骑）前置条件",
    get = function(info) return ns.db[info[#info]] end,
    set = function(info, v)
        ns.db[info[#info]] = v
        ns.HL:SendMessage("HandyNotes_NotifyUpdate", myname:gsub("HandyNotes_", ""))
    end,
    args = {
        icon = {
            type = "group",
            name = "图标设置",
            inline = true,
            args = {
                desc = {
                    name = "调整和设置图标的外观",
                    type = "description",
                    order = 0,
                },
                icon_scale = {
                    type = "range",
                    name = "图标的比例",
                    desc = "调整图标的大小",
                    min = 0.25, max = 2, step = 0.01,
                    order = 20,
                },
                icon_alpha = {
                    type = "range",
                    name = "图标透明度",
                    desc = "调整图标的透明度",
                    min = 0, max = 1, step = 0.01,
                    order = 30,
                },
            },
        },
        display = {
            type = "group",
            name = "显示设置",
            inline = true,
            args = {
                -- found = {
                --     type = "toggle",
                --     name = "Show found",
                --     desc = "Show waypoints for items you've already found?",
                --     order = 20,
                -- },
                unhide = {
                    type = "execute",
                    name = "重置隐藏图标",
                    desc = "重置隐藏图标，可通过右键来隐藏该图标",
                    func = function()
                        for map,coords in pairs(ns.hidden) do
                            wipe(coords)
                        end
                        ns.HL:Refresh()
                    end,
                    order = 50,
                },
            },
        },
    },
}

local player_faction = UnitFactionGroup("player")
ns.should_show_point = function(coord, point, currentZone, currentLevel)
    if point.level and point.level ~= currentLevel then
        return false
    end
    if ns.hidden[currentZone] and ns.hidden[currentZone][coord] then
        return false
    end
    if point.junk and not ns.db.show_junk then
        return false
    end
    if point.faction and point.faction ~= player_faction then
        return false
    end
    if (not ns.db.found) then
        if point.quest and IsQuestFlaggedCompleted(point.quest) then
            return false
        end
        if point.achievement then
            local id, name, points, completed, month, day, year, description, flags, icon, rewardText, isGuildAch, wasEarnedByMe, earnedBy = GetAchievementInfo(point.achievement)
            if completed then
                return false
            end
            if point.criteria then
                local description, type, completed, quantity, requiredQuantity, characterName, flags, assetID, quantityString, criteriaID = GetAchievementCriteriaInfoByID(point.achievement, point.criteria)
                if completed then
                    return false
                end
            end
        end
        if point.follower and C_Garrison.IsFollowerCollected(point.follower) then
            return false
        end
        -- This is actually super-targeted at Basten, who is repeatable daily and drops a toy
        -- Might want to generalize at some point...
        if point.toy and point.item and point.repeatable and select(4, C_ToyBox.GetToyInfo(point.item)) then
            return false
        end
    end
    if (not ns.db.repeatable) and point.repeatable then
        return false
    end
    if point.npc and not point.follower and not ns.db.show_npcs then
        return false
    end
    return true
end
