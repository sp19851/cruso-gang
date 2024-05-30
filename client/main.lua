local QBCore = exports['qb-core']:GetCoreObject()
--local PlayerData = QBCore.Functions.GetPlayerData()
local pedSpawned = false
local Peds = {}
local MenuList = {}
local needControl = false
--local isInteract = false
local sleepControlMenu = 1000



--Functions--
local function GetIndexByIdMenu(id)
    for i, menu in pairs(MenuList) do
        if (menu.menuId == id) then
            return true, menu.index
        end
    end
    return false
end

local function SetBusy(menuId, boolean)
    local bool, index = GetIndexByIdMenu(menuId)
    if (bool and index and Config.Points and Config.Points[index]) then
        --if (Config.Points[index].isbusy == boolean) then
            needControl = boolean
            TriggerServerEvent("cruso-sellers:server:setBusy", index, needControl)    
        --else
    end
end

    
    --[[if (rigthmenu) then
        sleepControlMenu = 100
        --print("index", index, "isInteract", isInteract)
        if (index ~= nil and Config.Points[index] ~= nil and Config.Points[index].isbusy == false) then TriggerServerEvent("cruso-sellers:server:setBusy", index, true) end
    else
        local isFinded, index = GetIndexBusyPoint()
        if (isFinded and index ~= nil and Config.Points[index] ~= nil and Config.Points[index].isbusy) then TriggerServerEvent("cruso-sellers:server:setBusy", index, false) end
        sleepControlMenu = 1000
        --needControlMenu = false
    end
end]]



local function GetIndexBusyPoint()
    for i, point in pairs(Config.Points) do
        if (point.isbusy) then
            return true, i
        end
    end
    return false
end

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
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
end
local function loadAnimDict(animDict)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(0)
    end
end


