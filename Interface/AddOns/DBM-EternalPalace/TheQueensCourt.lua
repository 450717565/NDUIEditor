local mod	= DBM:NewMod(2359, "DBM-EternalPalace", nil, 1179)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("2019051661717")
mod:SetCreatureID(152852, 152853)--Pashmar 152852, Silivaz 152853
mod:SetEncounterID(2311)
mod:SetZone()
mod:SetBossHPInfoToHighest()
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)
--mod:SetHotfixNoticeRev(16950)
--mod:SetMinSyncRevision(16950)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 300088 301807 297325 301947",
	"SPELL_CAST_SUCCESS 298050 297960 299914 296850",
	"SPELL_SUMMON 297832",
	"SPELL_AURA_APPLIED 296704 298050 301244 297656 297564 297585 301828 299914 296851",
	"SPELL_AURA_APPLIED_DOSE 301828",
	"SPELL_AURA_REMOVED 296704 298050 301244 297656 297564 299914 296851",
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, verify value of general unfiltered target announces for azshara's bullshit
--TODO, maybe add delay and list all form ranks players in each players individual form ranks warning.
--TODO, infoframe that shows repeat performance and form ranks targets and Deferred Sentence+amount on affected players
--TODO, better detection of when player is standing still too long with sentence, and re-show keep move warning if they aren't moving enough
--TODO, right decrees event
--TODO, Frenetic Charge soak priority
--TODO, track https://ptr.wowhead.com/spell=297836/potent-spark on infoframe, like cabal
--local warnPoweringDown					= mod:NewSpellAnnounce(271965, 2, nil, nil, nil, nil, nil, 2)
--General
local warnDesperateMeasures					= mod:NewCastAnnounce(300088, 4)
--Queen Azshara
local warnFormRanks							= mod:NewTargetNoFilterAnnounce(298050, 3)--Importnat to everyone to clear them a path
local warnRepeatPerformance					= mod:NewTargetNoFilterAnnounce(301244, 3, nil, "Tank|Healer")--Important to tanks healers, if one of targets is tank or healer
local warnRepeatPerformanceOver				= mod:NewFadesAnnounce(301244, 1)--Personal fades warning
local warnStandAlone						= mod:NewTargetAnnounce(297656, 2)
local warnStandAloneOver					= mod:NewFadesAnnounce(297656, 1)--Personal fades warning
local warnDeferredSentence					= mod:NewTargetAnnounce(297564, 2)
local warnDeferredSentenceOver				= mod:NewFadesAnnounce(297564, 1)--Personal fades warning
--Silivaz the Zealous
local warnSilivazTouch						= mod:NewStackAnnounce(244899, 2, nil, "Tank")
--Pashmar the Fanatical
local warnPashmarsTouch						= mod:NewStackAnnounce(245518, 2, nil, "Tank")
local warnPotentSpark						= mod:NewSpellAnnounce(301947, 3)
local warnFanaticalVerdict					= mod:NewTargetAnnounce(296851, 2)

