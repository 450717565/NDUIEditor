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
            name = "ͼ������",
            inline = true,
            args = {
                desc = {
                    name = "����������ͼ������",
                    type = "description",
                    order = 0,
                },
                icon_scale = {
                    type = "range",
                    name = "ͼ��ı���",
                    desc = "����ͼ��Ĵ�С",
                    min = 0.25, max = 2, step = 0.01,
                    order = 20,
                },
                icon_alpha = {
                    type = "range",
                    name = "ͼ��͸����",
                    desc = "����ͼ���͸����",
                    min = 0, max = 1, step = 0.01,
                    order = 30,
                },
            },
        },
        display = {
            type = "group",
            name = "��ʾ����",
            inline = true,
            args = {
                icon_item = {
                    type = "toggle",
                    name = "��ʾ��Ʒͼ��",
                    desc = "��֪��Ʒ��ʾ��Ʒͼ�꣬δ֪��Ʒ��ʾͨ��ͼ��",
                    order = 0,
                },
                tooltip_item = {
                    type = "toggle",
                    name = "��ʾ��Ʒ��ʾ",
                    desc = "��ʾ��������Ʒ��ʾ��Ϣ",
                    order = 10,
                },
                found = {
                    type = "toggle",
                    name = "��ʾ���ҵ���",
                    desc = "������ʾ�Ѿ��ҵ�����Ʒͼ��",
                    order = 20,
                },
                show_npcs = {
                    type = "toggle",
                    name = "��ʾ�ѻ�ɱ��",
                    desc = "������ʾ�Ѿ���ɱ��ϡ�о�Ӣ",
                    order = 30,
                },
                repeatable = {
                    type = "toggle",
                    name = "��ʾ���ظ���",
                    desc = "��ʾ��Ʒ��Щ�ǿ��ظ��ģ�һ���Ϊ�ճ�����",
                    order = 40,
                },
                tooltip_questid = {
                    type = "toggle",
                    name = "��ʾ������",
                    desc = "��ʾ������������ID",
                    order = 40,
                },
                unhide = {
                    type = "execute",
                    name = "��������ͼ��",
                    desc = "��������ͼ�꣬��ͨ���Ҽ������ظ�ͼ��",
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
