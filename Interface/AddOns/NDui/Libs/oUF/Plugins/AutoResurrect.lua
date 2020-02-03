--------------------------------
-- FreebAutoRez, by Freebaser
-- NDui MOD
--------------------------------
local _, ns = ...
local B, C, L, DB = unpack(ns)
local oUF = ns.oUF or oUF

local classList = {
	["DEATHKNIGHT"] = {
		combat = GetSpellInfo(61999),		-- 复活盟友
	},
	["DRUID"] = {
		combat = GetSpellInfo(20484),		-- 复生
		oneres = GetSpellInfo(50769),		-- 起死回生
		allres = GetSpellInfo(212040),		-- 新生
	},
	["HUNTER"] = {
		[1] = GetSpellInfo(126393),		-- 永恒守护者
		[2] = GetSpellInfo(159931),		-- 赤精之赐
		[3] = GetSpellInfo(159956),		-- 生命之尘
	},
	["MONK"] = {
		oneres = GetSpellInfo(115178),		-- 轮回转世
		allres = GetSpellInfo(212051),		-- 死而复生
	},
	["PALADIN"] = {
		oneres = GetSpellInfo(7328),		-- 救赎
		allres = GetSpellInfo(212056),		-- 宽恕
	},
	["PRIEST"] = {
		oneres = GetSpellInfo(2006),		-- 复活术
		allres = GetSpellInfo(212036),		-- 群体复活
	},
	["SHAMAN"] = {
		oneres = GetSpellInfo(2008),		-- 先祖之魂
		allres = GetSpellInfo(212048),		-- 先祖视界
	},
	["WARLOCK"] = {
		combat = GetSpellInfo(20707),		-- 灵魂石
	},
}

local body = ""
local function macroBody(class)
	body = "/stopmacro [@mouseover,harm,nodead][harm,nodead]\n"
	body = "/stopcasting\n"

	if class == "HUNTER" then
		for i = 1, #classList.HUNTER do
			local hunterSpell = classList.HUNTER[i]
			body = body.."/cast [combat,@mouseover,help,dead][combat,help,dead] "..hunterSpell.."\n"
		end
	else
		local combatSpell = classList[class].combat
		local oneresSpell = classList[class].oneres
		local allresSpell = classList[class].allres

		if combatSpell then
			body = body.."/cast [combat,@mouseover,help,dead][combat,help,dead] "..combatSpell.."\n"
		end
		if allresSpell then
			body = body.."/cast [nocombat] "..allresSpell.."\n"
		end
		if oneresSpell then
			body = body.."/cast [nocombat,@mouseover,help,dead][nocombat,help,dead] "..oneresSpell.."\n"
		end
	end

	return body
end

local function setupAttribute(self)
	if InCombatLockdown() then return end

	if classList[DB.MyClass] and not IsAddOnLoaded("Clique") then
		self:SetAttribute("*type3", "macro")
		self:SetAttribute("macrotext3", macroBody(DB.MyClass))
		self:UnregisterEvent("PLAYER_REGEN_ENABLED", setupAttribute)
	end
end

local Enable = function(self)
	if not NDuiDB["UFs"]["AutoRes"] then return end

	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED", setupAttribute, true)
	else
		setupAttribute(self)
	end
end

local Disable = function(self)
	if NDuiDB["UFs"]["AutoRes"] then return end

	self:SetAttribute("*type3", nil)
	self:UnregisterEvent("PLAYER_REGEN_ENABLED", setupAttribute)
end

oUF:AddElement("AutoResurrect", nil, Enable, Disable)