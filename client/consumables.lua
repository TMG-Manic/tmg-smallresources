

local alcoholCount = 0
local healing, parachuteEquipped = false, false
local currVest, currVestTexture = nil, nil


RegisterNetEvent('TMGCore:Client:UpdateObject', function()
    TMGCore = exports['tmg-core']:GetCoreObject()
end)


local function loadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return true end
    RequestAnimDict(dict)
    local timeout = 0
    while not HasAnimDictLoaded(dict) do
        Wait(10)
        timeout = timeout + 1
        if timeout > 150 then 
            print("^1[TMG CONSUMABLES] Error:^7 Animation Dict failed to load: " .. tostring(dict))
            return false 
        end
    end

    return true
end

local function equipParachuteAnim()
    local ped = PlayerPedId()
    local dict = 'clothingshirt'
    local anim = 'try_shirt_positive_d'
    if not loadAnimDict(dict) then return false end
    StopAnimTask(ped, dict, anim, 3.0) 
    
    TaskPlayAnim(ped, dict, anim, 8.0, 1.0, 1500, 49, 0, false, false, false)
    
    SetTimeout(1500, function()
        if IsEntityPlayingAnim(ped, dict, anim, 3) then
            StopAnimTask(ped, dict, anim, 3.0)
        end
    end)
    
    return true
end


local function healOxy()
    if healing then return end
    healing = true

    local count = 9
    while count > 0 do
        Wait(1000)
        local ped = PlayerPedId()
        local maxHealth = GetEntityMaxHealth(ped)
        local currentHealth = GetEntityHealth(ped)
        if IsEntityDead(ped) or currentHealth <= 0 then 
            healing = false
            return 
        end
        if currentHealth < maxHealth then
            local newHealth = currentHealth + 6
            if newHealth > maxHealth then newHealth = maxHealth end
            SetEntityHealth(ped, newHealth)
        end
        RestorePlayerStamina(PlayerId(), 1.0)

        count = count - 1
    end
    
    healing = false
end


local effectActive = false

local function trevorEffect()
    if effectActive then return end
    effectActive = true

    StartScreenEffect('DrugsTrevorClownsFightIn', 3000, true)
    Wait(3000)
    if not IsEntityDead(PlayerPedId()) then
        StartScreenEffect('DrugsTrevorClownsFight', 3000, true)
        Wait(3000)
    end
    StartScreenEffect('DrugsTrevorClownsFightOut', 3000, true)
    Wait(3000)

    StopAllScreenEffects() 
    effectActive = false
end
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        StopAllScreenEffects()
    end
end)


local isMethActive = false

local function methBagEffect()
    if isMethActive then return end
    isMethActive = true

    CreateThread(trevorEffect) 

    local player = PlayerId()
    SetRunSprintMultiplierForPlayer(player, 1.25)
    
    local duration = 20 
    CreateThread(function()
        while duration > 0 and isMethActive do
            Wait(1000)
            duration = duration - 1
            
            local ped = PlayerPedId()
            
            if math.random(1, 100) < 30 then
                RestorePlayerStamina(player, 1.0)
            end

            if duration % 5 == 0 and math.random(1, 100) < 50 then
                CreateThread(trevorEffect)
            end
            if IsEntityDead(ped) then break end
        end

        SetRunSprintMultiplierForPlayer(player, 1.0)
        isMethActive = false
    end)
end

local isEcstasyActive = false

local function ecstasyEffect()
    if isEcstasyActive then return end
    isEcstasyActive = true

    local player = PlayerId()
    local duration = 30 

    CreateThread(function()
        SetFlash(0, 0, 500, 7000, 500)

        while duration > 0 and isEcstasyActive do
            local ped = PlayerPedId()
            
            if IsEntityDead(ped) then break end
            if math.random(1, 100) < 50 then
                SetFlash(0, 0, 200, 1000, 200)
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.05)
            end

            RestorePlayerStamina(player, 1.0)
            
            Wait(1000)
            duration = duration - 1
        end

        StopGameplayCamShaking(true) 
        
        local ped = PlayerPedId()
        if not IsEntityDead(ped) and IsPedRunning(ped) then
            TMGCore.Functions.Notify("You've hit the wall... exhaustion sets in.", "error")
            SetPedToRagdoll(ped, 2000, 2000, 0, false, false, false)
        end

        isEcstasyActive = false
    end)
