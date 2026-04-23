local entZones = {}


local function deleteTargetObject(data)
    local model = type(data.model) == 'string' and joaat(data.model) or data.model
    
    CreateThread(function()
        local attempts = 0
        while attempts < 3 do
            local ent = GetClosestObjectOfType(data.coords.x, data.coords.y, data.coords.z, 5.0, model, false, false, false)
            
            if DoesEntityExist(ent) then
                SetEntityAsMissionEntity(ent, true, true)
                DeleteObject(ent)
                SetEntityAsNoLongerNeeded(ent)
                return 
            end
            
            attempts = attempts + 1
            Wait(500)
        end
    end)
end

RegisterNetEvent('TMGCore:Client:OnPlayerLoaded', function()
    for _, zone in pairs(entZones) do zone:destroy() end
    entZones = {}

    for k, v in pairs(Config.Objects) do
        local zoneName = "deleter_" .. k
        entZones[k] = BoxZone:Create(v.coords, v.length, v.width, {
            name = zoneName,
            debugPoly = false,
            heading = v.heading or 0
        })

        entZones[k]:onPlayerInOut(function(isPointInside)
            if isPointInside then
                deleteTargetObject(v)
            end
        end)
    end
end)
