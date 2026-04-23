
local function SetRespectRelationships()
    local groups = {
        `AMBIENT_GANG_HILLBILLY`,
        `AMBIENT_GANG_BALLAS`,
        `AMBIENT_GANG_MEXICAN`,
        `AMBIENT_GANG_FAMILY`,
        `AMBIENT_GANG_MARABUNTE`,
        `AMBIENT_GANG_SALVA`,
        `AMBIENT_GANG_LOST`,
        `GANG_1`,
        `GANG_2`,
        `GANG_9`,
        `GANG_10`,
        `FIREMAN`,
        `MEDIC`,
        `COP`,
        `PRISONER`
    }

    local playerGroup = `PLAYER`

    for i = 1, #groups do
        local targetGroup = groups[i]
        
        SetRelationshipBetweenGroups(1, targetGroup, playerGroup)
        
        SetRelationshipBetweenGroups(1, playerGroup, targetGroup)
    end
end

CreateThread(function()
    SetRespectRelationships()
    
    while true do
        Wait(30000)
        SetRespectRelationships()
    end
end)