end


local isAlienEffectActive = false

local function alienEffect()
    if isAlienEffectActive then return end
    isAlienEffectActive = true

    StartScreenEffect('DrugsMichaelAliensFightIn', 3000, true)
    
    local tripDuration = math.random(10000, 15000)
    
    CreateThread(function()
        local timeStarted = GetGameTimer()
        
        StartScreenEffect('DrugsMichaelAliensFight', 3000, true)

        while (GetGameTimer() - timeStarted) < tripDuration and isAlienEffectActive do
            Wait(1000)
            if IsEntityDead(PlayerPedId()) then break end
        end

        StartScreenEffect('DrugsMichaelAliensFightOut', 3000, true)
        Wait(3000)

        StopScreenEffect('DrugsMichaelAliensFightIn')
        StopScreenEffect('DrugsMichaelAliensFight')
        StopScreenEffect('DrugsMichaelAliensFightOut')
        StopAllScreenEffects() 
        
        isAlienEffectActive = false
    end)
end



local isCrackActive = false

local function crackBaggyEffect()
    if isCrackActive then return end
    isCrackActive = true

    local player = PlayerId()
    local ped = PlayerPedId()
    
    CreateThread(alienEffect)

    SetRunSprintMultiplierForPlayer(player, 1.3)

    CreateThread(function()
        local duration = 12 
        
        while duration > 0 and isCrackActive do
            Wait(1000)
            duration = duration - 1
            local currentPed = PlayerPedId()

            if math.random(1, 100) < 15 then
                RestorePlayerStamina(player, 1.0)
            end

            if duration > 1 and math.random(1, 100) < 30 then
                if IsPedRunning(currentPed) and not IsPedRagdoll(currentPed) then
                    SetPedToRagdoll(currentPed, math.random(1000, 2000), math.random(1000, 2000), 0, false, false, false)
                end
            end

            if duration % 4 == 0 and math.random(1, 100) < 40 then
                CreateThread(alienEffect)
            end

            if IsEntityDead(currentPed) then break end
        end

        local finalPed = PlayerPedId()
        SetRunSprintMultiplierForPlayer(player, 1.0)
        
        if not IsEntityDead(finalPed) and IsPedRunning(finalPed) then
            SetPedToRagdoll(finalPed, 1500, 1500, 0, false, false, false)
        end
        
        isCrackActive = false
    end)
end


local isCokeActive = false

local function cokeBaggyEffect()
    if isCokeActive then return end
    isCokeActive = true

    local player = PlayerId()
    
    CreateThread(alienEffect)

    SetRunSprintMultiplierForPlayer(player, 1.1)
    CreateThread(function()
        local duration = 20 
        
        while duration > 0 and isCokeActive do
            Wait(1000)
            duration = duration - 1
            local ped = PlayerPedId()

            if math.random(1, 100) < 20 then
                RestorePlayerStamina(player, 1.0)
            end

            if math.random(1, 300) < 10 then
                CreateThread(alienEffect)
            end

            if duration > 1 and math.random(1, 100) < 5 then
                if IsPedRunning(ped) and not IsPedRagdoll(ped) then
                    SetPedToRagdoll(ped, math.random(1000, 2000), math.random(1000, 2000), 0, false, false, false)
                end
            end

            if IsEntityDead(ped) then break end
        end

        SetRunSprintMultiplierForPlayer(player, 1.0)
        isCokeActive = false
    end)
end



local isProcessing = false

RegisterNetEvent('consumables:client:Eat', function(itemName)
    if isProcessing then return end 
    
    local data = Config.Consumables.eat[itemName]
    if not data then return end

    isProcessing = true
    
    local animDict = 'mp_player_inteat@burger'
    loadAnimDict(animDict)

    TMGCore.Functions.Progressbar('eat_something', Lang:t('consumables.eat_progress'), 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true
    }, {
        animDict = animDict,
        anim = 'mp_player_int_eat_burger',
        flags = 49
    }, {
        model = 'prop_cs_burger_01',
        bone = 18905, 
        coords = vec3(0.12, 0.028, 0.001),
        rotation = vec3(10.0, 175.0, 0.0),
    }, {}, function() 
        isProcessing = false
        StopAnimTask(PlayerPedId(), animDict, 'mp_player_int_eat_burger', 1.0)
        
        TriggerEvent('inventory:client:ItemBox', TMGCore.Shared.Items[itemName], 'remove')
        TriggerServerEvent('consumables:server:UseItem', itemName, 'eat')
        TriggerServerEvent('hud:server:RelieveStress', math.random(2, 4))
    end, function() 
        isProcessing = false
        StopAnimTask(PlayerPedId(), animDict, 'mp_player_int_eat_burger', 1.0)
        TMGCore.Functions.Notify(Lang:t('error.canceled'), 'error')
    end)
