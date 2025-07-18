--// 🚀 ENHANCED ULTRA FPS BOOSTER FOR MOBILE & PC \\--
--// Advanced Anti-Lag Script with Smart Optimizations \\--

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

-- Performance Tracking
local OptimizationStats = {
    PartsOptimized = 0,
    TexturesRemoved = 0,
    ParticlesDisabled = 0,
    EffectsDisabled = 0,
    LightsOptimized = 0,
    GuisOptimized = 0,
    StartTime = tick(),
    MemoryBefore = 0,
    MemoryAfter = 0
}

-- Advanced Settings Configuration
local Settings = {
    -- Core Performance
    RemoveUnnecessaryTextures = true,
    DisableParticles = true,
    DisablePostEffects = true,
    OptimizeParts = true,
    DisableShadows = true,
    
    -- Visual Quality Balance
    KeepSky = true,
    KeepColors = true,
    KeepImportantDecals = true, -- Keeps UI-related decals
    
    -- Advanced Optimizations
    OptimizeLighting = true,
    OptimizeGUIs = true,
    OptimizeSounds = true,
    FlattenTerrain = true,
    ReduceDrawDistance = true,
    OptimizeAnimations = true,
    
    -- Performance Limits
    FPSCap = 120,
    MaxRenderDistance = 1000,
    ParticleLimit = 50,
    
    -- Dynamic Performance
    EnableDynamicOptimization = true,
    TargetFPS = 60,
    MonitorPerformance = true,
    
    -- Safety Features
    SafeMode = false, -- Prevents removing essential objects
    BackupSettings = true,
    
    -- Visual Enhancements
    ImprovedLighting = true,
    BetterFog = true,
    CleanWater = true
}

-- Backup original settings for restoration
local OriginalSettings = {}
if Settings.BackupSettings then
    OriginalSettings.Lighting = {
        Brightness = Lighting.Brightness,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        Ambient = Lighting.Ambient,
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart,
        FogColor = Lighting.FogColor,
        GlobalShadows = Lighting.GlobalShadows
    }
end

-- Essential object whitelist (SafeMode)
local EssentialObjects = {
    "Camera", "CurrentCamera", "Humanoid", "HumanoidRootPart",
    "Head", "Torso", "UpperTorso", "LowerTorso"
}

-- Performance monitoring function
local function GetMemoryUsage()
    return collectgarbage("count")
end

OptimizationStats.MemoryBefore = GetMemoryUsage()

-- Utility Functions
local function IsEssential(obj)
    if not Settings.SafeMode then return false end
    
    for _, essential in ipairs(EssentialObjects) do
        if obj.Name == essential or obj.ClassName == essential then
            return true
        end
    end
    
    -- Don't remove player-related objects
    local player = Players.LocalPlayer
    if player and player.Character then
        return obj:IsDescendantOf(player.Character)
    end
    
    return false
end

local function SafeDestroy(obj)
    if IsEssential(obj) then return false end
    
    local success = pcall(function()
        obj:Destroy()
    end)
    return success
end

local function SafeDisable(obj)
    if IsEssential(obj) then return false end
    
    local success = pcall(function()
        if obj:GetAttribute("FPSBooster_Disabled") then return end
        obj:SetAttribute("FPSBooster_Disabled", true)
        
        if obj:FindFirstChild("Enabled") then
            obj.Enabled = false
        elseif obj:FindFirstChild("Volume") then
            obj.Volume = 0
        end
    end)
    return success
end

-- Advanced Part Optimization
local function OptimizePart(part)
    if not part:IsA("BasePart") or IsEssential(part) then return false end
    
    pcall(function()
        -- Material optimization
        if part.Material ~= Enum.Material.Plastic then
            part.Material = Enum.Material.Plastic
        end
        
        -- Remove expensive properties
        part.Reflectance = 0
        part.CastShadow = false
        part.CanCollide = part.CanCollide -- Keep collision for gameplay
        
        -- Optimize transparency for distant objects
        if Settings.ReduceDrawDistance then
            local camera = workspace.CurrentCamera
            if camera then
                local distance = (part.Position - camera.CFrame.Position).Magnitude
                if distance > Settings.MaxRenderDistance then
                    part.Transparency = math.min(part.Transparency + 0.5, 0.95)
                end
            end
        end
        
        -- Keep colors if setting is enabled
        if not Settings.KeepColors then
            part.Color = Color3.fromRGB(200, 200, 200)
        end
        
        -- Optimize mesh/special mesh
        local mesh = part:FindFirstChildOfClass("SpecialMesh") or part:FindFirstChildOfClass("Mesh")
        if mesh then
            mesh.TextureId = ""
        end
    end)
    
    return true
end

