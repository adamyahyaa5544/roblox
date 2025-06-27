-- ROBLOX RIVALS CHEAT v2.1
-- Press RightShift to toggle menu - Fixed Activation
-- Full ESP/Aimbot functionality

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Teams = game:GetService("Teams")
local TweenService = game:GetService("TweenService")

-- Configuration
local ESP_COLOR = Color3.fromRGB(255, 50, 50)
local TEAM_CHECK = true
local AIMBOT_KEY = Enum.UserInputType.MouseButton2
local HEADSHOT_MODE = true
local AIM_SMOOTHNESS = 0.25
local MAX_DISTANCE = 1000
local ESP_ENABLED = true
local AIMBOT_ENABLED = true
local MENU_OPEN = false
local WALL_PENETRATION = true

-- ESP Storage
local ESPBoxes = {}
local ESPHealthBars = {}
local ESPNames = {}

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RivalsCheatUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Position = UDim2.new(0.5, -150, -0.3, -125)  -- Start off-screen
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "🔥 RIVALS CHEAT v2.1 🔥"
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(220, 220, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Text = "X"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = TitleBar

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -40)
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Create toggle buttons
local function createToggle(label, initialState, yPos, callback, color)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = ContentFrame
    
    local labelText = Instance.new("TextLabel")
    labelText.Text = label
    labelText.Size = UDim2.new(0.6, 0, 1, 0)
    labelText.Position = UDim2.new(0, 0, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.TextColor3 = Color3.fromRGB(220, 220, 240)
    labelText.Font = Enum.Font.Gotham
    labelText.TextSize = 14
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = frame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 50, 0, 24)
    toggleButton.Position = UDim2.new(1, -50, 0.5, -12)
    toggleButton.BackgroundColor3 = initialState and color or Color3.fromRGB(80, 80, 100)
    toggleButton.Text = initialState and "ON" or "OFF"
    toggleButton.TextColor3 = Color3.new(1, 1, 1)
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 14
    toggleButton.Parent = frame
    
    toggleButton.MouseButton1Click:Connect(function()
        local newState = not initialState
        initialState = newState
        toggleButton.Text = newState and "ON" or "OFF"
        toggleButton.BackgroundColor3 = newState and color or Color3.fromRGB(80, 80, 100)
        callback(newState)
    end)
end