end)

RegisterNetEvent('consumables:client:Drink', function(itemName)
    if isProcessing then return end
    isProcessing = true
    local animDict = 'mp_player_intdrink'
    loadAnimDict(animDict)

    TMGCore.Functions.Progressbar('drink_something', Lang:t('consumables.drink_progress'), 5000, false, true, {
        disableMovement = false, disableCarMovement = false, disableMouse = false, disableCombat = true
    }, {
        animDict = animDict, anim = 'loop_bottle', flags = 49
    }, {
        model = 'vw_prop_casino_water_bottle_01a', bone = 18905, coords = vec3(0.12, 0.028, 0.001), rotation = vec3(10.0, 175.0, 0.0),
    }, {}, function() 
        isProcessing = false
        StopAnimTask(PlayerPedId(), animDict, 'loop_bottle', 1.0)
        TriggerEvent('inventory:client:ItemBox', TMGCore.Shared.Items[itemName], 'remove')
        TriggerServerEvent('consumables:server:addThirst', TMGCore.Functions.GetPlayerData().metadata.thirst + Config.Consumables.drink[itemName])
    end, function() 
        isProcessing = false
        StopAnimTask(PlayerPedId(), animDict, 'loop_bottle', 1.0)
    end)
end)

local alcoholCount = 0
local isDrunk = false


local function AlcoholLoop()
    if isDrunk then return end 
    isDrunk = true
    
    CreateThread(function()
        while alcoholCount > 0 do
            local ped = PlayerPedId()
            
            
            if alcoholCount >= 4 then
                StartScreenEffect('DrugsMichaelAliensFight', 3000, true)
                ShakeGameplayCam('DRUNK_SHAKE', 1.0)
            elseif alcoholCount >= 1 then
                ShakeGameplayCam('DRUNK_SHAKE', 0.5)
            end
            
            
            Wait(30000) 
            alcoholCount = alcoholCount - 1
            
            if IsEntityDead(ped) then alcoholCount = 0 end 
        end
        
        
        StopAllScreenEffects()
        StopGameplayCamShaking(true)
        SetPedIsDrunk(PlayerPedId(), false)
        isDrunk = false
    end)
end

RegisterNetEvent('consumables:client:DrinkAlcohol', function(itemName)
    if isProcessing then return end
    isProcessing = true
    
    local animDict = 'mp_player_intdrink'
    loadAnimDict(animDict)

    TMGCore.Functions.Progressbar('drink_alcohol', Lang:t('consumables.liqour_progress'), math.random(3000, 6000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true
    }, {
        animDict = animDict,
        anim = 'loop_bottle',
        flags = 49
    }, {
        model = 'prop_cs_beer_bot_40oz',
        bone = 18905, 
        coords = vec3(0.12, 0.028, 0.001),
        rotation = vec3(10.0, 175.0, 0.0),
    }, {}, function() 
        isProcessing = false
        StopAnimTask(PlayerPedId(), animDict, 'loop_bottle', 1.0)
        
        
        TriggerEvent('inventory:client:ItemBox', TMGCore.Shared.Items[itemName], 'remove')
        TriggerServerEvent('consumables:server:drinkAlcohol', itemName)
        TriggerServerEvent('consumables:server:addThirst', TMGCore.Functions.GetPlayerData().metadata.thirst + Config.Consumables.alcohol[itemName])
        TriggerServerEvent('hud:server:RelieveStress', math.random(2, 4))
        
        alcoholCount = alcoholCount + 1
        AlcoholLoop() 
        
        if alcoholCount > 1 and alcoholCount < 4 then
            TriggerEvent('evidence:client:SetStatus', 'alcohol', 200)
        elseif alcoholCount >= 4 then
            TriggerEvent('evidence:client:SetStatus', 'heavyalcohol', 200)
        end
        
        if alcoholCount >= 2 then
            SetPedIsDrunk(PlayerPedId(), true)
        end
    end, function() 
        isProcessing = false
        StopAnimTask(PlayerPedId(), animDict, 'loop_bottle', 1.0)
    end)
end)

