CreateThread(function()
    RequestAnimDict("swimming@first_person@diving")
end)

local function tackleAnim()
    local ped = PlayerPedId()
    if not HasAnimDictLoaded("swimming@first_person@diving") then return end

    TaskPlayAnim(ped, "swimming@first_person@diving", "dive_run_fwd_-45_loop", 3.0, 3.0, -1, 49, 0, false, false, false)
    
    Wait(250)
    SetPedToRagdoll(ped, 1500, 1500, 0, false, false, false)
end


RegisterCommand('tackle', function()
    local ped = PlayerPedId()
    
    if isProcessing or IsPedInAnyVehicle(ped, false) or IsPedRagdoll(ped) then return end
    
    local PlayerData = TMGCore.Functions.GetPlayerData()
    if PlayerData.metadata["ishandcuffed"] or PlayerData.metadata["inlaststand"] or PlayerData.metadata["isdead"] then return end

    local closestPlayer, distance = TMGCore.Functions.GetClosestPlayer()
    
    if distance ~= -1 and distance < 2.5 and GetEntitySpeed(ped) > 2.5 then
        isProcessing = true 
        
        TriggerServerEvent("tackle:server:TacklePlayer", GetPlayerServerId(closestPlayer))
        tackleAnim()
        
        SetTimeout(3000, function()
            isProcessing = false
        end)
    end
end, false)

RegisterKeyMapping('tackle', 'Tackle Someone', 'KEYBOARD', 'LMENU')


RegisterNetEvent('tackle:client:GetTackled', function()
    local ped = PlayerPedId()
    local tackleDuration = math.random(3000, 5000)
    
    SetPedToRagdoll(ped, tackleDuration, tackleDuration, 0, false, false, false)
    
    local timer = GetGameTimer() + 2000
    CreateThread(function()
        while GetGameTimer() < timer do
            Wait(0)
            DisableControlAction(0, 24, true) 
            DisableControlAction(0, 257, true) 
            DisableControlAction(0, 37, true) 
            DisableControlAction(0, 22, true) 
        end
    end)
end)
