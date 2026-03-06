-- Blox Fruits Rayfield Hub v7 - Keyless 2026 | Fix Black UI | Auto Farm, Quest, Boss, Fruit Sniper
-- Rayfield UI: Stable, bright theme, no black screen bug

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Blox Fruits Hub v7 - Keyless",
   LoadingTitle = "Loading for Đức Mạnh...",
   LoadingSubtitle = "Lv 2224 Farm Mode",
   ConfigurationSaving = { Enabled = true, FolderName = "BFHubV7", FileName = "Config" }
})

-- Globals
_G.AutoFarmLevel = false
_G.AutoQuest = false
_G.AutoBoss = false
_G.AutoBones = false
_G.AutoKatakuri = false
_G.AutoRaid = false
_G.FruitSniper = false
_G.FruitNotify = false
_G.FruitESP = false
_G.FarmHeight = 25
_G.AttackDelay = 0.1

-- Fruit Sniper Loop
spawn(function()
   while wait(0.3) do
      if _G.FruitSniper or _G.FruitNotify or _G.FruitESP then
         for _, v in pairs(game.Workspace:GetChildren()) do
            if v:IsA("Tool") and v:FindFirstChild("Handle") then
               local fruit = v.Name
               if _G.FruitNotify then
                  Rayfield:Notify({Title = "Fruit Spawn!", Content = fruit .. " xuất hiện!", Duration = 5})
               end
               if _G.FruitESP then
                  local hl = Instance.new("Highlight", v.Handle)
                  hl.FillColor = Color3.fromRGB(255, 215, 0)
                  hl.OutlineColor = Color3.fromRGB(255, 0, 255)
               end
               if _G.FruitSniper and player.Character then
                  player.Character.HumanoidRootPart.CFrame = v.Handle.CFrame + Vector3.new(0,5,0)
               end
            end
         end
      end
   end
end)

-- Auto Farm Loop
local function AutoFarm(filter)
   spawn(function()
      local vu = game:GetService("VirtualUser")
      vu:CaptureController()
      while _G.AutoFarmLevel or _G.AutoQuest or _G.AutoBoss or _G.AutoBones or _G.AutoKatakuri or _G.AutoRaid do
         pcall(function()
            local char = player.Character
            if not char then return end
            for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
            local closest = nil
            local distMin = 4000
            for _, e in pairs(game.Workspace.Enemies:GetChildren()) do
               local h = e:FindFirstChild("Humanoid")
               if h and h.Health > 0 and e:FindFirstChild("HumanoidRootPart") and (not filter or filter(e)) then
                  local d = (char.HumanoidRootPart.Position - e.HumanoidRootPart.Position).Magnitude
                  if d < distMin then distMin = d closest = e end
               end
            end
            if closest then
               char.HumanoidRootPart.CFrame = closest.HumanoidRootPart.CFrame * CFrame.new(0, _G.FarmHeight, 0)
               wait(_G.AttackDelay)
               local tool = player.Backpack:FindFirstChildOfClass("Tool")
               if tool then char.Humanoid:EquipTool(tool) end
               vu:ClickButton1(Vector2.new())
               if char:FindFirstChildOfClass("Tool") then char:FindFirstChildOfClass("Tool"):Activate() end
            end
         end)
         wait(0.2)
      end
      vu:ReleaseController()
   end)
end

-- Tabs
local FarmTab = Window:CreateTab("Farm")
FarmTab:CreateToggle({Name = "Auto Farm Level", CurrentValue = false, Callback = function(v) _G.AutoFarmLevel = v if v then AutoFarm() end end})
FarmTab:CreateToggle({Name = "Auto Quest + Farm", CurrentValue = false, Callback = function(v) 
   _G.AutoQuest = v 
   if v then 
      spawn(function() while _G.AutoQuest do game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", "CitizenQuest", 1) wait(5) end end) 
      AutoFarm(function(e) return e.Name:find("Quest") or e.Name:find("Bandit") end) 
   end 
end})
FarmTab:CreateToggle({Name = "Auto Farm Boss", CurrentValue = false, Callback = function(v) _G.AutoBoss = v if v then AutoFarm(function(e) return e.Name:lower():find("boss") or e.Name:lower():find("king") end) end end})
FarmTab:CreateToggle({Name = "Auto Farm Bones", CurrentValue = false, Callback = function(v) _G.AutoBones = v if v then AutoFarm(function(e) return e.Name:find("Skeleton") end) end end})
FarmTab:CreateToggle({Name = "Auto Farm Katakuri", CurrentValue = false, Callback = function(v) _G.AutoKatakuri = v if v then AutoFarm(function(e) return e.Name:find("Cake") or e.Name:find("Cookie") end) end end})
FarmTab:CreateToggle({Name = "Auto Farm Raid", CurrentValue = false, Callback = function(v) _G.AutoRaid = v if v then AutoFarm(function(e) return e.Name:find("Raid") end) end end})

local FruitTab = Window:CreateTab("Fruit")
FruitTab:CreateToggle({Name = "Fruit Sniper (TP)", CurrentValue = false, Callback = function(v) _G.FruitSniper = v end})
FruitTab:CreateToggle({Name = "Notify Fruit", CurrentValue = false, Callback = function(v) _G.FruitNotify = v end})
FruitTab:CreateToggle({Name = "ESP Fruit", CurrentValue = false, Callback = function(v) _G.FruitESP = v end})
FruitTab:CreateButton({Name = "Random Fruit", Callback = function() game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin","Buy") end})
FruitTab:CreateButton({Name = "Store Fruit", Callback = function() 
   local f = player.Character:FindFirstChildOfClass("Tool") 
   if f then game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", f.Name) end 
end})

local MiscTab = Window:CreateTab("Misc")
MiscTab:CreateToggle({Name = "Auto Stats Melee", CurrentValue = false, Callback = function(v) spawn(function() while v do game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint","Melee",3) wait(1) end end) end})

local SettingsTab = Window:CreateTab("Settings")
SettingsTab:CreateSlider({Name = "Farm Height", Range = {10, 50}, Increment = 1, CurrentValue = 25, Callback = function(v) _G.FarmHeight = v end})
SettingsTab:CreateSlider({Name = "Attack Delay", Range = {0.05, 0.5}, Increment = 0.01, CurrentValue = 0.1, Callback = function(v) _G.AttackDelay = v end})

Rayfield:Notify({Title = "Hub Loaded!", Content = "UI Rayfield ổn định, không đen nữa! Bật Auto Quest + Farm để lên lv nhanh nhé anh Mạnh!", Duration = 6})
