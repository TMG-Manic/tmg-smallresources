
local seatbeltOn = false
local harnessOn = false
local harnessHp = Config.HarnessUses
local handbrake = 0
local sleep = 0
local harnessData = {}
local newVehBodyHealth = 0
local currVehBodyHealth = 0
local frameBodyChange = 0
local lastFrameVehSpeed = 0
local lastFrameVehSpeed2 = 0
local thisFrameVehSpeed = 0
local tick = 0
local damageDone = false
local modifierDensity = true
local lastVeh = nil
local veloc



local function ejectFromVehicle()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local coords = GetOffsetFromEntityInWorldCoords(veh, 1.0, 0.0, 1.0)
    SetEntityCoords(ped, coords.x, coords.y, coords.z)
    Wait(1)
    SetPedToRagdoll(ped, 5511, 5511, 0, 0, 0, 0)
    SetEntityVelocity(ped, veloc.x * 4, veloc.y * 4, veloc.z * 4)
    local ejectSpeed = math.ceil(GetEntitySpeed(ped) * 8)
    if GetEntityHealth(ped) - ejectSpeed > 0 then
        SetEntityHealth(ped, GetEntityHealth(ped) - ejectSpeed)
    elseif GetEntityHealth(ped) ~= 0 then
        SetEntityHealth(ped, 0)
    end
end

local function toggleSeatbelt()
    seatbeltOn = not seatbeltOn
    SeatBeltLoop()
    TriggerEvent("seatbelt:client:ToggleSeatbelt", seatbeltOn)
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5.0, seatbeltOn and "carbuckle" or "carunbuckle", 0.25)
end

local function toggleHarness()
    harnessOn = not harnessOn
    if not harnessOn then return end
    toggleSeatbelt()
end

local function resetHandBrake()
    if handbrake <= 0 then return end
    handbrake -= 1
end

function SeatBeltLoop()
    CreateThread(function()
        while true do
            sleep = 0
            if seatbeltOn or harnessOn then
                DisableControlAction(0, 75, true)
                DisableControlAction(27, 75, true)
            end
            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                seatbeltOn = false
                harnessOn = false
                TriggerEvent("seatbelt:client:ToggleSeatbelt", seatbeltOn)
                break
            end
            if not seatbeltOn and not harnessOn then break end
            Wait(sleep)
        end
    end)
end





local function hasHarness()
    return harnessOn
end

exports("HasHarness", hasHarness)



local function hasSeatbeltOn()
    return seatbeltOn
end

exports("HasSeatbeltOn", hasSeatbeltOn)



local seatbeltOn = false
local harnessOn = false
local harnessHp = 100
local handbrake = 0



local function ejectFromVehicle()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local coords = GetEntityCoords(ped)
    local velocity = GetEntityVelocity(veh)
    
    SetEntityCoords(ped, coords.x, coords.y, coords.z + 1.0)
    Wait(1)
    SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
    SetEntityVelocity(ped, velocity.x, velocity.y, velocity.z)
end



RegisterNetEvent('TMGCore:Client:EnteredVehicle', function()
    local ped = PlayerPedId()
    
    
    local lastFrameSpeed = 0.0
    local lastFrameBodyHealth = 0.0
    
    CreateThread(function()
        while IsPedInAnyVehicle(ped, false) do
            local sleep = 100 
            local veh = GetVehiclePedIsIn(ped, false)
            
            if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped then
                sleep = 50 
                
                local currentSpeed = GetEntitySpeed(veh) * 3.6
                local currentBodyHealth = GetVehicleBodyHealth(veh)
                
                local speedDiff = lastFrameSpeed - currentSpeed
                
                if speedDiff > (lastFrameSpeed * 0.25) and lastFrameSpeed > 50.0 then
                    if not seatbeltOn and not harnessOn and not IsThisModelABike(GetEntityModel(veh)) then
                        if math.random(1, 100) < (lastFrameSpeed * 0.4) then
                            ejectFromVehicle()
                        end
                    elseif harnessOn then
                        harnessHp = harnessHp - 1
                        TriggerServerEvent('seatbelt:server:DoHarnessDamage', harnessHp)
                    end
                    
                    if speedDiff > 80.0 then
                        SetVehicleEngineOn(veh, false, true, true)
                    end
                end

                SetPedHelmet(ped, false)
                
                lastFrameSpeed = currentSpeed
                lastFrameBodyHealth = currentBodyHealth
            end
            
            Wait(sleep)
        end
        
        seatbeltOn = false
        harnessOn = false
        lastFrameSpeed = 0.0
        SetPedHelmet(ped, true)
    end)
end)

