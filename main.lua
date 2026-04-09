-- Dark Transparent UI - Fix Logic (UI Toggle, Fly, Speed)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Xóa GUI cũ nếu tồn tại
if playerGui:FindFirstChild("DarkTransparentUI") then
    playerGui.DarkTransparentUI:Destroy()
end

local sg = Instance.new("ScreenGui")
sg.Name = "DarkTransparentUI"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = playerGui

------------------------------------
--       ICON (Góc trên phải)     --
------------------------------------
local icon = Instance.new("ImageButton")
icon.Name = "IconToggle"
icon.Size = UDim2.new(0, 60, 0, 60)
icon.Position = UDim2.new(1, -80, 0, 40)
icon.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
icon.BackgroundTransparency = 0.35
icon.Image = "rbxassetid://7072718362"
icon.ImageColor3 = Color3.fromRGB(180, 180, 255)
icon.AutoButtonColor = false
icon.ZIndex = 2000
icon.Parent = sg

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 16)
iconCorner.Parent = icon

local iconStroke = Instance.new("UIStroke")
iconStroke.Thickness = 2.5
iconStroke.Transparency = 0.2
iconStroke.Color = Color3.new(1,1,1)
iconStroke.Parent = icon

local iconGradient = Instance.new("UIGradient")
iconGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 255, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 80, 255))
}
iconGradient.Parent = iconStroke

------------------------------------
--        MAIN FRAME              --
------------------------------------
local mf = Instance.new("Frame")
mf.Name = "MainFrame"
mf.Size = UDim2.new(0, 380, 0, 280) -- Cỡ khi đang ẩn
mf.Position = UDim2.new(0.5, -200, 0.5, -150)
mf.BackgroundColor3 = Color3.fromRGB(15, 15, 28)
mf.BackgroundTransparency = 1
mf.BorderSizePixel = 0
mf.ClipsDescendants = true
mf.ZIndex = 1000
mf.Visible = false 
mf.Parent = sg

local mfCorner = Instance.new("UICorner")
mfCorner.CornerRadius = UDim.new(0, 14)
mfCorner.Parent = mf

local mfStroke = Instance.new("UIStroke")
mfStroke.Thickness = 3
mfStroke.Transparency = 0.15
mfStroke.Color = Color3.new(1,1,1)
mfStroke.Parent = mf

local mfGradient = Instance.new("UIGradient")
mfGradient.Color = iconGradient.Color
mfGradient.Parent = mfStroke

-- Rainbow xoay mượt
RunService.RenderStepped:Connect(function(dt)
    local rot = (mfGradient.Rotation + dt * 45) % 360
    mfGradient.Rotation = rot
    iconGradient.Rotation = rot
end)

------------------------------------
--        TOGGLE UI LOGIC         --
------------------------------------
local isUIOpen = false

local function toggleUI()
    isUIOpen = not isUIOpen
    local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    if isUIOpen then
        mf.Visible = true
        TweenService:Create(mf, tweenInfo, {Size = UDim2.new(0, 400, 0, 300), BackgroundTransparency = 0.38}):Play()
    else
        local hideTween = TweenService:Create(mf, tweenInfo, {Size = UDim2.new(0, 380, 0, 280), BackgroundTransparency = 1})
        hideTween:Play()
        -- Chờ Tween xong mới ẩn hoàn toàn, tránh glitch
        hideTween.Completed:Once(function()
            if not isUIOpen then mf.Visible = false end
        end)
    end
end

icon.MouseButton1Click:Connect(toggleUI)

------------------------------------
--        TITLE BAR & DRAG        --
------------------------------------
local titleBar = Instance.new("Frame", mf)
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundTransparency = 1
titleBar.ZIndex = 1100

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Dark Transparent UI"
title.TextColor3 = Color3.fromRGB(235, 235, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamBlack
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", titleBar)
close.Size = UDim2.new(0, 36, 0, 36)
close.Position = UDim2.new(1, -46, 0.5, -18)
close.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
close.Text = "×"
close.TextColor3 = Color3.new(1,1,1)
close.TextSize = 28
close.Font = Enum.Font.GothamBold
close.ZIndex = 1200
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 10)

close.MouseEnter:Connect(function() TweenService:Create(close, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 70, 70)}):Play() end)
close.MouseLeave:Connect(function() TweenService:Create(close, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}):Play() end)
close.MouseButton1Click:Connect(toggleUI)

-- Kéo thả UI mượt
local dragging, dragInput, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mf.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mf.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

------------------------------------
--        TAB CONTENT             --
------------------------------------
local content = Instance.new("ScrollingFrame", mf)
content.Size = UDim2.new(1, -20, 1, -55)
content.Position = UDim2.new(0, 10, 0, 50)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 4
content.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 200)
content.BorderSizePixel = 0

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
end)

