-- Blox Fruits Gem Hub v8.4 - Keyless | FIX LOẠN ITEM + AUTO HỦY QUEST + LOCAL PLAYER + STATUS SERVER
-- Optimized for Lv 2224 Sea 3 (Cake Guard / Bones / Katakuri) | Rayfield UI Stable 2026

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Gem Blox Fruits Hub v8.4 - Keyless",
   LoadingTitle = "Đang tải Gem Hub cho Lv 2224...",
   LoadingSubtitle = "Cake Guard Farm Fix - No Loạn Item",
   ConfigurationSaving = { Enabled = true, FolderName = "GemBFHubV8", FileName = "Config" }
})

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local CommF_ = ReplicatedStorage.Remotes.CommF_
local playerGui = player:WaitForChild("PlayerGui")

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
_G.LastEquipTime = 0
_G.SelectedTool = nil
_G.UseSelectedTool = false
_G.FarmConnection = nil
_G.NoClipConnection = nil

-- Check if quest active (fix auto hủy)
local function IsQuestActive()
   local questGui = playerGui.Main.Quest
   return questGui.Visible and questGui.Container.QuestTitle.Title.Text ~= ""
end

-- Get current quest mob name (parse từ GUI)
local function GetQuestMobName()
   local questGui = playerGui.Main.Quest
   if questGui.Visible then
      local title = questGui.Container.QuestTitle.Title.Text
      local mob = title:match("Defeat (%d+) (.+)") or title:match("(.+) %[Lv%.") or ""
      return mob:match("^(.+) %[Lv") or mob
   end
   return nil
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

-- Farm Loop FIX LOẠN ITEM
local function StartFarm(filter)
   if _G.FarmConnection then _G.FarmConnection:Disconnect() end
   ToggleNoClip(true)
   Rayfield:Notify({Title = "Farm ON", Content = "Đã fix loạn item + auto equip ổn định!", Duration = 4})

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
         hrp.CFrame = closest.HumanoidRootPart.CFrame * CFrame.new(math.random(-3,3), _G.FarmHeight, math.random(-3,3))

         -- FIX EQUIP: Chỉ equip nếu cần + cooldown 1.5s + check current
         if tick() - _G.LastEquipTime > 1.5 then
            local equipped = false
            if _G.UseSelectedTool and _G.SelectedTool then
               local tool = player.Backpack:FindFirstChild(_G.SelectedTool) or char:FindFirstChild(_G.SelectedTool)
               if tool and char:FindFirstChildOfClass("Tool") ~= tool then
                  char.Humanoid:EquipTool(tool)
                  tool:Activate()
                  equipped = true
               end
            end
            if not equipped then
               local currentTool = char:FindFirstChildOfClass("Tool")
               if not currentTool then
                  local fallback = player.Backpack:FindFirstChildOfClass("Tool")
                  if fallback then
                     char.Humanoid:EquipTool(fallback)
                     fallback:Activate()
                  end
               else
                  currentTool:Activate()
               end
            end
            _G.LastEquipTime = tick()
         end
      end
   end)
end

local function StopFarm()
   if _G.FarmConnection then _G.FarmConnection:Disconnect() end
   ToggleNoClip(false)
   Rayfield:Notify({Title = "Farm OFF", Content = "Đã dừng farm an toàn!", Duration = 3})
end

-- Auto Quest + Check Active
local function AutoQuestCallback(v)
   _G.AutoQuestFarm = v
   if v then
      spawn(function()
         while _G.AutoQuestFarm do
            if not IsQuestActive() then
               -- TP giver + accept quest
               local quest = GetQuestByLevel() -- từ table trước
               if quest then
                  player.Character.HumanoidRootPart.CFrame = quest.GiverCFrame
                  wait(0.6)
                  CommF_:InvokeServer("StartQuest", quest.QuestName, quest.QuestNum)
                  wait(1.5)
               end
            end
            local mobName = GetQuestMobName()
            if mobName then
               StartFarm(function(e) return string.find(e.Name, mobName) end)
            else
               StartFarm(nil) -- fallback
            end
            wait(2)
         end
      end)
   else
      StopFarm()
   end
end

-- Tab Local Player + Status Server
local LocalTab = Window:CreateTab("Local Player")
LocalTab:CreateSection("Status Server (Refresh)")

