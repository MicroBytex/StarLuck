if not game:IsLoaded() then game.Loaded:Wait() end
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local mono = Instance.new("Model")
mono.Name = "Monkey"

local function crearParte(nombre, forma, tamaño, color, posicion)
    local parte = Instance.new("Part")
    parte.Name = nombre
    parte.Shape = forma
    parte.Size = tamaño
    parte.BrickColor = BrickColor.new(color)
    parte.Anchored = false
    parte.CanCollide = true
    parte.Parent = mono
    parte.Position = posicion or Vector3.new(0, 0, 0)
    return parte
end

local cuerpo = crearParte("Cuerpo", Enum.PartType.Block, Vector3.new(2, 1.5, 1), "Brown")
local cabeza = crearParte("Cabeza", Enum.PartType.Ball, Vector3.new(1.5, 1.5, 1.5), "Light brown")
cabeza.Position = cuerpo.Position + Vector3.new(0, 1.2, 0)

-- Brazos y piernas
local brazoIzq = crearParte("BrazoIzq", Enum.PartType.Block, Vector3.new(0.5, 1.5, 0.5), "Light brown")
local brazoDer = crearParte("BrazoDer", Enum.PartType.Block, Vector3.new(0.5, 1.5, 0.5), "Light brown")
local piernaIzq = crearParte("PiernaIzq", Enum.PartType.Block, Vector3.new(0.6, 1.2, 0.6), "Brown")
local piernaDer = crearParte("PiernaDer", Enum.PartType.Block, Vector3.new(0.6, 1.2, 0.6), "Brown")

-- Cola (Cilindro)
local cola = crearParte("Cola", Enum.PartType.Cylinder, Vector3.new(0.3, 1.5, 0.3), "Brown")
cola.Orientation = Vector3.new(0, 0, 90)

-- Unir partes con Motor6D (simular articulaciones)
local function unirParte(parte1, parte2, offset)
    local union = Instance.new("Motor6D")
    union.Part0 = parte1
    union.Part1 = parte2
    union.C0 = offset or CFrame.new()
    union.Parent = parte1
end

unirParte(cuerpo, cabeza, CFrame.new(0, 0.8, 0))
unirParte(cuerpo, brazoIzq, CFrame.new(-1, 0.5, 0))
unirParte(cuerpo, brazoDer, CFrame.new(1, 0.5, 0))
unirParte(cuerpo, piernaIzq, CFrame.new(-0.5, -1, 0))
unirParte(cuerpo, piernaDer, CFrame.new(0.5, -1, 0))
unirParte(cuerpo, cola, CFrame.new(0, -0.5, -0.8) * CFrame.Angles(0, math.rad(90), 0))

-- Animaciones (simuladas con TweenService)
local ts = game:GetService("TweenService")
local estado = "idle"
local enHombro = false
local modoLoco = false

-- Función para animar brazos/piernas
function animarMono(animacion)
    if animacion == "walk" then
        ts:Create(brazoIzq, TweenInfo.new(0.3), {CFrame = brazoIzq.CFrame * CFrame.Angles(math.rad(30), 0, 0)}):Play()
        ts:Create(brazoDer, TweenInfo.new(0.3), {CFrame = brazoDer.CFrame * CFrame.Angles(math.rad(-30), 0, 0)}):Play()
    elseif animacion == "jump" then
        ts:Create(cuerpo, TweenInfo.new(0.2), {Position = cuerpo.Position + Vector3.new(0, 5, 0)}):Play()
    elseif animacion == "attack" then
        ts:Create(brazoDer, TweenInfo.new(0.1), {CFrame = brazoDer.CFrame * CFrame.new(0, 0, -1)}):Play()
    end
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.J then
        animarMono("jump")
    elseif input.KeyCode == Enum.KeyCode.R then
        animarMono("scratch")
    elseif input.KeyCode == Enum.KeyCode.G then
        animarMono("scream")
    end
end)

mono.Parent = workspace
while true do
    if not enHombro then
        local destino = character.HumanoidRootPart.Position + Vector3.new(2, 0, 0)
        ts:Create(cuerpo, TweenInfo.new(1), {Position = destino}):Play()
        animarMono("walk")
    end
    wait(0.5)
end
