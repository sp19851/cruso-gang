local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()
local pedSpawned = false
local Peds = {}



--Functions--
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

local function openShop(index)

end

local function createPed(index, pointData)
    if pedSpawned then return end
    loadModel(pointData.ped_model)
    
    Peds[index] = CreatePed(0, GetHashKey(pointData.ped_model), pointData.coords.x, pointData.coords.y, pointData.coords.z-1, pointData.coords.w, false, false)
    loadAnimDict(pointData.animDic)
    TaskPlayAnim(Peds[index], pointData.animDic, pointData.anim, 1.0, 1.0, -1, 16, 0, false, false, false)
    

    SetEntityInvincible(Peds[index], true)
    SetBlockingOfNonTemporaryEvents(Peds[index], true)
    FreezeEntityPosition(Peds[index], true)
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