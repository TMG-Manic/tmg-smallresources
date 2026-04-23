


for k, _ in pairs(Config.Consumables.alcohol) do
    TMGCore.Functions.CreateUseableItem(k, function(source, item)
        local Player = TMGCore.Functions.GetPlayer(source)
        if not Player then return end
        TriggerClientEvent('consumables:client:DrinkAlcohol', source, item.name)
        print(string.format("^5[TMG]^7 Materialization: %s initiated consumption of %s", Player.PlayerData.citizenid, item.name))
    end)
end



for k, _ in pairs(Config.Consumables.eat) do
    TMGCore.Functions.CreateUseableItem(k, function(source, item)
        local Player = TMGCore.Functions.GetPlayer(source)
        if not Player then return end
        if exports['tmg-inventory']:RemoveItem(source, item.name, 1, item.slot, 'tmgno:consumables:eat') then
            TriggerClientEvent('tmg-inventory:client:ItemBox', source, TMGCore.Shared.Items[item.name], 'remove')
            TriggerClientEvent('consumables:client:Eat', source, item.name)
            print(string.format("^5[TMG]^7 Nutrition: %s consumed 1x %s (BSON Slot: %s)", Player.PlayerData.citizenid, item.name, item.slot))
        else
            print(string.format("^1[TMG Security]^7 Player %s attempted unauthorized consumption for [%s]", source, item.name))
        end
    end)
end


for k, _ in pairs(Config.Consumables.drink) do
    TMGCore.Functions.CreateUseableItem(k, function(source, item)
        local Player = TMGCore.Functions.GetPlayer(source)
        if not Player then return end

        if exports['tmg-inventory']:RemoveItem(source, item.name, 1, item.slot, 'tmgno:consumables:drink') then
            
            TriggerClientEvent('tmg-inventory:client:ItemBox', source, TMGCore.Shared.Items[item.name], 'remove')
            TriggerClientEvent('consumables:client:Drink', source, item.name)
            print(string.format("^5[TMG]^7 Hydration: %s consumed 1x %s (BSON Slot: %s)", Player.PlayerData.citizenid, item.name, item.slot))
        else
            print(string.format("^1[TMG Security]^7 Player %s attempted unauthorized hydration for [%s]", source, item.name))
        end
    end)
end


for k, _ in pairs(Config.Consumables.custom) do
    TMGCore.Functions.CreateUseableItem(k, function(source, item)
        local Player = TMGCore.Functions.GetPlayer(source)
        if not Player then 
            return print(string.format("^1[TMG Error]^7 Player %s attempted interaction without active BSON session.", source))
        end
        if exports['tmg-inventory']:RemoveItem(source, item.name, 1, item.slot, 'tmgno:consumables:custom') then
            TriggerClientEvent('tmg-inventory:client:ItemBox', source, TMGCore.Shared.Items[item.name], 'remove')
            TriggerClientEvent('consumables:client:Custom', source, item.name)
            print(string.format("^5[TMG]^7 Materialization: %s consumed 1x %s (BSON Slot: %s)", Player.PlayerData.citizenid, item.name, item.slot))
        else
            print(string.format("^1[TMG Security]^7 Player %s attempted unauthorized custom pulse for [%s]", source, item.name))
        end
    end)
end



local function createItem(name, type)
    TMGCore.Functions.CreateUseableItem(name, function(source, item)
        local Player = TMGCore.Functions.GetPlayer(source)
        if not Player then 
            return print(string.format("^1[TMG Error]^7 Player %s attempted dynamic interaction without active BSON session.", source))
        end
        if exports['tmg-inventory']:RemoveItem(source, item.name, 1, item.slot, 'tmgno:consumables:dynamic') then
            TriggerClientEvent('tmg-inventory:client:ItemBox', source, TMGCore.Shared.Items[item.name], 'remove')
            TriggerClientEvent('consumables:client:' .. type, source, item.name)
            print(string.format("^5[TMG]^7 Dynamic Registry: %s consumed 1x %s (Type: %s | BSON Slot: %s)", 
                Player.PlayerData.citizenid, item.name, type, item.slot))
        else
            print(string.format("^1[TMG Security]^7 Player %s attempted unauthorized dynamic pulse for [%s]", source, item.name))
        end
    end)
end


