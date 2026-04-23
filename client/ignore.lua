
CreateThread(function()
    if Config.Disable.ambience then
        StartAudioScene('CHARACTER_CHANGE_IN_SKY_SCENE')
        SetAudioFlag('DisableFlightMusic', true)
    end
    SetAudioFlag('PoliceScannerDisabled', true)
    DistantCopCarSirens(false)

    SetGarbageTrucks(false)
    SetCreateRandomCops(false)
    SetCreateRandomCopsNotOnScenarios(false)
    SetCreateRandomCopsOnScenarios(false)
    
    local zones = {
        {coords = vec3(335.26, -1432.45, 46.51), range = 300.0},  
        {coords = vec3(441.84, -987.99, 30.68), range = 500.0},   
        {coords = vec3(316.79, -592.36, 43.28), range = 300.0},   
        {coords = vec3(-2150.44, 3075.99, 32.8), range = 500.0},  
        {coords = vec3(-1108.35, 4920.64, 217.2), range = 300.0}, 
        {coords = vec3(-458.24, 6019.81, 31.34), range = 300.0},  
        {coords = vec3(1854.82, 3679.4, 33.82), range = 300.0},   
        {coords = vec3(-724.46, -1444.03, 5.0), range = 300.0},   
    }
    for _, zone in ipairs(zones) do
        RemoveVehiclesFromGeneratorsInArea(
            zone.coords.x - zone.range, zone.coords.y - zone.range, zone.coords.z - zone.range, 
            zone.coords.x + zone.range, zone.coords.y + zone.range, zone.coords.z + zone.range
        )
    end

    for _, sctyp in ipairs(Config.BlacklistedScenarios.types) do SetScenarioTypeEnabled(sctyp, false) end
    for _, scgrp in ipairs(Config.BlacklistedScenarios.groups) do SetScenarioGroupEnabled(scgrp, false) end
    
    for i = 1, 15 do EnableDispatchService(i, Config.AIResponse.dispatchServices[i] or false) end
    SetMaxWantedLevel(Config.AIResponse.wantedLevels and 5 or 0)
    
    AddTextEntry('FE_THDR_GTAO', (Config.PauseMapText ~= '' and Config.PauseMapText) or 'TMG Mainframe')
    
    if Config.Disable.driveby then SetPlayerCanDoDriveBy(PlayerId(), false) end
end)

AddEventHandler('populationPedCreating', function(x, y, z)
    Wait(500) 
    local _, handle = GetClosestPed(x, y, z, 1.0)
    if DoesEntityExist(handle) then
        SetPedDropsWeaponsWhenDead(handle, false)
    end
end)


CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local sleep = 1000 

        if IsPedArmed(ped, 6) then
            sleep = 0
            
            if Config.Disable.pistolWhipping then
                DisableControlAction(0, 140, true) 
                DisableControlAction(0, 141, true) 
                DisableControlAction(0, 142, true) 
            end

            local weapon = GetSelectedPedWeapon(ped)
            if weapon == `WEAPON_FIREEXTINGUISHER` or weapon == `WEAPON_PETROLCAN` then
                if IsPedShooting(ped) then SetPedInfiniteAmmo(ped, true, weapon) end
            end

            if Config.BlacklistedWeapons[weapon] then
                RemoveWeaponFromPed(ped, weapon)
                TMGCore.Functions.Notify("This weapon is blacklisted.", "error")
            end
        end

        if IsPedBeingStunned(ped, 0) then
            sleep = 0
            SetPedMinGroundTimeForStungun(ped, math.random(4000, 7000))
        end
        if Config.Disable.idleCamera then
            InvalidateIdleCam()
            InvalidateVehicleIdleCam()
        end

        Wait(sleep)
    end
end)

RegisterNetEvent('TMGCore:Client:EnteredVehicle', function(data)
    if Config.Disable.carRadio then
        
        SetVehRadioStation(data.vehicle, 'OFF')
    end
end)
