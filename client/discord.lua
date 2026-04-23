CreateThread(function()
    if not Config.Discord.isEnabled then return end

    SetDiscordAppId(Config.Discord.applicationId)
    SetDiscordRichPresenceAsset(Config.Discord.iconLarge)
    SetDiscordRichPresenceAssetText(Config.Discord.iconLargeHoverText)
    SetDiscordRichPresenceAssetSmall(Config.Discord.iconSmall)
    SetDiscordRichPresenceAssetSmallText(Config.Discord.iconSmallHoverText)

    if Config.Discord.buttons and type(Config.Discord.buttons) == "table" then
        for i, v in pairs(Config.Discord.buttons) do
            SetDiscordRichPresenceAction(i - 1, v.text, v.url)
        end
    end

    while true do
        if Config.Discord.showPlayerCount then
            TMGCore.Functions.TriggerCallback('smallresources:server:GetCurrentPlayers', function(result)
                local playerLabel = string.format("Players: %s/%s", result, Config.Discord.maxPlayers)
                SetRichPresence(playerLabel)
            end)
        else
            SetRichPresence(Config.Discord.iconLargeHoverText)
            break 
        end

        local updateRate = Config.Discord.updateRate
        if updateRate < 60000 then updateRate = 60000 end 
        
        Wait(updateRate)
    end
end)
