
AddEventHandler("entityCreating", function(handle)
    local entityType = GetEntityType(handle)
    
    if entityType == 3 then return end 

    local entityModel = GetEntityModel(handle)
    local owner = NetworkGetEntityOwner(handle)

    if entityType == 2 and Config.BlacklistedVehs[entityModel] then
        CancelEvent()
        print(string.format("^1[TMG Security]^7 Filtration Pulse: Blocked VEHICLE hash [%s] from terminal [%s]", 
            entityModel, (owner ~= -1 and owner or "System/Script")))
        return
    end

    if entityType == 1 and Config.BlacklistedPeds[entityModel] then
        CancelEvent()
        print(string.format("^1[TMG Security]^7 Filtration Pulse: Blocked PED hash [%s] from terminal [%s]", 
            entityModel, (owner ~= -1 and owner or "System/Script")))
        return
    end
end)
