-- ============================================
--  TSS SCRIPT - PAINKILLERSHUB (FLUENT UI)
-- ============================================
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local THEME_FILE = "PainKillersHub_Theme.json"
local savedTheme = "Dark"
local currentTheme = "Dark"

pcall(function()
    if isfile(THEME_FILE) then
        local data = HttpService:JSONDecode(readfile(THEME_FILE))
        if data and data.ThemeName then 
            savedTheme = data.ThemeName 
            currentTheme = data.ThemeName
        end
    end
end)

-- 2. BLACKLIST CHECK (Проверка на бан)
local BlacklistURL = "https://raw.githubusercontent.com/AgostDead/tss/main/blacklist.json"
local bannedUsersList = {}

local function CheckBan()
    local response = nil
    local success, err = pcall(function()
        response = game:HttpGet(BlacklistURL)
    end)

    if success and response and response ~= "" then
        local successDecode, bannedUsers = pcall(function() 
            return HttpService:JSONDecode(response) 
        end)

        if successDecode and type(bannedUsers) == "table" then
            bannedUsersList = bannedUsers
            local myId = LocalPlayer.UserId

            for _, bannedId in ipairs(bannedUsers) do
                if tonumber(bannedId) == myId then
                    LocalPlayer:Kick("\n🔨 ВЫ ЗАБАНЕНЫ В BLACKLIST")
                    task.wait(9e9)
                end
            end
        else
            warn("[Blacklist] JSON File syntax error!")
        end
    else
        warn("System error: cant check BlacklistURL | Detail:", err)
    end
end

CheckBan()

local OWNER_USER_ID = 9295465868
local IsOwnerInServer = "False (in this server)"

local function SetupOwnerTag(player)
    if player.UserId == OWNER_USER_ID then
        local function ApplyTag(character)
            local head = character:WaitForChild("Head", 10)
            if head and not head:FindFirstChild("OwnerBillboardGui") then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "OwnerBillboardGui"
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = "👑PainKillers Owner👑"
                label.TextColor3 = Color3.fromRGB(255, 215, 0)
                label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                label.TextStrokeTransparency = 0
                label.TextSize = 20
                label.Font = Enum.Font.SourceSansBold
                label.Parent = billboard

                billboard.Parent = head
            end
        end

        if player.Character then ApplyTag(player.Character) end
        player.CharacterAdded:Connect(ApplyTag)
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    SetupOwnerTag(p)
end
Players.PlayerAdded:Connect(SetupOwnerTag)

if game:GetService("Players"):GetPlayerByUserId(OWNER_USER_ID) then
    IsOwnerInServer = "True (in this server) 👑"
    task.spawn(function() 
        task.wait(1.5) 
        -- playSound(12221944, 0.8) -- Закомментировал, если нет функции
    end)
end

game:GetService("Players").PlayerAdded:Connect(function(player)
    if player.UserId == OWNER_USER_ID then
        -- playSound(12221944, 0.8) 
        Fluent:Notify({
            Title = "TSS Alert",
            Content = "Creator Angry66gsjjd YT has just joined the game!",
            Duration = 5,
        })
    end
end)

-- Создаем окно Fluent
local Window = Fluent:MakeWindow({
    Title = "TSS Script - PainKillersHub",
    SubTitle = "Made by Angry66gsjjd YT",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = savedTheme,
    MinimizeKey = Enum.KeyCode.RightControl
})

getgenv().AutoCollect = false
getgenv().CollectSpeed = 0.05

getgenv().AutoCrown = false
getgenv().ImmuneMyself = false
getgenv().AutoCombat = false
getgenv().AutoEquipCombat = false
getgenv().AutoEquipWeight = false

getgenv().LockPosition = false
getgenv().SavedCFrame = nil

for i = 1, 6 do
    getgenv()["AutoSac" .. i] = false
    getgenv()["AutoAsc" .. i] = false
end

getgenv().AutoSolution = false
getgenv().HideAnswer = false
getgenv().DelayMin = 0.5
getgenv().DelayMax = 1.0

getgenv().WS_Value = nil
getgenv().JP_Value = nil

getgenv().AutoBossTitan = false
getgenv().AutoBossMuscle = false
getgenv().AutoBossWhite = false
getgenv().AutoBossGreen = false

getgenv().AutoBossMulti_8_43 = false
getgenv().AutoBossMulti_8_200 = false
getgenv().AutoBossMulti_8_1K = false

getgenv().LowGraphics = false
getgenv().NightTimeMode = false
getgenv().AutoJumpAFK = false
getgenv().AutoJumpDelay = 5
getgenv().EnableFPSLimit = false
getgenv().TargetFPS = 60

getgenv().TargetBoxName = ""
getgenv().AutoOpenBox = false

local AFKStartTime = 0

