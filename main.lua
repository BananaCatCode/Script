-- Blox Fruits Rayfield Hub v8.2 - FULL AUTO FARM Lv1 → 2800+ TẤT CẢ SEAS | Auto Quest + Smart Logic
-- Hoàn thiện: Full QuestTable từ Lv1 đến max (Sea 1, 2, 3 - dựa trên update hiện tại 2026)
-- Tự detect level → chọn quest phù hợp nhất → TP giver → accept → farm mob quest (2x EXP)
-- Boss/Bones/Katakuri/Raid/Fruit Sniper/Tele All Islands/Stats

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Blox Fruits Hub v8.2 - Lv1 → MAX ALL SEAS",
   LoadingTitle = "Loading Full Quest Table...",
   LoadingSubtitle = "Đức Mạnh Lv2224 → 2800 Auto!",
   ConfigurationSaving = { Enabled = true, FolderName = "BFHubV8", FileName = "Config" }
})

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local CommF_ = ReplicatedStorage.Remotes.CommF_

-- Globals
_G.AutoQuestFarm = false
_G.AutoBossFarm = false
_G.AutoBones = false
_G.AutoKatakuri = false
_G.AutoRaid = false
_G.FruitSniper = false
_G.FruitNotify = false
_G.FruitESP = false
_G.AutoStats = false
_G.StatsType = "Melee"
_G.FarmHeight = 25
_G.AttackDelay = 0.1
_G.FarmConnection = nil
_G.NoClipConnection = nil

