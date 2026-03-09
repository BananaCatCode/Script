-- Dark Transparent UI + Features (Fly, Speed, Noclip, Godmode, Infinite Jump) + Settings
-- Rainbow border, draggable icon, thu/expand effect, Ctrl hide

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

if pg:FindFirstChild("DarkTransparentUI") then
    pg.DarkTransparentUI:Destroy()
end

local sg = Instance.new("ScreenGui")
sg.Name = "DarkTransparentUI"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = pg

-- ICON (draggable)
local icon = Instance.new("TextButton")
icon.Name = "IconToggle"
icon.Size = UDim2.new(0, 45, 0, 45)
icon.Position = UDim2.new(1, -60, 1, -70)
icon.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
icon.Text = "⋮"
icon.TextColor3 = Color3.fromRGB(180, 180, 255)
icon.TextScaled = true
icon.Font = Enum.Font.GothamBold
icon.ZIndex = 1500
icon.Active = true
icon.Draggable = true
icon.Parent = sg

local iconCorner = Instance.new("UICorner", icon)
iconCorner.CornerRadius = UDim.new(1, 0)

local iconStroke = Instance.new("UIStroke", icon)
iconStroke.Thickness = 2.5
iconStroke.Transparency = 0.2
iconStroke.Color = Color3.new(1,1,1)
iconStroke.Parent = icon

local iconGradient = Instance.new("UIGradient", iconStroke)
iconGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,165,0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255,255,0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,0)),
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,255,255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(0,0,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,255))
}
iconGradient.Rotation = 0

-- MAIN FRAME
local mf = Instance.new("Frame")
mf.Name = "MainFrame"
mf.Size = UDim2.new(0.4, 0, 0.6, 0)
mf.Position = UDim2.new(0.3, 0, 0.2, 0)
mf.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
mf.BackgroundTransparency = 0.32
mf.BorderSizePixel = 0
mf.Active = true
mf.Draggable = true
mf.ZIndex = 500
mf.Parent = sg

local mfCorner = Instance.new("UICorner", mf)
mfCorner.CornerRadius = UDim.new(0, 18)

local rainbowStroke = Instance.new("UIStroke")
rainbowStroke.Thickness = 4.5
rainbowStroke.Transparency = 0
rainbowStroke.Color = Color3.new(1,1,1)
rainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
rainbowStroke.LineJoinMode = Enum.LineJoinMode.Round
rainbowStroke.Parent = mf

local rainbowGradient = Instance.new("UIGradient")
rainbowGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,165,0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255,255,0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,0)),
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,255,255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(0,0,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,255))
}
rainbowGradient.Rotation = 0
rainbowGradient.Parent = rainbowStroke

RunService.RenderStepped:Connect(function(delta)
    rainbowGradient.Rotation = (rainbowGradient.Rotation + delta * 45) % 360
    iconGradient.Rotation = (iconGradient.Rotation + delta * 45) % 360
end)

-- Tab System (Main Features & Settings)
local tabFrame = Instance.new("Frame", mf)
tabFrame.Size = UDim2.new(1, -20, 1, -50)
tabFrame.Position = UDim2.new(0, 10, 0, 40)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mf

local mainTabBtn = Instance.new("TextButton")
mainTabBtn.Size = UDim2.new(0.5, -10, 0, 30)
mainTabBtn.Position = UDim2.new(0, 0, 0, 0)
mainTabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
mainTabBtn.Text = "Main Features"
mainTabBtn.TextColor3 = Color3.new(1,1,1)
mainTabBtn.Font = Enum.Font.GothamBold
mainTabBtn.Parent = mf

local settingsTabBtn = Instance.new("TextButton")
settingsTabBtn.Size = UDim2.new(0.5, -10, 0, 30)
settingsTabBtn.Position = UDim2.new(0.5, 10, 0, 0)
settingsTabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
settingsTabBtn.Text = "Settings"
settingsTabBtn.TextColor3 = Color3.new(1,1,1)
settingsTabBtn.Font = Enum.Font.GothamBold
settingsTabBtn.Parent = mf

-- Main Features Tab Content
local mainContent = Instance.new("ScrollingFrame", tabFrame)
mainContent.Size = UDim2.new(1, 0, 1, 0)
mainContent.BackgroundTransparency = 1
mainContent.ScrollBarThickness = 5
mainContent.Visible = true

local featuresList = Instance.new("UIListLayout", mainContent)
featuresList.Padding = UDim.new(0, 10)
featuresList.SortOrder = Enum.SortOrder.LayoutOrder

-- Fly Toggle
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(1, -20, 0, 40)
flyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
flyBtn.Text = "Fly: OFF"
flyBtn.TextColor3 = Color3.new(1,1,1)
flyBtn.Font = Enum.Font.Gotham
flyBtn.Parent = mainContent

