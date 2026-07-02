-- Auto Farm Script Muscle Legends com Rayfield UI

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Muscle Legends",
    LoadingTitle = "Muscle Legends",
    LoadingSubtitle = "by davix_script",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MuscleLegendsAutoFarm",
        FileName = "MainConfig"
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false,
})

local MainTab = Window:CreateTab("Main", 4483362458)
local StatsTab = Window:CreateTab("Stats", 4483362458)

-- Variáveis principais
local player = game.Players.LocalPlayer
local autoLiftEnabled = false
local autoPunchEnabled = false

-- Função para esperar character
local function waitForCharacter()
    if not player.Character then
        player.CharacterAdded:Wait()
    end
    repeat task.wait() until player.Character and player.Character:FindFirstChild("Humanoid")
    return player.Character
end

-- === AUTO LIFT (Weight) ===
local function setupAutoLift()
    local char = waitForCharacter()
    local muscleEvent = player:WaitForChild("muscleEvent")
    local repTimeObj = player.Backpack:WaitForChild("Weight"):WaitForChild("repTime")
    
    if repTimeObj then
        repTimeObj.Value = 0
    end
    
    local lastRep = 0
    
    local function lift()
        if not autoLiftEnabled then return end
        local char = player.Character
        if not char or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then return end
        
        -- Auto equip Weight
        local tool = char:FindFirstChild("Weight")
        if not tool then
            local weightTool = player.Backpack:FindFirstChild("Weight")
            if weightTool then
                weightTool.Parent = char
                task.wait(0.15)
            end
        end
        
        if tick() - lastRep >= (repTimeObj.Value or 0) then
            lastRep = tick()
            muscleEvent:FireServer("rep")
        end
    end
    
    task.spawn(function()
        while true do
            task.wait(0.03)
            lift()
        end
    end)
end

-- === AUTO PUNCH ===
local function setupAutoPunch()
    local char = waitForCharacter()
    local muscleEvent = player:WaitForChild("muscleEvent")
    local attackTimeObj = player.Backpack:WaitForChild("Punch"):WaitForChild("attackTime")
    
    if attackTimeObj then
        attackTimeObj.Value = 0
    end
    
    local lastPunch = 0
    
    local function punch()
        if not autoPunchEnabled then return end
        local char = player.Character
        if not char or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then return end
        
        -- Auto equip Punch
        local tool = char:FindFirstChild("Punch")
        if not tool then
            local punchTool = player.Backpack:FindFirstChild("Punch")
            if punchTool then
                punchTool.Parent = char
                task.wait(0.15)
            end
        end
        
        if tick() - lastPunch >= (attackTimeObj.Value or 0) then
            lastPunch = tick()
            muscleEvent:FireServer("punch", "rightHand")
        end
    end
    
    task.spawn(function()
        while true do
            task.wait(0.03)
            punch()
        end
    end)
end

-- UI Toggles
local autoLiftToggle = MainTab:CreateToggle({
    Name = "🔨 Auto Malhar (Weight)",
    CurrentValue = false,
    Flag = "AutoLiftFlag",
    Callback = function(Value)
        autoLiftEnabled = Value
        if Value then
            setupAutoLift()
            Rayfield:Notify({Title = "Auto Malhar", Content = "Ativado com sucesso!", Duration = 3})
        end
    end,
})

local autoPunchToggle = MainTab:CreateToggle({
    Name = "👊 Auto Punch",
    CurrentValue = false,
    Flag = "AutoPunchFlag",
    Callback = function(Value)
        autoPunchEnabled = Value
        if Value then
            setupAutoPunch()
            Rayfield:Notify({Title = "Auto Punch", Content = "Ativado com sucesso!", Duration = 3})
        end
    end,
})

-- Stats Tab
local agilityLabel = StatsTab:CreateLabel("Agility: Carregando...")
local durabilityLabel = StatsTab:CreateLabel("Durability: Carregando...")
local gemsLabel = StatsTab:CreateLabel("Gems: Carregando...")

task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            agilityLabel:Set("Agility: " .. (player:FindFirstChild("Agility") and player.Agility.Value or 0))
            durabilityLabel:Set("Durability: " .. (player:FindFirstChild("Durability") and player.Durability.Value or 0))
            gemsLabel:Set("Gems: " .. (player:FindFirstChild("Gems") and player.Gems.Value or 0))
        end)
    end
end)

-- Respawn Support
player.CharacterAdded:Connect(function()
    task.wait(1.5)
    if autoLiftEnabled then setupAutoLift() end
    if autoPunchEnabled then setupAutoPunch() end
end)

Rayfield:Notify({
    Title = "Muscle Legends",
    Content = "Script carregado por davix_script! Ative os autos.",
    Duration = 6,
})