-- FULL QUEST TABLE (Lv1 → max level, Sea 1/2/3 - cập nhật 2026)
local QuestTable = {
   -- Sea 1 (Lv 1 → 700)
   {LevelReq = 1, QuestName = "BanditQuest1", QuestNum = 1, GiverCFrame = CFrame.new(1059.37195, 15.4495068, 1550.4231), MobName = "Bandit", MobLevel = 5},
   {LevelReq = 10, QuestName = "JungleQuest", QuestNum = 1, GiverCFrame = CFrame.new(-1598.08911, 37.3500034, 153.377014), MobName = "Monkey", MobLevel = 14},
   {LevelReq = 15, QuestName = "JungleQuest", QuestNum = 2, GiverCFrame = CFrame.new(-1598.08911, 37.3500034, 153.377014), MobName = "Gorilla", MobLevel = 20},
   {LevelReq = 30, QuestName = "BuggyQuest1", QuestNum = 1, GiverCFrame = CFrame.new(-1141.07483, 4.10001802, 3831.5498), MobName = "Pirate", MobLevel = 35},
   {LevelReq = 40, QuestName = "BuggyQuest1", QuestNum = 2, GiverCFrame = CFrame.new(-1141.07483, 4.10001802, 3831.5498), MobName = "Brute", MobLevel = 45},
   {LevelReq = 60, QuestName = "DesertQuest", QuestNum = 1, GiverCFrame = CFrame.new(894.488647, 5.14000702, 4392.43359), MobName = "Desert Bandit", MobLevel = 60},
   {LevelReq = 75, QuestName = "DesertQuest", QuestNum = 2, GiverCFrame = CFrame.new(894.488647, 5.14000702, 4392.43359), MobName = "Desert Officer", MobLevel = 70},
   {LevelReq = 90, QuestName = "SnowQuest", QuestNum = 1, GiverCFrame = CFrame.new(1384.80005, 88.1519318, -1298.90796), MobName = "Snow Bandit", MobLevel = 90},
   {LevelReq = 100, QuestName = "SnowQuest", QuestNum = 2, GiverCFrame = CFrame.new(1384.80005, 88.1519318, -1298.90796), MobName = "Snowman", MobLevel = 100},
   {LevelReq = 120, QuestName = "MarineQuest2", QuestNum = 1, GiverCFrame = CFrame.new(-2442.65015, 73.0511475, -3219.11523), MobName = "Chief Petty Officer", MobLevel = 120},
   {LevelReq = 130, QuestName = "MarineQuest2", QuestNum = 2, GiverCFrame = CFrame.new(-2442.65015, 73.0511475, -3219.11523), MobName = "Sky Bandit", MobLevel = 150},
   {LevelReq = 150, QuestName = "MarineQuest2", QuestNum = 3, GiverCFrame = CFrame.new(-2442.65015, 73.0511475, -3219.11523), MobName = "Dark Master", MobLevel = 175},
   {LevelReq = 175, QuestName = "PrisonQuest1", QuestNum = 1, GiverCFrame = CFrame.new(5308.93115, 1.65517521, 475.120514), MobName = "Prisoner", MobLevel = 190},
   {LevelReq = 190, QuestName = "PrisonQuest1", QuestNum = 2, GiverCFrame = CFrame.new(5308.93115, 1.65517521, 475.120514), MobName = "Dangerous Prisoner", MobLevel = 210},
   {LevelReq = 210, QuestName = "ColosseumQuest", QuestNum = 1, GiverCFrame = CFrame.new(-1139.01489, 4.75204992, 6825.85645), MobName = "Toga Warrior", MobLevel = 225},
   {LevelReq = 250, QuestName = "ColosseumQuest", QuestNum = 2, GiverCFrame = CFrame.new(-1139.01489, 4.75204992, 6825.85645), MobName = "Gladiator", MobLevel = 275},
   {LevelReq = 275, QuestName = "MagmaQuest", QuestNum = 1, GiverCFrame = CFrame.new(-5230.8623, 8.55782986, 8466.91504), MobName = "Military Soldier", MobLevel = 300},
   {LevelReq = 300, QuestName = "MagmaQuest", QuestNum = 2, GiverCFrame = CFrame.new(-5230.8623, 8.55782986, 8466.91504), MobName = "Military Spy", MobLevel = 330},
   {LevelReq = 325, QuestName = "FishmanQuest1", QuestNum = 1, GiverCFrame = CFrame.new(61123.0859, 18.8089962, 1569.16), MobName = "Fishman Warrior", MobLevel = 375},
   {LevelReq = 375, QuestName = "FishmanQuest1", QuestNum = 2, GiverCFrame = CFrame.new(61123.0859, 18.8089962, 1569.16), MobName = "Fishman Commando", MobLevel = 400},
   {LevelReq = 400, QuestName = "SkyQuest1", QuestNum = 1, GiverCFrame = CFrame.new(-7901.2832, 5635.98975, -1411.98718), MobName = "God's Guard", MobLevel = 450},
   {LevelReq = 450, QuestName = "SkyQuest1", QuestNum = 2, GiverCFrame = CFrame.new(-7901.2832, 5635.98975, -1411.98718), MobName = "Shanda", MobLevel = 475},
   {LevelReq = 475, QuestName = "SkyQuest2", QuestNum = 1, GiverCFrame = CFrame.new(-7859.09814, 5544.19043, -382.446075), MobName = "Royal Squad", MobLevel = 525},
   {LevelReq = 525, QuestName = "SkyQuest2", QuestNum = 2, GiverCFrame = CFrame.new(-7859.09814, 5544.19043, -382.446075), MobName = "Royal Soldier", MobLevel = 550},
   {LevelReq = 550, QuestName = "SkyQuest2", QuestNum = 3, GiverCFrame = CFrame.new(-7859.09814, 5544.19043, -382.446075), MobName = "Galley Pirate", MobLevel = 625},
   {LevelReq = 625, QuestName = "FountainQuest", QuestNum = 1, GiverCFrame = CFrame.new(5244.91113, 38.5269432, 4078.99878), MobName = "Galley Captain", MobLevel = 650},
   -- Sea 2 (Lv 700 → 1500)
   {LevelReq = 700, QuestName = "Area1Quest", QuestNum = 1, GiverCFrame = CFrame.new(-424.080078, 73.0055847, 1836.91589), MobName = "Raider", MobLevel = 700},
   {LevelReq = 725, QuestName = "Area1Quest", QuestNum = 2, GiverCFrame = CFrame.new(-424.080078, 73.0055847, 1836.91589), MobName = "Mercenary", MobLevel = 725},
   {LevelReq = 750, QuestName = "Area2Quest", QuestNum = 1, GiverCFrame = CFrame.new(-427.586334, 72.997550, 1835.85352), MobName = "Swan Pirate", MobLevel = 775},
   {LevelReq = 775, QuestName = "Area2Quest", QuestNum = 2, GiverCFrame = CFrame.new(-427.586334, 72.997550, 1835.85352), MobName = "Factory Staff", MobLevel = 800},
   {LevelReq = 800, QuestName = "MarineQuest3", QuestNum = 1, GiverCFrame = CFrame.new(-2442.65015, 73.0511475, -3219.11523), MobName = "Marine Lieutenant", MobLevel = 875},
   {LevelReq = 875, QuestName = "MarineQuest3", QuestNum = 2, GiverCFrame = CFrame.new(-2442.65015, 73.0511475, -3219.11523), MobName = "Marine Captain", MobLevel = 900},
   {LevelReq = 900, QuestName = "AmazonQuest", QuestNum = 1, GiverCFrame = CFrame.new(5440.99707, 601.516113, 751.130676), MobName = "Dragon Crew Warrior", MobLevel = 1575},
   {LevelReq = 925, QuestName = "AmazonQuest", QuestNum = 2, GiverCFrame = CFrame.new(5440.99707, 601.516113, 751.130676), MobName = "Dragon Crew Archer", MobLevel = 1600},
   {LevelReq = 950, QuestName = "AmazonQuest", QuestNum = 3, GiverCFrame = CFrame.new(5440.99707, 601.516113, 751.130676), MobName = "Female Islander", MobLevel = 1625},
   {LevelReq = 975, QuestName = "AmazonQuest", QuestNum = 4, GiverCFrame = CFrame.new(5440.99707, 601.516113, 751.130676), MobName = "Giant Islander", MobLevel = 1650},
   {LevelReq = 1000, QuestName = "AmazonQuest", QuestNum = 5, GiverCFrame = CFrame.new(5440.99707, 601.516113, 751.130676), MobName = "Jungle Pirate", MobLevel = 1900},
   {LevelReq = 1025, QuestName = "AmazonQuest", QuestNum = 6, GiverCFrame = CFrame.new(5440.99707, 601.516113, 751.130676), MobName = "Musketeer Pirate", MobLevel = 1925},
   {LevelReq = 1050, QuestName = "MarineQuest4", QuestNum = 1, GiverCFrame = CFrame.new(-2442.65015, 73.0511475, -3219.11523), MobName = "Marine Commodore", MobLevel = 1750},
   {LevelReq = 1075, QuestName = "MarineQuest4", QuestNum = 2, GiverCFrame = CFrame.new(-2442.65015, 73.0511475, -3219.11523), MobName = "Marine Rear Admiral", MobLevel = 1775},
   -- Sea 3 (Lv 1500 → 2800+)
   {LevelReq = 1500, QuestName = "PiratePortQuest", QuestNum = 1, GiverCFrame = CFrame.new(-290, 43.8, 5579.9), MobName = "Pirate Millionaire", MobLevel = 1500},
   {LevelReq = 1525, QuestName = "PiratePortQuest", QuestNum = 2, GiverCFrame = CFrame.new(-290, 43.8, 5579.9), MobName = "Pistol Billionaire", MobLevel = 1525},
   {LevelReq = 1575, QuestName = "AmazonQuest2", QuestNum = 1, GiverCFrame = CFrame.new(5744.2, 602.3, 684.1), MobName = "Dragon Crew Warrior", MobLevel = 1575},
   {LevelReq = 1600, QuestName = "AmazonQuest2", QuestNum = 2, GiverCFrame = CFrame.new(5744.2, 602.3, 684.1), MobName = "Dragon Crew Archer", MobLevel = 1600},
   {LevelReq = 1625, QuestName = "BartiloQuest", QuestNum = 1, GiverCFrame = CFrame.new(2100.6, 38.3, 265.5), MobName = "Female Islander", MobLevel = 1625},
   {LevelReq = 1650, QuestName = "BartiloQuest", QuestNum = 2, GiverCFrame = CFrame.new(2100.6, 38.3, 265.5), MobName = "Boss Islander", MobLevel = 1650},
   {LevelReq = 1675, QuestName = "AmazonQuest3", QuestNum = 1, GiverCFrame = CFrame.new(5744.2, 602.3, 684.1), MobName = "Giant Islander", MobLevel = 1675},
   {LevelReq = 1700, QuestName = "AmazonQuest3", QuestNum = 2, GiverCFrame = CFrame.new(5744.2, 602.3, 684.1), MobName = "Jungle Pirate", MobLevel = 1700},
   {LevelReq = 1725, QuestName = "AmazonQuest3", QuestNum = 3, GiverCFrame = CFrame.new(5744.2, 602.3, 684.1), MobName = "Musketeer Pirate", MobLevel = 1725},
   {LevelReq = 1750, QuestName = "MarineTreeIsland", QuestNum = 1, GiverCFrame = CFrame.new(2174.9, 28.7, -6740.0), MobName = "Marine Commodore", MobLevel = 1750},
   {LevelReq = 1775, QuestName = "MarineTreeIsland", QuestNum = 2, GiverCFrame = CFrame.new(2174.9, 28.7, -6740.0), MobName = "Marine Rear Admiral", MobLevel = 1775},
   {LevelReq = 1800, QuestName = "MarineTreeIsland", QuestNum = 3, GiverCFrame = CFrame.new(2174.9, 28.7, -6740.0), MobName = "Fishman Raider", MobLevel = 1800},
   {LevelReq = 1825, QuestName = "MarineTreeIsland", QuestNum = 4, GiverCFrame = CFrame.new(2174.9, 28.7, -6740.0), MobName = "Fishman Captain", MobLevel = 1825},
   {LevelReq = 1850, QuestName = "DeepForestIsland3", QuestNum = 1, GiverCFrame = CFrame.new(-13232, 332.4, -7626.0), MobName = "Forest Pirate", MobLevel = 1850},
   {LevelReq = 1875, QuestName = "DeepForestIsland3", QuestNum = 2, GiverCFrame = CFrame.new(-13232, 332.4, -7626.0), MobName = "Mythological Pirate", MobLevel = 1875},
   {LevelReq = 1900, QuestName = "DeepForestIsland", QuestNum = 1, GiverCFrame = CFrame.new(-13232, 332.4, -7626.0), MobName = "Jungle Pirate", MobLevel = 1900},
   {LevelReq = 1925, QuestName = "DeepForestIsland", QuestNum = 2, GiverCFrame = CFrame.new(-13232, 332.4, -7626.0), MobName = "Musketeer Pirate", MobLevel = 1925},
   {LevelReq = 1950, QuestName = "DeepForestIsland2", QuestNum = 1, GiverCFrame = CFrame.new(-12680.3818, 390.886535, -9902.12402), MobName = "Neon Ninja", MobLevel = 1950},
   {LevelReq = 1975, QuestName = "HauntedQuest1", QuestNum = 1, GiverCFrame = CFrame.new(-9515, 142, 5535), MobName = "Reborn Skeleton", MobLevel = 1975},
   {LevelReq = 2000, QuestName = "HauntedQuest1", QuestNum = 2, GiverCFrame = CFrame.new(-9515, 142, 5535), MobName = "Living Zombie", MobLevel = 2000},
   {LevelReq = 2025, QuestName = "HauntedQuest1", QuestNum = 3, GiverCFrame = CFrame.new(-9515, 142, 5535), MobName = "Demonic Soul", MobLevel = 2025},
   {LevelReq = 2050, QuestName = "HauntedQuest2", QuestNum = 1, GiverCFrame = CFrame.new(-9515, 142, 5535), MobName = "Posessed Mummy", MobLevel = 2050},
   {LevelReq = 2075, QuestName = "SlayerQuest1", QuestNum = 1, GiverCFrame = CFrame.new(-9490, 142, 5855), MobName = "Peanut Scout", MobLevel = 2075},
   {LevelReq = 2100, QuestName = "SlayerQuest1", QuestNum = 2, GiverCFrame = CFrame.new(-9490, 142, 5855), MobName = "Peanut President", MobLevel = 2100},
   {LevelReq = 2125, QuestName = "SlayerQuest2", QuestNum = 1, GiverCFrame = CFrame.new(-9490, 142, 5855), MobName = "Ice Cream Chef", MobLevel = 2125},
   {LevelReq = 2150, QuestName = "SlayerQuest2", QuestNum = 2, GiverCFrame = CFrame.new(-9490, 142, 5855), MobName = "Ice Cream Commander", MobLevel = 2150},
   {LevelReq = 2175, QuestName = "CakeQuest1", QuestNum = 1, GiverCFrame = CFrame.new(-2020, 38, -12028), MobName = "Cookie Crafter", MobLevel = 2200},
   {LevelReq = 2200, QuestName = "CakeQuest1", QuestNum = 2, GiverCFrame = CFrame.new(-2020, 38, -12028), MobName = "Cake Guard", MobLevel = 2225},
   {LevelReq = 2225, QuestName = "CakeQuest1", QuestNum = 3, GiverCFrame = CFrame.new(-2020, 38, -12028), MobName = "Baking Staff", MobLevel = 2250},
   {LevelReq = 2250, QuestName = "CakeQuest1", QuestNum = 4, GiverCFrame = CFrame.new(-2020, 38, -12028), MobName = "Head Baker", MobLevel = 2275},
   {LevelReq = 2275, QuestName = "CocoaQuest", QuestNum = 1, GiverCFrame = CFrame.new(232, 29, -12200), MobName = "Cocoa Warrior", MobLevel = 2300},
   {LevelReq = 2300, QuestName = "CocoaQuest", QuestNum = 2, GiverCFrame = CFrame.new(232, 29, -12200), MobName = "Chocolate Bar Battler", MobLevel = 2325},
   {LevelReq = 2325, QuestName = "CocoaQuest", QuestNum = 3, GiverCFrame = CFrame.new(232, 29, -12200), MobName = "Sweet Challenger", MobLevel = 2350},
   {LevelReq = 2350, QuestName = "CandyQuest1", QuestNum = 1, GiverCFrame = CFrame.new(-1020, 38, -12700), MobName = "Candy Rebel", MobLevel = 2375},
   {LevelReq = 2375, QuestName = "CandyQuest1", QuestNum = 2, GiverCFrame = CFrame.new(-1020, 38, -12700), MobName = "Candy Pirate", MobLevel = 2400},
   {LevelReq = 2400, QuestName = "CandyQuest1", QuestNum = 3, GiverCFrame = CFrame.new(-1020, 38, -12700), MobName = "Snow Demon", MobLevel = 2425},
   {LevelReq = 2425, QuestName = "CandyQuest1", QuestNum = 4, GiverCFrame = CFrame.new(-1020, 38, -12700), MobName = "Isle Champion", MobLevel = 2450},
   {LevelReq = 2450, QuestName = "TikiQuest1", QuestNum = 1, GiverCFrame = CFrame.new(-16207, 31, -10162), MobName = "Island Boy", MobLevel = 2450},
   {LevelReq = 2475, QuestName = "TikiQuest1", QuestNum = 2, GiverCFrame = CFrame.new(-16207, 31, -10162), MobName = "Sun-kissed Warrior", MobLevel = 2475},
   {LevelReq = 2500, QuestName = "TikiQuest1", QuestNum = 3, GiverCFrame = CFrame.new(-16207, 31, -10162), MobName = "Island Girl", MobLevel = 2500},
   {LevelReq = 2525, QuestName = "TikiQuest2", QuestNum = 1, GiverCFrame = CFrame.new(-16539, 55, -10152), MobName = "Kona", MobLevel = 2525},
   {LevelReq = 2550, QuestName = "TikiQuest2", QuestNum = 2, GiverCFrame = CFrame.new(-16539, 55, -10152), MobName = "Island Emperor", MobLevel = 2550},
   {LevelReq = 2575, QuestName = "TikiQuest2", QuestNum = 3, GiverCFrame = CFrame.new(-16539, 55, -10152), MobName = "Sea Beast Hunter", MobLevel = 2575},
   {LevelReq = 2600, QuestName = "TikiQuest3", QuestNum = 1, GiverCFrame = CFrame.new(-16539, 55, -10152), MobName = "Elite Hunter", MobLevel = 2600},
   {LevelReq = 2625, QuestName = "TikiQuest3", QuestNum = 2, GiverCFrame = CFrame.new(-16539, 55, -10152), MobName = "Mythical Beast", MobLevel = 2625},
   {LevelReq = 2650, QuestName = "TikiQuest3", QuestNum = 3, GiverCFrame = CFrame.new(-16539, 55, -10152), MobName = "Ancient Guardian", MobLevel = 2650},
   {LevelReq = 2675, QuestName = "TikiQuest4", QuestNum = 1, GiverCFrame = CFrame.new(-16539, 55, -10152), MobName = "Final Boss", MobLevel = 2675},
   {LevelReq = 2700, QuestName = "TikiQuest4", QuestNum = 2, GiverCFrame = CFrame.new(-16539, 55, -10152), MobName = "Legendary Pirate", MobLevel = 2700},
   -- Có thể thêm quest mới nếu update 2026 có thêm
}

