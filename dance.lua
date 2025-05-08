local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local COLORS = {
	Color3.fromRGB(255, 0, 0),      
	Color3.fromRGB(255, 0, 255),    
	Color3.fromRGB(0, 0, 255),      
	Color3.fromRGB(0, 255, 255),    
	Color3.fromRGB(0, 255, 0),      
	Color3.fromRGB(255, 255, 0)     
}

local DANCE_ANIMATION_ID = "rbxassetid://27789359"
local TRAIL_EFFECT_SIZE = Vector3.new(3, 0.1, 3)

function setupDanceAnimation(character)
	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then return end

	local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator")
	animator.Parent = humanoid

	local animation = Instance.new("Animation")
	animation.AnimationId = DANCE_ANIMATION_ID

	local animTrack = animator:LoadAnimation(animation)
	animTrack:Play()
	animTrack.Looped = true
	animTrack:AdjustSpeed(1)

	return animTrack
end

function createFollowEffect(character)
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	local followEffectFolder = Instance.new("Folder")
	followEffectFolder.Name = "C00lkiddFollowEffect"
	followEffectFolder.Parent = character

	local mainPlate = Instance.new("Part")
	mainPlate.Name = "MainPlate"
	mainPlate.Size = TRAIL_EFFECT_SIZE
	mainPlate.Anchored = true
	mainPlate.CanCollide = false
	mainPlate.Material = Enum.Material.Neon
	mainPlate.BrickColor = BrickColor.new("Really black")
	mainPlate.Transparency = 0.2
	mainPlate.Parent = followEffectFolder

	local circle = Instance.new("Part")
	circle.Name = "CircleEffect"
	circle.Shape = Enum.PartType.Cylinder
	circle.Size = Vector3.new(0.1, 6, 6)
	circle.Anchored = true
	circle.CanCollide = false
	circle.Material = Enum.Material.Neon
	circle.BrickColor = BrickColor.new("Really red")
	circle.Transparency = 0.2
	circle.Parent = followEffectFolder

	local trailHistory = {}
	local maxTrailLength = 20

	RunService.Heartbeat:Connect(function()
		if not character.Parent then
			followEffectFolder:Destroy()
			return
		end

		local position = rootPart.Position - Vector3.new(0, 2.5, 0)
		local rotation = rootPart.CFrame - rootPart.CFrame.Position

		mainPlate.CFrame = CFrame.new(position) * rotation * CFrame.Angles(0, math.rad(tick() * 100), 0)

		circle.CFrame = CFrame.new(position) * CFrame.Angles(math.rad(90), math.rad(tick() * 50), 0)
		circle.Size = Vector3.new(0.1, 6 + math.sin(tick() * 5) * 1, 6 + math.sin(tick() * 5) * 1)

		table.insert(trailHistory, 1, position)

		if #trailHistory > maxTrailLength then
			table.remove(trailHistory)
		end

		for i, pos in ipairs(trailHistory) do
			local trailPart = followEffectFolder:FindFirstChild("Trail" .. i)
			if not trailPart then
				trailPart = Instance.new("Part")
				trailPart.Name = "Trail" .. i
				trailPart.Shape = Enum.PartType.Ball
				trailPart.Size = Vector3.new(1, 1, 1)
				trailPart.Anchored = true
				trailPart.CanCollide = false
				trailPart.Material = Enum.Material.Neon
				trailPart.Parent = followEffectFolder

				local pointLight = Instance.new("PointLight")
				pointLight.Range = 4
				pointLight.Brightness = 1
				pointLight.Parent = trailPart
			end

			local transparency = i / maxTrailLength
			local scale = 1 - (i / maxTrailLength) * 0.8

			trailPart.Size = Vector3.new(scale, scale, scale)
			trailPart.Position = pos
			trailPart.Transparency = transparency
			trailPart.Color = COLORS[(i % #COLORS) + 1]

			local pointLight = trailPart:FindFirstChildOfClass("PointLight")
			if pointLight then
				pointLight.Color = trailPart.Color
				pointLight.Brightness = 1 - transparency
			end
		end
	end)
end

function createCharacterEffects(character)
	local colorIndex = 1
	local bodyParts = {}

	for _, part in pairs(character:GetChildren()) do
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
			table.insert(bodyParts, part)
		end
	end

	RunService.Heartbeat:Connect(function()
		if not character.Parent then return end

		colorIndex = (colorIndex % #COLORS) + 1
		local currentColor = COLORS[colorIndex]

		for i, part in ipairs(bodyParts) do
			local partColorIndex = ((colorIndex + i) % #COLORS) + 1
			part.Color = COLORS[partColorIndex]

			if not part:FindFirstChildOfClass("PointLight") then
				local light = Instance.new("PointLight")
				light.Range = 4
				light.Brightness = 0.5
				light.Parent = part
			end

			local light = part:FindFirstChildOfClass("PointLight")
			light.Color = part.Color
		end
	end)

	local head = character:FindFirstChild("Head")
	if head then
		local face = head:FindFirstChild("face")
		if face then
			face.Texture = "rbxassetid://133163817"
		end

		local particleEmitter = Instance.new("ParticleEmitter")
		particleEmitter.Texture = "rbxassetid://133163817"
		particleEmitter.Size = NumberSequence.new(0.5)
		particleEmitter.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.5),
			NumberSequenceKeypoint.new(1, 1)
		})
		particleEmitter.Rate = 5
		particleEmitter.Speed = NumberRange.new(5, 10)
		particleEmitter.Lifetime = NumberRange.new(1, 2)
		particleEmitter.SpreadAngle = Vector2.new(180, 180)
		particleEmitter.Parent = head
	end

	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if rootPart then
		local particleEmitter = Instance.new("ParticleEmitter")
		particleEmitter.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, COLORS[1]),
			ColorSequenceKeypoint.new(0.2, COLORS[2]),
			ColorSequenceKeypoint.new(0.4, COLORS[3]),
			ColorSequenceKeypoint.new(0.6, COLORS[4]),
			ColorSequenceKeypoint.new(0.8, COLORS[5]),
			ColorSequenceKeypoint.new(1, COLORS[6])
		})
		particleEmitter.Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.5),
			NumberSequenceKeypoint.new(1, 0)
		})
		particleEmitter.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(1, 1)
		})
		particleEmitter.Rate = 50
		particleEmitter.Speed = NumberRange.new(2, 5)
		particleEmitter.Lifetime = NumberRange.new(0.5, 1)
		particleEmitter.Parent = rootPart
	end
