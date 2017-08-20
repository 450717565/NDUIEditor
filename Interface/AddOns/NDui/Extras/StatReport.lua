local B, C, L, DB = unpack(select(2, ...))

-- 定义标点符号
local Point = " "

-- 本地化专精
local function Talent()
	local Spec = GetSpecialization()
	local SpecName = (Spec and select(2, GetSpecializationInfo(Spec))) or "无"
	return SpecName
end

-- 基础属性
local function BaseInfo()
	local BaseStats = ""
	BaseStats = BaseStats..("职业:%s"):format(UnitClass("player"))..Point
	BaseStats = BaseStats..("专精:%s"):format(Talent())..Point
	BaseStats = BaseStats..("装等:%.1f(%.1f)"):format(GetAverageItemLevel())..Point

	return BaseStats
end

-- 属性通报
function StatsReport()
	local StatsInfo = ""
	local STR = UnitStat("player", 1)
	local AGI = UnitStat("player", 2)
	local INT = UnitStat("player", 4)
	local LVL = UnitLevel("player")
	local Role = GetSpecializationRole(GetSpecialization())

	if HasArtifactEquipped() then
		local ArtifactLvl = select(6, C_ArtifactUI.GetEquippedArtifactInfo())
		if ArtifactLvl > 51 then
			StatsInfo = StatsInfo..("神器:%s(%s)"):format(ArtifactLvl, ArtifactLvl-51)..Point
		else
			StatsInfo = StatsInfo..("神器:%s"):format(ArtifactLvl)..Point
		end
	end

	if STR > AGI then
		StatsInfo = StatsInfo..("力量:%s"):format(UnitStat("player", 1))..Point
	elseif AGI > INT then
		StatsInfo = StatsInfo..("敏捷:%s"):format(UnitStat("player", 2))..Point
	else
		StatsInfo = StatsInfo..("智力:%s"):format(UnitStat("player", 4))..Point
	end

	StatsInfo = StatsInfo..("血量:%s"):format(B.Numb(UnitHealthMax("player")))..Point
	StatsInfo = StatsInfo..("爆击:%.2f%%"):format(GetCritChance())..Point
	StatsInfo = StatsInfo..("急速:%.2f%%"):format(GetHaste())..Point
	StatsInfo = StatsInfo..("精通:%.2f%%"):format(GetMasteryEffect())..Point
	if GetCombatRatingBonus(29) > 0 then
		StatsInfo = StatsInfo..("全能:%.2f%%"):format(GetCombatRatingBonus(29))..Point
	end
	if GetAvoidance() > 0 then
		StatsInfo = StatsInfo..("闪避:%.2f%%"):format(GetAvoidance())..Point
	end
	if GetLifesteal() > 0 then
		StatsInfo = StatsInfo..("吸血:%.2f%%"):format(GetLifesteal())..Point
	end

	if Role == "TANK" then
		StatsInfo = StatsInfo..("躲闪:%.2f%%"):format(GetDodgeChance())..Point
		StatsInfo = StatsInfo..("招架:%.2f%%"):format(GetParryChance())..Point
		if GetBlockChance() > 0 then
			StatsInfo = StatsInfo..("格挡:%.2f%%"):format(GetBlockChance())..Point
		end
	end

	if LVL < 10 then
		return BaseInfo()
	else
		return BaseInfo()..StatsInfo
	end
end