local BlackFrameGui = Instance.new("ScreenGui")
local BlackFrame = Instance.new("Frame")
local TimerLabel = Instance.new("TextLabel")
local BlackFPSLabel = Instance.new("TextLabel")

BlackFrameGui.Name = "AFK_BlackScreen_System"
BlackFrameGui.IgnoreGuiInset = true
BlackFrameGui.Enabled = false

BlackFrame.Size = UDim2.new(1, 0, 1, 0)
BlackFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BlackFrame.Parent = BlackFrameGui

TimerLabel.Size = UDim2.new(1, 0, 0, 50)
TimerLabel.Position = UDim2.new(0, 0, 0.5, -40)
TimerLabel.BackgroundTransparency = 1
TimerLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
TimerLabel.TextSize = 24
TimerLabel.Font = Enum.Font.SourceSansBold
TimerLabel.Text = "AFKing Off"
TimerLabel.Parent = BlackFrame

BlackFPSLabel.Size = UDim2.new(1, 0, 0, 30)
BlackFPSLabel.Position = UDim2.new(0, 0, 0.5, 20)
BlackFPSLabel.BackgroundTransparency = 1
BlackFPSLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BlackFPSLabel.TextSize = 18
BlackFPSLabel.Font = Enum.Font.SourceSans
BlackFPSLabel.Text = "FPS: --"
BlackFPSLabel.Parent = BlackFrame

pcall(function()
    BlackFrameGui.Parent = game:GetService("CoreGui")
end)

task.spawn(function()
    while true do
        if BlackFrameGui.Enabled then
            local elapsed = os.time() - AFKStartTime
            local hours = math.floor(elapsed / 3600)
            local minutes = math.floor((elapsed % 3600) / 60)
            local seconds = elapsed % 60
            TimerLabel.Text = string.format("AFKing On.. Time AFKing: [%02d:%02d:%02d]", hours, minutes, seconds)
        end
        task.wait(1)
    end
end)

local function SafeTP(pos)
   local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
   local hrp = char:WaitForChild("HumanoidRootPart", 5)
   if hrp then
      hrp.CFrame = CFrame.new(pos)
   end
end

----------------------------------------------------
-- 🌐 TAB MAIN
----------------------------------------------------
local MainTab = Window:AddTab({ Title = "Main", Icon = "home" })

MainTab:AddToggle("AutoCollect", {
   Title = "💧 Auto Collect Drops",
   Default = false,
   Callback = function(Value)
      getgenv().AutoCollect = Value
      if Value then
         task.spawn(function()
            while getgenv().AutoCollect do
               local char = LocalPlayer.Character
               if char and char:FindFirstChild("Head") then
                  local worlds = {"World1", "World2", "World3", "World4", "World5", "World6", "World7", "World8", "World9"}
                  for _, wName in pairs(worlds) do
                     local folder = workspace:FindFirstChild("Add") and workspace.Add:FindFirstChild(wName)
                     if folder then
                        for _, item in pairs(folder:GetChildren()) do
                           if item:IsA("BasePart") then
                              item.CanCollide = false
                              item.CFrame = char.Head.CFrame
                           end
                        end
                     end
                  end
               end
               task.wait(getgenv().CollectSpeed)
            end
         end)
      end
   end,
})

MainTab:AddInput("CollectSpeed", {
   Title = "💧 Collect Speed ⚡️",
   Default = "0.05",
   Placeholder = "Default: 0.05",
   Callback = function(Text)
      local num = tonumber(Text)
      getgenv().CollectSpeed = num or 0.05
   end,
})

MainTab:AddSection("— Player Utilities —")

MainTab:AddToggle("CrownToggle", {
   Title = "👑 Auto Get Crown (Tp)",
   Default = false,
   Callback = function(Value)
      getgenv().AutoCrown = Value
      if Value then
         task.spawn(function()
            while getgenv().AutoCrown do
               SafeTP(Vector3.new(-11, 5, -152))
               task.wait(0.5)
            end
         end)
      end
   end,
})

MainTab:AddToggle("ImmuneToggle", {
   Title = "🛡️ Immune Myself",
   Default = false,
   Callback = function(Value)
      getgenv().ImmuneMyself = Value
      if Value then
         task.spawn(function()
            while getgenv().ImmuneMyself do
               pcall(function()
                  local safePart = workspace:FindFirstChild("Area") and workspace.Area:FindFirstChild("Safe") and workspace.Area.Safe:FindFirstChild("world")
                  local char = LocalPlayer.Character
                  local hrp = char and char:FindFirstChild("HumanoidRootPart")
                  if safePart and hrp then
                     firetouchinterest(hrp, safePart, 0)
                     task.wait()
                     firetouchinterest(hrp, safePart, 1)
                  end
               end)
               task.wait(0.01)
            end
         end)
      end
   end,
})

