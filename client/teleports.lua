local teleportPoly = {}
local isMenuOpen = false


local function teleportMenu(groupIndex, padIndex)
    local menu = {}
    local group = Config.Teleports[groupIndex]
    local currentPad = group[padIndex]

    for k, v in pairs(group) do
        if k ~= padIndex then
            local label = v.label or Lang:t('teleport.teleport_default')
            
            menu[#menu + 1] = {
                header = label,
                params = {
                    event = 'teleports:chooseloc',
                    args = {
                        car = currentPad.allowVeh, 
                        coords = v.poly.coords,
                        heading = v.poly.heading
                    }
                }
            }
        end
    end
    exports['tmg-menu']:openMenu(menu)
end


CreateThread(function()
    
    for i = 1, #Config.Teleports do
        for u = 1, #Config.Teleports[i] do
            local portal = Config.Teleports[i][u].poly
            
            teleportPoly[#teleportPoly + 1] = BoxZone:Create(
                vector3(portal.coords.x, portal.coords.y, portal.coords.z), 
                portal.length, portal.width, 
                {
                    heading = portal.heading,
                    name = tostring(i), 
                    debugPoly = false,
                    minZ = portal.coords.z - 2.0,
                    maxZ = portal.coords.z + 2.0,
                    data = { pad = u } 
                }
            )
        end
    end

    local teleportCombo = ComboZone:Create(teleportPoly, {name = 'teleportCombo'})
    
    teleportCombo:onPlayerInOut(function(isPointInside, _, zone)
        if isPointInside then
            if not isMenuOpen then
                isMenuOpen = true
                teleportMenu(tonumber(zone.name), zone.data.pad)
            end
        else
            isMenuOpen = false
            exports['tmg-menu']:closeMenu()
        end
    end)
end)

RegisterNetEvent('teleports:chooseloc', function(data)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(10) end

    if data.car and veh ~= 0 then
        SetEntityCoords(veh, data.coords.x, data.coords.y, data.coords.z)
        SetEntityHeading(veh, data.heading)
    else
        SetEntityCoords(ped, data.coords.x, data.coords.y, data.coords.z)
        SetEntityHeading(ped, data.heading)
    end

    RequestCollisionAtCoord(data.coords.x, data.coords.y, data.coords.z)
    local timeout = 0
    while not HasCollisionLoadedAroundEntity(ped) and timeout < 100 do
        Wait(10)
        timeout = timeout + 1
    end

    Wait(500)
    DoScreenFadeIn(500)
end)
