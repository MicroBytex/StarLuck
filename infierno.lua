local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local FIRE_DENSITY = 50
local LINE_THICKNESS = 0.2
local LINE_COLOR = Color3.fromRGB(255, 0, 0)

function setupLighting()
    Lighting.Ambient = Color3.fromRGB(0, 0, 0)
    Lighting.Brightness = 0.2
    Lighting.ClockTime = 0
    Lighting.FogColor = Color3.fromRGB(0, 0, 0)
    Lighting.FogEnd = 200
    Lighting.FogStart = 50
    
    local atmosphere = Instance.new("Atmosphere")
    atmosphere.Density = 0.5
    atmosphere.Color = Color3.fromRGB(170, 0, 0)
    atmosphere.Decay = Color3.fromRGB(30, 0, 0)
    atmosphere.Glare = 0.5
    atmosphere.Haze = 1
    atmosphere.Parent = Lighting
    
    local bloomEffect = Instance.new("BloomEffect")
    bloomEffect.Intensity = 1
    bloomEffect.Size = 24
    bloomEffect.Threshold = 2
    bloomEffect.Parent = Lighting
    
    local colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.Brightness = 0.05
    colorCorrection.Contrast = 0.4
    colorCorrection.Saturation = 0.2
    colorCorrection.TintColor = Color3.fromRGB(255, 50, 50)
    colorCorrection.Parent = Lighting
end

function convertToRedLines()
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and not part:IsA("Terrain") then
            local originalSize = part.Size
            local originalCFrame = part.CFrame
            
            part.Transparency = 1
            
            for i = 1, 4 do
                local edge = Instance.new("Part")
                edge.Size = Vector3.new(originalSize.X, LINE_THICKNESS, LINE_THICKNESS)
                edge.CFrame = originalCFrame * CFrame.new(0, -originalSize.Y/2 + (i-1)*originalSize.Y/3, -originalSize.Z/2)
                edge.Anchored = true
                edge.CanCollide = false
                edge.Material = Enum.Material.Neon
                edge.BrickColor = BrickColor.new("Really red")
                edge.Parent = Workspace
                
                local edge2 = Instance.new("Part")
                edge2.Size = Vector3.new(originalSize.X, LINE_THICKNESS, LINE_THICKNESS)
                edge2.CFrame = originalCFrame * CFrame.new(0, -originalSize.Y/2 + (i-1)*originalSize.Y/3, originalSize.Z/2)
                edge2.Anchored = true
                edge2.CanCollide = false
                edge2.Material = Enum.Material.Neon
                edge2.BrickColor = BrickColor.new("Really red")
                edge2.Parent = Workspace
                
                local edge3 = Instance.new("Part")
                edge3.Size = Vector3.new(LINE_THICKNESS, LINE_THICKNESS, originalSize.Z)
                edge3.CFrame = originalCFrame * CFrame.new(-originalSize.X/2, -originalSize.Y/2 + (i-1)*originalSize.Y/3, 0)
                edge3.Anchored = true
                edge3.CanCollide = false
                edge3.Material = Enum.Material.Neon
                edge3.BrickColor = BrickColor.new("Really red")
                edge3.Parent = Workspace
                
                local edge4 = Instance.new("Part")
                edge4.Size = Vector3.new(LINE_THICKNESS, LINE_THICKNESS, originalSize.Z)
                edge4.CFrame = originalCFrame * CFrame.new(originalSize.X/2, -originalSize.Y/2 + (i-1)*originalSize.Y/3, 0)
                edge4.Anchored = true
                edge4.CanCollide = false
                edge4.Material = Enum.Material.Neon
                edge4.BrickColor = BrickColor.new("Really red")
                edge4.Parent = Workspace
            end
        end
    end
end

