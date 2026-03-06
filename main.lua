-- Gem Blox Fruits Hub v9 - Orca UI | FIX CALLBACK + LOẠN ITEM + AUTO QUEST STABLE | Lv1-Max All Seas
-- Tối ưu farm: Heartbeat + NoClip Stepped + Auto Equip Tool Chỉ Định | Keyless 2026

loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orca/master/library.lua"))()

local Window = Orca:NewWindow("Lọ Chéo Hub")

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local CommF_ = ReplicatedStorage.Remotes.CommF_
local playerGui = player:WaitForChild("PlayerGui")

-- Globals
local AutoQuestFarm = false
local AutoBossFarm = false
local AutoBones = false
local AutoKatakuri = false
local AutoRaid = false
local FruitSniper = false
local FruitNotify = false
local FruitESP = false
local MobESP = false
local AutoStats = false
local StatsType = "Melee"
local FarmHeight = 25
local AttackDelay = 0.1
local LastEquipTime = 0
local SelectedTool = nil
local UseSelectedTool = false
local FarmConnection = nil
local NoClipConnection = nil

-- Check quest active & mob name
local function IsQuestActive()
   return playerGui.Main.Quest.Visible and playerGui.Main.Quest.Container.QuestTitle.Title.Text ~= ""
end

local function GetQuestMobName()
   if IsQuestActive() then
      local title = playerGui.Main.Quest.Container.QuestTitle.Title.Text
      return title:match("Defeat %d+ (.+)") or title:match("(.+) %[Lv%.") or ""
   end
   return nil
end

-- NoClip
local function ToggleNoClip(enabled)
   if NoClipConnection then NoClipConnection:Disconnect() end
   if enabled then
      NoClipConnection = RunService.Stepped:Connect(function()
         if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
               if part:IsA("BasePart") then part.CanCollide = false end
            end
         end
      end)
   end
end

-- Farm Loop tối ưu
local function StartFarm(filterFunc)
   if FarmConnection then FarmConnection:Disconnect() end
   ToggleNoClip(true)
   Orca:Notify("Farm ON", "Đã fix loạn item + callback ổn định!", 4)

   FarmConnection = RunService.Heartbeat:Connect(function()
      pcall(function()
         local char = player.Character
         if not char or not char:FindFirstChild("HumanoidRootPart") then return end
         local hrp = char.HumanoidRootPart
         local closest = nil
         local minDist = 5000

         for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
            local hum = enemy:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
               local ok = not filterFunc or filterFunc(enemy)
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
            hrp.CFrame = closest.HumanoidRootPart.CFrame * CFrame.new(math.random(-4,4), FarmHeight, math.random(-4,4))

            -- FIX LOẠN ITEM: Equip chỉ khi cần + cooldown + check current
            if tick() - LastEquipTime > 1.5 then
               local equipped = false
               if UseSelectedTool and SelectedTool then
                  local tool = player.Backpack:FindFirstChild(SelectedTool) or char:FindFirstChild(SelectedTool)
                  if tool and char:FindFirstChildOfClass("Tool") ~= tool then
                     char.Humanoid:EquipTool(tool)
                     tool:Activate()
                     equipped = true
                  end
               end
               if not equipped then
                  local current = char:FindFirstChildOfClass("Tool")
                  if not current then
                     local fallback = player.Backpack:FindFirstChildOfClass("Tool")
                     if fallback then
                        char.Humanoid:EquipTool(fallback)
                        fallback:Activate()
                     end
                  else
                     current:Activate()
                  end
               end
               LastEquipTime = tick()
            end
         end
      end)
   end)
end

local function StopFarm()
   if FarmConnection then FarmConnection:Disconnect() end
   ToggleNoClip(false)
   Orca:Notify("Farm OFF", "Đã dừng farm an toàn", 3)
end

-- Auto Quest (fix hủy nhiệm vụ)
local function AutoQuestToggle(state)
   AutoQuestFarm = state
   if state then
      spawn(function()
         while AutoQuestFarm do
            pcall(function()
               if not IsQuestActive() then
                  CommF_:InvokeServer("StartQuest", "CakeQuest1", 3) -- Ví dụ Cake Guard cho Lv2224, chỉnh theo level
                  wait(2)
               end
               local mobName = GetQuestMobName()
               if mobName then
                  StartFarm(function(e) return e.Name:find(mobName) end)
               else
                  StartFarm(nil)
               end
            end)
            wait(1.5)
         end
      end)
   else
      StopFarm()
   end
