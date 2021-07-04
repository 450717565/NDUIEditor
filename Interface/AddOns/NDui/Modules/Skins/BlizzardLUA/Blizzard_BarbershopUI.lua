local _, ns = ...
local B, C, L, DB = unpack(ns)

C.OnLoadThemes["Blizzard_BarbershopUI"] = function()
	local frame = BarberShopFrame

	B.StripTextures(frame)
	B.ReskinButton(frame.AcceptButton)
	B.ReskinButton(frame.CancelButton)
	B.ReskinButton(frame.ResetButton)
end

local function Reskin_CustomizeButton(self)
	B.ReskinButton(self)

	self.bgTex:SetInside(nil, 3, 3)
end

local function Reskin_CustomizeTooltip(self)
	B.ReskinTooltip(self)
	self:SetScale(UIParent:GetScale())
end

local function Reskin_CharCustomizeFrame(self)
	for button in self.selectionPopoutPool:EnumerateActive() do
		if button and not button.styled then
			B.ReskinArrow(button.DecrementButton, "left", 24)
			B.ReskinArrow(button.IncrementButton, "right", 24)

			local SelectionPopoutButton = button.SelectionPopoutButton
			B.StripTextures(SelectionPopoutButton, 0)
			Reskin_CustomizeButton(SelectionPopoutButton)

			local Popout = SelectionPopoutButton.Popout
			B.StripTextures(Popout)

			local bg = B.CreateBDFrame(Popout, 1)
			bg:SetFrameLevel(Popout:GetFrameLevel())

			button.styled = true
		end
	end

	local optionPool = self.pools:GetPool("CharCustomizeOptionCheckButtonTemplate")
	for button in optionPool:EnumerateActive() do
		if button and not button.styled then
			B.ReskinCheck(button.Button)

			button.styled = true
		end
	end

	Reskin_CustomizeTooltip(CharCustomizeTooltip)
	Reskin_CustomizeTooltip(CharCustomizeNoHeaderTooltip)
end

C.OnLoadThemes["Blizzard_CharacterCustomize"] = function()
	local frame = CharCustomizeFrame

	Reskin_CustomizeButton(frame.SmallButtons.ResetCameraButton)
	Reskin_CustomizeButton(frame.SmallButtons.ZoomOutButton)
	Reskin_CustomizeButton(frame.SmallButtons.ZoomInButton)
	Reskin_CustomizeButton(frame.SmallButtons.RotateLeftButton)
	Reskin_CustomizeButton(frame.SmallButtons.RotateRightButton)

	hooksecurefunc(frame, "SetSelectedCatgory", Reskin_CharCustomizeFrame)
end