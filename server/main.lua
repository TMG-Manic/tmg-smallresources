RegisterNetEvent('tackle:server:TacklePlayer', function(playerId)
    local src = source
    if not TMGCore.Functions.GetPlayer(src) then return end
    print(string.format("^5[TMG]^7 Physical Pulse: Terminal %s initiated tackle on %s", src, playerId))
    TriggerClientEvent('tackle:client:GetTackled', playerId)
end)

TMGCore.Commands.Add('id', 'Check Your ID #', {}, false, function(source)
    TriggerClientEvent('TMGCore:Notify', source, 'ID: ' .. source, 'primary')
end)


TMGCore.Functions.CreateUseableItem('harness', function(source, item)
    TriggerClientEvent('seatbelt:client:UseHarness', source, item)
end)

RegisterNetEvent('tmg-racing:server:useHarness', function(item)
    local src = source
    local Player = TMGCore.Functions.GetPlayer(src)
    if not Player or not item.slot then return end

    local cid = Player.PlayerData.citizenid
    local itemData = Player.PlayerData.items[item.slot]
    if not itemData then return end

    local currentUses = itemData.info.uses or Config.HarnessUses
    
    if currentUses <= 1 then
        if exports['tmg-inventory']:RemoveItem(src, 'harness', 1, item.slot, 'mainframe:harness:exhausted') then
            TriggerClientEvent('tmg-inventory:client:ItemBox', src, TMGCore.Shared.Items['harness'], 'remove')
        end
    else
        itemData.info.uses = currentUses - 1
        
        Player.Functions.SetInventory(Player.PlayerData.items)
        
        local updatePath = string.format("inventory.%d.info", item.slot)
        
        exports['tmgnosql']:UpdateOne('players', 
            { ["citizenid"] = cid }, 
            { ["$set"] = { [updatePath] = itemData.info } }
        )
    end
end)

RegisterNetEvent('tmg-carwash:server:washCar', function()
    local src = source
    local Player = TMGCore.Functions.GetPlayer(src)
    if not Player then return end

    local price = Config.CarWash.defaultPrice

    if Player.Functions.RemoveMoney('cash', price, 'car-washed') or 
       Player.Functions.RemoveMoney('bank', price, 'car-washed') then
        
        TriggerClientEvent('tmg-carwash:client:washCar', src)
        print(string.format("^5[TMG]^7 Economy Pulse: %s paid $%s for terminal cleaning.", Player.PlayerData.citizenid, price))
    else
        TriggerClientEvent('TMGCore:Notify', src, Lang:t('error.dont_have_enough_money'), 'error')
    end
end)

TMGCore.Functions.CreateCallback('smallresources:server:GetCurrentPlayers', function(_, cb)
    cb(#GetPlayers())
end)
