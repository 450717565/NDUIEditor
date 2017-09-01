function FilteredNamePlate.printTable(table , level, key)
  level = level or 1
  local indent = ""
  for i = 1, level do
    indent = indent.."  "
  end
  if key and key ~= "" then
    print(indent..key.." ".."=".." ".."{")
  else
    print(indent .. "{")
  end

  key = ""
  for k,v in pairs(table) do
     if type(v) == "table" then
        key = k
		print("key>>"..key)
        -- FilteredNamePlate.printTable(v, level + 1, key)
     else
        local content = string.format("%s%s = %s", indent .. "  ",tostring(k), tostring(v))
      print(content)
      end
  end
  print(indent .. "}")
end

function FilteredNamePlate.insertATabValue(tab, value)
    local isExist = false;
    for pos, name in ipairs(tab) do
        if (name == value) then
            isExist = true;
        end
    end
    if not isExist then table.insert(tab, value) end;
end

function FilteredNamePlate.removeATabValue(tab, value)
    for pos, name in ipairs(tab) do
        if (name == value) then
            table.remove(tab, pos)
        end
    end
end
