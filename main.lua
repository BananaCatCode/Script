-- Dark Transparent UI - Icon Draggable + Hiệu ứng Thu Vào Icon + Phím Ctrl Toggle Hide
-- Icon ⋮: Draggable khắp màn hình, click để toggle (show/expand hoặc hide/thu UI vào icon)
-- Nút X: Đóng vĩnh viễn
-- Phím Ctrl (Left/Right): Toggle hide với hiệu ứng thu vào icon
-- Phím U: Giữ nguyên toggle đơn giản (fallback)
-- Transparent thật + Main frame draggable

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

-- ICON (draggable, đại diện, thay đổi theo trạng thái)
local icon = Instance.new("TextButton")
icon.Name = "IconToggle"
icon.Size = UDim2.new(0, 40, 0, 40)  -- Size mặc định (khi show)
icon.Position = UDim2.new(1, -55, 1, -60)
icon.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
icon.Text = "⋮"
icon.TextColor3 = Color3.fromRGB(180, 180, 255)
icon.TextScaled = true
icon.Font = Enum.Font.GothamBold
icon.ZIndex = 1500
icon.Active = true
icon.Draggable = true  -- Làm draggable, di chuyển khắp màn hình!
icon.Parent = sg

local iconCorner = Instance.new("UICorner", icon)
iconCorner.CornerRadius = UDim.new(1, 0)

local iconStroke = Instance.new("UIStroke", icon)
iconStroke.Color = Color3.fromRGB(100, 100, 200)
iconStroke.Thickness = 2
iconStroke.Transparency = 0.4

-- MAIN FRAME (transparent, draggable)
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

-- Nút X
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
close.Parent = mf

local clCorner = Instance.new("UICorner", close)
clCorner.CornerRadius = UDim.new(0, 12)

-- Content
local cont = Instance.new("TextLabel", mf)
cont.Size = UDim2.new(1, -40, 0.75, -80)
cont.Position = UDim2.new(0, 20, 0, 70)
cont.BackgroundTransparency = 1
cont.Text = "UI dark theme với transparent!\n\n• Icon ⋮ draggable khắp màn hình.\n• Click icon: Toggle với hiệu ứng thu/expand vào icon.\n• Phím Ctrl: Toggle hide (thu vào icon).\n• U: Toggle đơn giản.\n• Kéo icon/main frame được.\n• Nhấn X đóng hết."
cont.TextColor3 = Color3.fromRGB(210, 210, 230)
cont.TextSize = 19
cont.Font = Enum.Font.Gotham
cont.TextWrapped = true
cont.TextYAlignment = Enum.TextYAlignment.Top

-- Tween info
local animInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)

-- Trạng thái: true = show
local isShowing = true  -- Bắt đầu show

local function toggleHide(onlyHide)
    if isShowing or onlyHide then
        -- Thu UI vào icon: Scale nhỏ, di chuyển về vị trí icon, fade out
        local iconPos = icon.AbsolutePosition
        local iconSize = icon.AbsoluteSize
        TweenService:Create(mf, animInfo, {
            Size = UDim2.new(0, iconSize.X, 0, iconSize.Y),
            Position = UDim2.new(0, iconPos.X, 0, iconPos.Y),
            BackgroundTransparency = 1
        }):Play()
        -- Icon to (nổi bật khi UI thu vào)
        TweenService:Create(icon, animInfo, {
            Size = UDim2.new(0, 50, 0, 50),
            BackgroundColor3 = Color3.fromRGB(50, 50, 70),
            TextColor3 = Color3.fromRGB(220, 220, 255)
        }):Play()
        isShowing = false
    else
        -- Expand UI từ icon: Scale to, di chuyển về vị trí gốc, fade in
        mf.BackgroundTransparency = 1
        mf.Size = icon.Size
        mf.Position = icon.Position
        TweenService:Create(mf, animInfo, {
            Size = UDim2.new(0.38, 0, 0.55, 0),
            Position = UDim2.new(0.31, 0, 0.225, 0),  -- Vị trí gốc, hoặc chỉnh thành gần icon nếu muốn
            BackgroundTransparency = 0.32
        }):Play()
        -- Icon bé lại (khi UI expand)
        TweenService:Create(icon, animInfo, {
            Size = UDim2.new(0, 35, 0, 35),
            BackgroundColor3 = Color3.fromRGB(35, 35, 45),
            TextColor3 = Color3.fromRGB(180, 180, 255)
        }):Play()
        isShowing = true
    end
end

-- Click icon: Toggle với hiệu ứng thu/expand
icon.MouseButton1Click:Connect(function()
    toggleHide(false)
end)

-- Hover icon
icon.MouseEnter:Connect(function()
    local targetSize = isShowing and UDim2.new(0, 40, 0, 40) or UDim2.new(0, 55, 0, 55)
    TweenService:Create(icon, TweenInfo.new(0.2), {Size = targetSize}):Play()
end)
icon.MouseLeave:Connect(function()
    local targetSize = isShowing and UDim2.new(0, 35, 0, 35) or UDim2.new(0, 50, 0, 50)
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

-- Nút X: Thu vào rồi destroy
close.MouseButton1Click:Connect(function()
    toggleHide(true)  -- Thu vào trước
    task.wait(0.6)
    sg:Destroy()
end)

-- Phím Ctrl: Toggle hide với hiệu ứng thu vào icon
local ctrlPressed = false
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
        ctrlPressed = true
        toggleHide(true)  -- Chỉ hide với hiệu ứng thu
    elseif input.KeyCode == Enum.KeyCode.U then
        toggleHide(false)  -- Toggle đầy đủ
    elseif input.KeyCode == Enum.KeyCode.C then
        sg:Destroy()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
        ctrlPressed = false
    end
end)

print("Dark UI updated! Icon draggable, click/ctrl để thu/expand, U toggle, C close.")
