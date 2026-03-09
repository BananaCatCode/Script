-- Dark Transparent UI với Toggle Icon (⋮⋮⋮) - Execute trực tiếp hoặc loadstring
-- Icon nhỏ ở góc dưới phải: Click để show/hide main UI
-- Nút X: Đóng hoàn toàn (destroy)
-- Phím U: Toggle (fallback)
-- Đã fix cho Infinite Yield + Draggable main frame

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Xóa UI cũ
if playerGui:FindFirstChild("DarkTransparentUI") then
    playerGui.DarkTransparentUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DarkTransparentUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- ICON TOGGLE (luôn visible, nhỏ gọn ở góc dưới phải)
local toggleIcon = Instance.new("TextButton")
toggleIcon.Name = "ToggleIcon"
toggleIcon.Size = UDim2.new(0, 50, 0, 50)
toggleIcon.Position = UDim2.new(1, -60, 1, -60)
toggleIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
toggleIcon.Text = "⋮⋮⋮"  -- Icon đặc trưng (menu dots)
toggleIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleIcon.TextScaled = true
toggleIcon.Font = Enum.Font.GothamBold
toggleIcon.Active = true
toggleIcon.ZIndex = 999  -- Cao nhất
toggleIcon.Parent = screenGui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 12)
iconCorner.Parent = toggleIcon

local iconStroke = Instance.new("UIStroke")
iconStroke.Color = Color3.fromRGB(80, 80, 100)
iconStroke.Thickness = 2
iconStroke.Transparency = 0.5
iconStroke.Parent = toggleIcon

-- Hover cho icon
local hoverInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart)
toggleIcon.MouseEnter:Connect(function()
    TweenService:Create(toggleIcon, hoverInfo, {
        Size = UDim2.new(0, 55, 0, 55),
        BackgroundColor3 = Color3.fromRGB(50, 50, 60),
        TextColor3 = Color3.fromRGB(0, 200, 255)
    }):Play()
end)
toggleIcon.MouseLeave:Connect(function()
    TweenService:Create(toggleIcon, hoverInfo, {
        Size = UDim2.new(0, 50, 0, 50),
        BackgroundColor3 = Color3.fromRGB(30, 30, 40),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
end)

-- MAIN FRAME (bắt đầu ẩn)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0.42, 0, 0.52, 0)
mainFrame.Position = UDim2.new(0.29, 0, 0.24, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 1  -- Ẩn ban đầu
mainFrame.Active = true
mainFrame.Draggable = true  -- Kéo thả được!
mainFrame.ZIndex = 100
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(80, 80, 100)
mainStroke.Thickness = 2
mainStroke.Transparency = 0.3
mainStroke.Parent = mainFrame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 20))
}
gradient.Rotation = 90
gradient.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0.12, 0)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Dark Transparent UI"
title.TextColor3 = Color3.fromRGB(220, 220, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.TextStrokeTransparency = 0.7
title.TextStrokeColor3 = Color3.new(0,0,0)
title.ZIndex = 110
title.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -50, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Active = true
closeBtn.Selectable = true
closeBtn.ZIndex = 200
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeBtn

-- Hover cho close
closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, hoverInfo, {
        BackgroundColor3 = Color3.fromRGB(255, 80, 80),
        Size = UDim2.new(0, 45, 0, 45)
    }):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, hoverInfo, {
        BackgroundColor3 = Color3.fromRGB(200, 50, 50),
        Size = UDim2.new(0, 40, 0, 40)
    }):Play()
end)

local content = Instance.new("TextLabel")
content.Size = UDim2.new(1, -40, 0.7, -70)
content.Position = UDim2.new(0, 20, 0, 70)
content.BackgroundTransparency = 1
content.Text = "UI Dark theme + transparent\n\n• Icon ⋮⋮⋮ (góc dưới phải) để toggle show/hide\n• Kéo thả main frame được\n• Nhấn X để đóng hoàn toàn\n• Phím U để toggle\n\nĐã fix cho Infinite Yield!"
content.TextColor3 = Color3.fromRGB(200, 200, 220)
content.TextSize = 18
content.Font = Enum.Font.Gotham
content.TextWrapped = true
content.TextYAlignment = Enum.TextYAlignment.Top
content.ZIndex = 105
content.Parent = mainFrame

-- Tween info
local fadeInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- Trạng thái UI
local isVisible = false

-- Toggle function
local function toggleUI()
    if isVisible then
        -- Hide (fade out)
        TweenService:Create(mainFrame, fadeInfo, {BackgroundTransparency = 1}):Play()
    else
        -- Show (fade in)
        mainFrame.BackgroundTransparency = 1
        TweenService:Create(mainFrame, fadeInfo, {BackgroundTransparency = 0.08}):Play()
    end
    isVisible = not isVisible
end

-- Icon click: Toggle
toggleIcon.MouseButton1Click:Connect(toggleUI)

-- Close: Destroy toàn bộ
closeBtn.MouseButton1Click:Connect(function()
    print("Đóng hoàn toàn UI!")
    TweenService:Create(mainFrame, fadeInfo, {BackgroundTransparency = 1}):Play()
    wait(0.6)
    screenGui:Destroy()
end)

-- Phím U fallback toggle
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.U then
        toggleUI()
    end
end)

-- Phím C force destroy
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.C then
        screenGui:Destroy()
    end
end)

print("Dark UI với Toggle Icon ⋮⋮⋮ đã load! Click icon để mở, X để đóng vĩnh viễn.")