MainTab:AddToggle("CombatToggle", {
   Title = "🥊 Auto Combat",
   Default = false,
   Callback = function(Value)
      getgenv().AutoCombat = Value
      if Value then
         task.spawn(function()
            while getgenv().AutoCombat do
               local char = LocalPlayer.Character
               if char and char:FindFirstChild("Combat") then
                  local args = { LocalPlayer }
                  char.Combat.RemoteUse:FireServer(unpack(args))
               end
               task.wait(0.1)
            end
         end)
      end
   end,
})

MainTab:AddToggle("EquipCombatToggle", {
   Title = "🥊 Auto Equip Combat",
   Default = false,
   Callback = function(Value)
      getgenv().AutoEquipCombat = Value
      if Value then
         if getgenv().AutoEquipWeight then
            getgenv().AutoEquipWeight = false
            if Options.EquipWeightToggle then
               Options.EquipWeightToggle:Set(false)
            end
         end
         task.spawn(function()
            while getgenv().AutoEquipCombat do
               local backpack = LocalPlayer:FindFirstChild("Backpack")
               local char = LocalPlayer.Character
               if backpack and char then
                  local combatTool = backpack:FindFirstChild("Combat")
                  local alreadyEquipped = char:FindFirstChild("Combat")
                  if combatTool and not alreadyEquipped and char:FindFirstChildOfClass("Humanoid") then
                     char:FindFirstChildOfClass("Humanoid"):EquipTool(combatTool)
                  end
               end
               task.wait(0.5)
            end
         end)
      end
   end,
})

MainTab:AddToggle("EquipWeightToggle", {
   Title = "🏋️ Auto Equip Weight",
   Default = false,
   Callback = function(Value)
      getgenv().AutoEquipWeight = Value
      if Value then
         if getgenv().AutoEquipCombat then
            getgenv().AutoEquipCombat = false
            if Options.EquipCombatToggle then
               Options.EquipCombatToggle:Set(false)
            end
         end
         task.spawn(function()
            while getgenv().AutoEquipWeight do
               local backpack = LocalPlayer:FindFirstChild("Backpack")
               local char = LocalPlayer.Character
               if backpack and char then
                  local weightTool = backpack:FindFirstChild("Weight")
                  local alreadyEquipped = char:FindFirstChild("Weight")
                  if weightTool and not alreadyEquipped and char:FindFirstChildOfClass("Humanoid") then
                     char:FindFirstChildOfClass("Humanoid"):EquipTool(weightTool)
                  end
               end
               task.wait(0.5)
            end
         end)
      end
   end,
})

MainTab:AddToggle("LockPosToggle", {
   Title = "🔒 Lock Position [Sac & Asc]",
   Default = false,
   Callback = function(Value)
      getgenv().LockPosition = Value
      if Value then
         local char = LocalPlayer.Character
         local hrp = char and char:FindFirstChild("HumanoidRootPart")
         if hrp then
            getgenv().SavedCFrame = hrp.CFrame
         end
         task.spawn(function()
            while getgenv().LockPosition do
               local currentChar = LocalPlayer.Character
               local currentHrp = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
               local humanoid = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
               if currentHrp and getgenv().SavedCFrame then
                  if (humanoid and humanoid.Health > 0) and (currentHrp.Position - getgenv().SavedCFrame.Position).Magnitude > 3 then
                     currentHrp.CFrame = getgenv().SavedCFrame
                  end
               end
               task.wait(0.1)
            end
         end)
      else
         getgenv().SavedCFrame = nil
      end
   end,
})

MainTab:AddSection("— Sacrifice —")
for i = 1, 6 do
   MainTab:AddToggle("SacFlag" .. i, {
      Title = "🔥 Auto Sac " .. i,
      Default = false,
      Callback = function(Value)
         getgenv()["AutoSac" .. i] = Value
      end,
   })
end

MainTab:AddSection("— Ascension —")
for i = 1, 6 do
   MainTab:AddToggle("AscFlag" .. i, {
      Title = "✨️ Auto Asc " .. i,
      Default = false,
      Callback = function(Value)
         getgenv()["AutoAsc" .. i] = Value
      end,
   })
end

-- ЛОГИКА SAC -> ASC (твой оригинальный код, оставлен как есть)
local function GetStatsSnapshot()
    local snapshot = {}
    local stats = LocalPlayer:FindFirstChild("Stats")
    if not stats then return snapshot end
    for _, obj in ipairs(stats:GetDescendants()) do
        if obj:IsA("ValueBase") then
            local ok, val = pcall(function() return obj.Value end)
            if ok and type(val) == "number" then
                snapshot[obj:GetFullName()] = val
            end
        end
    end
    return snapshot
end

local function WaitForAnyStatChange(prevSnapshot, timeout)
    local startTime = tick()
    while tick() - startTime < (timeout or 4) do
        local now = GetStatsSnapshot()
        for name, oldVal in pairs(prevSnapshot) do
            local newVal = now[name]
            if newVal ~= nil and newVal ~= oldVal then
                return true, name, oldVal, newVal
            end
        end
        task.wait(0.1)
    end
    return false
