-- ============================================
--   S-Productions | Arsenal Hub v1.1
--   Mobil Optimize | TR/EN Dil Desteği
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
        title = "ARSENAL HUB",
        version = "v1.1  •  S-Productions",
        esp = "👁  Oyuncu ESP",
        speed = "⚡  Speed Hack",
        speedVal = "Hız Değeri",
        ammo = "🔫  Sınırsız Mermi",
        recoil = "🎯  No Recoil",
        esp_section = "ESP",
        speed_section = "SPEED",
        combat_section = "COMBAT",
        loaded = "✓  Arsenal Hub v1.1 Yüklendi!",
        watermark = "S-Productions  •  Arsenal Hub v1.1  •  Mobil",
        select_lang = "Dil Seçin",
        turkish = "Türkçe",
        english = "English",
    },
    EN = {
        title = "ARSENAL HUB",
        version = "v1.1  •  S-Productions",
        esp = "👁  Player ESP",
        speed = "⚡  Speed Hack",
        speedVal = "Speed Value",
        ammo = "🔫  Unlimited Ammo",
        recoil = "🎯  No Recoil",
        esp_section = "ESP",
        speed_section = "SPEED",
        combat_section = "COMBAT",
        loaded = "✓  Arsenal Hub v1.1 Loaded!",
        watermark = "S-Productions  •  Arsenal Hub v1.1  •  Mobile",
        select_lang = "Select Language",
        turkish = "Türkçe",
        english = "English",
    }
}
local currentLang = "TR"
local function T(key) return Lang[currentLang][key] end

-- ============================================
-- AYARLAR
-- ============================================
local Settings = {
    ESP   = { Enabled = false },
    Speed = { Enabled = false, Value = 50 },
    Ammo  = { Enabled = false },
    Recoil= { Enabled = false },
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
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. player.Name
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 140, 0, 70)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.Enabled = false
    billboard.Parent = ESPFolder

    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Parent = billboard

    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(1, 0, 0.13, 0)
    healthBg.Position = UDim2.new(0, 0, 0.8, 0)
    healthBg.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    healthBg.BorderSizePixel = 0
    healthBg.Parent = billboard
    Instance.new("UICorner", healthBg).CornerRadius = UDim.new(1, 0)

    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(50, 210, 50)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = healthBg
    Instance.new("UICorner", healthBar).CornerRadius = UDim.new(1, 0)

    ESPObjects[player.Name] = {Billboard = billboard, NameLabel = nameLabel, HealthBar = healthBar}

    RunService.Heartbeat:Connect(function()
        if not Settings.ESP.Enabled then billboard.Enabled = false return end
        local char = player.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                billboard.Adornee = hrp
                billboard.Enabled = true
                local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                healthBar.Size = UDim2.new(hp, 0, 1, 0)
                healthBar.BackgroundColor3 = Color3.fromRGB(255*(1-hp), 255*hp, 30)
                local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
                nameLabel.Text = player.Name .. "  [" .. dist .. "m]"
            else
                billboard.Enabled = false
            end
        else
            billboard.Enabled = false
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
-- SINIRSIZ MERMİ
-- ============================================
local ammoConnection
local function EnableAmmo()
    ammoConnection = RunService.Heartbeat:Connect(function()
        if not Settings.Ammo.Enabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        -- Arsenal silah sistemi
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            local ammoVal = tool:FindFirstChild("Ammo") or tool:FindFirstChild("ammo")
                or tool:FindFirstChild("AMMO") or tool:FindFirstChild("AmmoValue")
            if ammoVal and ammoVal:IsA("IntValue") or ammoVal and ammoVal:IsA("NumberValue") then
                if ammoVal.Value < 999 then
                    ammoVal.Value = 999
                end
            end
            -- Alternatif: RemoteEvent ile ammo sıfırlanmasını engelle
            local remote = tool:FindFirstChild("ReloadEvent") or tool:FindFirstChild("Reload")
            -- sadece client-side koruma
        end
    end)
end
EnableAmmo()

-- ============================================
-- NO RECOIL
-- ============================================
local recoilConnection
local originalCFrame

local function EnableRecoil()
    recoilConnection = RunService.RenderStepped:Connect(function()
        if not Settings.Recoil.Enabled then return end
        -- Kamera geri tepmesini sıfırla
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- Arsenal'de recoil kamera CFrame'i değiştirir
        -- Her frame'de pitch'i (yukarı kayma) sıfırlıyoruz
        local camCF = Camera.CFrame
        local x, y, z = camCF:ToEulerAnglesYXZ()
        -- Sadece X eksenindeki (yukarı/aşağı) değişimi sabitleme
        -- Bu yaklaşım Arsenal'de etkili çalışır
        if originalCFrame then
            local ox, oy, oz = originalCFrame:ToEulerAnglesYXZ()
            if math.abs(x - ox) > 0.04 then
                Camera.CFrame = CFrame.new(camCF.Position) *
                    CFrame.fromEulerAnglesYXZ(ox, y, z)
            end
        end
        originalCFrame = Camera.CFrame
    end)
end

local function DisableRecoil()
    if recoilConnection then recoilConnection:Disconnect() end
    originalCFrame = nil
end

-- ============================================
-- INTRO EKRANI GUI
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SProductionsHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = game.CoreGui

-- ============================================
-- ANİMASYONLU INTRO
-- ============================================
local IntroFrame = Instance.new("Frame")
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
IntroFrame.BorderSizePixel = 0
IntroFrame.ZIndex = 100
IntroFrame.Parent = ScreenGui

-- Arka plan gradient
local introGrad = Instance.new("UIGradient")
introGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 10)),
})
introGrad.Rotation = 135
introGrad.Parent = IntroFrame

