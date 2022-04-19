local QBCore = exports['qb-core']:GetCoreObject()

local item = {
    "recycledmaterials",
}

RegisterNetEvent('qb-recycle:server:getItem', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local amount = math.random(1, 3)
    
    Player.Functions.AddItem("recycledmaterials", amount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'add', amount)
    Wait(500)
    
    local chance = math.random(1, 100)
    if chance < 7 then
        Player.Functions.AddItem("cryptostick", 1, false)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["cryptostick"], "add")
    end

end)


-- Sell ALL Recycled Materials for (x Amount of Material * x Amount of Recyceld Materials)

RegisterNetEvent("qb-recyclejob:SellAll")
AddEventHandler("qb-recyclejob:SellAll", function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.Functions.GetItemByName("recycledmaterials") ~= nil then
        local amount = Player.Functions.GetItemByName("recycledmaterials").amount

        if data == 1 then
            local itemamount = Config.ItemPrices["metalscrap"].price
            local pay = (amount * itemamount)
            Player.Functions.RemoveItem('recycledmaterials', amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'remove', amount)
            Player.Functions.AddItem("metalscrap", pay)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["metalscrap"], 'add', pay)

        elseif data == 3 then
            local itemamount = Config.ItemPrices["iron"].price
            local pay = (amount * itemamount)
            Player.Functions.RemoveItem('recycledmaterials', amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'remove', amount)
            Player.Functions.AddItem("iron", pay)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["iron"], 'add', pay)

        elseif data == 5 then
            local itemamount = Config.ItemPrices["steel"].price
            local pay = (amount * itemamount)
            Player.Functions.RemoveItem('recycledmaterials', amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'remove', amount)
            Player.Functions.AddItem("steel", pay)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["steel"], 'add', pay)

        elseif data == 7 then
            local itemamount = Config.ItemPrices["aluminum"].price
            local pay = (amount * itemamount)
            Player.Functions.RemoveItem('recycledmaterials', amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'remove', amount)
            Player.Functions.AddItem("aluminum", pay)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["aluminum"], 'add', pay)

        elseif data == 9 then
            local itemamount = Config.ItemPrices["copper"].price
            local pay = (amount * itemamount)
            Player.Functions.RemoveItem('recycledmaterials', amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'remove', amount)
            Player.Functions.AddItem("copper", pay)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["copper"], 'add', pay)

        elseif data == 11 then
            local itemamount = Config.ItemPrices["plastic"].price
            local pay = (amount * itemamount)
            Player.Functions.RemoveItem('recycledmaterials', amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'remove', amount)
            Player.Functions.AddItem("plastic", pay)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["plastic"], 'add', pay)

        elseif data == 13 then
            local itemamount = Config.ItemPrices["glass"].price
            local pay = (amount * itemamount)
            Player.Functions.RemoveItem('recycledmaterials', amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'remove', amount)
            Player.Functions.AddItem("glass", pay)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["glass"], 'add', pay)

        elseif data == 15 then
            local itemamount = Config.ItemPrices["rubber"].price
            local pay = (amount * itemamount)
            Player.Functions.RemoveItem('recycledmaterials', amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'remove', amount)
            Player.Functions.AddItem("rubber", pay)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["rubber"], 'add', pay)

        elseif data == 17 then
            local pay = (amount * Config.ItemPrices["cash"].price)
            Player.Functions.RemoveItem('recycledmaterials', amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'remove', amount)
            Player.Functions.AddMoney('cash', pay)

        end
        
    else
        TriggerClientEvent("QBCore:Notify", src, "You don't have any Recycled Materials!", "error")
    end
    Wait(1000)
end)



-- Sell 1 Recycled Materials for x Amount of Material

RegisterNetEvent("qb-recyclejob:SellOne")
AddEventHandler("qb-recyclejob:SellOne", function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName("recycledmaterials") ~= nil then
        local amount = Player.Functions.GetItemByName("recycledmaterials").amount

        if data == 2 then
            local pay = Config.ItemPrices["metalscrap"].price
            Player.Functions.RemoveItem('recycledmaterials', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'remove', 1)
            Player.Functions.AddItem("metalscrap", pay)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["metalscrap"], 'add', pay)

        elseif data == 4 then
            local pay = Config.ItemPrices["iron"].price
            Player.Functions.RemoveItem('recycledmaterials', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'remove', 1)
            Player.Functions.AddItem("iron", pay)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["iron"], 'add', pay)

        elseif data == 6 then
            local pay = Config.ItemPrices["steel"].price
            Player.Functions.RemoveItem('recycledmaterials', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'remove', 1)
            Player.Functions.AddItem("steel", pay)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["steel"], 'add', pay)

        elseif data == 8 then
            local pay = Config.ItemPrices["aluminum"].price
            Player.Functions.RemoveItem('recycledmaterials', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'remove', 1)
            Player.Functions.AddItem("aluminum", pay)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["aluminum"], 'add', pay)

        elseif data == 10 then
            local pay = Config.ItemPrices["copper"].price
            Player.Functions.RemoveItem('recycledmaterials', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'remove', 1)
            Player.Functions.AddItem("copper", pay)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["copper"], 'add', pay)

        elseif data == 12 then
            local pay = Config.ItemPrices["plastic"].price
            Player.Functions.RemoveItem('recycledmaterials', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'remove', 1)
            Player.Functions.AddItem("plastic", pay)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["plastic"], 'add', pay)

        elseif data == 14 then
            local pay = Config.ItemPrices["glass"].price
            Player.Functions.RemoveItem('recycledmaterials', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'remove', 1)
            Player.Functions.AddItem("glass", pay)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["glass"], 'add', pay)

        elseif data == 16 then
            local pay = Config.ItemPrices["rubber"].price
            Player.Functions.RemoveItem('recycledmaterials', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'remove', 1)
            Player.Functions.AddItem("rubber", pay)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["rubber"], 'add', pay)
        end
    else
        TriggerClientEvent("QBCore:Notify", src, "You don't have any Recycled Materials!", "error")
    end
    Wait(1000)
end)