end

task.spawn(function()
    local remoteFolder = game:GetService("ReplicatedStorage")
        :WaitForChild("Remote")
        :WaitForChild("FromLocalForServer")
        :WaitForChild("Get")

    for i = 1, 6 do
        task.spawn(function()
            while true do
                local sacEnabled = getgenv()["AutoSac" .. i]
                local ascEnabled = getgenv()["AutoAsc" .. i]

                if not sacEnabled and not ascEnabled then
                    task.wait(0.2)
                else
                    local sacRemote = remoteFolder:FindFirstChild("sac" .. i)
                    local ascRemote = remoteFolder:FindFirstChild("asc" .. i)

                    if sacEnabled and sacRemote then
                        local before = GetStatsSnapshot()
                        sacRemote:FireServer()
                        WaitForAnyStatChange(before, 4)
                    end

                    if ascEnabled and ascRemote then
                        local before = GetStatsSnapshot()
                        ascRemote:FireServer()
                        WaitForAnyStatChange(before, 4)
                    end
                    task.wait(0.2)
                end
            end
        end)
    end
end)

MainTab:AddSection("— Auto Solution ChatQuest V2 —")
local SolutionLabel = MainTab:AddLabel("Last Math: None | Reward: None")

MainTab:AddToggle("HideAnswerToggle", {
   Title = "🛑 Hide Answer",
   Default = false,
   Callback = function(Value)
      getgenv().HideAnswer = Value
   end,
})

MainTab:AddInput("DelayMinInput", {
   Title = "🕛 Delay Answer Min",
   Default = "0.5",
   Placeholder = "Default: 0.5",
   Callback = function(Text)
      local num = tonumber(Text)
      if num then getgenv().DelayMin = num end
   end,
})

MainTab:AddInput("DelayMaxInput", {
   Title = "🕧 Delay Answer Max",
   Default = "1.0",
   Placeholder = "Default: 1.0",
   Callback = function(Text)
      local num = tonumber(Text)
      if num then getgenv().DelayMax = num end
   end,
})

-- ... остальные функции solveAndAnswer без изменений ...
-- (Вставь сюда свои функции solveAndAnswer и TextChatService, они не зависят от UI)

----------------------------------------------------
-- 🌐 TAB TELEPORT
----------------------------------------------------
local TPTab = Window:AddTab({ Title = "Teleport", Icon = "map-pin" })
local locations = {
   ["World 1"] = Vector3.new(-13, 4, -82),
   ["World 2"] = Vector3.new(294, 4, -84),
   ["World 3"] = Vector3.new(-53, 5, 269),
   ["World 4"] = Vector3.new(282, 4, 272),
   ["World 5"] = Vector3.new(0, 4, -364),
   ["World 6"] = Vector3.new(-318, 49, -46),
   ["World 7"] = Vector3.new(-236, 84, -352),
   ["World 8"] = Vector3.new(-549, 151, -310),
   ["World 9"] = Vector3.new(217, 74, -608),
}
local sortedWorlds = {"World 1", "World 2", "World 3", "World 4", "World 5", "World 6", "World 7", "World 8", "World 9"}

for _, name in ipairs(sortedWorlds) do
   TPTab:AddButton({
      Title = "Teleport to " .. name,
      Callback = function() 
         if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(locations[name])
         end
      end,
   })
end

----------------------------------------------------
-- 🌐 TAB PLAYERS
----------------------------------------------------
local PlayerTab = Window:AddTab({ Title = "Players", Icon = "users" })

PlayerTab:AddSlider("WalkSpeed", {
   Title = "⚡️ Walkspeed",
   Default = 16,
   Min = 1,
   Max = 125,
   Rounding = 1,
   Callback = function(Value) 
      getgenv().WS_Value = Value 
      local char = LocalPlayer.Character
      local hum = char and char:FindFirstChildOfClass("Humanoid")
      if hum then hum.WalkSpeed = Value end
   end,
})

PlayerTab:AddSlider("JumpPower", {
   Title = "⚡️ Jumppower",
   Default = 50,
   Min = 1,
   Max = 150,
   Rounding = 1,
   Callback = function(Value) 
      getgenv().JP_Value = Value 
      local char = LocalPlayer.Character
      local hum = char and char:FindFirstChildOfClass("Humanoid")
      if hum then hum.JumpPower = Value end
   end,
})

