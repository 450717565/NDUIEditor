local myname, ns = ...

ns.defaults = {
    profile = {
        show_junk = false,
        show_npcs = false,
        found = false,
        repeatable = false,
        icon_scale = 1.25,
        icon_alpha = 1.0,
        icon_item = false,
        tooltip_item = true,
        tooltip_questid = true,
    },
    char = {
        hidden = {
            ['*'] = {},
        },
    },
}

ns.options = {
    type = "group",
    name = myname:gsub("HandyNotes_", ""),
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
                icon_item = {
                    type = "toggle",
                    name = "显示物品图标",
                    desc = "已知物品显示物品图标，未知物品显示通用图标",
                    order = 0,
                },
                tooltip_item = {
                    type = "toggle",
                    name = "显示物品提示",
                    desc = "显示完整的物品提示信息",
                    order = 10,
                },
                found = {
                    type = "toggle",
                    name = "显示已找到的",
                    desc = "继续显示已经找到的物品图标",
                    order = 20,
                },
                show_npcs = {
                    type = "toggle",
                    name = "显示已击杀的",
                    desc = "继续显示已经击杀的稀有精英",
                    order = 30,
                },
                repeatable = {
                    type = "toggle",
                    name = "显示可重复的",
                    desc = "显示物品哪些是可重复的，一般多为日常任务",
                    order = 40,
                },
                tooltip_questid = {
                    type = "toggle",
                    name = "显示任务编号",
                    desc = "显示相关任务的任务ID",
                    order = 40,
                },
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
        if point.quest then
            if type(point.quest) == 'table' then
                -- if it's a table, only count as complete if all quests are complete
                local complete = true
                for _, quest in ipairs(point.quest) do
                    if not IsQuestFlaggedCompleted(quest) then
                        complete = false
                        break
                    end
                end
                if complete then
                    return false
                end
            elseif IsQuestFlaggedCompleted(point.quest) then
                return false
            end
        end
        if point.follower and C_Garrison.IsFollowerCollected(point.follower) then
            return false
        end
        if point.toy and point.item and PlayerHasToy(point.item) then
            return false
        end
    end
    if (not ns.db.repeatable) and point.repeatable then
        return false
    end
    if point.npc and not point.follower and not ns.db.show_npcs then
        return false
    end
    if point.hide_before and not ns.db.upcoming and not IsQuestFlaggedCompleted(point.hide_before) then
        return false
    end
    return true
end
