pcall(function()
    loadstring(game:HttpGet("https://pastebin.com/raw/VgbrkkM2"))()
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local camera = workspace.CurrentCamera
local player = Players.LocalPlayer

local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title=title, Text=text, Duration=3})
    end)
end

local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Eps1llonUI/refs/heads/main/UILibrary.lua"))()

local AnimationPresets = {
    toggleOn = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    toggleOff = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    sliderMove = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    buttonHover = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    buttonClick = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
    guiResize = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    colorShift = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
}

local premiumGradientColors = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 170, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(74, 255, 230))
}

local combatGradientColors = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 170, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(74, 200, 255))
}

local sectionNames = {"Configuration","Combat","ESP","Inventory","Misc","Script Chat","UI Settings"}
local iconData = {
    Configuration = "134572329997100",
    Combat = "94883448905030",
    ESP = "92313485402528",
    Inventory = "135628846657243",
    Misc = "121583805460244",
    ["Script Chat"] = "15577991768",
    ["UI Settings"] = "93991072023597",
}

local sections = {}
for _, name in ipairs(sectionNames) do
    sections[name] = UILib:GetSection(name)
end

for name, section in pairs(sections) do
    for _, c in ipairs(section:GetChildren()) do
        if c:IsA("TextLabel") and c.Name == "__SectionTitle" then c:Destroy() end
        if c:IsA("ImageLabel") and c.Name == "__SectionIcon" then c:Destroy() end
        if c:IsA("Frame") and c.Name == "__SectionHeaderContainer" then c:Destroy() end
    end
    
    local header = Instance.new("Frame")
    header.Name = "__SectionHeaderContainer"
    header.Size = UDim2.new(1, -40, 0, 38)
    header.Position = UDim2.new(0, 20, 0, 10)
    header.BackgroundTransparency = 1
    header.Parent = section
    
    local layout = Instance.new("UIListLayout", header)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 6)
    
    local icon = Instance.new("ImageLabel")
    icon.Name = "__SectionIcon"
    icon.Size = UDim2.new(0, 28, 0, 28)
    icon.BackgroundTransparency = 1
    icon.Image = iconData[name] and ("rbxassetid://"..iconData[name]) or ""
    icon.ImageColor3 = Color3.fromRGB(74, 177, 255)
    icon.Parent = header
    
    coroutine.wrap(function()
        while true do
            TweenService:Create(icon, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {ImageTransparency = 0.3}):Play()
            wait(2)
            TweenService:Create(icon, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {ImageTransparency = 0}):Play()
            wait(2)
        end
    end)()
    
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Name = "__SectionTitle"
    sectionTitle.Size = UDim2.new(0, 200, 1, 0)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = name
    sectionTitle.TextColor3 = Color3.fromRGB(215, 235, 255)
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.TextSize = 24
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.TextYAlignment = Enum.TextYAlignment.Center
    sectionTitle.Parent = header
    
    local titleGlow = sectionTitle:Clone()
    titleGlow.Name = "__TitleGlow"
    titleGlow.TextColor3 = Color3.fromRGB(74, 177, 255)
    titleGlow.TextTransparency = 0.8
    titleGlow.ZIndex = sectionTitle.ZIndex - 1
    titleGlow.Parent = header
end

local function createRippleEffect(parent, position)
    local ripple = Instance.new("Frame")
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = position
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.ZIndex = 10
    ripple.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    local expandTween = TweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 100, 0, 100),
        Position = UDim2.new(position.X.Scale, position.X.Offset - 50, position.Y.Scale, position.Y.Offset - 50),
        BackgroundTransparency = 1
    })
    
    expandTween:Play()
    expandTween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