local function ApplyCustomStats(character)
   local humanoid = character:WaitForChild("Humanoid", 5)
   if not humanoid then return end

   humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
      if getgenv().WS_Value ~= nil and humanoid.WalkSpeed ~= getgenv().WS_Value then
         humanoid.WalkSpeed = getgenv().WS_Value
      end
   end)

   humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
      if getgenv().JP_Value ~= nil and humanoid.JumpPower ~= getgenv().JP_Value then
         humanoid.JumpPower = getgenv().JP_Value
      end
   end)

   if getgenv().WS_Value ~= nil then humanoid.WalkSpeed = getgenv().WS_Value end
   if getgenv().JP_Value ~= nil then humanoid.JumpPower = getgenv().JP_Value end
end

if LocalPlayer.Character then ApplyCustomStats(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(ApplyCustomStats)

----------------------------------------------------
-- 🌀 TAB GLITCHES
----------------------------------------------------
local GlitchesTab = Window:AddTab({ Title = "Glitches", Icon = "bug" })

GlitchesTab:AddButton({
    Title = "Fire ISpySomeonesItems",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AgostDead/tss/main/spyitems.lua"))()
    end
})

GlitchesTab:AddButton({
    Title = "Fire Rolling Reward [LIMITED]",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AgostDead/tss/main/dupe.lua"))()
    end
})

----------------------------------------------------
-- ⚔️ TAB AUTO FARM (Bosses)
----------------------------------------------------
local BossTab = Window:AddTab({ Title = "Auto Farm", Icon = "swords" })

local function EquipCombatTool()
    pcall(function()
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        local char = LocalPlayer.Character
        if backpack and char then
            local combatTool = backpack:FindFirstChild("Combat")
            local equippedTool = char:FindFirstChild("Combat")
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if combatTool and not equippedTool and humanoid then
                humanoid:EquipTool(combatTool)
            end
        end
    end)
end

BossTab:AddSection("— All Bosses Status —")
local CombinedStatusLabel = BossTab:AddLabel("Titan: ... | Muscle: ... | White: ... | Green: ...")

-- ... (Функция GetBossSpawnData без изменений) ...
-- ... (Функция checkBoardState без изменений) ...

BossTab:AddSection("— Single Boss —")

BossTab:AddToggle("AutoBossTitanFlag", {
   Title = "⚔️ Auto Boss lvl 8 (Titan)",
   Default = false,
   Callback = function(Value)
      if Value then DisableOtherBossToggles("AutoBossTitanFlag") else getgenv().AutoBossTitan = false end
   end,
})

BossTab:AddToggle("AutoBossMuscleFlag", {
   Title = "⚔️ Auto Boss lvl 43 (Muscle)",
   Default = false,
   Callback = function(Value)
      if Value then DisableOtherBossToggles("AutoBossMuscleFlag") else getgenv().AutoBossMuscle = false end
   end,
})

BossTab:AddToggle("AutoBossWhiteFlag", {
   Title = "⚔️ Auto Boss lvl 200 (White)",
   Default = false,
   Callback = function(Value)
      if Value then DisableOtherBossToggles("AutoBossWhiteFlag") else getgenv().AutoBossWhite = false end
   end,
})

BossTab:AddToggle("AutoBossGreenFlag", {
   Title = "⚔️ Auto Boss lvl 1K (Green)",
   Default = false,
   Callback = function(Value)
      if Value then DisableOtherBossToggles("AutoBossGreenFlag") else getgenv().AutoBossGreen = false end
   end,
})

BossTab:AddSection("— Multi Boss (Loop) —")

BossTab:AddToggle("AutoBossMulti_8_43_Flag", {
   Title = "🔄 Auto Boss lvl 8 -> 43",
   Default = false,
   Callback = function(Value)
      if Value then DisableOtherBossToggles("AutoBossMulti_8_43_Flag") else getgenv().AutoBossMulti_8_43 = false end
   end,
})

BossTab:AddToggle("AutoBossMulti_8_200_Flag", {
   Title = "🔄 Auto Boss lvl 8 -> 200",
   Default = false,
   Callback = function(Value)
      if Value then DisableOtherBossToggles("AutoBossMulti_8_200_Flag") else getgenv().AutoBossMulti_8_200 = false end
   end,
})

BossTab:AddToggle("AutoBossMulti_8_1K_Flag", {
   Title = "🔄 Auto Boss lvl 8 -> 1K",
   Default = false,
   Callback = function(Value)
      if Value then DisableOtherBossToggles("AutoBossMulti_8_1K_Flag") else getgenv().AutoBossMulti_8_1K = false end
   end,
})

-- ... (Функции IsBossAvailableToWait, AttackBossTarget, ExecuteBossLogic остаются без изменений) ...

----------------------------------------------------
-- 📦 TAB BOX
----------------------------------------------------
local BoxTab = Window:AddTab({ Title = "Box", Icon = "box" })

BoxTab:AddSection("— Box Opener System —")

BoxTab:AddInput("TargetBoxNameInput", {
   Title = "📦 Target Box Name",
   Default = "",
   Placeholder = 'Type "Box1", "Box2" etc.',
   Callback = function(Text)
      getgenv().TargetBoxName = Text
   end,
})

BoxTab:AddToggle("AutoOpenBoxFlag", {
   Title = "🔄 Auto Open Box",
   Default = false,
   Callback = function(Value)
      getgenv().AutoOpenBox = Value
      if Value then
         task.spawn(function()
            while getgenv().AutoOpenBox do
               if getgenv().TargetBoxName and getgenv().TargetBoxName ~= "" then
                  pcall(function()
                     local autoRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Remote")
                        and game.ReplicatedStorage.Remote:FindFirstChild("FromServerForLocal")
                        and game.ReplicatedStorage.Remote.FromServerForLocal:FindFirstChild("Box")
                        and game.ReplicatedStorage.Remote.FromServerForLocal.Box:FindFirstChild("AutoOpen")
                     if autoRemote then
                        autoRemote:FireServer(getgenv().TargetBoxName)
                     end
                  end)
               end
               task.wait(0.1)
            end
         end)
      end
   end,
})

BoxTab:AddButton({
   Title = "🔓 Open Box (Once)",
   Callback = function()
      if not getgenv().TargetBoxName or getgenv().TargetBoxName == "" then
         return Fluent:Notify({
            Title = "Box Opener",
            Content = "Please enter a valid Box Name (e.g. Box1) first!",
            Duration = 3
         })
      end
      local success = pcall(function()
         local boxRemoteFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Remote")
            and game.ReplicatedStorage.Remote:FindFirstChild("FromServerForLocal")
            and game.ReplicatedStorage.Remote.FromServerForLocal:FindFirstChild("Box")
         if boxRemoteFolder then
            local specificBoxRemote = boxRemoteFolder:FindFirstChild(getgenv().TargetBoxName)
            if specificBoxRemote then
               specificBoxRemote:FireServer()
            else
               boxRemoteFolder[getgenv().TargetBoxName]:FireServer()
            end
         end
      end)
      if success then
         Fluent:Notify({Title = "Box Opener", Content = "Fired Open Remote for " .. getgenv().TargetBoxName, Duration = 2})
      else
         Fluent:Notify({Title = "Error", Content = "Could not find remote for: " .. getgenv().TargetBoxName, Duration = 3})
      end
   end,
})

BoxTab:AddSection("— Box Price List —")
BoxTab:AddParagraph({ Title = "💵 Cash Boxes", Content = "• Box1 = Free\n• Box2 = 1K Cash\n• Box3 = 1M Cash\n• Box4 = 1T Cash\n• Box5 = 1Sx Cash" })
BoxTab:AddParagraph({ Title = "✨ Ascension Boxes", Content = "• Box6 = 0.1 Asc\n• Box7 = 100 Asc\n• Box8 = 1K Asc\n• Box9 = 10K Asc\n• Box10 = 40K Asc\n• Box11 = 400K Asc" })
BoxTab:AddParagraph({ Title = "💎 Diamond Boxes", Content = "• DiamondBox1 = 10 Diamond\n• DiamondBox2 = 100 Diamond\n• DiamondBox3 = 300 Diamond" })
BoxTab:AddParagraph({ Title = "👑 Crown Boxes", Content = "• CrownBox1 = 1B Crown\n• CrownBox2 = 1T Crown" })

----------------------------------------------------
-- 💤 TAB AFK MODE
----------------------------------------------------
local AFKTab = Window:AddTab({ Title = "AFK Mode", Icon = "coffee" })
local UIFPSLabel = AFKTab:AddLabel("Current Hub FPS: --")
local frameCount = 0
local elapsedTime = 0

RunService.RenderStepped:Connect(function(deltaTime)
    frameCount = frameCount + 1
    elapsedTime = elapsedTime + deltaTime
    if elapsedTime >= 0.1 then
        local currentFPS = math.floor(frameCount / elapsedTime)
        UIFPSLabel:Set("Current Hub FPS: " .. currentFPS)
        if BlackFrameGui.Enabled then
            BlackFPSLabel.Text = "Current FPS: " .. currentFPS
        end
        frameCount = 0
        elapsedTime = 0
    end
end)

AFKTab:AddSection("— Graphics & Optimization —")

AFKTab:AddToggle("LowGraphicsFlag", {
   Title = "📉 Force Graphics to Lowest",
   Default = false,
   Callback = function(Value)
      getgenv().LowGraphics = Value
      if Value then
         pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
      else
         pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic end)
      end
   end,
})

