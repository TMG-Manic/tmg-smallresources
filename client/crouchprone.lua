local isCrouching = false
local walkSet = 'default'

local function loadAnimSet(anim)
    if HasAnimSetLoaded(anim) then return true end
    RequestAnimSet(anim)
    local timeout = 0
    while not HasAnimSetLoaded(anim) and timeout < 100 do
        Wait(10); timeout = timeout + 1
    end
    return HasAnimSetLoaded(anim)
end

local function resetMovement()
    local ped = PlayerPedId()
    ResetPedMovementClipset(ped, 0.5) 
    ResetPedWeaponMovementClipset(ped)
    ResetPedStrafeClipset(ped)
    
    if walkSet ~= 'default' and loadAnimSet(walkSet) then
        SetPedMovementClipset(ped, walkSet, 0.5)
    end
end


RegisterNetEvent('crouchprone:client:SetWalkSet', function(clipset)
    walkSet = clipset or 'default'
end)


RegisterCommand('togglecrouch', function()
    local ped = PlayerPedId()
    
    if IsPedInAnyVehicle(ped) or IsPedFalling(ped) or IsPedSwimming(ped) or IsPauseMenuActive() or IsEntityDead(ped) then
        return
    end

    if GetPedStealthMovement(ped) then
        SetPedStealthMovement(ped, false, 'DEFAULT_ACTION')
    end

    if isCrouching then
        resetMovement()
        isCrouching = false
    else
        if loadAnimSet('move_ped_crouched') then
            SetPedMovementClipset(ped, 'move_ped_crouched', 0.5)
            SetPedStrafeClipset(ped, 'move_ped_crouched_strafing')
            isCrouching = true
            
        end
    end
end, false)

RegisterKeyMapping('togglecrouch', 'Toggle Crouch', 'keyboard', 'LCONTROL')

CreateThread(function()
    while true do
        Wait(1000)
        if isCrouching then
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped) or IsEntityDead(ped) then
                isCrouching = false
                resetMovement()
            end
        end
    end
end)
