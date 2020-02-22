local Loc = LibStub("AceLocale-3.0"):NewLocale("Details_Vanguard", "zhCN") 

if (not Loc) then
	return 
end 

Loc ["STRING_PLUGIN_NAME"] = "坦克助手"
Loc ["STRING_HEALVSDAMAGETOOLTIP"] = "预治疗是预计接下来几秒的治疗量。\n预伤害是由“坦克助手”使用\n最后几秒的平均伤害计算的。\n\n|cff33CC00*点击查看更多信息."
Loc ["STRING_AVOIDVSHITSTOOLTIP"] = "这是在过去几秒内收到的\n成功躲闪和招架数量。\n\n|cff33CC00*点击查看更多信息."
Loc ["STRING_DAMAGESCROLL"] = "收到的最新伤害量."
Loc ["STRING_REPORT"] = "Details Vanguard报告"
Loc ["STRING_REPORT_AVOIDANCE"] = "规避统计"
Loc ["STRING_REPORT_AVOIDANCE_TOOLTIP"] = "发送规避报告"

Loc ["STRING_HEALRECEIVED"] = "收到治疗"
Loc ["STRING_HPS"] = "RHPS"
Loc ["STRING_HITS"] = "击中"
Loc ["STRING_DODGE"] = "躲闪"
Loc ["STRING_PARRY"] = "招架"
Loc ["STRING_DAMAGETAKEN"] = "承受伤害"
Loc ["STRING_DTPS"] = "DTPS"
Loc ["STRING_DEBUFF"] = "Debuff"
Loc ["STRING_DURATION"] = "持续时间"