AFKTab:AddButton({
   Title = "🗑️ Clear Map Textures",
   Callback = function()
      pcall(function()
         for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("Sky") then
               obj:Destroy()
            elseif obj:IsA("BasePart") then
               obj.Material = Enum.Material.SmoothPlastic
            end
         end
         Fluent:Notify({Title = "AFK Optimizer", Content = "All textures and decals cleared!", Duration = 3})
      end)
   end,
})

AFKTab:AddToggle("NightTimeFlag", {
   Title = "🌙 Night Time Mode",
   Default = false,
   Callback = function(Value)
      getgenv().NightTimeMode = Value
      if Value then
         task.spawn(function()
            while getgenv().NightTimeMode do
               game:GetService("Lighting").ClockTime = 0
               task.wait(1)
            end
         end)
      else
         game:GetService("Lighting").ClockTime = 12
      end
   end,
})

AFKTab:AddSection("— FPS Engine Controller —")

AFKTab:AddToggle("EnableFPSLimitFlag", {
    Title = "🚀 Enable FPS Limit",
    Default = false,
    Callback = function(Value)
        getgenv().EnableFPSLimit = Value
        if Value then
            if setfpscap then pcall(function() setfpscap(getgenv().TargetFPS) end) end
        else
            if setfpscap then pcall(function() setfpscap(60) end) end
        end
    end,
})

