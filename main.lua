-- Dark Transparent UI FIX - Transparent thật + Toggle Icon + Nút X nổi bật
-- Execute trong Infinite Yield hoặc executor

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

-- TOGGLE ICON (luôn ở góc dưới phải, click để show/hide)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(0, 48, 0, 48)
toggleBtn.Position = UDim2.new(1, -60, 1, -70)
toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
toggleBtn.Text = "⋮"  -- Icon đặc trưng (có thể đổi thành "⚙️" hoặc "≡")
toggleBtn.TextColor3 = Color3.fromRGB(180, 180, 255)
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.ZIndex = 1000
toggleBtn.Active = true
toggleBtn.Parent = sg

local tbCorner = Instance.new("UICorner", toggleBtn)
tbCorner.CornerRadius = UDim.new(1, 0)  -- tròn hoàn toàn

local tbStroke = Instance.new("UIStroke", toggleBtn)
tbStroke.Color = Color3.fromRGB(100, 100, 200)
tbStroke.Thickness = 2
tbStroke.Transparency = 0.4

-- Hover icon
toggleBtn.MouseEnter:Connect(function()
    TweenService:Create(toggleBtn, TweenInfo.new(0.25), {
        BackgroundColor3 = Color3.fromRGB(60, 60, 90),
        TextColor3 = Color3.fromRGB(220, 220, 255),
        Size = UDim2.new(0, 54, 0, 54)
    }):Play()
end)
toggleBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleBtn, TweenInfo.new(0.25), {
        BackgroundColor3 = Color3.fromRGB(35, 35, 45),
        TextColor3 = Color3.fromRGB(180, 180, 255),
        Size = UDim2.new(0, 48, 0, 48)
    }):Play()
end)

-- MAIN FRAME (bắt đầu ẩn, transparent thật)
local mf = Instance.new("Frame")
mf.Name = "Main"
mf.Size = UDim2.new(0.38, 0, 0.55, 0)
mf.Position = UDim2.new(0.31, 0, 0.225, 0)
mf.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
mf.BackgroundTransparency = 1  -- ẩn ban đầu
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

-- Close Button (đỏ nổi bật, ZIndex cao)
local close = Instance.new("TextButton", mf)
close.Name = "Close"
close.Size = UDim2.new(0, 45, 0, 45)
close.Position = UDim2.new(1, -55, 0, 10)
close.BackgroundColor3 = Color3.fromRGB(210, 40, 40)
close.Text = "X"
close.TextColor3 = Color3.new(1,1,1)
close.TextScaled = true
close.Font = Enum.Font.GothamBold
close.ZIndex = 1200
close.Active = true
close.Parent = mf

local clCorner = Instance.new("UICorner", close)
clCorner.CornerRadius = UDim.new(0, 12)

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

-- Content
local cont = Instance.new("TextLabel", mf)
cont.Size = UDim2.new(1, -40, 0.75, -80)
cont.Position = UDim2.new(0, 20, 0, 70)
cont.BackgroundTransparency = 1
cont.Text = "Đây là UI dark theme với hiệu ứng transparent thật sự!\n\n- Nền mờ gradient (nhìn xuyên game).\n- Fade in/out mượt.\n- Hover effects nổi bật.\n- Icon ⋮ góc dưới phải để toggle show/hide.\n- Kéo thả frame được.\n- Nhấn X để đóng vĩnh viễn.\n\nNhấn U để toggle nhanh."
cont.TextColor3 = Color3.fromRGB(210, 210, 230)
cont.TextSize = 19
cont.Font = Enum.Font.Gotham
cont.TextWrapped = true
cont.TextYAlignment = Enum.TextYAlignment.Top

-- Fade Tween
local fadeTween = TweenInfo.new(0.65, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- Trạng thái
local showing = false

local function toggle()
    if showing then
        TweenService:Create(mf, fadeTween, {BackgroundTransparency = 1}):Play()
    else
        mf.BackgroundTransparency = 1
        TweenService:Create(mf, fadeTween, {BackgroundTransparency = 0.32}):Play()  -- 0.32 = transparent đẹp, điều chỉnh nếu muốn mờ hơn
    end
    showing = not showing
end

-- Icon click toggle
toggleBtn.MouseButton1Click:Connect(toggle)

-- Close destroy
close.MouseButton1Click:Connect(function()
    TweenService:Create(mf, fadeTween, {BackgroundTransparency = 1}):Play()
    task.wait(0.7)
    sg:Destroy()
end)

-- Phím U toggle, C force close
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.U then
        toggle()
    elseif input.KeyCode == Enum.KeyCode.C then
        sg:Destroy()
    end
end)

-- Auto show lần đầu
toggle()  -- Mở UI ngay khi execute

print("Dark Transparent UI FIXED loaded! Icon ⋮ để toggle, X để đóng.")
