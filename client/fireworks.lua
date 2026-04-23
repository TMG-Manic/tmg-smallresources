
local fireworkTime = 0
local fireworkLoc = nil
local fireworkList = {
    ['proj_xmas_firework'] = {
        'scr_firework_xmas_ring_burst_rgw',
        'scr_firework_xmas_burst_rgw',
        'scr_firework_xmas_repeat_burst_rgw',
        'scr_firework_xmas_spiral_burst_rgw',
        'scr_xmas_firework_sparkle_spawn'
    },
    ['scr_indep_fireworks'] = {
        'scr_indep_firework_sparkle_spawn',
        'scr_indep_firework_starburst',
        'scr_indep_firework_shotburst',
        'scr_indep_firework_trailburst',
        'scr_indep_firework_trailburst_spawn',
        'scr_indep_firework_burst_spawn',
        'scr_indep_firework_trail_spawn',
        'scr_indep_firework_fountain'
    },
    ['proj_indep_firework'] = {
        'scr_indep_firework_grd_burst',
        'scr_indep_launcher_sparkle_spawn',
        'scr_indep_firework_air_burst',
        'proj_indep_flare_trail'
    },
    ['proj_indep_firework_v2'] = {
        'scr_firework_indep_burst_rwb',
        'scr_firework_indep_spiral_burst_rwb',
        'scr_xmas_firework_sparkle_spawn',
        'scr_firework_indep_ring_burst_rwb',
        'scr_xmas_firework_burst_fizzle',
        'scr_firework_indep_repeat_burst_rwb'
    }
}

local function LoadParticleAsset(asset)
    if HasNamedPtfxAssetLoaded(asset) then return true end
    RequestNamedPtfxAsset(asset)
    local timeout = 0
    while not HasNamedPtfxAssetLoaded(asset) and timeout < 150 do
        Wait(10); timeout = timeout + 1
    end
    return HasNamedPtfxAssetLoaded(asset)
end

local function startFirework(asset, coords)
    local time = Config.Fireworks.delay or 5
    local location = vector3(coords.x, coords.y, coords.z)

    CreateThread(function()
        while time > 0 do
            local playerCoords = GetEntityCoords(PlayerPedId())
            if #(playerCoords - location) < 20.0 then
                exports['tmg-core']:DrawText(Lang:t('firework.time_left') .. ' ' .. time, 'left')
            else
                exports['tmg-core']:HideText()
            end
            Wait(1000)
            time -= 1
        end
        
        exports['tmg-core']:HideText()

        if LoadParticleAsset(asset) then
            UseParticleFxAssetNextCall(asset)
            
            for i = 1, math.random(5, 10) do
                local fireworkEffect = fireworkList[asset][math.random(1, #fireworkList[asset])]
                
                UseParticleFxAssetNextCall(asset)
                StartNetworkedParticleFxNonLoopedAtCoord(
                    fireworkEffect, 
                    location.x, location.y, location.z + 42.5, 
                    0.0, 0.0, 0.0, 
                    math.random() * 0.3 + 0.5, 
                    false, false, false
                )
                
                Wait(math.random(250, 700))
            end
            
            RemoveNamedPtfxAsset(asset)
        end
    end)
end

CreateThread(function()
    local assets = {
        'scr_indep_fireworks',
        'proj_xmas_firework',
        'proj_indep_firework_v2',
        'proj_indep_firework'
    }

    for i = 1, #assets do
        local asset = assets[i]
        if not HasNamedPtfxAssetLoaded(asset) then
            RequestNamedPtfxAsset(asset)
            while not HasNamedPtfxAssetLoaded(asset) do
                Wait(10)
            end
        end
    end
end)

RegisterNetEvent('fireworks:client:UseFirework', function(itemName, assetName)
    if isProcessing then return end 
    isProcessing = true

    TMGCore.Functions.Progressbar('place_firework', Lang:t('firework.place_progress'), 3000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'anim@narcotics@trash',
        anim = 'drop_front',
        flags = 16,
    }, {}, {}, function() 
        isProcessing = false
        StopAnimTask(PlayerPedId(), 'anim@narcotics@trash', 'drop_front', 1.0)
        
        TriggerServerEvent('consumables:server:UseFirework', itemName)
        TriggerEvent('inventory:client:ItemBox', TMGCore.Shared.Items[itemName], 'remove')
        
        startFirework(assetName, GetEntityCoords(PlayerPedId()))
    end, function() 
        isProcessing = false
        StopAnimTask(PlayerPedId(), 'anim@narcotics@trash', 'drop_front', 1.0)
    end)
end)