AFKTab:AddInput("SetFPSInput", {
    Title = "⌨️ Set FPS Value",
    Default = "60",
    Placeholder = "E.g. 30, 45, 60",
    Callback = function(Text)
        local num = tonumber(Text)
        if num and num > 0 then 
            getgenv().TargetFPS = num
            if getgenv().EnableFPSLimit and setfpscap then 
                pcall(function() setfpscap(num) end)
            end
        end
    end,
})

AFKTab:AddSection("— Black Screen Mode —")

AFKTab:AddToggle("Disable3DFlag", {
   Title = "🖥️ Disable 3D Rendering (Black Screen Fix)",
   Default = false,
   Callback = function(Value)
      BlackFrameGui.Enabled = Value
      if Value then
         AFKStartTime = os.time()
         pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
      end
   end,
})

AFKTab:AddSection("— Auto-AFK (Anti-Disconnect) —")

AFKTab:AddToggle("AutoJumpFlag", {
   Title = "🦘 Auto Jump",
   Default = false,
   Callback = function(Value)
      getgenv().AutoJumpAFK = Value
      if Value then
         task.spawn(function()
            while getgenv().AutoJumpAFK do
               local char = LocalPlayer.Character
               local hum = char and char:FindFirstChildOfClass("Humanoid")
               if hum and hum.FloorMaterial ~= Enum.Material.Air then
                  hum:ChangeState(Enum.HumanoidStateType.Jumping)
               end
               task.wait(getgenv().AutoJumpDelay)
            end
         end)
      end
   end,
})

AFKTab:AddInput("AutoJumpDelayInput", {
   Title = "⏱️ Delay Auto Jump (Seconds)",
   Default = "5",
   Placeholder = "Default: 5",
   Callback = function(Text)
      local num = tonumber(Text)
      getgenv().AutoJumpDelay = (num and num > 0) and num or 5
   end,
})

----------------------------------------------------
-- 👤 TAB CREDITS
----------------------------------------------------
local CreditTab = Window:AddTab({ Title = "Credits", Icon = "info" }) 

CreditTab:AddSection("— Blacklist Players —")

if #bannedUsersList == 0 then
    CreditTab:AddParagraph({ Title = "🚫 Banned List", Content = "No one got banned from using TSS Script - PainKillersHub!" })
else
    local bannedText = ""
    for _, id in ipairs(bannedUsersList) do
        local username = "Unknown"
        pcall(function() username = Players:GetNameFromUserIdAsync(tonumber(id)) end)
        bannedText = bannedText .. string.format("%s (@%s) got Banned\n", tostring(id), username)
    end
    CreditTab:AddParagraph({ Title = "🔨 Banned List", Content = bannedText })
end

CreditTab:AddSection("— Owner Info —")
CreditTab:AddParagraph({ Title = "👤 Creator Information", Content = "Owner & Creator: NoneUsername0813\nStatus: " .. IsOwnerInServer })
CreditTab:AddParagraph({ Title = "💬 Message", Content = "Thank for using my script! If you see any issue in this script, comment it on Scriptblox web. Love you all!" })

----------------------------------------------------
-- 📢 TAB UPDATE
----------------------------------------------------
local UpdateTab = Window:AddTab({ Title = "Update", Icon = "file-text" })
UpdateTab:AddSection("— Latest Changelog —")
UpdateTab:AddParagraph({ Title = "📩 What's new in v1.6.5?", Content = "• In Version 1.6.5\nWe added\n- Tab: Glitches\n- \"Sol RNG Simulator\" at tab Glitches" })
UpdateTab:AddParagraph({ Title = "📩 What's new in v1.6.4.5?", Content = "• In Version 1.6.4.5\nWe added\n- Auto Join Battle\n\nNote: We are developing Auto Kill Players in Battle and Auto Farm Mods so just be patient and wait." })
UpdateTab:AddParagraph({ Title = "📩 What's new in v1.6.4.25?", Content = "• In Version 1.6.4.25\nWe fixed\n- Auto Boss bug lost Combat tool" })