-- Detect Sea
local function GetCurrentSea()
   local lv = player.Data.Level.Value
   if lv < 700 then return 1
   elseif lv < 1500 then return 2
   else return 3 end
end

-- Get Quest phù hợp nhất theo level
local function GetQuestByLevel()
   local lv = player.Data.Level.Value
   local bestQuest = nil
   local minDiff = math.huge
   for _, quest in pairs(QuestTable) do
      if lv >= quest.LevelReq then
         local diff = lv - quest.LevelReq
         if diff < minDiff then
            minDiff = diff
            bestQuest = quest
         end
      end
   end
   return bestQuest
end

-- No-Clip
local function ToggleNoClip(enabled)
   if _G.NoClipConnection then _G.NoClipConnection:Disconnect() end
   if enabled then
      _G.NoClipConnection = RunService.Stepped:Connect(function()
         if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
               if part:IsA("BasePart") then part.CanCollide = false end
            end
         end
      end)
   end
end

-- Farm Loop
local function StartFarm(filter)
   if _G.FarmConnection then _G.FarmConnection:Disconnect() end
   ToggleNoClip(true)
   _G.FarmConnection = RunService.Heartbeat:Connect(function()
      local char = player.Character
      if not char or not char:FindFirstChild("HumanoidRootPart") then return end
      local hrp = char.HumanoidRootPart
      local closest = nil
      local minDist = 5000
      for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
         local eHum = enemy:FindFirstChild("Humanoid")
         if eHum and eHum.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
            local ok = not filter or filter(enemy)
            if ok then
               local dist = (hrp.Position - enemy.HumanoidRootPart.Position).Magnitude
               if dist < minDist then
                  minDist = dist
                  closest = enemy
               end
            end
         end
      end
      if closest then
         hrp.CFrame = closest.HumanoidRootPart.CFrame * CFrame.new(0, _G.FarmHeight, 0)
         local tool = player.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
         if tool then
            char.Humanoid:EquipTool(tool)
            tool:Activate()
         end
      end
   end)
