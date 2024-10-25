local VORPcore = {}

local PlayerIsRestricted = false
local PlayerIsPermitted = false

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

RegisterCommand(Config.command, function()
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
end, false)

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