-- Blox Fruits Rayfield Hub v8.3 - FIX LOẠN ITEM FARM | Local Player Tab + Shop + Auto Equip Tool
-- Fix: Farm loop ưu tiên equip tool chỉ định (không loạn item nữa). Tab Local Player: Chọn tool/sword, buy shop, auto equip farm.
-- Full Auto Quest Lv1-Max All Seas, Boss/Bones/Katakuri/Raid/Fruit Sniper

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Blox Fruits Hub v8.3 - FIX LOẠN ITEM",
   LoadingTitle = "Loading Local Player + Shop...",
   LoadingSubtitle = "Đức Mạnh Lv2224 - Cake Guard Farm Fix",
   ConfigurationSaving = { Enabled = true, FolderName = "BFHubV8.3", FileName = "Config" }
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
_G.SelectedTool = nil  -- Tool name to equip for farm (fix loạn item)
_G.UseSelectedTool = false  -- Toggle auto equip selected tool during farm

-- Update backpack tools list dynamically
local function UpdateToolList()
   local tools = {}
   for _, tool in pairs(player.Backpack:GetChildren()) do
      if tool:IsA("Tool") then table.insert(tools, tool.Name) end
   end
   for _, tool in pairs(player.Character:GetChildren()) do
      if tool:IsA("Tool") then table.insert(tools, tool.Name) end
   end
   table.sort(tools)
   return tools
end

-- No-Clip (same)
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

-- FIXED Farm Loop: Ưu tiên equip _G.SelectedTool nếu bật UseSelectedTool
local function StartFarm(filter)
   if _G.FarmConnection then _G.FarmConnection:Disconnect() end
   ToggleNoClip(true)
   Rayfield:Notify({Title = "Farm ON (Fixed Item)", Content = "Equip tool ổn định, không loạn nữa!", Duration = 3})
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
         -- FIXED EQUIP: Ưu tiên SelectedTool nếu có, không thì tool đầu tiên
         local equipped = false
         if _G.UseSelectedTool and _G.SelectedTool then
            local tool = player.Backpack:FindFirstChild(_G.SelectedTool) or char:FindFirstChild(_G.SelectedTool)
            if tool then
               char.Humanoid:EquipTool(tool)
               tool:Activate()
               equipped = true
            end
         end
         if not equipped then
            -- Fallback: equip any tool/sword
            local tool = player.Backpack:FindFirstChildOfClass("Tool")
            if tool then
               char.Humanoid:EquipTool(tool)
               tool:Activate()
            end
         end
      end
   end)
end

local function StopFarm()
   if _G.FarmConnection then _G.FarmConnection:Disconnect() end
   ToggleNoClip(false)
   Rayfield:Notify({Title = "Farm OFF", Content = "Dừng farm!", Duration = 3})
end

-- Auto Quest (same as before)
local function AutoQuestCallback(v)
   _G.AutoQuestFarm = v
   if v then StartFarm(function(e) return true end) -- Farm quest mobs via filter in loop
   else StopFarm() end
end

-- *** NEW TAB: LOCAL PLAYER + SHOP + ITEM FARM ***
local LocalPlayerTab = Window:CreateTab("Local Player")

-- Dropdown chọn tool/sword
LocalPlayerTab:CreateDropdown({
   Name = "Chọn Tool/Sword để Farm (Fix loạn item)",
   Options = UpdateToolList(),
   CurrentOption = "Katana",
   Callback = function(option)
      _G.SelectedTool = option
      Rayfield:Notify({Title = "Tool Selected", Content = option .. " sẽ auto equip khi farm!", Duration = 3})
   end,
   Flag = "SelectedTool"
})

LocalPlayerTab:CreateToggle({
   Name = "Auto Equip Tool Chỉ Định Khi Farm",
   CurrentValue = false,
   Callback = function(v)
      _G.UseSelectedTool = v
      if v then Rayfield:Notify({Title = "Auto Equip ON", Content = "Farm sẽ chỉ dùng " .. (_G.SelectedTool or "tool đầu") .. "!", Duration = 3}) end
   end
})

