local pretty = require(".pretty")

Farmers = Farmers or {}
FarmersIndex = 1

Farms = Farms or {}
FarmsIndex = 1

Admin = Admin or {}

function SetAdmin(newAdmin)
    table.insert(Admin, newAdmin)
end

Handlers.add("SetAdmin", Handlers.utils.hasMatchingTag("Action", "Set-Admin"), function(msg)
    local newAdmin = msg.From
    SetAdmin(newAdmin)
    Handlers.utils.reply("Admin has been set to: " .. newAdmin)
end)

Handlers.add("Register-Farmer", Handlers.utils.hasMatchingTag("Action", "Register-Farmer"), function(msg)

    local name = msg.Name
    local message = name .. " has been added"
    local newFarmer = {
        id = FarmersIndex,
        name = name,
        address = msg.From
    }

    ao.send({
        Target = msg.From,
        Data = message
    })

    Farmers[FarmersIndex] = newFarmer
    FarmersIndex = FarmersIndex + 1

end)

Handlers.add("Onboard-Farms", Handlers.utils.hasMatchingTag("Action", "Onboard-Farms"), function(msg)

    local newFarm = {
        owner = msg.From,
        availableShares = 500,
        id = FarmsIndex,
        farmName = msg.FarmName,
        location = msg.Location
    }

    local message = newFarm.farmName .. " has been added"

    ao.send({
        Target = msg.From,
        Data = message
    })

    Farms[FarmsIndex] = newFarm
    FarmsIndex = FarmsIndex + 1

end)

function GetFarmers()
    local formatted = pretty.tprint({
        farmers = Farmers
    })
    return formatted
end

function GetCurrentTime()
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    return currentTime
end