--Queen Azshara
local specWarnFormRanks						= mod:NewSpecialWarningMoveTo(298050, nil, nil, nil, 1, 2)
local yellFormRanks							= mod:NewYell(298050)
local yellFormRanksFades					= mod:NewShortFadesYell(298050)
local specWarnRepeatPerformance				= mod:NewSpecialWarningYou(301244, nil, nil, nil, 1, 2)
local specWarnStandAlone					= mod:NewSpecialWarningMoveAway(297656, nil, nil, nil, 1, 2)
local yellStandAlone						= mod:NewYell(297656)
local specWarnDeferredSentence				= mod:NewSpecialWarningKeepMove(297564, nil, nil, nil, 1, 2)
local specWarnObeyorSuffer					= mod:NewSpecialWarningDefensive(297585, nil, nil, nil, 1, 2)
local specWarnObeyorSufferTaunt				= mod:NewSpecialWarningTaunt(297585, false, nil, nil, 1, 2)
--Silivaz the Zealous
local specWarnSilivazTouch					= mod:NewSpecialWarningStack(301828, nil, 7, nil, nil, 1, 6)
local specWarnSilivazTouchOther				= mod:NewSpecialWarningTaunt(301828, nil, nil, nil, 1, 2)
local specWarnFreneticCharge				= mod:NewSpecialWarningMoveTo(299914, nil, nil, nil, 1, 2)
local yellFreneticCharge					= mod:NewYell(299914, nil, nil, nil, "YELL")
local yellFreneticChargeFades				= mod:NewShortFadesYell(299914, nil, nil, nil, "YELL")
local specWarnZealousEruption				= mod:NewSpecialWarningMoveTo(301807, nil, nil, nil, 3, 2)
--Pashmar the Fanatical
local specWarnPashmarsTouch					= mod:NewSpecialWarningStack(301830, nil, 7, nil, nil, 1, 6)
local specWarnPashmarsTouchOther			= mod:NewSpecialWarningTaunt(301830, nil, nil, nil, 1, 2)
local specWarnFanaticalVerdict				= mod:NewSpecialWarningMoveAway(296851, nil, nil, nil, 1, 2)
local yellFanaticalVerdict					= mod:NewYell(296851)
local yellFanaticalVerdictFades				= mod:NewShortFadesYell(296851)
local specWarnViolentOutburst				= mod:NewSpecialWarningRun(297325, nil, nil, nil, 4, 2)
--local specWarnGTFO						= mod:NewSpecialWarningGTFO(270290, nil, nil, nil, 1, 8)

--General
local timerDesperateMeasures			= mod:NewCastTimer(10, 271225, nil, nil, nil, 5)
--Queen Azshara
mod:AddTimerLine(DBM:EJ_GetSectionInfo(20258))
local timerSummonDecreesCD				= mod:NewAITimer(30.4, 297960, nil, nil, nil, 3)--30.4-42
--Silivaz the Zealous
mod:AddTimerLine(DBM:EJ_GetSectionInfo(20231))
local timerFreneticChargeCD				= mod:NewAITimer(58.2, 299914, nil, nil, nil, 3)
local timerZealousEruptionCD			= mod:NewAITimer(58.2, 301807, nil, nil, nil, 2)
--Pashmar the Fanatical
mod:AddTimerLine(DBM:EJ_GetSectionInfo(20235))
local timerFanaticalVerdictCD			= mod:NewAITimer(58.2, 296850, nil, nil, nil, 3)
local timerViolentOutburstCD			= mod:NewAITimer(58.2, 297325, nil, nil, nil, 2)
local timerPotentSparkCD				= mod:NewAITimer(58.2, 301947, nil, nil, nil, 1)

--local berserkTimer					= mod:NewBerserkTimer(600)

--local countdownCudgelofGore				= mod:NewCountdown(58, 271296)
--local countdownEnlargedHeart			= mod:NewCountdown("Alt60", 275205, true, 2)

mod:AddNamePlateOption("NPAuraOnSoP", 296704)
--mod:AddRangeFrameOption(6, 264382)
--mod:AddInfoFrameOption(275270, true)
mod:AddSetIconOption("SetIconFormRanks", 298050, true, false, {1, 2, 3})
mod:AddSetIconOption("SetIconFreneticCharge", 299914, true, false, {4})
mod:AddSetIconOption("SetIconSparks", 301947, true, true, {5, 6, 7, 8})

mod.vb.formRanksIcon = 1
mod.vb.sparkIcon = 5

function mod:OnCombatStart(delay)
	self.vb.formRanksIcon = 1
	self.vb.sparkIcon = 5
	--ass-shara
	timerSummonDecreesCD:Start(1-delay)
	--Silivaz
	timerFreneticChargeCD:Start(1-delay)
	timerZealousEruptionCD:Start(1-delay)
	--Pashmar
	timerFanaticalVerdictCD:Start(1-delay)
	timerViolentOutburstCD:Start(1-delay)
	timerPotentSparkCD:Start(1-delay)
	if self.Options.NPAuraOnSoP then
		DBM:FireEvent("BossMod_EnableHostileNameplates")
	end
end