local drugItems = {
    ['joint'] = 'consumables:client:UseJoint',
    ['cokebaggy'] = 'consumables:client:Cokebaggy',
    ['crack_baggy'] = 'consumables:client:Crackbaggy',
    ['xtcbaggy'] = 'consumables:client:EcstasyBaggy',
    ['oxy'] = 'consumables:client:oxy',
    ['meth'] = 'consumables:client:meth'
}

for item, event in pairs(drugItems) do
    TMGCore.Functions.CreateUseableItem(item, function(source, itemData)
        local Player = TMGCore.Functions.GetPlayer(source)
        if not Player then return end
        if exports['tmg-inventory']:RemoveItem(source, itemData.name, 1, itemData.slot, 'tmgno:consumables:narcotic') then
            TriggerClientEvent('tmg-inventory:client:ItemBox', source, TMGCore.Shared.Items[itemData.name], 'remove')
            TriggerClientEvent(event, source, itemData.name)
            print(string.format("^5[TMG]^7 Ballistics: %s consumed 1x %s (BSON Slot: %s)", 
                Player.PlayerData.citizenid, itemData.name, itemData.slot))
        else
            print(string.format("^1[TMG Security]^7 Terminal %s attempted unauthorized narcotic pulse for [%s]", source, itemData.name))
        end
    end)
end



TMGCore.Functions.CreateUseableItem('armor', function(source, item)
    local Player = TMGCore.Functions.GetPlayer(source)
    if not Player then return end
    if exports['tmg-inventory']:RemoveItem(source, item.name, 1, item.slot, 'tmgno:consumables:armor') then
        TriggerClientEvent('tmg-inventory:client:ItemBox', source, TMGCore.Shared.Items[item.name], 'remove')
        TriggerClientEvent('consumables:client:UseArmor', source)
        print(string.format("^5[TMG]^7 Ballistics: %s equipped 1x %s (BSON Slot: %s)", 
            Player.PlayerData.citizenid, item.name, item.slot))
    else
        print(string.format("^1[TMG Security]^7 Terminal %s attempted unauthorized armor", source))
    end
end)

TMGCore.Functions.CreateUseableItem('heavyarmor', function(source, item)
    local Player = TMGCore.Functions.GetPlayer(source)
    if not Player then return end
    if exports['tmg-inventory']:RemoveItem(source, item.name, 1, item.slot, 'tmgno:consumables:heavyarmor') then
        TriggerClientEvent('tmg-inventory:client:ItemBox', source, TMGCore.Shared.Items[item.name], 'remove')
        TriggerClientEvent('consumables:client:UseHeavyArmor', source)
        
        print(string.format("^5[TMG]^7 Ballistics: %s equipped 1x %s (BSON Slot: %s)", 
            Player.PlayerData.citizenid, item.name, item.slot))
    else
        print(string.format("^1[TMG Security]^7 Terminal %s attempted unauthorized heavy armor", source))
    end
end)

TMGCore.Commands.Add('resetarmor', 'Resets Vest (Police Only)', {}, false, function(source)
    local Player = TMGCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.PlayerData.job.name == 'police' then
        TriggerClientEvent('consumables:client:ResetArmor', source)
        print(string.format("^5[TMG]^7 Duty Logistics: %s (Police) initiated a ballistic vest reset pulse.", 
            Player.PlayerData.citizenid))
            
    else
        TriggerClientEvent('TMGCore:Notify', source, 'For Police Officer Only', 'error')
        print(string.format("^1[TMG Security]^7 Player %s attempted unauthorized access to 'resetarmor' pulse.", 
            source))
    end
end)


TMGCore.Functions.CreateUseableItem('binoculars', function(source)
    local Player = TMGCore.Functions.GetPlayer(source)
    if not Player then 
        return print(string.format("^1[TMG Error]^7 Terminal %s attempted utility interaction without active BSON session.", source))
    end
    TriggerClientEvent('binoculars:Toggle', source)
    print(string.format("^5[TMG]^7 Utility Pulse: %s initiated binoculars materialization.", 
        Player.PlayerData.citizenid))
end)

TMGCore.Functions.CreateUseableItem('parachute', function(source, item)
    local Player = TMGCore.Functions.GetPlayer(source)
    if not Player then 
        return print(string.format("^1[TMG Error]^7 Terminal %s attempted parachute interaction without active BSON session.", source))
    end
    if exports['tmg-inventory']:RemoveItem(source, item.name, 1, item.slot, 'tmgno:consumables:parachute') then
        TriggerClientEvent('tmg-inventory:client:ItemBox', source, TMGCore.Shared.Items[item.name], 'remove')
        TriggerClientEvent('consumables:client:UseParachute', source)
        print(string.format("^5[TMG]^7 Aerial Logistics: %s deployed 1x %s (BSON Slot: %s)", 
            Player.PlayerData.citizenid, item.name, item.slot))
    else
        print(string.format("^1[TMG Security]^7 Terminal %s attempted unauthorized parachute deployment pulse", source))
    end
end)