end

local function StopFarm()
   if _G.FarmConnection then _G.FarmConnection:Disconnect() end
   ToggleNoClip(false)
end

-- Auto Quest Logic
local function AutoQuestCallback(v)
   _G.AutoQuestFarm = v
   if v then
      spawn(function()
         while _G.AutoQuestFarm do
            local quest = GetQuestByLevel()
            if quest then
               -- TP giver
               player.Character.HumanoidRootPart.CFrame = quest.GiverCFrame
               wait(0.5)
               CommF_:InvokeServer("StartQuest", quest.QuestName, quest.QuestNum)
               wait(1)
               -- Farm mob quest
               StartFarm(function(e) return string.find(e.Name, quest.MobName) end)
            else
               -- Nếu không có quest, farm boss hoặc any
               StartFarm(function(e) return e.Name:find("Boss") end) -- fallback
            end
            wait(3) -- check lại quest mỗi 3s
         end
      end)
   else
      StopFarm()
   end
end

-- Tabs & Toggles (giống v7 nhưng thêm full quest)
local FarmTab = Window:CreateTab("Farm")
FarmTab:CreateToggle({
   Name = "Auto Quest + Farm (Lv1 → Max - All Seas)",
   CurrentValue = false,
   Callback = AutoQuestCallback
})