function mod:OnCombatEnd()
--	if self.Options.InfoFrame then
--		DBM.InfoFrame:Hide()
--	end
--	if self.Options.RangeFrame then
--		DBM.RangeCheck:Hide()
--	end
	if self.Options.NPAuraOnSoP then
		DBM.Nameplate:Hide(true, nil, nil, nil, true, true)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 300088 then
		if self:AntiSpam(1.5, 1) then
			warnDesperateMeasures:Show()
		end
		timerDesperateMeasures:Start(10, args.sourceGUID)
	elseif spellId == 301807 then
		specWarnZealousEruption:Show(BOSS)
		specWarnZealousEruption:Play("runin")
		timerZealousEruptionCD:Start()
	elseif spellId == 297325 then
		specWarnViolentOutburst:Show()
		specWarnViolentOutburst:Play("justrun")
		timerViolentOutburstCD:Start()
	elseif spellId == 301947 then
		self.vb.sparkIcon = 5
		warnPotentSpark:Show()
		timerPotentSparkCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 298050 then
		self.vb.formRanksIcon = 1
	elseif spellId == 297960 and self:AntiSpam(5, 2) then
		timerSummonDecreesCD:Start()
	elseif spellId == 299914 then
		timerFreneticChargeCD:Start()
	elseif spellId == 296850 then
		timerFanaticalVerdictCD:Start()
	end
end