local function createEnhancedToggle(parent, position, onToggle)
    local toggleBar = Instance.new("Frame", parent)
    toggleBar.Size = UDim2.new(0, 46, 0, 20)
    toggleBar.Position = UDim2.new(position.X.Scale, position.X.Offset + 13, position.Y.Scale, position.Y.Offset)
    toggleBar.BackgroundColor3 = Color3.fromRGB(22, 28, 38)
    toggleBar.BorderSizePixel = 0
    Instance.new('UICorner', toggleBar).CornerRadius = UDim.new(1, 999)

    local toggleKnob = Instance.new("Frame", toggleBar)
    toggleKnob.Size = UDim2.new(0, 18, 0, 18)
    toggleKnob.Position = UDim2.new(0, 1, 0, 1)
    toggleKnob.BackgroundColor3 = Color3.fromRGB(245,245,250)
    toggleKnob.BorderSizePixel = 0
    Instance.new('UICorner', toggleKnob).CornerRadius = UDim.new(1, 999)

    local knobShadow = Instance.new("Frame", toggleKnob)
    knobShadow.Size = UDim2.new(1, 4, 1, 4)
    knobShadow.Position = UDim2.new(0, -2, 0, 1)
    knobShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    knobShadow.BackgroundTransparency = 0.8
    knobShadow.BorderSizePixel = 0
    knobShadow.ZIndex = toggleKnob.ZIndex - 1
    Instance.new('UICorner', knobShadow).CornerRadius = UDim.new(1, 999)

    local isOn = false

    toggleBar.MouseEnter:Connect(function()
        TweenService:Create(toggleBar, AnimationPresets.buttonHover, {
            Size = UDim2.new(0, 50, 0, 24)
        }):Play()
    end)

    toggleBar.MouseLeave:Connect(function()
        TweenService:Create(toggleBar, AnimationPresets.buttonHover, {
            Size = UDim2.new(0, 46, 0, 20)
        }):Play()
    end)

    local function setToggle(val)
        isOn = val

        local targetBarColor = val and Color3.fromRGB(80, 170, 255) or Color3.fromRGB(22, 28, 38)
        local targetKnobPos = val and UDim2.new(1, -19, 0, 1) or UDim2.new(0, 1, 0, 1)
        local targetKnobColor = val and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(245, 245, 250)

        TweenService:Create(toggleBar, AnimationPresets.toggleOn, {
            BackgroundColor3 = targetBarColor
        }):Play()

        TweenService:Create(toggleKnob, AnimationPresets.toggleOn, {
            Position = targetKnobPos,
            BackgroundColor3 = targetKnobColor,
            Size = val and UDim2.new(0, 20, 0, 20) or UDim2.new(0, 18, 0, 18)
        }):Play()

        TweenService:Create(toggleKnob, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, val and 22 or 20, 0, val and 22 or 20)
        }):Play()

        wait(0.1)
        TweenService:Create(toggleKnob, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, val and 20 or 18, 0, val and 20 or 18)
        }):Play()

        if onToggle then onToggle(val) end
    end

    setToggle(false)

    toggleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            createRippleEffect(toggleBar, UDim2.new(0.5, 0, 0.5, 0))
            setToggle(not isOn)
        end
    end)

    return setToggle, toggleBar
end

