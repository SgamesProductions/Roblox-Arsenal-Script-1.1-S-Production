-- ============================================
--   S-Productions | Arsenal Hub v1.1
--   Mobil Optimize | TR/EN | Fast Reload + No Recoil
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ============================================
-- DİL SİSTEMİ
-- ============================================
local Lang = {
    TR = {
        title      = "ARSENAL HUB",
        esp        = "👁  Oyuncu ESP",
        speed      = "⚡  Speed Hack",
        speedVal   = "Hız Değeri",
        recoil     = "🎯  No Recoil",
        reload     = "🔄  Fast Reload",
        reloadVal  = "Reload Hızı",
        esp_sec    = "ESP",
        speed_sec  = "SPEED",
        combat_sec = "COMBAT",
        loaded     = "✓  Arsenal Hub v1.1 Yüklendi!",
        watermark  = "S-Productions  •  Arsenal Hub v1.1  •  Mobil",
        selectLang = "🌐  Dil Seçin / Select Language",
    },
    EN = {
        title      = "ARSENAL HUB",
        esp        = "👁  Player ESP",
        speed      = "⚡  Speed Hack",
        speedVal   = "Speed Value",
        recoil     = "🎯  No Recoil",
        reload     = "🔄  Fast Reload",
        reloadVal  = "Reload Speed",
        esp_sec    = "ESP",
        speed_sec  = "SPEED",
        combat_sec = "COMBAT",
        loaded     = "✓  Arsenal Hub v1.1 Loaded!",
        watermark  = "S-Productions  •  Arsenal Hub v1.1  •  Mobile",
        selectLang = "🌐  Dil Seçin / Select Language",
    },
}
local currentLang = "TR"
local function T(k) return Lang[currentLang][k] end

-- ============================================
-- AYARLAR
-- ============================================
local Settings = {
    ESP    = { Enabled = false },
    Speed  = { Enabled = false, Value = 50 },
    Recoil = { Enabled = false },
    Reload = { Enabled = false, Speed = 0.05 },
}

-- ============================================
-- ESP SİSTEMİ
-- ============================================
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ArsenalESP"
ESPFolder.Parent = game.CoreGui
local ESPObjects = {}

local function CreateESP(player)
    if player == LocalPlayer then return end
    local bb = Instance.new("BillboardGui")
    bb.Name = "ESP_" .. player.Name
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 140, 0, 70)
    bb.StudsOffset = Vector3.new(0, 3.5, 0)
    bb.Enabled = false
    bb.Parent = ESPFolder

    local nl = Instance.new("TextLabel")
    nl.BackgroundTransparency = 1
    nl.Size = UDim2.new(1, 0, 0.5, 0)
    nl.Font = Enum.Font.GothamBold
    nl.TextSize = 14
    nl.TextColor3 = Color3.fromRGB(255, 255, 255)
    nl.TextStrokeTransparency = 0
    nl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nl.Parent = bb

    local hbg = Instance.new("Frame")
    hbg.Size = UDim2.new(1, 0, 0.13, 0)
    hbg.Position = UDim2.new(0, 0, 0.82, 0)
    hbg.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    hbg.BorderSizePixel = 0
    hbg.Parent = bb
    Instance.new("UICorner", hbg).CornerRadius = UDim.new(1, 0)

    local hb = Instance.new("Frame")
    hb.Size = UDim2.new(1, 0, 1, 0)
    hb.BackgroundColor3 = Color3.fromRGB(50, 210, 50)
    hb.BorderSizePixel = 0
    hb.Parent = hbg
    Instance.new("UICorner", hb).CornerRadius = UDim.new(1, 0)

    ESPObjects[player.Name] = { Billboard = bb, NameLabel = nl, HealthBar = hb }

    RunService.Heartbeat:Connect(function()
        if not Settings.ESP.Enabled then bb.Enabled = false return end
        local char = player.Character
        if not char then bb.Enabled = false return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.Health > 0 then
            bb.Adornee = hrp
            bb.Enabled = true
            local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            hb.Size = UDim2.new(hp, 0, 1, 0)
            hb.BackgroundColor3 = Color3.fromRGB(255*(1-hp), 255*hp, 30)
            local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
            nl.Text = player.Name .. "  [" .. dist .. "m]"
        else
            bb.Enabled = false
        end
    end)
