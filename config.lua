Config = {}
Config.DB = {
    table_name = 'cruso_sellers',
    table_name2 = 'cruso_sellers_accounts'
}

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
    isbusy = false,
    job   = {['sheriff'] = 0, ["police"] = 0},
    gang   = {['crime'] = 0},
 },
 [2] = {
    Id = 2,
    coords = vector4(-603.18, 10.01, 43.57, 96), 
    ped_model = 'a_f_m_eastsa_02',
    animDic = 'abigail_mcs_1_concat-10',
    anim ='player_zero_dual-10',
    items = "public2", --названия набора итемов, должно совпадать с ключом в Config.Items
    targetLabel = 'Взаимодействовать',
    targetIcon = 'fas fa-shopping-basket',
    isbusy = false
 }
}
-- !!!name Items element must  unique ---
Config.Items = {
    ["public"] = {
        cooldown = 60000*10,--множитель это количество минут,
        items = {
            ["cokebaggy"] = {amount = 1, price = 85},
            ["meth"] = {amount = 2, price = 50},
        }
    },
    ["public2"] = {
        cooldown = 60000*10,--множитель это количество минут,
        items = {
            
            ["kurkakola"] = {amount = 1, price = 2},
            ["beer"] = {amount = 1, price = 5},
            ["whiskey"] = {amount = 2, price = 10},
        }
    }
}