LocalTab:CreateButton({
   Name = "Refresh Status Server",
   Callback = function()
      local lv = player.Data.Level.Value
      local beli = player.leaderstats.Beli.Value
      local frag = player.Data.Fragments.Value
      local bounty = player.leaderstats["Bounty/Honor"] and player.leaderstats["Bounty/Honor"].Value or "N/A"
      local fruit = player.Data.DevilFruit.Value ~= "" and player.Data.DevilFruit.Value or "No Fruit"
      local sea = GetCurrentSea()
      local mastery = {}
      for _, tool in pairs(player.Backpack:GetChildren()) do
         if tool:IsA("Tool") and tool:FindFirstChild("Mastery") then
            table.insert(mastery, tool.Name .. ": " .. tool.Mastery.Value)
         end
      end
      Rayfield:Notify({
         Title = "Server Status",
         Content = string.format(
            "Lv: %d | Sea: %d | Beli: %s | Frag: %s | Bounty: %s\nFruit: %s\nMastery: %s",
            lv, sea, beli, frag, bounty, fruit, table.concat(mastery, ", ")
         ),
         Duration = 10
      })
   end
})

LocalTab:CreateSection("Tool & Equip Fix Loạn Item")

LocalTab:CreateDropdown({
   Name = "Chọn Sword/Tool để Farm",
   Options = UpdateToolList(),
   CurrentOption = "Katana",
   Callback = function(opt)
      _G.SelectedTool = opt
      Rayfield:Notify({Title = "Selected", Content = "Sẽ ưu tiên equip " .. opt .. " khi farm!", Duration = 3})
   end
})

LocalTab:CreateToggle({
   Name = "Auto Equip Tool Chỉ Định (Fix Loạn Item)",
   CurrentValue = true,
   Callback = function(v)
      _G.UseSelectedTool = v
      Rayfield:Notify({Title = "Auto Equip", Content = v and "ON - Farm ổn định tool" or "OFF", Duration = 3})
   end
})

LocalTab:CreateButton({
   Name = "Equip Ngay Tool Đã Chọn",
   Callback = function()
      if _G.SelectedTool then
         local tool = player.Backpack:FindFirstChild(_G.SelectedTool) or player.Character:FindFirstChild(_G.SelectedTool)
         if tool and player.Character then
            player.Character.Humanoid:EquipTool(tool)
            Rayfield:Notify({Title = "Equipped", Content = _G.SelectedTool .. " đã cầm!", Duration = 3})
         end
      end
   end
})

-- Shop Section
LocalTab:CreateSection("Shop Swords (Buy nhanh)")
LocalTab:CreateButton({Name = "Buy Katana (300)", Callback = function() CommF_:InvokeServer("BuyItem", "Katana") end})
LocalTab:CreateButton({Name = "Buy Pole (2.5k)", Callback = function() CommF_:InvokeServer("BuyItem", "Pole") end})
LocalTab:CreateButton({Name = "Buy Triple Katana (30k)", Callback = function() CommF_:InvokeServer("BuyItem", "Triple Katana") end})
LocalTab:CreateButton({Name = "Buy Saddi (20k)", Callback = function() CommF_:InvokeServer("BuyItem", "Saddi") end})

-- Farm Tab
local FarmTab = Window:CreateTab("Farm")
FarmTab:CreateToggle({
   Name = "Auto Quest + Farm (Lv1-Max All Seas)",
   CurrentValue = false,
   Callback = AutoQuestCallback
})
FarmTab:CreateToggle({
   Name = "Auto Farm Boss",
   CurrentValue = false,
   Callback = function(v) if v then StartFarm(function(e) return e.Name:lower():find("boss") or e.Name:lower():find("king") end) else StopFarm() end end
})
FarmTab:CreateToggle({
   Name = "Auto Farm Bones (Reborn Skeleton)",
   CurrentValue = false,
   Callback = function(v) if v then StartFarm(function(e) return e.Name:find("Reborn Skeleton") end) else StopFarm() end end
})
FarmTab:CreateToggle({
   Name = "Auto Farm Katakuri (Cake Mobs)",
   CurrentValue = false,
   Callback = function(v) if v then StartFarm(function(e) return e.Name:find("Cookie") or e.Name:find("Cake") end) else StopFarm() end end
})

Rayfield:Notify({
   Title = "v8.4 - LOẠN ITEM ĐÃ FIX HOÀN TOÀN!",
   Content = "Tab Local Player: Chọn sword/tool → bật Auto Equip → farm Cake Guard không còn loạn item nữa. Status Server refresh đầy đủ thông tin. Bật Auto Quest + Farm để auto!",
   Duration = 10
})