end

local function RemoveESP(player)
    if ESPObjects[player.Name] then
        ESPObjects[player.Name].Billboard:Destroy()
        ESPObjects[player.Name] = nil
    end
end

Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(RemoveESP)
for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end

-- ============================================
-- SPEED HACK
-- ============================================
RunService.Heartbeat:Connect(function()
    if not Settings.Speed.Enabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = Settings.Speed.Value end
end)

-- ============================================
-- NO RECOIL
-- ============================================
local recoilConn
local lastCamCF

local function EnableRecoil()
    lastCamCF = nil
    recoilConn = RunService.RenderStepped:Connect(function()
        if not Settings.Recoil.Enabled then lastCamCF = nil return end
        local camCF = Camera.CFrame
        if lastCamCF then
            local lx, ly, lz = lastCamCF:ToEulerAnglesYXZ()
            local cx, cy, cz = camCF:ToEulerAnglesYXZ()
            local diff = cx - lx
            if diff > 0.008 then
                Camera.CFrame = CFrame.new(camCF.Position)
                    * CFrame.fromEulerAnglesYXZ(lx, cy, cz)
                return
            end
        end
        lastCamCF = camCF
    end)
end

local function DisableRecoil()
    if recoilConn then recoilConn:Disconnect() recoilConn = nil end
    lastCamCF = nil
end

-- ============================================
-- FAST RELOAD
-- ============================================
local reloadConn
local hookedTools = {}

local function GetAnimator()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end
    return hum:FindFirstChildOfClass("Animator")
end

local function ApplyReloadSpeed()
    local animator = GetAnimator()
    if not animator then return end
    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
        local name = string.lower(track.Name or "")
        if string.find(name, "reload") or (track.Length > 0 and track.Length < 2.5) then
            local targetSpeed = 1 / math.max(Settings.Reload.Speed, 0.01)
            track:AdjustSpeed(targetSpeed)
        end
    end
end

local function ResetReloadSpeed()
    local animator = GetAnimator()
    if not animator then return end
    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
        track:AdjustSpeed(1)
    end
end

local function HookTool(tool)
    if hookedTools[tool] then return end
    hookedTools[tool] = true
    tool.Equipped:Connect(function()
        if Settings.Reload.Enabled then ApplyReloadSpeed() end
    end)
end

reloadConn = RunService.Heartbeat:Connect(function()
    if not Settings.Reload.Enabled then return end
    ApplyReloadSpeed()
end)

local function OnCharAdded(char)
    char.ChildAdded:Connect(function(c)
        if c:IsA("Tool") then HookTool(c) end
    end)
    for _, c in pairs(char:GetChildren()) do
        if c:IsA("Tool") then HookTool(c) end
    end
end

if LocalPlayer.Character then OnCharAdded(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(OnCharAdded)

local function DisableReload()
    Settings.Reload.Enabled = false
    hookedTools = {}
    ResetReloadSpeed()
end

-- ============================================
-- ANİMASYONLU INTRO
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SProductionsHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = game.CoreGui

local IntroFrame = Instance.new("Frame")
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
IntroFrame.BorderSizePixel = 0
IntroFrame.ZIndex = 100
IntroFrame.Parent = ScreenGui

local ig = Instance.new("UIGradient")
ig.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 12)),
})
ig.Rotation = 135
ig.Parent = IntroFrame

local SLetter = Instance.new("TextLabel")
SLetter.Size = UDim2.new(0, 130, 0, 130)
SLetter.Position = UDim2.new(0.5, -65, 0.5, -115)
SLetter.BackgroundTransparency = 1
SLetter.Font = Enum.Font.GothamBold
SLetter.TextSize = 110
SLetter.TextColor3 = Color3.fromRGB(210, 30, 30)
SLetter.Text = "S"
SLetter.TextTransparency = 1
SLetter.ZIndex = 101
SLetter.Parent = IntroFrame