local function createEnhancedDropdown(parent, position, options, onSelect)
    local dropdownFrame = Instance.new("Frame", parent)
    dropdownFrame.Size = UDim2.new(0, 200, 0, 36)
    dropdownFrame.Position = position
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(33, 41, 57)
    dropdownFrame.BorderSizePixel = 0
    Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 8)

    local dropdownLabel = Instance.new("TextLabel", dropdownFrame)
    dropdownLabel.Size = UDim2.new(1, -30, 1, 0)
    dropdownLabel.Position = UDim2.new(0, 10, 0, 0)
    dropdownLabel.Text = options[1] or "Select Option"
    dropdownLabel.TextColor3 = Color3.fromRGB(220, 240, 255)
    dropdownLabel.BackgroundTransparency = 1
    dropdownLabel.Font = Enum.Font.GothamBold
    dropdownLabel.TextSize = 14
    dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left

    local dropdownArrow = Instance.new("TextLabel", dropdownFrame)
    dropdownArrow.Size = UDim2.new(0, 20, 1, 0)
    dropdownArrow.Position = UDim2.new(1, -25, 0, 0)
    dropdownArrow.Text = "▼"
    dropdownArrow.TextColor3 = Color3.fromRGB(220, 240, 255)
    dropdownArrow.BackgroundTransparency = 1
    dropdownArrow.Font = Enum.Font.GothamBold
    dropdownArrow.TextSize = 12
    dropdownArrow.TextXAlignment = Enum.TextXAlignment.Center

    local dropdownList = Instance.new("Frame", dropdownFrame)
    dropdownList.Size = UDim2.new(1, 0, 0, #options * 32)
    dropdownList.Position = UDim2.new(0, 0, 1, 5)
    dropdownList.BackgroundColor3 = Color3.fromRGB(26, 28, 33)
    dropdownList.BorderSizePixel = 0
    dropdownList.Visible = false
    dropdownList.ZIndex = 100
    Instance.new("UICorner", dropdownList).CornerRadius = UDim.new(0, 8)

    local isOpen = false

    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton", dropdownList)
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 32)
        optionButton.Text = option
        optionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        optionButton.BackgroundColor3 = Color3.fromRGB(26, 28, 33)
        optionButton.BorderSizePixel = 0
        optionButton.Font = Enum.Font.Gotham
        optionButton.TextSize = 14
        optionButton.ZIndex = 101

        if i == 1 then
            Instance.new("UICorner", optionButton).CornerRadius = UDim.new(0, 8)
        elseif i == #options then
            Instance.new("UICorner", optionButton).CornerRadius = UDim.new(0, 8)
        end

        optionButton.MouseEnter:Connect(function()
            TweenService:Create(optionButton, AnimationPresets.buttonHover, {
                BackgroundColor3 = Color3.fromRGB(80, 170, 255),
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        end)

        optionButton.MouseLeave:Connect(function()
            TweenService:Create(optionButton, AnimationPresets.buttonHover, {
                BackgroundColor3 = Color3.fromRGB(26, 28, 33),
                TextColor3 = Color3.fromRGB(200, 200, 200)
            }):Play()
        end)

        optionButton.MouseButton1Click:Connect(function()
            dropdownLabel.Text = option
            dropdownList.Visible = false
            isOpen = false
            dropdownArrow.Text = "▼"
            if onSelect then onSelect(option, i) end
        end)
    end

    dropdownFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isOpen = not isOpen
            dropdownList.Visible = isOpen
            dropdownArrow.Text = isOpen and "▲" or "▼"
        end
    end)

    return dropdownFrame
end

local function setupEnhancedSliderDrag(bar, pill, min, max, onChange)
    local dragging = false
    local hovered = false

    pill.MouseEnter:Connect(function()
        hovered = true
        TweenService:Create(pill, AnimationPresets.buttonHover, {
            Size = UDim2.new(pill.Size.X.Scale, pill.Size.X.Offset, 0, 40)
        }):Play()

        local glow = Instance.new("Frame")
        glow.Name = "SliderGlow"
        glow.Size = UDim2.new(1, 10, 1, 10)
        glow.Position = UDim2.new(0, -5, 0, -5)
        glow.BackgroundColor3 = Color3.fromRGB(74, 177, 255)
        glow.BackgroundTransparency = 0.8
        glow.BorderSizePixel = 0
        glow.ZIndex = pill.ZIndex - 1
        glow.Parent = pill
        Instance.new("UICorner", glow).CornerRadius = UDim.new(1, 999)

        TweenService:Create(glow, AnimationPresets.colorShift, {
            BackgroundTransparency = 0.6
        }):Play()
    end)

    pill.MouseLeave:Connect(function()
        hovered = false
        if not dragging then
            TweenService:Create(pill, AnimationPresets.buttonHover, {
                Size = UDim2.new(pill.Size.X.Scale, pill.Size.X.Offset, 0, 36)
            }):Play()

            local glow = pill:FindFirstChild("SliderGlow")
            if glow then
                TweenService:Create(glow, AnimationPresets.buttonHover, {
                    BackgroundTransparency = 1
                }):Play()
                game:GetService("Debris"):AddItem(glow, 0.15)
            end
        end
    end)

    local function updateInput(input)
        local absPos = pill.AbsolutePosition.X
        local absSize = pill.AbsoluteSize.X
        local percent = math.clamp((input.Position.X - absPos) / absSize, 0, 1)
        local value = math.floor(min + (max - min) * percent + 0.5)

        TweenService:Create(bar, AnimationPresets.sliderMove, {
            Size = UDim2.new(percent, 0, 1, 0)
        }):Play()

        if onChange then onChange(value, percent) end
    end

    pill.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            createRippleEffect(pill, UDim2.new(0, input.Position.X - pill.AbsolutePosition.X, 0, input.Position.Y - pill.AbsolutePosition.Y))
            updateInput(input)

            TweenService:Create(pill, AnimationPresets.buttonClick, {
                Size = UDim2.new(pill.Size.X.Scale, pill.Size.X.Offset, 0, 42)
            }):Play()

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if not hovered then
                        TweenService:Create(pill, AnimationPresets.buttonHover, {
                            Size = UDim2.new(pill.Size.X.Scale, pill.Size.X.Offset, 0, 36)
                        }):Play()
                    end
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateInput(input)
        end
    end)

    pill.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            if not hovered then
                TweenService:Create(pill, AnimationPresets.buttonHover, {
                    Size = UDim2.new(pill.Size.X.Scale, pill.Size.X.Offset, 0, 36)
                }):Play()
            end
        end
    end)
end

