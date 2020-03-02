local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

local function ReskinDetails()
	local Details = _G.Details

	-- instance table can be nil sometimes
	Details.tabela_instancias = Details.tabela_instancias or {}
	Details.instances_amount = Details.instances_amount or 5

	-- toggle windows on init
	Details:ReabrirTodasInstancias()

	-- default profile
	if NDuiADB["ResetDetails"] then
		Details.death_recap.enabled = false
		Details.instances_segments_locked = false
		Details.minimap.hide = true
		Details.minimap.text_format = 2
		Details.on_death_menu = false
		Details.ps_abbreviation = 2
		Details.segments_amount = 25
		Details.segments_amount_to_save = 25
		Details.tooltip.abbreviation = 2
		Details.tooltip.submenu_wallpaper = false
	end

	local function setupInstance(self)
		if self.styled then return end
		if not self.baseframe then return end

		self:AttributeMenu(true, 0, 3, DB.Font[1], 13, {1, 1, 1}, 1, true)
		self:ChangeSkin("Minimalistic")
		self:DesaturateMenu(false)
		self:HideMainIcon(false)
		self:InstanceColor(0, 0, 0, 0)
		self:InstanceWallpaper(false)
		self:MenuAnchor(16, 3)
		self:SetBackdropTexture("None")
		self:SetBarRightTextSettings(nil, nil, true, nil, ",")
		self:SetBarSettings(18, NDuiADB["ResetDetails"] and "Altz01" or nil, true, {0, 0, 0, 0}, NDuiADB["ResetDetails"] and "Altz01" or nil, false, {0, 0, 0, 0})
		self:SetBarTextSettings(NDuiADB["ResetDetails"] and 14 or nil, DB.Font[1], nil, nil, nil, true, true, nil, nil, nil, nil, nil, nil, false, nil, false, nil)
		self:ToolbarMenuButtonsSize(1)

		B.SetBDFrame(self.baseframe, -1, 18, 0, 0)

		if self:GetId() <= 2 then
			local open, close = S:CreateToggle(self.baseframe)
			open:HookScript("OnClick", function()
				self:ShowWindow()
			end)
			close:HookScript("OnClick", function()
				self:HideWindow()
			end)
		end

		self.styled = true
	end

	local index = 1
	local instance = Details:GetInstance(index)
	while instance do
		setupInstance(instance)
		index = index + 1
		instance = Details:GetInstance(index)
	end

	-- Reanchor
	local instance1 = Details:GetInstance(1)
	local instance2 = Details:GetInstance(2)

	local function EmbedWindow(self, x, y, width, height)
		if not self.baseframe then return end
		self.baseframe:ClearAllPoints()
		self.baseframe:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", x, y)
		self:SetSize(width, height)
		self:SaveMainWindowPosition()
		self:RestoreMainWindowPosition()
		self:LockInstance(true)
	end

	if NDuiADB["ResetDetails"] then
		local height = 190
		if instance1 then
			if instance2 then
				height = 95
				EmbedWindow(instance2, -3, 143, 350, height)
			end
			EmbedWindow(instance1, -3, 28, 350, height)
		end
	end

	local listener = Details:CreateEventListener()
	listener:RegisterEvent("DETAILS_INSTANCE_OPEN")
	function listener:OnDetailsEvent(event, instance)
		if event == "DETAILS_INSTANCE_OPEN" then
			if not instance.styled and instance:GetId() == 2 then
				instance1:SetSize(350, 95)
				EmbedWindow(instance, -3, 143, 350, 95)
			end
			setupInstance(instance)
		end
	end

	-- Numberize
	local current = NDuiADB["NumberFormat"]
	if current < 3 then
		Details.numerical_system = current
		Details:SelectNumericalSystem()
	end
	Details.OpenWelcomeWindow = function()
		if instance1 then
			EmbedWindow(instance1, -3, 28, 350, 190)
			instance1:SetBarSettings(18, "Altz01")
			instance1:SetBarTextSettings(14, DB.Font[1], nil, nil, nil, true, true, nil, nil, nil, nil, nil, nil, false, nil, false, nil)
		end
	end

	NDuiADB["ResetDetails"] = false
end

S:LoadWithAddOn("Details", "Details", ReskinDetails)