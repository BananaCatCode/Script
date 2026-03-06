print("Cats Script V5 Loaded")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "CatsScriptV5"

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0,500,0,320)
Frame.Position = UDim2.new(0.5,-250,0.5,-160)
Frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
Frame.BorderSizePixel = 0

-- Title
local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "🐱 Cats Script V5"
Title.TextColor3 = Color3.fromRGB(0,255,180)
Title.TextScaled = true

-- Drag UI
local dragging = false
local dragInput
local dragStart
local startPos

Title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position
	end
end)

Title.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging then
		local delta = input.Position - dragStart
		Frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- Tab container
local TabHolder = Instance.new("Frame")
TabHolder.Parent = Frame
TabHolder.Position = UDim2.new(0,0,0,40)
TabHolder.Size = UDim2.new(0,140,1,-40)
TabHolder.BackgroundColor3 = Color3.fromRGB(22,22,22)

local Main = Instance.new("Frame")
Main.Parent = Frame
Main.Position = UDim2.new(0,140,0,40)
Main.Size = UDim2.new(1,-140,1,-40)
Main.BackgroundTransparency = 1

-- Button creator
local function CreateButton(text,pos,callback)
	local btn = Instance.new("TextButton")
	btn.Parent = Main
	btn.Size = UDim2.new(0,220,0,36)
	btn.Position = UDim2.new(0,20,0,pos)
	btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
end

-- Notification
pcall(function()
	game.StarterGui:SetCore("SendNotification",{
		Title = "Cats Script V5",
		Text = "Loaded successfully",
		Duration = 5
	})
end)

-- Anti AFK
LocalPlayer.Idled:Connect(function()
	VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	task.wait(1)
	VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- Speed
CreateButton("Speed 120",10,function()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = 120
	end
end)

-- Jump
CreateButton("Jump 150",60,function()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.JumpPower = 150
	end
end)

-- Auto Haki
CreateButton("Auto Haki",110,function()
	pcall(function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
	end)
end)

-- Simple enemy teleport (example)
CreateButton("Teleport To Enemy",160,function()
	for _,enemy in pairs(workspace.Enemies:GetChildren()) do
		if enemy:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
			LocalPlayer.Character.HumanoidRootPart.CFrame =
				enemy.HumanoidRootPart.CFrame * CFrame.new(0,0,5)
			break
		end
	end
end)

-- Close button
local Close = Instance.new("TextButton")
Close.Parent = Frame
Close.Size = UDim2.new(0,30,0,30)
Close.Position = UDim2.new(1,-35,0,5)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(120,20,20)
Close.TextColor3 = Color3.new(1,1,1)

Close.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)
