-- Blox Fruits Orca UI Hub v6.5 - Keyless 2026 | Auto Farm, Quest, Boss, Bones, Katakuri, Raid, Fruit Sniper
-- Fix UI black screen issue from Kavo - Use Orca for better stability

loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orca/master/library.lua"))() -- Orca UI Library (stable 2026)

local Window = Orca:NewWindow("Blox Fruits Hub v6.5 - Keyless", "Đức Mạnh Farm 2026")

-- Globals
local _G = _G or {}
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
_G.SelectedBoss = "All Bosses"

-- Fruit Sniper / Finder Loop
spawn(function()
    while wait(0.3) do
        if _G.FruitSniper or _G.FruitNotify or _G.FruitESP then
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v:IsA("Tool") and v:FindFirstChild("Handle") then
                    local fruitName = v.Name
                    if _G.FruitNotify then
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "Fruit Spawned!",
                            Text = fruitName .. " xuất hiện gần bạn!",
                            Duration = 6
                        })
                    end
                    if _G.FruitESP then
                        local hl = Instance.new("Highlight", v.Handle)
                        hl.FillColor = Color3.fromRGB(255, 0, 255)
                        hl.OutlineColor = Color3.fromRGB(255, 215, 0)
                        hl.FillTransparency = 0.4
                    end
                    if _G.FruitSniper and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = player.Character.HumanoidRootPart
                        hrp.CFrame = v.Handle.CFrame + Vector3.new(0, 5, 0)
                        firetouchinterest(hrp, v.Handle, 0) wait(0.05) firetouchinterest(hrp, v.Handle, 1)
                    end
                end
            end
        end
    end
end)

-- Auto Farm Loop (shared for all modes)
local function StartAutoFarm(filterFunc)
    spawn(function()
        local vu = game:GetService("VirtualUser")
        vu:CaptureController()
        while _G.AutoFarmLevel or _G.AutoQuest or _G.AutoBoss or _G.AutoBones or _G.AutoKatakuri or _G.AutoRaid do
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                
                -- No clip
                for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
                
                local closest = nil
                local minDist = 4000
                
                for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
                    local hum = enemy:FindFirstChild("Humanoid")
                    if hum and hum.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                        local ok = filterFunc and filterFunc(enemy) or true  -- if no filter, farm any
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
                    char.HumanoidRootPart.CFrame = closest.HumanoidRootPart.CFrame * CFrame.new(math.random(-3,3), _G.FarmHeight, math.random(-3,3))
                    wait(_G.AttackDelay)
                    -- Equip tool
                    local tool = player.Backpack:FindFirstChildOfClass("Tool")
                    if tool then char.Humanoid:EquipTool(tool) end
                    -- Attack
                    vu:ClickButton1(Vector2.new())
                    if char:FindFirstChildOfClass("Tool") then char:FindFirstChildOfClass("Tool"):Activate() end
                end
            end)
            wait(0.15)
        end
        vu:ReleaseController()
    end)
end

-- Tabs
local FarmTab = Orca:NewTab("Farm")
FarmTab:NewToggle("Auto Farm Level", "Farm mob gần nhất", function(v)
    _G.AutoFarmLevel = v
    if v then StartAutoFarm() end
end)

FarmTab:NewToggle("Auto Quest + Farm", "Tự accept quest & farm mob quest", function(v)
    _G.AutoQuest = v
    if v then
        spawn(function()
            while _G.AutoQuest do
                -- Auto accept quest đơn giản (có thể expand)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", "CitizenQuest", 1) -- ví dụ, thay bằng quest phù hợp
                wait(4)
            end
        end)
        StartAutoFarm(function(e) return e.Name:find("Bandit") or e.Name:find("Quest") end) -- filter mob quest
    end
end)

FarmTab:NewToggle("Auto Farm Boss", "", function(v)
    _G.AutoBoss = v
    if v then
        StartAutoFarm(function(e)
            local name = e.Name:lower()
            return name:find("boss") or name:find("king") or name:find("indra") or name:find("dough") or name:find("cursed") -- add more
        end)
    end
end)

FarmTab:NewDropdown("Chọn Boss", {"All Bosses", "Rip Indra", "Dough King", "Cake Prince", "Cursed Captain"}, function(v)
    _G.SelectedBoss = v
end)

FarmTab:NewToggle("Auto Farm Bones", "", function(v)
    _G.AutoBones = v
    if v then StartAutoFarm(function(e) return e.Name:find("Skeleton") or e.Name:find("Zombie") or e.Name:find("Soul") end) end
end)

FarmTab:NewToggle("Auto Farm Katakuri (Cake Prince)", "", function(v)
    _G.AutoKatakuri = v
    if v then StartAutoFarm(function(e) return e.Name:find("Cookie") or e.Name:find("Cake") or e.Name:find("Guard") end) end
end)

FarmTab:NewToggle("Auto Farm Raid Enemies", "", function(v)
    _G.AutoRaid = v
    if v then StartAutoFarm(function(e) return e.Name:find("Raid") or e.Name:find("Master") end) end
end)

-- Fruit Tab
local FruitTab = Orca:NewTab("Fruit")
FruitTab:NewToggle("Fruit Sniper (TP lấy trái)", function(v) _G.FruitSniper = v end)
FruitTab:NewToggle("Notify khi trái spawn", function(v) _G.FruitNotify = v end)
FruitTab:NewToggle("ESP trái (highlight)", function(v) _G.FruitESP = v end)

FruitTab:NewButton("Random Fruit (Cousin)", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "Buy")
end)

FruitTab:NewButton("Store Fruit", function()
    local fruit = player.Character:FindFirstChildOfClass("Tool")
    if fruit then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", fruit.Name, fruit)
    end
end)

-- Misc Tab
local MiscTab = Orca:NewTab("Misc")
MiscTab:NewToggle("Auto Stats (Melee)", function(v)
    spawn(function()
        while v do
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Melee", 3)
            wait(1)
        end
    end)
end)

-- Settings Tab
local SettingsTab = Orca:NewTab("Settings")
SettingsTab:NewSlider("Farm Height", 10, 50, _G.FarmHeight, function(v) _G.FarmHeight = v end)
SettingsTab:NewSlider("Attack Delay", 0.05, 0.5, _G.AttackDelay, function(v) _G.AttackDelay = v end)

print("Blox Fruits Hub v6.5 Loaded - Chúc Đức Mạnh farm vui, lên max level nhanh nhé! 🍉")