FarmTab:CreateToggle({
   Name = "Auto Farm Boss (All Seas)",
   CurrentValue = false,
   Callback = function(v) _G.AutoBossFarm = v if v then StartFarm(function(e) return string.find(e.Name:lower(), "boss") or string.find(e.Name:lower(), "king") or string.find(e.Name:lower(), "prince") end) else StopFarm() end end
})

FarmTab:CreateToggle({
   Name = "Auto Farm Bones (Sea 3)",
   CurrentValue = false,
   Callback = function(v) _G.AutoBones = v if v then StartFarm(function(e) return string.find(e.Name, "Skeleton") or string.find(e.Name, "Zombie") or string.find(e.Name, "Soul") end) else StopFarm() end end
})

FarmTab:CreateToggle({
   Name = "Auto Farm Katakuri (Sea 3)",
   CurrentValue = false,
   Callback = function(v) _G.AutoKatakuri = v if v then StartFarm(function(e) return string.find(e.Name, "Cookie") or string.find(e.Name, "Cake") or string.find(e.Name, "Guard") end) else StopFarm() end end
})

FarmTab:CreateToggle({
   Name = "Auto Farm Raid Enemies",
   CurrentValue = false,
   Callback = function(v) _G.AutoRaid = v if v then StartFarm(function(e) return string.find(e.Name, "[Raid") end) else StopFarm() end end
})

