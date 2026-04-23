local cruiseActive = false
local vehicleClasses = {
    [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, 
    [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, 
    [10] = true, [11] = true, [12] = true, [13] = false, [14] = false, 
    [15] = false, [16] = false, [17] = true, [18] = true, [19] = true, 
    [20] = true, [21] = false
}


local function triggerCruiseControl()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    
    if not veh or veh == 0 or GetPedInVehicleSeat(veh, -1) ~= ped then return end
    if not vehicleClasses[GetVehicleClass(veh)] then return end
    if cruiseActive then 
        cruiseActive = false
        return 
    end

    local currentSpeed = GetEntitySpeed(veh)
    if currentSpeed <= 3.0 or GetVehicleCurrentGear(veh) <= 0 then return end

    local fuel = 100
    if GetResourceState('tmg-fuel') == 'started' then
        fuel = exports['tmg-fuel']:GetFuel(veh)
    elseif GetResourceState('LegacyFuel') == 'started' then
        fuel = exports['LegacyFuel']:GetFuel(veh)
    end

    if fuel <= 10 then
        TMGCore.Functions.Notify(Lang:t('cruise.not_Enough_Fuel'), 'error')
        return
    end

    cruiseActive = true
    TMGCore.Functions.Notify(Lang:t('cruise.activated'))
    TriggerEvent('seatbelt:client:ToggleCruise', true)

    CreateThread(function()
        while cruiseActive do
            Wait(0)
            local currentVeh = GetVehiclePedIsIn(ped, false)
            
            if not currentVeh or currentVeh == 0 or GetPedInVehicleSeat(currentVeh, -1) ~= ped or not cruiseActive then
                cruiseActive = false
                break
            end

            SetEntityMaxSpeed(currentVeh, currentSpeed)

            if IsControlJustPressed(0, 72) or IsControlJustPressed(0, 76) then
                cruiseActive = false
            end

            if GetEntitySpeed(currentVeh) < (currentSpeed - 2.0) then
                cruiseActive = false
            end
        end

        local finalVeh = GetVehiclePedIsIn(ped, false)
        if finalVeh ~= 0 then
            SetEntityMaxSpeed(finalVeh, GetVehicleHandlingFloat(finalVeh, "CHandlingData", "fInitialDriveMaxFlatVel"))
        end
        TriggerEvent('seatbelt:client:ToggleCruise', false)
        TMGCore.Functions.Notify(Lang:t('cruise.deactivated'), 'error')
    end)
end


RegisterCommand('togglecruise', function()
    triggerCruiseControl()
end, false)

RegisterKeyMapping('togglecruise', 'Toggle Cruise Control', 'keyboard', 'Y')
