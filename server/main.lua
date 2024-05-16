local QBCore = exports['qb-core']:GetCoreObject()


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
    print('cruso-sellers:server:GetData', json.encode(data))
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

-----Threads----
--CoolDawn--
Citizen.CreateThread(function()
    
end) 

