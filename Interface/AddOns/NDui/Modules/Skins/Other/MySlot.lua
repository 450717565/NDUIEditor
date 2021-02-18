local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

function Skins:Myslot()
	if not IsAddOnLoaded("Myslot") then return end

	local Myslot = LibStub("Myslot-5.0", true)
	if not Myslot then return end

	local MainFrame = Myslot.MainFrame
	B.ReskinFrame(MainFrame)

	for _, child in pairs {MainFrame:GetChildren()} do
		local objType = child:GetObjectType()
		if objType == "Button" and child.Text then
			B.ReskinButton(child)
		elseif objType == "CheckButton" then
			B.ReskinCheck(child)
		elseif objType == "Frame" then
			if floor(child:GetWidth() - 600) == 0 and floor(child:GetHeight() - 400) == 0 then
				child:SetBackdrop(nil)

				local bg = B.CreateBDFrame(child)
				bg:SetInside()

				for _, subChild in pairs {child:GetChildren()} do
					if subChild:GetObjectType() == "ScrollFrame" then
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