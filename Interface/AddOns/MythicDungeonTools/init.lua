local AddonName, MDT = ...
_G["MDT"] = MDT
MDT.L = {}

local lib = LibStub:GetLibrary("LibUIDropDownMenu-4.0")
function L_Create_UIDropDownMenu(name, parent)
	return lib:Create_UIDropDownMenu(name, parent)
end