RegisterNetEvent('consumables:client:Custom', function(itemName)
    TMGCore.Functions.TriggerCallback('consumables:itemdata', function(data)
        TMGCore.Functions.Progressbar('custom_consumable', data.progress.label, data.progress.time, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true
        }, {
            animDict = data.animation.animDict,
            anim = data.animation.anim,
            flags = data.animation.flags
        }, {
            model = data.prop.model,
            bone = data.prop.bone,
            coords = data.prop.coords,
            rotation = data.prop.rotation
        }, {}, function() 
            ClearPedTasks(PlayerPedId())
            TriggerEvent('tmg-inventory:client:ItemBox', TMGCore.Shared.Items[itemName], 'remove')
            if data.replenish.type then
                TriggerServerEvent('consumables:server:add' .. data.replenish.type, TMGCore.Functions.GetPlayerData().metadata[string.lower(data.replenish.type)] + data.replenish.replenish)
            end
            if data.replenish.isAlcohol then
                alcoholCount += 1
                AlcoholLoop()
                if alcoholCount > 1 and alcoholCount < 4 then
                    TriggerEvent('evidence:client:SetStatus', 'alcohol', 200)
                elseif alcoholCount >= 4 then
                    TriggerEvent('evidence:client:SetStatus', 'heavyalcohol', 200)
                end
            end
            if data.replenish.event then
                TriggerEvent(data.replenish.event)
            end
        end)
    end, itemName)
end)

RegisterNetEvent('consumables:client:Cokebaggy', function()
    local ped = PlayerPedId()
    
    if isProcessing then return end
    isProcessing = true

    local animDict = 'switch@trevor@trev_smoking_meth'
    local animName = 'trev_smoking_meth_loop'
    if not loadAnimDict(animDict) then 
        isProcessing = false 
        return 
    end

    TMGCore.Functions.Progressbar('snort_coke', Lang:t('consumables.coke_progress'), math.random(5000, 8000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = animDict,
        anim = animName,
        flags = 49,
    }, {}, {}, function() 
        isProcessing = false
        StopAnimTask(ped, animDict, animName, 1.0)
        
        TriggerServerEvent('consumables:server:useCokeBaggy')
        
        TriggerEvent('tmg-inventory:client:ItemBox', TMGCore.Shared.Items['cokebaggy'], 'remove')
        TriggerEvent('evidence:client:SetStatus', 'widepupils', 200)
        
        cokeBaggyEffect()
    end, function() 
        isProcessing = false
        StopAnimTask(ped, animDict, animName, 1.0)
        TMGCore.Functions.Notify(Lang:t('consumables.canceled'), 'error')
    end)
end)

RegisterNetEvent('consumables:client:Crackbaggy', function()
    local ped = PlayerPedId()
    
    if isProcessing then return end
    isProcessing = true

    local animDict = 'switch@trevor@trev_smoking_meth'
    local animName = 'trev_smoking_meth_loop'
    if not loadAnimDict(animDict) then 
        isProcessing = false 
        return 
    end

    TMGCore.Functions.Progressbar('snort_crack', Lang:t('consumables.crack_progress'), math.random(7000, 10000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = animDict,
        anim = animName,
        flags = 49,
    }, {}, {}, function() 
        isProcessing = false
        StopAnimTask(ped, animDict, animName, 1.0)
        
        TriggerServerEvent('consumables:server:useCrackBaggy')
        
        TriggerEvent('inventory:client:ItemBox', TMGCore.Shared.Items['crack_baggy'], 'remove')
        TriggerEvent('evidence:client:SetStatus', 'widepupils', 300)
        
        crackBaggyEffect()
    end, function() 
        isProcessing = false
        StopAnimTask(ped, animDict, animName, 1.0)
        TMGCore.Functions.Notify(Lang:t('consumables.canceled'), 'error')
    end)
end)

