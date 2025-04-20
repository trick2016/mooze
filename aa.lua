-// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Notification Popup
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "MOOZE",
        Text = "MOOZE EXECUTED",
        Duration = 2
    })
end)

-- Visual Animation Label
local animGui = Instance.new("ScreenGui")
animGui.Name = "MoozeAnimGui"
animGui.ResetOnSpawn = false
animGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
animGui.Parent = game:GetService("CoreGui")

local animLabel = Instance.new("TextLabel")
animLabel.Parent = animGui
animLabel.AnchorPoint = Vector2.new(0.5, 0)
animLabel.Position = UDim2.new(0.5, 0, 0, 30)
animLabel.Size = UDim2.new(0, 300, 0, 50)
animLabel.BackgroundTransparency = 1
animLabel.Text = "@trick2016 on discord"
animLabel.TextColor3 = Color3.fromRGB(255, 100, 255)
animLabel.TextStrokeTransparency = 0.5
animLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
animLabel.Font = Enum.Font.GothamBlack
animLabel.TextSize = 36
animLabel.TextTransparency = 1

local tweenIn = TweenService:Create(animLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    TextTransparency = 0
})
local tweenOut = TweenService:Create(animLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
    TextTransparency = 1
})
tweenIn:Play()
tweenIn.Completed:Connect(function()
    task.wait(2)
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        animGui:Destroy()
    end)
end)

--// Settings
local SilentPrediction = {
    Enabled = false,
    PredictionScalar = 0.165,
    TargetPart = "HumanoidRootPart",
    LockedTarget = nil,
    FOVRadius = 12225,
    ShowFOV = true,
    FOVColor = Color3.fromRGB(255, 0, 0),
    FOVTransparency = 0.5,
    FOVThickness = 1,
    ToggleKey = Enum.KeyCode.Q,
    GuiKey = Enum.KeyCode.RightShift
}

getgenv().WalkSpeedValue = 500
local WalkSpeedEnabled = false

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Color = SilentPrediction.FOVColor
FOVCircle.Radius = SilentPrediction.FOVRadius
FOVCircle.Thickness = SilentPrediction.FOVThickness
FOVCircle.Transparency = SilentPrediction.FOVTransparency
FOVCircle.Filled = false

local TracerLine = Drawing.new("Line")
TracerLine.Visible = false
TracerLine.Thickness = 1.5
TracerLine.Transparency = 0.8
TracerLine.Color = Color3.fromRGB(255, 255, 255)

local function createStatusGui()
    local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    screenGui.Name = "SilentAimStatusGui"
    screenGui.ResetOnSpawn = false

    local frame = Instance.new("Frame", screenGui)
    frame.Name = "MainFrame"
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(1, -180, 0, 20)
    frame.Size = UDim2.new(0, 160, 0, 60)
    frame.Draggable = true
    frame.Active = true

    local statusLabel = Instance.new("TextLabel", frame)
    statusLabel.Name = "StatusLabel"
    statusLabel.BackgroundTransparency = 1
    statusLabel.Position = UDim2.new(0, 0, 0, 0)
    statusLabel.Size = UDim2.new(1, 0, 0.5, 0)
    statusLabel.Font = Enum.Font.SourceSansBold
    statusLabel.TextSize = 16
    statusLabel.TextColor3 = Color3.new(1, 1, 1)
    statusLabel.TextStrokeTransparency = 0
    statusLabel.Text = "Silent Aim"

    local wsLabel = Instance.new("TextLabel", frame)
    wsLabel.Name = "WalkSpeedLabel"
    wsLabel.BackgroundTransparency = 1
    wsLabel.Position = UDim2.new(0, 0, 0.5, 0)
    wsLabel.Size = UDim2.new(1, 0, 0.5, 0)
    wsLabel.Font = Enum.Font.SourceSansBold
    wsLabel.TextSize = 16
    wsLabel.TextColor3 = Color3.new(1, 1, 1)
    wsLabel.TextStrokeTransparency = 0
    wsLabel.Text = "WalkSpeed"

    return screenGui, frame, statusLabel, wsLabel
end

local screenGui, mainFrame, statusLabel, wsLabel = createStatusGui()
screenGui.Enabled = true

local hue = 0
RunService.RenderStepped:Connect(function()
    hue = (hue + 0.005) % 1
    local rainbow = Color3.fromHSV(hue, 1, 1)
    if statusLabel then statusLabel.TextColor3 = rainbow end
    if wsLabel then wsLabel.TextColor3 = rainbow end
end)

local function updateGuiStatus()
    statusLabel.Text = "Silent Aim"
    wsLabel.Text = "WalkSpeed"
end

local function enableWalkSpeed()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        local hum = char.Humanoid
        hum.WalkSpeed = getgenv().WalkSpeedValue
        hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if WalkSpeedEnabled then
                hum.WalkSpeed = getgenv().WalkSpeedValue
            end
        end)
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if WalkSpeedEnabled then
        enableWalkSpeed()
    end
end)

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == SilentPrediction.ToggleKey then
        SilentPrediction.Enabled = not SilentPrediction.Enabled
        updateGuiStatus()

    elseif input.KeyCode == SilentPrediction.GuiKey then
        screenGui.Enabled = not screenGui.Enabled

    elseif input.KeyCode == Enum.KeyCode.V then
        WalkSpeedEnabled = not WalkSpeedEnabled
        if WalkSpeedEnabled then
            enableWalkSpeed()
        elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
        updateGuiStatus()
    end
end)

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
    FOVCircle.Visible = SilentPrediction.ShowFOV and SilentPrediction.Enabled

    if SilentPrediction.Enabled and SilentPrediction.LockedTarget and SilentPrediction.LockedTarget.Character then
        local part = SilentPrediction.LockedTarget.Character:FindFirstChild(SilentPrediction.TargetPart)
        if part then
            local predictedPos = part.Position + part.Velocity * SilentPrediction.PredictionScalar
            local screenPos, onScreen = Camera:WorldToViewportPoint(predictedPos)

            if onScreen then
                TracerLine.Visible = true
                TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                TracerLine.To = Vector2.new(screenPos.X, screenPos.Y)
            else
                TracerLine.Visible = false
            end
        else
            TracerLine.Visible = false
        end
    else
        TracerLine.Visible = false
    end
end)

function SilentPrediction:GetClosestPlayer()
    local closest, shortest = nil, SilentPrediction.FOVRadius
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(self.TargetPart) then
            local part = player.Character[self.TargetPart]
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = player
                end
            end
        end
    end
    return closest
end

local function PredictHit(part, scalar)
    scalar = math.clamp(scalar or 0.165, 0.01, 1)
    return part.Position + (part.Velocity * scalar)
end

RunService.RenderStepped:Connect(function()
    if SilentPrediction.Enabled then
        SilentPrediction.LockedTarget = SilentPrediction:GetClosestPlayer()
    else
        SilentPrediction.LockedTarget = nil
    end
end)

local OriginalIndex
OriginalIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
    if not checkcaller() and SilentPrediction.Enabled and typeof(self) == "Instance" and self:IsA("Mouse") and key == "Hit" then
        local target = SilentPrediction.LockedTarget
        if target and target.Character then
            local part = target.Character:FindFirstChild(SilentPrediction.TargetPart)
            if part then
                return CFrame.new(PredictHit(part, SilentPrediction.PredictionScalar))
            end
        end
    end
    return OriginalIndex(self, key)
end))

updateGuiStatus()