local isToggling = false 

RegisterCommand('toggleseatbelt', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    
    if veh == 0 or IsThisModelABike(GetEntityModel(veh)) or isToggling then return end
    
    isToggling = true
    
    seatbeltOn = not seatbeltOn
    
    if seatbeltOn then
        TMGCore.Functions.Notify("Seatbelt Fastened", "success")
        TriggerEvent('InteractSound_CL:PlayOnOne', 'seatbelt', 0.9)
    else
        TMGCore.Functions.Notify("Seatbelt Unfastened", "error")
        TriggerEvent('InteractSound_CL:PlayOnOne', 'unbuckle', 0.9)
    end

    TriggerEvent('seatbelt:client:ToggleSeatbelt', seatbeltOn)
    
    SetTimeout(500, function()
        isToggling = false
    end)
end, false)


exports('isSeatbeltOn', function()
    return seatbeltOn
end)
RegisterKeyMapping('toggleseatbelt', 'Toggle Seatbelt', 'keyboard', 'B')



RegisterNetEvent('seatbelt:client:UseHarness', function(ItemData)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local class = GetVehicleClass(veh)
    
    if veh == 0 or class == 8 or class == 13 or class == 14 then
        TMGCore.Functions.Notify(Lang:t('seatbelt.no_car'), 'error')
        return
    end

    if isProcessing then return end
    isProcessing = true

    local isEquipping = not harnessOn
    local progressText = isEquipping and Lang:t('seatbelt.use_harness_progress') or Lang:t('seatbelt.remove_harness_progress')

    LocalPlayer.state:set("inv_busy", true, true)

    TMGCore.Functions.Progressbar("harness_equip", progressText, 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() 
        isProcessing = false
        LocalPlayer.state:set("inv_busy", false, true)

        if IsPedInAnyVehicle(ped, false) then
            toggleHarness() 
            
            if isEquipping then
                harnessHp = ItemData.info.uses or 100
                harnessData = ItemData
                TriggerServerEvent('equip:harness', ItemData) 
                TriggerEvent('hud:client:UpdateHarness', harnessHp)
                TMGCore.Functions.Notify("Racing harness secured", "success")
            else
                harnessHp = 0
                harnessData = nil
                TriggerEvent('hud:client:UpdateHarness', 0)
                TMGCore.Functions.Notify("Racing harness removed", "primary")
            end
        else
            TMGCore.Functions.Notify("Action failed: You left the vehicle", "error")
        end
    end, function() 
        isProcessing = false
        LocalPlayer.state:set("inv_busy", false, true)
        TMGCore.Functions.Notify(Lang:t('consumables.canceled'), 'error')
    end)
end)

local isToggling = false 

RegisterCommand('toggleseatbelt', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    
    if veh == 0 or IsPauseMenuActive() or isToggling then return end
    
    local class = GetVehicleClass(veh)
    if class == 8 or class == 13 or class == 14 then return end

    isToggling = true
    
    toggleSeatbelt() 
    SetTimeout(500, function()
        isToggling = false
    end)
end, false)

RegisterKeyMapping('toggleseatbelt', 'Toggle Seatbelt', 'keyboard', 'B')
