local isPushing = false

local function loadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return end
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(10) end
end


RegisterNetEvent('vehiclepush:client:push', function(veh)
    if isPushing or not veh then return end
    
    local ped = PlayerPedId()
    
    local timeout = 0
    NetworkRequestControlOfEntity(veh)
    while not NetworkHasControlOfEntity(veh) and timeout < 50 do
        Wait(10)
        timeout = timeout + 1
    end

    if not NetworkHasControlOfEntity(veh) then
        TMGCore.Functions.Notify("Cannot gain control of vehicle physics.", "error")
        return
    end

    local dimension = GetModelDimensions(GetEntityModel(veh))
    local pos = GetEntityCoords(ped)
    local vehPos = GetEntityCoords(veh)
    local isInFront = #(vehPos + GetEntityForwardVector(veh) - pos) < #(vehPos + GetEntityForwardVector(veh) * -1 - pos)

    isPushing = true
    
    AttachEntityToEntity(ped, veh, GetPedBoneIndex(ped, 6286), 0.0, isInFront and (dimension.y * -1 + 0.1) or (dimension.y - 0.3), dimension.z + 1.0, 0.0, 0.0, isInFront and 180.0 or 0.0, false, false, false, true, 0, true)
    
    loadAnimDict('missfinale_c2ig_11')
    TaskPlayAnim(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, false, false, false)
    
    exports['tmg-core']:DrawText(Lang:t('pushcar.stop_push'), 'left')

    CreateThread(function()
        while isPushing do
            Wait(0)
            
            if not DoesEntityExist(veh) or IsEntityDead(ped) or IsPedInAnyVehicle(ped, true) then
                isPushing = false
                break
            end

            if IsDisabledControlPressed(0, 34) then 
                TaskVehicleTempAction(ped, veh, 11, 100)
            elseif IsDisabledControlPressed(0, 9) then 
                TaskVehicleTempAction(ped, veh, 10, 100)
            end

            local forwardSpeed = isInFront and -2.0 or 2.0
            SetVehicleForwardSpeed(veh, forwardSpeed)

            if IsControlJustPressed(0, 38) then 
                isPushing = false
            end
        end

        exports['tmg-core']:HideText()
        DetachEntity(ped, false, false)
        StopAnimTask(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0)
        isPushing = false
    end)
end)