TMGCore.Commands.Add('resetparachute', 'Resets Parachute', {}, false, function(source)
    local Player = TMGCore.Functions.GetPlayer(source)
    if not Player then 
        return print(string.format("^1[TMG Error]^7 Terminal %s attempted parachute reset without active BSON session.", source))
    end
    TriggerClientEvent('consumables:client:ResetParachute', source)
    print(string.format("^5[TMG]^7 Aerial Logistics: %s initiated a parachute reset pulse.", 
        Player.PlayerData.citizenid))
end)



for _, v in pairs(Config.Fireworks.items) do
    TMGCore.Functions.CreateUseableItem(v, function(source, item)
        local Player = TMGCore.Functions.GetPlayer(source)
        if not Player then return end
        if exports['tmg-inventory']:RemoveItem(source, item.name, 1, item.slot, 'tmgno:consumables:fireworks') then
            TriggerClientEvent('tmg-inventory:client:ItemBox', source, TMGCore.Shared.Items[item.name], 'remove')
            TriggerClientEvent('fireworks:client:UseFirework', source, item.name, 'proj_indep_firework')
            print(string.format("^5[TMG]^7 Pyrotechnics: %s deployed 1x %s (BSON Slot: %s)", 
                Player.PlayerData.citizenid, item.name, item.slot))
        else
            print(string.format("^1[TMG Security]^7 Terminal %s attempted unauthorized firework deployment", source))
        end
    end)
end


TMGCore.Functions.CreateUseableItem('lockpick', function(source)
    local Player = TMGCore.Functions.GetPlayer(source)
    if not Player then return end
    TriggerClientEvent('lockpicks:UseLockpick', source, false)
    print(string.format("^5[TMG]^7 Breach Logic: %s initiated a standard lockpick pulse.", 
        Player.PlayerData.citizenid))
end)

TMGCore.Functions.CreateUseableItem('advancedlockpick', function(source)
    local Player = TMGCore.Functions.GetPlayer(source)
    if not Player then return end
    TriggerClientEvent('lockpicks:UseLockpick', source, true)
    print(string.format("^5[TMG]^7 Breach Logic: %s initiated an advanced lockpick pulse.", 
        Player.PlayerData.citizenid))
end)



RegisterNetEvent('consumables:server:AddParachute', function()
    local src = source
    local Player = TMGCore.Functions.GetPlayer(src)
    if not Player then 
        return print(string.format("^1[TMG Security]^7 Terminal %s attempted hardware materialization without active BSON session.", src))
    end
    local success = exports['tmg-inventory']:AddItem(src, 'parachute', 1, false, false, 'tmgno:consumables:AddParachute')
    if success then
        TriggerClientEvent('tmg-inventory:client:ItemBox', src, TMGCore.Shared.Items['parachute'], 'add')
        print(string.format("^5[TMG]^7 Materialization: %s received 1x parachute (Source: Aerial Logistics)", 
            Player.PlayerData.citizenid))
    else
        print(string.format("^1[TMG Error]^7 Failed to materialize parachute for %s (NoSQL Write Rejected)", 
            Player.PlayerData.citizenid))
    end
end)

RegisterNetEvent('consumables:server:resetArmor', function()
    local src = source
    local Player = TMGCore.Functions.GetPlayer(src)
    if not Player then 
        return print(string.format("^1[TMG Security]^7 Terminal %s attempted armor recovery without active BSON session.", src))
    end
    local success = exports['tmg-inventory']:AddItem(src, 'heavyarmor', 1, false, false, 'tmgno:consumables:resetArmor')
    if success then
        TriggerClientEvent('tmg-inventory:client:ItemBox', src, TMGCore.Shared.Items['heavyarmor'], 'add')
        print(string.format("^5[TMG]^7 Logistics Pulse: %s recovered 1x heavyarmor (Source: Reset Event)", 
            Player.PlayerData.citizenid))
    else
        print(string.format("^1[TMG Error]^7 Failed to materialize heavyarmor for %s (NoSQL Write Rejected)", 
            Player.PlayerData.citizenid))
    end
end)

