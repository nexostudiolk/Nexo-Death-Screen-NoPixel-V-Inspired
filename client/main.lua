local visible = false
local isTesting = false

local function Update(data)
    data = data or {}
    local texts = Config.Texts
    visible = true
    SendNUIMessage({
        action = 'update',
        position = Config.Position,
        title = data.title or (data.state == 'incapacitated' and texts.incapacitated or texts.dead),
        subtitle = data.subtitle or texts.doctorWait,
        timer = data.timer or '00:00',
        showTimer = data.showTimer ~= false,
        showRespawn = data.showRespawn or false,
        holdTime = data.holdTime or Config.HoldTime,
        holdKey = Config.HoldKey,
        holdPrefix = texts.holdPrefix,
        holdSuffix = texts.holdSuffix
    })
end

local function Hide()
    visible = false
    isTesting = false
    SendNUIMessage({ action = 'hide' })
end

local function SetHold(seconds)
    SendNUIMessage({ action = 'updateHold', holdTime = seconds })
end

exports('Update', Update)
exports('Hide', Hide)
exports('SetHold', SetHold)
exports('IsVisible', function() return visible end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then Hide() end
end)

AddEventHandler('onClientResourceStart', function(res)
    if res == GetCurrentResourceName() then Hide() end
end)

RegisterCommand('deathscreen_hide', Hide, false)

if Config.Debug then
    RegisterCommand('deathscreen_test', function(_, args)
        local mode = args[1] or 'dead'
        isTesting = true
        if mode == 'respawn' then
            Update({ state = 'dead', showRespawn = true, showTimer = false })
        else
            Update({ state = mode, timer = '05:00' })
        end
    end, false)
end

local function FormatTime(seconds)
    seconds = math.floor(tonumber(seconds) or 0)
    if seconds < 0 then seconds = 0 end
    return string.format('%02d:%02d', seconds // 60, seconds % 60)
end

-- State bag handler for Qbox medical and standard isDead bag
local myServerId = GetPlayerServerId(PlayerId())
AddStateBagChangeHandler('qbx_medical:deathState', ('player:%s'):format(myServerId), function(_, _, value)
    if value == 1 then -- ALIVE
        Hide()
    elseif value == 2 then -- LAST_STAND
        Update({ state = 'incapacitated' })
    elseif value == 3 then -- DEAD
        Update({ state = 'dead' })
    end
end)

AddStateBagChangeHandler('isDead', ('player:%s'):format(myServerId), function(_, _, value)
    if value == false then
        Hide()
    end
end)

-- Background loop to keep timer updated and auto-hide if player is alive
CreateThread(function()
    while true do
        if visible and not isTesting then
            local isAlive = false

            if GetResourceState('qbx_medical') == 'started' then
                local isDead = exports.qbx_medical:IsDead()
                local isLaststand = exports.qbx_medical:IsLaststand()

                if not isDead and not isLaststand then
                    isAlive = true
                elseif isLaststand then
                    local laststandTime = exports.qbx_medical:GetLaststandTime()
                    Update({
                        state = 'incapacitated',
                        timer = FormatTime(laststandTime),
                        showRespawn = false,
                    })
                elseif isDead then
                    local deathTime = exports.qbx_medical:GetDeathTime()
                    if deathTime and deathTime > 0 then
                        Update({
                            state = 'dead',
                            timer = FormatTime(deathTime),
                            showRespawn = false,
                        })
                    else
                        local holdTime = exports.qbx_medical:GetRespawnHoldTimeDeprecated() or Config.HoldTime
                        Update({
                            state = 'dead',
                            showRespawn = true,
                            showTimer = false,
                            holdTime = holdTime,
                        })
                    end
                end
            else
                local ped = PlayerPedId()
                if not IsEntityDead(ped) and not IsPedFatallyInjured(ped) and not IsPedDeadOrDying(ped, true) then
                    if LocalPlayer.state.isDead == false or (LocalPlayer.state.isDead == nil and GetEntityHealth(ped) > 0) then
                        isAlive = true
                    end
                end
            end

            if isAlive then
                Hide()
            end
            Wait(1000)
        else
            Wait(500)
        end
    end
end)

local function RegisterIntegrationEvents()
    local cfg = Config.Integrations
    if not cfg or not cfg.Enabled then return end

    for _, entry in ipairs(cfg.IncapacitatedEvents or {}) do
        local name = type(entry) == 'table' and entry.name or entry
        local timeArg = type(entry) == 'table' and entry.timeArg or nil
        if name then
            RegisterNetEvent(name)
            AddEventHandler(name, function(...)
                local args = { ... }
                local seconds = timeArg and args[timeArg] or nil
                Update({
                    state = 'incapacitated',
                    timer = seconds and FormatTime(seconds) or nil
                })
            end)
        end
    end

    for _, entry in ipairs(cfg.DeadEvents or {}) do
        local name = type(entry) == 'table' and entry.name or entry
        local timeArg = type(entry) == 'table' and entry.timeArg or nil
        if name then
            RegisterNetEvent(name)
            AddEventHandler(name, function(...)
                local args = { ... }
                local seconds = timeArg and args[timeArg] or nil
                Update({
                    state = 'dead',
                    timer = seconds and FormatTime(seconds) or nil
                })
            end)
        end
    end

    for _, entry in ipairs(cfg.ReviveEvents or {}) do
        local name = type(entry) == 'table' and entry.name or entry
        if name then
            RegisterNetEvent(name)
            AddEventHandler(name, function()
                Hide()
            end)
        end
    end
end

RegisterIntegrationEvents()
