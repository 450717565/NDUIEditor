local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

local function ReskinDetails()
	local function setupInstance(self)
		if self.styled then return end
		if not self.baseframe then return end

		self:ChangeSkin("Minimalistic")
		self:InstanceWallpaper(false)
		self:DesaturateMenu(true)
		self:HideMainIcon(false)
		self:SetBackdropTexture("None")
		self:MenuAnchor(16, 3)
		self:ToolbarMenuButtonsSize(1)
		self:AttributeMenu(true, 0, 3, DB.Font[1], 13, {1, 1, 1}, 1, true)
		self:SetBarSettings(18, NDuiADB["ResetDetails"] and "NDui" or nil)
		self:SetBarTextSettings(NDuiADB["ResetDetails"] and 14 or nil, DB.Font[1], nil, nil, nil, true, true, nil, nil, nil, nil, nil, nil, false, nil, false, nil)

		local bg = B.CreateBGFrame(self.baseframe, "tex")
		bg:SetPoint("TOPLEFT", -1, 18)
		self.baseframe.bg = bg

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
				EmbedWindow(instance2, -6, 148, 320, height)
			end
			EmbedWindow(instance1, -6, 32, 320, height)
		end
	end

	local listener = Details:CreateEventListener()
	listener:RegisterEvent("DETAILS_INSTANCE_OPEN")
	function listener:OnDetailsEvent(event, instance)
		if event == "DETAILS_INSTANCE_OPEN" then
			if not instance.styled and instance:GetId() == 2 then
				instance1:SetSize(320, 95)
				EmbedWindow(instance, -6, 148, 320, 95)
			end
			setupInstance(instance)
		end
	end

	-- Numberize
	local _detalhes = _G._detalhes
	local current = NDuiADB["NumberFormat"]
	if current < 3 then
		_detalhes.numerical_system = current
		_detalhes:SelectNumericalSystem()
	end
	_detalhes.OpenWelcomeWindow = function()
		if instance1 then
			EmbedWindow(instance1, -6, 32, 320, 190)
			instance1:SetBarSettings(18, "normTex")
			instance1:SetBarTextSettings(14, DB.Font[1], nil, nil, nil, true, true, nil, nil, nil, nil, nil, nil, false, nil, false, nil)
		end
	end

	NDuiADB["ResetDetails"] = false
end

S:LoadWithAddOn("Details", "Details", ReskinDetails)