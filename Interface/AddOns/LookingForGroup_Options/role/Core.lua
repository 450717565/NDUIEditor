local LookingForGroup_Options = LibStub("AceAddon-3.0"):GetAddon("LookingForGroup_Options")
local GetLFGRoles = GetLFGRoles
local C_LFGList_GetSearchResultMemberCounts = C_LFGList.GetSearchResultMemberCounts
local math_ceil = math.ceil

function LookingForGroup_Options.FilterRole(id,members,categoryID)
	local _,t,h,d = GetLFGRoles()
	local tb = C_LFGList_GetSearchResultMemberCounts(id)
	local tank = tb.TANK
	local healer = tb.HEALER
	local damager = tb.NOROLE + tb.DAMAGER
	if categoryID == 1 or categoryID == 4 then
		if not (d or (h and healer == 0) or (t and tank == 0)) then
			return true
		end
	elseif categoryID == 2 then
		if not ((d and (damager < 4)) or (h and healer == 0) or (t and tank == 0)) then
			return true
		end
	elseif categoryID == 3 then
		local nm = 15
		if nm < members then
			nm = members
		end
		local maxhealer = math_ceil(nm/5)
		local maxmembers = maxhealer * 5
		if not ((d and damager + 1 < maxmembers) or (h and healer < maxhealer) or (t and tank < 2)) then
			return true
		end
	elseif categoryID == 9 then
		if not ((d and damager < 7) or (h and healer < 3) or (t and tank == 0)) then
			return true
		end
	end
end
