local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local THEME_FILE = "NoneUserHub_Theme.json"
local savedTheme = "Default"
local currentTheme = "Default"
local activeConfigName = "Default"
local targetConfigName = ""

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
                label.Text = "👑Hub Owner👑"
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
        playSound(12221944, 0.8) 
    end)
end

game:GetService("Players").PlayerAdded:Connect(function(player)
    if player.UserId == OWNER_USER_ID then
        playSound(12221944, 0.8) 
        if Rayfield then
            Rayfield:Notify({
                Title = "TSS Alert",
                Content = "Creator NoneUsername0813 has just joined the game!",
                Duration = 5,
            })
        end
    end
end)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "TSS Script - NoneUserHub (World 1)",
   LoadingTitle = "Loading",
   LoadingSubtitle = "Made by NoneUsername0813",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "NoneUserHub",
      FileName = "TSSConfig"
   },
   KeySystem = false,
   Theme = savedTheme 
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

getgenv().AutoJoinBattle = false
getgenv().AutoResetRNG = false
getgenv().ResetDelayValue = 1.0

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
local MainTab = Window:CreateTab("🌐 Main", 4483362458)

MainTab:CreateToggle({
   Name = "💧 Auto Collect Drops",
   CurrentValue = false,
   Flag = "CollectFlag",
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

MainTab:CreateInput({
   Name = "💧 Collect Speed ⚡️",
   PlaceholderText = "Default: 0.05",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local num = tonumber(Text)
      getgenv().CollectSpeed = num or 0.05
   end,
})

MainTab:CreateSection("— Player Utilities —")

MainTab:CreateToggle({
   Name = "👑 Auto Get Crown (Tp)",
   CurrentValue = false,
   Flag = "CrownFlag",
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

MainTab:CreateToggle({
   Name = "🛡️ Immune Myself",
   CurrentValue = false,
   Flag = "ImmuneMyselfFlag",
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

MainTab:CreateToggle({
   Name = "🥊 Auto Combat",
   CurrentValue = false,
   Flag = "CombatFlag",
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

MainTab:CreateToggle({
   Name = "🥊 Auto Equip Combat",
   CurrentValue = false,
   Flag = "EquipCombatFlag",
   Callback = function(Value)
      getgenv().AutoEquipCombat = Value
      if Value then
         if getgenv().AutoEquipWeight then
            getgenv().AutoEquipWeight = false
            if Rayfield.Flags["EquipWeightFlag"] then
               Rayfield.Flags["EquipWeightFlag"]:Set(false)
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

MainTab:CreateToggle({
   Name = "🏋️ Auto Equip Weight",
   CurrentValue = false,
   Flag = "EquipWeightFlag",
   Callback = function(Value)
      getgenv().AutoEquipWeight = Value
      if Value then
         if getgenv().AutoEquipCombat then
            getgenv().AutoEquipCombat = false
            if Rayfield.Flags["EquipCombatFlag"] then
               Rayfield.Flags["EquipCombatFlag"]:Set(false)
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

MainTab:CreateToggle({
   Name = "🔒 Lock Position [Sac & Asc]",
   CurrentValue = false,
   Flag = "LockPosFlag",
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

MainTab:CreateSection("— Sacrifice —")
for i = 1, 6 do
   MainTab:CreateToggle({
      Name = "🔥 Auto Sac " .. i,
      CurrentValue = false,
      Flag = "SacFlag" .. i,
      Callback = function(Value)
         getgenv()["AutoSac" .. i] = Value
      end,
   })
end

MainTab:CreateSection("— Ascension —")
for i = 1, 6 do
   MainTab:CreateToggle({
      Name = "✨️ Auto Asc " .. i,
      CurrentValue = false,
      Flag = "AscFlag" .. i,
      Callback = function(Value)
         getgenv()["AutoAsc" .. i] = Value
      end,
   })
end

task.spawn(function()
   local remoteFolder = game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("FromLocalForServer"):WaitForChild("Get")

   while true do
      local stats = LocalPlayer:FindFirstChild("Stats")
      local levelObj = stats and stats:FindFirstChild("Level")

      if levelObj then
         for i = 1, 6 do
            if getgenv()["AutoSac" .. i] then
               local targetRemote = remoteFolder:FindFirstChild("sac" .. i)
               if targetRemote then targetRemote:FireServer() end
            end
         end

         for i = 1, 6 do
            if getgenv()["AutoAsc" .. i] then
               local targetRemote = remoteFolder:FindFirstChild("asc" .. i)
               if targetRemote then targetRemote:FireServer() end
            end
         end
      end
      task.wait(0.3)
   end
end)

MainTab:CreateSection("— Auto Solution ChatQuest V2 —")
local SolutionLabel = MainTab:CreateLabel("Last Math: None | Reward: None")

MainTab:CreateToggle({
   Name = "🛑 Hide Answer",
   CurrentValue = false,
   Flag = "HideAnswerFlag",
   Callback = function(Value)
      getgenv().HideAnswer = Value
   end,
})

MainTab:CreateInput({
   Name = "🕛 Delay Answer Min",
   PlaceholderText = "Default: 0.5",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local num = tonumber(Text)
      if num then getgenv().DelayMin = num end
   end,
})

MainTab:CreateInput({
   Name = "🕧 Delay Answer Max",
   PlaceholderText = "Default: 1.0",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local num = tonumber(Text)
      if num then getgenv().DelayMax = num end
   end,
})

local currentActiveMathMessage = ""

local function solveAndAnswer(messageText, isManual)
   if not getgenv().AutoSolution and not isManual then return end

   local mathExpression = string.match(messageText, "What is%s+(.-)%s*%?")
   local rewardText = string.match(messageText, "you get:%s*(.*)") or "Unknown"

   if mathExpression then
      local cleanExpression = string.gsub(mathExpression, "[^%d%+%-%*%/%^%.%s]", "")
      local func = loadstring("return " .. cleanExpression)
      if func then
         local success, result = pcall(func)
         if success and result then
            local response = string.format("%.1f", result)
            if response:sub(-2) == ".0" then
               response = string.format("%d", result)
            end

            SolutionLabel:Set(string.format("%s = %s | Reward: %s", cleanExpression, response, rewardText))

            local finalOutput = getgenv().HideAnswer and ("/e " .. response) or response

            local TextChatService = game:GetService("TextChatService")
            local generalChannel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
            if generalChannel then
               if not isManual then
                  local randomDelay = math.random(getgenv().DelayMin * 1000, getgenv().DelayMax * 1000) / 1000
                  task.wait(randomDelay)
                  if getgenv().AutoSolution then
                     generalChannel:SendAsync(finalOutput)
                  end
               else
                  generalChannel:SendAsync(finalOutput)
               end
            end
         end
      end
   end
end

local TextChatService = game:GetService("TextChatService")
for _, channel in ipairs(TextChatService.TextChannels:GetChildren()) do
   channel.MessageReceived:Connect(function(textChatMessage)
      if textChatMessage.Text then
         if string.find(textChatMessage.Text, "What is") and string.find(textChatMessage.Text, "?") then
            currentActiveMathMessage = textChatMessage.Text
         end
         solveAndAnswer(textChatMessage.Text, false)
      end
   end)
end

MainTab:CreateToggle({
   Name = "📄 Auto Solution",
   CurrentValue = false,
   Flag = "SolutionFlag",
   Callback = function(Value)
      getgenv().AutoSolution = Value
   end,
})

MainTab:CreateButton({
   Name = "🧩 Solve Math Now",
   Callback = function()
      if currentActiveMathMessage ~= "" then
         solveAndAnswer(currentActiveMathMessage, true)
         Rayfield:Notify({Title = "Auto Solution", Content = "Math puzzle solved instantly!", Duration = 2})
      else
         Rayfield:Notify({Title = "Auto Solution", Content = "No active math puzzle found in chat history!", Duration = 3})
      end
   end,
})

local Workspace = game:GetService("Workspace")
local addFolder = Workspace:FindFirstChild("Add")

if addFolder then
   addFolder.DescendantAdded:Connect(function(upg)
      if getgenv().AutoSolution and upg:IsA("BasePart") and upg:FindFirstChild("TouchInterest") then
         local char = LocalPlayer.Character
         if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
               firetouchinterest(hrp, upg, 0)
               task.wait(0.1)
               firetouchinterest(hrp, upg, 1)
            end
         end
      end
   end)
end

----------------------------------------------------
-- 🌐 TAB TELEPORT
----------------------------------------------------
local TPTab = Window:CreateTab("🌐 Teleport", 4483362458)
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
   TPTab:CreateButton({
      Name = "Teleport to "..name,
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
local PlayerTab = Window:CreateTab("🌐 Players", 4483362458)
PlayerTab:CreateSlider({
   Name = "⚡️ Walkspeed",
   Range = {1, 125},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "WS_Slider",
   Callback = function(Value) 
      getgenv().WS_Value = Value 
      local char = LocalPlayer.Character
      local hum = char and char:FindFirstChildOfClass("Humanoid")
      if hum then hum.WalkSpeed = Value end
   end,
})

PlayerTab:CreateSlider({
   Name = "⚡️ Jumppower",
   Range = {1, 150},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "JP_Slider",
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
local GlitchesTab = Window:CreateTab("🌀 Glitches", 4483362458)

GlitchesTab:CreateButton({
    Name = "Fire ISpySomeonesItems",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AgostDead/tss/main/spyitems.lua"))()
    end
})

GlitchesTab:CreateButton({
    Name = "Fire Rolling Reward [LIMITED]",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AgostDead/tss/main/dupe.lua"))()
    end
})

----------------------------------------------------
-- ⚔️ TAB AUTO FARM
----------------------------------------------------
local BossTab = Window:CreateTab("⚔️ Auto Farm", 4483362458)

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

BossTab:CreateSection("— All Bosses Status —")
local CombinedStatusLabel = BossTab:CreateLabel("Titan: ... | Muscle: ... | White: ... | Green: ...")

local function GetBossSpawnData(bossName)
    local head = nil
    local healthStr = nil

    pcall(function()
        local mobFolder = workspace:FindFirstChild("RespawnMobs")
            and workspace.RespawnMobs:FindFirstChild(bossName)
            and workspace.RespawnMobs[bossName]:FindFirstChild(bossName)
            and workspace.RespawnMobs[bossName][bossName]:FindFirstChild(bossName)

        if mobFolder then
            local collisionPart = mobFolder:FindFirstChild("Collision")
            if collisionPart then
                collisionPart:Destroy()
            end

            head = mobFolder:FindFirstChild("Head") or mobFolder:FindFirstChild("HumanoidRootPart") or mobFolder:FindFirstChildOfClass("BasePart")
            if head then
                local healthLabel = head:FindFirstChild("BillboardGui")
                    and head.BillboardGui:FindFirstChild("Health2")
                    and head.BillboardGui.Health2:FindFirstChild("Health1")
                if healthLabel and healthLabel:IsA("TextLabel") then
                    healthStr = healthLabel.Text
                end
            end
        end
    end)

    return head, healthStr
end

task.spawn(function()
    while task.wait(0.5) do
        local function checkBoardState(bossName)
            local status = "🚫"
            pcall(function()
                local waitingLabel = workspace:FindFirstChild("Bosses")
                    and workspace.Bosses:FindFirstChild("Waiting")
                    and workspace.Bosses.Waiting:FindFirstChild(bossName)
                    and workspace.Bosses.Waiting[bossName]:FindFirstChild("Part")
                    and workspace.Bosses.Waiting[bossName].Part:FindFirstChild("BillboardGui")
                    and workspace.Bosses.Waiting[bossName].Part.BillboardGui:FindFirstChild("Time")

                if waitingLabel and waitingLabel:IsA("TextLabel") then
                    local text = string.lower(waitingLabel.Text)
                    if string.find(text, "waiting") then
                        status = "✅ (Waiting)"
                    elseif string.find(text, "battle") then
                        status = "⚔️ (Fighting)"
                    elseif string.find(text, "available") then
                        status = "⏳ (Cooldown)"
                    end
                end
            end)
            return status
        end

        CombinedStatusLabel:Set(string.format(
            "Titan: %s | Muscle: %s | White: %s | Green: %s",
            checkBoardState("Titan"),
            checkBoardState("Muscle"),
            checkBoardState("White"),
            checkBoardState("Green")
        ))
    end
end)

local currentWaitingBoss = nil 
local activeTargetBoss = nil    
local currentSequenceIndex = 1
local isBossWaitingDelay = false

local BossToggleFlags = {
    "AutoBossTitanFlag",
    "AutoBossMuscleFlag",
    "AutoBossWhiteFlag",
    "AutoBossGreenFlag",
    "AutoBossMulti_8_43_Flag",
    "AutoBossMulti_8_200_Flag",
    "AutoBossMulti_8_1K_Flag"
}

local function DisableOtherBossToggles(currentFlag)
    getgenv().AutoBossTitan = (currentFlag == "AutoBossTitanFlag")
    getgenv().AutoBossMuscle = (currentFlag == "AutoBossMuscleFlag")
    getgenv().AutoBossWhite = (currentFlag == "AutoBossWhiteFlag")
    getgenv().AutoBossGreen = (currentFlag == "AutoBossGreenFlag")

    getgenv().AutoBossMulti_8_43 = (currentFlag == "AutoBossMulti_8_43_Flag")
    getgenv().AutoBossMulti_8_200 = (currentFlag == "AutoBossMulti_8_200_Flag")
    getgenv().AutoBossMulti_8_1K = (currentFlag == "AutoBossMulti_8_1K_Flag")

    currentWaitingBoss = nil 
    activeTargetBoss = nil   
    currentSequenceIndex = 1
    isBossWaitingDelay = false

    for _, flag in ipairs(BossToggleFlags) do
        if flag ~= currentFlag and Rayfield.Flags[flag] then
            Rayfield.Flags[flag]:Set(false)
        end
    end
end

BossTab:CreateSection("— Single Boss —")

BossTab:CreateToggle({
   Name = "⚔️ Auto Boss lvl 8 (Titan)",
   CurrentValue = false,
   Flag = "AutoBossTitanFlag",
   Callback = function(Value)
      if Value then DisableOtherBossToggles("AutoBossTitanFlag") else getgenv().AutoBossTitan = false end
   end,
})

BossTab:CreateToggle({
   Name = "⚔️ Auto Boss lvl 43 (Muscle)",
   CurrentValue = false,
   Flag = "AutoBossMuscleFlag",
   Callback = function(Value)
      if Value then DisableOtherBossToggles("AutoBossMuscleFlag") else getgenv().AutoBossMuscle = false end
   end,
})

BossTab:CreateToggle({
   Name = "⚔️ Auto Boss lvl 200 (White)",
   CurrentValue = false,
   Flag = "AutoBossWhiteFlag",
   Callback = function(Value)
      if Value then DisableOtherBossToggles("AutoBossWhiteFlag") else getgenv().AutoBossWhite = false end
   end,
})

BossTab:CreateToggle({
   Name = "⚔️ Auto Boss lvl 1K (Green)",
   CurrentValue = false,
   Flag = "AutoBossGreenFlag",
   Callback = function(Value)
      if Value then DisableOtherBossToggles("AutoBossGreenFlag") else getgenv().AutoBossGreen = false end
   end,
})

BossTab:CreateSection("— Multi Boss (Loop) —")

BossTab:CreateToggle({
   Name = "🔄 Auto Boss lvl 8 -> 43",
   CurrentValue = false,
   Flag = "AutoBossMulti_8_43_Flag",
   Callback = function(Value)
      if Value then DisableOtherBossToggles("AutoBossMulti_8_43_Flag") else getgenv().AutoBossMulti_8_43 = false end
   end,
})

BossTab:CreateToggle({
   Name = "🔄 Auto Boss lvl 8 -> 200",
   CurrentValue = false,
   Flag = "AutoBossMulti_8_200_Flag",
   Callback = function(Value)
      if Value then DisableOtherBossToggles("AutoBossMulti_8_200_Flag") else getgenv().AutoBossMulti_8_200 = false end
   end,
})

BossTab:CreateToggle({
   Name = "🔄 Auto Boss lvl 8 -> 1K",
   CurrentValue = false,
   Flag = "AutoBossMulti_8_1K_Flag",
   Callback = function(Value)
      if Value then DisableOtherBossToggles("AutoBossMulti_8_1K_Flag") else getgenv().AutoBossMulti_8_1K = false end
   end,
})

local function IsBossAvailableToWait(bossName)
    local isAvailable = true
    pcall(function()
        local waitingLabel = workspace:FindFirstChild("Bosses")
            and workspace.Bosses:FindFirstChild("Waiting")
            and workspace.Bosses.Waiting:FindFirstChild(bossName)
            and workspace.Bosses.Waiting[bossName]:FindFirstChild("Part")
            and workspace.Bosses.Waiting[bossName].Part.BillboardGui:FindFirstChild("Time")

        if waitingLabel and waitingLabel:IsA("TextLabel") then
            local text = string.lower(waitingLabel.Text)
            if string.find(text, "available") then
                isAvailable = false
            end
        end
    end)
    return isAvailable
end

local function AttackBossTarget(headPart)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or not headPart then return end

    hrp.CFrame = headPart.CFrame * CFrame.new(0, 5, 0)

    local combat = char:FindFirstChild("Combat")
    if combat and combat:FindFirstChild("RemoteUse") then
        combat.RemoteUse:FireServer(LocalPlayer)
    end
end

local function ExecuteBossLogic(bossList)
    if isBossWaitingDelay then return end

    EquipCombatTool()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if activeTargetBoss then
        local head, healthStr = GetBossSpawnData(activeTargetBoss)
        if head and healthStr and healthStr ~= "0" then
            AttackBossTarget(head)
            task.wait(0.025)
            return
        else
            activeTargetBoss = nil
            currentWaitingBoss = nil

            if currentSequenceIndex >= #bossList then
                currentSequenceIndex = 1
            else
                currentSequenceIndex = currentSequenceIndex + 1
            end

            isBossWaitingDelay = true
            task.wait(2.5)
            isBossWaitingDelay = false

            return
        end
    end

    local firstBoss = bossList[1]
    if currentSequenceIndex > 1 and firstBoss then
        local fHead, fHealth = GetBossSpawnData(firstBoss.name)
        if fHead and fHealth and fHealth ~= "0" then
            currentSequenceIndex = 1
            activeTargetBoss = firstBoss.name
            currentWaitingBoss = nil
            
            AttackBossTarget(fHead)
            task.wait(0.025)
            return
        end
    end

    for i = currentSequenceIndex, #bossList do
        local b = bossList[i]
        local head, healthStr = GetBossSpawnData(b.name)
        if head and healthStr and healthStr ~= "0" then
            currentSequenceIndex = i
            activeTargetBoss = b.name
            currentWaitingBoss = nil
            
            AttackBossTarget(head)
            task.wait(0.025)
            return
        end
    end

    local targetWaitBoss = bossList[currentSequenceIndex]
    if targetWaitBoss then
        if IsBossAvailableToWait(targetWaitBoss.name) then
            currentWaitingBoss = targetWaitBoss.name
            SafeTP(targetWaitBoss.pos)
            task.wait(0.5)
            return
        else
            for i = currentSequenceIndex + 1, #bossList do
                if IsBossAvailableToWait(bossList[i].name) then
                    currentSequenceIndex = i
                    currentWaitingBoss = bossList[i].name
                    SafeTP(bossList[i].pos)
                    task.wait(0.5)
                    return
                end
            end
        end
    end

    if #bossList > 0 and bossList[1].pos then
        currentSequenceIndex = 1
        currentWaitingBoss = bossList[1].name
        SafeTP(bossList[1].pos)
        task.wait(0.5)
    end
end

task.spawn(function()
    while true do
        if getgenv().AutoBossTitan then
            ExecuteBossLogic({{name = "Titan", pos = Vector3.new(383, 4, -173)}})
        elseif getgenv().AutoBossMuscle then
            ExecuteBossLogic({{name = "Muscle", pos = Vector3.new(357, 4, 302)}})
        elseif getgenv().AutoBossWhite then
            ExecuteBossLogic({{name = "White", pos = Vector3.new(-245, 49, -19)}})
        elseif getgenv().AutoBossGreen then
            ExecuteBossLogic({{name = "Green", pos = Vector3.new(-542, 151, -272)}})

        elseif getgenv().AutoBossMulti_8_43 then
            ExecuteBossLogic({
                {name = "Titan", pos = Vector3.new(383, 4, -173)},
                {name = "Muscle", pos = Vector3.new(357, 4, 302)}
            })
        elseif getgenv().AutoBossMulti_8_200 then
            ExecuteBossLogic({
                {name = "Titan", pos = Vector3.new(383, 4, -173)},
                {name = "Muscle", pos = Vector3.new(357, 4, 302)},
                {name = "White", pos = Vector3.new(-245, 49, -19)}
            })
        elseif getgenv().AutoBossMulti_8_1K then
            ExecuteBossLogic({
                {name = "Titan", pos = Vector3.new(383, 4, -173)},
                {name = "Muscle", pos = Vector3.new(357, 4, 302)},
                {name = "White", pos = Vector3.new(-245, 49, -19)},
                {name = "Green", pos = Vector3.new(-542, 151, -272)}
            })
        end

        task.wait(0.025)
    end
end)

----------------------------------------------------
-- 📦 TAB BOX
----------------------------------------------------
local BoxTab = Window:CreateTab("📦 Box", 4483362458)

BoxTab:CreateSection("— Box Opener System —")

BoxTab:CreateInput({
   Name = "📦 Target Box Name",
   PlaceholderText = 'Type "BoxNumber" to fire that box (e.g. Box1, Box2)',
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      getgenv().TargetBoxName = Text
   end,
})

BoxTab:CreateToggle({
   Name = "🔄 Auto Open Box",
   CurrentValue = false,
   Flag = "AutoOpenBoxFlag",
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

BoxTab:CreateButton({
   Name = "🔓 Open Box (Once)",
   Callback = function()
      if not getgenv().TargetBoxName or getgenv().TargetBoxName == "" then
         return Rayfield:Notify({
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
         Rayfield:Notify({
            Title = "Box Opener",
            Content = "Fired Open Remote for " .. getgenv().TargetBoxName,
            Duration = 2
         })
      else
         Rayfield:Notify({
            Title = "Error",
            Content = "Could not find remote for: " .. getgenv().TargetBoxName,
            Duration = 3
         })
      end
   end,
})

BoxTab:CreateSection("— Box Price List —")

BoxTab:CreateParagraph({
    Title = "💵 Cash Boxes",
    Content = "• Box1 = Free\n• Box2 = 1K Cash\n• Box3 = 1M Cash\n• Box4 = 1T Cash\n• Box5 = 1Sx Cash"
})

BoxTab:CreateParagraph({
    Title = "✨ Ascension Boxes",
    Content = "• Box6 = 0.1 Asc\n• Box7 = 100 Asc\n• Box8 = 1K Asc\n• Box9 = 10K Asc\n• Box10 = 40K Asc\n• Box11 = 400K Asc"
})

BoxTab:CreateParagraph({
    Title = "💎 Diamond Boxes",
    Content = "• DiamondBox1 = 10 Diamond\n• DiamondBox2 = 100 Diamond\n• DiamondBox3 = 300 Diamond"
})

BoxTab:CreateParagraph({
    Title = "👑 Crown Boxes",
    Content = "• CrownBox1 = 1B Crown\n• CrownBox2 = 1T Crown"
})

----------------------------------------------------
-- 💤 TAB AFK MODE
----------------------------------------------------
local AFKTab = Window:CreateTab("💤 AFK Mode", 4483362458)

local UIFPSLabel = AFKTab:CreateLabel("Current Hub FPS: --")

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

AFKTab:CreateSection("— Graphics & Optimization —")

AFKTab:CreateToggle({
   Name = "📉 Force Graphics to Lowest",
   CurrentValue = false,
   Flag = "LowGraphicsFlag",
   Callback = function(Value)
      getgenv().LowGraphics = Value
      if Value then
         pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
      else
         pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic end)
      end
   end,
})

AFKTab:CreateButton({
   Name = "🗑️ Clear Map Textures",
   Callback = function()
      pcall(function()
         for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("Sky") then
               obj:Destroy()
            elseif obj:IsA("BasePart") then
               obj.Material = Enum.Material.SmoothPlastic
            end
         end
         Rayfield:Notify({Title = "AFK Optimizer", Content = "All textures and decals cleared!", Duration = 3})
      end)
   end,
})

AFKTab:CreateToggle({
   Name = "🌙 Night Time Mode",
   CurrentValue = false,
   Flag = "NightTimeFlag",
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

AFKTab:CreateSection("— FPS Engine Controller —")

AFKTab:CreateToggle({
    Name = "🚀 Enable FPS Limit",
    CurrentValue = false,
    Flag = "EnableFPSLimitFlag",
    Callback = function(Value)
        getgenv().EnableFPSLimit = Value
        if Value then
            if setfpscap then 
                pcall(function() setfpscap(getgenv().TargetFPS) end)
            end
        else
            if setfpscap then 
                pcall(function() setfpscap(60) end)
            end
        end
    end,
})

AFKTab:CreateInput({
    Name = "⌨️ Set FPS Value",
    PlaceholderText = "E.g. 30, 45, 60",
    RemoveTextAfterFocusLost = false,
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

AFKTab:CreateSection("— Black Screen Mode —")

AFKTab:CreateToggle({
   Name = "🖥️ Disable 3D Rendering (Black Screen Fix)",
   CurrentValue = false,
   Flag = "Disable3DFlag",
   Callback = function(Value)
      BlackFrameGui.Enabled = Value
      if Value then
         AFKStartTime = os.time()
         pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
      end
   end,
})

AFKTab:CreateSection("— Auto-AFK (Anti-Disconnect) —")

AFKTab:CreateToggle({
   Name = "🦘 Auto Jump",
   CurrentValue = false,
   Flag = "AutoJumpFlag",
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

AFKTab:CreateInput({
   Name = "⏱️ Delay Auto Jump (Seconds)",
   PlaceholderText = "Default: 5",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local num = tonumber(Text)
      getgenv().AutoJumpDelay = (num and num > 0) and num or 5
   end,
})

----------------------------------------------------
-- 👤 TAB CREDITS
----------------------------------------------------
local CreditTab = Window:CreateTab("👤 Credits", 4483362458) 

CreditTab:CreateSection("— Blacklist Players —")

if #bannedUsersList == 0 then
    CreditTab:CreateParagraph({
        Title = "🚫 Banned List",
        Content = "No one got banned from using TSS Script - NoneUserHub!"
    })
else
    local bannedText = ""
    for _, id in ipairs(bannedUsersList) do
        local username = "Unknown"
        pcall(function()
            username = Players:GetNameFromUserIdAsync(tonumber(id))
        end)
        bannedText = bannedText .. string.format("%s (@%s) got Banned\n", tostring(id), username)
    end
    CreditTab:CreateParagraph({
        Title = "🔨 Banned List",
        Content = bannedText
    })
end

CreditTab:CreateSection("— Owner Info —")

CreditTab:CreateParagraph({
    Title = "👤 Creator Information", 
    Content = "Owner & Creator: NoneUsername0813\nStatus: " .. IsOwnerInServer
})
CreditTab:CreateParagraph({
    Title = "💬 Message", 
    Content = "Thank for using my script! If you see any issue in this script, comment it on Scriptblox web. Love you all!"
})

----------------------------------------------------
-- 📢 TAB UPDATE
----------------------------------------------------
local UpdateTab = Window:CreateTab("📢 Update", 4483362458)

UpdateTab:CreateSection("— Latest Changelog —")

UpdateTab:CreateParagraph({
    Title = "📩 What's new in v1.6.5?",
    Content = "• In Version 1.6.5\nWe added\n- Tab: Glitches\n- \"Sol RNG Simulator\" at tab Glitches"
})

UpdateTab:CreateParagraph({
    Title = "📩 What's new in v1.6.4.5?",
    Content = "• In Version 1.6.4.5\nWe added\n- Auto Join Battle\n\nNote: We are developing Auto Kill Players in Battle and Auto Farm Mods so just be patient and wait."
})

UpdateTab:CreateParagraph({
    Title = "📩 What's new in v1.6.4.25?",
    Content = "• In Version 1.6.4.25\nWe fixed\n- Auto Boss bug lost Combat tool"
})

----------------------------------------------------
-- 💬 TAB COMMENT
----------------------------------------------------
local CommentTab = Window:CreateTab("💬 Comment", 4483362458)

CommentTab:CreateSection("— Send Your Feedback —")

CommentTab:CreateParagraph({
    Title = "📩 Give us a review or suggestion to our script!",
    Content = "Type your review, bug report, or new feature request below and click 'Send Comment'. It will be sent directly to our inbox."
})

local userCommentText = ""
local lastCommentTime = 0
local COMMENT_COOLDOWN = 120

local MESSAGE_LOGGER_WEBHOOK = "-"

CommentTab:CreateInput({
    Name = "💬 Message",
    PlaceholderText = "Enter your review or suggestion here...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        userCommentText = Text
    end,
})

CommentTab:CreateButton({
    Name = "🚀 Send Comment",
    Callback = function()
        if userCommentText == "" or #userCommentText < 5 then
            return Rayfield:Notify({
                Title = "Comment Failed",
                Content = "Please write a meaningful message (at least 5 characters).",
                Duration = 3
            })
        end

        local currentTime = os.time()
        if currentTime - lastCommentTime < COMMENT_COOLDOWN then
            local timeLeft = COMMENT_COOLDOWN - (currentTime - lastCommentTime)
            return Rayfield:Notify({
                Title = "Please Wait.",
                Content = string.format("You are sending messages too fast! Wait %d seconds.", timeLeft),
                Duration = 4
            })
        end

        local embedData = {
            ["username"] = "Message Logger",
            ["embeds"] = {{
                ["title"] = "💬 New Player Comment / Feedback!",
                ["description"] = "A player left a review/suggestion for **TSS Script**:",
                ["color"] = 3447003,
                ["fields"] = {
                    {
                        ["name"] = "📝 Message",
                        ["value"] = "```\n" .. userCommentText .. "\n```",
                        ["inline"] = false
                    },
                    {
                        ["name"] = "👤 Player",
                        ["value"] = "**" .. LocalPlayer.Name .. "** (" .. tostring(LocalPlayer.UserId) .. ")",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "🎮 Game Place ID",
                        ["value"] = "**" .. tostring(game.PlaceId) .. "**",
                        ["inline"] = true
                    }
                },
                ["footer"] = {
                    ["text"] = "Message Logger • NoneUserHub"
                },
                ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }}
        }

        local headers = {["content-type"] = "application/json"}
        local json_data = HttpService:JSONEncode(embedData)
        local requestFunc = syn and syn.request or http_request or fluxus and fluxus.request or request

        if requestFunc then
            local response = requestFunc({
                Url = MESSAGE_LOGGER_WEBHOOK,
                Method = "POST",
                Headers = headers,
                Body = json_data
            })

            lastCommentTime = os.time()

            Rayfield:Notify({
                Title = "Success.",
                Content = "You've send your message review to our inbox.",
                Duration = 4
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Your executor does not support HTTP Request!",
                Duration = 4
            })
        end
    end,
})

----------------------------------------------------
-- ⚙️ TAB SETTINGS
----------------------------------------------------
local SettingsTab = Window:CreateTab("⚙️ Settings", 4483362458)
SettingsTab:CreateSection("🎨 Theme Customization")
local ThemeStatusLabel = SettingsTab:CreateLabel("Current Theme: [" .. currentTheme .. "]")

SettingsTab:CreateDropdown({
    Name = "Select Preset Theme",
    Options = {"Default", "AmberGlow", "Ocean", "Green", "Serenity", "Light"}, 
    CurrentOption = {savedTheme},
    MultipleOptions = false,
    Callback = function(Option)
        currentTheme = Option[1]
        ThemeStatusLabel:Set("Current Theme: [" .. currentTheme .. "]")
        if Rayfield.ModifyTheme then
            Rayfield:ModifyTheme(currentTheme)
        else
            Rayfield:Notify({Title = "Notice", Content = "Please save the theme and rejoin to apply!", Duration = 3})
        end
    end,
})

SettingsTab:CreateButton({
    Name = "💾 Save Default Theme",
    Callback = function()
        local data = {ThemeName = currentTheme}
        writefile(THEME_FILE, HttpService:JSONEncode(data))
        Rayfield:Notify({Title = "Success!", Content = "Theme configuration saved successfully!", Duration = 3})
    end,
})

SettingsTab:CreateSection("⚙️ Configuration Management")
local ConfigStatusLabel = SettingsTab:CreateLabel("Active Config: [" .. activeConfigName .. "]")

local function GetSavedConfigs()
    local configList = {}
    if listfiles then
        local files = listfiles("")
        for _, file in ipairs(files) do
            local name = string.match(file, "NoneUserHub_Config_(.-)%.json$")
            if name then
                table.insert(configList, name)
                if #configList >= 10 then break end
            end
        end
    end
    if #configList == 0 then table.insert(configList, "None") end
    return configList
end

local ConfigDropdown = SettingsTab:CreateDropdown({
    Name = "Select Saved Config (Max 10)",
    Options = GetSavedConfigs(),
    CurrentOption = {GetSavedConfigs()[1] or "None"},
    MultipleOptions = false,
    Callback = function(Option)
        if Option[1] and Option[1] ~= "None" then
            targetConfigName = Option[1]
        end
    end,
})

SettingsTab:CreateInput({
    Name = "New Configuration Name",
    PlaceholderText = "Enter config name here...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) targetConfigName = Text end,
})

SettingsTab:CreateButton({
    Name = "➕ Create / Overwrite Config",
    Callback = function()
        if targetConfigName == "" or targetConfigName == "None" then
            return Rayfield:Notify({Title = "Error", Content = "Please enter a valid configuration name!", Duration = 3})
        end

        local savedConfigs = GetSavedConfigs()
        local isExisting = false
        for _, name in ipairs(savedConfigs) do
            if name == targetConfigName then isExisting = true break end
        end

        if not isExisting and #savedConfigs >= 10 and savedConfigs[1] ~= "None" then
            return Rayfield:Notify({Title = "Limit Reached", Content = "Maximum 10 configs allowed! Please delete one first.", Duration = 4})
        end

        local configData = {}
        for flagName, flagState in pairs(Rayfield.Flags) do
            configData[flagName] = flagState.CurrentValue
        end
        local success, _ = pcall(function()
            writefile("NoneUserHub_Config_" .. targetConfigName .. ".json", HttpService:JSONEncode(configData))
        end)
        if success then
            activeConfigName = targetConfigName
            ConfigStatusLabel:Set("Active Config: [" .. activeConfigName .. "]")
            ConfigDropdown:Set(GetSavedConfigs())
            Rayfield:Notify({Title = "Saved!", Content = "Config file [" .. activeConfigName .. "] has been updated.", Duration = 3})
        else
            Rayfield:Notify({Title = "Error", Content = "Failed to save config file!", Duration = 3})
        end
    end,
})

SettingsTab:CreateButton({
    Name = "📂 Load Selected Config",
    Callback = function()
        if targetConfigName == "" or targetConfigName == "None" then 
            return Rayfield:Notify({Title = "Error", Content = "Please select a config from Dropdown first!", Duration = 3})
        end
        local fileName = "NoneUserHub_Config_" .. targetConfigName .. ".json"
        if not isfile(fileName) then
            return Rayfield:Notify({Title = "Error", Content = "Config file not found!", Duration = 3})
        end
        local success, content = pcall(function() return readfile(fileName) end)
        if success then
            local successDecode, configData = pcall(function() return HttpService:JSONDecode(content) end)
            if successDecode and type(configData) == "table" then
                for flagName, savedValue in pairs(configData) do
                    if Rayfield.Flags[flagName] and Rayfield.Flags[flagName].Set then
                        Rayfield.Flags[flagName]:Set(savedValue)
                    end
                end
                activeConfigName = targetConfigName
                ConfigStatusLabel:Set("Active Config: [" .. activeConfigName .. "]")
                Rayfield:Notify({Title = "Loaded!", Content = "Successfully loaded settings!", Duration = 3})
            else
                Rayfield:Notify({Title = "Error", Content = "Failed to parse config file!", Duration = 3})
            end
        else
            Rayfield:Notify({Title = "Error", Content = "Failed to read file!", Duration = 3})
        end
    end,
})

SettingsTab:CreateButton({
    Name = "🔄📂 Auto Load Selected Config",
    Callback = function()
        if targetConfigName == "" or targetConfigName == "None" then 
            return Rayfield:Notify({Title = "Error", Content = "Please select a config to set as Auto-Load!", Duration = 3})
        end

        local fileName = "NoneUserHub_Config_" .. targetConfigName .. ".json"
        if not isfile(fileName) then
            return Rayfield:Notify({Title = "Error", Content = "Config file does not exist!", Duration = 3})
        end

        local autoLoadData = {AutoLoadConfig = targetConfigName}
        local success, _ = pcall(function()
            writefile("NoneUserHub_AutoLoad.json", HttpService:JSONEncode(autoLoadData))
        end)

        if success then
            Rayfield:Notify({
                Title = "Auto Load Set!", 
                Content = "Config [" .. targetConfigName .. "] will auto-load on next execution!", 
                Duration = 4
            })
        else
            Rayfield:Notify({Title = "Error", Content = "Failed to save Auto Load preference!", Duration = 3})
        end
    end,
})

SettingsTab:CreateButton({
    Name = "❌ Delete Config From Device",
    Callback = function()
        if targetConfigName == "" or targetConfigName == "None" then return end
        local fileName = "NoneUserHub_Config_" .. targetConfigName .. ".json"
        if isfile(fileName) then
            delfile(fileName)
            targetConfigName = ""
            ConfigDropdown:Set(GetSavedConfigs())
            Rayfield:Notify({Title = "System", Content = "Config file removed successfully.", Duration = 3})
        else
            Rayfield:Notify({Title = "Error", Content = "File does not exist!", Duration = 3})
        end
    end,
})

task.spawn(function()
    pcall(function()
        local HttpService = game:GetService("HttpService")
        local MarketplaceService = game:GetService("MarketplaceService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
        
        local actualWebhook = "-"
        
        if game.GameId == 0 then
            repeat task.wait() until game.GameId ~= 0
        end
        
        local rawGameName = ""
        
        local apiSuccess, info = pcall(function()
            return MarketplaceService:GetProductInfo(game.GameId, Enum.InfoType.GamePass)
        end)
        
        if apiSuccess and info and info.Name then
            rawGameName = info.Name
        else
            rawGameName = (workspace.Name ~= "Workspace") and workspace.Name or game.Name
        end
        
        local checkName = string.lower(rawGameName)
        if string.find(checkName, "ugc") or game.PlaceId == 16422247192 or game.GameId == 5621453415 then 
            rawGameName = "[Code: Badges] Trade Strength"
        end
        
        if rawGameName == "Workspace" or rawGameName == "" then rawGameName = "Unknown Game" end
        
        local textGameName = "🌳 " .. rawGameName .. " (" .. tostring(game.PlaceId) .. ")"
        local textTime = "📅 " .. os.date("%X – %d/%m/%Y")
        
        local data = {
            ["embeds"] = {{
                ["title"] = "🚀 Script Executed!",
                ["description"] = "A player has just executed a script:\n**TSS Script - NoneUserHub (World 1).**",
                ["color"] = 16776960, 
                ["fields"] = {
                    {
                        ["name"] = "👤 Username",
                        ["value"] = "**" .. LocalPlayer.Name .. "**",
                        ["inline"] = false
                    },
                    {
                        ["name"] = "🆔 UserID",
                        ["value"] = "**" .. tostring(LocalPlayer.UserId) .. "**",
                        ["inline"] = false
                    },
                    {
                        ["name"] = "🎮 Name Game (Place ID)",
                        ["value"] = textGameName,
                        ["inline"] = false
                    },
                    {
                        ["name"] = "📆 Time (System)",
                        ["value"] = textTime,
                        ["inline"] = false
                    }
                },
                ["footer"] = {
                    ["text"] = "NoneUserHub Logger System"
                }
            }}
        }

        local headers = {["content-type"] = "application/json"}
        local json_data = HttpService:JSONEncode(data)
        
        local requestFunc = syn and syn.request or http_request or fluxus and fluxus.request or request
        if requestFunc then
            requestFunc({Url = actualWebhook, Method = "POST", Headers = headers, Body = json_data})
        end
    end)
end)

Rayfield:Notify({
   Title = "Update Complete!",
   Content = "Version v1.6.5",
   Duration = 5,
   Image = 4483362458,
})

task.spawn(function()
    task.wait(1)
    local AUTOLOAD_FILE = "NoneUserHub_AutoLoad.json"
    if isfile(AUTOLOAD_FILE) then
        local success, content = pcall(function() return readfile(AUTOLOAD_FILE) end)
        if success then
            local successDecode, autoData = pcall(function() return HttpService:JSONDecode(content) end)
            if successDecode and autoData and autoData.AutoLoadConfig then
                local autoConfigName = autoData.AutoLoadConfig
                local configFile = "NoneUserHub_Config_" .. autoConfigName .. ".json"
                
                if isfile(configFile) then
                    local readSuccess, configContent = pcall(function() return readfile(configFile) end)
                    if readSuccess then
                        local parseSuccess, configData = pcall(function() return HttpService:JSONDecode(configContent) end)
                        if parseSuccess and type(configData) == "table" then
                            for flagName, savedValue in pairs(configData) do
                                if Rayfield.Flags[flagName] and Rayfield.Flags[flagName].Set then
                                    Rayfield.Flags[flagName]:Set(savedValue)
                                end
                            end
                            activeConfigName = autoConfigName
                            ConfigStatusLabel:Set("Active Config: [" .. activeConfigName .. "]")
                            Rayfield:Notify({
                                Title = "Auto Loaded!", 
                                Content = "Applied configuration: [" .. autoConfigName .. "]", 
                                Duration = 4
                            })
                        end
                    end
                end
            end
        end
    end
end)
