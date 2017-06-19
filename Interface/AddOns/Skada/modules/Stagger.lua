Skada:AddLoadableModule("Damage", nil, function(Skada, L)

	local mod = Skada:NewModule("醉拳大师")
	local modDetails = Skada:NewModule("醉拳细节")

	local function printdebug(...)
		--print(...)
	end

	local function getSetDuration(set)
		if set.time > 0 then
			return set.time
		else
			local endtime = set.endtime
			if not endtime then
				endtime = time()
			end
			return endtime - set.starttime
		end
	end

	local function nextDataset(win, context)
		context.index = context.index or 1

		local dataset = win.dataset[context.index] or {}
		dataset.id = context.index
		win.dataset[context.index] = dataset

		context.index = context.index + 1
		return dataset
	end

	local function getPurifyPercent(unitGUID)
		local talentGroup = GetActiveSpecGroup()
		_, _, _, elusiveDanceSelected, _ = GetTalentInfo(7, 1, talentGroup, true, unitGUID)

		local purifyPercent = 0.5
		if elusiveDanceSelected then
				purifyPercent = purifyPercent + 0.15
		end
		--printdebug("Purify percent for "..unitGUID..": "..purifyPercent)
		return purifyPercent
	end

	local tick = {}
	local function logStaggerTick(set, tick, isCurrent)
		local player = Skada:get_player(set, tick.dstGUID, tick.dstName)
		if player then
			player.stagger.taken = player.stagger.taken + tick.samount
			player.stagger.tickCount = player.stagger.tickCount + 1
			if player.stagger.tickMax < tick.samount then
				player.stagger.tickMax = tick.samount
			end
			if isCurrent then
				if player.stagger.lastTickTime then
					local timeSinceLastTick = tick.timestamp - player.stagger.lastTickTime
					player.stagger.duration = player.stagger.duration + timeSinceLastTick
					if timeSinceLastTick > 60 then
						--printdebug(tick.dstName.."'s time since last tick: "..timeSinceLastTick.." (ignored)")
					elseif timeSinceLastTick > 2 then
						--printdebug(tick.dstName.."'s time since last tick: "..timeSinceLastTick)
						player.stagger.freezeDuration = player.stagger.freezeDuration + (timeSinceLastTick - 0.5)
					end
				end
				if tick.remainingStagger > 0 then
					player.stagger.lastTickTime = tick.timestamp
					--printdebug(tick.dstName.."'s stagger tick for "..tick.samount.." ("..tick.remainingStagger.." remains)")
				else
					player.stagger.lastTickTime = nil
					--printdebug(tick.dstName.."'s stagger ended")
				end
			end
		end
	end

	local purify = {}
	local function logStaggerPurify(set, purify)
		local player = Skada:get_player(set, purify.srcGUID, purify.srcName)
		if player then
			player.stagger.purified = player.stagger.purified + purify.samount
			player.stagger.purifyCount = player.stagger.purifyCount + 1
			if player.stagger.purifyMax < purify.samount then
				player.stagger.purifyMax = purify.samount
			end
		end
	end

	local function SpellDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
		local spellId, spellName, spellSchool, samount, soverkill, sschool, sresisted, sblocked, sabsorbed, scritical, sglancing, scrushing = ...
		if spellId == 124255 then -- Stagger damage
			tick.timestamp = timestamp
			tick.dstGUID = dstGUID
			tick.dstName = dstName
			tick.samount = samount
			tick.remainingStagger = UnitStagger(dstName)
			logStaggerTick(Skada.current, tick, true)
			logStaggerTick(Skada.total, tick, false)
		end
	end

	local function SpellCast(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
		local spellId, spellName, spellSchool = ...
		if spellId == 119582 then -- Purifying brew
			local purifiedAmount = UnitStagger(srcName) * getPurifyPercent(srcGUID)
			--printdebug(srcName.." purified "..purifiedAmount.." stagger")

			purify.srcGUID = srcGUID
			purify.srcName = srcName
			purify.samount = purifiedAmount
			logStaggerPurify(Skada.current, purify)
			logStaggerPurify(Skada.total, purify)
		end
	end

	function mod:OnEnable()
		mod.metadata = {showspots = false, click1 = modDetails, icon = "Interface\\Icons\\monk_stance_drunkenox"}
		modDetails.metadata = {showspots = false, ordersort = true}

		Skada:RegisterForCL(SpellDamage, 'SPELL_PERIODIC_DAMAGE', {src_is_interesting = true, dst_is_interesting_nopets = false})
		Skada:RegisterForCL(SpellCast, 'SPELL_CAST_SUCCESS', {src_is_interesting = true, dst_is_interesting_nopets = false})

		Skada:AddMode(self, "醉拳")
	end

	function mod:OnDisable()
		Skada:RemoveMode(self)
	end

	function modDetails:Enter(win, id, label)
		modDetails.playerid = id
		modDetails.title = label.."的醉拳"
	end

	function modDetails:Update(win, set)
		local player = Skada:find_player(set, self.playerid)
		if player then
			local playerStagger = player.stagger

			local damageStaggered = playerStagger.taken + playerStagger.purified
			if damageStaggered == 0 then
				return
			end
			local setDuration = getSetDuration(set)

			local datasetContext = {}

			local staggered = nextDataset(win, datasetContext)
			staggered.label = "总计伤害"
			staggered.valuetext = Skada:FormatNumber(damageStaggered)
			staggered.value = 1

			local staggerTaken = nextDataset(win, datasetContext)
			staggerTaken.label = "当前伤害"
			staggerTaken.valuetext = Skada:FormatNumber(playerStagger.taken)..(" (%02.1f%%)"):format(playerStagger.taken / damageStaggered * 100)
			staggerTaken.value = playerStagger.taken / damageStaggered

			if playerStagger.purifyCount > 0 then
				local staggerPurified = nextDataset(win, datasetContext)
				staggerPurified.label = "总计化解"
				staggerPurified.valuetext = Skada:FormatNumber(playerStagger.purified)..(" (%02.1f%%)"):format(playerStagger.purified / damageStaggered * 100)
				staggerPurified.value = playerStagger.purified / damageStaggered

				local staggerPurifiedAvg = nextDataset(win, datasetContext)
				staggerPurifiedAvg.label = "平均化解"
				staggerPurifiedAvg.valuetext = Skada:FormatNumber(playerStagger.purified / playerStagger.purifyCount).." ("..playerStagger.purifyCount.."x)"
				staggerPurifiedAvg.value = (playerStagger.purified / playerStagger.purifyCount) / damageStaggered
			end

			if setDuration > 0 and playerStagger.duration > 0 then
				local staggerDuration = nextDataset(win, datasetContext)
				staggerDuration.label = "醉拳持续"
				staggerDuration.valuetext = ("%d秒"):format(playerStagger.duration)
				staggerDuration.value = playerStagger.duration / setDuration

				if playerStagger.freezeDuration > 2 then
					local freezeDuration = nextDataset(win, datasetContext)
					freezeDuration.label = "高危时间"
					freezeDuration.valuetext = ("%d秒"):format(playerStagger.freezeDuration)..(" (%02.1f%%)"):format(playerStagger.freezeDuration / playerStagger.duration * 100)
					freezeDuration.value = playerStagger.freezeDuration / setDuration
				end
			end

			local tickMax = nextDataset(win, datasetContext)
			tickMax.label = "单次伤害（最大）"
			tickMax.valuetext = Skada:FormatNumber(playerStagger.tickMax)
			tickMax.value = playerStagger.tickMax / damageStaggered

			win.metadata.maxvalue = 1
		end
	end

	function mod:AddPlayerAttributes(player, set)
		if not player.stagger then
			player.stagger =
			{
				taken = 0,
				purified = 0,
				purifyCount = 0,
				purifyMax = 0,

				lastTickTime = nil,
				tickMax = 0,
				tickCount = 0,

				duration = 0,
				freezeDuration = 0,
			}
		end
	end

	function mod:GetSetSummary(set)
		local totalPurified = 0
		for i, player in ipairs(set.players) do
			if player.stagger then
				totalPurified = totalPurified + player.stagger.purified
			end
		end
		return "总计化解 ("..Skada:FormatNumber(totalPurified)..")"
	end

	function mod:Update(win, set)
		local nr = 1
		local max = 0

		for i, player in ipairs(set.players) do
			if player.stagger then

				local value = player.stagger.taken + player.stagger.purified
				if value > 0 then
					local d = win.dataset[nr] or {}
					win.dataset[nr] = d

					d.id = player.id
					d.label = player.name
					d.value = value
					d.valuetext = Skada:FormatNumber(value)
					d.class = player.class
					d.role = player.role

					if max < value then
						max = value
					end
				end

				nr = nr + 1
			end
		end
		win.metadata.maxvalue = max
	end
end)