RegisterNetEvent('consumables:client:EcstasyBaggy', function()
    if isProcessing then return end
    isProcessing = true

    local animDict = 'mp_suicide'
    local animName = 'pill'
    
    if not loadAnimDict(animDict) then 
        isProcessing = false 
        return 
    end

    TMGCore.Functions.Progressbar('use_ecstasy', Lang:t('consumables.ecstasy_progress'), 3000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = animDict,
        anim = animName,
        flags = 49,
    }, {}, {}, function() 
        isProcessing = false
        StopAnimTask(PlayerPedId(), animDict, animName, 1.0)
        
        TriggerServerEvent('consumables:server:useXTCBaggy')
        
        TriggerEvent('tmg-inventory:client:ItemBox', TMGCore.Shared.Items['xtcbaggy'], 'remove')
        
        ecstasyEffect()
    end, function() 
        isProcessing = false
        StopAnimTask(PlayerPedId(), animDict, animName, 1.0)
        TMGCore.Functions.Notify(Lang:t('consumables.canceled'), 'error')
    end)
end)

RegisterNetEvent('consumables:client:oxy', function()
    if isProcessing then return end
    isProcessing = true

    local animDict = 'mp_suicide'
    local animName = 'pill'
    
    if not loadAnimDict(animDict) then 
        isProcessing = false 
        return 
    end

    TMGCore.Functions.Progressbar('use_oxy', Lang:t('consumables.healing_progress'), 2000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = animDict,
        anim = animName,
        flags = 49,
    }, {}, {}, function() 
        isProcessing = false
        StopAnimTask(PlayerPedId(), animDict, animName, 1.0)
        
        TriggerServerEvent('consumables:server:useOxy')
        
        TriggerEvent('tmg-inventory:client:ItemBox', TMGCore.Shared.Items['oxy'], 'remove')
        ClearPedBloodDamage(PlayerPedId())
        
        healOxy()
    end, function() 
        isProcessing = false
        StopAnimTask(PlayerPedId(), animDict, animName, 1.0)
        TMGCore.Functions.Notify(Lang:t('consumables.canceled'), 'error')
    end)
end)

RegisterNetEvent('consumables:client:meth', function()
    local ped = PlayerPedId()

    if isProcessing then return end
    isProcessing = true

    local animDict = 'switch@trevor@trev_smoking_meth'
    local animName = 'trev_smoking_meth_loop'
    if not loadAnimDict(animDict) then 
        isProcessing = false 
        return 
    end

    TMGCore.Functions.Progressbar('snort_meth', Lang:t('consumables.meth_progress'), 1500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = animDict,
        anim = animName,
        flags = 49,
    }, {}, {}, function() 
        isProcessing = false
        StopAnimTask(ped, animDict, animName, 1.0)
        
        TriggerServerEvent('consumables:server:useMeth')
        
        TriggerEvent('tmg-inventory:client:ItemBox', TMGCore.Shared.Items['meth'], 'remove')
        TriggerEvent('evidence:client:SetStatus', 'widepupils', 300)
        TriggerEvent('evidence:client:SetStatus', 'agitated', 300)
        
        methBagEffect()
    end, function() 
        isProcessing = false
        StopAnimTask(ped, animDict, animName, 1.0)
        TMGCore.Functions.Notify(Lang:t('consumables.canceled'), 'error')
    end)
end)

RegisterNetEvent('consumables:client:UseJoint', function()
    if isProcessing then return end
    isProcessing = true

    TMGCore.Functions.Progressbar('smoke_joint', Lang:t('consumables.joint_progress'), 1500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() 
        isProcessing = false
        local ped = PlayerPedId()
        
        TriggerEvent('tmg-inventory:client:ItemBox', TMGCore.Shared.Items['joint'], 'remove')
        TriggerServerEvent('tmg-inventory:server:RemoveItem', 'joint', 1) 

        local animDict = 'timetable@gardener@smoking_joint'
        local animName = 'smoke_idle'
        if loadAnimDict(animDict) then
            TaskPlayAnim(ped, animDict, animName, 8.0, 1.0, -1, 49, 0, false, false, false)
        end

        StartScreenEffect('DrugsMichaelAliensFightIn', 3.0, 0)
        SetTimeout(5000, function()
            StopScreenEffect('DrugsMichaelAliensFightIn')
        end)

        TriggerEvent('evidence:client:SetStatus', 'weedsmell', 300)
        TriggerServerEvent('hud:server:RelieveStress', Config.RelieveWeedStress)
        
        SetTimeout(7000, function()
            StopAnimTask(ped, animDict, animName, 1.0)
        end)
    end, function() 
        isProcessing = false
        TMGCore.Functions.Notify(Lang:t('consumables.canceled'), 'error')
    end)
end)

