local _, ns = ...
local B, C, L, DB = unpack(ns)
local Extras = B:GetModule("Extras")

local TomesToQuests = {
	[118572] = 42946, --附魔幻象：拉格纳罗斯的怒焰
	[120286] = 42949, --附魔幻象：辉煌暴君
	[120287] = 42950, --附魔幻象：原始胜利
	[128649] = 42947, --附魔幻象：寒冬之握
	[138787] = 42871, --幻象之书：艾泽拉斯
	[138789] = 42873, --幻象之书：外域
	[138790] = 42874, --幻象之书：诺森德
	[138791] = 42875, --幻象之书：大地的裂变
	[138792] = 42876, --幻象之书：元素领主
	[138793] = 42877, --幻象之书：潘达利亚
	[138794] = 42878, --幻象之书：影踪派的秘密
	[138795] = 42879, --幻象之书：德拉诺
	[138796] = 42891, --附魔幻象：斩杀
	[138797] = 42892, --附魔幻象：猫鼬
	[138798] = 42893, --附魔幻象：阳炎
	[138799] = 42894, --附魔幻象：魂霜
	[138800] = 42895, --附魔幻象：利刃防护
	[138801] = 42896, --附魔幻象：吸血
	[138802] = 42898, --附魔幻象：能量洪流
	[138803] = 42900, --附魔幻象：治愈
	[138804] = 42902, --附魔幻象：巨神像
	[138805] = 42906, --附魔幻象：玉魂
	[138806] = 42907, --附魔幻象：影月之印
	[138807] = 42908, --附魔幻象：碎手之印
	[138808] = 42909, --附魔幻象：血环之印
	[138809] = 42910, --附魔幻象：黑石之印
	[138827] = 42934, --附魔幻象：梦魇
	[138828] = 42938, --附魔幻象：时光
	[138832] = 42941, --附魔幻象：大地生命(职业:SM)
	[138833] = 42942, --附魔幻象：火舌(职业:SM)
	[138834] = 42943, --附魔幻象：冰封(职业:SM)
	[138835] = 42944, --附魔幻象：石化(职业:SM)
	[138836] = 42945, --附魔幻象：风怒(职业:SM)
	[138838] = 42948, --附魔幻象：死亡霜冻
	[138954] = 42972, --附魔幻象：淬毒(职业:DZ)
	[138955] = 42973, --附魔幻象：冰锋符文(职业:DK)
	[172177] = 57596, --附魔幻象：怨幽之寒
	[174932] = 58927, --附魔幻象：虚空之锋
}

function Extras:IC_CheckInfo()
	if self:IsForbidden() then return end

	local showIt = false
	local _, link = self:GetItem()
	if link then
		local itemId = tonumber(string.match(link, 'item:(%d+):'))
		local questId = TomesToQuests[itemId]
		if questId then
			if C_QuestLog.IsQuestFlaggedCompleted(questId) then
				self:AddLine(COLLECTED, 0, 1, 0)
			else
				self:AddLine(NOT_COLLECTED, 1, 0, 0)
			end
		end

		showIt = true
	end

	if showIt then self:Show() end
end

function Extras:IllusionsCheck()
	GameTooltip:HookScript("OnTooltipSetItem", self.IC_CheckInfo)
end