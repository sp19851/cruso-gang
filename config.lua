Config = {}


Config.Points = {
 [1] = {
    id = 1,
    coords = vector3(-617.98, 14.36, 41.57), 
    ped_model = 'csbagent',
    animDic = 'abigail_mcs_1_concat-10',
    anim ='player_zero_dual-10',
    items = "public" --названия набора итемов, должно совпадать с ключом в Config.Items
 }
}

Config.Items = {
    ["public"] = {
        cooldown = 60000*1 --множитель это количество минут,
        items = {
            [1] = {
                "name" = "beer",
                "amount" = 1,
                "price" = 5,
            },
            [2] = {
                "name" = "meth",
                "amount" = 2,
                "price" = 50,
            },
        }
    }
}