local parachuteEquipped = false

RegisterNetEvent('consumables:client:UseParachute', function()
    if isProcessing then return end
    isProcessing = true
    
    local ped = PlayerPedId()
    equipParachuteAnim() 

    TMGCore.Functions.Progressbar('use_parachute', Lang:t('consumables.use_parachute_progress'), 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() 
        isProcessing = false
        
        TriggerEvent('tmg-inventory:client:ItemBox', TMGCore.Shared.Items['parachute'], 'remove')
        TriggerServerEvent('tmg-inventory:server:RemoveItem', 'parachute', 1)
        GiveWeaponToPed(ped, `GADGET_PARACHUTE`, 1, false, false)
        SetPedGadget(ped, `GADGET_PARACHUTE`, true) 
        
        local parachuteData = {
            outfitData = { ['bag'] = { item = 7, texture = 0 } } 
        }
        TriggerEvent('tmg-clothing:client:loadOutfit', parachuteData)
        
        parachuteEquipped = true
        
        loadAnimDict('clothingshirt')
        TaskPlayAnim(ped, 'clothingshirt', 'exit', 8.0, 1.0, 1000, 49, 0, false, false, false)
        
        TMGCore.Functions.Notify("Parachute equipped. Safe travels.", "success")
    end, function() 
        isProcessing = false
        StopAnimTask(ped, 'clothingshirt', 'try_shirt_positive_d', 1.0)
    end)
end)

RegisterNetEvent('consumables:client:ResetParachute', function()
    if not parachuteEquipped then 
        TMGCore.Functions.Notify(Lang:t('consumables.no_parachute'), 'error')
        return 
    end

    if isProcessing then return end
    isProcessing = true

    local ped = PlayerPedId()
    equipParachuteAnim() 

    TMGCore.Functions.Progressbar('reset_parachute', Lang:t('consumables.pack_parachute_progress'), 40000, false, true, {
        disableMovement = true, 
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() 
        isProcessing = false
        
        local parachuteResetData = {
            outfitData = { ['bag'] = { item = 0, texture = 0 } } 
        }
        TriggerEvent('tmg-clothing:client:loadOutfit', parachuteResetData)
        
        loadAnimDict('clothingshirt')
        TaskPlayAnim(ped, 'clothingshirt', 'exit', 8.0, 1.0, 1000, 49, 0, false, false, false)

        TriggerServerEvent('consumables:server:AddParachute')
        TriggerEvent('inventory:client:ItemBox', TMGCore.Shared.Items['parachute'], 'add')
        
        parachuteEquipped = false
        TMGCore.Functions.Notify("Parachute packed successfully.", "success")
    end, function() 
        isProcessing = false
        StopAnimTask(ped, 'clothingshirt', 'try_shirt_positive_d', 1.0)
        TMGCore.Functions.Notify(Lang:t('consumables.canceled'), 'error')
    end)
end)

RegisterNetEvent('consumables:client:UseArmor', function()
    local ped = PlayerPedId()
    local currentArmor = GetPedArmour(ped)

    if currentArmor >= 100 then 
        TMGCore.Functions.Notify(Lang:t('consumables.armor_full'), 'error')
        return
    end

    if isProcessing then return end
    isProcessing = true

    local animDict = "clothingshirt"
    local animName = "try_shirt_positive_d"
    loadAnimDict(animDict)

    TMGCore.Functions.Progressbar('use_armor', Lang:t('consumables.armor_progress'), 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = animDict,
        anim = animName,
        flags = 49,
    }, {}, {}, function() 
        isProcessing = false
        StopAnimTask(ped, animDict, animName, 1.0)
        
        TriggerEvent('inventory:client:ItemBox', TMGCore.Shared.Items['armor'], 'remove')
        
        TriggerServerEvent('consumables:server:useArmor')
        
        TMGCore.Functions.Notify("Armor vest secured.", "success")
    end, function() 
        isProcessing = false
        StopAnimTask(ped, animDict, animName, 1.0)
        TMGCore.Functions.Notify(Lang:t('consumables.canceled'), 'error')
    end)
end)

