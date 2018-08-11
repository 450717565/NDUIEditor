local _, ns = ...
local _, C = unpack(ns)

-- 法术白名单
C.WhiteList = {
	-- Buffs
	[642]		= true,		-- 圣盾术
	[1022]		= true,		-- 保护之手
	[23920]		= true,		-- 法术反射
	[45438]		= true,		-- 寒冰屏障
	[186265]	= true,		-- 灵龟守护
	-- Debuffs
	[2094]		= true,		-- 致盲
	-- Mythic dungeons
	[228318]	= true,		-- 激怒
	[226510]	= true,		-- 血池
	[200672]	= true,		-- 水晶迸裂
	[232156]	= true,		-- 鬼灵服务
	[228225]	= true,		-- 阴燃高温，驱散
	[227909]	= true,		-- 幽灵陷阱
	[229489]	= true,		-- 象棋国王免伤
	[226285]	= true,		-- 恶魔飞升，驱散
	[277242]	= true,		-- 共生
	-- Raids
	[207327]	= true,		-- 净化毁灭，崔利艾克斯
	[236513]	= true,		-- 骨牢护甲，聚合体小怪
	[240315]	= true,		-- 硬化之壳，哈亚坦蛋盾
	[241521]	= true,		-- 折磨碎片，M审判庭小怪
	[250074]	= true,		-- 净化，艾欧娜尔
	[250555]	= true,		-- 邪能护盾，艾欧娜尔
	[246504]	= true,		-- 程式启动，金加洛斯
	[249863]	= true,		-- 泰坦的面容，破坏魔女巫会
	[244903]	= true,		-- 催化作用，阿格拉玛
	[247091]	= true,		-- 催化，阿格拉玛
	[253021]	= true,		-- 宿命，寂灭者阿古斯
	[255496]	= true,		-- 宇宙之剑，寂灭者阿古斯
	[255478]	= true,		-- 永恒之刃，寂灭者阿古斯
	[255418]	= true,		-- 物理易伤，寂灭者阿古斯
	[255425]	= true,		-- 冰霜易伤，寂灭者阿古斯
	[255430]	= true,		-- 暗影易伤，寂灭者阿古斯
	[255429]	= true,		-- 火焰易伤，寂灭者阿古斯
	[255419]	= true,		-- 神圣易伤，寂灭者阿古斯
	[255422]	= true,		-- 自然易伤，寂灭者阿古斯
	[255433]	= true,		-- 奥术易伤，寂灭者阿古斯
}

-- 法术黑名单
C.BlackList = {
	[15407]		= true,		-- 精神鞭笞
	[1490]		= true,		-- 混乱烙印
	[113746]	= true,		-- 玄秘掌
	[51714]		= true,		-- 锋锐之霜
}
