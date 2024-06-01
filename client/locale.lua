


--[[--Debug---
Citizen.CreateThread(function()
    print(Replace("Привет, {0}! Ты знаком с {0}?","Петя"))
    print(Replace("Привет, {0}! Ты знаком с {0}?", {"Вася","Петя"}))
end)]]

Translations = {
    setupSell = {
        title = "Настройка продажи {0}",
        addItem = "Выставить дополнительное количество",
        howMuch = 'Сколько Вы ходите выставить?',
        quantity = 'Количество',
        givingItem = "Передаем товар",
        error = 'У Вас нет такого предмета или требуемого количества'
    },
    leftovers = {
        title = "Забрать остатки: {0} шт ",
        takeItem = "Забираем товар",
        error = 'Так вроде нечего пока забирать...'
    },
    setupItem = {
        description = "Стоимость за шт. - ${0}. Остаток: {0} шт.",
    },
    productMenu = {
        title = "Меню продаж",
    },
    cash = {
        taking = "Забираем деньги",
    },
    shop = {
        title = "Меню магазина",
        forsale = "Товар на продажу",
        forsaleDescription = "Настройка продаж",
        takecash = "Забрать деньги",
        takecashDescription = "Продано товаров на ${0}",
        error = 'Бабок пока не накапало',
        busy = "Парень не в настроении разговаривать, подойдите позже"
    }
}


function LocaleReplace(str, text)
    if type(text) == "string" then
        local charIndex = string.match(str, "{0}")
        if (charIndex) == nil then
            return str
        else
            return string.gsub(str, "{0}", text, 1);
        end
    elseif type(text) == "table" then
        local newstr = str
        for _, v in pairs (text) do
            local charIndex = string.match(newstr, "{0}")
            if (charIndex) ~= nil then
                newstr = string.gsub(newstr, "{0}", v, 1);
            end
        end
        return newstr
    else
        return str
    end
end