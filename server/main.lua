local QBCore = exports['qb-core']:GetCoreObject()



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


    --[[exports.oxmysql:insert('INSERT INTO play_time (citizenid, nick, license, timeingame, lastupdate) VALUES (?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE citizenid = ?, nick= ?, license = ?, timeingame = ?, lastupdate = ?', {
        Player.PlayerData.citizenid,
        GetPlayerName(src),
        startTime[src].identifier,
        startTime[src].timeingame + gametime,
        os.time(),
        Player.PlayerData.citizenid,
        GetPlayerName(src),
        startTime[src].identifier,
        startTime[src].timeingame + gametime,
        os.time()
    })]]
end)

RegisterServerEvent('cruso-sellers:server:update')
AddEventHandler('cruso-sellers:server:update', function(index, item, removeAmount)
    print("cruso-sellers:server:update", removeAmount, json.encode(item))
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local name = tostring(Config.Points[index].Id)
    local tableName = tostring(Config.DB.table_name)
    --for i = 1, item.count do -- цикл потому что не нашел функцию для множественного удаления итемов
        --QBCore.Functions.RemoveItem(item.name)
        --exports["qb-core"]:RemoveItem(item.name)
    Player.Functions.RemoveItem(item.name, removeAmount)
    --end
   
    /*local response = MySQL.query.await('SELECT * FROM '..tableName..' WHERE id_seller = ?', {
        name
    })
    print('cruso-sellers:server:update', json.encode(response))
    if response ~= null then*/
        local id = MySQL.insert.await('INSERT INTO '..tableName..' (id_seller, item, amount) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE amount = ?', {
            tostring(index), item.name, item.count,  item.count
        })
        print("^3Script `cruso-sellers:server:update` ^0updated data from  id_seller", id)
    /*else
        
    end*/
end)

