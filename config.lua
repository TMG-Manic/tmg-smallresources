Config = {}
TMGCore = exports['tmg-core']:GetCoreObject()
Config.UseTarget = GetConvar('UseTarget', 'false') == 'true' 
Config.PauseMapText = ''                                     
Config.HarnessUses = 20
Config.DamageNeeded = 100.0                                  
Config.Logging = 'discord'                                   

Config.AFK = {
    ignoredGroups = {
        ['mod'] = true,
        ['admin'] = true,
        ['god'] = true
    },
    secondsUntilKick = 1000000, 
    kickInCharMenu = false      
}

Config.HandsUp = {
    command = 'hu',
    keybind = 'X',
    controls = { 24, 25, 47, 58, 59, 63, 64, 71, 72, 75, 140, 141, 142, 143, 257, 263, 264 }
}

Config.Binoculars = {
    zoomSpeed = 10.0,        
    storeBinocularsKey = 177 
}

Config.AIResponse = {
    wantedLevels = false, 
    dispatchServices = {  
        [1] = false,      
        [2] = false,      
        [3] = false,      
        [4] = false,      
        [5] = false,      
        [6] = false,      
        [7] = false,      
        [8] = false,      
        [9] = false,      
        [10] = false,     
        [11] = false,     
        [12] = false,     
        [13] = false,     
        [14] = false,     
        [15] = false      
    }
}


Config.Discord = {
    isEnabled = false,                                     
    applicationId = '00000000000000000',                   
    iconLarge = 'logo_name',                               
    iconLargeHoverText = 'This is a Large icon with text', 
    iconSmall = 'small_logo_name',                         
    iconSmallHoverText = 'This is a Small icon with text', 
    updateRate = 60000,                                    
    showPlayerCount = true,                                
    maxPlayers = 48,                                       
    buttons = {
        {
            text = 'First Button!',
            url = 'fivem://connect/localhost:30120'
        },
        {
            text = 'Second Button!',
            url = 'fivem://connect/localhost:30120'
        }
    }
}

Config.Density = {
    parked = 0.8,
    vehicle = 0.8,
    multiplier = 0.8,
    peds = 0.8,
    scenario = 0.8
}

Config.Disable = {
    hudComponents = { 1, 2, 3, 4, 7, 9, 13, 14, 19, 20, 21, 22 }, 
    controls = { 37 },                                            
    displayAmmo = true,                                           
    ambience = false,                                             
    idleCamera = true,                                            
    vestDrawable = false,                                         
    pistolWhipping = true,                                        
    driveby = false,                                              
    carRadio = false                                              
}

Config.RelieveWeedStress = math.random(15, 20) 

