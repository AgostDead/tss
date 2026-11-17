-- ============================================
--  TSS HUB (ГЛАВНОЕ МЕНЮ)
-- ============================================
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/AgostDead/new-ui-painkillers/main/ui"))()
local color3 = Color3.fromRGB(255, 0, 0)
local vector2New = Vector2.new

-- Ссылки на твои скрипты (замени AgostDead, если ник другой)
local LINKS = {
    MainScript = "https://raw.githubusercontent.com/AgostDead/tss/main/script.lua",
    Dupe = "https://raw.githubusercontent.com/AgostDead/tss/main/dupe.lua",
    SpyItems = "https://raw.githubusercontent.com/AgostDead/tss/main/spyitems.lua",
    Whitelist = "https://raw.githubusercontent.com/AgostDead/tss/main/whitelist.txt"
}

-- ============================================
--  ПРОВЕРКА WHITELIST
-- ============================================
local function CheckWhitelist()
    local success, data = pcall(function()
        return game:HttpGet(LINKS.Whitelist)
    end)
    
    if success and data then
        local myId = tostring(game.Players.LocalPlayer.UserId)
        if string.find(data, myId) then
            return true
        end
    end
    return false
end

if not CheckWhitelist() then
    game.Players.LocalPlayer:Kick("❌ Ты не в вайтлисте! Купи доступ у AgostDead.")
    return
end

-- ============================================
--  СОЗДАНИЕ ОКНА
-- ============================================
local v6 = lib.AddWindow(lib, "TSS Hub | AgostDead", {
	main_color = color3,
	min_size = vector2New(500, 400),
	can_resize = false
})

local MainTab = v6:AddTab("Main")
local ScriptsTab = v6:AddTab("Scripts")

MainTab:AddLabel("Добро пожаловать в TSS Hub!").TextSize = 20
MainTab:AddLabel("Твой ID: " .. game.Players.LocalPlayer.UserId)

ScriptsTab:AddLabel("Нажми на кнопку, чтобы загрузить скрипт")

-- ============================================
--  ФУНКЦИЯ ЗАКРЫТИЯ МЕНЮ ХАБА
-- ============================================
local function CloseHub()
    pcall(function()
        -- Пробуем все возможные методы закрытия окна у lib
        if v6.Destroy then v6:Destroy() end
        if v6.Close then v6:Close() end
        if v6.Remove then v6:Remove() end
        if v6.Hide then v6:Hide() end
        if v6.SetVisible then v6:SetVisible(false) end
    end)
    -- Дополнительно: скрываем все ScreenGui, созданные хабом
    pcall(function()
        for _, gui in ipairs(game:GetService("CoreGui"):GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name ~= "AFK_BlackScreen_System" then
                -- не трогаем Rayfield, только потенциальные GUI хаба
            end
        end
    end)
end

-- Кнопка 1: Загрузка основного скрипта
ScriptsTab:AddButton("📜 Загрузить Основной Скрипт", function()
    CloseHub()
    task.wait(0.3) -- даём время закрыться старому UI
    local success, err = pcall(function()
        loadstring(game:HttpGet(LINKS.MainScript))()
    end)
    if not success then warn("Ошибка: " .. tostring(err)) end
end)

-- Кнопка 2: Загрузка дюпа
ScriptsTab:AddButton("💎 Загрузить Dupe Glitch", function()
    CloseHub()
    task.wait(0.3)
    local success, err = pcall(function()
        loadstring(game:HttpGet(LINKS.Dupe))()
    end)
    if not success then warn("Ошибка: " .. tostring(err)) end
end)

-- Кнопка 3: Spy Items
ScriptsTab:AddButton("🕵️ Загрузить Spy Items", function()
    CloseHub()
    task.wait(0.3)
    local success, err = pcall(function()
        loadstring(game:HttpGet(LINKS.SpyItems))()
    end)
    if not success then warn("Ошибка: " .. tostring(err)) end
end)
