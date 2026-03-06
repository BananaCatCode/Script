-- Cats Script V2

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CatsScript"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0,300,0,200)
Frame.Position = UDim2.new(0.5,-150,0.5,-100)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.BorderSizePixel = 0

local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundColor3 = Color3.fromRGB(40,40,40)
Title.Text = "Cats Script V2"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextScaled = true

-- Button 1
local Button1 = Instance.new("TextButton")
Button1.Parent = Frame
Button1.Size = UDim2.new(0.8,0,0,40)
Button1.Position = UDim2.new(0.1,0,0.35,0)
Button1.Text = "Print Player Name"
Button1.BackgroundColor3 = Color3.fromRGB(60,60,60)
Button1.TextColor3 = Color3.new(1,1,1)

Button1.MouseButton1Click:Connect(function()
    print("Player:", LocalPlayer.Name)
end)

-- Button 2
local Button2 = Instance.new("TextButton")
Button2.Parent = Frame
Button2.Size = UDim2.new(0.8,0,0,40)
Button2.Position = UDim2.new(0.1,0,0.6,0)
Button2.Text = "ESP Players"
Button2.BackgroundColor3 = Color3.fromRGB(60,60,60)
Button2.TextColor3 = Color3.new(1,1,1)

Button2.MouseButton1Click:Connect(function()
    for _,v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local Billboard = Instance.new("BillboardGui")
            Billboard.Parent = v.Character.Head
            Billboard.Size = UDim2.new(0,100,0,40)
            Billboard.AlwaysOnTop = true
            
            local Text = Instance.new("TextLabel")
            Text.Parent = Billboard
            Text.Size = UDim2.new(1,0,1,0)
            Text.BackgroundTransparency = 1
            Text.Text = v.Name
            Text.TextColor3 = Color3.new(1,0,0)
            Text.TextScaled = true
        end
    end
end)

-- Drag UI
local UIS = game:GetService("UserInputService")
local dragging
local dragInput
local start
local startPos

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        start = input.Position
        startPos = Frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - start
        Frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