local flySpeed = 50
local flying = false
local flyConnection

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = "Fly: " .. (flying and "ON" or "OFF")
    if flying then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Parent = player.Character.HumanoidRootPart

        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.P = 9e4
        bodyGyro.Parent = player.Character.HumanoidRootPart

        flyConnection = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            local moveDir = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end
            bodyVelocity.Velocity = moveDir * flySpeed
            bodyGyro.CFrame = cam.CFrame
        end)
    else
        if flyConnection then flyConnection:Disconnect() end
        if player.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") then player.Character.HumanoidRootPart.BodyVelocity:Destroy() end
        if player.Character.HumanoidRootPart:FindFirstChild("BodyGyro") then player.Character.HumanoidRootPart.BodyGyro:Destroy() end
    end
end)

-- Noclip Toggle
local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(1, -20, 0, 40)
noclipBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
noclipBtn.Text = "Noclip: OFF"
noclipBtn.TextColor3 = Color3.new(1,1,1)
noclipBtn.Font = Enum.Font.Gotham
noclipBtn.Parent = mainContent

local noclipping = false
local noclipConn

noclipBtn.MouseButton1Click:Connect(function()
    noclipping = not noclipping
    noclipBtn.Text = "Noclip: " .. (noclipping and "ON" or "OFF")
    if noclipping then
        noclipConn = RunService.Stepped:Connect(function()
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() end
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- Infinite Jump Toggle
local infJumpBtn = Instance.new("TextButton")
infJumpBtn.Size = UDim2.new(1, -20, 0, 40)
infJumpBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
infJumpBtn.Text = "Infinite Jump: OFF"
infJumpBtn.TextColor3 = Color3.new(1,1,1)
infJumpBtn.Font = Enum.Font.Gotham
infJumpBtn.Parent = mainContent

local infJumpConn

infJumpBtn.MouseButton1Click:Connect(function()
    local enabled = infJumpBtn.Text:find("ON")
    infJumpBtn.Text = "Infinite Jump: " .. (enabled and "OFF" or "ON")
    if not enabled then
        infJumpConn = UserInputService.JumpRequest:Connect(function()
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    else
        if infJumpConn then infJumpConn:Disconnect() end
    end
end)

-- God Mode (basic, set health high)
local godBtn = Instance.new("TextButton")
godBtn.Size = UDim2.new(1, -20, 0, 40)
godBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
godBtn.Text = "God Mode: OFF"
godBtn.TextColor3 = Color3.new(1,1,1)
godBtn.Font = Enum.Font.Gotham
godBtn.Parent = mainContent

godBtn.MouseButton1Click:Connect(function()
    local enabled = godBtn.Text:find("ON")
    godBtn.Text = "God Mode: " .. (enabled and "OFF" or "ON")
    if not enabled then
        player.Character.Humanoid.MaxHealth = math.huge
        player.Character.Humanoid.Health = math.huge
    else
        player.Character.Humanoid.MaxHealth = 100
        player.Character.Humanoid.Health = 100
    end
end)

-- Speed Hack (WalkSpeed)
local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(1, -20, 0, 40)
speedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
speedBtn.Text = "Super Speed: OFF"
speedBtn.TextColor3 = Color3.new(1,1,1)
speedBtn.Font = Enum.Font.Gotham
speedBtn.Parent = mainContent

local originalSpeed = 16
speedBtn.MouseButton1Click:Connect(function()
    local enabled = speedBtn.Text:find("ON")
    speedBtn.Text = "Super Speed: " .. (enabled and "OFF" or "ON")
    if not enabled then
        player.Character.Humanoid.WalkSpeed = 100
    else
        player.Character.Humanoid.WalkSpeed = originalSpeed
    end
end)

-- Settings Tab Content
local settingsContent = Instance.new("ScrollingFrame", tabFrame)
settingsContent.Size = UDim2.new(1, 0, 1, 0)
settingsContent.BackgroundTransparency = 1
settingsContent.ScrollBarThickness = 5
settingsContent.Visible = false

local settingsList = Instance.new("UIListLayout", settingsContent)
settingsList.Padding = UDim.new(0, 10)
settingsList.SortOrder = Enum.SortOrder.LayoutOrder

-- Fly Speed Slider (TextBox for simplicity)
local flySpeedLabel = Instance.new("TextLabel", settingsContent)
flySpeedLabel.Size = UDim2.new(1, -20, 0, 30)
flySpeedLabel.BackgroundTransparency = 1
flySpeedLabel.Text = "Fly Speed: 50"
flySpeedLabel.TextColor3 = Color3.new(1,1,1)
flySpeedLabel.Font = Enum.Font.Gotham

local flySpeedBox = Instance.new("TextBox", settingsContent)
flySpeedBox.Size = UDim2.new(1, -20, 0, 30)
flySpeedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
flySpeedBox.Text = "50"
flySpeedBox.TextColor3 = Color3.new(1,1,1)
flySpeedBox.Font = Enum.Font.Gotham
flySpeedBox.Changed:Connect(function(prop)
    if prop == "Text" then
        local num = tonumber(flySpeedBox.Text)
        if num then
            flySpeed = num
            flySpeedLabel.Text = "Fly Speed: " .. num
        end
    end
end)

-- Walk Speed Slider
local walkSpeedLabel = Instance.new("TextLabel", settingsContent)
walkSpeedLabel.Size = UDim2.new(1, -20, 0, 30)
walkSpeedLabel.BackgroundTransparency = 1
walkSpeedLabel.Text = "Walk Speed: 16"
walkSpeedLabel.TextColor3 = Color3.new(1,1,1)
walkSpeedLabel.Font = Enum.Font.Gotham

local walkSpeedBox = Instance.new("TextBox", settingsContent)
walkSpeedBox.Size = UDim2.new(1, -20, 0, 30)
walkSpeedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
walkSpeedBox.Text = "16"
walkSpeedBox.TextColor3 = Color3.new(1,1,1)
walkSpeedBox.Font = Enum.Font.Gotham
walkSpeedBox.Changed:Connect(function(prop)
    if prop == "Text" then
        local num = tonumber(walkSpeedBox.Text)
        if num then
            player.Character.Humanoid.WalkSpeed = num
            walkSpeedLabel.Text = "Walk Speed: " .. num
        end
    end
end)

-- Tab Switch
mainTabBtn.MouseButton1Click:Connect(function()
    mainContent.Visible = true
    settingsContent.Visible = false
    mainTabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    settingsTabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
end)

settingsTabBtn.MouseButton1Click:Connect(function()
    mainContent.Visible = false
    settingsContent.Visible = true
    settingsTabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    mainTabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
end)

-- Title & Close (giữ nguyên)
local title = Instance.new("TextLabel", mf)
title.Size = UDim2.new(1, -60, 0, 30)
title.Position = UDim2.new(0, 20, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Dark Transparent UI"
title.TextColor3 = Color3.fromRGB(240, 240, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBlack

local close = Instance.new("TextButton", mf)
close.Size = UDim2.new(0, 35, 0, 35)
close.Position = UDim2.new(1, -45, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(210, 40, 40)
close.Text = "✕"
close.TextColor3 = Color3.new(1,1,1)
close.TextScaled = true
close.Font = Enum.Font.GothamBold
close.ZIndex = 1200
close.Active = true
close.Parent = mf

local clCorner = Instance.new("UICorner", close)
clCorner.CornerRadius = UDim.new(0, 10)

close.MouseButton1Click:Connect(function()
    hideUI()
    task.delay(0.6, function()
        sg:Destroy()
    end)
end)

-- Hide / Show functions (giữ nguyên từ trước)
local animInfo = TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)

local function hideUI()
    if not isShowing then return end
    local iconAbsPos = icon.AbsolutePosition
    local iconAbsSize = icon.AbsoluteSize
    TweenService:Create(mf, animInfo, {
        Size = UDim2.new(0, iconAbsSize.X * 0.8, 0, iconAbsSize.Y * 0.8),
        Position = UDim2.new(0, iconAbsPos.X + iconAbsSize.X/2 - (iconAbsSize.X * 0.4), 0, iconAbsPos.Y + iconAbsSize.Y/2 - (iconAbsSize.Y * 0.4)),
        BackgroundTransparency = 1,
        Rotation = 15
    }):Play()
    task.delay(0.55, function()
        mf.Visible = false
        mf.Rotation = 0
    end)
    isShowing = false
end

local function showUI()
    if isShowing then return end
    mf.Visible = true
    mf.Rotation = 0
    mf.BackgroundTransparency = 1
    mf.Size = UDim2.new(0, 100, 0, 100)
    mf.Position = icon.Position
    TweenService:Create(mf, animInfo, {
        Size = UDim2.new(0.4, 0, 0.6, 0),
        Position = UDim2.new(icon.Position.X.Scale + 0.05, icon.Position.X.Offset + 60, icon.Position.Y.Scale + 0.05, icon.Position.Y.Offset + 60),
        BackgroundTransparency = 0.32
    }):Play()
    isShowing = true
end

local function toggleUI()
    if isShowing then hideUI() else showUI() end
end

icon.MouseButton1Click:Connect(toggleUI)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
        hideUI()
    elseif input.KeyCode == Enum.KeyCode.U then
        toggleUI()
    elseif input.KeyCode == Enum.KeyCode.C then
        sg:Destroy()
    end
end)

-- Auto show lần đầu
task.wait(0.3)
isShowing = true

print("UI + Features (Fly, Noclip, Inf Jump, God, Speed) + Settings loaded! Ctrl hide, U toggle.")
