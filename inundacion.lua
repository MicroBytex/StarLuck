local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

local config = {
    donasPorSegundo = 3,
    tiempoTotal = 120,
    incrementoAguaPorSegundo = 0.05,
    alturaMaximaAgua = 50,
    rangoCaidaX = {-100, 100},
    rangoCaidaZ = {-100, 100}
}

local parteAgua = Instance.new("Part")
parteAgua.Name = "AguaCreciente"
parteAgua.Anchored = true
parteAgua.Size = Vector3.new(500, 1, 500)
parteAgua.Position = Vector3.new(0, 0, 0)
parteAgua.Color = Color3.fromRGB(0, 162, 255)
parteAgua.Transparency = 0.3
parteAgua.Material = Enum.Material.Water
parteAgua.CanCollide = false
parteAgua.Parent = Workspace

local function crearDona()
    local dona = Instance.new("Part")
    dona.Name = "Dona"
    dona.Shape = Enum.PartType.Cylinder
    dona.Size = Vector3.new(1, 1, 1)
    dona.Position = Vector3.new(
        math.random(config.rangoCaidaX[1], config.rangoCaidaX[2]),
        config.alturaMaximaAgua + 50,
        math.random(config.rangoCaidaZ[1], config.rangoCaidaZ[2])
    )
    dona.Anchored = false
    dona.CanCollide = true
    dona.Color = Color3.fromRGB(255, math.random(50, 150), math.random(50, 150))
    dona.Material = Enum.Material.Neon
    
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://9419831"
    mesh.TextureId = "rbxassetid://9419827"
    mesh.Scale = Vector3.new(1, 1, 1)a
    mesh.Parent = dona
    
    dona.Parent = Workspace
    
    game:GetService("Debris"):AddItem(dona, 30)
end

local tiempoTranscurrido = 0

while tiempoTranscurrido < config.tiempoTotal do
    for i = 1, config.donasPorSegundo do
        crearDona()
    end
    
    local alturaActual = math.min(tiempoTranscurrido * config.incrementoAguaPorSegundo, config.alturaMaximaAgua)
    parteAgua.Position = Vector3.new(0, alturaActual, 0)
    
    wait(1)
    tiempoTranscurrido = tiempoTranscurrido + 1
end

parteAgua.Position = Vector3.new(0, config.alturaMaximaAgua, 0)
