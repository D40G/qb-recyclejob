local QBCore = exports['qb-core']:GetCoreObject()
local carryPackage = nil
local packagePos = nil
local onDuty = false
local shopPeds = {}

-- Functions

local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local function ScrapAnim()
    local time = 5
    loadAnimDict("mp_car_bomb")
    TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    CreateThread(function()
        while openingDoor do
            TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Wait(1000)
            time = time - 1
            if time <= 0 then
                openingDoor = false
                StopAnimTask(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 1.0)
            end
        end
    end)
end

local function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function GetRandomPackage()
    local randSeed = math.random(1, #Config["delivery"].pickupLocations)
    packagePos = {}
    packagePos.x = Config["delivery"].pickupLocations[randSeed].x
    packagePos.y = Config["delivery"].pickupLocations[randSeed].y
    packagePos.z = Config["delivery"].pickupLocations[randSeed].z
end

local function PickupPackage()
    local pos = GetEntityCoords(PlayerPedId(), true)
    RequestAnimDict("anim@heists@box_carry@")
    while (not HasAnimDictLoaded("anim@heists@box_carry@")) do
        Wait(7)
    end
    TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
    local model = `prop_cs_cardbox_01`
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end
    local object = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)
    AttachEntityToEntity(object, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.05, 0.1, -0.3, 300.0, 250.0, 20.0, true, true, false, true, 1, true)
    carryPackage = object
end

local function DropPackage()
    ClearPedTasks(PlayerPedId())
    DetachEntity(carryPackage, true, true)
    DeleteObject(carryPackage)
    carryPackage = nil
end

-- Threads

