PricePerShare = PricePerShare or 2000

Farmers = Farmers or {}
FarmersIndex = 1

Farms = Farms or {}
FarmsIndex = 1

Investors = Investors or {}
InvestorsIndex = 1

Listings = Listings or {}
ListingsIndex = ListingsIndex or 1

Admin = Admin or {"kug8_jXTqTfBt2UxQh7k1gIzHBnUuC8avFIvnZ_DHhE"}

function SetAdmin(newAdmin)
    table.insert(Admin, newAdmin)
end

local function isAdmin(Admin, address)
    for _, admin in ipairs(Admin) do
        if admin == address then
            return true
        end
    end
    return false
end

Handlers.add("SetAdmin", Handlers.utils.hasMatchingTag("Action", "Set-Admin"), function(msg)
    local newAdmin = msg.From

    local isAlreadyAdmin = isAdmin(Admin, newAdmin)

    if isAlreadyAdmin then
        SetAdmin(newAdmin)
        ao.send({
            Target = msg.From,
            Data = "New admin added!"
        })
    else
        ao.send({
            Target = msg.From,
            Data = "Error in adding admin"
        })

    end
end)

--- Register a farmer
Handlers.add("Register-Farmer", Handlers.utils.hasMatchingTag("Action", "Register-Farmer"), function(msg)

    local name = msg.Name
    local message = name .. " has been added"
    local newFarmer = {
        id = FarmersIndex,
        name = name,
        address = msg.From,
        isActive = true
    }

    ao.send({
        Target = msg.From,
        Data = message
    })

    Farmers[FarmersIndex] = newFarmer
    FarmersIndex = FarmersIndex + 1

end)

--- Register a farm
Handlers.add("Onboard-Farms", Handlers.utils.hasMatchingTag("Action", "Onboard-Farms"), function(msg)
    local newFarm = {
        owner = msg.From,
        availableShares = 500,
        farmName = msg.FarmName,
        id = FarmsIndex,
        location = msg.Location,
        metadata = (msg and msg.Metadata) or '',
        isListed = (msg and msg.Listed) or false,
        isActive = true
    }

    local message = newFarm.farmName .. " has been added"

    ao.send({
        Target = msg.From,
        Data = message
    })

    Farms[FarmsIndex] = newFarm
    FarmsIndex = FarmsIndex + 1

end)

--- Onboarding Investor
Handlers.add('Register-Investor', Handlers.utils.hasMatchingTag("Action", "Register-Investor"), function(msg)
    local name = msg.Name
    local message = name .. " has been added"

    local newInvestor = {
        id = InvestorsIndex,
        name = name,
        address = msg.From,
        balance = 0,
        ownedShares = {},
        isActive = true
    }
    ao.send({
        Target = msg.From,
        Data = message
    })

    Investors[InvestorsIndex] = newInvestor
    InvestorsIndex = InvestorsIndex + 1

end)

--- List to Registree Marketplace
Handlers.add("List-Farm", Handlers.utils.hasMatchingTag("Action", "List-Farm"), function(msg)

    --- TODO: Only registered Farmers are allowed to list a farm
    --- TODO: Only onboarded Farms can be listed
    local newListing = {
        id = msg.FarmId,
        owner = msg.From,
        availableShares = 500,
        isActive = true,
        investors = {{
            address = '',
            share = 0
        }}
    }

    local id = msg.FarmId
    local idInt = tonumber(id)

    Farms[idInt].isListed = true

    local message = "Farm #" .. newListing.id .. " has been listed"
    ao.send({
        Target = msg.From,
        Data = message
    })
    Listings[ListingsIndex] = newListing
    ListingsIndex = ListingsIndex + 1
end)

local function findInvestorByAddress(targetAddress)
    for _, investor in ipairs(Investors) do
        if (investor.address) == targetAddress then
            return investor
        end
    end
    return nil
end

Handlers.add("Invest", Handlers.utils.hasMatchingTag("Action", "Invest"), function(msg)

    local farmId = msg.FarmId
    local farmIdInt = tonumber(farmId)

    local sharesToBuy = msg.Shares
    local sharesToBuyInt = tonumber(sharesToBuy)

    local updatedShares = Listings[farmIdInt].availableShares - sharesToBuyInt
    Listings[farmIdInt].availableShares = updatedShares

    -- Update the Farms table
    Farms[farmIdInt].availableShares = Farms[farmIdInt].availableShares - sharesToBuyInt

    local invAddress = msg.From
    local invItem = findInvestorByAddress(invAddress)

    if (invItem) then
        -- Update the owned shares
        local newShares = {
            farmId = farmIdInt,
            shares = sharesToBuyInt
        }
        table.insert(invItem.ownedShares, newShares)

        local sharesPayable = sharesToBuyInt * PricePerShare

        -- Deduct shares payment
        invItem.balance = invItem.balance - sharesPayable

        -- Push the investor's data in the investors table of the Listings
        local investmentInfo = {
            address = msg.From,
            share = sharesToBuyInt
        }

        table.insert(Listings[farmIdInt].investors, investmentInfo)
    else
        ao.send({
            Target = msg.From,
            Data = "Investor not found"
        })
    end

    ao.send({
        Target = msg.From,
        Data = "Investment has been submitted"
    })
end)

Handlers.add("Farm-Update", Handlers.utils.hasMatchingTag("Action", "Farm-Update"), function(msg)
    local farmId = tonumber(msg.FarmId)
    local newMetadata = msg.Metadata or ''

    Farms[farmId].metadata = newMetadata

    ao.send({
        Target = msg.From,
        Data = "Successfully saved metadata!"
    })
end)

local function sumSharesForAddress(entries, targetAddress)
    local totalShares = 0

    for _, entry in ipairs(entries) do
        if entry.address == targetAddress then
            totalShares = totalShares + entry.share
        end
    end

    return totalShares
end

Handlers.add("Sell-Shares", Handlers.utils.hasMatchingTag("Action", "Sell-Shares"), function(msg)
    local farmId = tonumber(msg.FarmId)
    local listingId = msg.ListingId
    local quantity = tonumber(msg.Quantity)

    local listing = Listings[farmId].investors

    local farmShares = sumSharesForAddress(listing, msg.From)
    print(farmShares)
end)