local speedwalkEnabled, currentSpeed = false, 12
do
    local section = sections["Configuration"]
    
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -40, 0, 54)
    row.Position = UDim2.new(0, 20, 0, 60)
    row.BackgroundColor3 = Color3.fromRGB(26, 28, 33)
    row.BackgroundTransparency = 0.08
    row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 13)
    row.Parent = section
    
    local rowGlow = Instance.new("Frame")
    rowGlow.Size = UDim2.new(1, 4, 1, 4)
    rowGlow.Position = UDim2.new(0, -2, 0, -2)
    rowGlow.BackgroundColor3 = Color3.fromRGB(74, 177, 255)
    rowGlow.BackgroundTransparency = 0.95
    rowGlow.BorderSizePixel = 0
    rowGlow.ZIndex = row.ZIndex - 1
    rowGlow.Parent = row
    Instance.new("UICorner", rowGlow).CornerRadius = UDim.new(0, 15)
    
    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(0, 115, 1, 0)
    label.Position = UDim2.new(0, 13, 0, 0)
    label.Text = "Walkspeed"
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local min, max, default = 4, 15, 12
    local sliderPill = Instance.new("Frame", row)
    sliderPill.Size = UDim2.new(0, 170, 0, 36)
    sliderPill.Position = UDim2.new(0, 132, 0.5, -18)
    sliderPill.BackgroundColor3 = Color3.fromRGB(33, 41, 57)
    sliderPill.BorderSizePixel = 0
    Instance.new("UICorner", sliderPill).CornerRadius = UDim.new(1, 999)
    
    local pillShadow = Instance.new("ImageLabel", sliderPill)
    pillShadow.BackgroundTransparency = 1
    pillShadow.Image = "rbxassetid://1316045217"
    pillShadow.Size = UDim2.new(1, 8, 1, 8)
    pillShadow.Position = UDim2.new(0, -4, 0, -2)
    pillShadow.ImageTransparency = 0.78
    pillShadow.ZIndex = 0
    
    local sliderFill = Instance.new("Frame", sliderPill)
    sliderFill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(80, 170, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.ZIndex = 2
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 999)
    
    local grad = Instance.new("UIGradient", sliderFill)
    grad.Color = premiumGradientColors
    
    local valueLabel = Instance.new("TextLabel", sliderPill)
    valueLabel.Size = UDim2.new(0, 48, 1, 0)
    valueLabel.Position = UDim2.new(1, -50, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(220, 240, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 18
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.ZIndex = 3
    
    setupEnhancedSliderDrag(sliderFill, sliderPill, min, max, function(val, percent)
        currentSpeed = val
        TweenService:Create(valueLabel, AnimationPresets.colorShift, {
            TextColor3 = Color3.fromRGB(74, 177, 255)
        }):Play()
        valueLabel.Text = tostring(val)
        wait(0.1)
        TweenService:Create(valueLabel, AnimationPresets.colorShift, {
            TextColor3 = Color3.fromRGB(220, 240, 255)
        }):Play()
    end)
    
    local setToggle = createEnhancedToggle(row, UDim2.new(0, 301, 0.5, -10), function(val)
        speedwalkEnabled = val
        TweenService:Create(rowGlow, AnimationPresets.colorShift, {
            BackgroundTransparency = val and 0.85 or 0.95
        }):Play()
    end)
end

RunService.RenderStepped:Connect(function(dt)
    if speedwalkEnabled then
        local c = player.Character
        if c then
            local h = c:FindFirstChildOfClass("Humanoid")
            local r = c:FindFirstChild("HumanoidRootPart")
            if h and r then
                local d = h.MoveDirection
                if d.Magnitude > .1 then
                    r.CFrame += d.Unit * currentSpeed * dt
                end
            end
        end
    end
end)

local jumppowerEnabled, currentJump, lastJump = false, 50, 0
do
    local section = sections["Configuration"]
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -40, 0, 54)
    row.Position = UDim2.new(0, 20, 0, 120)
    row.BackgroundColor3 = Color3.fromRGB(26, 28, 33)
    row.BackgroundTransparency = 0.08
    row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 13)
    row.Parent = section
    
    local rowGlow = Instance.new("Frame")
    rowGlow.Size = UDim2.new(1, 4, 1, 4)
    rowGlow.Position = UDim2.new(0, -2, 0, -2)
    rowGlow.BackgroundColor3 = Color3.fromRGB(74, 177, 255)
    rowGlow.BackgroundTransparency = 0.95
    rowGlow.BorderSizePixel = 0
    rowGlow.ZIndex = row.ZIndex - 1
    rowGlow.Parent = row
    Instance.new("UICorner", rowGlow).CornerRadius = UDim.new(0, 15)
    
    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(0, 115, 1, 0)
    label.Position = UDim2.new(0, 13, 0, 0)
    label.Text = "JumpPower"
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local min, max, default = 5, 100, 50
    local sliderPill = Instance.new("Frame", row)
    sliderPill.Size = UDim2.new(0, 170, 0, 36)
    sliderPill.Position = UDim2.new(0, 132, 0.5, -18)
    sliderPill.BackgroundColor3 = Color3.fromRGB(33, 41, 57)
    sliderPill.BorderSizePixel = 0
    Instance.new("UICorner", sliderPill).CornerRadius = UDim.new(1, 999)
    
    local sliderFill = Instance.new("Frame", sliderPill)
    sliderFill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(80, 170, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.ZIndex = 2
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 999)
    
    local grad = Instance.new("UIGradient", sliderFill)
    grad.Color = premiumGradientColors
    
    local valueLabel = Instance.new("TextLabel", sliderPill)
    valueLabel.Size = UDim2.new(0, 48, 1, 0)
    valueLabel.Position = UDim2.new(1, -50, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(220, 240, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 18
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.ZIndex = 3
    
    setupEnhancedSliderDrag(sliderFill, sliderPill, min, max, function(val, percent)
        currentJump = val
        TweenService:Create(valueLabel, AnimationPresets.colorShift, {
            TextColor3 = Color3.fromRGB(74, 177, 255)
        }):Play()
        valueLabel.Text = tostring(val)
        wait(0.1)
        TweenService:Create(valueLabel, AnimationPresets.colorShift, {
            TextColor3 = Color3.fromRGB(220, 240, 255)
        }):Play()
    end)
    
    local setToggle = createEnhancedToggle(row, UDim2.new(0, 301, 0.5, -10), function(val)
        jumppowerEnabled = val
        TweenService:Create(rowGlow, AnimationPresets.colorShift, {
            BackgroundTransparency = val and 0.85 or 0.95
        }):Play()
    end)
end

RunService.RenderStepped:Connect(function()
    if jumppowerEnabled then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoid and rootPart and humanoid:GetState() == Enum.HumanoidStateType.Jumping then
                if tick() - lastJump > 0.15 then
                    rootPart.Velocity = Vector3.new(rootPart.Velocity.X, currentJump, rootPart.Velocity.Z)
                    lastJump = tick()
                end
            end
        end
    end
end)

local infWaterEnabled = false
local infWaterConnection = nil

do
    local section = sections["Configuration"]
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -40, 0, 54)
    row.Position = UDim2.new(0, 20, 0, 180)
    row.BackgroundColor3 = Color3.fromRGB(26, 28, 33)
    row.BackgroundTransparency = 0.08
    row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 13)
    row.Parent = section
    
    local rowGlow = Instance.new("Frame")
    rowGlow.Size = UDim2.new(1, 4, 1, 4)
    rowGlow.Position = UDim2.new(0, -2, 0, -2)
    rowGlow.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
    rowGlow.BackgroundTransparency = 0.95
    rowGlow.BorderSizePixel = 0
    rowGlow.ZIndex = row.ZIndex - 1
    rowGlow.Parent = row
    Instance.new("UICorner", rowGlow).CornerRadius = UDim.new(0, 15)
    
    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(0, 160, 1, 0)
    label.Position = UDim2.new(0, 13, 0, 0)
    label.Text = "Inf Water"
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local setInfWaterToggle = createEnhancedToggle(row, UDim2.new(0, 177, 0.5, -10), function(val)
        infWaterEnabled = val
        TweenService:Create(rowGlow, AnimationPresets.colorShift, {
            BackgroundTransparency = val and 0.85 or 0.95
        }):Play()
        
        TweenService:Create(label, AnimationPresets.colorShift, {
            TextColor3 = val and Color3.fromRGB(30, 144, 255) or Color3.fromRGB(230, 230, 240)
        }):Play()
        
        if val then
            if infWaterConnection then infWaterConnection:Disconnect() end
            infWaterConnection = RunService.Heartbeat:Connect(function()
                pcall(function()
                    local remote = ReplicatedStorage:FindFirstChild("WaterSource")
                    if remote then
                        remote:FireServer("Drank")
                    end
                end)
            end)
            notify("Eps1llon Hub", "💧 Infinite Water enabled!")
        else
            if infWaterConnection then
                infWaterConnection:Disconnect()
                infWaterConnection = nil
            end
            notify("Eps1llon Hub", "💧 Infinite Water disabled!")
        end
    end)