RegisterNetEvent('consumables:server:useHeavyArmor', function()
    local src = source
    local Player = TMGCore.Functions.GetPlayer(src)
    if not Player then 
        return print(string.format("^1[TMG Security]^7 Terminal %s attempted armor application without active BSON session.", src))
    end
    if exports['tmg-inventory']:RemoveItem(src, 'heavyarmor', 1, false, 'tmgno:consumables:useHeavyArmor') then
        TriggerClientEvent('tmg-inventory:client:ItemBox', src, TMGCore.Shared.Items['heavyarmor'], 'remove')
        SetPedArmour(GetPlayerPed(src), 100)
        Player.Functions.SetMetaData('armor', 100)
        exports['tmgnosql']:UpdateOne('players', { citizenid = Player.PlayerData.citizenid }, {
            ["$set"] = { ["metadata.armor"] = 100 }
        })
        print(string.format("^5[TMG]^7 Ballistics: %s finalized heavy armor application (100%%).", 
            Player.PlayerData.citizenid))
        TriggerClientEvent('hospital:server:SetArmor', src, 100)
    else
        print(string.format("^1[TMG Security]^7 Terminal %s attempted unauthorized heavy armor application pulse.", src))
    end
end)

RegisterNetEvent('consumables:server:useArmor', function()
    local src = source
    local Player = TMGCore.Functions.GetPlayer(src)
    if not Player then 
        return print(string.format("^1[TMG Security]^7 Terminal %s attempted armor application without active BSON session.", src))
    end
    if exports['tmg-inventory']:RemoveItem(src, 'armor', 1, false, 'tmgno:consumables:useArmor') then
        TriggerClientEvent('tmg-inventory:client:ItemBox', src, TMGCore.Shared.Items['armor'], 'remove')
        SetPedArmour(GetPlayerPed(src), 75)
        Player.Functions.SetMetaData('armor', 75)
        exports['tmgnosql']:UpdateOne('players', { citizenid = Player.PlayerData.citizenid }, {
            ["$set"] = { ["metadata.armor"] = 75 }
        })
        print(string.format("^5[TMG]^7 Ballistics: %s finalized standard armor application (75%%).", 
            Player.PlayerData.citizenid))
        TriggerClientEvent('hospital:server:SetArmor', src, 75)
    else
        print(string.format("^1[TMG Security]^7 Terminal %s attempted unauthorized armor application pulse.", src))
    end
end)

RegisterNetEvent('consumables:server:useMeth', function()
    local src = source
    local Player = TMGCore.Functions.GetPlayer(src)
    if not Player then 
        return print(string.format("^1[TMG Security]^7 Terminal %s attempted meth consumption without active BSON session.", src))
    end
    if exports['tmg-inventory']:RemoveItem(src, 'meth', 1, false, 'tmgno:consumables:useMeth') then
        TriggerClientEvent('tmg-inventory:client:ItemBox', src, TMGCore.Shared.Items['meth'], 'remove')
        print(string.format("^5[TMG]^7 Ballistics: %s finalized meth consumption (Source: Server Event)", 
            Player.PlayerData.citizenid))
    else
        print(string.format("^1[TMG Security]^7 Terminal %s attempted unauthorized meth pulse.", src))
    end
end)

RegisterNetEvent('consumables:server:useOxy', function()
    local src = source
    local Player = TMGCore.Functions.GetPlayer(src)
    if not Player then 
        return print(string.format("^1[TMG Security]^7 Terminal %s attempted oxy consumption without active BSON session.", src))
    end
    if exports['tmg-inventory']:RemoveItem(src, 'oxy', 1, false, 'tmgno:consumables:useOxy') then
        TriggerClientEvent('tmg-inventory:client:ItemBox', src, TMGCore.Shared.Items['oxy'], 'remove')
        print(string.format("^5[TMG]^7 Ballistics: %s finalized oxy consumption (Source: Server Event)", 
            Player.PlayerData.citizenid))
    else
        print(string.format("^1[TMG Security]^7 Terminal %s attempted unauthorized oxy pulse.", src))
    end
end)

