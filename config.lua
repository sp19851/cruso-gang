Config = {}
--!!!id may contain a unique value corresponding to the key in the database!!!---
Config.Points = {
 [1] = {
    Id = 1,
    coords = vector4(-617.98, 14.36, 41.57, 180), 
    ped_model = 'IG_LifeInvad_02',
    animDic = 'abigail_mcs_1_concat-10',
    anim ='player_zero_dual-10',
    items = "public", --названия набора итемов, должно совпадать с ключом в Config.Items
    targetLabel = 'Взаимодействовать',
    targetIcon = 'fas fa-shopping-basket',
    job   = {['sheriff'] = 0, ["police"] = 0},
    gang   = {['crime'] = 0},
 }
}

Config.Items = {
    ["public"] = {
        cooldown = 60000*1,--множитель это количество минут,
        items = {
            [1] = {name = "beer",amount = 1, price = 5},
            [2] = {name = "meth",amount = 2, price = 50},
        }
    }
}