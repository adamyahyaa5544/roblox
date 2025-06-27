-- ROBLOX MENU TOGGLE SCRIPT
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- MENU CONFIGURATION
local menuVisible = false
local menuKey = Enum.KeyCode.RightShift
local menuFrame = nil

-- CREATE ESP/AIMBOT MENU
local function CreateMenu()
    -- Create main GUI container
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CheatMenu"
    screenGui.Parent = game.CoreGui
    screenGui.ResetOnSpawn = false

    -- Main menu frame
    menuFrame = Instance.new("Frame")
    menuFrame.Size = UDim2.new(0.2, 0, 0.3, 0)
    menuFrame.Position = UDim2.new(0.78, 0, 0.35, 0)
    menuFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    menuFrame.BorderSizePixel = 0
    menuFrame.Visible = false
    menuFrame.Parent = screenGui

    -- Title bar
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0.15, 0)
    title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    title.Text = "SEAMONE'S HACK MENU"
    title.TextColor3 = Color3.fromRGB(255, 50, 50)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.Parent = menuFrame

    -- ESP Toggle
    local espToggle = Instance.new("TextButton")
    espToggle.Size = UDim2.new(0.9, 0, 0.2, 0)
    espToggle.Position = UDim2.new(0.05, 0, 0.2, 0)
    espToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    espToggle.Text = "ESP: OFF"
    espToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
    espToggle.Name = "ESPToggle"
    espToggle.Parent = menuFrame

    -- Aimbot Toggle
    local aimbotToggle = Instance.new("TextButton")
    aimbotToggle.Size = UDim2.new(0.9, 0, 0.2, 0)
    aimbotToggle.Position = UDim2.new(0.05, 0, 0.45, 0)
    aimbotToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    aimbotToggle.Text = "AIMBOT: OFF"
    aimbotToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
    aimbotToggle.Name = "AimbotToggle"
    aimbotToggle.Parent = menuFrame

    -- Exit Button
    local exitBtn = Instance.new("TextButton")
    exitBtn.Size = UDim2.new(0.9, 0, 0.2, 0)
    exitBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
    exitBtn.BackgroundColor3 = Color3.fromRGB(80, 25, 25)
    exitBtn.Text = "CLOSE MENU"
    exitBtn.TextColor3 = Color3.new(1, 1, 1)
    exitBtn.Parent = menuFrame

    return screenGui, espToggle, aimbotToggle, exitBtn
end

-- TOGGLE MENU VISIBILITY
local function ToggleMenu()
    menuVisible = not menuVisible
    if menuFrame then
        menuFrame.Visible = menuVisible
    end
    
    -- Block game input when menu is open
    if menuVisible then
        UserInputService.MouseIconEnabled = false
    else
        UserInputService.MouseIconEnabled = true
    end
end

-- KEY BINDING
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == menuKey then
        ToggleMenu()
    end
end)

-- INITIALIZE
local screenGui, espBtn, aimbotBtn, exitBtn = CreateMenu()

-- BUTTON FUNCTIONALITY
espBtn.MouseButton1Click:Connect(function()
    espBtn.Text = espBtn.Text == "ESP: OFF" and "ESP: ON" or "ESP: OFF"
    -- Add ESP activation logic here
end)

aimbotBtn.MouseButton1Click:Connect(function()
    aimbotBtn.Text = aimbotBtn.Text == "AIMBOT: OFF" and "AIMBOT: ON" or "AIMBOT: OFF"
    -- Add aimbot activation logic here
end)

exitBtn.MouseButton1Click:Connect(function()
    ToggleMenu()
end)

-- MENU DRAGGING FUNCTIONALITY
local dragging = false
local dragStartPos = Vector2.new(0,0)
local menuStartPos = Vector2.new(0,0)

menuFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
        menuStartPos = Vector2.new(menuFrame.Position.X.Offset, menuFrame.Position.Y.Offset)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local dragDelta = Vector2.new(input.Position.X, input.Position.Y) - dragStartPos
        menuFrame.Position = UDim2.new(
            0, menuStartPos.X + dragDelta.X,
            0, menuStartPos.Y + dragDelta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
