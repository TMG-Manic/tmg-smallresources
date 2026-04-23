local function toTitleCase(str)
    return (str:gsub("(%a)([%w_']*)", function(first, rest)
        return first:upper() .. rest:lower()
    end))
end


CreateThread(function()
    while not TMGCore or not TMGCore.Shared or not TMGCore.Shared.Vehicles do 
        Wait(500) 
    end

    local count = 0
    for _, v in pairs(TMGCore.Shared.Vehicles) do
        if v.name and v.hash and v.hash ~= 0 then
            local finalLabel = ""
            local name = v.name
            local brand = v.brand or ""

            if brand ~= "" and string.find(string.lower(name), string.lower(brand)) then
                finalLabel = name
            elseif brand ~= "" then
                finalLabel = brand .. " " .. name
            else
                finalLabel = name
            end

            AddTextEntryByHash(v.hash, toTitleCase(finalLabel))
            count = count + 1
        end
    end
    
    print(string.format("[Labels] Successfully injected %s vehicle display names.", count))
end)