-- Create color picker
local function createColorPicker(yPos)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = ContentFrame
    
    local labelText = Instance.new("TextLabel")
    labelText.Text = "ESP Color"
    labelText.Size = UDim2.new(0.4, 0, 1, 0)
    labelText.Position = UDim2.new(0, 0, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.TextColor3 = Color3.fromRGB(220, 220, 240)
    labelText.Font = Enum.Font.Gotham
    labelText.TextSize = 14
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = frame
    
    local colors = {
        {Name = "❤️", Color = Color3.new(1, 0, 0)},
        {Name = "💚", Color = Color3.new(0, 1, 0)},
        {Name = "💙", Color = Color3.new(0, 0.5, 1)},
        {Name = "💛", Color = Color3.new(1, 1, 0)},
        {Name = "💜", Color = Color3.new(0.7, 0, 1)}
    }
    
    for i, colorInfo in ipairs(colors) do
        local colorButton = Instance.new("TextButton")
        colorButton.Text = colorInfo.Name
        colorButton.Size = UDim2.new(0, 30, 0, 30)
        colorButton.Position = UDim2.new(0.4 + (i-1)*0.15, 0, 0, 0)
        colorButton.BackgroundColor3 = colorInfo.Color
        colorButton.TextColor3 = Color3.new(1, 1, 1)
        colorButton.Font = Enum.Font.GothamBold
        colorButton.TextSize = 14
        colorButton.Parent = frame
        
        colorButton.MouseButton1Click:Connect(function()
            ESP_COLOR = colorInfo.Color
        end)
    end
end

-- Initialize UI
createToggle("Aimbot", AIMBOT_ENABLED, 0, function(state)
    AIMBOT_ENABLED = state
end, Color3.fromRGB(220, 100, 100))

createToggle("Headshot", HEADSHOT_MODE, 30, function(state)
    HEADSHOT_MODE = state
end, Color3.fromRGB(100, 180, 220))

createToggle("Team Check", TEAM_CHECK, 60, function(state)
    TEAM_CHECK = state
end, Color3.fromRGB(100, 220, 140))

createToggle("Wall Pen", WALL_PENETRATION, 90, function(state)
    WALL_PENETRATION = state
end, Color3.fromRGB(220, 180, 80))

createToggle("ESP", ESP_ENABLED, 120, function(state)
    ESP_ENABLED = state
end, Color3.fromRGB(100, 220, 140))

createColorPicker(150)

-- Create ESP elements
local function createESP(player)
    if ESPBoxes[player] then return end
    
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = ESP_COLOR
    Box.Thickness = 2
    Box.Filled = false
    
    local HealthBarOutline = Drawing.new("Square")
    HealthBarOutline.Visible = false
    HealthBarOutline.Color = Color3.new(0, 0, 0)
    HealthBarOutline.Thickness = 1
    HealthBarOutline.Filled = true
    
    local HealthBar = Drawing.new("Square")
    HealthBar.Visible = false
    HealthBar.Color = Color3.new(0, 1, 0)
    HealthBar.Thickness = 1
    HealthBar.Filled = true
    
    local NameLabel = Drawing.new("Text")
    NameLabel.Visible = false
    NameLabel.Color = ESP_COLOR
    NameLabel.Size = 14
    NameLabel.Font = Drawing.Fonts.UI
    NameLabel.Outline = true
    
    ESPBoxes[player] = Box
    ESPHealthBars[player] = {Outline = HealthBarOutline, Fill = HealthBar}
    ESPNames[player] = NameLabel
end

-- Optimized ESP update
local function updateESP()
    if not ESP_ENABLED or MENU_OPEN then return end
    
    local localChar = LocalPlayer.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end
    
    for player, box in pairs(ESPBoxes) do
        local char = player.Character
        if char then
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChild("Humanoid")
            local head = char:FindFirstChild("Head")
            
            if rootPart and humanoid and humanoid.Health > 0 and head then
                -- Distance check
                local distance = (localRoot.Position - rootPart.Position).Magnitude
                if distance > MAX_DISTANCE then
                    box.Visible = false
                    ESPHealthBars[player].Outline.Visible = false
                    ESPHealthBars[player].Fill.Visible = false
                    ESPNames[player].Visible = false
                    goto continue
                end
                
                local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    local headPos = Camera:WorldToViewportPoint(head.Position)
                    local scale = math.max(10, (rootPos - headPos).Magnitude * 2)
                    
                    -- Update ESP Box
                    box.Size = Vector2.new(scale, scale * 1.8)
                    box.Position = Vector2.new(rootPos.X - scale/2, rootPos.Y - scale/2)
                    box.Visible = true
                    box.Color = ESP_COLOR
                    
                    -- Update Health Bar
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    local barWidth = 4
                    local barHeight = scale * 1.8 * healthPercent
                    local barX = rootPos.X - scale/2 - 8
                    local barY = rootPos.Y + scale/2 * 0.5 - barHeight
                    
                    local healthBar = ESPHealthBars[player]
                    healthBar.Outline.Visible = true
                    healthBar.Outline.Size = Vector2.new(barWidth + 2, scale * 1.8 + 2)
                    healthBar.Outline.Position = Vector2.new(barX - 1, barY - 1)
                    
                    healthBar.Fill.Visible = true
                    healthBar.Fill.Size = Vector2.new(barWidth, barHeight)
                    healthBar.Fill.Position = Vector2.new(barX, barY + (scale * 1.8 - barHeight))
                    
                    -- Health bar color
                    if healthPercent > 0.6 then
                        healthBar.Fill.Color = Color3.new(0, 1, 0)
                    elseif healthPercent > 0.3 then
                        healthBar.Fill.Color = Color3.new(1, 1, 0)
                    else
                        healthBar.Fill.Color = Color3.new(1, 0, 0)
                    end
                    
                    -- Update Name
                    local nameLabel = ESPNames[player]
                    nameLabel.Visible = true
                    nameLabel.Text = player.Name
                    nameLabel.Position = Vector2.new(rootPos.X, rootPos.Y - scale/2 - 20)
                    nameLabel.Color = ESP_COLOR
                else
                    box.Visible = false
                    healthBar.Outline.Visible = false
                    healthBar.Fill.Visible = false
                    nameLabel.Visible = false
                end
            else
                box.Visible = false
                ESPHealthBars[player].Outline.Visible = false
                ESPHealthBars[player].Fill.Visible = false
                ESPNames[player].Visible = false
            end
        else
            box.Visible = false
            ESPHealthBars[player].Outline.Visible = false
            ESPHealthBars[player].Fill.Visible = false
            ESPNames[player].Visible = false
        end
        
        ::continue::
    end
end

-- Wall penetration check
local function isVisible(targetPart)
    if not WALL_PENETRATION then return true end
    
    local origin = Camera.CFrame.Position
    local target = targetPart.Position
    local direction = (target - origin).Unit
    local ray = Ray.new(origin, direction * MAX_DISTANCE)
    
    local hit, position = workspace:FindPartOnRay(ray, LocalPlayer.Character)
    
    if hit then
        local model = hit:FindFirstAncestorOfClass("Model")
        return model == targetPart:FindFirstAncestorOfClass("Model")
    end
    
    return false
end

-- Fixed aimbot with wall penetration
local function smoothAim(target)
    if not target or not target.Character or MENU_OPEN then return end
    
    local targetPart = HEADSHOT_MODE and target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart")
    if not targetPart then return end
    
    -- Wall penetration check
    if not isVisible(targetPart) then return end
    
    -- Get target position in world space
    local targetPos = targetPart.Position
    
    -- Calculate direction to target
    local cameraPos = Camera.CFrame.Position
    local direction = (targetPos - cameraPos).Unit
    
    -- Create new CFrame looking at target
    local newCFrame = CFrame.new(cameraPos, cameraPos + direction)
    
    -- Apply smoothing
    Camera.CFrame = Camera.CFrame:Lerp(newCFrame, AIM_SMOOTHNESS)
end

-- Optimized target finding
local currentTarget = nil
local function findTarget()
    if not AIMBOT_ENABLED or MENU_OPEN then return nil end
    
    local closestPlayer = nil
    local closestDistance = math.huge
    local localChar = LocalPlayer.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
    
    if not localRoot then return nil end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- Team check
            if TEAM_CHECK then
                if Teams then
                    if player.Team == LocalPlayer.Team then
                        goto continue
                    end
                else
                    -- Fallback for games without teams
                    if player:GetAttribute("Team") == LocalPlayer:GetAttribute("Team") then
                        goto continue
                    end
                end
            end
            
            local char = player.Character
            local humanoid = char:FindFirstChild("Humanoid")
            local head = char:FindFirstChild("Head")
            
            if humanoid and humanoid.Health > 0 and head then
                -- Check distance
                local distance = (localRoot.Position - head.Position).Magnitude
                if distance > MAX_DISTANCE then goto continue end
                
                -- Wall penetration check
                if not isVisible(head) then goto continue end
                
                local screenPos = Camera:WorldToViewportPoint(head.Position)
                local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                local screenPoint = Vector2.new(screenPos.X, screenPos.Y)
                local screenDistance = (screenPoint - center).Magnitude
                
                if screenDistance < closestDistance then
                    closestDistance = screenDistance
                    closestPlayer = player
                end
            end
        end
        ::continue::
    end
    
    currentTarget = closestPlayer
    return closestPlayer
end

-- Connect UI Events
CloseButton.MouseButton1Click:Connect(function()
    MENU_OPEN = false
    MainFrame.Visible = false
    UserInputService.MouseIconEnabled = false
end)

-- Initialize ESP for existing players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

-- Player added event
Players.PlayerAdded:Connect(function(player)
    createESP(player)
end)

-- Player removed event
Players.PlayerRemoving:Connect(function(player)
    if ESPBoxes[player] then
        ESPBoxes[player]:Remove()
        ESPBoxes[player] = nil
    end
    
    if ESPHealthBars[player] then
        ESPHealthBars[player].Outline:Remove()
        ESPHealthBars[player].Fill:Remove()
        ESPHealthBars[player] = nil
    end
    
    if ESPNames[player] then
        ESPNames[player]:Remove()
        ESPNames[player] = nil
    end
end)

-- FIXED RIGHT SHIFT MENU ACTIVATION
local menuKey = Enum.KeyCode.RightShift
local debounce = false

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == menuKey and not debounce then
        debounce = true
        
        -- Toggle menu state
        MENU_OPEN = not MENU_OPEN
        
        -- Animate menu
        local targetPosition = MENU_OPEN and UDim2.new(0.5, -150, 0.5, -125) or UDim2.new(0.5, -150, -0.3, -125)
        local tween = TweenService:Create(
            MainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = targetPosition}
        )
        
        -- Show/hide menu with animation
        if not MainFrame.Visible then
            MainFrame.Visible = true
        end
        
        tween:Play()
        
        -- Control mouse visibility
        UserInputService.MouseIconEnabled = MENU_OPEN
        
        -- Reset debounce after animation
        task.delay(0.35, function()
            if not MENU_OPEN then
                MainFrame.Visible = false
            end
            debounce = false
        end)
    end
end)

-- Main game loop
RunService.RenderStepped:Connect(function()
    -- Update ESP
    updateESP()
    
    -- Update target
    local target = findTarget()
    
    -- Apply aimbot if needed
    if UserInputService:IsMouseButtonPressed(AIMBOT_KEY) and target then
        smoothAim(target)
    end
end)

-- Cleanup on script re-execution
local function cleanup()
    for player in pairs(ESPBoxes) do
        if ESPBoxes[player] then
            ESPBoxes[player]:Remove()
        end
        if ESPHealthBars[player] then
            ESPHealthBars[player].Outline:Remove()
            ESPHealthBars[player].Fill:Remove()
        end
        if ESPNames[player] then
            ESPNames[player]:Remove()
        end
    end
    
    ESPBoxes = {}
    ESPHealthBars = {}
    ESPNames = {}
    
    if ScreenGui then
        ScreenGui:Destroy()
    end
end

-- Re-initialize if script runs again
cleanup()
print("✅ RIVALS CHEAT LOADED! Press RightShift to toggle menu")
