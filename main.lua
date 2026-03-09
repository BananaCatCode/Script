-- Dark Transparent UI - Fix Drag Icon + Transparent Restore + Infinite Yield-like Features
-- Icon góc trên phải, border vuông rainbow, hide/show không bug

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("DarkTransparentUI") then
    playerGui.DarkTransparentUI:Destroy()
end

local sg = Instance.new("ScreenGui")
sg.Name = "DarkTransparentUI"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = playerGui

-- ICON (draggable, góc trên phải mặc định)
local icon = Instance.new("TextButton")
icon.Name = "IconToggle"
icon.Size = UDim2.new(0, 50, 0, 50)
icon.Position = UDim2.new(1, -70, 0, 70)  -- Góc trên phải
icon.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
icon.Text = "⋮"
icon.TextColor3 = Color3.fromRGB(180, 180, 255)
icon.TextScaled = true
icon.Font = Enum.Font.GothamBold
icon.ZIndex = 2000  -- Cao nhất để drag dễ
icon.Active = true
icon.Draggable = true
icon.Parent = sg

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 0)
iconCorner.Parent = icon

local iconStroke = Instance.new("UIStroke")
iconStroke.Thickness = 3
iconStroke.Transparency = 0
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

-- MAIN FRAME (vuông)
local mf = Instance.new("Frame")
mf.Name = "MainFrame"
mf.Size = UDim2.new(0.42, 0, 0.55, 0)
mf.Position = UDim2.new(0.29, 0, 0.22, 0)
mf.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
mf.BackgroundTransparency = 0.32
mf.BorderSizePixel = 0
mf.Active = true
mf.Draggable = true
mf.ZIndex = 500
mf.Visible = false  -- Bắt đầu ẩn
mf.Parent = sg

local mfCorner = Instance.new("UICorner")
mfCorner.CornerRadius = UDim.new(0, 0)
mfCorner.Parent = mf

local rainbowStroke = Instance.new("UIStroke")
rainbowStroke.Thickness = 5
rainbowStroke.Transparency = 0
rainbowStroke.Color = Color3.new(1,1,1)
rainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
rainbowStroke.Parent = mf

local rainbowGradient = Instance.new("UIGradient", rainbowStroke)
rainbowGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,165,0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255,255,0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,0)),
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,255,255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(0,0,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,255))
}

RunService.RenderStepped:Connect(function(delta)
    rainbowGradient.Rotation = (rainbowGradient.Rotation + delta * 60) % 360
    iconGradient.Rotation = (iconGradient.Rotation + delta * 60) % 360
end)

-- Title
local title = Instance.new("TextLabel", mf)
title.Size = UDim2.new(1, -60, 0, 40)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Dark Transparent UI"
title.TextColor3 = Color3.fromRGB(240, 240, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBlack

-- Close
local close = Instance.new("TextButton", mf)
close.Size = UDim2.new(0, 40, 0, 40)
close.Position = UDim2.new(1, -50, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(210, 40, 40)
close.Text = "X"
close.TextColor3 = Color3.new(1,1,1)
close.TextScaled = true
close.Font = Enum.Font.GothamBold
close.ZIndex = 1200
close.Active = true

local clCorner = Instance.new("UICorner", close)
clCorner.CornerRadius = UDim.new(0, 0)

-- Tab Frame
local tabFrame = Instance.new("Frame", mf)
tabFrame.Size = UDim2.new(1, -20, 1, -60)
tabFrame.Position = UDim2.new(0, 10, 0, 50)
tabFrame.BackgroundTransparency = 1

-- Main Features Tab
local mainContent = Instance.new("ScrollingFrame", tabFrame)
mainContent.Size = UDim2.new(1, 0, 1, 0)
mainContent.BackgroundTransparency = 1
mainContent.ScrollBarThickness = 6
mainContent.Visible = true

local listLayout = Instance.new("UIListLayout", mainContent)
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Fly
local flyBtn = Instance.new("TextButton", mainContent)
flyBtn.Size = UDim2.new(1, -10, 0, 40)
flyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
flyBtn.Text = "Fly: OFF"
flyBtn.TextColor3 = Color3.new(1,1,1)
flyBtn.Font = Enum.Font.Gotham

local flySpeed = 60
local flying = false
local flyConn

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = "Fly: " .. (flying and "ON" or "OFF")
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if flying then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.new()

        local bg = Instance.new("BodyGyro", hrp)
        bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        bg.P = 1e5

        flyConn = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            local move = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
            bv.Velocity = move.Unit * flySpeed
            bg.CFrame = cam.CFrame
        end)
    else
        if flyConn then flyConn:Disconnect() end
        if hrp:FindFirstChild("BodyVelocity") then hrp.BodyVelocity:Destroy() end
        if hrp:FindFirstChild("BodyGyro") then hrp.BodyGyro:Destroy() end
    end
end)

-- Noclip
local noclipBtn = Instance.new("TextButton", mainContent)
noclipBtn.Size = UDim2.new(1, -10, 0, 40)
noclipBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
noclipBtn.Text = "Noclip: OFF"
noclipBtn.TextColor3 = Color3.new(1,1,1)
noclipBtn.Font = Enum.Font.Gotham

