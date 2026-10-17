Config = {}

Config.Position = 'bottom' 
Config.HoldKey = 'E'       
Config.HoldTime = 5        

Config.Texts = {
    dead = 'YOU ARE DEAD',
    incapacitated = 'YOU ARE INCAPACITATED',
    doctorWait = 'PLEASE WAIT FOR DOCTORS, EVERYTHING WILL BE FINE.',
    holdPrefix = 'HOLD',
    holdSuffix = 'TO RESPAWN OR WAIT FOR THE EMS',
}

Config.Debug = false 


Config.Integrations = {
    Enabled = true, 

    -- Fired when the player goes into incapacitated / laststand
    IncapacitatedEvents = {
        { name = 'hospital:client:SetLaststandStatus', timeArg = 1 },
        { name = 'codera-deathscreen:die',             timeArg = 1 },
        { name = 'qbx_medical:client:onPlayerLaststand' },
       -- { name = 'qbx_medical:client:onPlayerLaststand' }, You can Add More Ambulance jobs 
       --{ name = 'qbx_medical:client:onPlayerLaststand' },
      -- { name = 'qbx_medical:client:onPlayerLaststand' },
       --{ name = 'qbx_medical:client:onPlayerLaststand' },
    },

    -- Fired on full death
    DeadEvents = {
        { name = 'baseevents:onPlayerDied' },
        { name = 'qbx_medical:client:onPlayerDied' },
    },

    -- Fired on revive / respawn (hides the screen)
    ReviveEvents = {
        'hospital:client:Revive',
        'hospital:client:RespawnAtHospital',
        'qbx_medical:client:playerRevived',
        'qbx_ambulancejob:client:checkedIn',
        'qbx_ambulancejob:client:putPlayerInBed',
        'QBCore:Client:OnPlayerLoaded',
        'qbx_core:client:playerLoaded',
        'playerSpawned',
        'NX-deathscreen:revive',
        'esx_ambulancejob:revive',
        'wasabi_ambulance:revive',
        'wasabi_ambulance:clearInjury',
    },
}