end

local reachEnabled, reachRadius = false, 12
local autoHitEnabled = false

do
    local section = sections["Combat"]
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -40, 0, 54)
    row.Position = UDim2.new(0, 20, 0, 60)
    row.BackgroundColor3 = Color3.fromRGB(26, 28, 33)
    row.BackgroundTransparency = 0.08
    row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 13)
    row.Parent = section
    
    local rowGlow = Instance.new("Frame")
    rowGlow.Size = UDim2.new(1, 4, 1, 4)
    rowGlow.Position = UDim2.new(0, -2, 0, -2)
    rowGlow.BackgroundColor3 = Color3.fromRGB(74, 177, 255)
    rowGlow.BackgroundTransparency = 0.95
    rowGlow.BorderSizePixel = 0
    rowGlow.ZIndex = row.ZIndex - 1
    rowGlow.Parent = row
    Instance.new("UICorner", rowGlow).CornerRadius = UDim.new(0, 15)
    
    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(0, 145, 1, 0)
    label.Position = UDim2.new(0, 13, 0, 0)
    label.Text = "Reach Radius"
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local min, max, default = 5, 15, 12
    local sliderPill = Instance.new("Frame", row)
    sliderPill.Size = UDim2.new(0, 170, 0, 36)
    sliderPill.Position = UDim2.new(0, 162, 0.5, -18)
    sliderPill.BackgroundColor3 = Color3.fromRGB(33, 41, 57)
    sliderPill.BorderSizePixel = 0
    Instance.new("UICorner", sliderPill).CornerRadius = UDim.new(1, 999)
    
    local sliderFill = Instance.new("Frame", sliderPill)
    sliderFill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(80, 170, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.ZIndex = 2
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 999)
    
    local combatGrad = Instance.new("UIGradient", sliderFill)
    combatGrad.Color = combatGradientColors
    
    local valueLabel = Instance.new("TextLabel", sliderPill)
    valueLabel.Size = UDim2.new(0, 48, 1, 0)
    valueLabel.Position = UDim2.new(1, -50, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(220, 240, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 18
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.ZIndex = 3
    
    setupEnhancedSliderDrag(sliderFill, sliderPill, min, max, function(val, percent)
        reachRadius = val
        TweenService:Create(valueLabel, AnimationPresets.colorShift, {
            TextColor3 = Color3.fromRGB(74, 177, 255)
        }):Play()
        valueLabel.Text = tostring(val)
        wait(0.1)
        TweenService:Create(valueLabel, AnimationPresets.colorShift, {
            TextColor3 = Color3.fromRGB(220, 240, 255)
        }):Play()
    end)
    
    local setToggle = createEnhancedToggle(row, UDim2.new(0, 331, 0.5, -10), function(val)
        reachEnabled = val
        TweenService:Create(rowGlow, AnimationPresets.colorShift, {
            BackgroundTransparency = val and 0.85 or 0.95
        }):Play()
    end)

    local row2 = Instance.new("Frame")
    row2.Size = UDim2.new(1, -40, 0, 54)
    row2.Position = UDim2.new(0, 20, 0, 120)
    row2.BackgroundColor3 = Color3.fromRGB(26, 28, 33)
    row2.BackgroundTransparency = 0.08
    row2.BorderSizePixel = 0
    Instance.new("UICorner", row2).CornerRadius = UDim.new(0, 13)
    row2.Parent = section
    
    local rowGlow2 = Instance.new("Frame")
    rowGlow2.Size = UDim2.new(1, 4, 1, 4)
    rowGlow2.Position = UDim2.new(0, -2, 0, -2)
    rowGlow2.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    rowGlow2.BackgroundTransparency = 0.95
    rowGlow2.BorderSizePixel = 0
    rowGlow2.ZIndex = row2.ZIndex - 1
    rowGlow2.Parent = row2
    Instance.new("UICorner", rowGlow2).CornerRadius = UDim.new(0, 15)
    
    local label2 = Instance.new("TextLabel", row2)
    label2.Size = UDim2.new(0, 145, 1, 0)
    label2.Position = UDim2.new(0, 13, 0, 0)
    label2.Text = "Auto Hit"
    label2.TextColor3 = Color3.fromRGB(230, 230, 240)
    label2.BackgroundTransparency = 1
    label2.Font = Enum.Font.GothamBold
    label2.TextSize = 18
    label2.TextXAlignment = Enum.TextXAlignment.Left
    
    local setAutoHit = createEnhancedToggle(row2, UDim2.new(0, 149, 0.5, -10), function(val)
        autoHitEnabled = val
        TweenService:Create(rowGlow2, AnimationPresets.colorShift, {
            BackgroundTransparency = val and 0.85 or 0.95
        }):Play()
    end)
end

local function expandHitbox(tool)
    local hitbox = tool:FindFirstChild("Hitbox", true)
    local handle = tool:FindFirstChild("Handle")
    if hitbox and handle and hitbox:IsA("BasePart") and handle:IsA("BasePart") then
        hitbox.Size = Vector3.new(reachRadius*2, reachRadius*2, reachRadius*2)
        hitbox.Massless = true
        hitbox.CanCollide = false
        hitbox.Transparency = 1
        for _,c in ipairs(hitbox:GetChildren()) do
            if c:IsA("SpecialMesh") or c:IsA("Weld") or c:IsA("WeldConstraint") or c:IsA("BoxHandleAdornment") then
                c:Destroy()
            end
        end
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = handle
        weld.Part1 = hitbox
        weld.Parent = hitbox
    end
end

local function trackTool(tool)
    expandHitbox(tool)
    if tool:IsA("Tool") then
        tool.Equipped:Connect(function() expandHitbox(tool) end)
        tool.Unequipped:Connect(function() expandHitbox(tool) end)
    end
end

local function updateHitboxes()
    if player.Character then
        for _,tool in ipairs(player.Character:GetChildren()) do
            if tool:IsA("Tool") then expandHitbox(tool) end
        end
    end
end

local function initHitboxSystem()
    if player.Character then
        for _,tool in ipairs(player.Character:GetChildren()) do
            if tool:IsA("Tool") then trackTool(tool) end
        end
        player.Character.ChildAdded:Connect(function(c)
            if c:IsA("Tool") then wait(0.1) trackTool(c) end
        end)
    end
    player.CharacterAdded:Connect(function(ch)
        for _,tool in ipairs(ch:GetChildren()) do
            if tool:IsA("Tool") then trackTool(tool) end
        end
        ch.ChildAdded:Connect(function(c)
            if c:IsA("Tool") then wait(0.1) trackTool(c) end
        end)
    end)
end

local hitboxConn
local function enableReachSystem(val)
    if val then
        if not hitboxConn then
            hitboxConn = RunService.RenderStepped:Connect(updateHitboxes)
        end
        initHitboxSystem()
    else
        if hitboxConn then hitboxConn:Disconnect() hitboxConn = nil end
    end
end

coroutine.wrap(function()
    local prevEnabled = false
    while true do
        if reachEnabled ~= prevEnabled then
            enableReachSystem(reachEnabled)
            prevEnabled = reachEnabled
        end
        wait(0.22)
    end
end)()

coroutine.wrap(function()
    while true do
        if autoHitEnabled and player.Character then
            local tool = nil
            for _,v in ipairs(player.Character:GetChildren()) do
                if v:IsA("Tool") and v:FindFirstChild("Handle") then
                    tool = v
                    break
                end
            end
            if tool and tool.Activate then
                pcall(function() tool:Activate() end)
            end
        end
        wait(0.12)
    end
end)()

local espSettings = {
    Name = false, HP = false, Armor = false, Distance = false,
    Team = false, Age = false, Holding = false, Highlight = false
}

local espObjects = {}

local function getArmor(prot)
    if prot:IsA("IntValue") or prot:IsA("NumberValue") then return prot.Value end
    if prot:IsA("Folder") or prot:IsA("Model") then
        local a = prot:FindFirstChild("Armor")
        if a and a:IsA("IntValue") then return a.Value end
        for _,v in ipairs(prot:GetChildren()) do
            if v:IsA("IntValue") then return v.Value end
        end
    end
    return nil
end

local function clearESP()
    for _,d in pairs(espObjects) do
        for _,o in pairs(d) do
            if o and o.Remove then o:Remove() end
        end
    end
    table.clear(espObjects)
end

local function createEnhancedESPToggle(section, xPos, yPos, labelText, setting)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0.5, -25, 0, 50)
    row.Position = UDim2.new(xPos, 20, 0, yPos)
    row.BackgroundColor3 = Color3.fromRGB(26, 28, 33)
    row.BackgroundTransparency = 0.08
    row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
    row.Parent = section
    
    local rowGlow = Instance.new("Frame")
    rowGlow.Size = UDim2.new(1, 4, 1, 4)
    rowGlow.Position = UDim2.new(0, -2, 0, -2)
    rowGlow.BackgroundColor3 = Color3.fromRGB(74, 255, 230)
    rowGlow.BackgroundTransparency = 0.95
    rowGlow.BorderSizePixel = 0
    rowGlow.ZIndex = row.ZIndex - 1
    rowGlow.Parent = row
    Instance.new("UICorner", rowGlow).CornerRadius = UDim.new(0, 12)
    
    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(1, -90, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local setToggle = createEnhancedToggle(row, UDim2.new(1, -90, 0.5, -10), function(val)
        espSettings[setting] = val
        TweenService:Create(rowGlow, AnimationPresets.colorShift, {
            BackgroundTransparency = val and 0.80 or 0.95
        }):Play()
        
        TweenService:Create(label, AnimationPresets.colorShift, {
            TextColor3 = val and Color3.fromRGB(74, 255, 230) or Color3.fromRGB(230, 230, 240)
        }):Play()
    end)
end

do
    local section = sections["ESP"]
    
    createEnhancedESPToggle(section, 0, 60, "Show Names", "Name")
    createEnhancedESPToggle(section, 0, 116, "Show HP", "HP") 
    createEnhancedESPToggle(section, 0, 172, "Show Armor", "Armor")
    createEnhancedESPToggle(section, 0, 228, "Show Distance", "Distance")
    
    createEnhancedESPToggle(section, 0.5, 60, "Show Team", "Team")
    createEnhancedESPToggle(section, 0.5, 116, "Show Age", "Age")
    createEnhancedESPToggle(section, 0.5, 172, "Show Holding", "Holding")
    createEnhancedESPToggle(section, 0.5, 228, "Highlight Players", "Highlight")
end

RunService.RenderStepped:Connect(function()
    clearESP()
    
    local anyEnabled = false
    for _, enabled in pairs(espSettings) do
        if enabled then anyEnabled = true break end
    end
    if not anyEnabled then return end
    
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl~=player and pl.Character then
            local char = pl.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hrp and head and hum and hum.Health > 0 then
                local pos, on = camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.3,0))
                if not on then continue end

                local hl = char:FindFirstChild("ESP_Highlight")
                if espSettings.Highlight then
                    if not hl then
                        hl = Instance.new("Highlight", char)
                        hl.Name = "ESP_Highlight"
                        hl.Adornee = char
                        hl.FillTransparency = 0.5
                        hl.OutlineColor = Color3.new(1,1,1)
                        hl.OutlineTransparency = 0
                    end
                    hl.FillColor = (pl.Team and pl.Team.TeamColor.Color) or Color3.new(1,1,1)
                elseif hl then
                    hl:Destroy()
                end

                local dist = math.floor((hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude)
                local hp = math.floor(hum.Health)
                local armor = "?"
                local vf = char:FindFirstChild("Values")
                if vf then
                    local prot = vf:FindFirstChild("Protection")
                    if prot then
                        local a = getArmor(prot)
                        if type(a)=="number" then armor = tostring(a) end
                    end
                end
                local age = char:FindFirstChild("Age") and tostring(char.Age.Value) or "?"
                local teamName = pl.Team and pl.Team.Name or "None"
                local tool = char:FindFirstChildOfClass("Tool")
                local toolName = tool and tool.Name

                local lines, L1, L2 = {}, {}, {}
                if espSettings.Name then table.insert(L1, pl.Name) end
                if espSettings.HP then table.insert(L1, hp.." HP") end
                if espSettings.Armor then table.insert(L1, armor.." Armor") end
                if espSettings.Distance then table.insert(L1, dist.." studs") end
                if #L1 > 0 then table.insert(lines, table.concat(L1, " | ")) end
                if espSettings.Team then table.insert(L2, "Team: "..teamName) end
                if espSettings.Age then table.insert(L2, "Age: "..age) end
                if #L2 > 0 then table.insert(lines, table.concat(L2, " | ")) end
                if espSettings.Holding and toolName then table.insert(lines, "Holding: "..toolName) end

                local lineH, totalH = 18, #lines * 18
                local startY = pos.Y - totalH/2
                local drawn = {}
                for i,txt in ipairs(lines) do
                    local d = Drawing.new("Text")
                    d.Text = txt
                    d.Size = 16
                    d.Center = true
                    d.Font = 2
                    d.Color = (pl.Team and pl.Team.TeamColor.Color) or Color3.new(1,1,1)
                    d.Outline = true
                    d.OutlineColor = Color3.new(0,0,0)
                    d.Position = Vector2.new(pos.X, startY + (i-1)*lineH)
                    d.Visible = true
                    table.insert(drawn, d)
                end
                espObjects[pl] = drawn
            end
        end
    end
end)

local targetToolNames = {}
local grabtoolsConnection = nil
local toolCountDisplay = nil
local toolListFrame = nil
local toolListLabels = {}

local function shouldPickupTool(toolName)
    if #targetToolNames == 0 then return false end
    for _, targetName in ipairs(targetToolNames) do
        if string.lower(toolName):find(string.lower(targetName)) then return true end
    end
    return false
end

local function parseToolNames(inputText)
    local names = {}
    if inputText == "" then return names end
    for name in string.gmatch(inputText, "([^,]+)") do
        local trimmedName = string.match(name, "^%s*(.-)%s*$")
        if trimmedName ~= "" then table.insert(names, trimmedName) end
    end
    return names
end

local function getToolCounts()
    local toolCounts = {}
    local totalTools = 0
    for _, child in ipairs(workspace:GetChildren()) do
        if child:IsA("Tool") and child:FindFirstChild("Handle") then
            local toolName = child.Name
            toolCounts[toolName] = (toolCounts[toolName] or 0) + 1
            totalTools = totalTools + 1
        end
    end
    return toolCounts, totalTools
end

local function equipSpecificTool(toolName)
    if not player.Character then return false end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    for _, child in ipairs(workspace:GetChildren()) do
        if child:IsA("Tool") and child:FindFirstChild("Handle") and child.Name == toolName then
            humanoid:EquipTool(child)
            notify("Eps1llon Hub", "✅ Grabbed " .. toolName)
            return true
        end
    end
    return false
end

local function equipTools()
    if #targetToolNames == 0 then return end
    if not player.Character then return end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    for _, child in ipairs(workspace:GetChildren()) do
        if player.Character and child:IsA("Tool") and child:FindFirstChild("Handle") then
            if shouldPickupTool(child.Name) then
                humanoid:EquipTool(child)
                wait(0.05)
            end
        end
    end
end

local function updateToolCountDisplay()
    if not toolCountDisplay then return end
    
    local toolCounts, totalTools = getToolCounts()
    
    if totalTools > 0 then
        local targetText = #targetToolNames > 0 and " (Targeting: " .. #targetToolNames .. ")" or ""
        toolCountDisplay.Text = "Tools Available: " .. totalTools .. targetText
        toolCountDisplay.TextColor3 = Color3.fromRGB(74, 177, 255)
    else
        toolCountDisplay.Text = "No Tools Available"
        toolCountDisplay.TextColor3 = Color3.fromRGB(120, 120, 120)
    end
end

local function updateToolList()
    if not toolListFrame then return end
    
    for _, label in pairs(toolListLabels) do
        if label then label:Destroy() end
    end
    toolListLabels = {}
    
    local toolCounts, totalTools = getToolCounts()
    local yOffset = 5
    
    if totalTools == 0 then
        local noToolsLabel = Instance.new("TextLabel")
        noToolsLabel.Size = UDim2.new(1, -10, 0, 20)
        noToolsLabel.Position = UDim2.new(0, 5, 0, yOffset)
        noToolsLabel.Text = "No tools found in workspace"
        noToolsLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
        noToolsLabel.BackgroundTransparency = 1
        noToolsLabel.Font = Enum.Font.Gotham
        noToolsLabel.TextSize = 12
        noToolsLabel.TextXAlignment = Enum.TextXAlignment.Center
        noToolsLabel.Parent = toolListFrame
        table.insert(toolListLabels, noToolsLabel)
        return
    end
    
    local sortedTools = {}
    for toolName, count in pairs(toolCounts) do
        table.insert(sortedTools, {name = toolName, count = count})
    end
    table.sort(sortedTools, function(a, b) return a.name < b.name end)
    
    local maxItems = 5
    local itemsToShow = math.min(#sortedTools