RegisterNetEvent('consumables:server:useXTCBaggy', function()
    local src = source
    local Player = TMGCore.Functions.GetPlayer(src)
    if not Player then 
        return print(string.format("^1[TMG Security]^7 Terminal %s attempted XTC consumption without active BSON session.", src))
    end
    if exports['tmg-inventory']:RemoveItem(src, 'xtcbaggy', 1, false, 'tmgno:consumables:useXTCBaggy') then
        TriggerClientEvent('tmg-inventory:client:ItemBox', src, TMGCore.Shared.Items['xtcbaggy'], 'remove')
        print(string.format("^5[TMG]^7 Ballistics: %s finalized XTC consumption (Source: Server Event)", 
            Player.PlayerData.citizenid))
    else
        print(string.format("^1[TMG Security]^7 Terminal %s attempted unauthorized XTC pulse.", src))
    end
end)

RegisterNetEvent('consumables:server:useCrackBaggy', function()
    local src = source
    local Player = TMGCore.Functions.GetPlayer(src)
    if not Player then 
        return print(string.format("^1[TMG Security]^7 Terminal %s attempted crack consumption without active BSON session.", src))
    end
    if exports['tmg-inventory']:RemoveItem(src, 'crack_baggy', 1, false, 'tmgno:consumables:useCrackBaggy') then
        TriggerClientEvent('tmg-inventory:client:ItemBox', src, TMGCore.Shared.Items['crack_baggy'], 'remove')
        print(string.format("^5[TMG]^7 Ballistics: %s finalized crack consumption (Source: Server Event)", 
            Player.PlayerData.citizenid))
    else
        print(string.format("^1[TMG Security]^7 Terminal %s attempted unauthorized crack pulse.", src))
    end
end)

RegisterNetEvent('consumables:server:useCokeBaggy', function()
    local src = source
    local Player = TMGCore.Functions.GetPlayer(src)
    if not Player then 
        return print(string.format("^1[TMG Security]^7 Terminal %s attempted coke consumption without active BSON session.", src))
    end
    if exports['tmg-inventory']:RemoveItem(src, 'cokebaggy', 1, false, 'tmgno:consumables:useCokeBaggy') then
        
        TriggerClientEvent('tmg-inventory:client:ItemBox', src, TMGCore.Shared.Items['cokebaggy'], 'remove')
        print(string.format("^5[TMG]^7 Ballistics: %s finalized coke consumption (Source: Server Event)", 
            Player.PlayerData.citizenid))
    else
        print(string.format("^1[TMG Security]^7 Terminal %s attempted unauthorized coke pulse.", src))
    end
end)

RegisterNetEvent('consumables:server:drinkAlcohol', function(item)
    local src = source
    local Player = TMGCore.Functions.GetPlayer(src)
    if not Player then 
        return print(string.format("^1[TMG Security]^7 Terminal %s attempted alcohol consumption without active BSON session.", src))
    end
    if Config.Consumables.alcohol[item] then
        if exports['tmg-inventory']:RemoveItem(src, item, 1, false, 'tmgno:consumables:drinkAlcohol') then
            TriggerClientEvent('tmg-inventory:client:ItemBox', src, TMGCore.Shared.Items[item], 'remove')
            print(string.format("^5[TMG]^7 Ballistics: %s finalized alcohol consumption [%s]", 
                Player.PlayerData.citizenid, item))
        else
            print(string.format("^1[TMG Security]^7 Terminal %s attempted unauthorized alcohol pulse.", src))
        end
    end
end)


RegisterNetEvent('consumables:server:UseFirework', function(item)
    local src = source
    local Player = TMGCore.Functions.GetPlayer(src)
    if not Player then 
        return print(string.format("^1[TMG Security]^7 Terminal %s attempted firework deployment without active BSON session.", src))
    end
    local isValid = false
    for _, firework in ipairs(Config.Fireworks.items) do
        if firework == item then
            isValid = true
            break
        end
    end

    if isValid then
        if exports['tmg-inventory']:RemoveItem(src, item, 1, false, 'tmgno:consumables:UseFirework') then
            TriggerClientEvent('tmg-inventory:client:ItemBox', src, TMGCore.Shared.Items[item], 'remove')
            print(string.format("^5[TMG]^7 Pyrotechnics: %s finalized deployment of %s", 
                Player.PlayerData.citizenid, item))
        else
            print(string.format("^1[TMG Security]^7 Terminal %s attempted unauthorized firework pulse.", src))
        end
    end
end)

