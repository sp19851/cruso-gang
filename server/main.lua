local QBCore = exports['qb-core']:GetCoreObject()
local TimerData = {}

--Functions--
local function GetConfigItems(id_sellers)
    local name
    for i, data in pairs(Config.Points) do
        if (data.Id == id_sellers) then
            return data.items
        end
    end
    return false
end

local function SellItems(id_sellers)
    print("SellItems", id_sellers)
    local tableName = tostring(Config.DB.table_name)
    local tableName2 = tostring(Config.DB.table_name2)
    --local nameItems = tostring(Config.Points[id_sellers].Items)
    local response = MySQL.query.await('SELECT * FROM '..tableName..' WHERE id_seller = ?', {id_sellers})
    print("SellItems", response, json.encode(response))
    if (response ~= null and #response >0) then
        for i, dbItem in pairs(response) do
            print("dbItem", dbItem, json.encode(dbItem))
            for k, data in pairs(Config.Items[GetConfigItems(id_sellers)].items) do
                local newAmount = dbItem.amount - data.amount
                local price = data.amount * data.price
                if (newAmount >= 0) then
                    local id = MySQL.insert.await('INSERT INTO '..tableName..' (id_seller, item, amount) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE amount = ?', {
                        tostring(id_sellers), dbItem.item, newAmount, newAmount
                    })
                    print("^3Script `cruso-sellers:server:update` ^0updated data from  id_seller", id)  
                    local id = MySQL.insert.await('INSERT INTO '..tableName2..' (id_seller, account) VALUES (?, account + ?) ON DUPLICATE KEY UPDATE account = account + ?', {
                        tostring(id_sellers), price, price
                    })
                    print("^3Script `cruso-sellers:server:update` ^0updated data from  id_seller", id)  
                end
                
            end
        end
    end
end

--Events--
QBCore.Functions.CreateCallback('cruso-sellers:server:GetData', function(source, cb, index)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local name = tostring(Config.Points[index].Id)
    local tableName = tostring(Config.DB.table_name)

    local response = MySQL.query.await('SELECT * FROM '..tableName..' WHERE id_seller = ?', {
        name
    })
    cb(response)
    print('cruso-sellers:server:GetData', json.encode(response))
end)

QBCore.Functions.CreateCallback('cruso-sellers:server:GetMoneyData', function(source, cb, index)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local name = tostring(Config.Points[index].Id)
    local tableName2 = tostring(Config.DB.table_name2)

    local response = MySQL.query.await('SELECT * FROM '..tableName2..' WHERE id_seller = ?', {
        name
    })
    cb(response)
    print('cruso-sellers:server:GetMoneyData', json.encode(response))
end)

RegisterServerEvent('cruso-sellers:server:update')
AddEventHandler('cruso-sellers:server:update', function(param, index, item, removeAmount)
    print("cruso-sellers:server:update", removeAmount, json.encode(item))
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local name = tostring(Config.Points[index].Id)
    local tableName = tostring(Config.DB.table_name)
    
    if (param == "put") then 
        Player.Functions.RemoveItem(item.name, removeAmount)
    else 
        item.count = 0
        Player.Functions.AddItem(item.name, removeAmount)
    end
    local id = MySQL.insert.await('INSERT INTO '..tableName..' (id_seller, item, amount) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE amount = ?', {
        tostring(index), item.name, item.count,  item.count
    })
        print("^3Script `cruso-sellers:server:update` ^0updated data from  id_seller", id)
end)

RegisterServerEvent('cruso-sellers:server:getMoney')
AddEventHandler('cruso-sellers:server:getMoney', function(data)
    print("cruso-sellers:server:getMoney", json.encode(data))
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local tableName2 = tostring(Config.DB.table_name2)
    local cash = data.cash
    local index = data.index
    Player.Functions.AddMoney('cash', cash, 'cruso-sellers')
    
    local affectedRows  = MySQL.update.await('UPDATE '..tableName2..' SET account = 0 WHERE id_seller = ?', {
        tostring(index) 
    })
        print("^3Script `cruso-sellers:server:getMoney` ^0updated data from  id_seller", json.encode(affectedRows))
end)

-----Threads----
--Init--
Citizen.CreateThread(function()
    for i, data in pairs(Config.Points) do
        local id_sellers = data.Id
        TimerData[i] = {
            id_sellers = data.Id,
            items = data.items,
            timer = GetGameTimer()
        }
    end
    print("TimerData", json.encode(TimerData))
 end) 
--CoolDawn--
Citizen.CreateThread(function()
   while true do
        for i, data in pairs(TimerData) do
            local cooldown = Config.Items[data.items].cooldown
            local id_sellers = data.id_sellers
            if (data.timer + cooldown) < GetGameTimer() then
                SellItems(id_sellers)
                data.timer = GetGameTimer()
            end

        end
        Citizen.Wait(1000)
    end  
end) 

