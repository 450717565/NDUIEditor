local addonName, vars = ...
local L = vars.L
local Skada = Skada
local mod = Skada:NewModule(L["labels.stagger"])
local modDetails = Skada:NewModule(L["labels.staggerdetail"])

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

local function calcrate(stvar,realst)
	local pbratelist = {0.40,0.41,0.42,0.43,0.44,0.45,0.46,0.47,0.60,0.61,0.62,0.63,0.64,0.65,0.66,0.67}
	local qsratelist = {0,0.05}
	local useisb = 0
	local usepb = 0
	local prate = -1
	local qsrate = -1
	local pamounts = {}
	local qsamounts = {}
	local pamounts_tmp = {}
	local qsamounts_tmp = {}
	local pamount = 0
	local qsamount = 0
	local found = 0
	for pflag,pr in ipairs(pbratelist) do
		if found >= 1 then
			break
		end
		for iflag,ir in ipairs(qsratelist) do
			testst = stvar.stpool
			pamounts = {}
			qsamounts = {}
			for sflag,spell in ipairs(stvar.spellhistory) do
				spellname = spell[1]
				if spellname == 'pb' then
					pamount = testst*pr
					table.insert(pamounts,pamount)
					testst = testst - pamount
					usepb = 1
				elseif spellname == 'isb' then
					qsamount= testst*ir
					table.insert(qsamounts,qsamount)
					testst = testst - qsamount
					useisb = 1
				elseif spellname == 'stin' then
					testst = testst + spell[2]
				elseif spellname == 'stout' then
					testst = testst - spell[2]
				end
			end
			if testst-realst< 2 and testst-realst>-2 then
				found = found + 1
				qsrate = ir
				prate = pr
				break
			end
		end
	end
	if found == 0 then
		usepb=0
		useisb=0
		pamounts={}
		qsamounts={}
	end
	if found ~= 0 then
		if usepb ~= 0 then
			stvar.pbrate = prate
		end
		if useisb ~= 0 then
			stvar.qsrate = qsrate
		end
	end
	return usepb,useisb,pamounts,qsamounts,found
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
				if timeSinceLastTick > 2 then
					player.stagger.freezeDuration = player.stagger.freezeDuration + (timeSinceLastTick - 0.5)
				end
			end
			if tick.remainingStagger > 0 then
				player.stagger.lastTickTime = tick.timestamp
			else
				player.stagger.lastTickTime = nil
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

local function logStaggerQuicksip(set, purify)
	local player = Skada:get_player(set, purify.srcGUID, purify.srcName)
	if player then
		player.stagger.purified_quicksip = player.stagger.purified_quicksip + purify.samount
	end
end

local function logspelllist(stvar,srcGUID,srcName)
	testst = stvar.stpool
	pamount = 0
	qsamount = 0
	pr = stvar.pbrate
	ir = stvar.qsrate
	for sflag,spell in ipairs(stvar.spellhistory) do
		spellname = spell[1]
		if spellname == 'pb' then
			pamount = testst*pr
			testst = testst - pamount
			local purify = {}
			purify.srcGUID = srcGUID
			purify.srcName = srcName
			purify.samount = pamount
			logStaggerPurify(Skada.current, purify)
			logStaggerPurify(Skada.total, purify)
		elseif spellname == 'isb' then
			qsamount = testst*ir
			local purify = {}
			purify.srcGUID = srcGUID
			purify.srcName = srcName
			purify.samount = qsamount
			logStaggerQuicksip(Skada.current, purify)
			logStaggerQuicksip(Skada.total, purify)
		elseif spellname == 'stin' then
			testst = testst + spell[2]
		elseif spellname == 'stout' then
			testst = testst - spell[2]
		end
	end
end