RegisterNetEvent('consumables:server:addThirst', function(amount)
    local src = source
    local Player = TMGCore.Functions.GetPlayer(src)
    if not Player then 
        return print(string.format("^1[TMG Security]^7 Terminal %s attempted hydration pulse without active BSON session.", src))
    end
    local currentThirst = Player.PlayerData.metadata['thirst']
    local newThirst = math.max(0, math.min(100, amount))
    Player.Functions.SetMetaData('thirst', newThirst)
    exports['tmgnosql']:UpdateOne('players', { citizenid = Player.PlayerData.citizenid }, {
        ["$set"] = { ["metadata.thirst"] = newThirst }
    })
    TriggerClientEvent('hud:client:UpdateNeeds', src, Player.PlayerData.metadata.hunger, newThirst)
    print(string.format("^5[TMG]^7 Hydration Pulse: %s updated to %s%% (Delta: %s%%)", 
        Player.PlayerData.citizenid, newThirst, (newThirst - currentThirst)))
end)

RegisterNetEvent('consumables:server:addHunger', function(amount)
    local src = source
    local Player = TMGCore.Functions.GetPlayer(src)
    if not Player then 
        return print(string.format("^1[TMG Security]^7 Terminal %s attempted metabolic pulse without active BSON session.", src))
    end
    local currentHunger = Player.PlayerData.metadata['hunger']
    local newHunger = math.max(0, math.min(100, amount))
    Player.Functions.SetMetaData('hunger', newHunger)
    exports['tmgnosql']:UpdateOne('players', { citizenid = Player.PlayerData.citizenid }, {
        ["$set"] = { ["metadata.hunger"] = newHunger }
    })
    TriggerClientEvent('hud:client:UpdateNeeds', src, newHunger, Player.PlayerData.metadata.thirst)
    print(string.format("^5[TMG]^7 Metabolic Pulse: %s updated to %s%% (Delta: %s%%)", 
        Player.PlayerData.citizenid, newHunger, (newHunger - currentHunger)))
end)


TMGCore.Functions.CreateCallback('consumables:itemdata', function(source, cb, itemName)
    local Player = TMGCore.Functions.GetPlayer(source)
    if not Player then 
        return cb(nil) 
    end
    local itemData = Config.Consumables.custom[itemName]
    if itemData then
        cb(itemData)
    else
        cb(nil)
    end
end)





local function addDrink(drinkName, replenish)
    if Config.Consumables.drink[drinkName] ~= nil then
        print(string.format("^1[TMG Error]^7 Dynamic Registry: [%s] rejected. Asset already materialized.", drinkName))
        return false, 'already added'
    end
    Config.Consumables.drink[drinkName] = replenish
    createItem(drinkName, 'Drink')
    print(string.format("^5[TMG]^7 Dynamic Registry: Authorized beverage [%s] (Replenish: %s%%)", 
        drinkName, replenish))
    return true, 'success'
end
exports('AddDrink', addDrink)


local function addFood(foodName, replenish)
    if Config.Consumables.eat[foodName] ~= nil then
        print(string.format("^1[TMG Error]^7 Dynamic Registry: [%s] rejected. Asset already materialized.", foodName))
        return false, 'already added'
    end
    Config.Consumables.eat[foodName] = replenish
    createItem(foodName, 'Eat')
    print(string.format("^5[TMG]^7 Dynamic Registry: Authorized metabolic asset [%s] (Replenish: %s%%)", 
        foodName, replenish))
    return true, 'success'
end
exports('AddFood', addFood)





local function addAlcohol(alcoholName, replenish)
    if Config.Consumables.alcohol[alcoholName] ~= nil then
        print(string.format("^1[TMG Error]^7 Dynamic Registry: [%s] rejected. Asset already materialized.", alcoholName))
        return false, 'already added'
    end
    Config.Consumables.alcohol[alcoholName] = replenish
    createItem(alcoholName, 'DrinkAlcohol')
    print(string.format("^5[TMG]^7 Dynamic Registry: Authorized intoxicant [%s] (Replenish: %s%%)", 
        alcoholName, replenish))
    return true, 'success'
end
exports('AddAlcohol', addAlcohol)





local function addCustom(itemName, data)
    if Config.Consumables.custom[itemName] ~= nil then
        print(string.format("^1[TMG Error]^7 Dynamic Registry: [%s] rejected. Asset already materialized.", itemName))
        return false, 'already added'
    end
    Config.Consumables.custom[itemName] = data
    createItem(itemName, 'Custom')
    print(string.format("^5[TMG]^7 Dynamic Registry: Authorized custom asset [%s]", itemName))
    return true, 'success'
end
exports('AddCustom', addCustom)
