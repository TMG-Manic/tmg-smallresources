local disableHudComponents = Config.Disable.hudComponents
local disableControls = Config.Disable.controls
local displayAmmo = Config.Disable.displayAmmo

local function decorSet(Type, Value)
    if Type == 'parked' then
        Config.Density.parked = Value
    elseif Type == 'vehicle' then
        Config.Density.vehicle = Value
    elseif Type == 'multiplier' then
        Config.Density.multiplier = Value
    elseif Type == 'peds' then
        Config.Density.peds = Value
    elseif Type == 'scenario' then
        Config.Density.scenario = Value
    end
end

exports('DecorSet', decorSet)

CreateThread(function()
    while true do
        local controlCount = #disableControls
        if controlCount > 0 then
            for i = 1, controlCount do
                DisableControlAction(0, disableControls[i], true)
            end
        end

        local hudCount = #disableHudComponents
        if hudCount > 0 then
            for i = 1, hudCount do
                HideHudComponentThisFrame(disableHudComponents[i])
            end
        end

        DisplayAmmoThisFrame(displayAmmo)

        if Config.Density.parked ~= 1.0 then SetParkedVehicleDensityMultiplierThisFrame(Config.Density.parked) end
        if Config.Density.vehicle ~= 1.0 then SetVehicleDensityMultiplierThisFrame(Config.Density.vehicle) end
        if Config.Density.multiplier ~= 1.0 then SetRandomVehicleDensityMultiplierThisFrame(Config.Density.multiplier) end
        if Config.Density.peds ~= 1.0 then SetPedDensityMultiplierThisFrame(Config.Density.peds) end
        if Config.Density.scenario ~= 1.0 then 
            SetScenarioPedDensityMultiplierThisFrame(Config.Density.scenario, Config.Density.scenario) 
        end

        Wait(0)
    end
end)

exports('addDisableHudComponents', function(hudComponents)
    local hudComponentsType = type(hudComponents)
    if hudComponentsType == 'number' then
        disableHudComponents[#disableHudComponents + 1] = hudComponents
    elseif hudComponentsType == 'table' and table.type(hudComponents) == "array" then
        for i = 1, #hudComponents do
            disableHudComponents[#disableHudComponents + 1] = hudComponents[i]
        end
    end
end)

exports('removeDisableHudComponents', function(hudComponents)
    local hudComponentsType = type(hudComponents)
    if hudComponentsType == 'number' then
        for i = 1, #disableHudComponents do
            if disableHudComponents[i] == hudComponents then
                table.remove(disableHudComponents, i)
                break
            end
        end
    elseif hudComponentsType == 'table' and table.type(hudComponents) == "array" then
        for i = 1, #disableHudComponents do
            for i2 = 1, #hudComponents do
                if disableHudComponents[i] == hudComponents[i2] then
                    table.remove(disableHudComponents, i)
                end
            end
        end
    end
end)

exports('getDisableHudComponents', function() return disableHudComponents end)

exports('addDisableControls', function(controls)
    if type(controls) == 'number' then
        disableControls[#disableControls + 1] = controls
    elseif type(controls) == 'table' then
        for _, control in ipairs(controls) do
            disableControls[#disableControls + 1] = control
        end
    end
end)

exports('removeDisableControls', function(controls)
    local newList = {}
    local toRemove = type(controls) == 'table' and controls or {controls}
    
    for i = 1, #disableControls do
        local found = false
        for j = 1, #toRemove do
            if disableControls[i] == toRemove[j] then
                found = true
                break
            end
        end
        if not found then
            newList[#newList + 1] = disableControls[i]
        end
    end
    disableControls = newList
end)

exports('getDisableControls', function() return disableControls end)

exports('setDisplayAmmo', function(bool) displayAmmo = bool end)

exports('getDisplayAmmo', function() return displayAmmo end)
