local _, ns = ...
local B, C, L, DB = unpack(ns)

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local function Reskin_ConduitList(frame)
	local header = frame.CategoryButton.Container
	if header and not header.styled then
		header:DisableDrawLayer("BACKGROUND")
		local bg = B.CreateBDFrame(header)
		bg:SetPoint("TOPLEFT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", 15, 0)

		header.styled = true
	end

	for button in frame.pool:EnumerateActive() do
		if button and not button.styled then
			button.Spec.IconOverlay:Hide()
			B.ReskinIcon(button.Spec.Icon)

			button.styled = true
		end
	end
end

local numChildrenStyled = 0
local function Update_ConduitList(self)
	local numChildren = self.ScrollTarget:GetNumChildren()
	if numChildren > numChildrenStyled then
		for i = 1, numChildren do
			local list = select(i, self.ScrollTarget:GetChildren())
			if list and not list.hooked then
				hooksecurefunc(list, "Layout", Reskin_ConduitList)

				list.hooked = true
			end
		end

		numChildrenStyled = numChildren
	end
end

C.OnLoadThemes["Blizzard_Soulbinds"] = function()
	B.ReskinFrame(SoulbindViewer)
	B.ReskinButton(SoulbindViewer.CommitConduitsButton)
	B.ReskinButton(SoulbindViewer.ActivateSoulbindButton)

	hooksecurefunc(SoulbindViewer.ConduitList.ScrollBox, "Update", Update_ConduitList)
end