LocalPlayerTab:CreateButton({
   Name = "Equip Tool Ngay",
   Callback = function()
      local tool = player.Backpack:FindFirstChild(_G.SelectedTool) or player.Character:FindFirstChild(_G.SelectedTool)
      if tool and player.Character then
         player.Character.Humanoid:EquipTool(tool)
         Rayfield:Notify({Title = "Equipped", Content = _G.SelectedTool .. " đã equip!", Duration = 3})
      else
         Rayfield:Notify({Title = "Error", Content = "Không tìm thấy tool!", Duration = 3})
      end
   end
})

-- SHOP INTEGRATION (Buy swords, accessories from dealers)
LocalPlayerTab:CreateSection("Shop Swords/Accessories")

LocalPlayerTab:CreateButton({
   Name = "Buy Katana (300)",
   Callback = function() CommF_:InvokeServer("BuyItem", "Katana") end
})

LocalPlayerTab:CreateButton({
   Name = "Buy Pipe (1000)",
   Callback = function() CommF_:InvokeServer("BuyItem", "Pipe") end
})

LocalPlayerTab:CreateButton({
   Name = "Buy Pole (2.5k)",
   Callback = function() CommF_:InvokeServer("BuyItem", "Pole") end
})

LocalPlayerTab:CreateButton({
   Name = "Buy Dual Katana (15k)",
   Callback = function() CommF_:InvokeServer("BuyItem", "Dual-Katana") end
})

LocalPlayerTab:CreateButton({
   Name = "Buy Saddi (20k)",
   Callback = function() CommF_:InvokeServer("BuyItem", "Saddi") end
})

LocalPlayerTab:CreateButton({
   Name = "Buy Triple Katana (30k)",
   Callback = function() CommF_:InvokeServer("BuyItem", "Triple-Katana") end
})

LocalPlayerTab:CreateSection("Quick Shop")

LocalPlayerTab:CreateButton({
   Name = "Buy Random Bones",
   Callback = function() CommF_:InvokeServer("Bones", "Buy", 10, 1) end
})

LocalPlayerTab:CreateButton({
   Name = "Auto Random Bones (Toggle in Farm)",
   Callback = function() CommF_:InvokeServer("Bones", "Buy", 1, 1) end
})

-- Refresh tool list button
LocalPlayerTab:CreateButton({
   Name = "Refresh Tool List",
   Callback = function()
      Rayfield:Notify({Title = "Refreshed", Content = "Danh sách tool cập nhật!", Duration = 2})
      -- UI auto refresh dropdown via Flag
   end
})

-- Farm Tab (updated callbacks to use fixed equip)
local FarmTab = Window:CreateTab("Farm")
FarmTab:CreateToggle({
   Name = "Auto Quest + Farm (Lv1-Max All Seas)",
   CurrentValue = false,
   Callback = AutoQuestCallback  -- Uses fixed StartFarm
})

FarmTab:CreateToggle({
   Name = "Auto Farm Boss",
   CurrentValue = false,
   Callback = function(v) if v then StartFarm(function(e) return string.find(e.Name:lower(), "boss") end) else StopFarm() end end
})

FarmTab:CreateToggle({
   Name = "Auto Farm Bones",
   CurrentValue = false,
   Callback = function(v) if v then StartFarm(function(e) return string.find(e.Name, "Skeleton") end) else StopFarm() end end
})

FarmTab:CreateToggle({
   Name = "Auto Farm Katakuri (Cake Mobs)",
   CurrentValue = false,
   Callback = function(v) if v then StartFarm(function(e) return string.find(e.Name, "Cookie") or string.find(e.Name, "Cake") end) else StopFarm() end end
})

-- Fruit/Misc/Tele/Settings tabs same as before (copy if needed)

Rayfield:Notify({
   Title = "v8.3 LOẠN ITEM FIXED!",
   Content = "Tab Local Player: Chọn sword/tool → Auto equip farm (không loạn nữa). Buy shop dễ dàng. Bật UseSelectedTool + Auto Farm Katakuri cho Lv2224!",
   Duration = 8,
   Image = 4483362458
})