local function proc_st_tick(timestamp,dstGUID,dstName,samount,sabsorbed,srcName,srcGUID,isabsorb)
	local player = Skada:get_player(Skada.current, dstGUID, dstName)
	stvar = player.stagger
	tick.timestamp = timestamp
	tick.dstGUID = dstGUID
	tick.dstName = dstName
	tick.samount = samount
	tick.remainingStagger = UnitStagger(dstName)
	logStaggerTick(Skada.current, tick, true)
	logStaggerTick(Skada.total, tick, false)
	if sabsorbed then
		if player.stagger.tickMax < samount+sabsorbed then
			player.stagger.tickMax = samount+sabsorbed
		end
		playertotal = Skada:get_player(Skada.total, dstGUID, dstName)
		if playertotal.stagger.tickMax < samount+sabsorbed then
			playertotal.stagger.tickMax = samount+sabsorbed
		end
	end
	local unitst = UnitStagger(srcName)
	if stvar.spellhistory[1] ~= nil then
		if stvar.spellhistory[1][1] == 'stin' and stvar.spellhistory[2] == nil then
			local donothing = nil
		elseif stvar.spellhistory[1][1] == 'stout' and stvar.spellhistory[2] == nil then
			local donothing = nil
		elseif stvar.spellhistory[1][1] == 'stin' and stvar.spellhistory[2][1] == 'stout' and stvar.spellhistory[3]==nil then
			local donothing = nil
		else
			if stvar.pbrate == -1 or stvar.qsrate == -1 then
				local realst = 0
				if sabsorbed then
					realst = unitst+samount+sabsorbed
				else
					realst = unitst+samount
				end
				usepb,useisb,pamounts,qsamounts,found = calcrate(stvar,realst)
				if found == 0 and isabsorb == 1 then return end
				if usepb == 1 then
					for i, pamount in ipairs(pamounts) do
						local purify = {}
						purify.srcGUID = srcGUID
						purify.srcName = srcName
						purify.samount = pamount
						logStaggerPurify(Skada.current, purify)
						logStaggerPurify(Skada.total, purify)
					end
				end
				if useisb == 1 then
					for i, qsamount in ipairs(qsamounts) do
						local purify = {}
						purify.srcGUID = srcGUID
						purify.srcName = srcName
						purify.samount = qsamount
						logStaggerQuicksip(Skada.current, purify)
						logStaggerQuicksip(Skada.total, purify)
					end
				end
			else
				logspelllist(stvar,srcGUID,srcName)
			end
		end
	end
	stvar.stpool = unitst
	stvar.spellhistory = {}
	sttaken = sttaken + samount
end

local function log_stabsorb(set,samount, dstGUID, dstName)
	local player = Skada:get_player(set, dstGUID, dstName)
	player.stagger.absorbed = player.stagger.absorbed + samount
	if set == Skada.current then
		local stvar = player.stagger
		table.insert(stvar.spellhistory, {'stin',samount})
	end
end

local tick = {}

