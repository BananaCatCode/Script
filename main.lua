-- Dark Transparent UI - Fix Hide/Show Bug + Icon Top Right + Square UI + Rainbow Border
-- Icon mặc định góc trên phải, border vuông ăn khớp, rainbow xoay rõ

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

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

-- ICON TOGGLE (góc trên phải mặc định)
local toggleIcon = Instance.new("TextButton")
toggleIcon.Name = "ToggleIcon"
toggleIcon.Size = UDim2.new(0, 50, 0, 50)
toggleIcon.Position = UDim2.new(1, -60, 0, 60)  -- Góc trên phải
toggleIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
toggleIcon.Text = "⋮⋮⋮"
toggleIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleIcon.TextScaled = true
toggleIcon.Font = Enum.Font.GothamBold
toggleIcon.Active = true
toggleIcon.ZIndex = 999
toggleIcon.Parent = screenGui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 0)  -- Vuông để khớp UI
iconCorner.Parent = toggleIcon

local iconStroke = Instance.new("UIStroke")
iconStroke.Color = Color3.new(1,1,1)
iconStroke.Thickness = 3
iconStroke.Transparency = 0
iconStroke.Parent = toggleIcon

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

-- MAIN FRAME (vuông, không bo góc)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0.42, 0, 0.52, 0)
mainFrame.Position = UDim2.new(0.29, 0, 0.24, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 1  -- Ẩn ban đầu
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ZIndex = 100
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 0)  -- Vuông hoàn toàn
mainCorner.Parent = mainFrame

-- Rainbow border (ăn khớp vuông)
local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 4
mainStroke.Transparency = 0
mainStroke.Color = Color3.new(1,1,1)
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.LineJoinMode = Enum.LineJoinMode.Miter  -- Vuông cạnh
mainStroke.Parent = mainFrame

local rainbowGradient = Instance.new("UIGradient", mainStroke)
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

-- Xoay rainbow mượt
RunService.RenderStepped:Connect(function(delta)
    rainbowGradient.Rotation = (rainbowGradient.Rotation + delta * 60) % 360  -- Tăng tốc để rõ hơn
    iconGradient.Rotation = (iconGradient.Rotation + delta * 60) % 360
end)

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 20))
}
gradient.Rotation = 90
gradient.Parent = mainFrame

-- Title (fix chèn)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0.12, 0)
title.Position = UDim2.new(0, 10, 0, 5)  -- Cao hơn
title.BackgroundTransparency = 1
title.Text = "Dark Transparent UI"
title.TextColor3 = Color3.fromRGB(220, 220, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.TextStrokeTransparency = 0.7
title.TextStrokeColor3 = Color3.new(0,0,0)
title.ZIndex = 110
title.Parent = mainFrame

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -50, 0, 5)  -- Cao hơn
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Active = true
closeBtn.ZIndex = 200
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 0)  -- Vuông
closeCorner.Parent = closeBtn

-- Hover close
local hoverInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart)
closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, hoverInfo, {BackgroundColor3 = Color3.fromRGB(255, 80, 80), Size = UDim2.new(0, 45, 0, 45)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, hoverInfo, {BackgroundColor3 = Color3.fromRGB(200, 50, 50), Size = UDim2.new(0, 40, 0, 40)}):Play()
end)

-- Content
local content = Instance.new("TextLabel")
content.Size = UDim2.new(1, -40, 0.7, -70)
content.Position = UDim2.new(0, 20, 0, 60)  -- Dưới title
content.BackgroundTransparency = 1
content.Text = "UI Dark theme + transparent\n\n• Icon ⋮⋮⋮ góc trên phải để toggle\n• Kéo thả main frame\n• Nhấn X để đóng\n• Phím U toggle\n• Đã fix bug hide/show & border vuông"
content.TextColor3 = Color3.fromRGB(200, 200, 220)
content.TextSize = 18
content.Font = Enum.Font.Gotham
content.TextWrapped = true
content.TextYAlignment = Enum.TextYAlignment.Top
content.ZIndex = 105
content.Parent = mainFrame

-- Tween info
local fadeInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- Trạng thái + lưu vị trí gốc
local isVisible = false
local originalMainPos = mainFrame.Position  -- Lưu vị trí gốc

-- Toggle function
local function toggleUI()
    if isVisible then
        -- Hide: Thu vào icon + fade
        originalMainPos = mainFrame.Position  -- Lưu trước hide
        local iconAbsPos = toggleIcon.AbsolutePosition
        local iconAbsSize = toggleIcon.AbsoluteSize
        TweenService:Create(mainFrame, fadeInfo, {
            Size = UDim2.new(0, iconAbsSize.X * 0.8, 0, iconAbsSize.Y * 0.8),
            Position = UDim2.new(0, iconAbsPos.X + iconAbsSize.X/2 - iconAbsSize.X*0.4, 0, iconAbsPos.Y + iconAbsSize.Y/2 - iconAbsSize.Y*0.4),
            BackgroundTransparency = 1
        }):Play()
        task.delay(0.6, function()
            mainFrame.Visible = false
        end)
    else
        -- Show: Expand từ icon, restore vị trí gốc
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 100, 0, 100)
        mainFrame.Position = toggleIcon.Position
        mainFrame.BackgroundTransparency = 1
        TweenService:Create(mainFrame, fadeInfo, {
            Size = UDim2.new(0.42, 0, 0.52, 0),
            Position = originalMainPos,  -- Restore vị trí trước hide
            BackgroundTransparency = 0.08
        }):Play()
    end
    isVisible = not isVisible
end

toggleIcon.MouseButton1Click:Connect(toggleUI)

-- Close
closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, fadeInfo, {BackgroundTransparency = 1}):Play()
    task.delay(0.6, function()
        screenGui:Destroy()
    end)
end)

-- Phím U toggle, C destroy
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.U then
        toggleUI()
    elseif input.KeyCode == Enum.KeyCode.C then
        screenGui:Destroy()
    end
end)

-- Hover icon (giữ nguyên)
toggleIcon.MouseEnter:Connect(function()
    TweenService:Create(toggleIcon, hoverInfo, {Size = UDim2.new(0, 55, 0, 55), BackgroundColor3 = Color3.fromRGB(50, 50, 60), TextColor3 = Color3.fromRGB(0, 200, 255)}):Play()
end)
toggleIcon.MouseLeave:Connect(function()
    TweenService:Create(toggleIcon, hoverInfo, {Size = UDim2.new(0, 50, 0, 50), BackgroundColor3 = Color3.fromRGB(30, 30, 40), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)

print("UI fixed: Icon top right default, square border khớp, hide/show không bug thu góc, rainbow rõ ràng.")