function makeFloor()
    local existingFloor = Workspace:FindFirstChild("HorrorFloor")
    if existingFloor then
        existingFloor:Destroy()
    end
    
    local blackFloor = Instance.new("Part")
    blackFloor.Name = "HorrorFloor"
    blackFloor.Size = Vector3.new(1000, 1, 1000)
    blackFloor.Position = Vector3.new(0, -1, 0)
    blackFloor.Anchored = true
    blackFloor.Material = Enum.Material.SmoothPlastic
    blackFloor.BrickColor = BrickColor.new("Black")
    blackFloor.Parent = Workspace
    
    local redGrid = Instance.new("Texture")
    redGrid.Texture = "rbxassetid://6372755229"
    redGrid.StudsPerTileU = 20
    redGrid.StudsPerTileV = 20
    redGrid.Color3 = Color3.fromRGB(255, 0, 0)
    redGrid.Transparency = 0.7
    redGrid.Face = Enum.NormalId.Top
    redGrid.Parent = blackFloor
end

function addFire()
    for i = 1, FIRE_DENSITY do
        local posX = math.random(-400, 400)
        local posZ = math.random(-400, 400)
        
        local firePart = Instance.new("Part")
        firePart.Name = "FireEmitter"
        firePart.Size = Vector3.new(1, 1, 1)
        firePart.Position = Vector3.new(posX, 0, posZ)
        firePart.Anchored = true
        firePart.CanCollide = false
        firePart.Transparency = 1
        firePart.Parent = Workspace
        
        local fire = Instance.new("Fire")
        fire.Color = Color3.fromRGB(255, 0, 0)
        fire.SecondaryColor = Color3.fromRGB(0, 0, 0)
        fire.Heat = 25
        fire.Size = math.random(10, 20)
        fire.Parent = firePart
        
        local smoke = Instance.new("Smoke")
        smoke.Color = Color3.fromRGB(0, 0, 0)
        smoke.Size = 5
        smoke.RiseVelocity = 1
        smoke.Opacity = 0.5
        smoke.Parent = firePart
    end
end

function playerEffects(player)
    local character = player.Character or player.CharacterAdded:Wait()
    
    local head = character:FindFirstChild("Head")
    if head then
        local fire = Instance.new("Fire")
        fire.Color = Color3.fromRGB(255, 0, 0)
        fire.SecondaryColor = Color3.fromRGB(0, 0, 0)
        fire.Heat = 0
        fire.Size = 7
        fire.Parent = head
    end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator")
        animator.Parent = humanoid
        
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://507770453"
        local animTrack = animator:LoadAnimation(animation)
        animTrack:Play()
        animTrack:AdjustSpeed(0.5)
        animTrack.Looped = true
    end
end

function setupScarySound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://142376088"
    sound.Volume = 0.5
    sound.Looped = true
    sound.Parent = Workspace
    sound:Play()
    
    local distortionEffect = Instance.new("DistortionSoundEffect")
    distortionEffect.Level = 0.75
    distortionEffect.Parent = sound
    
    local echoEffect = Instance.new("EchoSoundEffect")
    echoEffect.Delay = 0.5
    echoEffect.Feedback = 0.5
    echoEffect.Parent = sound
    
    return sound
end

function addJumpscares()
    local jumpscareFolder = Instance.new("Folder")
    jumpscareFolder.Name = "Jumpscares"
    jumpscareFolder.Parent = Workspace
    
    for i = 1, 10 do
        local jumpPart = Instance.new("Part")
        jumpPart.Size = Vector3.new(1, 7, 1)
        jumpPart.Position = Vector3.new(math.random(-200, 200), 0, math.random(-200, 200))
        jumpPart.Anchored = true
        jumpPart.CanCollide = false
        jumpPart.Transparency = 1
        jumpPart.Parent = jumpscareFolder
        
        local decal = Instance.new("Decal")
        decal.Texture = "rbxassetid://142410803"
        decal.Face = Enum.NormalId.Front
        decal.Parent = jumpPart
        
        local proximityPrompt = Instance.new("ProximityPrompt")
        proximityPrompt.ObjectText = "???"
        proximityPrompt.ActionText = "???"
        proximityPrompt.KeyboardKeyCode = Enum.KeyCode.E
        proximityPrompt.HoldDuration = 0.5
        proximityPrompt.MaxActivationDistance = 10
        proximityPrompt.Parent = jumpPart
        
        proximityPrompt.Triggered:Connect(function(player)
            local screenGui = Instance.new("ScreenGui")
            screenGui.Parent = player.PlayerGui
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundTransparency = 0
            frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            frame.Parent = screenGui
            
            local imageLabel = Instance.new("ImageLabel")
            imageLabel.Size = UDim2.new(1, 0, 1, 0)
            imageLabel.BackgroundTransparency = 1
            imageLabel.Image = "rbxassetid://142410803"
            imageLabel.Parent = frame
            
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://142376088"
            sound.Volume = 1
            sound.Parent = screenGui
            sound:Play()
            
            task.delay(1, function()
                screenGui:Destroy()
            end)
        end)
    end
