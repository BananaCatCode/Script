-- Blox Fruits Hub v6.5 - Keyless - Auto Quest, Fruit Sniper/Finder, Farm Boss, Bones, Katakuri, Raid
-- Made for 2025-2026 Update | No Key | PC & Mobile Support

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Blox Fruits Hub v6.5 - Keyless", "DarkTheme")

local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local CommF_ = ReplicatedStorage.Remotes.CommF_

-- Globals
local _G = _G or {}
_G.AutoFarm = false
_G.AutoQuest = false
_G.AutoBoss = false
_G.AutoBones = false
_G.AutoKatakuri = false
_G.AutoRaid = false
_G.FruitSniper = false
_G.FruitNotifier = false
_G.FruitESP = false
_G.FarmHeight = 25
_G.SelectedBoss = "All Bosses"

-- Fruit Sniper / Finder Logic
spawn(function()
    while wait(0.5) do
        if _G.FruitSniper or _G.FruitNotifier or _G.FruitESP then
            for _, v in pairs(Workspace:GetChildren()) do
                if v:IsA("Tool") and v:FindFirstChild("Handle") then  -- Devil Fruit on ground
                    local fruitName = v.Name
                    if _G.FruitNotifier then
                        game.StarterGui:SetCore("SendNotification", {
                            Title = "Fruit Spawned!",
                            Text = fruitName .. " appeared!",
                            Duration = 5
                        })
                    end
                    if _G.FruitESP then
                        local esp = Instance.new("Highlight")
                        esp.FillColor = Color3.fromRGB(255, 0, 255)
                        esp.OutlineColor = Color3.fromRGB(255, 255, 0)
                        esp.FillTransparency = 0.5
                        esp.Parent = v.Handle
                    end
                    if _G.FruitSniper then
                        -- Teleport to fruit (simple, add distance check if needed)
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            player.Character.HumanoidRootPart.CFrame = v.Handle.CFrame + Vector3.new(0, 5, 0)
                            firetouchinterest(player.Character.HumanoidRootPart, v.Handle, 0)
                            wait(0.1)
                            firetouchinterest(player.Character.HumanoidRootPart, v.Handle, 1)
                        end
                    end
                end
            end
        end
    end
end)

-- Basic Farm Function (used for Level, Quest, Boss, Bones, Katakuri, Raid)
local function AutoFarmLoop(targetFilter)
    spawn(function()
        game:GetService("VirtualUser"):CaptureController()
        while _G.AutoFarm or _G.AutoQuest or _G.AutoBoss or _G.AutoBones or _G.AutoKatakuri or _G.AutoRaid do
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                
                -- No clip
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
                
                local closest = nil
                local minDist = 5000
                
                for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                    local hum = enemy:FindFirstChild("Humanoid")
                    if hum and hum.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                        local ok = true
                        if targetFilter then ok = targetFilter(enemy) end
                        if ok then
                            local dist = (char.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                            if dist < minDist then
                                minDist = dist
                                closest = enemy
                            end
                        end
                    end
                end
                
                if closest then
                    char.HumanoidRootPart.CFrame = closest.HumanoidRootPart.CFrame * CFrame.new(0, _G.FarmHeight, 0)
                    -- Equip tool
                    local tool = player.Backpack:FindFirstChildOfClass("Tool")
                    if tool then char.Humanoid:EquipTool(tool) end
                    -- Attack
                    VirtualUser:ClickButton1(Vector2.new())
                    if char:FindFirstChildOfClass("Tool") then char:FindFirstChildOfClass("Tool"):Activate() end
                end
            end)
            wait(0.2)
        end
        game:GetService("VirtualUser"):ReleaseController()
    end)
end

-- Tabs
local FarmTab = Window:NewTab("Farm")
local FruitTab = Window:NewTab("Fruit")
local MiscTab = Window:NewTab("Misc")
local TeleTab = Window:NewTab("Teleport")
local SettingsTab = Window:NewTab("Settings")

-- Farm Tab
FarmTab:NewToggle("Auto Farm Level", "Farm any mob", function(v)
    _G.AutoFarm = v
    if v then AutoFarmLoop() end
end)

FarmTab:NewToggle("Auto Quest + Farm", "Auto accept & farm quest", function(v)
    _G.AutoQuest = v
    if v then
        spawn(function()
            while _G.AutoQuest do
                -- Simple quest accept logic (expand if needed)
                CommF_:InvokeServer("StartQuest", "CitizenQuest", 1)  -- example
                wait(3)
            end
        end)
        AutoFarmLoop(function(e) return string.find(e.Name, "Bandit") end)  -- change based on quest
    end
end)

FarmTab:NewToggle("Auto Farm Boss", "Farm selected boss", function(v)
    _G.AutoBoss = v
    if v then AutoFarmLoop(function(e) return string.find(e.Name:lower(), _G.SelectedBoss:lower()) end) end
end)

FarmTab:NewDropdown("Select Boss", "Choose boss to farm", {"All Bosses", "Rip Indra", "Dough King", "Cake Prince", "Cursed Captain"}, function(v)
    _G.SelectedBoss = v
end)

FarmTab:NewToggle("Auto Farm Bones", "", function(v)
    _G.AutoBones = v
    if v then AutoFarmLoop(function(e) return string.find(e.Name, "Skeleton") or string.find(e.Name, "Zombie") end) end
end)

FarmTab:NewToggle("Auto Farm Katakuri (Cake Prince)", "", function(v)
    _G.AutoKatakuri = v
    if v then AutoFarmLoop(function(e) return string.find(e.Name, "Cookie") or string.find(e.Name, "Cake") end) end
end)

FarmTab:NewToggle("Auto Raid Enemies", "", function(v)
    _G.AutoRaid = v
    if v then AutoFarmLoop(function(e) return string.find(e.Name, "Raid") end) end
end)

-- Fruit Tab
FruitTab:NewToggle("Fruit Sniper (TP to fruit)", "Auto teleport to spawned fruit", function(v)
    _G.FruitSniper = v
end)

FruitTab:NewToggle("Fruit Notifier", "Notify when fruit spawn", function(v)
    _G.FruitNotifier = v
end)

FruitTab:NewToggle("Fruit ESP", "Highlight fruits", function(v)
    _G.FruitESP = v
end)

FruitTab:NewButton("Random Fruit (Cousin)", function()
    CommF_:InvokeServer("Cousin", "Buy")
end)

FruitTab:NewButton("Store Fruit", function()
    CommF_:InvokeServer("StoreFruit", player.Character:FindFirstChildOfClass("Tool") and player.Character:FindFirstChildOfClass("Tool").Name or "")
end)

-- Misc Tab (add more like stats, hop server...)
MiscTab:NewToggle("Auto Stats (Melee)", "", function(v)
    spawn(function()
        while v do
            CommF_:InvokeServer("AddPoint", "Melee", 3)
            wait(1)
        end
    end)
end)

-- Settings Tab
SettingsTab:NewSlider("Farm Height", "Adjust farm position height", 50, 10, function(v)
    _G.FarmHeight = v
end)

-- Note: Expand more features (Teleport islands, Raid buy chip, etc.) if needed
-- This is a typical "hub" style script - clean, toggle-based, no heavy UI library dependency issues

print("Blox Fruits Hub v6.5 Loaded - Enjoy farming!")