local introLine = Instance.new("Frame")
introLine.Size = UDim2.new(0, 0, 0, 3)
introLine.Position = UDim2.new(0.5, 0, 0.5, 20)
introLine.BackgroundColor3 = Color3.fromRGB(210, 30, 30)
introLine.BorderSizePixel = 0
introLine.AnchorPoint = Vector2.new(0.5, 0.5)
introLine.ZIndex = 101
introLine.Parent = IntroFrame
Instance.new("UICorner", introLine).CornerRadius = UDim.new(1, 0)

local introText = Instance.new("TextLabel")
introText.Size = UDim2.new(1, 0, 0, 50)
introText.Position = UDim2.new(0, 0, 0.5, 30)
introText.BackgroundTransparency = 1
introText.Font = Enum.Font.GothamBold
introText.TextSize = isMobile and 30 or 34
introText.TextColor3 = Color3.fromRGB(255, 255, 255)
introText.Text = "S-Productions"
introText.TextTransparency = 1
introText.ZIndex = 101
introText.Parent = IntroFrame

local introSub = Instance.new("TextLabel")
introSub.Size = UDim2.new(1, 0, 0, 28)
introSub.Position = UDim2.new(0, 0, 0.5, 82)
introSub.BackgroundTransparency = 1
introSub.Font = Enum.Font.Gotham
introSub.TextSize = isMobile and 14 or 16
introSub.TextColor3 = Color3.fromRGB(180, 30, 30)
introSub.Text = "Arsenal Hub  v1.1"
introSub.TextTransparency = 1
introSub.ZIndex = 101
introSub.Parent = IntroFrame

local function PlayIntro(onFinish)
    task.delay(0.3, function()
        TweenService:Create(SLetter, TweenInfo.new(0.6, Enum.EasingStyle.Back), { TextTransparency = 0 }):Play()
    end)
    task.delay(0.8, function()
        TweenService:Create(introLine, TweenInfo.new(0.5, Enum.EasingStyle.Quart), { Size = UDim2.new(0, 300, 0, 3) }):Play()
    end)
    task.delay(1.1, function()
        TweenService:Create(introText, TweenInfo.new(0.5), { TextTransparency = 0 }):Play()
    end)
    task.delay(1.4, function()
        TweenService:Create(introSub, TweenInfo.new(0.5), { TextTransparency = 0 }):Play()
    end)
    task.delay(2.9, function()
        TweenService:Create(SLetter,    TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
        TweenService:Create(introLine,  TweenInfo.new(0.5), { Size = UDim2.new(0, 0, 0, 3) }):Play()
        TweenService:Create(introText,  TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
        TweenService:Create(introSub,   TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
        TweenService:Create(IntroFrame, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
        task.delay(0.6, function()
            IntroFrame:Destroy()
            onFinish()
        end)
    end)
end

-- ============================================
-- DİL SEÇİM EKRANI
-- ============================================
local function ShowLangSelect(onSelect)
    local LF = Instance.new("Frame")
    LF.Size = UDim2.new(0, 290, 0, 215)
    LF.Position = UDim2.new(0.5, -145, 0.5, -107)
    LF.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    LF.BorderSizePixel = 0
    LF.BackgroundTransparency = 1
    LF.ZIndex = 50
    LF.Parent = ScreenGui
    Instance.new("UICorner", LF).CornerRadius = UDim.new(0, 16)

    local ls = Instance.new("UIStroke")
    ls.Color = Color3.fromRGB(210, 30, 30)
    ls.Thickness = 2
    ls.Parent = LF

    local lt = Instance.new("TextLabel")
    lt.Size = UDim2.new(1, 0, 0, 60)
    lt.BackgroundTransparency = 1
    lt.Font = Enum.Font.GothamBold
    lt.TextSize = isMobile and 17 or 15
    lt.TextColor3 = Color3.fromRGB(255, 255, 255)
    lt.Text = T("selectLang")
    lt.TextTransparency = 1
    lt.ZIndex = 51
    lt.Parent = LF

    local function MakeBtn(text, yPos, lang)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.82, 0, 0, isMobile and 54 or 46)
        btn.Position = UDim2.new(0.09, 0, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 38)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = isMobile and 16 or 14
        btn.TextColor3 = Color3.fromRGB(220, 220, 240)
        btn.Text = text
        btn.BorderSizePixel = 0
        btn.BackgroundTransparency = 1
        btn.ZIndex = 51
        btn.Parent = LF
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
        local bs = Instance.new("UIStroke")
        bs.Color = Color3.fromRGB(40, 40, 70)
        bs.Thickness = 1
        bs.Parent = btn

        btn.MouseButton1Click:Connect(function()
            currentLang = lang
            TweenService:Create(LF, TweenInfo.new(0.35), { BackgroundTransparency = 1 }):Play()
            TweenService:Create(lt, TweenInfo.new(0.25), { TextTransparency = 1 }):Play()
            task.delay(0.4, function() LF:Destroy() onSelect() end)
        end)
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(210, 30, 30), BackgroundTransparency = 0,
            }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(20, 20, 38), BackgroundTransparency = 0,
            }):Play()
        end)
        return btn
    end

    TweenService:Create(LF, TweenInfo.new(0.5, Enum.EasingStyle.Back), { BackgroundTransparency = 0 }):Play()
    task.delay(0.2, function()
        TweenService:Create(lt, TweenInfo.new(0.4), { TextTransparency = 0 }):Play()
    end)
    local b1 = MakeBtn("🇹🇷  Türkçe", 68, "TR")
    local b2 = MakeBtn("🇬🇧  English", 132, "EN")
    task.delay(0.3, function()
        TweenService:Create(b1, TweenInfo.new(0.3), { BackgroundTransparency = 0 }):Play()
        TweenService:Create(b2, TweenInfo.new(0.3), { BackgroundTransparency = 0 }):Play()
    end)