end

function addFloatingHeads()
    local headsFolder = Instance.new("Folder")
    headsFolder.Name = "FloatingHeads"
    headsFolder.Parent = Workspace
    
    for i = 1, 20 do
        local head = Instance.new("Part")
        head.Name = "FloatingHead"
        head.Size = Vector3.new(2, 2, 2)
        head.Position = Vector3.new(math.random(-300, 300), math.random(10, 50), math.random(-300, 300))
        head.Anchored = true
        head.CanCollide = false
        head.Material = Enum.Material.SmoothPlastic
        head.BrickColor = BrickColor.new("Really black")
        head.Shape = Enum.PartType.Ball
        head.Parent = headsFolder
        
        local face = Instance.new("Decal")
        face.Texture = "rbxassetid://142410803"
        face.Face = Enum.NormalId.Front
        face.Parent = head
        
        local fire = Instance.new("Fire")
        fire.Color = Color3.fromRGB(255, 0, 0)
        fire.SecondaryColor = Color3.fromRGB(0, 0, 0)
        fire.Heat = 0
        fire.Size = 5
        fire.Parent = head
        
        local pointLight = Instance.new("PointLight")
        pointLight.Color = Color3.fromRGB(255, 0, 0)
        pointLight.Range = 15
        pointLight.Brightness = 1
        pointLight.Parent = head
        
        spawn(function()
            local startPos = head.Position
            while true do
                head.Position = startPos + Vector3.new(
                    math.sin(tick() * 0.5) * 5,
                    math.sin(tick() * 0.7) * 3,
                    math.cos(tick() * 0.5) * 5
                )
                task.wait()
            end
        end)
    end
end

function createSky()
    local sky = Instance.new("Sky")
    sky.SkyboxBk = "rbxassetid://1012890"
    sky.SkyboxDn = "rbxassetid://1012891"
    sky.SkyboxFt = "rbxassetid://1012887"
    sky.SkyboxLf = "rbxassetid://1012889"
    sky.SkyboxRt = "rbxassetid://1012888"
    sky.SkyboxUp = "rbxassetid://1014449"
    sky.StarCount = 3000
    sky.SunAngularSize = 21
    sky.SunTextureId = "rbxassetid://1084351190"
    sky.Parent = Lighting
end

setupLighting()
convertToRedLines()
makeFloor()
addFire()
setupScarySound()
addJumpscares()
addFloatingHeads()
createSky()

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        playerEffects(player)
    end)
end)

for _, player in pairs(Players:GetPlayers()) do
    if player.Character then
        playerEffects(player)
    end
end

local messageGui = Instance.new("ScreenGui")
messageGui.Name = "ScaryMessage"
messageGui.Parent = game:GetService("StarterGui")

local messageFrame = Instance.new("Frame")
messageFrame.Size = UDim2.new(0.5, 0, 0.2, 0)
messageFrame.Position = UDim2.new(0.25, 0, 0.7, 0)
messageFrame.BackgroundTransparency = 0.5
messageFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
messageFrame.BorderSizePixel = 0
messageFrame.Parent = messageGui

local messageText = Instance.new("TextLabel")
messageText.Size = UDim2.new(1, 0, 1, 0)
messageText.BackgroundTransparency = 1
messageText.Font = Enum.Font.Creepster
messageText.TextColor3 = Color3.fromRGB(255, 0, 0)
messageText.TextSize = 50
messageText.Text = "NO ESCAPE"
messageText.Parent = messageFrame

spawn(function()
    while true do
        messageText.Rotation = math.sin(tick() * 2) * 5
        messageText.TextSize = 45 + math.sin(tick() * 3) * 5
        task.wait()
    end
end)
