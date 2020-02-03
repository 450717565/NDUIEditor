-- Configure 配置页面
local _, ns = ...
local B, C, L, DB = unpack(ns)

-- BUFF/DEBUFF相关
C.Auras = {
	BuffPos			= {"TOPRIGHT", Minimap, "TOPLEFT", -15, 0},				-- BUFF默认位置

	IconSize		= 32,													-- 相关职业助手图标大小
	TotemsPos		= {"CENTER", UIParent, "CENTER", 0, -206},				-- 图腾助手默认位置
	StatuePos		= {"CENTER", UIParent, "CENTER", 0, -240},				-- 武僧雕像默认位置

	-- 技能监控各组初始位置
	EnchantAuraPos			= {"BOTTOMRIGHT", UIParent, "CENTER", -200, -99},	-- 附魔及饰品分组
	PlayerSpecialAuraPos	= {"BOTTOMRIGHT", UIParent, "CENTER", -200, -136},	-- 玩家重要光环分组
	PlayerAuraPos			= {"BOTTOMRIGHT", UIParent, "CENTER", -200, -165},	-- 玩家光环分组

	TargetSpecialAuraPos	= {"BOTTOMLEFT", UIParent, "CENTER", 200, -128},	-- 目标重要光环分组
	TargetAuraPos			= {"BOTTOMLEFT", UIParent, "CENTER", 200, -165},	-- 目标光环分组

	FocusSpecialAuraPos		= {"BOTTOMLEFT", UIParent, "LEFT", 5, -130},		-- 焦点重要光环分组
	RaidBuffPos				= {"BOTTOMRIGHT", UIParent, "CENTER", -200, 200},	-- 团队增益分组
	RaidDebuffPos			= {"BOTTOMLEFT", UIParent, "CENTER", 200, 200},		-- 团队减益分组
	SpellCDPos				= {"LEFT", UIParent, "LEFT", 5, -30},				-- 技能冷却计时分组
	EnchantCDPos			= {"LEFT", UIParent, "LEFT", 200, -30},				-- 物品冷却计时分组
	CustomCDPos				= {"BOTTOMLEFT", UIParent, "CENTER", 519, -214},	-- 法术内置冷却分组
}

-- 头像相关
C.UFs = {
	Playercb		= {"BOTTOM", UIParent, "BOTTOM", 0, 150},				-- 玩家施法条默认位置
	Targetcb		= {"BOTTOM", UIParent, "BOTTOM", 0, 310},				-- 目标施法条默认位置
	Focuscb			= {"CENTER", UIParent, "CENTER", 0, 150},				-- 焦点施法条默认位置

	PlayerPos		= {"BOTTOMRIGHT", UIParent, "BOTTOM", -200, 280},		-- 玩家框体默认位置
	TargetPos		= {"BOTTOMLEFT", UIParent, "BOTTOM", 200, 280},			-- 目标框体默认位置
	FocusPos		= {"LEFT", UIParent, "LEFT", 5, -150},					-- 焦点框体默认位置

	PlayerPlate		= {"BOTTOM", UIParent, "BOTTOM", 0, 230},				-- 个人资源条默认位置
	BarWidth		= 150,													-- 资源条长度
	BarMargin		= 2,													-- 资源条间隔
}

-- 小地图
C.Minimap = {
	Pos				= {"TOPRIGHT", UIParent, "TOPRIGHT", -7, -7},			-- 小地图默认位置
}

-- 美化及皮肤
C.Skins = {
	MicroMenuPos	= {"BOTTOM", UIParent, "BOTTOM", 0, 3},					-- 微型菜单默认坐标
	RMPos			= {"TOP", UIParent, "TOP", 0, -2},						-- 团队工具默认坐标
}

-- 鼠标提示框
C.Tooltips = {
	TipPos			= {"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -55, 230},	-- 鼠标提示框默认位置
}

-- 信息条
C.Infobar = {
	Guild	 		= true,												-- 公会信息
	GuildPos 		= {"TOPLEFT", UIParent, "TOPLEFT", 20, -7},			-- 公会信息位置
	Friends 		= true,												-- 好友模块
	FriendsPos 		= {"TOPLEFT", UIParent, "TOPLEFT", 125, -7},		-- 好友模块位置
	System			= true,												-- 帧数/延迟
	SystemPos		= {"TOPLEFT", UIParent, "TOPLEFT", 230, -7},		-- 帧数/延迟位置
	Location		= true,												-- 区域信息
	LocationPos		= {"TOPLEFT", UIParent, "TOPLEFT", 410, -7},		-- 区域信息位置

	Spec			= true,												-- 天赋专精
	SpecPos			= {"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -400, 7},-- 天赋专精位置
	Memory			= true,												-- 内存占用
	MemoryPos		= {"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -310, 7},-- 内存占用位置
	MaxAddOns		= 12,												-- 插件信息显示数量
	Durability		= true,												-- 耐久度
	DurabilityPos	= {"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -195, 7},-- 耐久度位置
	Gold			= true,												-- 金币信息
	GoldPos			= {"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -95, 7},	-- 金币信息位置
	Time			= true,												-- 时间信息
	TimePos			= {"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -20, 7},	-- 时间信息位置

	FontSize		= 13,												-- 字号
	AutoAnchor		= true,												-- 自动对齐
}