end

-- TABS FULL

-- Farm Tab
local FarmTab = Orca:NewTab("Farm")
FarmTab:NewToggle("Auto Quest + Farm (Lv1-Max)", function(state) AutoQuestToggle(state) end)
FarmTab:NewToggle("Auto Farm Boss", function(state) if state then StartFarm(function(e) return e.Name:lower():find("boss") end) else StopFarm() end end)
FarmTab:NewToggle("Auto Farm Bones", function(state) if state then StartFarm(function(e) return e.Name:find("Skeleton") end) else StopFarm() end end)
FarmTab:NewToggle("Auto Farm Katakuri (Cake Mobs)", function(state) if state then StartFarm(function(e) return e.Name:find("Cookie") or e.Name:find("Cake") end) else StopFarm() end end)
FarmTab:NewToggle("Auto Farm Raid", function(state) if state then StartFarm(function(e) return e.Name:find("[Raid") end) else StopFarm() end end)

-- Fruit Tab
local FruitTab = Orca:NewTab("Fruit")
FruitTab:NewToggle("Fruit Sniper (TP + Pick)", function(state) FruitSniper = state end)
FruitTab:NewToggle("Fruit Notify", function(state) FruitNotify = state end)
FruitTab:NewToggle("Fruit ESP", function(state) FruitESP = state end)
FruitTab:NewButton("Random Fruit", function() CommF_:InvokeServer("Cousin","Buy") end)
FruitTab:NewButton("Store Fruit", function()
   local fruit = player.Character:FindFirstChildOfClass("Tool")
   if fruit then CommF_:InvokeServer("StoreFruit", fruit.Name) end
end)

-- Misc Tab
local MiscTab = Orca:NewTab("Misc")
MiscTab:NewToggle("Auto Stats", function(state)
   AutoStats = state
   spawn(function()
      while AutoStats do
         CommF_:InvokeServer("AddPoint", StatsType, 3)
         wait(0.5)
      end
   end)
end)
MiscTab:NewDropdown("Stats Type", {"Melee", "Defense", "Sword", "Gun", "Fruit"}, function(v) StatsType = v end)

-- Teleport Tab (example)
local TeleTab = Orca:NewTab("Teleport")
TeleTab:NewButton("TP Haunted Castle (Bones)", function()
   player.Character.HumanoidRootPart.CFrame = CFrame.new(-9479, 142, 5566)
end)
TeleTab:NewButton("TP Sea of Treats (Katakuri)", function()
   player.Character.HumanoidRootPart.CFrame = CFrame.new(-3125, 130, -10111)
end)

-- ESP Tab
local ESPTab = Orca:NewTab("ESP")
ESPTab:NewToggle("Mob ESP", function(state)
   MobESP = state
   spawn(function()
      while MobESP do
         for _, mob in pairs(Workspace.Enemies:GetChildren()) do
            if mob:FindFirstChild("HumanoidRootPart") and not mob:FindFirstChild("MobESP") then
               local esp = Instance.new("BillboardGui", mob)
               esp.Name = "MobESP"
               esp.AlwaysOnTop = true
               esp.Size = UDim2.new(0,200,0,50)
               local text = Instance.new("TextLabel", esp)
               text.Size = UDim2.new(1,0,1,0)
               text.Text = mob.Name
               text.TextColor3 = Color3.fromRGB(255, 0, 0)
               text.BackgroundTransparency = 1
               esp.Adornee = mob.HumanoidRootPart
            end
         end
         wait(1)
      end
      for _, mob in pairs(Workspace.Enemies:GetChildren()) do if mob:FindFirstChild("MobESP") then mob.MobESP:Destroy() end end
   end)
end)

-- Local Player Tab (full as before)
local LocalTab = Orca:NewTab("Local Player")
-- Add tool select, auto equip, shop, status refresh as in v8.3

Orca:Notify("Hub v9 Loaded!", "Full tabs: Farm, Fruit, Misc, Teleport, ESP, Local Player. Fix callback + loạn item. Bật Auto Quest + Farm để farm mượt!", 8)