Config.Consumables = {
    eat = { 
        ['sandwich'] = math.random(35, 54),
        ['tosti'] = math.random(40, 50),
        ['twerks_candy'] = math.random(35, 54),
        ['snikkel_candy'] = math.random(40, 50)
    },
    drink = { 
        ['water_bottle'] = math.random(35, 54),
        ['kurkakola'] = math.random(35, 54),
        ['coffee'] = math.random(40, 50)
    },
    alcohol = { 
        ['whiskey'] = math.random(20, 30),
        ['beer'] = math.random(30, 40),
        ['vodka'] = math.random(20, 40),
    },
    custom = { 
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
}

Config.Fireworks = {
    delay = 5, 
    items = {  
        'firework1',
        'firework2',
        'firework3',
        'firework4'
    }
}

Config.BlacklistedScenarios = {
    types = {
        'WORLD_VEHICLE_MILITARY_PLANES_SMALL',
        'WORLD_VEHICLE_MILITARY_PLANES_BIG',
        'WORLD_VEHICLE_AMBULANCE',
        'WORLD_VEHICLE_POLICE_NEXT_TO_CAR',
        'WORLD_VEHICLE_POLICE_CAR',
        'WORLD_VEHICLE_POLICE_BIKE'
    },
    groups = {
        2017590552,
        2141866469,
        1409640232,
        `ng_planes`
    }
}

Config.BlacklistedVehs = {
    [`shamal`] = true,
    [`luxor`] = true,
    [`luxor2`] = true,
    [`jet`] = true,
    [`lazer`] = true,
    [`buzzard`] = true,
    [`buzzard2`] = true,
    [`annihilator`] = true,
    [`savage`] = true,
    [`titan`] = true,
    [`rhino`] = true,
    [`firetruck`] = true,
    [`mule`] = true,
    [`maverick`] = true,
    [`blimp`] = true,
    [`airtug`] = true,
    [`camper`] = true,
    [`hydra`] = true,
    [`oppressor`] = true,
    [`technical3`] = true,
    [`insurgent3`] = true,
    [`apc`] = true,
    [`tampa3`] = true,
    [`trailersmall2`] = true,
    [`halftrack`] = true,
    [`hunter`] = true,
    [`vigilante`] = true,
    [`akula`] = true,
    [`barrage`] = true,
    [`khanjali`] = true,
    [`caracara`] = true,
    [`blimp3`] = true,
    [`menacer`] = true,
    [`oppressor2`] = true,
    [`scramjet`] = true,
    [`strikeforce`] = true,
    [`cerberus`] = true,
    [`cerberus2`] = true,
    [`cerberus3`] = true,
    [`scarab`] = true,
    [`scarab2`] = true,
    [`scarab3`] = true,
    [`rrocket`] = true,
    [`ruiner2`] = true,
    [`deluxo`] = true,
    [`cargoplane2`] = true,
    [`voltic2`] = true
}

Config.BlacklistedWeapons = {
    [`WEAPON_RAILGUN`] = true,
}

Config.BlacklistedPeds = {
    [`s_m_y_ranger_01`] = true,
    [`s_m_y_sheriff_01`] = true,
    [`s_m_y_cop_01`] = true,
    [`s_f_y_sheriff_01`] = true,
    [`s_f_y_cop_01`] = true,
    [`s_m_y_hwaycop_01`] = true
}

Config.Objects = { 
    { coords = vector3(266.09, -349.35, 44.74), heading = 0, length = 200, width = 200, model = 'prop_sec_barier_02b' },
    { coords = vector3(285.28, -355.78, 45.13), heading = 0, length = 200, width = 200, model = 'prop_sec_barier_02a' },
}


Config.Teleports = {
    [1] = {                   
        [1] = {               
            poly = { coords = vector3(3540.74, 3675.59, 20.99), heading = 167.5, length = 2, width = 2 },
            allowVeh = false, 
            label = false     

        },
        [2] = { 
            poly = { coords = vector3(3540.74, 3675.59, 28.11), heading = 172.5, length = 2, width = 2 },
            allowVeh = false,
            label = false
        }
    },
    [2] = { 
        [1] = {
            poly = { coords = vector3(909.49, -1589.22, 30.51), heading = 92.24, length = 2, width = 2 },
            allowVeh = false,
            label = '[E] Enter Coke Processing'
        },
        [2] = {
            poly = { coords = vector3(1088.81, -3187.57, -38.99), heading = 181.7, length = 2, width = 2 },
            allowVeh = false,
            label = '[E] Leave'
        }
    }
}

Config.CarWash = {
    dirtLevel = 0.1,                                                                                   
    defaultPrice = 20,                                                                                 
    locations = {
        [1] = { coords = vector3(174.81, -1736.77, 28.87), length = 7.0, width = 8.8, heading = 359 }, 
        [2] = { coords = vector3(25.2, -1391.98, 28.91), length = 6.6, width = 8.2, heading = 0 },     
        [3] = { coords = vector3(-74.27, 6427.72, 31.02), length = 9.4, width = 8, heading = 315 },    
        [4] = { coords = vector3(1362.69, 3591.81, 34.5), length = 6.4, width = 8, heading = 21 },     
        [5] = { coords = vector3(-699.84, -932.68, 18.59), length = 11.8, width = 5.2, heading = 0 }   
    }
}