------------------------------------
--        LOGIC: SPEED            --
------------------------------------
local speedFrame = Instance.new("Frame", content)
speedFrame.Size = UDim2.new(1, -10, 0, 48)
speedFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
Instance.new("UICorner", speedFrame).CornerRadius = UDim.new(0, 8)
local sfStroke = Instance.new("UIStroke", speedFrame)
sfStroke.Color = Color3.fromRGB(255, 120, 120)

local speedLabel = Instance.new("TextLabel", speedFrame)
speedLabel.Size = UDim2.new(0.5, 0, 1, 0)
speedLabel.Position = UDim2.new(0, 15, 0, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Set Speed:"
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Font = Enum.Font.GothamSemibold
speedLabel.TextSize = 16
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedBox = Instance.new("TextBox", speedFrame)
speedBox.Size = UDim2.new(0.4, 0, 0.7, 0)
speedBox.Position = UDim2.new(0.55, 0, 0.15, 0)
speedBox.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 16
speedBox.Text = "16"
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 6)

local currentSpeed = 16

local function updateSpeed()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = currentSpeed
    end
end

speedBox.FocusLost:Connect(function()
    local newSpeed = tonumber(speedBox.Text)
    if newSpeed then
        currentSpeed = newSpeed
        updateSpeed()
    else
        speedBox.Text = tostring(currentSpeed)
    end
end)

-- Giữ nguyên speed nếu nhân vật chết và hồi sinh
player.CharacterAdded:Connect(function()
    task.wait(0.5) -- Đợi nhân vật load xong
    updateSpeed()
end)

------------------------------------
--        LOGIC: FLY              --
------------------------------------
local flying = false
local ctrl = {f = 0, b = 0, l = 0, r = 0, u = 0, d = 0}
local bg, bv, flyStepped

local flyBtn = Instance.new("TextButton", content)
flyBtn.Size = UDim2.new(1, -10, 0, 48)
flyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
flyBtn.Text = "Fly: OFF"
flyBtn.TextColor3 = Color3.new(1,1,1)
flyBtn.Font = Enum.Font.GothamSemibold
flyBtn.TextSize = 16
Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0, 8)
local flyBtnStroke = Instance.new("UIStroke", flyBtn)
flyBtnStroke.Color = Color3.fromRGB(120, 120, 255)

-- Nhận diện phím
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then ctrl.f = 1
    elseif input.KeyCode == Enum.KeyCode.S then ctrl.b = 1
    elseif input.KeyCode == Enum.KeyCode.A then ctrl.l = 1
    elseif input.KeyCode == Enum.KeyCode.D then ctrl.r = 1
    elseif input.KeyCode == Enum.KeyCode.Space then ctrl.u = 1
    elseif input.KeyCode == Enum.KeyCode.LeftControl then ctrl.d = 1 end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.W then ctrl.f = 0
    elseif input.KeyCode == Enum.KeyCode.S then ctrl.b = 0
    elseif input.KeyCode == Enum.KeyCode.A then ctrl.l = 0
    elseif input.KeyCode == Enum.KeyCode.D then ctrl.r = 0
    elseif input.KeyCode == Enum.KeyCode.Space then ctrl.u = 0
    elseif input.KeyCode == Enum.KeyCode.LeftControl then ctrl.d = 0 end
end)

local function stopFly()
    flying = false
    flyBtn.Text = "Fly: OFF"
    flyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end
    if flyStepped then flyStepped:Disconnect() flyStepped = nil end
    
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.PlatformStand = false
    end
end

local function startFly()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    flying = true
    flyBtn.Text = "Fly: ON"
    flyBtn.BackgroundColor3 = Color3.fromRGB(55, 120, 55)

    local hrp = char.HumanoidRootPart
    char.Humanoid.PlatformStand = true -- Tắt vật lý mặc định để ko bị rơi/vấp

    bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.new()

    bg = Instance.new("BodyGyro", hrp)
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.P = 9e4
    bg.CFrame = hrp.CFrame

    local cam = workspace.CurrentCamera

    flyStepped = RunService.RenderStepped:Connect(function()
        -- Tính toán hướng bay tuyệt đối theo Camera
        local moveDir = Vector3.new()
        if ctrl.f > 0 then moveDir = moveDir + cam.CFrame.LookVector end
        if ctrl.b > 0 then moveDir = moveDir - cam.CFrame.LookVector end
        if ctrl.r > 0 then moveDir = moveDir + cam.CFrame.RightVector end
        if ctrl.l > 0 then moveDir = moveDir - cam.CFrame.RightVector end
        if ctrl.u > 0 then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if ctrl.d > 0 then moveDir = moveDir - Vector3.new(0, 1, 0) end

        if moveDir.Magnitude > 0 then
            bv.Velocity = moveDir.Unit * currentSpeed
        else
            bv.Velocity = Vector3.new(0, 0, 0)
        end
        
        bg.CFrame = cam.CFrame
    end)
end

flyBtn.MouseButton1Click:Connect(function()
    if flying then stopFly() else startFly() end
end)

-- Tắt Fly tự động khi chết
player.CharacterAdded:Connect(function()
    if flying then stopFly() end
end)