-- S harfi (büyük, ortada)
local SLetter = Instance.new("TextLabel")
SLetter.Size = UDim2.new(0, 120, 0, 120)
SLetter.Position = UDim2.new(0.5, -60, 0.5, -100)
SLetter.BackgroundTransparency = 1
SLetter.Font = Enum.Font.GothamBold
SLetter.TextSize = 100
SLetter.TextColor3 = Color3.fromRGB(210, 30, 30)
SLetter.Text = "S"
SLetter.TextTransparency = 1
SLetter.ZIndex = 101
SLetter.Parent = IntroFrame

-- Çizgi (S altında)
local introLine = Instance.new("Frame")
introLine.Size = UDim2.new(0, 0, 0, 3)
introLine.Position = UDim2.new(0.5, 0, 0.5, 15)
introLine.BackgroundColor3 = Color3.fromRGB(210, 30, 30)
introLine.BorderSizePixel = 0
introLine.AnchorPoint = Vector2.new(0.5, 0.5)
introLine.ZIndex = 101
introLine.Parent = IntroFrame
Instance.new("UICorner", introLine).CornerRadius = UDim.new(1, 0)

-- S-Productions yazısı
local introText = Instance.new("TextLabel")
introText.Size = UDim2.new(1, 0, 0, 50)
introText.Position = UDim2.new(0, 0, 0.5, 30)
introText.BackgroundTransparency = 1
introText.Font = Enum.Font.GothamBold
introText.TextSize = isMobile and 28 or 32
introText.TextColor3 = Color3.fromRGB(255, 255, 255)
introText.Text = "S-Productions"
introText.TextTransparency = 1
introText.ZIndex = 101
introText.Parent = IntroFrame

-- Alt yazı
local introSub = Instance.new("TextLabel")
introSub.Size = UDim2.new(1, 0, 0, 30)
introSub.Position = UDim2.new(0, 0, 0.5, 78)
introSub.BackgroundTransparency = 1
introSub.Font = Enum.Font.Gotham
introSub.TextSize = isMobile and 13 or 15
introSub.TextColor3 = Color3.fromRGB(180, 30, 30)
introSub.Text = "Arsenal Hub  v1.1"
introSub.TextTransparency = 1
introSub.ZIndex = 101
introSub.Parent = IntroFrame

