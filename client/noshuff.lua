local disableShuffle = true

RegisterNetEvent('TMGCore:Client:EnteredVehicle', function(data)
    local ped = PlayerPedId()
    local vehicle = data.vehicle
    
    SetPedConfigFlag(ped, 184, true)
    
    if SetPedConfigFlag then
        SetPedConfigFlag(ped, 429, true)
    end
end)

RegisterNetEvent('TMGCore:Client:LeftVehicle', function()
    local ped = PlayerPedId()
    SetPedConfigFlag(ped, 184, false)
    if SetPedConfigFlag then
        SetPedConfigFlag(ped, 429, false)
    end
end)


RegisterNetEvent('SeatShuffle', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) == ped then
        SetPedConfigFlag(ped, 184, false)
        
        TaskShuffleToNextSeat(ped, vehicle)
        
        SetTimeout(3000, function()
            if IsPedInAnyVehicle(ped, false) then
                SetPedConfigFlag(ped, 184, true)
            end
        end)
    end
end)

RegisterCommand('shuff', function()
    TriggerEvent('SeatShuffle')
end, false)
