local _
local GetNamePlateForUnit , GetNamePlates = C_NamePlate.GetNamePlateForUnit, C_NamePlate.GetNamePlates
local UnitName, GetUnitName = UnitName, GetUnitName
FilteredNamePlate = {}
FilteredNamePlate.UITypeCheckList = {
	[0] = false,
	[1] = false,
	[2] = false,
	[3] = false,
	[4] = false,
	[5] = false,
	[6] = false,
	[7] = false,
	[8] = false,
}

FilteredNamePlate.UITypeList = {
	[0] = FNP_LOCALE_TEXT.FNP_ORIG_TITLE,
	[1] = FNP_LOCALE_TEXT.FNP_ORIG_TITLE2,
	[2] = "TidyPlates",
	[3] = "Kui_NamePlates",
	[4] = "EUI/RayUI",
	[5] = "NDUI",
	[6] = FNP_LOCALE_TEXT.FNP_EKNUM_TITLE,
	[7] = "ShestackUI",
	[8] = "CblUI",
}

FilteredNamePlate.curScaleList = {}

-- UIType  -> curNpFlag  curNpFlag1Type
-- 原生0,1		   0	UnitFrame
-- TidyPlates 简单2  1	carrier
-- KUI        简单3  1	kui
-- EUI/RayUI  简单4  1	UnitFrame
-- NDUI	      简单5  1    unitFrame
-- EKNum 6	    	2	 UnitFrame
-- she7		        3	 UnitFrame
-- CBL 8		    4	 UnitFrame
function FilteredNamePlate:GenCurNpFlags()
	local curNpFlag = 0 -- 上述UIType的下标
	if Fnp_OtherNPFlag == 0 or Fnp_OtherNPFlag == 1 then
		curNpFlag = 0
	elseif Fnp_OtherNPFlag == 6 then
		curNpFlag = 2
	elseif Fnp_OtherNPFlag == 7 then
		curNpFlag = 3
	elseif Fnp_OtherNPFlag == 8 then
		curNpFlag = 4
	else -- 最简模型
		curNpFlag = 1
	end
	local curNpFlag1Type = "UnitFrame" --针对最简单模型的frameName
	if Fnp_OtherNPFlag == 2 then
		curNpFlag1Type = "carrier"
	elseif Fnp_OtherNPFlag == 3 then
		curNpFlag1Type = "kui"
	elseif Fnp_OtherNPFlag == 4 or Fnp_OtherNPFlag == 8 then
		curNpFlag1Type = "UnitFrame"
	elseif Fnp_OtherNPFlag == 5 then
		curNpFlag1Type = "unitFrame"
	end
	return curNpFlag, curNpFlag1Type
end

function FilteredNamePlate:ChangedSavedScaleList(flag)
     Fnp_SavedScaleList.only = 1.4
     Fnp_SavedScaleList.small = 0.25
     --配置不同UI下 small的默认比例
     if flag == 7 then
        Fnp_SavedScaleList.small = 0.5
        Fnp_SavedScaleList.only = 1.2
     elseif flag == 8 then
		Fnp_SavedScaleList.small = 0.2
		Fnp_SavedScaleList.only = 1.35
 	 end
end