local function SpellAbsorbed(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
	local chk = ...
	local spellId, spellName, spellSchool, aGUID, aName, aFlags, aRaidFlags, aspellId, aspellName, aspellSchool, aAmount
	if type(chk) == "number" then
		spellId, spellName, spellSchool, aGUID, aName, aFlags, aRaidFlags, aspellId, aspellName, aspellSchool, aAmount = ...
		if spellId == 124255 then
			proc_st_tick(timestamp,dstGUID,dstName,aAmount,0,srcName,srcGUID,1)
		end
		if aspellId ~= 115069 then return end
		if aAmount then
			log_stabsorb(Skada.current, aAmount,dstGUID, dstName)
			log_stabsorb(Skada.total, aAmount, dstGUID, dstName)
		end
	else
		aGUID, aName, aFlags, aRaidFlags, aspellId, aspellName, aspellSchool, aAmount = ...
		if aspellId ~= 115069 then return end
		if aAmount then
			log_stabsorb(Skada.current, aAmount, dstGUID, dstName)
			log_stabsorb(Skada.total, aAmount, dstGUID, dstName)
		end
	end
end

last = 0
sttaken = 0

local function SpellDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
	local spellId, spellName, spellSchool, samount, soverkill, sschool, sresisted, sblocked, sabsorbed, scritical, sglancing, scrushing = ...
	if spellId == 124255 then -- Stagger damage
		proc_st_tick(timestamp,dstGUID,dstName,samount,sabsorbed,srcName,srcGUID)
	end
end

stpury = 0

local function SpellCast(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
	local spellId, spellName, spellSchool = ...
	local player = Skada:get_player(Skada.current, srcGUID, srcName)
	local stvar = player.stagger
	if spellId == 119582 then -- Purifying brew
		table.insert(stvar.spellhistory,{'pb',1})
	elseif spellId == 115308 then
		table.insert(stvar.spellhistory,{'isb',1})
	end
end

function mod:OnEnable()
	mod.metadata = {showspots = false, click1 = modDetails, icon = "Interface\\Icons\\monk_stance_drunkenox"}
	modDetails.metadata = {showspots = false, ordersort = true}
	Skada:RegisterForCL(SpellDamage, 'SPELL_PERIODIC_DAMAGE', {src_is_interesting = true, dst_is_interesting_nopets = false})
	Skada:RegisterForCL(SpellCast, 'SPELL_CAST_SUCCESS', {src_is_interesting = true, dst_is_interesting_nopets = false})
	Skada:RegisterForCL(SpellAbsorbed, 'SPELL_ABSORBED', {dst_is_interesting = true})
	Skada:AddMode(self, "Stagger")
end

function mod:OnDisable()
	Skada:RemoveMode(self)
end

function modDetails:Enter(win, id, label)
	modDetails.playerid = id
	modDetails.title = label
end

function modDetails:Update(win, set)
	local player = Skada:find_player(set, self.playerid)
	if player then
		local playerStagger = player.stagger
		local staggerabsorbed = playerStagger.absorbed
		local damageStaggered = staggerabsorbed
		if damageStaggered == 0 then return end
		local setDuration = getSetDuration(set)
		local datasetContext = {}
		-- dmg staggered
		local staggered = nextDataset(win, datasetContext)
		staggered.label = L["labels.stin"]
		staggered.valuetext = Skada:FormatNumber(damageStaggered)
		staggered.value = 1
		-- stagger taken
		local staggerTaken = nextDataset(win, datasetContext)
		staggerTaken.label = L["labels.taken"]
		staggerTaken.valuetext = Skada:FormatNumber(playerStagger.taken)..(" (%02.1f%%)"):format(playerStagger.taken / damageStaggered * 100)
		staggerTaken.value = playerStagger.taken / damageStaggered
		-- purifying brew
		if playerStagger.purifyCount > 0 then
			local staggerPurified = nextDataset(win, datasetContext)
			staggerPurified.label = L["labels.pb"]
			staggerPurified.valuetext = Skada:FormatNumber(playerStagger.purified)..(" (%02.1f%%)"):format(playerStagger.purified / damageStaggered * 100)
			staggerPurified.value = playerStagger.purified / damageStaggered
			-- purifying brew ave
			local staggerPurifiedAvg = nextDataset(win, datasetContext)
			staggerPurifiedAvg.label = L["labels.pb_a"]
			staggerPurifiedAvg.valuetext = Skada:FormatNumber(playerStagger.purified / playerStagger.purifyCount).." ("..playerStagger.purifyCount.."x)"
			staggerPurifiedAvg.value = (playerStagger.purified / playerStagger.purifyCount) / damageStaggered
		end
		-- quicksip
		if playerStagger.purified_quicksip > 0 then
			local staggerquicksip = nextDataset(win, datasetContext)
			staggerquicksip.label = L["labels.qs"]
			staggerquicksip.valuetext = Skada:FormatNumber(playerStagger.purified_quicksip)..(" (%02.1f%%)"):format(playerStagger.purified_quicksip / damageStaggered * 100)
			staggerquicksip.value = playerStagger.purified_quicksip / damageStaggered
		end
		-- others
		local others = damageStaggered - playerStagger.taken - playerStagger.purified - playerStagger.purified_quicksip
		if others >= 0 then
			local o = nextDataset(win, datasetContext)
			o.label = L["labels.others"]
			o.valuetext = Skada:FormatNumber(others)..(" (%02.1f%%)"):format(others / damageStaggered * 100)
			o.value = others / damageStaggered
		end
		-- duration
		if setDuration > 0 and playerStagger.duration > 0 then
			local staggerDuration = nextDataset(win, datasetContext)
			staggerDuration.label = L["labels.duration"]
			staggerDuration.valuetext = ("%02.1f秒"):format(playerStagger.duration)
			staggerDuration.value = playerStagger.duration / setDuration
		-- freeze
			if playerStagger.freezeDuration > 2 then
				local freezeDuration = nextDataset(win, datasetContext)
				freezeDuration.label = L["labels.freeze"]
				freezeDuration.valuetext = ("%02.1f秒"):format(playerStagger.freezeDuration)..(" (%02.1f%%)"):format(playerStagger.freezeDuration / playerStagger.duration * 100)
				freezeDuration.value = playerStagger.freezeDuration / setDuration
			end
		end
		-- tick max
		local tickMax = nextDataset(win, datasetContext)
		tickMax.label = L["labels.tickmax"]
		tickMax.valuetext = Skada:FormatNumber(playerStagger.tickMax)
		tickMax.value = playerStagger.tickMax / damageStaggered
		win.metadata.maxvalue = 1
	end
end

function mod:AddPlayerAttributes(player, set)
	if not player.stagger then
		player.stagger = {
			purified_quicksip = 0,
			purified_quicksip_static = 0,
			absorbed = 0,
			dtb4st = 0,
			stpool = 0,
			stpool_static = 0,
			t20 = -1,
			qsrate = -1,
			pbrate = -1,
			spellhistory = {},
			taken = 0,
			purified = 0,
			purified_static = 0,
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
	return L["labels.purified"].." ("..Skada:FormatNumber(totalPurified)..")"
end

function mod:Update(win, set)
	local nr = 1
	local max = 0
	for i, player in ipairs(set.players) do
		if player.stagger then
			local value = player.stagger.absorbed
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