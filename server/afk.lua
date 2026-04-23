RegisterNetEvent('KickForAFK', function()
    local src = source
    local Player = TMGCore.Functions.GetPlayer(src)
    if not Player then return end
    print(string.format("^5[TMG]^7 Session Purge: %s terminated (Reason: AFK Threshold Exceeded)", 
        Player.PlayerData.citizenid))
    DropPlayer(src, Lang:t("afk.kick_message"))
end)
TMGCore.Functions.CreateCallback('tmg-afkkick:server:GetPermissions', function(source, cb)
    local Player = TMGCore.Functions.GetPlayer(source)
    if Player then
        local permissions = TMGCore.Functions.GetPermission(source)
        print(string.format("^5[TMG]^7 Security Pulse: %s requested AFK Immunity status [%s]", 
        Player.PlayerData.citizenid, tostring(permissions)))
        cb(permissions)
    else
        cb(nil)
    end
end)
