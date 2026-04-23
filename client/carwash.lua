local washingVeh = false
local listen = false


local function canWashVehicle(ped, veh)
    if not veh or veh == 0 then return false end
    local driver = GetPedInVehicleSeat(veh, -1)
    if driver ~= ped then return false end
    if washingVeh then return false end

    local dirtLevel = GetVehicleDirtLevel(veh)
    if dirtLevel <= (Config.CarWash.dirtLevel or 1.0) then
        TMGCore.Functions.Notify(Lang:t('wash.dirty'), 'error')
        return false
    end
    return true
end


local function washLoop()
    CreateThread(function()
        while listen do
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)
            if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped then
                if IsControlJustPressed(0, 38) then 
                    if canWashVehicle(ped, veh) then
                        TriggerServerEvent('qb-carwash:server:washCar')
                        listen = false
                        break
                    end
                end
                Wait(0)
            else
                Wait(500) 
            end
        end
    end)
end


RegisterNetEvent('qb-carwash:client:washCar', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh == 0 then return end

    washingVeh = true
    TMGCore.Functions.Progressbar('car_wash_process', Lang:t('wash.in_progress'), math.random(4000, 8000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() 
        if DoesEntityExist(veh) then
            SetVehicleDirtLevel(veh, 0.0)
            SetVehicleUndriveable(veh, false)
            WashDecalsFromVehicle(veh, 1.0)
        end
        washingVeh = false
    end, function() 
        washingVeh = false
    end)
end)


CreateThread(function()
    for k, v in pairs(Config.CarWash.locations) do
        
        local carWash = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
        SetBlipSprite(carWash, 100)
        SetBlipDisplay(carWash, 4)
        SetBlipScale(carWash, 0.75)
        SetBlipAsShortRange(carWash, true)
        SetBlipColour(carWash, 37)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Hands Free Carwash')
        EndTextCommandSetBlipName(carWash)

        
        if Config.UseTarget then
            exports["qb-target"]:AddBoxZone('carwash_'..k, v.coords, v.length, v.width, {
                name = 'carwash_'..k,
                heading = v.heading,
                debugPoly = false,
                minZ = v.coords.z - 2,
                maxZ = v.coords.z + 3,
            }, {
                options = {
                    {
                        icon = "fa-car-wash",
                        label = Lang:t('wash.wash_vehicle_target'),
                        action = function()
                            local ped = PlayerPedId()
                            local veh = GetVehiclePedIsIn(ped, false)
                            if canWashVehicle(ped, veh) then
                                TriggerServerEvent('qb-carwash:server:washCar')
                            end
                        end,
                        canInteract = function() return IsPedInAnyVehicle(PlayerPedId(), false) end,
                    }
                },
                distance = 3.5
            })
        else
            local zone = BoxZone:Create(v.coords, v.length, v.width, {
                name = 'carwash_'..k,
                heading = v.heading,
                debugPoly = false,
                minZ = v.coords.z - 2,
                maxZ = v.coords.z + 3,
            })
            zone:onPlayerInOut(function(isInside)
                if isInside and IsPedInAnyVehicle(PlayerPedId(), false) then
                    exports['qb-core']:DrawText(Lang:t('wash.wash_vehicle'), 'left')
                    if not listen then listen = true; washLoop() end
                else
                    listen = false
                    exports['qb-core']:HideText()
                end
            end)
        end
    end
end)