function mod:SPELL_SUMMON(args)
	local spellId = args.spellId
	if spellId == 297832 then
		if self.Options.SetIconSparks then
			self:ScanForMobs(args.destGUID, 2, self.vb.sparkIcon, 1, 0.2, 12)
		end
		self.vb.sparkIcon = self.vb.sparkIcon + 1
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 296704 then
		if self.Options.NPAuraOnSoP then
			DBM.Nameplate:Show(true, args.destGUID, spellId)
		end
	elseif spellId == 298050 then
		warnFormRanks:CombinedShow(0.3, args.destName)
		local icon = self.vb.formRanksIcon
		if args:IsPlayer() then
			specWarnFormRanks:Show(args.spellName)
			specWarnFormRanks:Play("gathershare")
			yellFormRanks:Yell()
			yellFormRanksFades:Countdown(15)
		end
		if self.Options.SetIconFormRanks then
			self:SetIcon(args.destName, icon)
		end
		self.vb.formRanksIcon = self.vb.formRanksIcon + 1
	elseif spellId == 301244 then
		warnRepeatPerformance:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnRepeatPerformance:Show()
			specWarnRepeatPerformance:Play("targetyou")
		end
	elseif spellId == 297656 then
		warnStandAlone:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnStandAlone:Show()
			specWarnStandAlone:Play("runout")
			yellStandAlone:Yell()
		end
	elseif spellId == 297564 then
		warnDeferredSentence:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnDeferredSentence:Show()
			specWarnDeferredSentence:Play("keepmove")
		end
	elseif spellId == 297585 then
		if args:IsPlayer() then
			specWarnObeyorSuffer:Show()
			specWarnObeyorSuffer:Play("defensive")
		else
			local uId = DBM:GetRaidUnitId(args.destName)
			if self:IsTanking(uId) then
				specWarnObeyorSufferTaunt:Show(args.destName)
				specWarnObeyorSufferTaunt:Play("tauntboss")
			end
		end
	elseif spellId == 301828 then
		local uId = DBM:GetRaidUnitId(args.destName)
		if self:IsTanking(uId) then
			local amount = args.amount or 1
			--local tauntStack = 3
			--if self:IsMythic() and self.Options.TauntBehavior == "TwoMythicThreeNon" or self.Options.TauntBehavior == "TwoAlways" then
			--	tauntStack = 2
			--end
			if amount >= 7 then--Lasts 20 seconds, unknown reapplication rate, fine tune!
				if args:IsPlayer() then--At this point the other tank SHOULD be clear.
					specWarnSilivazTouch:Show(amount)
					specWarnSilivazTouch:Play("stackhigh")
				else--Taunt as soon as stacks are clear, regardless of stack count.
					local _, _, _, _, _, expireTime = DBM:UnitDebuff("player", spellId)
					local remaining
					if expireTime then
						remaining = expireTime-GetTime()
					end
					--if not UnitIsDeadOrGhost("player") and (not remaining or remaining and remaining < 9.6) then
					if not UnitIsDeadOrGhost("player") and not remaining  then
						specWarnSilivazTouchOther:Show(args.destName)
						specWarnSilivazTouchOther:Play("tauntboss")
					else
						warnSilivazTouch:Show(args.destName, amount)
					end
				end
			else
				warnSilivazTouch:Show(args.destName, amount)
			end
		end
	elseif spellId == 301830 then
		local uId = DBM:GetRaidUnitId(args.destName)
		if self:IsTanking(uId) then
			local amount = args.amount or 1
			--local tauntStack = 3
			--if self:IsMythic() and self.Options.TauntBehavior == "TwoMythicThreeNon" or self.Options.TauntBehavior == "TwoAlways" then
			--	tauntStack = 2
			--end
			if amount >= 7 then--Lasts 20 seconds, unknown reapplication rate, fine tune!
				if args:IsPlayer() then--At this point the other tank SHOULD be clear.
					specWarnPashmarsTouch:Show(amount)
					specWarnPashmarsTouch:Play("stackhigh")
				else--Taunt as soon as stacks are clear, regardless of stack count.
					local _, _, _, _, _, expireTime = DBM:UnitDebuff("player", spellId)
					local remaining
					if expireTime then
						remaining = expireTime-GetTime()
					end
					--if not UnitIsDeadOrGhost("player") and (not remaining or remaining and remaining < 9.6) then
					if not UnitIsDeadOrGhost("player") and not remaining  then
						specWarnPashmarsTouchOther:Show(args.destName)
						specWarnPashmarsTouchOther:Play("tauntboss")
					else
						warnPashmarsTouch:Show(args.destName, amount)
					end
				end
			else
				warnPashmarsTouch:Show(args.destName, amount)
			end
		end
	elseif spellId == 299914 then
		if args:IsPlayer() then
			specWarnFreneticCharge:Show(GROUP)
			specWarnFreneticCharge:Play("gathershare")
			yellFreneticCharge:Yell()
			yellFreneticChargeFades:Countdown(4)
		elseif not DBM:UnitDebuff("player", 297656, 298050, 297585, 297564) and not self:IsTank() then--Not tank, or affected by decrees that'd conflict with soaking
			specWarnFreneticCharge:Show(GROUP)
			specWarnFreneticCharge:Play("gathershare")
		end
		if self.Options.SetIconFreneticCharge then
			self:SetIcon(args.destName, 4)
		end
	elseif spellId == 296851 then
		if args:IsPlayer() then--If you have form ranks, do NOT run out
			--if not DBM:UnitDebuff("player", 298050) then
				specWarnFanaticalVerdict:Show()
				specWarnFanaticalVerdict:Play("runout")
			--end
			yellFanaticalVerdict:Yell()
			yellFanaticalVerdictFades:Countdown(8)
		else
			warnFanaticalVerdict:Show(args.destName)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 296704 then
		if self.Options.NPAuraOnSoP then
			DBM.Nameplate:Hide(true, args.destGUID, spellId)
		end
	elseif spellId == 298050 then
		if args:IsPlayer() then
			yellFormRanksFades:Cancel()
		end
		if self.Options.SetIconFormRanks then
			self:SetIcon(args.destName, 0)
		end
	elseif spellId == 301244 then
		if args:IsPlayer() then
			warnRepeatPerformanceOver:Show()
		end
	elseif spellId == 297656 then
		if args:IsPlayer() then
			warnStandAloneOver:Show()
		end
	elseif spellId == 297564 then
		if args:IsPlayer() then
			warnDeferredSentenceOver:Show()
		end
	elseif spellId == 299914 then
		if args:IsPlayer() then
			yellFreneticChargeFades:Cancel()
		end
		if self.Options.SetIconFreneticCharge then
			self:SetIcon(args.destName, 0)
		end
	elseif spellId == 296851 then
		if args:IsPlayer() then--If you have form ranks, do NOT run out
			yellFanaticalVerdictFades:Cancel()
		end
	end
end

--[[
function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 270290 and destGUID == UnitGUID("player") and self:AntiSpam(2, 5) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 153335 then--Potent Spark

	end
end
--]]

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if (spellId == 297960 or spellId == 298401) and self:AntiSpam(5, 2) then--Summon Decrees/Warn Players of Enact Decrees
		timerSummonDecreesCD:Start()
	end
end
