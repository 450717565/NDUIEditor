local myname, ns = ...

ns.points = {
    --[[ structure:
    [mapFile] = { -- "_terrain1" etc will be stripped from attempts to fetch this
        [coord] = {
            label=[string], -- label: text that'll be the label, optional
            item=[id], -- itemid
            quest=[id], -- will be checked, for whether character already has it
            achievement=[id], -- will be shown in the tooltip
            junk=[bool], -- doesn't count for achievement
            npc=[id], -- related npc id, used to display names in tooltip
            note=[string], -- some text which might be helpful
        },
    },
    --]]
    ["Azsuna"] = {
        -- Many things from NaThuRe's comment on wowhead
        -- http://www.wowhead.com/item=138258/reins-of-the-long-forgotten-hippogryph#comments:id=2400520
        [29903600] = {},
        [29903600] = {},
        [34803530] = { label="Nor'danil wellspring south crystal", },
        [34851714] = {},
        [35002200] = {},
        [36003600] = {},
        [37403220] = { label="Nor'danil wellspring north crystal", },
        [38760929] = {},
        [40303280] = {},
        [40553629] = {},
        [42200850] = { label="Lost Orchard crystal", },
        [43001800] = {},
        [44105980] = {},
        [45501720] = {},
        [45504540] = {},
        [45700920] = {},
        [46954893] = {},
        [47003300] = { label="Azurewing repose south crystal", },
        [47106170] = { label="Oceanus cove crystal", },
        [48704850] = {},
        [49933295] = {},
        [50002090] = { label="Azurewing repose cave crystal ", },
        [50400780] = {},
        [50485699] = {},
        [50734989] = {},
        [51006100] = {},
        [51403760] = {},
        [52007100] = {},
        [52252553] = {},
        [52411344] = {},
        [53082803] = { label="Liothien crystal", },
        [54503350] = { label="Nar'thalas academy crystal", },
        [56004000] = {},
        [57502660] = {},
        [57904260] = {},
        [58814502] = {},
        [59003800] = { label="Hatecoil warcamp crystal", },
        [60004900] = {},
        [60105320] = { label="The Ruined sanctum west crystal", },
        [61003000] = { label="In a cave crystal", },
        [61103890] = {},
        [62005400] = {},
        [62535236] = {},
        [62734070] = {},
        [64803790] = {},
        [65402950] = {},
        [65494247] = {},
        [67003370] = { label="Felblaze Ingress east crystal", },
        [67004600] = {},
        [67005200] = {},
        [68192403] = {},
    },
}