-- Smart Decal/Texture Removal
local function ShouldKeepDecal(decal)
    if not Settings.KeepImportantDecals then return false end
    
    -- Keep UI-related decals
    local parent = decal.Parent
    if parent and (parent:IsA("ScreenGui") or parent:IsA("BillboardGui") or parent:IsA("SurfaceGui")) then
        return true
    end
    
    -- Keep decals with specific names (signs, important graphics)
    local importantNames = {"sign", "logo", "icon", "ui", "hud", "button"}
    local name = decal.Name:lower()
    for _, important in ipairs(importantNames) do
        if name:find(important) then
            return true
        end
    end
    
    return false
end

-- Advanced Lighting Optimization
local function OptimizeLighting()
    if not Settings.OptimizeLighting then return end
    
    pcall(function()
        -- Enhanced lighting for better performance and visuals
        if Settings.ImprovedLighting then
            Lighting.Brightness = 2.5
            Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 160)
            Lighting.Ambient = Color3.fromRGB(150, 150, 160)
            Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
        end
        
        -- Improved fog settings
        if Settings.BetterFog then
            Lighting.FogEnd = 2000
            Lighting.FogStart = 100
            Lighting.FogColor = Color3.fromRGB(200, 210, 220)
        else
            Lighting.FogEnd = 1e9
            Lighting.FogStart = 0
        end
        
        -- Disable expensive lighting features
        if Settings.DisableShadows then
            Lighting.GlobalShadows = false
        end
        
        -- Remove expensive lighting objects
        for _, light in ipairs(Lighting:GetChildren()) do
            if light:IsA("PointLight") or light:IsA("SpotLight") or light:IsA("SurfaceLight") then
                if not IsEssential(light) then
                    SafeDisable(light)
                    OptimizationStats.LightsOptimized = OptimizationStats.LightsOptimized + 1
                end
            end
        end
    end)
end

-- GUI Optimization
local function OptimizeGUIs()
    if not Settings.OptimizeGUIs then return end
    
    for _, gui in ipairs(Players.LocalPlayer:WaitForChild("PlayerGui"):GetDescendants()) do
        pcall(function()
            -- Reduce GUI update frequency
            if gui:IsA("Frame") or gui:IsA("TextLabel") or gui:IsA("ImageLabel") then
                if gui:GetAttribute("FPSBooster_Optimized") then return end
                gui:SetAttribute("FPSBooster_Optimized", true)
                
                -- Disable expensive GUI effects
                if gui:FindFirstChild("UIStroke") then
                    gui.UIStroke.Enabled = false
                end
                if gui:FindFirstChild("UIGradient") then
                    gui.UIGradient.Enabled = false
                end
                if gui:FindFirstChild("DropShadowEffect") then
                    gui.DropShadowEffect.Enabled = false
                end
                
                OptimizationStats.GuisOptimized = OptimizationStats.GuisOptimized + 1
            end
        end)
    end
end

-- Terrain Optimization
local function OptimizeTerrain()
    if not Terrain or not Settings.FlattenTerrain then return end
    
    pcall(function()
        -- Water optimization
        if Settings.CleanWater then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 0.7
        end
        
        -- Reduce terrain quality for better performance
        Terrain.Decoration = false
    end)
end

-- Dynamic Performance Monitor
local lastFPSCheck = 0
local fpsHistory = {}

local function MonitorPerformance()
    if not Settings.MonitorPerformance or not Settings.EnableDynamicOptimization then return end
    
    local currentTime = tick()
    if currentTime - lastFPSCheck < 1 then return end -- Check every second
    
    lastFPSCheck = currentTime
    
    -- Calculate FPS
    local fps = 1 / RunService.Heartbeat:Wait()
    table.insert(fpsHistory, fps)
    
    if #fpsHistory > 10 then
        table.remove(fpsHistory, 1)
    end
    
    -- Calculate average FPS
    local avgFPS = 0
    for _, f in ipairs(fpsHistory) do
        avgFPS = avgFPS + f
    end
    avgFPS = avgFPS / #fpsHistory
    
    -- Dynamic optimization based on performance
    if avgFPS < Settings.TargetFPS then
        -- Increase optimization intensity
        Settings.MaxRenderDistance = math.max(500, Settings.MaxRenderDistance - 100)
        Settings.ParticleLimit = math.max(10, Settings.ParticleLimit - 10)
    elseif avgFPS > Settings.TargetFPS + 10 then
        -- Decrease optimization intensity
        Settings.MaxRenderDistance = math.min(1500, Settings.MaxRenderDistance + 50)
        Settings.ParticleLimit = math.min(100, Settings.ParticleLimit + 5)
    end
end

