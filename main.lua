-- Dark Transparent UI - Rainbow Border FIXED (hiển thị rõ + chuyển động mượt)
-- Border rainbow cầu vồng xoay, set Color trắng để gradient work

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

-- ICON
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
iconStroke.Color = Color3.new(1,1,1)  -- Bắt buộc trắng để gradient work
iconStroke.Parent = icon

local iconGradient = Instance.new("UIGradient", iconStroke)
iconGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 165, 0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(0, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
}
iconGradient.Rotation = 0

-- MAIN FRAME
local mf = Instance.new("Frame")
mf.Name = "MainFrame"
mf.Size = UDim2.new(0.38, 0, 0.55, 0)
mf.Position = UDim2.new(0.31, 0, 0.225, 0)
mf.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
mf.BackgroundTransparency = 0.32
mf.BorderSizePixel = 0
mf.Active = true
mf.Draggable = true
mf.ZIndex = 500
mf.Parent = sg

local mfCorner = Instance.new("UICorner", mf)
mfCorner.CornerRadius = UDim.new(0, 18)

-- Rainbow border FIXED
local rainbowStroke = Instance.new("UIStroke")
rainbowStroke.Name = "RainbowBorder"
rainbowStroke.Thickness = 4.5  -- Tăng dày để nổi bật
rainbowStroke.Transparency = 0  -- Không mờ
rainbowStroke.Color = Color3.new(1,1,1)  -- BẮT BUỘC set trắng để UIGradient hiển thị!
rainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
rainbowStroke.LineJoinMode = Enum.LineJoinMode.Round
rainbowStroke.Parent = mf

local rainbowGradient = Instance.new("UIGradient")
rainbowGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 165, 0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(0, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
}
rainbowGradient.Rotation = 0
rainbowGradient.Parent = rainbowStroke

-- Hiệu ứng xoay rainbow mượt (dùng RenderStepped)
local rotationSpeed = 45  -- Độ/giây, chỉnh nhỏ hơn nếu muốn chậm
RunService.RenderStepped:Connect(function(delta)
    rainbowGradient.Rotation = (rainbowGradient.Rotation + delta * rotationSpeed) % 360
    iconGradient.Rotation = (iconGradient.Rotation + delta * rotationSpeed) % 360  -- Đồng bộ icon
end)

-- Title, Close, Content (giữ nguyên)
local title = Instance.new("TextLabel", mf)
title.Size = UDim2.new(1, -60, 0.1, 0)
title.Position = UDim2.new(0, 20, 0, 15)
title.BackgroundTransparency = 1
title.Text = "Dark Transparent UI"
title.TextColor3 = Color3.fromRGB(240, 240, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.TextStrokeTransparency = 0.75

local close = Instance.new("TextButton", mf)
close.Size = UDim2.new(0, 45, 0, 45)
close.Position = UDim2.new(1, -55, 0, 10)
close.BackgroundColor3 = Color3.fromRGB(210, 40, 40)
close.Text = "✕"
close.TextColor3 = Color3.new(1,1,1)
close.TextScaled = true
close.Font = Enum.Font.GothamBold
close.ZIndex = 1200
close.Active = true

local clCorner = Instance.new("UICorner", close)
clCorner.CornerRadius = UDim.new(0, 12)

local cont = Instance.new("TextLabel", mf)
cont.Size = UDim2.new(1, -40, 0.75, -80)
cont.Position = UDim2.new(0, 20, 0, 70)
cont.BackgroundTransparency = 1
cont.Text = "Rainbow Border đã fix hiển thị rõ!\n\n• Border cầu vồng xoay mượt (đỏ-cam-vàng-xanh...).\n• Icon cũng có rainbow nhẹ.\n• Ctrl: Hide hẳn (thu vào icon).\n• Click icon: Toggle thu/expand.\n• U: Toggle | X: Đóng."
cont.TextColor3 = Color3.fromRGB(210, 210, 230)
cont.TextSize = 19
cont.Font = Enum.Font.Gotham
cont.TextWrapped = true
cont.TextYAlignment = Enum.TextYAlignment.Top

-- Anim functions (giữ nguyên từ trước)
local animInfo = TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
local isShowing = true

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
        Size = UDim2.new(0.38, 0, 0.55, 0),
        Position = UDim2.new(icon.Position.X.Scale + 0.05, icon.Position.X.Offset + 60, icon.Position.Y.Scale + 0.05, icon.Position.Y.Offset + 60),
        BackgroundTransparency = 0.32
    }):Play()
    isShowing = true
end

local function toggleUI()
    if isShowing then hideUI() else showUI() end
end

icon.MouseButton1Click:Connect(toggleUI)

icon.MouseEnter:Connect(function()
    TweenService:Create(icon, TweenInfo.new(0.2), {Size = UDim2.new(0, 52, 0, 52)}):Play()
end)
icon.MouseLeave:Connect(function()
    TweenService:Create(icon, TweenInfo.new(0.2), {Size = UDim2.new(0, 45, 0, 45)}):Play()
end)

close.MouseButton1Click:Connect(function()
    hideUI()
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

print("Rainbow Border FIXED! Execute lại để thấy viền cầu vồng xoay rõ ràng.")