function FilteredNamePlate:reinitScaleValues(curNpFlag, isScaleInited)
	if isScaleInited == false then return end
	local SPELL_SCALE = 0.5
	if curNpFlag == 1 then
		FilteredNamePlate.curScaleList.normal = FilteredNamePlate.curScaleList.SYSTEM * Fnp_SavedScaleList.normal
		FilteredNamePlate.curScaleList.small = FilteredNamePlate.curScaleList.normal * Fnp_SavedScaleList.small
		FilteredNamePlate.curScaleList.middle = FilteredNamePlate.curScaleList.normal * SPELL_SCALE
		FilteredNamePlate.curScaleList.only = FilteredNamePlate.curScaleList.SYSTEM * Fnp_SavedScaleList.only
	elseif curNpFlag == 0 then
		FilteredNamePlate.curScaleList.name.normal = FilteredNamePlate.curScaleList.name.SYSTEM
		FilteredNamePlate.curScaleList.name.small = FilteredNamePlate.curScaleList.name.normal * Fnp_SavedScaleList.small
		FilteredNamePlate.curScaleList.name.middle = FilteredNamePlate.curScaleList.name.small
		if FilteredNamePlate.curScaleList.name.small < 30 then
			FilteredNamePlate.curScaleList.name.small = 30
			FilteredNamePlate.curScaleList.name.middle = 30
		end
		FilteredNamePlate.curScaleList.bars.heal_normalHeight = FilteredNamePlate.curScaleList.bars.HEAL_SYS_HEIGHT * Fnp_SavedScaleList.normal;
		FilteredNamePlate.curScaleList.bars.heal_onlyHeight = FilteredNamePlate.curScaleList.bars.HEAL_SYS_HEIGHT * Fnp_SavedScaleList.only;
		FilteredNamePlate.curScaleList.bars.cast_midHeight = FilteredNamePlate.curScaleList.bars.CAST_SYS_HEIGHT * SPELL_SCALE;
	elseif curNpFlag == 2 then
		FilteredNamePlate.curScaleList.normal_perc_font = FilteredNamePlate.curScaleList.PERC_FONT * Fnp_SavedScaleList.normal
		FilteredNamePlate.curScaleList.only_perc_font = FilteredNamePlate.curScaleList.PERC_FONT * Fnp_SavedScaleList.only
		FilteredNamePlate.curScaleList.mid_perc_font = FilteredNamePlate.curScaleList.normal_perc_font * SPELL_SCALE
		FilteredNamePlate.curScaleList.small_perc_font = FilteredNamePlate.curScaleList.normal_perc_font * Fnp_SavedScaleList.small
	elseif curNpFlag == 3 then
		FilteredNamePlate.curScaleList.normal_name_font = FilteredNamePlate.curScaleList.NAME_FONT * Fnp_SavedScaleList.normal
		FilteredNamePlate.curScaleList.only_name_font = FilteredNamePlate.curScaleList.NAME_FONT * Fnp_SavedScaleList.only
		FilteredNamePlate.curScaleList.mid_name_font = FilteredNamePlate.curScaleList.normal_name_font * SPELL_SCALE
		FilteredNamePlate.curScaleList.small_name_font = FilteredNamePlate.curScaleList.normal_name_font * Fnp_SavedScaleList.small
	elseif curNpFlag == 4 then
		FilteredNamePlate.curScaleList.nor_scale = FilteredNamePlate.curScaleList.SYS_SCALE * Fnp_SavedScaleList.normal
		FilteredNamePlate.curScaleList.only_scale = FilteredNamePlate.curScaleList.SYS_SCALE * Fnp_SavedScaleList.only
		FilteredNamePlate.curScaleList.mid_scale = FilteredNamePlate.curScaleList.nor_scale * SPELL_SCALE
		FilteredNamePlate.curScaleList.small_scale = FilteredNamePlate.curScaleList.nor_scale * Fnp_SavedScaleList.small
	end
end

