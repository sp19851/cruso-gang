local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()
local pedSpawned = false
local Peds = {}



--Functions--
local function GetItemLabel(item)
    --print('^1Item: ^3['..item..']^1 ')
    if QBCore.Shared and QBCore.Shared.Items and QBCore.Shared.Items[item] then
        return QBCore.Shared.Items[item].label
    else
        print('^1Item: ^3['..item..']^1 missing in qb-core/shared/items.lua^0')
        return item
    end
end

local function loadModel(model)
    print("loadModel" , model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    print("loadModel done")
end
local function loadAnimDict(animDict)
    print("loadAnimDict" , animDict)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(0)
    end
    print("loadMloadAnimDic done")
end


function editItemMenu(index, item)
    print("editItemMenu" , index, json.encode(item))
    lib.registerContext({
        id = 'itemMenu',
        title = 'Настройка продажи '..GetItemLabel(item.name),
        options = {
            {
                title = 'Выставить дополнительное количество',
                onSelect = function()
                    local input = lib.inputDialog('Сколько Вы ходите выставить?', {'Количество'})
                    if not input then return end
                    print("Выставить", input[1])
                    if QBCore.Functions.HasItem(item.name, tonumber(input[1])) then
                        item.count = item.count + tonumber(input[1])
                        TriggerServerEvent('cruso-sellers:server:update', "put", index, item, tonumber(input[1]))
                    else
                        QBCore.Functions.Notify('У Вас нет такого предмета или требуемого количества', 'error', 5000)
                    end
                    
                    --productMenu(index)
                end,
            },
            {
                title = 'Забрать остатки: '..item.count..' шт.',
                onSelect = function()
                    TriggerServerEvent('cruso-sellers:server:update', "give", index, item, item.count)
                end,
            },
            {
                title = 'Назад',
                icon = 'left-long',
                onSelect = function()
                    productMenu(index)
                end,
            }
        }
    })
    lib.showContext('itemMenu')
end

function productMenu(index)
    print("товары на продажу индекс" , index)
    QBCore.Functions.TriggerCallback('cruso-sellers:server:GetData', function(result)
        print("result" , #result, json.encode(result))
        if (#result ~= 0) then
            local nameproducte = Config.Points[index].items
            print("nameproducte", nameproducte)
            local _options = {}
            for i, product in pairs(Config.Items[nameproducte].items) do
                 print(i, "-->", json.encode(product))
                 product.name = i
                 --local amount = 0
                 product.count = 0
                 for _, itemDB in pairs(result) do
                    print(i, ">>>", json.encode(itemDB))
                    if (itemDB.item == i) then
                        print("***", i)
                        product.count = itemDB.amount
                        print("***", product.count)
                        break
                    end
                 end
                 

                 _options[i] = {
                     title = GetItemLabel(i),
                     description = 'Стоимость за шт. - $'..product.price.. '. Остаток: '..product.count..' шт.',
                     onSelect = function()
                         editItemMenu(index, product)
                     end,
                 }
                 
            end
            lib.registerContext({
                 id = 'productMenu',
                 title = 'Меню продаж',
                 options = _options
             })
        else 
           local nameproducte = Config.Points[index].items
           print("nameproducte", nameproducte)
           local _options = {}
           for i, product in pairs(Config.Items[nameproducte].items) do
                print(i, "-->", json.encode(product))
                product.name = i
                product.count = 0
                _options[i] = {
                    title = GetItemLabel(i),
                    description = 'Стоимость за шт. - $'..product.price.. '. Остаток: '..product.count..' шт.',
                    onSelect = function()
                        editItemMenu(index, product)
                    end,
                }
                
           end
           lib.registerContext({
                id = 'productMenu',
                title = 'Меню продаж',
                options = _options
            })

        end
        lib.showContext('productMenu')
    end, index)
    
end

local function openShop(index)
    QBCore.Functions.TriggerCallback('cruso-sellers:server:GetMoneyData', function(result)
        print("result[0]", json.encode(result[1]))
        local cash = result[1].account
        lib.registerContext({
            id = 'shopMenu',
            title = 'Меню магазина',
            options = {
            {
                title = 'Товар на продажу',
                description = 'Настройка продаж',
                icon = 'rectangle-list',
                --menu = 'productMenu',
                onSelect = function()
                    productMenu(index)
                end,
            },
            {
                title = 'Забрать деньги',
                description = 'Продано товаров на $'..cash,
                icon = 'money-bill-1',
                serverEvent = 'cruso-sellers:server:getMoney',
                args = {
                    index = index,
                    cash = cash
                  }
            },
            
            }
        })
        lib.showContext('shopMenu')
    end, index)
end

local function createPed(index, pointData)
    if pedSpawned then return end
    loadModel(pointData.ped_model)
    
    Peds[index] = CreatePed(0, GetHashKey(pointData.ped_model), pointData.coords.x, pointData.coords.y, pointData.coords.z-1, pointData.coords.w, false, false)
    loadAnimDict(pointData.animDic)
    PlaceObjectOnGroundProperly(Peds[index])
    TaskPlayAnim(Peds[index], pointData.animDic, pointData.anim, 1.0, 1.0, -1, 16, 0, false, false, false)
    SetEntityInvincible(Peds[index], true)
    SetBlockingOfNonTemporaryEvents(Peds[index], true)
    --FreezeEntityPosition(Peds[index], true)
    exports['qb-target']:AddTargetEntity(Peds[index], {
        options = {
            {
                label = pointData.targetLabel,
                icon = pointData.targetIcon,
                action = function()
                    openShop(index)
                end,
                job = pointData.job,
                gang = pointData.gang
            }
        },
        distance = 2.0
    })
        
end

local function deletePeds()
    if not pedSpawned then return end

    for _, v in pairs(ShopPed) do
        DeletePed(v)
    end
    pedSpawned = false
end


--Events--
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(2000)
    local hudSettings = GetResourceKvpString('hudSettings')
    if hudSettings then loadSettings(json.decode(hudSettings)) end
    PlayerData = QBCore.Functions.GetPlayerData()
    Wait(3000)
    SetEntityHealth(PlayerPedId(), 200)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

-----Threads----
--Init--
Citizen.CreateThread(function()
    --iterating through the points--
    for index, point in pairs(Config.Points) do
        createPed(index, point)
    end
end)     