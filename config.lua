Config = {}
Config.DiscordWebhook = "" --put your webhook here
Config.DiscordBotName = "juSa Weapon Modify"
Config.DiscordAvatar = "https://i.postimg.cc/TYm9DdHT/jusa-scripts.png"
Config.usewebhook = true

Config.command = "SN_scratch" --command to open menu to choose a weapon
Config.useLocation = false --if true the command is disabled
Config.useTownRestrictions = false --restricts command using in towns (see town settings in config)

Config.applyJobSpecifications = true --set true if u want to permit or restrict players with/without jobs
Config.jobRestriction = { --states that players with these jobs are not allowed to remove SN | leave blank if you do not want any restrictions
    { name = "SheriffV", grade = 0 },
}
Config.jobPermission = { --specifies which job players need to remove SN | leave blank if you do not want any restrictions
    --{ name = "SheriffV", grade = 0 },
}

Config.ItemNeeded = true -- set to true if players need item(s) to remove the SN
Config.LightItem = {DBname = "rock" , Label = "Stein" , amount = 1, consumed = false } -- removes just part of the weapon SN
Config.StrongItem = {DBname = "wisteria_tincture" , Label = "Blauregen Tinktur" , amount = 1 , consumed = true } -- removes SN totaly

------------------- TRANSLATE HERE --------------
Config.Language = {
    --Notify
    noweapons = "No weapons found in your inventory.",
    noitem = "Looks like you don't have the necessary item(s).",
    removedSN = ": Serial number has been manipulated.",
    errorRemove = "Error removing the serial number.",
    jobRestriction = " Looks like you have the wrong job for this. ",
    CommandRestriction = "You are not allowed to use this. Look elsewhere ...",
    --Menu
    title = "weapons list",
    SN = "Serial Number ",
    --ItemModify
    strongItemSN = " illegible ",
    strongItemDesc = "The serial number has been made illegible.",
    lightItemDesc = "The serial number got partially obscured.",
    --Notify
    NotifyTitle = "Weapon Modify:",
    inTown = "You are being watched. Better do it somewhere else.",
    --Webhook
    webhook_changed = "Changed the serial number from: ",
    webhook_from = " from ",
    webhook_to = " to ",
    --prompts
    press = "press ",
    use = "Modify your weapon ..."
}
------------------- Interaction -----------------
Config.keys = {
    G = 0x760A9C6F, -- talk/interact
}
------------------- Don't touch -----------------
Config.Towns = {
    { name = "Annesburg",  allowed = false },
    { name = "Armadillo",  allowed = false },
    { name = "Blackwater", allowed = false },
    { name = "Lagras",     allowed = false },
    { name = "Rhodes",     allowed = false },
    { name = "StDenis",    allowed = false },
    { name = "Strawberry", allowed = false },
    { name = "Tumbleweed", allowed = false },
    { name = "Valentine",  allowed = false },
    { name = "Vanhorn",    allowed = false },
}
Config.Location = {
    coords = vector3( 1249.79, 1154.76, 151.23),
    radius = 5.0, --interaction radius
}