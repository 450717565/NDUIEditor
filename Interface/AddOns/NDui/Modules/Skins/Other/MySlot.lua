local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

function Skins:Myslot()
	if not IsAddOnLoaded("Myslot") then return end

	local Myslot = LibStub("Myslot-5.0", true)
	if not Myslot then return end

	local MainFrame = Myslot.MainFrame
	B.ReskinFrame(MainFrame)

	local children = {MainFrame:GetChildren()}
	for _, child in pairs(children) do
		if child:IsObjectType("Button") and child.Text then
			B.ReskinButton(child)
		elseif child:IsObjectType("CheckButton") then
			B.ReskinCheck(child)
		elseif child:IsObjectType("Frame") then
			if floor(child:GetWidth() - 600) == 0 and floor(child:GetHeight() - 400) == 0 then
				child:SetBackdrop(nil)
				B.CreateBDFrame(child)

				local subChildren = {child:GetChildren()}
				for _, subChild in pairs(subChildren) do
					if subChild:IsObjectType("ScrollFrame")then
						B.ReskinScroll(subChild.ScrollBar)

						break
					end
				end
			elseif child.initialize and child.Icon and child.Button then
				B.ReskinDropDown(child)
			end
		end
	end
end