local noclipConn
noclipBtn.MouseButton1Click:Connect(function()
    local enabled = noclipBtn.Text:find("ON")
    noclipBtn.Text = "Noclip: " .. (enabled and "OFF" or "ON")
    if not enabled then
        noclipConn = RunService.Stepped:Connect(function()
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() end
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end
end)

-- Infinite Jump
local infJumpBtn = Instance.new("TextButton", mainContent)
infJumpBtn.Size = UDim2.new(1, -10, 0, 40)
infJumpBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
infJumpBtn.Text = "Infinite Jump: OFF"
infJumpBtn.TextColor3 = Color3.new(1,1,1)
infJumpBtn.Font = Enum.Font.Gotham

local infJumpConn
infJumpBtn.MouseButton1Click:Connect(function()
    local enabled = infJumpBtn.Text:find("ON")
    infJumpBtn.Text = "Infinite Jump: " .. (enabled and "OFF" or "ON")
    if not enabled then
        infJumpConn = UserInputService.JumpRequest:Connect(function()
            player.Character.Humanoid:ChangeState("Jumping")
        end)
    else
        if infJumpConn then infJumpConn:Disconnect() end
    end
end)

-- God Mode
local godBtn = Instance.new("TextButton", mainContent)
godBtn.Size = UDim2.new(1, -10, 0, 40)
godBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
godBtn.Text = "God Mode: OFF"
godBtn.TextColor3 = Color3.new(1,1,1)
godBtn.Font = Enum.Font.Gotham

godBtn.MouseButton1Click:Connect(function()
    local enabled = godBtn.Text:find("ON")
    godBtn.Text = "God Mode: " .. (enabled and "OFF" or "ON")
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then
        if not enabled then
            hum.MaxHealth = math.huge
            hum.Health = math.huge
        else
            hum.MaxHealth = 100
            hum.Health = 100
        end
    end
end)

-- Super Speed
local speedBtn = Instance.new("TextButton", mainContent)
speedBtn.Size = UDim2.new(1, -10, 0, 40)
speedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
speedBtn.Text = "Super Speed: OFF"
speedBtn.TextColor3 = Color3.new(1,1,1)
speedBtn.Font = Enum.Font.Gotham

local origSpeed = 16
speedBtn.MouseButton1Click:Connect(function()
    local enabled = speedBtn.Text:find("ON")
    speedBtn.Text = "Super Speed: " .. (enabled and "OFF" or "ON")
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = enabled and origSpeed or 80
    end
end)

-- Rejoin
local rejoinBtn = Instance.new("TextButton", mainContent)
rejoinBtn.Size = UDim2.new(1, -10, 0, 40)
rejoinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
rejoinBtn.Text = "Rejoin Server"
rejoinBtn.TextColor3 = Color3.new(1,1,1)
rejoinBtn.Font = Enum.Font.Gotham
rejoinBtn.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, player)
end)

-- Settings Tab (ví dụ đơn giản)
local settingsContent = Instance.new("ScrollingFrame", tabFrame)
settingsContent.Size = UDim2.new(1, 0, 1, 0)
settingsContent.BackgroundTransparency = 1
settingsContent.Visible = false

-- (Bạn có thể thêm slider/textbox cho flySpeed, walkSpeed ở đây như code cũ)

-- Tab Switch
local mainTabBtn = Instance.new("TextButton", mf)
mainTabBtn.Size = UDim2.new(0.5, -5, 0, 35)
mainTabBtn.Position = UDim2.new(0, 5, 0, 45)
mainTabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
mainTabBtn.Text = "Main Features"
mainTabBtn.TextColor3 = Color3.new(1,1,1)
mainTabBtn.Font = Enum.Font.GothamBold

local settingsTabBtn = Instance.new("TextButton", mf)
settingsTabBtn.Size = UDim2.new(0.5, -5, 0, 35)
settingsTabBtn.Position = UDim2.new(0.5, 0, 0, 45)
settingsTabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
settingsTabBtn.Text = "Settings"
settingsTabBtn.TextColor3 = Color3.new(1,1,1)
settingsTabBtn.Font = Enum.Font.GothamBold

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

-- Hide/Show logic (fix transparent + position)
local animInfo = TweenInfo.new(0.55, Enum.EasingStyle.Quint)
local isShowing = false
local originalPos = mf.Position
local originalSize = mf.Size

local function hideUI()
    if not isShowing then return end
    originalPos = mf.Position
    originalSize = mf.Size
    local iconAbs = icon.AbsolutePosition
    local iconSize = icon.AbsoluteSize
    TweenService:Create(mf, animInfo, {
        Size = UDim2.new(0, iconSize.X*0.8, 0, iconSize.Y*0.8),
        Position = UDim2.new(0, iconAbs.X + iconSize.X*0.1, 0, iconAbs.Y + iconSize.Y*0.1),
        BackgroundTransparency = 1
    }):Play()
    task.delay(0.6, function()
        mf.Visible = false
    end)
    isShowing = false
end

local function showUI()
    if isShowing then return end
    mf.Visible = true
    mf.Position = icon.Position
    mf.Size = UDim2.new(0, 100, 0, 100)
    mf.BackgroundTransparency = 1
    TweenService:Create(mf, animInfo, {
        Size = originalSize,
        Position = originalPos,
        BackgroundTransparency = 0.32
    }):Play()
    isShowing = true
end

local function toggleUI()
    if isShowing then hideUI() else showUI() end
end

icon.MouseButton1Click:Connect(toggleUI)

close.MouseButton1Click:Connect(function()
    TweenService:Create(mf, animInfo, {BackgroundTransparency = 1}):Play()
    task.delay(0.6, function()
        sg:Destroy()
    end)
end)

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

-- Auto mở UI lần đầu
task.wait(0.5)
showUI()

print("Fixed: Icon drag work, transparent restore, square rainbow border, Infinite Yield features added.")
