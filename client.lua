local VORPcore = {}
local VORPInv = {}
local progressbar = exports.vorp_progressbar:initiate()
local Animations = exports.vorp_animations.initiate()
local prompts = GetRandomIntInRange(0, 0xffffff)

local PlayerIsRestricted = false
local PlayerIsPermitted = false
local towns = {}

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

Citizen.CreateThread(function() --create interactiv prompt
    Citizen.Wait(5000)
    local press = Config.Language.press
    interact = PromptRegisterBegin()
    PromptSetControlAction(interact, Config.keys["G"])
    press = CreateVarString(10, 'LITERAL_STRING', press)
    PromptSetText(interact, press)
    PromptSetEnabled(interact, 1)
    PromptSetVisible(interact, 1)
    PromptSetStandardMode(interact, 1)
    PromptSetHoldMode(interact, 1)
    PromptSetGroup(interact, prompts)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, interact, true)
    PromptRegisterEnd(interact)
end)

RegisterCommand(Config.command, function()
    if not Config.useLocation then --when using location is disabled -> use command
        if Config.useTownRestrictions then
            towns = RegisterTownRestriction()
            local restricted = isInRestrictedTown(towns, playerCoords)
            if restricted then
                TriggerEvent('vorp:NotifyLeft', Config.Language.NotifyTitle, Config.Language.inTown, "BLIPS", "blip_destroy", 4000, "COLOR_RED")
            else
                if Config.applyJobSpecifications then
                    TriggerServerEvent("juSa_weapon_modify:checkJob") --checking if there are any restrictions
                    Wait(500)
                    if PlayerIsPermitted and not PlayerIsRestricted then
                        TriggerServerEvent("juSa_weapon_modify:getAllWeaponsForMenu") --get all weapons in players inv
                    else
                        VORPcore.NotifyRightTip(Config.Language.jobRestriction, 3000)
                    end
                else 
                    TriggerServerEvent("juSa_weapon_modify:getAllWeaponsForMenu") --get all weapons in players inv
                end
            end
        else
            if Config.applyJobSpecifications then
                TriggerServerEvent("juSa_weapon_modify:checkJob") --checking if there are any restrictions
                Wait(500)
                if PlayerIsPermitted and not PlayerIsRestricted then
                    TriggerServerEvent("juSa_weapon_modify:getAllWeaponsForMenu") --get all weapons in players inv
                else
                    VORPcore.NotifyRightTip(Config.Language.jobRestriction, 3000)
                end
            else 
                TriggerServerEvent("juSa_weapon_modify:getAllWeaponsForMenu") --get all weapons in players inv
            end
        end
    else
        VORPcore.NotifyRightTip(Config.Language.CommandRestriction, 3000)
    end
end, false)

Citizen.CreateThread(function() 
    while true do
        local sleep = true
        if Config.useLocation then
            sleep = false
            local playerCoords = GetEntityCoords(PlayerPedId())
            if  Vdist(playerCoords, Config.Location.coords) <= Config.Location.radius then -- Checking distance between player and npc
                local label = CreateVarString(10, 'LITERAL_STRING', Config.Language.use)
                PromptSetActiveGroupThisFrame(prompts, label) --load useshovle prompt
                if Citizen.InvokeNative(0xC92AC953F0A982AE, interact) then --if pressing the interaction-key
                    if Config.applyJobSpecifications then
                        TriggerServerEvent("juSa_weapon_modify:checkJob") --checking if there are any restrictions
                        Wait(500)
                        if PlayerIsPermitted and not PlayerIsRestricted then
                            TriggerServerEvent("juSa_weapon_modify:getAllWeaponsForMenu") --get all weapons in players inv
                        else
                            VORPcore.NotifyRightTip(Config.Language.jobRestriction, 3000)
                        end
                    else 
                        TriggerServerEvent("juSa_weapon_modify:getAllWeaponsForMenu") --get all weapons in players inv
                    end
                end
            end
            Citizen.Wait(1)
        end
        if sleep then
            Citizen.Wait(500)
        end
    end
end)

RegisterNetEvent("juSa_weapon_modify:openWeaponMenu")
AddEventHandler("juSa_weapon_modify:openWeaponMenu", function(weapons) --opens menu with 1 entry for every weapon in players inv
    local elements = {}

    for i, weapon in ipairs(weapons) do -- load weapons and names
        table.insert(elements, {
            label = weapon.label, 
            value = weapon.id,
            desc = Config.Language.SN..weapon.serial_number.." \n"--..weapon.desc
        })
    end

    VORPcore.Menu.Open("default", GetCurrentResourceName(), "weapon_menu", {
        title = Config.Language.title,
        align = "top-left",
        elements = elements
    }, function(data, menu)
        TriggerServerEvent("juSa_weapon_modify:removeWeaponSerial", data.current.value)
        menu.close() 
    end, function(data, menu)
        menu.close()
    end)
end)

RegisterNetEvent("juSa_weapon_modify:notify")
AddEventHandler("juSa_weapon_modify:notify", function(message)
    VORPcore.NotifyRightTip(message, 3000)
end)

RegisterNetEvent("juSa_weapon_modify:jobchecked")
AddEventHandler("juSa_weapon_modify:jobchecked", function(isrestricted, ispermitted)
    if isrestricted then
        PlayerIsRestricted = true
    elseif ispermitted then
        PlayerIsPermitted = true
    end
end)

function isInRestrictedTown(towns, playerCoords) --checks if player is in restricted arial
    player_coords = playerCoords or GetEntityCoords(PlayerPedId())
    local x, y, z = table.unpack(player_coords)
    local town_hash = GetTown(x, y, z)
    if town_hash == false then
        return false
    end
    if towns[town_hash] then
        return true
    end
    return false
end

function GetTown(x, y, z) --get map zone at this coords
    return Citizen.InvokeNative(0x43AD8FC02B429D33, x, y, z, 1)
end

function RegisterTownRestriction() --checking towns from config
    local towns = {}
    for i, town in pairs(Config.Towns) do
        if not town.allowed then
            local town_hash = GetHashKey(town.name)
            towns[town_hash] = town.name
        end
    end
    return towns
end