end

function addScreenEffects(player)
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "C00lkiddEffects"
	screenGui.Parent = player.PlayerGui

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 0.2, 0)
	textLabel.Position = UDim2.new(0, 0, 0.8, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Font = Enum.Font.Highway
	textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
	textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	textLabel.TextStrokeTransparency = 0
	textLabel.TextSize = 48
	textLabel.Text = "DANCE MODE ACTIVATE"
	textLabel.Parent = screenGui

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundTransparency = 0.9
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BorderSizePixel = 0
	frame.ZIndex = -1
	frame.Parent = screenGui

	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size = UDim2.new(0.15, 0, 0.15, 0)
	imageLabel.Position = UDim2.new(0.425, 0, 0.1, 0)
	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = "rbxassetid://133163817"
	imageLabel.Parent = screenGui

	RunService.RenderStepped:Connect(function()
		textLabel.Rotation = math.sin(tick() * 2) * 5
		textLabel.TextColor3 = COLORS[math.floor(tick() * 5) % #COLORS + 1]
		imageLabel.Rotation = tick() * 50
		imageLabel.ImageColor3 = textLabel.TextColor3
	end)
end

function createC00lkiddSound(player)
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://142376088"
	sound.Volume = 0.5
	sound.Looped = true
	sound.Parent = player.Character.HumanoidRootPart
	sound:Play()

	local distortionEffect = Instance.new("DistortionSoundEffect")
	distortionEffect.Level = 0.5
	distortionEffect.Parent = sound

	local pitchShiftEffect = Instance.new("PitchShiftSoundEffect")
	pitchShiftEffect.Octave = 1.5
	pitchShiftEffect.Parent = sound

	return sound
end

function modifyLighting()
	local blur = Instance.new("BlurEffect")
	blur.Size = 2
	blur.Parent = Lighting

	local colorCorrection = Instance.new("ColorCorrectionEffect")
	colorCorrection.Contrast = 0.2
	colorCorrection.Saturation = 0.2
	colorCorrection.TintColor = Color3.fromRGB(255, 0, 0)
	colorCorrection.Parent = Lighting

	RunService.Heartbeat:Connect(function()
		colorCorrection.TintColor = COLORS[math.floor(tick() * 2) % #COLORS + 1]
	end)
end

function playerAdded(player)
	player.CharacterAdded:Connect(function(character)
		setupDanceAnimation(character)
		createFollowEffect(character)
		createCharacterEffects(character)
		addScreenEffects(player)
		createC00lkiddSound(player)
	end)

	if player.Character then
		setupDanceAnimation(player.Character)
		createFollowEffect(player.Character)
		createCharacterEffects(player.Character)
		addScreenEffects(player)
		createC00lkiddSound(player)
	end
end

modifyLighting()

for _, player in pairs(Players:GetPlayers()) do
	playerAdded(player)
end

Players.PlayerAdded:Connect(playerAdded)
