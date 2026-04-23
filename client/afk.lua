
local TMGCore = exports['tmg-core']:GetCoreObject()

local isLoggedIn = LocalPlayer.state.isLoggedIn
local checkUser = true
local prevPos, prevHeading = nil, nil
local time = nil
local timeMinutes = 0

local function updatePermissionLevel()
    TMGCore.Functions.TriggerCallback('tmg-afkkick:server:GetPermissions', function(userGroups)
        checkUser = true 
        for group, isAllowed in pairs(userGroups) do
            if Config.AFK.ignoredGroups[group] and isAllowed then
                checkUser = false
                break
            end
        end
    end)
end

RegisterNetEvent('TMGCore:Client:OnPlayerLoaded', function()
    updatePermissionLevel()
    isLoggedIn = true
end)

RegisterNetEvent('TMGCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('TMGCore:Client:OnPermissionUpdate', function()
    updatePermissionLevel()
end)

CreateThread(function()
    while true do
        Wait(10000) 
        
        local ped = PlayerPedId()
        
        if (isLoggedIn or Config.AFK.kickInCharMenu) and checkUser then
            local currPos = GetEntityCoords(ped)
            local currHeading = GetEntityHeading(ped)

            if prevPos and prevHeading then
                local distance = #(currPos - prevPos)
                local changedView = math.abs(currHeading - prevHeading) > 0.1

                if distance < 0.1 and not changedView then
                    if time then
                        if time > 0 then
                            if timeMinutes[tostring(time)] then
                                local isMin = timeMinutes[tostring(time)] == 'minutes'
                                local label = isMin and Lang:t('afk.time_minutes') or Lang:t('afk.time_seconds')
                                local val = isMin and math.ceil(time / 60) or time
                                
                                TMGCore.Functions.Notify(Lang:t('afk.will_kick') .. val .. label, 'error', 8000)
                            end
                            time -= 10
                        else
                            TriggerServerEvent('KickForAFK')
                        end
                    else
                        time = Config.AFK.secondsUntilKick
                    end
                else
                    time = Config.AFK.secondsUntilKick
                end
            end

            prevPos = currPos
            prevHeading = currHeading
        else
            time = nil
        end
    end
end)
