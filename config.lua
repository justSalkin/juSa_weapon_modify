Config = {}

Config.command = "SN_scratch" --command to open menu to choose a weapon

Config.applyJobSpecifications = false --set true if u want to permit or restrict players with/without jobs
Config.jobRestriction = { --states that players with these jobs are not allowed to remove SN | leave blank if you do not want any restrictions
    { name = "police", grade = 0 },
}
Config.jobPermission = { --specifies which job players need to remove SN | leave blank if you do not want any restrictions
    { name = "blacksmith", grade = 3 },
}

Config.ItemNeeded = true -- set to true if players need item(s) to remove the SN
Config.LightItem = {DBname = "rock" , Label = "Rock" , amount = 1, consumed = false } -- removes just part of the weapon SN (every 3. Number = /)
Config.StrongItem = {DBname = "acid" , Label = "Acid" , amount = 1 , consumed = true } -- removes SN totaly

------------------- TRANSLATE HERE --------------
Config.Language = {
    --Notify
    noweapons = "No weapons found in your inventory.",
    noitem = "Looks like you don't have the necessary item(s).",
    removedSN = ": Serial number has been manipulated.",
    errorRemove = "Error removing the serial number.",
    jobRestriction = " Looks like you have the wrong job for this. ",
    --Menu
    title = "weapons list",
    SN = "Serial Number ",
    --ItemModify
    strongItemSN = " illegible ",
    strongItemDesc = "The serial number has been made illegible.",
    lightItemDesc = "The serial number got partially obscured."
}