-- Main Optimization Loop
print("🚀 Starting Enhanced FPS Booster...")
print("⚙️ Scanning " .. #game:GetDescendants() .. " objects...")

local startTime = tick()
local objectsProcessed = 0
local particleCount = 0

for _, obj in ipairs(game:GetDescendants()) do
    objectsProcessed = objectsProcessed + 1
    local class = obj.ClassName
    
    -- Progress indicator
    if objectsProcessed % 1000 == 0 then
        print("📊 Processed " .. objectsProcessed .. " objects...")
    end
    
    -- Part Optimization
    if Settings.OptimizeParts and obj:IsA("BasePart") then
        if OptimizePart(obj) then
            OptimizationStats.PartsOptimized = OptimizationStats.PartsOptimized + 1
        end
    end
    
    -- Smart Texture/Decal Removal
    if Settings.RemoveUnnecessaryTextures and (class == "Decal" or class == "Texture") then
        if not ShouldKeepDecal(obj) then
            if SafeDestroy(obj) then
                OptimizationStats.TexturesRemoved = OptimizationStats.TexturesRemoved + 1
            end
        end
    end
    
    -- Particle System Management
    if Settings.DisableParticles and (class == "ParticleEmitter" or class == "Smoke" or class == "Fire" or class == "Explosion" or class == "Sparkles") then
        particleCount = particleCount + 1
        if particleCount > Settings.ParticleLimit or SafeDisable(obj) then
            OptimizationStats.ParticlesDisabled = OptimizationStats.ParticlesDisabled + 1
        end
    end
    
    -- Post-Processing Effects
    if Settings.DisablePostEffects then
        local effectTypes = {"BlurEffect", "SunRaysEffect", "DepthOfFieldEffect", "BloomEffect", "ColorCorrectionEffect", "MotionBlur"}
        for _, effectType in ipairs(effectTypes) do
            if class == effectType then
                if SafeDisable(obj) then
                    OptimizationStats.EffectsDisabled = OptimizationStats.EffectsDisabled + 1
                end
                break
            end
        end
    end
    
    -- Sound Optimization
    if Settings.OptimizeSounds and (class == "Sound" or class == "SoundEffect") then
        pcall(function()
            if obj.Volume and obj.Volume > 0.1 then
                obj.Volume = obj.Volume * 0.7 -- Reduce volume slightly
            end
        end)
    end
    
    -- Animation Optimization
    if Settings.OptimizeAnimations and class == "Animation" then
        pcall(function()
            if obj.AnimationId and obj.AnimationId ~= "" then
                -- Keep essential animations only
                local name = obj.Name:lower()
                if not (name:find("idle") or name:find("walk") or name:find("run")) then
                    obj.AnimationId = ""
                end
            end
        end)
    end
    
    -- Sky Management
    if not Settings.KeepSky and class == "Sky" then
        SafeDestroy(obj)
    end
end

-- Apply advanced optimizations
OptimizeLighting()
OptimizeTerrain()
OptimizeGUIs()

-- Set FPS Cap
if typeof(setfpscap) == "function" and Settings.FPSCap then
    setfpscap(Settings.FPSCap)
elseif typeof(setfpsmax) == "function" and Settings.FPSCap then
    setfpsmax(Settings.FPSCap)
end

-- Memory cleanup
OptimizationStats.MemoryAfter = GetMemoryUsage()
local memoryFreed = OptimizationStats.MemoryBefore - OptimizationStats.MemoryAfter

collectgarbage("collect")

-- Setup performance monitoring
if Settings.MonitorPerformance then
    RunService.Heartbeat:Connect(MonitorPerformance)
end

-- Final Results
local processingTime = tick() - startTime
print("\n" .. string.rep("=", 50))
print("✅ ENHANCED FPS BOOSTER COMPLETE!")
print(string.rep("=", 50))
print("⏱️  Processing Time: " .. math.round(processingTime * 100) / 100 .. " seconds")
print("📊 Objects Processed: " .. objectsProcessed)
print("\n📈 OPTIMIZATION RESULTS:")
print("🧱 Parts Optimized: " .. OptimizationStats.PartsOptimized)
print("🎨 Textures Removed: " .. OptimizationStats.TexturesRemoved)
print("💨 Particles Disabled: " .. OptimizationStats.ParticlesDisabled)
print("🔍 Effects Disabled: " .. OptimizationStats.EffectsDisabled)
print("💡 Lights Optimized: " .. OptimizationStats.LightsOptimized)
print("🖥️  GUIs Optimized: " .. OptimizationStats.GuisOptimized)
print("🧠 Memory Freed: " .. math.round(memoryFreed * 100) / 100 .. " KB")

print("\n⚙️  ACTIVE SETTINGS:")
for setting, value in pairs(Settings) do
    if typeof(value) == "boolean" then
        print("• " .. setting .. ": " .. (value and "✅" or "❌"))
    else
        print("• " .. setting .. ": " .. tostring(value))
    end
end

print("\n🎯 Performance monitoring " .. (Settings.MonitorPerformance and "ENABLED" or "DISABLED"))
print("🔄 Dynamic optimization " .. (Settings.EnableDynamicOptimization and "ENABLED" or "DISABLED"))

-- Success notification
if game:GetService("StarterGui") then
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "🚀 FPS Booster Complete!";
            Text = "Optimized " .. (OptimizationStats.PartsOptimized + OptimizationStats.TexturesRemoved + OptimizationStats.ParticlesDisabled) .. " objects";
            Duration = 5;
        })
    end)
end

print(string.rep("=", 50))