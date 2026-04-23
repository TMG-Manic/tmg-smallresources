local binoculars = false
local fov_max = 70.0
local fov_min = 5.0
local fov = (fov_max + fov_min) * 0.5
local speed_lr = 8.0
local speed_ud = 8.0
local scaleform = nil
local cam = nil



local function HideHUDThisFrame()
    HideHudAndRadarThisFrame()
    HideHelpTextThisFrame()
    DisableControlAction(0, 37, true) 
    DisableControlAction(0, 24, true) 
    DisableControlAction(0, 25, true) 
    DisableControlAction(0, 140, true) 
end

local function checkInputRot(currentCam, zoomValue)
    local rightAxisX = GetDisabledControlNormal(0, 220)
    local rightAxisY = GetDisabledControlNormal(0, 221)
    
    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        local rot = GetCamRot(currentCam, 2)
        local speed = speed_ud * (zoomValue + 0.1)
        
        local new_z = rot.z + rightAxisX * -1.0 * speed
        local new_x = math.max(math.min(20.0, rot.x + rightAxisY * -1.0 * speed), -89.5)
        
        SetCamRot(currentCam, new_x, 0.0, new_z, 2)
        
        if math.abs(GetEntityHeading(PlayerPedId()) - new_z) > 1.5 then
            SetEntityHeading(PlayerPedId(), new_z)
        end
    end
end

local function handleZoom(currentCam)
    local ped = PlayerPedId()
    local scrollUp = IsPedSittingInAnyVehicle(ped) and 17 or 241
    local scrollDown = IsPedSittingInAnyVehicle(ped) and 16 or 242
    local zoomSpeed = Config.Binoculars.zoomSpeed or 5.0

    if IsControlJustPressed(0, scrollUp) then
        fov = math.max(fov - zoomSpeed, fov_min)
    elseif IsControlJustPressed(0, scrollDown) then
        fov = math.min(fov + zoomSpeed, fov_max)
    end

    local current_fov = GetCamFov(currentCam)
    if math.abs(fov - current_fov) < 0.1 then
        fov = current_fov
    end

    SetCamFov(currentCam, current_fov + (fov - current_fov) * 0.05)
end


function binocularLoop()
    CreateThread(function()
        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped) or IsEntityDead(ped) then 
            binoculars = false
            return 
        end

        if not scaleform then
            scaleform = RequestScaleformMovie('BINOCULARS')
            local timeout = 0
            while not HasScaleformMovieLoaded(scaleform) and timeout < 100 do
                Wait(10)
                timeout = timeout + 1
            end
        end

        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_BINOCULARS', 0, true)
        Wait(2000)

        if not binoculars then return end

        cam = CreateCam('DEFAULT_SCRIPTED_FLY_CAMERA', true)
        AttachCamToEntity(cam, ped, 0.0, 0.0, 0.6, true)
        SetCamRot(cam, 0.0, 0.0, GetEntityHeading(ped), 2)
        SetCamFov(cam, fov)
        RenderScriptCams(true, true, 500, true, false)
        while binoculars and not IsEntityDead(ped) do
            Wait(0)
            
            local exitKey = Config.Binoculars.storeBinocularsKey or 177
            if IsControlJustPressed(0, exitKey) or IsPedInAnyVehicle(ped) then
                binoculars = false
            end

            local zoomValue = (1.0 / (fov_max - fov_min)) * (fov - fov_min)
            checkInputRot(cam, zoomValue)
            handleZoom(cam)
            HideHUDThisFrame()
            
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
        end

        binoculars = false
        ClearPedTasks(ped)
        RenderScriptCams(false, true, 500, true, false)
        
        if cam then
            DestroyCam(cam, false)
            cam = nil
        end
        
        if scaleform then
            SetScaleformMovieAsNoLongerNeeded(scaleform)
            scaleform = nil
        end
        
        ClearTimecycleModifier()
        SetNightvision(false)
        SetSeethrough(false)
    end)
end


RegisterNetEvent('binoculars:Toggle', function()
    binoculars = not binoculars
    if binoculars then 
        binocularLoop() 
    else
        ClearPedTasks(PlayerPedId())
    end
end)