CreateThread(function()
    local RecycleBlip = AddBlipForCoord(Config['delivery'].outsideLocation.x, Config['delivery'].outsideLocation.y, Config['delivery'].outsideLocation.z)
    SetBlipSprite(RecycleBlip, 365)
    SetBlipColour(RecycleBlip, 2)
    SetBlipScale(RecycleBlip, 0.8)
    SetBlipAsShortRange(RecycleBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Recycle Center")
    EndTextCommandSetBlipName(RecycleBlip)


    local RecyclingSeller = AddBlipForCoord(-572.46, -1632.74, 19.41)
    SetBlipSprite (RecyclingSeller, 365)
    SetBlipColour(RecyclingSeller, 2)
    SetBlipScale  (RecyclingSeller, 0.8)
    SetBlipAsShortRange(RecyclingSeller, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Recycling Trader")
    EndTextCommandSetBlipName(RecyclingSeller)

    while true do
        Wait(0)
        local pos = GetEntityCoords(PlayerPedId(), true)

        if #(pos - vector3(Config['delivery'].outsideLocation.x, Config['delivery'].outsideLocation.y, Config['delivery'].outsideLocation.z)) < 1.3 then
            DrawText3D(Config['delivery'].outsideLocation.x, Config['delivery'].outsideLocation.y, Config['delivery'].outsideLocation.z + 1, "~g~E~w~ - To Enter")
            if IsControlJustReleased(0, 38) then
                DoScreenFadeOut(500)
                while not IsScreenFadedOut() do
                    Wait(10)
                end
                SetEntityCoords(PlayerPedId(), Config['delivery'].insideLocation.x, Config['delivery'].insideLocation.y, Config['delivery'].insideLocation.z)
                DoScreenFadeIn(500)
            end
        end

		if #(pos - vector3(Config['delivery'].insideLocation.x, Config['delivery'].insideLocation.y, Config['delivery'].insideLocation.z)) < 1.3 then
			DrawText3D(Config['delivery'].insideLocation.x, Config['delivery'].insideLocation.y, Config['delivery'].insideLocation.z + 1, "~g~E~w~ - To Go Outside")
			if IsControlJustReleased(0, 38) then
				DoScreenFadeOut(500)
				while not IsScreenFadedOut() do
					Wait(10)
				end
				SetEntityCoords(PlayerPedId(), Config['delivery'].outsideLocation.x, Config['delivery'].outsideLocation.y, Config['delivery'].outsideLocation.z + 1)
				DoScreenFadeIn(500)
			end
		end

        if #(pos - vector3(1049.15, -3100.63, -39.95)) < 15 and not IsPedInAnyVehicle(PlayerPedId(), false) and carryPackage == nil then
            DrawMarker(2, 1049.15, -3100.63, -39.20, 0.9, 0, 0, 0, 0, 0, 0.2001, 0.2001, 0.2001, 255, 255, 255, 255, 0, 0, 0, 0)
            if #(pos - vector3(1049.15, -3100.63, -39.95)) < 1.3 then
                if onDuty then
                    DrawText3D(1049.15, -3100.63, -38.95, "~g~E~w~ - Clock Out")
                else
                    DrawText3D(1049.15, -3100.63, -38.95, "~g~E~w~ -  Clock In")
                end
                if IsControlJustReleased(0, 38) then
                    onDuty = not onDuty
                    if onDuty then
                        QBCore.Functions.Notify("You Have Been Clocked In", "success")
                    else
                        QBCore.Functions.Notify("You Have Clocked Out", "error")
                    end
                end
            end
        end
    end
end)

CreateThread(function()
    for k, pickuploc in pairs(Config['delivery'].pickupLocations) do
        local model = GetHashKey(Config['delivery'].warehouseObjects[math.random(1, #Config['delivery'].warehouseObjects)])
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(0) end
        local obj = CreateObject(model, pickuploc.x, pickuploc.y, pickuploc.z, false, true, true)
        PlaceObjectOnGroundProperly(obj)
        FreezeEntityPosition(obj, true)
    end

    while true do
        Wait(5)
        if onDuty then
            if packagePos ~= nil then
                local pos = GetEntityCoords(PlayerPedId(), true)
                if carryPackage == nil then
                    if #(pos - vector3(packagePos.x, packagePos.y, packagePos.z)) < 2.3 then
                        DrawText3D(packagePos.x,packagePos.y,packagePos.z+ 1, "~g~E~w~ - Pack Package")
                        if IsControlJustReleased(0, 38) then
                            QBCore.Functions.Progressbar("pickup_reycle_package", "Pick Up The Package ..", Config.PickupTime, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function()
                                ClearPedTasks(PlayerPedId())
                                PickupPackage()
                            end)
                        end
                    else
                        DrawText3D(packagePos.x, packagePos.y, packagePos.z + 1, "Package")
                    end
                else
                    if #(pos - vector3(Config['delivery'].dropLocation.x, Config['delivery'].dropLocation.y, Config['delivery'].dropLocation.z)) < 2.0 then
                        DrawText3D(Config['delivery'].dropLocation.x, Config['delivery'].dropLocation.y, Config['delivery'].dropLocation.z, "~g~E~w~ - Hand In The Package")
                        if IsControlJustReleased(0, 38) then
                            DropPackage()
                            ScrapAnim()
                            QBCore.Functions.Progressbar("deliver_reycle_package", "Unpacking The Package", Config.TurnInTime, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function() -- Done
                                StopAnimTask(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 1.0)
                                TriggerServerEvent('qb-recycle:server:getItem')
                                GetRandomPackage()
                            end)
                        end
                    else
                        DrawText3D(Config['delivery'].dropLocation.x, Config['delivery'].dropLocation.y, Config['delivery'].dropLocation.z, "Hand In")
                    end
                end
            else
                GetRandomPackage()
            end
        end
    end
end)

--------------------------------------------------------------
--------------------------------------------------------------

                -- TARGET ZONE FOR PED 
                -- MENUS FOR TRADING 
                -- EVENTS FOR TRADING
                    -- TRADE 1
                    -- TRADE ALL
                    -- INPUT AMOUNT

--------------------------------------------------------------
--------------------------------------------------------------


-------------------------------
-- ZONE FOR SELLING TO PED -- 
-------------------------------

CreateThread(function()
	exports['qb-target']:AddCircleZone("MaterialTrader", vector3(-572.4, -1632.1, 18.41), 2.0, { 
		name="MaterialTrader", 
		debugPoly=false, 
		useZ=true, 
	},{ 
		options = {
			{ 
				event = "qb-recyclejob:SellItems", 
				icon = "fas fa-certificate", 
				label = "Trade Materials", 
			},	
		},
		distance = 2.0
	})
end)

-------------------------------
-- SELL EVENT --
-------------------------------

RegisterNetEvent('qb-recyclejob:Trade', function(data)
	if data.item == 'close' and data.amount == 'close' then
		exports['qb-menu']:closeMenu()
		return
	end
    QBCore.Functions.Progressbar("trade_materials", "Trading Materials..", Config.TradeTime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        ClearPedTasks(PlayerPedId())
        if data.amount == 'one' then
            TriggerServerEvent('qb-recyclejob:TradeOne', data.item) -- Trade One
        elseif data.amount == 'all' then
            TriggerServerEvent('qb-recyclejob:TradeAll', data.item) -- Trade All
        else
            TriggerServerEvent('qb-recyclejob:TradeInput', data.item, data.amount) -- Trade Input Amount
        end
    end)
	TriggerEvent('qb-recycle:SellItems')
end)

-------------------------------
-- INPUT MENU --
-------------------------------

RegisterNetEvent('qb-recyclejob:openinput', function(data)
    local input = exports['qb-input']:ShowInput({
        header = 'Enter Amount to Trade',
        submitText = "Submit",
        inputs = {
            {
                text = "Amount",
                name = 'tradeamount',
                type = "number",
                isRequired = true
            }
        }
    })
    if input then
        QBCore.Functions.Progressbar("trade_materials", "Trading Materials..", Config.TradeAllTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent('qb-recyclejob:TradeInput', data, input.tradeamount)
        end)
        TriggerEvent('qb-recycle:SellItems')
    end
end)

-------------------------------
-- MENUS - SELL ITEMS MENU --
-------------------------------

RegisterNetEvent('qb-recyclejob:SellItems', function()
    exports['qb-menu']:openMenu({
		{ header = "Materials Trade", txt = "Trade Materials Here", isMenuHeader = true }, 
		{ header = "", txt = "✘ Close", params = { event = "qb-recycle:Sell", args = {amount = 'close', item = 'close'} } },
		{ header = "Metal Scrap", txt = "", params = { event = "qb-recyclejob:SellItems:MetalScrap", } },
        { header = "Iron", txt = "", params = { event = "qb-recyclejob:SellItems:Iron", } },
        { header = "Steel", txt = "", params = { event = "qb-recyclejob:SellItems:Steel", } },
        { header = "Aluminum", txt = "", params = { event = "qb-recyclejob:SellItems:Aluminum", } },
        { header = "Copper", txt = "", params = { event = "qb-recyclejob:SellItems:Copper", } },
        { header = "Plastic", txt = "", params = { event = "qb-recyclejob:SellItems:Plastic", } },
        { header = "Glass", txt = "", params = { event = "qb-recyclejob:SellItems:Glass", } },
        { header = "Rubber", txt = "", params = { event = "qb-recyclejob:SellItems:Rubber", } },
        { header = "Sell for Cash", txt = "", params = { event = "qb-recyclejob:SellItems:Cash", } },
	})
end)

-------------------------------
-- METAL SCRAP --
-------------------------------

RegisterNetEvent('qb-recyclejob:SellItems:MetalScrap', function()
    exports['qb-menu']:openMenu({
		{ header = "Materials Trade", txt = "Trade Metal Scrap", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Return", params = { event = "qb-recyclejob:SellItems", } },
        { header = "Metal Scrap", txt = "Trade ALL for Metal Scrap", params = { event = "qb-recyclejob:Trade", args = {amount = 'all', item = 'metalscrap'} } },
		{ header = "Metal Scrap", txt = "Trade 1 for "..Config.ItemPrices["metalscrap"].price.. " Metal Scrap", params = { event = "qb-recyclejob:Trade", args = {amount = 'one', item = 'metalscrap'} } },
        { header = "Metal Scrap", txt = "Enter amount of Metal Scrap to trade", params = { event = "qb-recyclejob:openinput", args = 'metalscrap' } },
	})
end)
-- IRON
RegisterNetEvent('qb-recyclejob:SellItems:Iron', function()
    exports['qb-menu']:openMenu({
		{ header = "Materials Trade", txt = "Trade Iron", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Return", params = { event = "qb-recyclejob:SellItems", } },
        { header = "Iron", txt = "Trade ALL for Iron", params = { event = "qb-recyclejob:Trade", args = {amount = 'all', item = 'iron'} } },
		{ header = "Iron", txt = "Trade 1 for "..Config.ItemPrices["iron"].price.. " Iron", params = { event = "qb-recyclejob:Trade", args = {amount = 'one', item = 'iron'} } },
        { header = "Iron", txt = "Enter amount of Iron to trade", params = { event = "qb-recyclejob:openinput", args = 'iron' } },
	})
end)

-------------------------------
-- STEEL --
-------------------------------

RegisterNetEvent('qb-recyclejob:SellItems:Steel', function()
    exports['qb-menu']:openMenu({
		{ header = "Materials Trade", txt = "Trade Steel", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Return", params = { event = "qb-recyclejob:SellItems", } },
        { header = "Steel", txt = "Trade ALL for Steel", params = { event = "qb-recyclejob:Trade", args = {amount = 'all', item = 'steel'} } },
		{ header = "Steel", txt = "Trade 1 for "..Config.ItemPrices["steel"].price.. " Steel", params = { event = "qb-recyclejob:Trade", args = {amount = 'one', item = 'steel'} } },
        { header = "Steel", txt = "Enter amount of Steel to trade", params = { event = "qb-recyclejob:openinput", args = 'steel' } },
	})
end)

-------------------------------
-- ALUMINUM -- 
-------------------------------

RegisterNetEvent('qb-recyclejob:SellItems:Aluminum', function()
    exports['qb-menu']:openMenu({
		{ header = "Materials Trade", txt = "Trade Aluminum", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Return", params = { event = "qb-recyclejob:SellItems", } },
        { header = "Aluminum", txt = "Trade ALL for Aluminum", params = { event = "qb-recyclejob:Trade", args = {amount = 'all', item = 'aluminum'} } },
		{ header = "Aluminum", txt = "Trade 1 for "..Config.ItemPrices["aluminum"].price.. " Aluminum", params = { event = "qb-recyclejob:Trade", args = {amount = 'one', item = 'aluminum'} } },
        { header = "Aluminum", txt = "Enter amount of Aluminum to trade", params = { event = "qb-recyclejob:openinput", args = 'aluminum' } },
	})
end)

-------------------------------
-- COPPER -- 
-------------------------------

RegisterNetEvent('qb-recyclejob:SellItems:Copper', function()
    exports['qb-menu']:openMenu({
		{ header = "Materials Trade", txt = "Trade Copper", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Return", params = { event = "qb-recyclejob:SellItems", } },
        { header = "Copper", txt = "Trade ALL for Copper", params = { event = "qb-recyclejob:Trade", args = {amount = 'all', item = 'copper'} } },
		{ header = "Copper", txt = "Trade 1 for "..Config.ItemPrices["copper"].price.. " Copper", params = { event = "qb-recyclejob:Trade", args = {amount = 'one', item = 'copper'}} },
        { header = "Copper", txt = "Enter amount of Copper to trade", params = { event = "qb-recyclejob:openinput", args = 'copper' } },
	})
end)

-------------------------------
-- PLASTIC -- 
-------------------------------

RegisterNetEvent('qb-recyclejob:SellItems:Plastic', function()
    exports['qb-menu']:openMenu({
		{ header = "Materials Trade", txt = "Trade Plastic", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Return", params = { event = "qb-recyclejob:SellItems", } },
        { header = "Plastic", txt = "Trade ALL for Plastic", params = { event = "qb-recyclejob:Trade", args = {amount = 'all', item = 'plastic'} } },
		{ header = "Plastic", txt = "Trade 1 for "..Config.ItemPrices["plastic"].price.. " Plastic", params = { event = "qb-recyclejob:Trade", args = {amount = 'one', item = 'plastic'} } },
        { header = "Plastic", txt = "Enter amount of Plastic to trade", params = { event = "qb-recyclejob:openinput", args = 'plastic' } },
	})
end)

-------------------------------
-- GLASS -- 
-------------------------------

RegisterNetEvent('qb-recyclejob:SellItems:Glass', function()
    exports['qb-menu']:openMenu({
		{ header = "Materials Trade", txt = "Trade Glass", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Return", params = { event = "qb-recyclejob:SellItems", } },
        { header = "Glass", txt = "Trade ALL for Glass", params = { event = "qb-recyclejob:Trade", args = {amount = 'all', item = 'glass'} } },
		{ header = "Glass", txt = "Trade 1 for "..Config.ItemPrices["glass"].price.. " Glass", params = { event = "qb-recyclejob:Trade", args = {amount = 'one', item = 'glass'} } },
        { header = "Glass", txt = "Enter amount of Glass to trade", params = { event = "qb-recyclejob:openinput", args = 'glass' } },
	})
end)

-------------------------------
-- RUBBER -- 
-------------------------------

RegisterNetEvent('qb-recyclejob:SellItems:Rubber', function()
    exports['qb-menu']:openMenu({
		{ header = "Materials Trade", txt = "Trade Rubber", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Return", params = { event = "qb-recyclejob:SellItems", } },
        { header = "Rubber", txt = "Trade ALL for Rubber", params = { event = "qb-recyclejob:Trade", args = {amount = 'all', item = 'rubber'} } },
		{ header = "Rubber", txt = "Trade 1 for "..Config.ItemPrices["rubber"].price.. " Rubber", params = { event = "qb-recyclejob:Trade", args = {amount = 'one', item = 'rubber'} } },
        { header = "Rubber", txt = "Enter amount of Rubber to trade", params = { event = "qb-recyclejob:openinput", args = 'rubber' } },
	})
end)

-------------------------------
-- CASH -- 
-------------------------------

RegisterNetEvent('qb-recyclejob:SellItems:Cash', function()
    exports['qb-menu']:openMenu({
		{ header = "Materials Trade", txt = "Trade Materials for Cash", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Return", params = { event = "qb-recyclejob:SellItems", } },
        { header = "Cash", txt = "Sell all Recycled Materials for Cash", params = { event = "qb-recyclejob:Trade", args = {amount = 'all', item = 'cash'} } },
        { header = "Cash", txt = "Enter amount of Recycled Materials to sell", params = { event = "qb-recyclejob:openinput", args = 'cash' } },
	})
end)