-- 返回值true代表已经获取了系统血条的真正大小，false表示UITYPE出错
function FilteredNamePlate:initScaleValues(curNpFlag)
	local isScaleInited = false
	for _, frame in pairs(GetNamePlates()) do
		local foundUnit = frame.namePlateUnitToken or (frame.UnitFrame and frame.UnitFrame.unit)
		local sys = 0
		if foundUnit then
			if curNpFlag == 0 then --Orig模型 调节名字宽度，调节血条高度，施法条高度
				FilteredNamePlate.curScaleList = {
					name = {
						SYSTEM = 130,
						normal = 130,
						small = 40,
						middle = 40,
					},
					bars = {
						HEAL_SYS_HEIGHT = 10.8,
						heal_normalHeight = 10.8,
						heal_onlyHeight = 15.0,
						CAST_SYS_HEIGHT = 10.8,
						cast_midHeight = 5.4
					}
				}
				if frame.UnitFrame then
					sys = 1
					FilteredNamePlate.curScaleList.name.SYSTEM = frame.UnitFrame:GetWidth()
					if frame.UnitFrame.healthBar then
						FilteredNamePlate.curScaleList.bars.HEAL_SYS_HEIGHT = frame.UnitFrame.healthBar:GetHeight()
					end
					if frame.UnitFrame.castBar then
						FilteredNamePlate.curScaleList.bars.CAST_SYS_HEIGHT = frame.UnitFrame.castBar:GetHeight()
					end
				end
			elseif curNpFlag == 2 then -- ek number 模型 调节名字宽度和高度，调节血量字体大小
				FilteredNamePlate.curScaleList = {
					SYSTEMW = 130,
					SMALLW = 40,
					SYSTEMH = 100,
					SMALLH = 20,

					PERC_FONT = 18,
					normal_perc_font = 18,
					only_perc_font = 10,
					mid_perc_font = 15,
					small_perc_font = 8,
				}
				if frame.UnitFrame then
					sys = 1
					FilteredNamePlate.curScaleList.SYSTEMW = frame.UnitFrame.name:GetWidth()
					FilteredNamePlate.curScaleList.SYSTEMH = frame.UnitFrame.name:GetHeight()
					if frame.UnitFrame.healthperc then
						local face,size,flag = frame.UnitFrame.healthperc:GetFont()
						FilteredNamePlate.curScaleList.fontFace = face
						FilteredNamePlate.curScaleList.fontFlag = flag
						FilteredNamePlate.curScaleList.PERC_FONT = size
					end
				end
			elseif curNpFlag == 4 then -- CblUI
				FilteredNamePlate.curScaleList = {
					NAME_SYSTEMW = 140,
					NAME_SMALLW = 40,

					SYS_SCALE = 1.0,
					nor_scale = 1.0,
					only_scale = 1.3,
					mid_scale = 0.5,
					small_scale = 0.2,
				}
				if frame.UnitFrame then
					sys = 1
					FilteredNamePlate.curScaleList.NAME_SYSTEMW = frame.UnitFrame.name:GetWidth()
					if frame.UnitFrame.healthBar then
						FilteredNamePlate.curScaleList.SYS_SCALE = frame.UnitFrame.healthBar:GetEffectiveScale()
					end
				end
			else -- 1 纯条模型 最简单啦 直接调节整体frame scale
				sys = 1
				FilteredNamePlate.curScaleList = {
					SYSTEM = 0.78,
					normal = 1.0,
					small = 0.20,
					middle = 0.5,
					only = 1.45,
				}
				if frame[curNpFlag1Type] then
					FilteredNamePlate.curScaleList.SYSTEM = frame[curNpFlag1Type]:GetEffectiveScale()
				end
			end
		elseif (frame and frame.ouf) then --sheStack 整体frame都不标准 /(ㄒoㄒ)/~~
			if curNpFlag == 3 then -- shestack 模型 调节名字字体大小，血条和施法条也不调节了，直接用hide处理
				FilteredNamePlate.curScaleList = {
					NAME_FONT = 18,
					normal_name_font = 18,
					only_name_font = 10,
					mid_name_font = 15,
					small_name_font = 8,
				}

				sys = 1
				if frame.ouf.Name then
					local face,size,flag = frame.ouf.Name:GetFont()
					FilteredNamePlate.curScaleList.NAME_FONT = size
					FilteredNamePlate.curScaleList.fontFace = face
					FilteredNamePlate.curScaleList.fontFlag = flag
				end
			end
		end
		if sys > 0.01 then -- it's a real info
			FilteredNamePlate:reinitScaleValues(curNpFlag, true)
			isScaleInited = true
			break
		end
	end
	return isScaleInited
end

