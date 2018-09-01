-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2015 Elotheon-Arthas-EU
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License along
-- with this program; if not, write to the Free Software Foundation, Inc.,
-- 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
-------------------------------------------------------------------------------

local PGF = select(2, ...)
local L = PGF.L

if GetLocale() ~= "zhCN" then return end

L["button.ok"] = "确定"
L["error.syntax"] = "|cffff0000过滤语法错误|r\n\n表示过滤语法不正确，例如缺少过滤条件、变量或运算符号，或是写成 'tanks=1' 而不是 'tanks==1'。\n\n详细错误讯息：\n|cffaaaaaa%s|r"
L["error.semantic"] = "|cffff0000过滤语法的语意错误|r\n\n表示过滤语法正确，但是很可能变量写错字，例如写成 tansk 而不是 tanks。\n\n详细错误讯息：\n|cffaaaaaa%s|r"
L["error.semantic.protected"] = "|cffff0000过滤语法的语意错误|r\n\n不再支持关键字 'name'，'comment' 和 'findnumber'。 请从高级过滤器表达式中删除它们或按重置按钮。\n\n从战斗艾泽拉斯准备开始，这些价值现在受到暴雪的保护，任何插件都无法读取。\n\n使用组列表上方的默认搜索栏过滤组名称。\n\n详细错误讯息：\n|cffaaaaaa%s|r"

L["dialog.defeated"] = "已击杀|cFF00ff00团队|r首领 ....."
L["dialog.difficulty"] = "难度 ............................"
L["dialog.dps"] = "输出 ............................"
L["dialog.expl.advanced"] = "如果上方的选项不够用，可以使用进阶语法来查询。"
L["dialog.expl.max"] = "最大"
L["dialog.expl.min"] = "最小"
L["dialog.expl.simple"] = "勾选选项，输入最大值和(或)最小值，然后按下搜索。"
L["dialog.expl.state"] = "队伍必须包含："
L["dialog.heals"] = "治疗 ............................"
L["dialog.heroic"] = "英雄"
L["dialog.ilvl"] = "装等 ............................"
L["dialog.members"] = "人数 ............................"
L["dialog.mythic"] = "史诗"
L["dialog.mythicplus"] = "秘境"
L["dialog.noilvl"] = "或不指定装等"
L["dialog.normal"] = "普通"
L["dialog.refresh"] = "搜索"
L["dialog.reset"] = "重置"
L["dialog.tanks"] = "坦克 ............................"
L["dialog.to"] = "～"
L["dialog.tooltip.age"] = "几分钟前建立的"
L["dialog.tooltip.arena"] = "选择指定的竞技场类型"
L["dialog.tooltip.classes"] = "指定的职业人数"
L["dialog.tooltip.defeated"] = "已击杀的首领数量"
L["dialog.tooltip.description"] = "说明"
L["dialog.tooltip.difficulty"] = "难度"
L["dialog.tooltip.dps"] = "伤害输出人数"
L["dialog.tooltip.dungeons"] = "选择指定的地下城"
L["dialog.tooltip.ex.and"] = "heroic and hfc"
L["dialog.tooltip.ex.eq"] = "dps == 3"
L["dialog.tooltip.ex.find"] = "not name:find(\"wts\")"
L["dialog.tooltip.ex.lt"] = "hlvl >= 5"
L["dialog.tooltip.ex.match"] = "name:match(\"+(%d)\")==\"5\""
L["dialog.tooltip.ex.neq"] = "members ~= 0"
L["dialog.tooltip.ex.not"] = "not myrealm"
L["dialog.tooltip.ex.or"] = "normal or heroic"
L["dialog.tooltip.ex.parentheses"] = "（voice or not voice）"
L["dialog.tooltip.example"] = "示例"
L["dialog.tooltip.heals"] = "治疗人数"
L["dialog.tooltip.hlvl"] = "需要的荣誉等级"
L["dialog.tooltip.ilvl"] = "需要的装备等级"
L["dialog.tooltip.matchingid"] = "相同进度的队伍"
L["dialog.tooltip.members"] = "成员人数"
L["dialog.tooltip.myrealm"] = "队长和我是同一个服务器"
L["dialog.tooltip.noid"] = "我还没有进度的副本"
L["dialog.tooltip.op.func"] = "函数"
L["dialog.tooltip.op.logic"] = "逻辑运算符号"
L["dialog.tooltip.op.number"] = "数字运算符号"
L["dialog.tooltip.op.string"] = "文字运算符号"
L["dialog.tooltip.raids"] = "选择指定的团队"
L["dialog.tooltip.seewebsite"] = "详见网站"
L["dialog.tooltip.tanks"] = "坦克人数"
L["dialog.tooltip.title"] = "进阶过滤语法"
L["dialog.tooltip.variable"] = "变量"
L["dialog.tooltip.voice"] = "语音"
L["dialog.usepgf.tooltip"] = "启用或停用预创建伍过滤"

L["PGF"] = "过滤选项"
L["Premade Groups Filter"] = "预创建伍过滤"