----------------------------------------------------
-- 💬 TAB COMMENT
----------------------------------------------------
local CommentTab = Window:AddTab({ Title = "Comment", Icon = "message-square" })
CommentTab:AddSection("— Send Your Feedback —")
CommentTab:AddParagraph({ Title = "📩 Give us a review or suggestion to our script!", Content = "Type your review, bug report, or new feature request below and click 'Send Comment'. It will be sent directly to our inbox." })

local userCommentText = ""
local lastCommentTime = 0
local COMMENT_COOLDOWN = 120
local MESSAGE_LOGGER_WEBHOOK = "-"

CommentTab:AddInput("CommentInput", {
    Title = "💬 Message",
    Default = "",
    Placeholder = "Enter your review or suggestion here...",
    Callback = function(Text)
        userCommentText = Text
    end,
})

CommentTab:AddButton({
    Title = "🚀 Send Comment",
    Callback = function()
        if userCommentText == "" or #userCommentText < 5 then
            return Fluent:Notify({ Title = "Comment Failed", Content = "Please write a meaningful message (at least 5 characters).", Duration = 3 })
        end
        local currentTime = os.time()
        if currentTime - lastCommentTime < COMMENT_COOLDOWN then
            local timeLeft = COMMENT_COOLDOWN - (currentTime - lastCommentTime)
            return Fluent:Notify({ Title = "Please Wait.", Content = string.format("You are sending messages too fast! Wait %d seconds.", timeLeft), Duration = 4 })
        end
        local embedData = {
            ["username"] = "Message Logger",
            ["embeds"] = {{
                ["title"] = "💬 New Player Comment / Feedback!",
                ["description"] = "A player left a review/suggestion for **TSS Script**:",
                ["color"] = 3447003,
                ["fields"] = {
                    { ["name"] = "📝 Message", ["value"] = "```\n" .. userCommentText .. "\n```", ["inline"] = false },
                    { ["name"] = "👤 Player", ["value"] = "**" .. LocalPlayer.Name .. "** (" .. tostring(LocalPlayer.UserId) .. ")", ["inline"] = true },
                    { ["name"] = "🎮 Game Place ID", ["value"] = "**" .. tostring(game.PlaceId) .. "**", ["inline"] = true }
                },
                ["footer"] = { ["text"] = "Message Logger • PainKillersHub" },
                ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }}
        }
        local headers = {["content-type"] = "application/json"}
        local json_data = HttpService:JSONEncode(embedData)
        local requestFunc = syn and syn.request or http_request or fluxus and fluxus.request or request
        if requestFunc then
            requestFunc({ Url = MESSAGE_LOGGER_WEBHOOK, Method = "POST", Headers = headers, Body = json_data })
            lastCommentTime = os.time()
            Fluent:Notify({ Title = "Success.", Content = "You've send your message review to our inbox.", Duration = 4 })
        else
            Fluent:Notify({ Title = "Error", Content = "Your executor does not support HTTP Request!", Duration = 4 })
        end
    end,
})

----------------------------------------------------
-- ⚙️ TAB SETTINGS
----------------------------------------------------
local SettingsTab = Window:AddTab({ Title = "Settings", Icon = "settings" })
SettingsTab:AddSection("🎨 Theme Customization")
local ThemeStatusLabel = SettingsTab:AddLabel("Current Theme: [" .. currentTheme .. "]")

SettingsTab:AddDropdown("ThemeDropdown", {
    Title = "Select Preset Theme",
    Values = {"Dark", "Darker", "Light", "Aqua", "Amethyst", "Rose", "Mint", "Ocean", "Retro", "Sunset"},
    Default = 1,
    Multi = false,
    Callback = function(Option)
        currentTheme = Option
        ThemeStatusLabel:Set("Current Theme: [" .. currentTheme .. "]")
        Fluent:SetTheme(currentTheme)
    end,
})

SettingsTab:AddButton({
    Title = "💾 Save Default Theme",
    Callback = function()
        local data = {ThemeName = currentTheme}
        writefile(THEME_FILE, HttpService:JSONEncode(data))
        Fluent:Notify({ Title = "Success!", Content = "Theme configuration saved successfully!", Duration = 3 })
    end,
})

SettingsTab:AddSection("⚙️ Configuration Management")
SettingsTab:AddParagraph({ Title = "📁 Configs", Content = "Используй вкладку 'Configs' в меню для сохранения и загрузки настроек (встроено в Fluent)." })

----------------------------------------------------
-- УВЕДОМЛЕНИЕ ПРИ ЗАПУСКЕ
----------------------------------------------------
Fluent:Notify({
   Title = "TSS Script",
   Content = "Меню успешно загружено! Версия v1.6.5",
   Duration = 5,
})