end

-- ============================================
-- ANA GUI
-- ============================================
local function BuildMainGui()
    local FW = isMobile and 325 or 305
    local FH = isMobile and 500 or 475
    local TH = isMobile and 62 or 55
    local TS = isMobile and 15 or 13
    local TITLES = isMobile and 19 or 17

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, FW, 0, FH)
    MainFrame.Position = UDim2.new(0.5, -FW/2, 0.5, -FH/2)
    MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

    local ms = Instance.new("UIStroke")
    ms.Color = Color3.fromRGB(210, 35, 35)
    ms.Thickness = 1.8
    ms.Parent = MainFrame

    local mg = Instance.new("UIGradient")
    mg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 14, 28)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 16)),
    })
    mg.Rotation = 135
    mg.Parent = MainFrame

    local TB = Instance.new("Frame")
    TB.Size = UDim2.new(1, 0, 0, 65)
    TB.BackgroundColor3 = Color3.fromRGB(16, 16, 30)
    TB.BorderSizePixel = 0
    TB.Parent = MainFrame
    Instance.new("UICorner", TB).CornerRadius = UDim.new(0, 14)

    local al = Instance.new("Frame")
    al.Size = UDim2.new(0, 4, 0.65, 0)
    al.Position = UDim2.new(0, 14, 0.175, 0)
    al.BackgroundColor3 = Color3.fromRGB(210, 35, 35)
    al.BorderSizePixel = 0
    al.Parent = TB
    Instance.new("UICorner", al).CornerRadius = UDim.new(1, 0)

    local cl = Instance.new("TextLabel")
    cl.Size = UDim2.new(1, -95, 0, 20)
    cl.Position = UDim2.new(0, 26, 0, 8)
    cl.BackgroundTransparency = 1
    cl.Font = Enum.Font.GothamBold
    cl.TextSize = 10
    cl.TextColor3 = Color3.fromRGB(180, 35, 35)
    cl.TextXAlignment = Enum.TextXAlignment.Left
    cl.Text = "S-PRODUCTIONS"
    cl.Parent = TB

    local tl = Instance.new("TextLabel")
    tl.Size = UDim2.new(1, -95, 0, 28)
    tl.Position = UDim2.new(0, 26, 0, 26)
    tl.BackgroundTransparency = 1
    tl.Font = Enum.Font.GothamBold
    tl.TextSize = TITLES
    tl.TextColor3 = Color3.fromRGB(240, 240, 255)
    tl.TextXAlignment = Enum.TextXAlignment.Left
    tl.Text = "⚡ " .. T("title") .. "  v1.1"
    tl.Parent = TB

    local bS = isMobile and 36 or 30

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, bS, 0, bS)
    MinBtn.Position = UDim2.new(1, -(bS*2+18), 0.5, -bS/2)
    MinBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 70)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 14
    MinBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
    MinBtn.Text = "▼"
    MinBtn.BorderSizePixel = 0
    MinBtn.Parent = TB
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, bS, 0, bS)
    CloseBtn.Position = UDim2.new(1, -(bS+10), 0.5, -bS/2)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Text = "✕"
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Parent = TB
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
            Size = UDim2.new(0, FW, 0, 0), BackgroundTransparency = 1,
        }):Play()
        task.delay(0.35, function() ScreenGui:Destroy() end)
    end)

    local MF = Instance.new("Frame")
    MF.Size = UDim2.new(0, FW, 0, 52)
    MF.Position = MainFrame.Position
    MF.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
    MF.BorderSizePixel = 0
    MF.Visible = false
    MF.Active = true
    MF.Draggable = true
    MF.Parent = ScreenGui
    Instance.new("UICorner", MF).CornerRadius = UDim.new(0, 12)
    local mfs = Instance.new("UIStroke")
    mfs.Color = Color3.fromRGB(210, 35, 35)
    mfs.Thickness = 1.5
    mfs.Parent = MF

    local mfl = Instance.new("TextLabel")
    mfl.Size = UDim2.new(1, -80, 1, 0)
    mfl.Position = UDim2.new(0, 16, 0, 0)
    mfl.BackgroundTransparency = 1
    mfl.Font = Enum.Font.GothamBold
    mfl.TextSize = 13
    mfl.TextColor3 = Color3.fromRGB(220, 220, 240)
    mfl.TextXAlignment = Enum.TextXAlignment.Left
    mfl.Text = "⚡ ARSENAL HUB  •  S-PRODUCTIONS"
    mfl.Parent = MF

    local EB = Instance.new("TextButton")
    EB.Size = UDim2.new(0, bS, 0, bS)
    EB.Position = UDim2.new(1, -(bS+10), 0.5, -bS/2)
    EB.BackgroundColor3 = Color3.fromRGB(30, 110, 30)
    EB.Font = Enum.Font.GothamBold
    EB.TextSize = 14
    EB.TextColor3 = Color3.fromRGB(255, 255, 255)
    EB.Text = "▲"
    EB.BorderSizePixel = 0
    EB.Parent = MF
    Instance.new("UICorner", EB).CornerRadius = UDim.new(0, 8)

    MinBtn.MouseButton1Click:Connect(function()
        MF.Position = MainFrame.Position
        MainFrame.Visible = false
        MF.Visible = true
    end)
    EB.MouseButton1Click:Connect(function()
        MainFrame.Position = MF.Position
        MF.Visible = false
        MainFrame.Visible = true
    end)

    local Content = Instance.new("ScrollingFrame")
    Content.Size = UDim2.new(1, 0, 1, -70)
    Content.Position = UDim2.new(0, 0, 0, 70)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.ScrollBarThickness = isMobile and 4 or 3
    Content.ScrollBarImageColor3 = Color3.fromRGB(210, 35, 35)
    Content.ScrollingDirection = Enum.ScrollingDirection.Y
    Content.Parent = MainFrame

    local function Section(yPos, text)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, -28, 0, 24)
        l.Position = UDim2.new(0, 14, 0, yPos)
        l.BackgroundTransparency = 1
        l.Font = Enum.Font.GothamBold
        l.TextSize = 10
        l.TextColor3 = Color3.fromRGB(200, 35, 35)
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Text = "▸ " .. string.upper(text)
        l.Parent = Content
    end

    local function Toggle(yPos, label, onToggle)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -24, 0, TH)
        f.Position = UDim2.new(0, 12, 0, yPos)
        f.BackgroundColor3 = Color3.fromRGB(16, 16, 30)
        f.BorderSizePixel = 0
        f.Parent = Content
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        local fs = Instance.new("UIStroke")
        fs.Color = Color3.fromRGB(30, 30, 55)
        fs.Thickness = 1
        fs.Parent = f

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -80, 1, 0)
        lbl.Position = UDim2.new(0, 16, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = TS
        lbl.TextColor3 = Color3.fromRGB(210, 210, 235)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Text = label
        lbl.Parent = f

        local bW = isMobile and 54 or 46
        local bH = isMobile and 30 or 24
        local cW = isMobile and 22 or 18

        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(0, bW, 0, bH)
        bg.Position = UDim2.new(1, -(bW+12), 0.5, -bH/2)
        bg.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
        bg.BorderSizePixel = 0
        bg.Parent = f
        Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

        local circle = Instance.new("Frame")
        circle.Size = UDim2.new(0, cW, 0, cW)
        circle.Position = UDim2.new(0, 4, 0.5, -cW/2)
        circle.BackgroundColor3 = Color3.fromRGB(130, 130, 160)
        circle.BorderSizePixel = 0
        circle.Parent = bg
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

        local toggled = false
        local onP = bW - cW - 4

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = f

        btn.MouseButton1Click:Connect(function()
            toggled = not toggled
            TweenService:Create(circle, TweenInfo.new(0.18), {
                Position = toggled and UDim2.new(0, onP, 0.5, -cW/2) or UDim2.new(0, 4, 0.5, -cW/2),
                BackgroundColor3 = toggled and Color3.fromRGB(255,255,255) or Color3.fromRGB(130,130,160),
            }):Play()
            TweenService:Create(bg, TweenInfo.new(0.18), {
                BackgroundColor3 = toggled and Color3.fromRGB(200,30,30) or Color3.fromRGB(40,40,65),
            }):Play()
            onToggle(toggled)
        end)
    end

    local function Slider(yPos, label, minV, maxV, defV, onChange)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -24, 0, TH)
        f.Position = UDim2.new(0, 12, 0, yPos)
        f.BackgroundColor3 = Color3.fromRGB(16, 16, 30)
        f.BorderSizePixel = 0
        f.Parent = Content
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        local fs = Instance.new("UIStroke")
        fs.Color = Color3.fromRGB(30, 30, 55)
        fs.Thickness = 1
        fs.Parent = f

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.68, 0, 0, 22)
        lbl.Position = UDim2.new(0, 16, 0, 6)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = TS
        lbl.TextColor3 = Color3.fromRGB(195, 195, 215)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Text = label
        lbl.Parent = f

        local vl = Instance.new("TextLabel")
        vl.Size = UDim2.new(0.3, -10, 0, 22)
        vl.Position = UDim2.new(0.7, 0, 0, 6)
        vl.BackgroundTransparency = 1
        vl.Font = Enum.Font.GothamBold
        vl.TextSize = TS
        vl.TextColor3 = Color3.fromRGB(200, 30, 30)
        vl.TextXAlignment = Enum.TextXAlignment.Right
        vl.Text = tostring(defV)
        vl.Parent = f

        local tH2 = isMobile and 8 or 6
        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, -32, 0, tH2)
        track.Position = UDim2.new(0, 16, 0, TH - tH2 - 10)
        track.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        track.BorderSizePixel = 0
        track.Parent = f
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local r0 = (defV - minV) / (maxV - minV)
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(r0, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
        fill.BorderSizePixel = 0
        fill.Parent = track
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local kS = isMobile and 20 or 14
        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, kS, 0, kS)
        knob.Position = UDim2.new(r0, -kS/2, 0.5, -kS/2)
        knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
        knob.BorderSizePixel = 0
        knob.ZIndex = 2
        knob.Parent = track
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local dragging = false
        local tb = Instance.new("TextButton")
        tb.Size = UDim2.new(1, 0, 4, 0)
        tb.Position = UDim2.new(0, 0, 0.5, -tH2*2)
        tb.BackgroundTransparency = 1
        tb.Text = ""
        tb.ZIndex = 3
        tb.Parent = track

        local function upd(x)
            local r = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local v = math.floor(minV + r*(maxV-minV))
            fill.Size = UDim2.new(r, 0, 1, 0)
            knob.Position = UDim2.new(r, -kS/2, 0.5, -kS/2)
            vl.Text = tostring(v)
            onChange(v)
        end

        tb.MouseButton1Down:Connect(function() dragging = true end)
        tb.TouchStarted:Connect(function(t) dragging = true upd(t.Position.X) end)
        tb.TouchMoved:Connect(function(t) if dragging then upd(t.Position.X) end end)
        tb.TouchEnded:Connect(function() dragging = false end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or
               i.UserInputType == Enum.UserInputType.Touch then dragging = false end
        end)
        RunService.Heartbeat:Connect(function()
            if dragging then upd(UserInputService:GetMouseLocation().X) end
        end)
    end

    -- ============================================
    -- TOGGLELAR
    -- ============================================
    local y = 0

    Section(y, T("esp_sec"))     y = y + 26
    Toggle(y, T("esp"), function(on)
        Settings.ESP.Enabled = on
        if not on then for _, e in pairs(ESPObjects) do e.Billboard.Enabled = false end end
    end) y = y + TH + 8

    Section(y, T("speed_sec"))   y = y + 26
    Toggle(y, T("speed"), function(on)
        Settings.Speed.Enabled = on
        if not on then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = 16 end
            end
        end
    end) y = y + TH + 6
    Slider(y, T("speedVal"), 16, 200, 50, function(v)
        Settings.Speed.Value = v
    end) y = y + TH + 8

    Section(y, T("combat_sec"))  y = y + 26
    Toggle(y, T("recoil"), function(on)
        Settings.Recoil.Enabled = on
        if on then EnableRecoil() else DisableRecoil() end
    end) y = y + TH + 6
    Toggle(y, T("reload"), function(on)
        Settings.Reload.Enabled = on
        if not on then DisableReload() end
    end) y = y + TH + 6
    Slider(y, T("reloadVal"), 1, 10, 5, function(v)
        -- 1 = en hızlı (~20x), 10 = normal hız
        Settings.Reload.Speed = v / 100
    end) y = y + TH + 14

    Content.CanvasSize = UDim2.new(0, 0, 0, y)

    local wm = Instance.new("TextLabel")
    wm.Size = UDim2.new(1, -24, 0, 22)
    wm.Position = UDim2.new(0, 12, 1, -28)
    wm.BackgroundTransparency = 1
    wm.Font = Enum.Font.Gotham
    wm.TextSize = 10
    wm.TextColor3 = Color3.fromRGB(65, 65, 95)
    wm.TextXAlignment = Enum.TextXAlignment.Center
    wm.Text = T("watermark")
    wm.Parent = MainFrame

    local nf = Instance.new("Frame")
    nf.Size = UDim2.new(0, 275, 0, 44)
    nf.Position = UDim2.new(0.5, -137, 1, 10)
    nf.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    nf.BorderSizePixel = 0
    nf.Parent = ScreenGui
    Instance.new("UICorner", nf).CornerRadius = UDim.new(0, 10)

    local nt = Instance.new("TextLabel")
    nt.Size = UDim2.new(1, 0, 1, 0)
    nt.BackgroundTransparency = 1
    nt.Font = Enum.Font.GothamBold
    nt.TextSize = 13
    nt.TextColor3 = Color3.fromRGB(255, 255, 255)
    nt.Text = T("loaded")
    nt.Parent = nf

    TweenService:Create(nf, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -137, 1, -62)
    }):Play()
    task.delay(3.5, function()
        TweenService:Create(nf, TweenInfo.new(0.4), { Position = UDim2.new(0.5, -137, 1, 10) }):Play()
        task.delay(0.5, function() nf:Destroy() end)
    end)
end

-- ============================================
-- INTRO → DİL → GUI
-- ============================================
PlayIntro(function()
    ShowLangSelect(function()
        BuildMainGui()
    end)
end)

print("[S-Productions] Arsenal Hub v1.1 - Yüklendi!")
