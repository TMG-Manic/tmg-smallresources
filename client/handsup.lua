local handsUp = false

CreateThread(function()
    RequestAnimDict('missminuteman_1ig_2')
end)


RegisterCommand(Config.HandsUp.command, function()
    local ped = PlayerPedId()
    
    if IsPedInAnyVehicle(ped, false) or IsEntityDead(ped) or exports['tmg-policejob']:IsHandcuffed() then 
        handsUp = false 
        return 
    end

    if not HasAnimDictLoaded('missminuteman_1ig_2') then
        RequestAnimDict('missminuteman_1ig_2')
        local timeout = 0
        while not HasAnimDictLoaded('missminuteman_1ig_2') and timeout < 100 do
            Wait(10); timeout = timeout + 1
        end
    end

    handsUp = not handsUp

    if handsUp then
        TaskPlayAnim(ped, 'missminuteman_1ig_2', 'handsup_base', 8.0, 8.0, -1, 50, 0, false, false, false)
        
        if Config.HandsUp.disableControls then
            exports['tmg-smallresources']:addDisableControls(Config.HandsUp.controls)
        end
    else
        StopAnimTask(ped, 'missminuteman_1ig_2', 'handsup_base', 3.0)
        
        if Config.HandsUp.disableControls then
            exports['tmg-smallresources']:removeDisableControls(Config.HandsUp.controls)
        end
    end
end, false)

CreateThread(function()
    while true do
        Wait(1000)
        if handsUp then
            local ped = PlayerPedId()
            if exports['tmg-policejob']:IsHandcuffed() or IsEntityDead(ped) or IsPedInAnyVehicle(ped, false) then
                handsUp = false
                StopAnimTask(ped, 'missminuteman_1ig_2', 'handsup_base', 3.0)
            end
        end
    end
end)

RegisterKeyMapping(Config.HandsUp.command, 'Hands Up', 'keyboard', Config.HandsUp.keybind)

exports('getHandsup', function() return handsUp end)