-- ============================================
-- INTRO ANİMASYON SIRASI
-- ============================================
local function PlayIntro(onFinish)
    -- S harfi belirir
    task.delay(0.3, function()
        TweenService:Create(SLetter, TweenInfo.new(0.6, Enum.EasingStyle.Back), {
            TextTransparency = 0,
            TextSize = 100,
        }):Play()
    end)

    -- Çizgi genişler
    task.delay(0.8, function()
        TweenService:Create(introLine, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
            Size = UDim2.new(0, 280, 0, 3),
        }):Play()
    end)

    -- S-Productions yazısı belirir
    task.delay(1.1, function()
        TweenService:Create(introText, TweenInfo.new(0.5), {
            TextTransparency = 0,
        }):Play()
    end)

    -- Alt yazı belirir
    task.delay(1.4, function()
        TweenService:Create(introSub, TweenInfo.new(0.5), {
            TextTransparency = 0,
        }):Play()
    end)

    -- Hepsi solar ve intro kapanır
    task.delay(2.8, function()
        TweenService:Create(SLetter, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(introLine, TweenInfo.new(0.5), {Size = UDim2.new(0, 0, 0, 3)}):Play()
        TweenService:Create(introText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(introSub, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(IntroFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
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
    local LangFrame = Instance.new("Frame")
    LangFrame.Size = UDim2.new(0, 280, 0, 200)
    LangFrame.Position = UDim2.new(0.5, -140, 0.5, -100)
    LangFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    LangFrame.BorderSizePixel = 0
    LangFrame.BackgroundTransparency = 1
    LangFrame.ZIndex = 50
    LangFrame.Parent = ScreenGui
    Instance.new("UICorner", LangFrame).CornerRadius = UDim.new(0, 16)

    local langStroke = Instance.new("UIStroke")
    langStroke.Color = Color3.fromRGB(210, 30, 30)
    langStroke.Thickness = 2
    langStroke.Parent = LangFrame

    local langTitle = Instance.new("TextLabel")
    langTitle.Size = UDim2.new(1, 0, 0, 55)
    langTitle.BackgroundTransparency = 1
    langTitle.Font = Enum.Font.GothamBold
    langTitle.TextSize = isMobile and 18 or 16
    langTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    langTitle.Text = "🌐  Dil Seçin / Select Language"
    langTitle.TextTransparency = 1
    langTitle.ZIndex = 51
    langTitle.Parent = LangFrame

    local function MakeLangBtn(text, yPos, lang)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.8, 0, 0, isMobile and 52 or 44)
        btn.Position = UDim2.new(0.1, 0, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 38)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = isMobile and 17 or 15
        btn.TextColor3 = Color3.fromRGB(220, 220, 240)
        btn.Text = text
        btn.BorderSizePixel = 0
        btn.BackgroundTransparency = 1
        btn.ZIndex = 51
        btn.Parent = LangFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

        local bStroke = Instance.new("UIStroke")
        bStroke.Color = Color3.fromRGB(40, 40, 70)
        bStroke.Thickness = 1
        bStroke.Parent = btn

        btn.MouseButton1Click:Connect(function()
            currentLang = lang
            TweenService:Create(LangFrame, TweenInfo.new(0.4), {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 280, 0, 0),
            }):Play()
            TweenService:Create(langTitle, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            task.delay(0.4, function()
                LangFrame:Destroy()
                onSelect()
            end)
        end)

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(210, 30, 30),
                BackgroundTransparency = 0,
            }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(20, 20, 38),
                BackgroundTransparency = 0,
            }):Play()
        end)

        return btn
    end

    -- Animate in
    TweenService:Create(LangFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        BackgroundTransparency = 0,
    }):Play()
    task.delay(0.2, function()
        TweenService:Create(langTitle, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    end)

    local trBtn = MakeLangBtn("🇹🇷  Türkçe", 65, "TR")
    local enBtn = MakeLangBtn("🇬🇧  English", 128, "EN")

    -- Butonları da animate et
    task.delay(0.3, function()
        TweenService:Create(trBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        TweenService:Create(enBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    end)
end

-- ============================================
-- ANA GUI FONKSİYONU
-- ============================================
local function BuildMainGui()
    local FRAME_W = isMobile and 320 or 300
    local FRAME_H = isMobile and 440 or 420
    local TOGGLE_H = isMobile and 62 or 55
    local TEXT_SIZE = isMobile and 15 or 13
    local TITLE_SIZE = isMobile and 19 or 17

    -- Ana Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, FRAME_W, 0, FRAME_H)
    MainFrame.Position = UDim2.new(0.5, -FRAME_W/2, 0.5, -FRAME_H/2)
    MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.BackgroundTransparency = 1
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(210, 35, 35)
    mainStroke.Thickness = 1.8
    mainStroke.Parent = MainFrame

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 14, 28)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 16)),
    })
    grad.Rotation = 135
    grad.Parent = MainFrame

    -- Animate in
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        BackgroundTransparency = 0,
    }):Play()

    -- Başlık
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 65)
    TitleBar.BackgroundColor3 = Color3.fromRGB(16, 16, 30)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 14)

    local accentLine = Instance.new("Frame")
    accentLine.Size = UDim2.new(0, 4, 0.65, 0)
    accentLine.Position = UDim2.new(0, 14, 0.175, 0)
    accentLine.BackgroundColor3 = Color3.fromRGB(210, 35, 35)
    accentLine.BorderSizePixel = 0
    accentLine.Parent = TitleBar
    Instance.new("UICorner", accentLine).CornerRadius = UDim.new(1, 0)

    local CompanyLabel = Instance.new("TextLabel")
    CompanyLabel.Size = UDim2.new(1, -90, 0, 20)
    CompanyLabel.Position = UDim2.new(0, 26, 0, 8)
    CompanyLabel.BackgroundTransparency = 1
    CompanyLabel.Font = Enum.Font.GothamBold
    CompanyLabel.TextSize = 10
    CompanyLabel.TextColor3 = Color3.fromRGB(180, 35, 35)
    CompanyLabel.TextXAlignment = Enum.TextXAlignment.Left
    CompanyLabel.Text = "S-PRODUCTIONS"
    CompanyLabel.Parent = TitleBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -90, 0, 28)
    TitleLabel.Position = UDim2.new(0, 26, 0, 26)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = TITLE_SIZE
    TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Text = "⚡ " .. T("title") .. "  v1.1"
    TitleLabel.Parent = TitleBar

    -- Minimize butonu
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, isMobile and 36 or 30, 0, isMobile and 36 or 30)
    MinBtn.Position = UDim2.new(1, -(isMobile and 86 or 74), 0.5, isMobile and -18 or -15)
    MinBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 70)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 14
    MinBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
    MinBtn.Text = "▼"
    MinBtn.BorderSizePixel = 0
    MinBtn.Parent = TitleBar
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

    -- Kapat
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, isMobile and 36 or 30, 0, isMobile and 36 or 30)
    CloseBtn.Position = UDim2.new(1, -(isMobile and 44 or 36), 0.5, isMobile and -18 or -15)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Text = "✕"
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Parent = TitleBar
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, FRAME_W, 0, 0),
        }):Play()
        task.delay(0.35, function() ScreenGui:Destroy() end)
    end)

    -- Minimize Frame
    local MinFrame = Instance.new("Frame")
    MinFrame.Size = UDim2.new(0, FRAME_W, 0, 55)
    MinFrame.Position = MainFrame.Position
    MinFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
    MinFrame.BorderSizePixel = 0
    MinFrame.Visible = false
    MinFrame.Active = true
    MinFrame.Draggable = true
    MinFrame.Parent = ScreenGui
    Instance.new("UICorner", MinFrame).CornerRadius = UDim.new(0, 12)

    local minStroke = Instance.new("UIStroke")
    minStroke.Color = Color3.fromRGB(210, 35, 35)
    minStroke.Thickness = 1.5
    minStroke.Parent = MinFrame

    local MinLabel = Instance.new("TextLabel")
    MinLabel.Size = UDim2.new(1, -80, 1, 0)
    MinLabel.Position = UDim2.new(0, 16, 0, 0)
    MinLabel.BackgroundTransparency = 1
    MinLabel.Font = Enum.Font.GothamBold
    MinLabel.TextSize = 14
    MinLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
    MinLabel.TextXAlignment = Enum.TextXAlignment.Left
    MinLabel.Text = "⚡ ARSENAL HUB  •  S-PRODUCTIONS"
    MinLabel.Parent = MinFrame

    local ExpandBtn = Instance.new("TextButton")
    ExpandBtn.Size = UDim2.new(0, isMobile and 36 or 30, 0, isMobile and 36 or 30)
    ExpandBtn.Position = UDim2.new(1, -(isMobile and 44 or 36), 0.5, isMobile and -18 or -15)
    ExpandBtn.BackgroundColor3 = Color3.fromRGB(30, 110, 30)
    ExpandBtn.Font = Enum.Font.GothamBold
    ExpandBtn.TextSize = 14
    ExpandBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExpandBtn.Text = "▲"
    ExpandBtn.BorderSizePixel = 0
    ExpandBtn.Parent = MinFrame
    Instance.new("UICorner", ExpandBtn).CornerRadius = UDim.new(0, 8)

    MinBtn.MouseButton1Click:Connect(function()
        MinFrame.Position = MainFrame.Position
        MainFrame.Visible = false
        MinFrame.Visible = true
    end)
    ExpandBtn.MouseButton1Click:Connect(function()
        MainFrame.Position = MinFrame.Position
        MinFrame.Visible = false
        MainFrame.Visible = true
    end)

    -- İçerik
    local Content = Instance.new("ScrollingFrame")
    Content.Size = UDim2.new(1, 0, 1, -70)
    Content.Position = UDim2.new(0, 0, 0, 70)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.ScrollBarThickness = isMobile and 4 or 3
    Content.ScrollBarImageColor3 = Color3.fromRGB(210, 35, 35)
    Content.ScrollingDirection = Enum.ScrollingDirection.Y
    Content.Parent = MainFrame

    -- Yardımcılar
    local function SectionLabel(yPos, text)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -28, 0, 24)
        lbl.Position = UDim2.new(0, 14, 0, yPos)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 10
        lbl.TextColor3 = Color3.fromRGB(200, 35, 35)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Text = "▸ " .. string.upper(text)
        lbl.Parent = Content
    end

    local function CreateToggle(yPos, labelText, onToggle)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -24, 0, TOGGLE_H)
        frame.Position = UDim2.new(0, 12, 0, yPos)
        frame.BackgroundColor3 = Color3.fromRGB(16, 16, 30)
        frame.BorderSizePixel = 0
        frame.Parent = Content
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

        local fs = Instance.new("UIStroke")
        fs.Color = Color3.fromRGB(30, 30, 55)
        fs.Thickness = 1
        fs.Parent = frame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -80, 1, 0)
        label.Position = UDim2.new(0, 16, 0, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextSize = TEXT_SIZE
        label.TextColor3 = Color3.fromRGB(210, 210, 235)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Text = labelText
        label.Parent = frame

        local bgW = isMobile and 54 or 46
        local bgH = isMobile and 30 or 24
        local circW = isMobile and 22 or 18

        local toggleBg = Instance.new("Frame")
        toggleBg.Size = UDim2.new(0, bgW, 0, bgH)
        toggleBg.Position = UDim2.new(1, -(bgW+12), 0.5, -bgH/2)
        toggleBg.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
        toggleBg.BorderSizePixel = 0
        toggleBg.Parent = frame
        Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

        local circle = Instance.new("Frame")
        circle.Size = UDim2.new(0, circW, 0, circW)
        circle.Position = UDim2.new(0, 4, 0.5, -circW/2)
        circle.BackgroundColor3 = Color3.fromRGB(130, 130, 160)
        circle.BorderSizePixel = 0
        circle.Parent = toggleBg
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

        local toggled = false
        local onPos = bgW - circW - 4

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = frame

        btn.MouseButton1Click:Connect(function()
            toggled = not toggled
            TweenService:Create(circle, TweenInfo.new(0.18), {
                Position = toggled and UDim2.new(0, onPos, 0.5, -circW/2) or UDim2.new(0, 4, 0.5, -circW/2),
                BackgroundColor3 = toggled and Color3.fromRGB(255,255,255) or Color3.fromRGB(130,130,160),
            }):Play()
            TweenService:Create(toggleBg, TweenInfo.new(0.18), {
                BackgroundColor3 = toggled and Color3.fromRGB(200, 30, 30) or Color3.fromRGB(40,40,65),
            }):Play()
            onToggle(toggled)
        end)
    end

    local function CreateSlider(yPos, labelText, minVal, maxVal, defaultVal, onChange)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -24, 0, TOGGLE_H)
        frame.Position = UDim2.new(0, 12, 0, yPos)
        frame.BackgroundColor3 = Color3.fromRGB(16, 16, 30)
        frame.BorderSizePixel = 0
        frame.Parent = Content
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

        local fs = Instance.new("UIStroke")
        fs.Color = Color3.fromRGB(30, 30, 55)
        fs.Thickness = 1
        fs.Parent = frame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.68, 0, 0, 22)
        label.Position = UDim2.new(0, 16, 0, 6)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextSize = TEXT_SIZE
        label.TextColor3 = Color3.fromRGB(195, 195, 215)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Text = labelText
        label.Parent = frame

        local valLabel = Instance.new("TextLabel")
        valLabel.Size = UDim2.new(0.3, -10, 0, 22)
        valLabel.Position = UDim2.new(0.7, 0, 0, 6)
        valLabel.BackgroundTransparency = 1
        valLabel.Font = Enum.Font.GothamBold
        valLabel.TextSize = TEXT_SIZE
        valLabel.TextColor3 = Color3.fromRGB(200, 30, 30)
        valLabel.TextXAlignment = Enum.TextXAlignment.Right
        valLabel.Text = tostring(defaultVal)
        valLabel.Parent = frame

        local trackH = isMobile and 8 or 6
        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, -32, 0, trackH)
        track.Position = UDim2.new(0, 16, 0, TOGGLE_H - trackH - 10)
        track.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        track.BorderSizePixel = 0
        track.Parent = frame
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local ratio = (defaultVal - minVal) / (maxVal - minVal)
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
        fill.BorderSizePixel = 0
        fill.Parent = track
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local knobSize = isMobile and 20 or 14
        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, knobSize, 0, knobSize)
        knob.Position = UDim2.new(ratio, -knobSize/2, 0.5, -knobSize/2)
        knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
        knob.BorderSizePixel = 0
        knob.ZIndex = 2
        knob.Parent = track
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local dragging = false
        local touchBtn = Instance.new("TextButton")
        touchBtn.Size = UDim2.new(1, 0, 4, 0)
        touchBtn.Position = UDim2.new(0, 0, 0.5, -trackH*2)
        touchBtn.BackgroundTransparency = 1
        touchBtn.Text = ""
        touchBtn.ZIndex = 3
        touchBtn.Parent = track

        local function updateSlider(inputX)
            local r = math.clamp((inputX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local val = math.floor(minVal + r * (maxVal - minVal))
            fill.Size = UDim2.new(r, 0, 1, 0)
            knob.Position = UDim2.new(r, -knobSize/2, 0.5, -knobSize/2)
            valLabel.Text = tostring(val)
            onChange(val)
        end

        touchBtn.MouseButton1Down:Connect(function() dragging = true end)
        touchBtn.TouchStarted:Connect(function(t) dragging = true updateSlider(t.Position.X) end)
        touchBtn.TouchMoved:Connect(function(t) if dragging then updateSlider(t.Position.X) end end)
        touchBtn.TouchEnded:Connect(function() dragging = false end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or
               i.UserInputType == Enum.UserInputType.Touch then dragging = false end
        end)
        RunService.Heartbeat:Connect(function()
            if dragging then updateSlider(UserInputService:GetMouseLocation().X) end
        end)
    end

    -- ============================================
    -- TOGGLE VE SLIDERLAR
    -- ============================================
    local y = 0

    -- ESP
    SectionLabel(y, T("esp_section")) y = y + 26
    CreateToggle(y, T("esp"), function(on)
        Settings.ESP.Enabled = on
        if not on then for _, e in pairs(ESPObjects) do e.Billboard.Enabled = false end end
    end) y = y + TOGGLE_H + 8

    -- SPEED
    SectionLabel(y, T("speed_section")) y = y + 26
    CreateToggle(y, T("speed"), function(on)
        Settings.Speed.Enabled = on
        if not on then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = 16 end
            end
        end
    end) y = y + TOGGLE_H + 6
    CreateSlider(y, T("speedVal"), 16, 200, 50, function(val)
        Settings.Speed.Value = val
    end) y = y + TOGGLE_H + 8

    -- COMBAT
    SectionLabel(y, T("combat_section")) y = y + 26
    CreateToggle(y, T("ammo"), function(on)
        Settings.Ammo.Enabled = on
    end) y = y + TOGGLE_H + 6
    CreateToggle(y, T("recoil"), function(on)
        Settings.Recoil.Enabled = on
        if on then EnableRecoil() else DisableRecoil() end
    end) y = y + TOGGLE_H + 14

    Content.CanvasSize = UDim2.new(0, 0, 0, y)

    -- Watermark
    local wm = Instance.new("TextLabel")
    wm.Size = UDim2.new(1, -24, 0, 22)
    wm.Position = UDim2.new(0, 12, 1, -28)
    wm.BackgroundTransparency = 1
    wm.Font = Enum.Font.Gotham
    wm.TextSize = 10
    wm.TextColor3 = Color3.fromRGB(70, 70, 100)
    wm.TextXAlignment = Enum.TextXAlignment.Center
    wm.Text = T("watermark")
    wm.Parent = MainFrame

    -- Yüklendi bildirimi
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 270, 0, 44)
    notif.Position = UDim2.new(0.5, -135, 1, 10)
    notif.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    notif.BorderSizePixel = 0
    notif.Parent = ScreenGui
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 10)

    local notifTxt = Instance.new("TextLabel")
    notifTxt.Size = UDim2.new(1, 0, 1, 0)
    notifTxt.BackgroundTransparency = 1
    notifTxt.Font = Enum.Font.GothamBold
    notifTxt.TextSize = 13
    notifTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifTxt.Text = T("loaded")
    notifTxt.Parent = notif

    TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -135, 1, -60)
    }):Play()
    task.delay(3.5, function()
        TweenService:Create(notif, TweenInfo.new(0.4), {Position = UDim2.new(0.5, -135, 1, 10)}):Play()
        task.delay(0.5, function() notif:Destroy() end)
    end)
end

-- ============================================
-- SIRAYA KOY: INTRO → DİL → ANA GUI
-- ============================================
PlayIntro(function()
    ShowLangSelect(function()
        BuildMainGui()
    end)
end)

print("[S-Productions] Arsenal Hub v1.1 - Yüklendi!")