function editItemMenu(index, item)
    MenuList[#MenuList+1] = {menuId = 'itemMenu', index = index}
    lib.registerContext({
        id = 'itemMenu',
        title = 'Настройка продажи '..GetItemLabel(item.name),
        onExit = function()
            print('close itemMenu')
            SetBusy('itemMenu', false)
        end,
        options = {
            {
                title = 'Выставить дополнительное количество',
                onSelect = function()
                    local input = lib.inputDialog('Сколько Вы ходите выставить?', {'Количество'})
                    if not input then return end
                    if QBCore.Functions.HasItem(item.name, tonumber(input[1])) then
                        item.count = item.count + tonumber(input[1])
                        QBCore.Functions.Progressbar('give', "Передаем товар", 10000, false, false, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = true,
                            disableCombat = true,
                        }, {
                            animDict = 'gestures@f@standing@casual',
                            anim = 'gesture_point',
                        }, {}, {}, 
                        function()
                            TriggerServerEvent('cruso-sellers:server:update', "put", index, item, tonumber(input[1])) 
                            SetBusy('itemMenu',false)
                        end)
                    else
                        QBCore.Functions.Notify('У Вас нет такого предмета или требуемого количества', 'error', 5000)
                        SetBusy('itemMenu',false)
                    end
                    
                    --productMenu(index)
                end,
            },
            {
                title = 'Забрать остатки: '..item.count..' шт.',
                onSelect = function()
                    if (item.count) > 0 then
                        QBCore.Functions.Progressbar('take', "Забираем товар", 10000, false, false, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = true,
                            disableCombat = true,
                        }, {
                            animDict = 'gestures@f@standing@casual',
                            anim = 'gesture_point',
                        }, {}, {}, 
                        function()
                            TriggerServerEvent('cruso-sellers:server:update', "give", index, item, item.count) 
                            SetBusy('itemMenu', false)
                        end)
                    else
                        QBCore.Functions.Notify('Так вроде нечего пока забирать...', 'error', 5000)
                    end
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
    SetBusy('itemMenu', true)
    lib.showContext('itemMenu')
end

function productMenu(index)
    QBCore.Functions.TriggerCallback('cruso-sellers:server:GetData', function(result)
        if (#result ~= 0) then
            local nameproducte = Config.Points[index].items
            local _options = {}
            for i, product in pairs(Config.Items[nameproducte].items) do
                 product.name = i
                 --local amount = 0
                 product.count = 0
                 for _, itemDB in pairs(result) do
                    if (itemDB.item == i) then
                        product.count = itemDB.amount
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
            MenuList[#MenuList+1] = {menuId = 'productMenu', index = index}
            lib.registerContext({
                 id = 'productMenu',
                 title = 'Меню продаж',
                 onExit = function()
                    SetBusy('productMenu', false)
                    print('close productMenu')
                end,
                 options = _options
             })
        else 
           local nameproducte = Config.Points[index].items
           local _options = {}
           for i, product in pairs(Config.Items[nameproducte].items) do
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
           MenuList[#MenuList+1] = {menuId = 'productMenu', index = index}
           lib.registerContext({
                id = 'productMenu',
                title = 'Меню продаж',
                options = _options
            })

        end
        SetBusy('productMenu', true)
        lib.showContext('productMenu')
    end, index)
    
end

local function TakeMoney(index, cash)
    
    SetBusy('shopMenu', true)
    QBCore.Functions.Progressbar('cash', "Забираем деньги", 7500, false, false, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = true,
        disableCombat = true,
    }, {
        animDict = 'gestures@f@standing@casual',
        anim = 'gesture_point',
    }, {}, {}, 
    function()
        TriggerServerEvent('cruso-sellers:server:getMoney', index, cash) 
        SetBusy('shopMenu', false)
    end)
end

local function openShop(index)
    QBCore.Functions.TriggerCallback('cruso-sellers:server:isCanInteract', function(result)
        if not result  then
            QBCore.Functions.TriggerCallback('cruso-sellers:server:GetMoneyData', function(result)
                local cash
                --print("result", json.encode(result))
                if (result and #result > 0 ) then -- проверка на пустую запись об аккаунте у этой точки
                 cash = result[1].account
                else
                    cash = 0
                end
                MenuList[#MenuList+1] = {menuId = 'shopMenu', index = index}
                lib.registerContext({
                    id = 'shopMenu',
                    title = 'Меню магазина',
                    onExit = function()
                        print('close shopMenu')
                        SetBusy('shopMenu', false)
                    end,
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
                       
                        onSelect = function()
                            if (tonumber(cash) > 0) then
                                TakeMoney(index, cash)
                            else
                                QBCore.Functions.Notify('Бабок пока не накапало', 'error', 5000)
                                SetBusy('shopMenu', false)
                            end;
                        end,
                    },
                    
                    }
                })
                SetBusy('shopMenu', true)
                lib.showContext('shopMenu')
            end, index)
        else
            QBCore.Functions.Notify('Парень не в настроении разговаривать, подойдите позже', 'error', 5000)
        end
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
    for _, v in pairs(Peds) do
        print("deletePeds", v)
        DeletePed(v)
    end
    pedSpawned = false
end


--Events--
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(2000)
    PlayerData = QBCore.Functions.GetPlayerData()
    Wait(3000)
    
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    deletePeds()
    print('QBCore:Client:OnPlayerUnload')
    --PlayerData = {}--
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    MenuList = {}
    deletePeds()
end)

RegisterNetEvent('cruso-sellers:client:setBusy')
AddEventHandler('cruso-sellers:client:setBusy', function(data)
    Config.Points = data
end)

-----Threads----
--Init--
Citizen.CreateThread(function()
    --iterating through the points--
    for index, point in pairs(Config.Points) do
        createPed(index, point)
    end
    pedSpawned = true 
end)   

--IsMenuOpen---
/*Citizen.CreateThread(function()
    while true do
        if (needControlMenu) then
            local id = lib.getOpenContextMenu()
            local rigthmenu, index = IsRightMenu(id)
            if (rigthmenu) then
                sleepControlMenu = 100
                --print("index", index, "isInteract", isInteract)
                if (index ~= nil and Config.Points[index] ~= nil and Config.Points[index].isbusy == false) then TriggerServerEvent("cruso-sellers:server:setBusy", index, true) end
            else
                local isFinded, index = GetIndexBusyPoint()
                if (isFinded and index ~= nil and Config.Points[index] ~= nil and Config.Points[index].isbusy) then TriggerServerEvent("cruso-sellers:server:setBusy", index, false) end
                sleepControlMenu = 1000
                --needControlMenu = false
            end
        end
        Citizen.Wait(sleepControlMenu)
    end
    
end)*/




local function drawTxt(text, font, x, y, scale, r, g, b, a)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextOutline()
    SetTextCentre(1)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(x, y)
end

--Debug---
Citizen.CreateThread(function()
    while true do
        --DrawText(needControlMenu, 0.2, 0.5)
        drawTxt(needControlMenu, 4, 0.5, 0.93, 0.50, 255, 255, 255, 180)
        Citizen.Wait(0)
    end
end)