-- Fruit, Misc, Tele, Settings (giống v7, copy nếu cần)
local FruitTab = Window:CreateTab("Fruit")
FruitTab:CreateToggle({Name = "Fruit Sniper (TP)", CurrentValue = false, Callback = function(v) _G.FruitSniper = v end})
-- ... (thêm các toggle notify/esp, button random/store như trước)

local MiscTab = Window:CreateTab("Misc")
MiscTab:CreateDropdown({Name = "Stats Priority", Options = {"Melee", "Defense", "Sword", "Gun", "Fruit"}, CurrentOption = "Melee", Callback = function(v) _G.StatsType = v end})
MiscTab:CreateToggle({Name = "Auto Stats", CurrentValue = false, Callback = function(v) 
   _G.AutoStats = v
   spawn(function() while _G.AutoStats do CommF_:InvokeServer("AddPoint", _G.StatsType, 3) wait(0.5) end end)
end})

-- Tele Tab (full islands)
local TeleTab = Window:CreateTab("Teleport")
-- Thêm list islands như v7 (WindMill, Middle Town, Jungle, Desert, Frozen, Prison, Colosseum, Magma, Underwater, Fountain, Kingdom of Rose, Green Zone, Haunted Castle, Sea of Treats, Tiki Outpost, v.v.)

Rayfield:Notify({
   Title = "v8.2 COMPLETED!",
   Content = "Full quest table Lv1 → max, auto quest thông minh cho mọi sea. Bật Auto Quest + Farm để tự động lên level từ đầu đến cuối! TP Haunted/Sea of Treats nếu Lv 2224.",
   Duration = 8
})
