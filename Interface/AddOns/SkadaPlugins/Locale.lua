local addonName, vars = ...
local Ld, La = {}, {}
local locale = GAME_LOCALE or GetLocale()

vars.L = setmetatable({},{
    __index = function(t, s) return La[s] or Ld[s] or rawget(t,s) or s end
})

Ld["Explosive Orbs"] = "Fel Explosive"

Ld["labels.stin"] = "Damage Staggered"
Ld["labels.taken"] = "Taken"
Ld["labels.pb"] = "Purified_brew"
Ld["labels.pb_a"] = "Purified_brew (average)"
Ld["labels.qs"] = "Purified_quicksip"
Ld["labels.others"] = "others"
Ld["labels.duration"] = "Stagger Duration"
Ld["labels.freeze"] = "Freeze Duration"
Ld["labels.tickmax"] = "Tick (max)"
Ld["labels.purified"] = "Total Purified"
Ld["labels.stagger"] = "Stagger"
Ld["labels.staggerdetail"] = "Stagger Detail"

if locale == "zhCN" then do end
La["Explosive Orbs"] = "邪能炸药"
La["Number of player spells"] = "技能次数"

La["labels.stin"] = "醉拳吸收"
La["labels.taken"] = "醉拳承受"
La["labels.pb"] = "活血酒"
La["labels.pb_a"] = "活血酒(平均)"
La["labels.qs"] = "浅斟快饮"
La["labels.others"] = "其他"
La["labels.duration"] = "醉拳时间"
La["labels.freeze"] = "锁定时间"
La["labels.tickmax"] = "最高醉拳伤害"
La["labels.purified"] = "总计化解"
La["labels.stagger"] = "醉拳大师"
La["labels.staggerdetail"] = "醉拳细节"
end
