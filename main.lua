-- Dark Transparent UI - Fixed & Improved Version
-- Bo góc mượt, viền rainbow, transparency đẹp, fly hoàn chỉnh, drag ổn định

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
--       ICON (góc trên phải)      --
------------------------------------
local icon = Instance.new("ImageButton")  -- Dùng ImageButton cho đẹp hơn TextButton
icon.Name = "IconToggle"
icon.Size = UDim2.new(0, 60, 0, 60)
icon.Position = UDim2.new(1, -80, 0, 40)
icon.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
icon.BackgroundTransparency = 0.35
icon.Image = "rbxassetid://7072718362"  -- icon 3 chấm (có thể thay)
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
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 180, 60)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(220, 255, 80)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(80, 255, 140)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(60, 220, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 80, 255))
}
iconGradient.Rotation = 45
iconGradient.Parent = iconStroke

------------------------------------
--        MAIN FRAME               --
------------------------------------
local mf = Instance.new("Frame")
mf.Name = "MainFrame"
mf.Size = UDim2.new(0.45, 0, 0.62, 0)
mf.Position = UDim2.new(0.275, 0, 0.19, 0)
mf.BackgroundColor3 = Color3.fromRGB(15, 15, 28)
mf.BackgroundTransparency = 0.38   -- transparency đẹp hơn
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
mfGradient.Color = iconGradient.Color  -- đồng bộ màu rainbow
mfGradient.Rotation = 90
mfGradient.Parent = mfStroke

-- Rainbow xoay mượt
local rainbowConn
rainbowConn = RunService.RenderStepped:Connect(function(dt)
    local rot = (mfGradient.Rotation + dt * 45) % 360
    mfGradient.Rotation = rot
    iconGradient.Rotation = rot
end)

-- Title bar (dùng để drag frame)
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

-- Close button
local close = Instance.new("TextButton", titleBar)
close.Size = UDim2.new(0, 36, 0, 36)
close.Position = UDim2.new(1, -46, 0.5, -18)
close.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
close.Text = "×"
close.TextColor3 = Color3.new(1,1,1)
close.TextSize = 28
close.Font = Enum.Font.GothamBold
close.ZIndex = 1200

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = close

close.MouseEnter:Connect(function()
    TweenService:Create(close, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 70, 70)}):Play()
end)
close.MouseLeave:Connect(function()
    TweenService:Create(close, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}):Play()
end)

------------------------------------
--        Tab Content              --
------------------------------------
local content = Instance.new("ScrollingFrame", mf)
content.Size = UDim2.new(1, -20, 1, -55)
content.Position = UDim2.new(0, 10, 0, 50)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 5
content.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 160)
content.CanvasSize = UDim2.new(0, 0, 0, 0)

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.FillDirection = Enum.FillDirection.Vertical

-- Auto update canvas size
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
end)

------------------------------------
--        FLY FUNCTION             --
------------------------------------
local flying = false
local flySpeed = 80
local ctrl = {forward = 0, backward = 0, left = 0, right = 0, up = 0, down = 0}
local lastCtrl = {forward = 0, backward = 0, left = 0, right = 0, up = 0, down = 0}
local flyKeys = {W = "forward", S = "backward", A = "left", D = "right", Space = "up", LeftControl = "down"}

local flyBtn = Instance.new("TextButton", content)
flyBtn.Size = UDim2.new(1, 0, 0, 48)
flyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
flyBtn.Text = "Fly (OFF)"
flyBtn.TextColor3 = Color3.new(1,1,1)
flyBtn.Font = Enum.Font.GothamSemibold
flyBtn.TextSize = 18

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 10)
flyCorner.Parent = flyBtn

local flyStroke = Instance.new("UIStroke")
flyStroke.Thickness = 1.5
flyStroke.Transparency = 0.6
flyStroke.Color = Color3.fromRGB(120, 120, 255)
flyStroke.Parent = flyBtn

local bg, bv, cam, flyStepped

local function startFly()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local hrp = char.HumanoidRootPart
    bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bv.Velocity = Vector3.new()

    bg = Instance.new("BodyGyro", hrp)
    bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bg.P = 15000
    bg.CFrame = hrp.CFrame

    cam = workspace.CurrentCamera

    flyStepped = RunService.RenderStepped:Connect(function()
        hrp.Velocity = Vector3.new()
        local moveDir = Vector3.new(ctrl.right - ctrl.left, ctrl.up - ctrl.down, ctrl.backward - ctrl.forward)
        local camLook = cam.CFrame.LookVector
        local camRight = cam.CFrame.RightVector

        local move = (camLook * moveDir.Z + camRight * moveDir.X + Vector3.new(0, moveDir.Y, 0)).Unit
        bv.Velocity = move * flySpeed * 10
        bg.CFrame = cam.CFrame
    end)
end

local function stopFly()
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end
    if flyStepped then flyStepped:Disconnect() flyStepped = nil end
end

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = "Fly (" .. (flying and "ON" or "OFF") .. ")"