RegisterNetEvent('consumables:client:UseHeavyArmor', function()
    local ped = PlayerPedId()
    if GetPedArmour(ped) >= 100 then
        TMGCore.Functions.Notify(Lang:t('consumables.armor_full'), 'error')
        return
    end

    if isProcessing then return end
    isProcessing = true
    local animDict = "clothingshirt"
    local animName = "try_shirt_positive_d"
    loadAnimDict(animDict)

    TMGCore.Functions.Progressbar('use_heavyarmor', Lang:t('consumables.heavy_armor_progress'), 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = animDict,
        anim = animName,
        flags = 49,
    }, {}, {}, function() 
        isProcessing = false
        StopAnimTask(ped, animDict, animName, 1.0)
        
        if not Config.Disable.vestDrawable then
            local PlayerData = TMGCore.Functions.GetPlayerData()
            
            if PlayerData.charinfo.gender == 0 then 
                
                if GetPedDrawableVariation(ped, 9) ~= 5 then
                    SetPedComponentVariation(ped, 9, 5, 2, 2)
                end
            else 
                if GetPedDrawableVariation(ped, 9) ~= 30 then
                    SetPedComponentVariation(ped, 9, 30, 0, 2)
                end
            end
        end

        TriggerEvent('inventory:client:ItemBox', TMGCore.Shared.Items['heavyarmor'], 'remove')
        TriggerServerEvent('consumables:server:useHeavyArmor')
        
        TMGCore.Functions.Notify("Heavy plates inserted.", "success")
    end, function() 
        isProcessing = false
        StopAnimTask(ped, animDict, animName, 1.0)
        TMGCore.Functions.Notify(Lang:t('consumables.canceled'), 'error')
    end)
end)

RegisterNetEvent('consumables:client:ResetArmor', function()
    local ped = PlayerPedId()
    local currentVest = GetPedDrawableVariation(ped, 9)

    if currentVest <= 0 then 
        TMGCore.Functions.Notify(Lang:t('consumables.armor_empty'), 'error')
        return 
    end

    if isProcessing then return end
    isProcessing = true

    local animDict = "clothingshirt"
    local animName = "try_shirt_positive_d"
    loadAnimDict(animDict)

    TMGCore.Functions.Progressbar('remove_armor', Lang:t('consumables.remove_armor_progress'), 2500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = animDict,
        anim = animName,
        flags = 49,
    }, {}, {}, function() 
        isProcessing = false
        StopAnimTask(ped, animDict, animName, 1.0)

        local resetVest = currVest or 0
        local resetTexture = currVestTexture or 0
        
        SetPedComponentVariation(ped, 9, resetVest, resetTexture, 2)
        SetPedArmour(ped, 0)

        TriggerEvent('inventory:client:ItemBox', TMGCore.Shared.Items['heavyarmor'], 'add')
        TriggerServerEvent('consumables:server:resetArmor')
        
        currVest = nil
        currVestTexture = nil
        
        TMGCore.Functions.Notify("Armor plates removed.", "primary")
    end, function() 
        isProcessing = false
        StopAnimTask(ped, animDict, animName, 1.0)
    end)
end)













local isDrunkLoopActive = false

function AlcoholLoop()
    if isDrunkLoopActive then return end
    isDrunkLoopActive = true

    CreateThread(function()
        local lastReduction = GetGameTimer()
        local reductionInterval = 1000 * 60 * 15 

        while alcoholCount > 0 do
            Wait(2000) 
            local ped = PlayerPedId()

            if IsEntityDead(ped) then
                alcoholCount = 0
                break
            end

            if (GetGameTimer() - lastReduction) >= reductionInterval then
                alcoholCount = alcoholCount - 1
                lastReduction = GetGameTimer()
                
                if alcoholCount < 2 then
                    SetPedIsDrunk(ped, false)
                    StopGameplayCamShaking(true)
                end
            end
        end
        StopAllScreenEffects()
        StopGameplayCamShaking(true)
        SetPedIsDrunk(PlayerPedId(), false)
        
        isDrunkLoopActive = false
    end)
end
