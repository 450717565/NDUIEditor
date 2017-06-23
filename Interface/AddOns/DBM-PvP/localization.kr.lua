if GetLocale() ~= "koKR" then return end
local L

----------------------------
--  General BG functions  --
----------------------------
L = DBM:GetModLocalization("Battlegrounds")

L:SetGeneralLocalization({
	name = "  "
})

L:SetTimerLocalization({
	TimerInvite = "%s"
})

L:SetOptionLocalization({
	ColorByClass		= "     ",
	ShowInviteTimer		= "    ",
	AutoSpirit			= "    ",
	HideBossEmoteFrame	= "    ,     "
})

L:SetMiscLocalization({
	BgStart60 	= "1   !",
	BgStart30 	= "30   !",
	ArenaInvite	= " "
})

--------------
--    --
--------------
L = DBM:GetModLocalization("Arenas")

L:SetGeneralLocalization({
	name = "  "
})

L:SetTimerLocalization({
	TimerShadow	= " "
})

L:SetOptionLocalization({
	TimerShadow 	= "   "
})

L:SetMiscLocalization({
	Start15 	= "   15 !",
	highmaulArena = "    30  !"
})

---------------
--  Alterac  --
---------------
L = DBM:GetModLocalization("z30")

L:SetTimerLocalization({
	TimerTower	= "%s",
	TimerGY 	= "%s"
})

L:SetOptionLocalization({
	TimerTower 	= "   ",
	TimerGY 	= "   ",
	AutoTurnIn 	= "    "
})

---------------
--  Arathi  --
---------------
L = DBM:GetModLocalization("z529")

L:SetTimerLocalization({
	TimerCap 				= "%s"
})

L:SetOptionLocalization({
	TimerWin 				= "    ",
	TimerCap 				= "   ",
	ShowAbEstimatedPoints 	= "   /    ",
	ShowAbBasesToWin 		= "       "
})

L:SetMiscLocalization({
	ScoreExpr 		= "(%d+)/1500",
	WinBarText 		= "%s ",
	BasesToWin		= "    : %d"
})

---------------------
--  Deepwind Gorge --
---------------------
L = DBM:GetModLocalization("z1105")

L:SetTimerLocalization({
	TimerCap        = "%s"
})

L:SetOptionLocalization({
	TimerCap        = "   ",
	TimerWin        = "    "
})

L:SetMiscLocalization({
	ScoreExpr       = "(%d+)/1500",
	WinBarText      = "%s "
})

-----------------------
--  Eye of the Storm --
-----------------------
L = DBM:GetModLocalization("z566")

L:SetTimerLocalization({
	TimerFlag		= " "
})

L:SetOptionLocalization({
	TimerWin 		= "    ",
	TimerFlag 		= "   ",
	ShowPointFrame 	= "   /       "
})

L:SetMiscLocalization({
	ScoreExpr 		= "(%d+)/1500",
	WinBarText		= "%s ",
	Flag 			= "",
	FlagReset 		= "   .",
	FlagTaken 		= "^(.+)|1;;  !",
	FlagCaptured 	= "(.+)|1;;  !",
	FlagDropped 	= " !"

})

--------------------
--  Warsong Gulch --
--------------------
L = DBM:GetModLocalization("z489")

L:SetTimerLocalization({
	TimerFlag 			= " "
})

L:SetOptionLocalization({
	TimerFlag 					= "   ",
	ShowFlagCarrier 	 	 	= "  ",
	ShowFlagCarrierErrorNote	= "          "
})

L:SetMiscLocalization({
	InfoErrorText 		= "       .         .",
	ExprFlagPickUp 		= "(.+)|1;; (.+)   !",
	ExprFlagCaptured 	= "(.+)|1;; (.+)   !",
	ExprFlagReturn 		= "(.+)|1;; (.+)  !",
	FlagAlliance 		= "  :",
	FlagHorde 			= "  :",
	FlagBase			= "",
	Vulnerable1			= "",
	Vulnerable2			= ""
})

------------------------
--  Isle of Conquest  --
------------------------

L = DBM:GetModLocalization("z628")

L:SetWarningLocalization({
	WarnSiegeEngine			= "   ",
	WarnSiegeEngineSoon		= "   10 "
})

L:SetTimerLocalization({
	TimerPOI				= "%s",
	TimerSiegeEngine		= "  "
})

L:SetOptionLocalization({
	TimerPOI				= "   ",
	TimerSiegeEngine		= "    ",
	WarnSiegeEngine			= "     ",
	WarnSiegeEngineSoon		= "      ",
	ShowGatesHealth			= "   (     )"
})

L:SetMiscLocalization({
	GatesHealthFrame		= "  ",
	SiegeEngine				= " ",
	GoblinStartAlliance		= "   ?         !",
	GoblinStartHorde		= "       .       !",
	GoblinHalfwayAlliance	= " !     .     !",
	GoblinHalfwayHorde		= " !      .    !",
	GoblinFinishedAlliance	= "   !       !",
	GoblinFinishedHorde		= "      !",
	GoblinBrokenAlliance	= " ?! .     .",
	GoblinBrokenHorde		= " ?!   ...        ."
})

------------------
--  Twin Peaks  --
------------------
L = DBM:GetModLocalization("z726")

L:SetTimerLocalization({
	TimerFlag	= " "
})

L:SetOptionLocalization({
	TimerFlag 					= "   ",
	ShowFlagCarrier 	 	 	= "  ",
	ShowFlagCarrierErrorNote	= "          "
})

L:SetMiscLocalization({
	InfoErrorText 		= "       .         .",
	ExprFlagPickUp		= "(.+)|1;; (.+)   !",
	ExprFlagCaptured	= "(.+)|1;; (.+)   !",
	ExprFlagReturn		= "(.+)|1;; (.+)  !",
	FlagAlliance		= " : ",
	FlagHorde			= " : ",
	FlagBase			= "",
	Vulnerable1			= "",
	Vulnerable2			= ""
})

------------------------------
--  The Battle for Gilneas  --
------------------------------
L = DBM:GetModLocalization("z761")

L:SetTimerLocalization({
	TimerCap 				= "%s"
})

L:SetOptionLocalization({
	TimerWin 					= "    ",
	TimerCap 					= "   ",
	ShowGilneasEstimatedPoints 	= "   /    ",
	ShowGilneasBasesToWin 		= "       "
})

L:SetMiscLocalization({
	ScoreExpr 		= "(%d+)/1500",
	WinBarText 		= "%s ",
	BasesToWin		= "    : %d"
})

-------------------------
--  Silvershard Mines  --
-------------------------
L = DBM:GetModLocalization("z727")

L:SetTimerLocalization({
	TimerCart	= " "
})

L:SetOptionLocalization({
	TimerCart	= "   "
})

L:SetMiscLocalization({
	Capture = " !"
})

-------------------------
--  Temple of Kotmogu  --
-------------------------
L = DBM:GetModLocalization("z998")

L:SetMiscLocalization({
	OrbTaken 	= "(.+)|1;; (.+)  !",
	OrbReturn 	= "(.+)  !",
	ScoreExpr	= "(%d+)/1500",
	WinBarText	= "%s ",
	OrbsToWin	= "    : %d"
})


L:SetOptionLocalization({
	TimerWin					= "    ",
	ShowKotmoguEstimatedPoints	= "   /    ",
	ShowKotmoguOrbsToWin		= "       "
})
