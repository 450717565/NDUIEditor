local AddonName, MDT = ...
_G["MDT"] = MDT
MDT.L = {}

local lib = LibStub:GetLibrary("LibUIDropDownMenu-4.0")
function L_EasyMenu(menuList, menuFrame, anchor, x, y, displayMode, autoHideDelay)
	return lib:EasyMenu(menuList, menuFrame, anchor, x, y, displayMode, autoHideDelay)
end

function L_CloseDropDownMenus(level)
	return lib:CloseDropDownMenus(level)
end

function L_Create_UIDropDownMenu(name, parent)
	return lib:Create_UIDropDownMenu(name, parent)
end