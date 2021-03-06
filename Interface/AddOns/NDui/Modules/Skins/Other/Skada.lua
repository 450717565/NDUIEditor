local _, ns = ...
local B, C, L, DB = unpack(ns)
local SKIN = B:GetModule("Skins")

local function Strip_Options(self)
	self.baroptions.args.barspacing = nil
	self.titleoptions.args.texture = nil
	self.titleoptions.args.bordertexture = nil
	self.titleoptions.args.thickness = nil
	self.titleoptions.args.margin = nil
	self.titleoptions.args.color = nil
	self.windowoptions = nil
	self.baroptions.args.barfont = nil
	self.titleoptions.args.font = nil
end

local function Embed_Window(window, width, barheight, height, ofsx, ofsy)
	window.db.barwidth = width
	window.db.barheight = barheight
	if window.db.enabletitle then
		height = height - barheight
	end
	window.db.background.height = height
	window.db.spark = false
	window.db.barslocked = true
	window.bargroup:ClearAllPoints()
	window.bargroup:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", ofsx, ofsy)
	barmod.ApplySettings(barmod, window)
end

function SKIN:Skada()
	if not C.db["Skins"]["Skada"] or not IsAddOnLoaded("Skada") then return end

	local Skada = Skada
	local barSpacing = 0
	local barmod = Skada.displays["bar"]

	barmod.AddDisplayOptions_ = barmod.AddDisplayOptions
	barmod.AddDisplayOptions = function(self, win, options)
		self:AddDisplayOptions_(win, options)
		Strip_Options(options)
	end

	for _, options in pairs(Skada.options.args.windows.args) do
		if options.type == "group" then
			Strip_Options(options.args)
		end
	end

	barmod.ApplySettings_ = barmod.ApplySettings
	barmod.ApplySettings = function(self, win)
		barmod.ApplySettings_(self, win)
		local window = win.bargroup
		if win.db.enabletitle then
			window.button:SetBackdrop("")
		end
		window:SetSpacing(barSpacing)
		window:SetFrameLevel(5)
		window.SetFrameLevel = B.Dummy
		window:SetBackdrop("")
		B.StripTextures(window.borderFrame)

		if not window.bg then
			window.bg = B.CreateBG(window)

			local open, close = B.CreateToggle(window)
			open:HookScript("OnClick", function()
				window:Show()
			end)
			close:HookScript("OnClick", function()
				window:Hide()
			end)
		end
		window.bg:ClearAllPoints()
		if win.db.enabletitle then
			window.bg:SetPoint("TOPLEFT", window.button, "TOPLEFT", -3, 3)
		else
			window.bg:SetPoint("TOPLEFT", window, "TOPLEFT", -3, 3)
		end
		window.bg:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", 3, -3)
		window.button:SetBackdropColor(1, 1, 1, 0)
		window.button:SetFrameStrata("MEDIUM")
		window.button:SetFrameLevel(5)
		window:SetFrameStrata("MEDIUM")
	end

	local windows = {}
	local function EmbedSkada()
		if #windows == 1 then
			Embed_Window(windows[1], 350, 16, 193, -6, 32)
		elseif #windows == 2 then
			Embed_Window(windows[1], 350, 16, 113, -6, 32)
			Embed_Window(windows[2], 350, 16, 113, -6, 156)
		end
	end

	for _, window in pairs(Skada:GetWindows()) do
		window:UpdateDisplay()
	end

	Skada.CreateWindow_ = Skada.CreateWindow
	function Skada:CreateWindow(name, db)
		Skada:CreateWindow_(name, db)
		wipe(windows)
		for _, window in pairs(Skada:GetWindows()) do
			table.insert(windows, window)
		end
		EmbedSkada()
	end

	Skada.DeleteWindow_ = Skada.DeleteWindow
	function Skada:DeleteWindow(name)
		Skada:DeleteWindow_(name)
		wipe(windows)
		for _, window in pairs(Skada:GetWindows()) do
			table.insert(windows, window)
		end
		EmbedSkada()
	end

	EmbedSkada()

	-- Change Skada Default Settings
	Skada.windowdefaults.barbgcolor = {r=0,g=0,b=0,a=0}
	Skada.windowdefaults.barfontflags = DB.Font[3]
	Skada.windowdefaults.barfontsize = 12
	Skada.windowdefaults.bartexture = "normTex"
	Skada.windowdefaults.classicons = false
	Skada.windowdefaults.smoothing = true
	Skada.windowdefaults.title.color = {r=0,g=0,b=0,a=.3}
	Skada.windowdefaults.title.fontflags = DB.Font[3]
	Skada.windowdefaults.title.fontsize = 14

	-- Change Skada NumberFormat
	Skada.options.args.generaloptions.args.numberformat = nil

	function Skada:FormatNumber(number)
		if number then return B.FormatNumb(number) end
	end
end