-- Dark Transparent UI - Icon Toggle Minimize (bé lại khi hide)
-- Icon ⋮ luôn visible góc dưới phải: Click toggle, show=to, hide=bé
-- Nút X: Đóng vĩnh viễn
-- Phím U toggle, C force close
-- Transparent thật + Draggable

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

-- Xóa UI cũ
if pg:FindFirstChild("DarkTransparentUI") then
    pg.DarkTransparentUI:Destroy()
end

local sg = Instance.new("ScreenGui")
sg.Name = "DarkTransparentUI"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = pg

-- ICON TOGGLE (đại diện UI, thay đổi size theo trạng thái)
local icon = Instance.new("TextButton")
icon.Name = "IconToggle"
icon.Size = UDim2.new(0, 35, 0, 35)  -- Bắt đầu bé (hide state)
icon.Position = UDim2.new(1, -50, 1, -55)
icon.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
icon.Text = "⋮"  -- Icon đặc trưng
icon.TextColor3 = Color3.fromRGB(180, 180, 255)
icon.TextScaled = true
icon.Font = Enum.Font.GothamBold
icon.ZIndex = 1500  -- Cao nhất
icon.Active = true
icon.Parent = sg

local iconCorner = Instance.new("UICorner", icon)
iconCorner.CornerRadius = UDim.new(1, 0)

local iconStroke = Instance.new("UIStroke", icon)
iconStroke.Color = Color3.fromRGB(100, 100, 200)
iconStroke.Thickness = 2
iconStroke.Transparency = 0.4

-- MAIN FRAME (transparent, bắt đầu ẩn)
local mf = Instance.new("Frame")
mf.Name = "MainFrame"
mf.Size = UDim2.new(0.38, 0, 0.55, 0)
mf.Position = UDim2.new(0.31, 0, 0.225, 0)
mf.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
mf.BackgroundTransparency = 1  -- Ẩn
mf.BorderSizePixel = 0
mf.Active = true
mf.Draggable = true
mf.ZIndex = 500
mf.Parent = sg

local mfCorner = Instance.new("UICorner", mf)
mfCorner.CornerRadius = UDim.new(0, 18)

local mfStroke = Instance.new("UIStroke", mf)
mfStroke.Color = Color3.fromRGB(90, 90, 140)
mfStroke.Thickness = 2.5
mfStroke.Transparency = 0.35

local grad = Instance.new("UIGradient", mf)
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 25))
}
grad.Rotation = 45

-- Title
local title = Instance.new("TextLabel", mf)
title.Size = UDim2.new(1, -60, 0.1, 0)
title.Position = UDim2.new(0, 20, 0, 15)
title.BackgroundTransparency = 1
title.Text = "Dark Transparent UI"
title.TextColor3 = Color3.fromRGB(240, 240, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.TextStrokeTransparency = 0.75

-- Nút X (đỏ nổi bật)
local close = Instance.new("TextButton", mf)
close.Name = "Close"
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

-- Content
local cont = Instance.new("TextLabel", mf)
cont.Size = UDim2.new(1, -40, 0.75, -80)
cont.Position = UDim2.new(0, 20, 0, 70)
cont.BackgroundTransparency = 1
cont.Text = "UI dark theme với transparent thật!\n\n• Icon ⋮ (góc dưới phải): Click toggle show/hide.\n  - Show: Icon to bình thường.\n  - Hide: Icon bé lại.\n• Kéo thả frame được.\n• Nhấn X đóng vĩnh viễn.\n• U: Toggle | C: Force close."
cont.TextColor3 = Color3.fromRGB(210, 210, 230)
cont.TextSize = 19
cont.Font = Enum.Font.Gotham
cont.TextWrapped = true
cont.TextYAlignment = Enum.TextYAlignment.Top

-- Tween info
local fadeInfo = TweenInfo.new(0.65, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local iconInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

-- Trạng thái: false = hide (icon bé)
local isShowing = false

local function toggleUI()
    if isShowing then
        -- Hide: Fade out main + icon bé lại
        TweenService:Create(mf, fadeInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(icon, iconInfo, {
            Size = UDim2.new(0, 35, 0, 35),
            BackgroundColor3 = Color3.fromRGB(35, 35, 45),
            TextColor3 = Color3.fromRGB(180, 180, 255)
        }):Play()
    else
        -- Show: Fade in main + icon to bình thường
        mf.BackgroundTransparency = 1
        TweenService:Create(mf, fadeInfo, {BackgroundTransparency = 0.32}):Play()
        TweenService:Create(icon, iconInfo, {
            Size = UDim2.new(0, 55, 0, 55),
            BackgroundColor3 = Color3.fromRGB(50, 50, 70),
            TextColor3 = Color3.fromRGB(220, 220, 255)
        }):Play()
    end
    isShowing = not isShowing
end

-- Icon click: Toggle
icon.MouseButton1Click:Connect(toggleUI)

-- Hover icon (thêm scale nhỏ)
icon.MouseEnter:Connect(function()
    local targetSize = isShowing and UDim2.new(0, 60, 0, 60) or UDim2.new(0, 40, 0, 40)
    TweenService:Create(icon, TweenInfo.new(0.2), {Size = targetSize}):Play()
end)
icon.MouseLeave:Connect(function()
    local targetSize = isShowing and UDim2.new(0, 55, 0, 55) or UDim2.new(0, 35, 0, 35)
    TweenService:Create(icon, TweenInfo.new(0.2), {Size = targetSize}):Play()
end)

-- Hover close
close.MouseEnter:Connect(function()
    TweenService:Create(close, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 60, 60),
        Size = UDim2.new(0, 50, 0, 50)
    }):Play()
end)
close.MouseLeave:Connect(function()
    TweenService:Create(close, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(210, 40, 40),
        Size = UDim2.new(0, 45, 0, 45)
    }):Play()
end)

-- Close vĩnh viễn
close.MouseButton1Click:Connect(function()
    TweenService:Create(mf, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(icon, iconInfo, {Size = UDim2.new(0, 0, 0, 0)}):Play()  -- Ẩn icon
    task.wait(0.7)
    sg:Destroy()
end)

-- Phím U toggle, C close
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.U then
        toggleUI()
    elseif input.KeyCode == Enum.KeyCode.C then
        sg:Destroy()
    end
end)

-- Auto show lần đầu (icon to, UI hiện)
task.wait(0.5)
toggleUI()

print("Dark UI + Icon Toggle (bé/to) loaded! Click ⋮ để test.")
