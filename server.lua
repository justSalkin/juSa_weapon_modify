local VORPcore = {}
local VORPInv = exports.vorp_inventory:vorp_inventoryApi()

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

RegisterServerEvent("juSa_weapon_modify:checkJob")
AddEventHandler("juSa_weapon_modify:checkJob", function()
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local job = Character.job
    local grade = Character.jobGrade
    local isrestricted = false
    local ispermitted = false
    
    if #Config.jobRestriction > 0 then
        for i, v in ipairs(Config.jobRestriction) do
            if v.name == job then
                if v.grade >= grade then
                    isrestricted = true
                end
            end
        end
    end
    
    if #Config.jobPermission > 0 then
        for i, v in ipairs(Config.jobPermission) do
            if v.name == job then
                if v.grade <= grade then
                    ispermitted = true
                end
            end
        end
    else 
        ispermitted = true
    end

    TriggerClientEvent("juSa_weapon_modify:jobchecked", _source, isrestricted, ispermitted)
end)

RegisterServerEvent("juSa_weapon_modify:getAllWeaponsForMenu")
AddEventHandler("juSa_weapon_modify:getAllWeaponsForMenu", function() --get all weapons -> client
    local _source = source 
    exports.vorp_inventory:getUserInventoryWeapons(_source, function(weaponsData)
        if weaponsData and #weaponsData > 0 then
            TriggerClientEvent("juSa_weapon_modify:openWeaponMenu", _source, weaponsData)
        else
            TriggerClientEvent("juSa_weapon_modify:notify", _source, Config.Language.noweapons)
        end
    end)
end)

local function hasRequiredItem(playerId, itemConfig)
    local hasItem = false
    local count = VORPInv.getItemCount(playerId, itemConfig.DBname)
    if count >= itemConfig.amount then
        hasItem = true
        if itemConfig.consumed then
            exports.vorp_inventory:subItem(playerId, itemConfig.DBname, itemConfig.amount)
        end
    end
    return hasItem
end

RegisterServerEvent("juSa_weapon_modify:removeWeaponSerial")
AddEventHandler("juSa_weapon_modify:removeWeaponSerial", function(weaponId)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local firstname = Character.firstname
    local lastname = Character.lastname

    local hasLightItem = hasRequiredItem(_source, Config.LightItem)
    local hasStrongItem = hasRequiredItem(_source, Config.StrongItem)

    if not hasLightItem and not hasStrongItem then
        TriggerClientEvent('juSa_weapon_modify:notify', _source, Config.Language.noitem)
        return
    end

    exports.vorp_inventory:getUserInventoryWeapons(_source, function(weaponsData)
        for i, weapon in ipairs(weaponsData) do
            if weapon.id == weaponId then
                if hasStrongItem then
                    newSerialNumber = Config.Language.strongItemSN
                    newdesc = Config.Language.strongItemDesc
                elseif not hasStrongItem and hasLightItem then
                    local function modifySerialNumber(serial)
                        local modifiedSerial = ""
                        for i = 1, #serial do
                            if i % 3 == 0 then
                                modifiedSerial = modifiedSerial .. "/"
                            else
                                modifiedSerial = modifiedSerial .. serial:sub(i, i)
                            end
                        end
                        return modifiedSerial
                    end
                    newSerialNumber = modifySerialNumber(weapon.serial_number)
                    newdesc = Config.Language.lightItemDesc
                end
                exports.vorp_inventory:setWeaponSerialNumber(weapon.id, newSerialNumber, function(success)
                exports.vorp_inventory:setWeaponCustomDesc(weapon.id, newdesc)

                    if success then
                        TriggerClientEvent("juSa_weapon_modify:notify", _source, weapon.label .. Config.Language.removedSN)
                        if Config.usewebhook then
                            VORPcore.AddWebhook(firstname.." "..lastname, Config.DiscordWebhook, Config.Language.webhook_changed .. weapon.label .. Config.Language.webhook_from .. weapon.serial_number .. Config.Language.webhook_to .. newSerialNumber, 1, Config.DiscordBotName, "", "", Config.DiscordAvatar)
                        end
                    else
                        TriggerClientEvent("juSa_weapon_modify:notify", _source, Config.Language.errorRemove)
                    end

                end)
                break
            end
        end
    end)
end)