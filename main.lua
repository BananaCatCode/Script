-- Đây là một LocalScript Roblox hoàn chỉnh để tạo UI dark theme với hiệu ứng transparent (fade in/out mượt mà).
-- Đặt script này vào StarterPlayer > StarterPlayerScripts để nó chạy cho mỗi player.
-- UI sẽ tự động fade in khi script chạy, nhấn nút X để fade out và đóng.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DarkTransparentUI"
screenGui.ResetOnSpawn = false  -- Không reset khi respawn
screenGui.Parent = playerGui

-- Frame chính (nền dark, bắt đầu hoàn toàn transparent)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0.4, 0, 0.5, 0)
mainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 1  -- Bắt đầu transparent
mainFrame.Parent = screenGui

-- Bo góc cho frame
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

-- Stroke (đường viền mờ dark)
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(40, 40, 50)
mainStroke.Thickness = 2
mainStroke.Transparency = 0.5
mainStroke.Parent = mainFrame

-- Gradient cho nền (từ xám tối đến đen)
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 45)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 20, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))
}
gradient.Rotation = 135
gradient.Parent = mainFrame

-- Tiêu đề
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -20, 0.15, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Dark Transparent UI"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextStrokeTransparency = 0.8
titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.Parent = mainFrame

-- Nút đóng (góc trên phải)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0.08, 0, 0.08, 0)
closeButton.Position = UDim2.new(1, -15, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

local closeStroke = Instance.new("UIStroke")
closeStroke.Color = Color3.fromRGB(255, 100, 100)
closeStroke.Thickness = 1.5
closeStroke.Parent = closeButton

-- Hiệu ứng hover cho nút đóng
local hoverInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, hoverInfo, {Size = UDim2.new(0.09, 0, 0.09, 0)}):Play()
    TweenService:Create(closeButton, hoverInfo, {BackgroundColor3 = Color3.fromRGB(255, 70, 70)}):Play()
end)
closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, hoverInfo, {Size = UDim2.new(0.08, 0, 0.08, 0)}):Play()
    TweenService:Create(closeButton, hoverInfo, {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}):Play()
end)

-- Nội dung mẫu (có thể thêm button khác)
local contentLabel = Instance.new("TextLabel")
contentLabel.Name = "Content"
contentLabel.Size = UDim2.new(1, -40, 0.6, 0)
contentLabel.Position = UDim2.new(0, 20, 0, 80)
contentLabel.BackgroundTransparency = 1
contentLabel.Text = "Đây là UI dark theme với hiệu ứng transparent!\n\n- Nền tối với gradient.\n- Fade in/out mượt mà.\n- Hover effects.\n\nNhấn X để đóng."
contentLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
contentLabel.TextScaled = true
contentLabel.Font = Enum.Font.Gotham
contentLabel.TextWrapped = true
contentLabel.TextYAlignment = Enum.TextYAlignment.Top
contentLabel.Parent = mainFrame

-- Tween info cho fade
local fadeInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- Fade in tự động khi script chạy
local fadeInTween = TweenService:Create(mainFrame, fadeInfo, {
    BackgroundTransparency = 0.05,
    Size = UDim2.new(0.45, 0, 0.55, 0)  -- Scale nhẹ lên
})
fadeInTween:Play()

-- Xử lý nút đóng: Fade out rồi destroy
closeButton.MouseButton1Click:Connect(function()
    local fadeOutTween = TweenService:Create(mainFrame, fadeInfo, {
        BackgroundTransparency = 1,
        Size = UDim2.new(0.4, 0, 0.5, 0)  -- Scale nhẹ xuống
    })
    fadeOutTween:Play()
    fadeOutTween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end)

-- Tùy chọn: Mở/đóng bằng phím U (toggle)
local UserInputService = game:GetService("UserInputService")
local isOpen = true  -- Đã mở
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.U then
        if isOpen then
            -- Đóng
            closeButton.MouseButton1Click:Fire()
        else
            -- Mở lại (tạo mới hoặc reset, ở đây chỉ demo đóng)
            print("UI đã đóng, reload script để mở lại!")
        end
        isOpen = not isOpen
    end
end)

print("Dark Transparent UI đã được tạo! Nhấn X để đóng hoặc U để toggle (demo).")
