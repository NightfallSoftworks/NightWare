local uis = game:GetService("UserInputService")
local players = game:GetService("Players")
local ws = game:GetService("Workspace")
local rs = game:GetService("ReplicatedStorage")
local http_service = game:GetService("HttpService")
local gui_service = game:GetService("GuiService")
local lighting = game:GetService("Lighting")
local run = game:GetService("RunService")
local stats = game:GetService("Stats")
local coregui = game:GetService("CoreGui")
local debris = game:GetService("Debris")
local tween_service = game:GetService("TweenService")

local vec2 = Vector2.new
local vec3 = Vector3.new
local dim2 = UDim2.new
local dim = UDim.new
local rect = Rect.new
local cfr = CFrame.new
local empty_cfr = cfr()
local point_object_space = empty_cfr.PointToObjectSpace
local angle = CFrame.Angles
local dim_offset = UDim2.fromOffset

local color = Color3.new
local rgb = Color3.fromRGB
local hex = Color3.fromHex
local hsv = Color3.fromHSV
local rgbseq = ColorSequence.new
local rgbkey = ColorSequenceKeypoint.new
local numseq = NumberSequence.new
local numkey = NumberSequenceKeypoint.new

local camera = ws.CurrentCamera
local lp = players.LocalPlayer
local mouse

local function waitForCharacter()
    repeat
        lp.Character = lp.Character or lp.CharacterAdded:Wait()
        task.wait()
    until lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
end

waitForCharacter()

local function getMouse()
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        mouse = lp:GetMouse()
    end
end
getMouse()
lp.CharacterAdded:Connect(getMouse)
local gui_offset = gui_service:GetGuiInset().Y

local max = math.max
local floor = math.floor
local min = math.min
local abs = math.abs
local noise = math.noise
local rad = math.rad
local random = math.random
local pow = math.pow
local sin = math.sin
local pi = math.pi
local tan = math.tan
local atan2 = math.atan2
local clamp = math.clamp

local insert = table.insert
local find = table.find
local remove = table.remove
local concat = table.concat

getgenv().library = {
    directory = "NightWare",
    folders = {
        "/fonts",
        "/configs",
    },
    flags = {},
    config_flags = {},
    connections = {},
    notifications = {notifs = {}},
    arraylist = {enabled_toggles = {}, items = {}},
    current_open = nil,
    hidden_position = nil,
    is_hidden = false,
    Font = "GothamBold",
}

local themes = {
    ["white"] = {
        background = rgb(32, 32, 32),
        accent = rgb(255, 255, 255),
        text = rgb(255, 255, 255)
    },
    ["pink"] = {
        background = rgb(32, 32, 32),
        accent = rgb(178, 34, 161),
        text = rgb(178, 34, 161)
    },
    ["red"] = {
        background = rgb(32, 32, 32),
        accent = rgb(178, 34, 34),
        text = rgb(178, 34, 34)
    },
    ["blue"] = {
        background = rgb(32, 32, 32),
        accent = rgb(34, 97, 183),
        text = rgb(34, 97, 183)
    },
    ["orange"] = {
        background = rgb(32, 32, 32),
        accent = rgb(214, 109, 7),
        text = rgb(214, 109, 7)
    },
    ["green"] = {
        background = rgb(32, 32, 32),
        accent = rgb(34, 178, 104),
        text = rgb(34, 178, 104),
    },
    current = "white"
}

local theme_elements = {
    window_title = nil,
    game_info_label = nil,
    window_name = nil,
    window_suffix = nil,
    game_name = nil,
    shadow = nil,
}

local keys = {
    [Enum.KeyCode.LeftShift] = "LS",
    [Enum.KeyCode.RightShift] = "RS",
    [Enum.KeyCode.LeftControl] = "LC",
    [Enum.KeyCode.RightControl] = "RC",
    [Enum.KeyCode.Insert] = "INS",
    [Enum.KeyCode.Backspace] = "BS",
    [Enum.KeyCode.Return] = "Ent",
    [Enum.KeyCode.LeftAlt] = "LA",
    [Enum.KeyCode.RightAlt] = "RA",
    [Enum.KeyCode.CapsLock] = "CAPS",
    [Enum.KeyCode.One] = "1",
    [Enum.KeyCode.Two] = "2",
    [Enum.KeyCode.Three] = "3",
    [Enum.KeyCode.Four] = "4",
    [Enum.KeyCode.Five] = "5",
    [Enum.KeyCode.Six] = "6",
    [Enum.KeyCode.Seven] = "7",
    [Enum.KeyCode.Eight] = "8",
    [Enum.KeyCode.Nine] = "9",
    [Enum.KeyCode.Zero] = "0",
    [Enum.KeyCode.Minus] = "-",
    [Enum.KeyCode.Equals] = "=",
    [Enum.KeyCode.Tilde] = "~",
    [Enum.KeyCode.LeftBracket] = "[",
    [Enum.KeyCode.RightBracket] = "]",
    [Enum.KeyCode.RightParenthesis] = ")",
    [Enum.KeyCode.LeftParenthesis] = "(",
    [Enum.KeyCode.Semicolon] = ",",
    [Enum.KeyCode.Quote] = "'",
    [Enum.KeyCode.BackSlash] = "\\",
    [Enum.KeyCode.Comma] = ",",
    [Enum.KeyCode.Period] = ".",
    [Enum.KeyCode.Slash] = "/",
    [Enum.KeyCode.Asterisk] = "*",
    [Enum.KeyCode.Plus] = "+",
    [Enum.KeyCode.Period] = ".",
    [Enum.KeyCode.Backquote] = "`",
    [Enum.UserInputType.MouseButton1] = "MB1",
    [Enum.UserInputType.MouseButton2] = "MB2",
    [Enum.UserInputType.MouseButton3] = "MB3",
    [Enum.KeyCode.Escape] = "ESC",
    [Enum.KeyCode.Space] = "SPC",
}

library.__index = library

for _, path in next, library.folders do
    makefolder(library.directory .. path)
end

local flags = library.flags
local config_flags = library.config_flags
local notifications = library.notifications
local arraylist = library.arraylist

local fonts = {
    small = Font.new("GothamBold", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    font = Font.new("GothamBold", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
};

function library:update_arraylist()
    local enabled_count = 0
    for _, toggle in arraylist.items do
        if toggle.enabled then
            enabled_count = enabled_count + 1
        end
    end
    
    if arraylist.count_label then
        arraylist.count_label.Text = enabled_count
    end
    
    if arraylist.holder then
        local sorted_items = {}
        for _, toggle in arraylist.items do
            if toggle.enabled then
                table.insert(sorted_items, toggle)
            end
        end
        table.sort(sorted_items, function(a, b) return a.name < b.name end)
        
        for _, child in arraylist.list_frame:GetChildren() do
            if child:IsA("Frame") and child.Name == "ItemFrame" then
                child:Destroy()
            end
        end
        
        for i, toggle in sorted_items do
            local item_frame = Instance.new("Frame")
            item_frame.Name = "ItemFrame"
            item_frame.BackgroundColor3 = rgb(32, 32, 32)
            item_frame.Size = dim2(1, -10, 0, 32)
            item_frame.BorderSizePixel = 0
            item_frame.Parent = arraylist.list_frame
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = dim(0, 6)
            corner.Parent = item_frame
            
            local stroke = Instance.new("UIStroke")
            stroke.Color = rgb(32, 32, 32)
            stroke.Thickness = 1
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Parent = item_frame
            
            local accent_bar = Instance.new("Frame")
            accent_bar.BackgroundColor3 = themes[themes.current].accent
            accent_bar.Size = dim2(0, 3, 1, -8)
            accent_bar.Position = dim2(0, 4, 0, 4)
            accent_bar.BorderSizePixel = 0
            accent_bar.Parent = item_frame
            
            local bar_corner = Instance.new("UICorner")
            bar_corner.CornerRadius = dim(0, 999)
            bar_corner.Parent = accent_bar
            
            local label = Instance.new("TextLabel")
            label.Font = library.Font
            label.TextColor3 = themes[themes.current].accent
            label.Text = toggle.name
            label.BackgroundTransparency = 1
            label.Size = dim2(1, -20, 1, 0)
            label.Position = dim2(0, 15, 0, 0)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextSize = 14
            label.Parent = item_frame
            
            item_frame.BackgroundTransparency = 1
            label.TextTransparency = 1
            accent_bar.BackgroundTransparency = 1
            stroke.Transparency = 1
            
            library:tween(item_frame, {BackgroundTransparency = 0}, Enum.EasingStyle.Quint, 0.3)
            library:tween(label, {TextTransparency = 0}, Enum.EasingStyle.Quint, 0.3)
            library:tween(accent_bar, {BackgroundTransparency = 0}, Enum.EasingStyle.Quint, 0.3)
            library:tween(stroke, {Transparency = 0}, Enum.EasingStyle.Quint, 0.3)
        end
    end
end

function library:create_arraylist()
    arraylist.holder = Instance.new("Frame")
    arraylist.holder.Name = "ArrayList"
    arraylist.holder.AnchorPoint = Vector2.new(1, 0)
    arraylist.holder.Position = dim2(1, -1, 0, 1)
    arraylist.holder.Size = dim2(0, 240, 0, 400)
    arraylist.holder.BackgroundColor3 = rgb(32, 32, 32)
    arraylist.holder.BorderSizePixel = 0
    arraylist.holder.Parent = library["items"]
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = dim(0, 10)
    corner.Parent = arraylist.holder
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = rgb(32, 32, 32)
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = arraylist.holder
    
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.BackgroundColor3 = rgb(32, 32, 32)
    header.Size = dim2(1, -2, 0, 45)
    header.Position = dim2(0, 1, 0, 1)
    header.BorderSizePixel = 0
    header.Parent = arraylist.holder
    
    local header_corner = Instance.new("UICorner")
    header_corner.CornerRadius = dim(0, 9)
    header_corner.Parent = header
    
    local header_cover = Instance.new("Frame")
    header_cover.BackgroundColor3 = rgb(32, 32, 32)
    header_cover.Size = dim2(1, 0, 0, 10)
    header_cover.Position = dim2(0, 0, 1, -10)
    header_cover.BorderSizePixel = 0
    header_cover.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Font = library.Font
    title.Text = "ARRAYLIST"
    title.TextColor3 = themes[themes.current].accent
    title.TextSize = 16
    title.BackgroundTransparency = 1
    title.Size = dim2(1, -50, 0, 45)
    title.Position = dim2(0, 15, 0, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextYAlignment = Enum.TextYAlignment.Center
    title.Parent = header
    
    local count_container = Instance.new("Frame")
    count_container.BackgroundColor3 = rgb(32, 32, 32)
    count_container.Size = dim2(0, 40, 0, 26)
    count_container.AnchorPoint = vec2(1, 0.5)
    count_container.Position = dim2(1, -12, 0.5, 0)
    count_container.BorderSizePixel = 0
    count_container.Parent = header
    
    local count_corner = Instance.new("UICorner")
    count_corner.CornerRadius = dim(0, 6)
    count_corner.Parent = count_container
    
    arraylist.count_label = Instance.new("TextLabel")
    arraylist.count_label.Name = "Count"
    arraylist.count_label.Font = library.Font
    arraylist.count_label.Text = "0"
    arraylist.count_label.TextColor3 = themes[themes.current].accent
    arraylist.count_label.TextSize = 15
    arraylist.count_label.BackgroundTransparency = 1
    arraylist.count_label.Size = dim2(1, 0, 1, 0)
    arraylist.count_label.Parent = count_container
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "Scroll"
    scroll.BackgroundTransparency = 1
    scroll.Size = dim2(1, -10, 1, -58)
    scroll.Position = dim2(0, 5, 0, 50)
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = themes[themes.current].accent
    scroll.CanvasSize = dim2(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = arraylist.holder
    
    arraylist.list_frame = Instance.new("Frame")
    arraylist.list_frame.Name = "ListFrame"
    arraylist.list_frame.BackgroundTransparency = 1
    arraylist.list_frame.Size = dim2(1, -10, 0, 0)
    arraylist.list_frame.Position = dim2(0, 5, 0, 5)
    arraylist.list_frame.AutomaticSize = Enum.AutomaticSize.Y
    arraylist.list_frame.Parent = scroll
    
    local list_layout = Instance.new("UIListLayout")
    list_layout.Padding = dim(0, 8)
    list_layout.SortOrder = Enum.SortOrder.LayoutOrder
    list_layout.Parent = arraylist.list_frame
end

function library:create_watermark()
    local watermark = {
        holder = nil,
        label = nil,
        update_connection = nil,
        frame_timer = tick(),
        frame_counter = 0,
        fps = 60,
    }

    watermark.holder = Instance.new("Frame")
    watermark.holder.Name = "Watermark"
    watermark.holder.AnchorPoint = Vector2.new(1, 0)
    watermark.holder.Position = dim2(1, -240, 0, 0)
    watermark.holder.Size = dim2(0, 0, 0, 30)
    watermark.holder.BackgroundColor3 = rgb(32, 32, 32)
    watermark.holder.BorderSizePixel = 0
    watermark.holder.Parent = library["items"]
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = dim(0, 6)
    corner.Parent = watermark.holder
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = rgb(32, 32, 32)
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = watermark.holder
    
    watermark.label = Instance.new("TextLabel")
    watermark.label.Name = "WatermarkLabel"
    watermark.label.Font = library.Font
    watermark.label.Text = "NightWare | 0/16 | 60 FPS | 0 ms | 0 Ghostyy"
    watermark.label.TextColor3 = themes[themes.current].accent
    watermark.label.BackgroundTransparency = 1
    watermark.label.Size = dim2(1, -10, 1, 0)
    watermark.label.Position = dim2(0, 5, 0, 0)
    watermark.label.TextXAlignment = Enum.TextXAlignment.Left
    watermark.label.TextYAlignment = Enum.TextYAlignment.Center
    watermark.label.TextSize = 14
    watermark.label.Parent = watermark.holder

    local function update_watermark()
        local player_count = #players:GetPlayers()
        local max_players = players.MaxPlayers
        local ghostyy_count = 0
        
        for _, player in ipairs(players:GetPlayers()) do
            if player.DisplayName:find("NFS_Ghostyy") or player.Name:find("NFS_Ghostyy") then
                ghostyy_count = ghostyy_count + 1
            end
        end
        
        local ping = 0
        local success, result = pcall(function()
            return math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
        end)
        if success then
            ping = result
        end
        
        watermark.label.Text = string.format("NightWare | %d/%d | %d FPS | %d ms | %d Ghostyy", 
            player_count, max_players, watermark.fps, ping, ghostyy_count)
        
        local text_size = game:GetService("TextService"):GetTextSize(watermark.label.Text, 14, library.Font, Vector2.new(1000, 30))
        watermark.holder.Size = dim2(0, text_size.X + 10, 0, 30)
    end

    watermark.update_connection = run.RenderStepped:Connect(function()
        watermark.frame_counter += 1
        
        if (tick() - watermark.frame_timer) >= 1 then
            watermark.fps = watermark.frame_counter
            watermark.frame_timer = tick()
            watermark.frame_counter = 0
            update_watermark()
        end
    end)

    players.PlayerAdded:Connect(update_watermark)
    players.PlayerRemoving:Connect(update_watermark)

    update_watermark()

    return watermark
end

function library:toggle_hide_ui()
    if not library["items"] then
        return
    end
    
    local mainFrame = library["items"]:FindFirstChild("MainFrame")
    if not mainFrame then
        return
    end
    
    if library.is_hidden then
        if library.hidden_position then
            mainFrame.Visible = true
            mainFrame.Position = dim2(1.2, 0, library.hidden_position.Y.Scale, library.hidden_position.Y.Offset)
            
            library:tween(mainFrame, {
                Position = library.hidden_position
            }, Enum.EasingStyle.Quint, 0.3)
        end
        
        library.is_hidden = false
    else
        library.hidden_position = mainFrame.Position
        
        local offscreen_position = dim2(1.2, 0, mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset)
        
        library:tween(mainFrame, {
            Position = offscreen_position
        }, Enum.EasingStyle.Quint, 0.3)
        
        task.spawn(function()
            task.wait(0.3)
            mainFrame.Visible = false
        end)
        
        library.is_hidden = true
    end
end

uis.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        library:toggle_hide_ui()
    end
end)

function library:tween(obj, properties, easing_style, time)
    local tween = tween_service:Create(obj, TweenInfo.new(time or 0.25, easing_style or Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0), properties):Play()

    return tween
end

function library:resizify(frame)
    local Frame = Instance.new("TextButton")
    Frame.Position = dim2(1, -10, 1, -10)
    Frame.BorderColor3 = rgb(0, 0, 0)
    Frame.Size = dim2(0, 10, 0, 10)
    Frame.BorderSizePixel = 0
    Frame.BackgroundColor3 = rgb(255, 255, 255)
    Frame.Parent = frame
    Frame.BackgroundTransparency = 1
    Frame.Text = ""

    local resizing = false
    local start_size
    local start
    local og_size = frame.Size

    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            start = input.Position
            start_size = frame.Size
        end
    end)

    Frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)

    library:connection(uis.InputChanged, function(input, game_event)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local viewport_x = camera.ViewportSize.X
            local viewport_y = camera.ViewportSize.Y

            local current_size = dim2(
                start_size.X.Scale,
                math.clamp(
                    start_size.X.Offset + (input.Position.X - start.X),
                    og_size.X.Offset,
                    viewport_x
                ),
                start_size.Y.Scale,
                math.clamp(
                    start_size.Y.Offset + (input.Position.Y - start.Y),
                    og_size.Y.Offset,
                    viewport_y
                )
            )

            library:tween(frame, {Size = current_size}, Enum.EasingStyle.Linear, 0.05)
        end
    end)
end

function fag(tbl)
    local Size = 0

    for _ in tbl do
        Size = Size + 1
    end

    return Size
end

function library:next_flag()
    local index = fag(library.flags) + 1;
    local str = string.format("flagnumber%s", index)

    return str;
end

function library:mouse_in_frame(uiobject)
    local y_cond = uiobject.AbsolutePosition.Y <= mouse.Y and mouse.Y <= uiobject.AbsolutePosition.Y + uiobject.AbsoluteSize.Y
    local x_cond = uiobject.AbsolutePosition.X <= mouse.X and mouse.X <= uiobject.AbsolutePosition.X + uiobject.AbsoluteSize.X

    return (y_cond and x_cond)
end

function library:draggify(frame)
    local dragging = false
    local start_size = frame.Position
    local start

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            start = input.Position
            start_size = frame.Position
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    library:connection(uis.InputChanged, function(input, game_event)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local viewport_x = camera.ViewportSize.X
            local viewport_y = camera.ViewportSize.Y

            local current_position = dim2(
                0,
                clamp(
                    start_size.X.Offset + (input.Position.X - start.X),
                    0,
                    viewport_x - frame.Size.X.Offset
                ),
                0,
                math.clamp(
                    start_size.Y.Offset + (input.Position.Y - start.Y),
                    0,
                    viewport_y - frame.Size.Y.Offset
                )
            )

            library:tween(frame, {Position = current_position}, Enum.EasingStyle.Linear, 0.05)
            library:close_element()
        end
    end)
end

function library:convert(str)
    local values = {}

    for value in string.gmatch(str, "[^,]+") do
        insert(values, tonumber(value))
    end

    if #values == 4 then
        return unpack(values)
    else
        return
    end
end

function library:convert_enum(enum)
    local enum_parts = {}

    for part in string.gmatch(enum, "[%w_]+") do
        insert(enum_parts, part)
    end

    local enum_table = Enum
    for i = 2, #enum_parts do
        local enum_item = enum_table[enum_parts[i]]

        enum_table = enum_item
    end

    return enum_table
end

local config_holder;
function library:update_config_list()
    if not config_holder then
        return
    end

    local list = {}

    for idx, file in listfiles(library.directory .. "/configs") do
        local name = file:gsub(library.directory .. "/configs\\", ""):gsub(".cfg", ""):gsub(library.directory .. "\\configs\\", "")
        list[#list + 1] = name
    end

    config_holder.refresh_options(list)
end

function library:get_config()
    local Config = {}

    for _, v in next, flags do
        if type(v) == "table" and v.key then
            Config[_] = {active = v.active, mode = v.mode, key = tostring(v.key)}
        elseif type(v) == "table" and v["Transparency"] and v["Color"] then
            Config[_] = {Transparency = v["Transparency"], Color = v["Color"]:ToHex()}
        else
            Config[_] = v
        end
    end

    return http_service:JSONEncode(Config)
end

function library:load_config(config_json)
    local config = http_service:JSONDecode(config_json)

    for _, v in config do
        local function_set = library.config_flags[_]

        if _ == "config_name_list" then
            continue
        end

        if function_set then
            if type(v) == "table" and v["Transparency"] and v["Color"] then
                function_set(hex(v["Color"]), v["Transparency"])
            elseif type(v) == "table" and v["active"] then
                function_set(v)
            else
                function_set(v)
            end
        end
    end
end

function library:round(number, float)
    local multiplier = 1 / (float or 1)

    return floor(number * multiplier + 0.5) / multiplier
end

function library:apply_theme(instance, theme_name, property)
end

function library:update_theme(theme_name, color)
    if themes[theme_name] then
        themes[theme_name].accent = color
        themes[theme_name].text = color
    end
end

function library:set_theme(theme_name)
    if themes[theme_name] then
        themes.current = theme_name
        library:update_all_ui_colors()
    end
end

function library:update_all_ui_colors()
    local current_theme = themes[themes.current]
    
    if theme_elements.window_title and theme_elements.window_name and theme_elements.window_suffix then
        theme_elements.window_title.TextColor3 = current_theme.accent
        local accent_color = string.format("rgb(%d, %d, %d)", current_theme.accent.R * 255, current_theme.accent.G * 255, current_theme.accent.B * 255)
        theme_elements.window_title.Text = string.format('<u>%s</u><font color = "%s">%s</font>', 
            theme_elements.window_name, accent_color, theme_elements.window_suffix)
    end
    
    if theme_elements.game_info_label then
        theme_elements.game_info_label.TextColor3 = current_theme.accent
    end
    
    if arraylist.holder then
        local header = arraylist.holder:FindFirstChild("Header")
        if header then
            local title = header:FindFirstChild("Title")
            if title then
                title.TextColor3 = current_theme.accent
            end
        end
        
        if arraylist.count_label then
            arraylist.count_label.TextColor3 = current_theme.accent
        end
        
        local scroll = arraylist.holder:FindFirstChild("Scroll")
        if scroll then
            scroll.ScrollBarImageColor3 = current_theme.accent
        end
    end
    
    if arraylist.watermark and arraylist.watermark.label then
        arraylist.watermark.label.TextColor3 = current_theme.accent
    end
    
    if theme_elements.shadow then
        theme_elements.shadow.ImageColor3 = current_theme.accent
    end
    
    for _, item_frame in arraylist.list_frame:GetChildren() do
        if item_frame:IsA("Frame") and item_frame.Name == "ItemFrame" then
            local label = item_frame:FindFirstChild("TextLabel")
            if label then
                label.TextColor3 = current_theme.accent
            end
            
            local accent_bar = item_frame:FindFirstChild("Frame")
            if accent_bar then
                accent_bar.BackgroundColor3 = current_theme.accent
            end
        end
    end
end

function library:connection(signal, callback)
    local connection = signal:Connect(callback)

    insert(library.connections, connection)

    return connection
end

function library:close_element(new_path)
    local open_element = library.current_open

    if open_element and new_path ~= open_element then
        open_element.set_visible(false)
        open_element.open = false;
    end

    if new_path ~= open_element then
        library.current_open = new_path or nil;
    end
end

function library:create(instance, options)
    local ins = Instance.new(instance)

    for prop, value in options do
        ins[prop] = value
    end

    return ins
end

function library:unload_menu()
    if library[ "items" ] then
        library[ "items" ]:Destroy()
    end

    if library[ "other" ] then
        library[ "other" ]:Destroy()
    end

    for index, connection in library.connections do
        connection:Disconnect()
        connection = nil
    end

    library = nil
end

function library:window(properties)
    local cfg = {
        suffix = properties.suffix or properties.Suffix or "tech";
        name = properties.name or properties.Name or "nebula";
        game_name = properties.gameInfo or properties.game_info or properties.GameInfo or "NightWare.lua";
        size = properties.size or properties.Size or dim2(0, 700, 0, 565);
        selected_tab;
        items = {};

        tween;
    }

    library[ "items" ] = library:create( "ScreenGui" , {
        Parent = lp:WaitForChild("PlayerGui");
        Name = "\0";
        Enabled = true;
        ZIndexBehavior = Enum.ZIndexBehavior.Global;
        IgnoreGuiInset = true;
        ResetOnSpawn = false;
    });

    library[ "other" ] = library:create( "ScreenGui" , {
        Parent = lp:WaitForChild("PlayerGui");
        Name = "\0";
        Enabled = false;
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
        IgnoreGuiInset = true;
        ResetOnSpawn = false;
    });

    local items = cfg.items; do
        items[ "main" ] = library:create( "Frame" , {
            Parent = library[ "items" ];
            Size = cfg.size;
            Name = "MainFrame";
            Position = dim2(0.5, -cfg.size.X.Offset / 2, 0.5, -cfg.size.Y.Offset / 2);
            BorderColor3 = rgb(0, 0, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(32, 32, 32)
        }); items[ "main" ].Position = dim2(0, items[ "main" ].AbsolutePosition.X, 0, items[ "main" ].AbsolutePosition.Y)

        library:create( "UICorner" , {
            Parent = items[ "main" ];
            CornerRadius = dim(0, 10)
        });

        library:create( "UIStroke" , {
            Color = rgb(23, 23, 29);
            Parent = items[ "main" ];
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        });

        items[ "side_frame" ] = library:create( "Frame" , {
            Parent = items[ "main" ];
            BackgroundTransparency = 1;
            Name = "\0";
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 196, 1, -25);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(32, 32, 32)
        });

        library:create( "Frame" , {
            AnchorPoint = vec2(1, 0);
            Parent = items[ "side_frame" ];
            Position = dim2(1, 0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 1, 1, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(32, 32, 32)
        });

        items[ "button_holder" ] = library:create( "Frame" , {
            Parent = items[ "side_frame" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 0, 0, 60);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 1, -60);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        }); cfg.button_holder = items[ "button_holder" ];

        library:create( "UIListLayout" , {
            Parent = items[ "button_holder" ];
            Padding = dim(0, 5);
            SortOrder = Enum.SortOrder.LayoutOrder
        });

        library:create( "UIPadding" , {
            PaddingTop = dim(0, 16);
            PaddingBottom = dim(0, 36);
            Parent = items[ "button_holder" ];
            PaddingRight = dim(0, 11);
            PaddingLeft = dim(0, 10)
        });

        local accent = themes[themes.current].accent
        items[ "title" ] = library:create( "TextLabel" , {
            FontFace = fonts.font;
            BorderColor3 = rgb(0, 0, 0);
            Text = name;
            Parent = items[ "side_frame" ];
            Name = "\0";
            Text = string.format('<u>%s</u><font color = "rgb(%d, %d, %d)">%s</font>', cfg.name, themes[themes.current].accent.R * 255, themes[themes.current].accent.G * 255, themes[themes.current].accent.B * 255, cfg.suffix);
            BackgroundTransparency = 1;
            Size = dim2(1, 0, 0, 70);
            TextColor3 = themes[themes.current].accent;
            BorderSizePixel = 0;
            RichText = true;
            TextSize = 30;
            BackgroundColor3 = rgb(255, 255, 255)
        }); library:apply_theme(items[ "title" ], "accent", "TextColor3");

        items[ "multi_holder" ] = library:create( "Frame" , {
            Parent = items[ "main" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 196, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -196, 0, 56);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        }); cfg.multi_holder = items[ "multi_holder" ];

        library:create( "Frame" , {
            AnchorPoint = vec2(0, 1);
            Parent = items[ "multi_holder" ];
            Position = dim2(0, 0, 1, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 0, 1);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(32, 32, 32)
        });

        items[ "shadow" ] = library:create( "ImageLabel" , {
            ImageColor3 = themes[themes.current].accent;
            ScaleType = Enum.ScaleType.Slice;
            Parent = items[ "main" ];
            BorderColor3 = rgb(0, 0, 0);
            Name = "\0";
            BackgroundColor3 = rgb(255, 255, 255);
            Size = dim2(1, 75, 1, 75);
            AnchorPoint = vec2(0.5, 0.5);
            Image = "rbxassetid://112971167999062";
            BackgroundTransparency = 1;
            Position = dim2(0.5, 0, 0.5, 0);
            SliceScale = 0.75;
            ZIndex = -100;
            BorderSizePixel = 0;
            SliceCenter = rect(vec2(112, 112), vec2(147, 147))
        }); theme_elements.shadow = items["shadow"]

        items[ "global_fade" ] = library:create( "Frame" , {
            Parent = items[ "main" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 196, 0, 56);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -196, 1, -81);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(32, 32, 32);
            ZIndex = 2;
        });

        library:create( "UICorner" , {
            Parent = items[ "shadow" ];
            CornerRadius = dim(0, 5)
        });

        items[ "info" ] = library:create( "Frame" , {
            AnchorPoint = vec2(0, 1);
            Parent = items[ "main" ];
            Name = "\0";
            Position = dim2(0, 0, 1, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 0, 25);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(32, 32, 32)
        });

        library:create( "UICorner" , {
            Parent = items[ "info" ];
            CornerRadius = dim(0, 10)
        });

        items[ "grey_fill" ] = library:create( "Frame" , {
            Name = "\0";
            Parent = items[ "info" ];
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 0, 6);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(32, 32, 32)
        });

        items[ "game" ] = library:create( "TextLabel" , {
            FontFace = fonts.font;
            Parent = items[ "info" ];
            TextColor3 = themes[themes.current].accent;
            BorderColor3 = rgb(0, 0, 0);
            Text = cfg.game_name;
            Name = "\0";
            Size = dim2(1, 0, 0, 0);
            AnchorPoint = vec2(0, 0.5);
            Position = dim2(0, 10, 0.5, -1);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        });
    end

    do
        library:draggify(items[ "main" ])
        library:resizify(items[ "main" ])
    end

    function cfg.toggle_menu(bool)
        library[ "items" ].Enabled = bool
    end

    theme_elements.window_title = items["title"]
    theme_elements.game_info_label = items["game"]
    theme_elements.window_name = cfg.name
    theme_elements.window_suffix = cfg.suffix
    theme_elements.game_name = cfg.game_name

    library:create_arraylist()
    arraylist.watermark = library:create_watermark()

    return setmetatable(cfg, library)
end

function library:tab(properties)
    local cfg = {
        name = properties.name or properties.Name or "visuals";
        icon = properties.icon or properties.Icon or "http://www.roblox.com/asset/?id=6034767608";

        tabs = properties.tabs or properties.Tabs or {"Main"};
        pages = {};
        current_multi;

        items = {};
    }

    local items = cfg.items; do
        items[ "tab_holder" ] = library:create( "Frame" , {
            Parent = library.cache;
            Name = "\0";
            Visible = false;
            BackgroundTransparency = 1;
            Position = dim2(0, 196, 0, 56);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -216, 1, -101);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        items[ "button" ] = library:create( "TextButton" , {
            FontFace = fonts.font;
            TextColor3 = themes[themes.current].accent;
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            Parent = self.items[ "button_holder" ];
            AutoButtonColor = false;
            BackgroundTransparency = 1;
            Name = "\0";
            Size = dim2(1, 0, 0, 35);
            BorderSizePixel = 0;
            TextSize = 16;
            BackgroundColor3 = rgb(32, 32, 32)
        });

        items[ "icon" ] = library:create( "ImageLabel" , {
            ImageColor3 = rgb(72, 72, 73);
            BorderColor3 = rgb(0, 0, 0);
            Parent = items[ "button" ];
            AnchorPoint = vec2(0, 0.5);
            Image = "http://www.roblox.com/asset/?id=6034767608";
            BackgroundTransparency = 1;
            Position = dim2(0, 10, 0.5, 0);
            Name = "\0";
            Size = dim2(0, 22, 0, 22);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        }); library:apply_theme(items[ "icon" ], "accent", "ImageColor3");

        items[ "name" ] = library:create( "TextLabel" , {
            FontFace = fonts.font;
            TextColor3 = themes[themes.current].accent;
            BorderColor3 = rgb(0, 0, 0);
            Text = cfg.name;
            Parent = items[ "button" ];
            Name = "\0";
            Size = dim2(0, 0, 1, 0);
            Position = dim2(0, 40, 0, 0);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.X;
            TextColor3 = themes[themes.current].accent;
            TextSize = 16;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        library:create( "UIPadding" , {
            Parent = items[ "name" ];
            PaddingRight = dim(0, 5);
            PaddingLeft = dim(0, 5)
        });

        library:create( "UICorner" , {
            Parent = items[ "button" ];
            CornerRadius = dim(0, 7)
        });

        library:create( "UIStroke" , {
            Color = rgb(23, 23, 29);
            Parent = items[ "button" ];
            Enabled = false;
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        });

        items[ "multi_section_button_holder" ] = library:create( "Frame" , {
            Parent = library.cache;
            BackgroundTransparency = 1;
            Name = "\0";
            Visible = false;
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 1, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        library:create( "UIListLayout" , {
            Parent = items[ "multi_section_button_holder" ];
            Padding = dim(0, 7);
            SortOrder = Enum.SortOrder.LayoutOrder;
            FillDirection = Enum.FillDirection.Horizontal
        });

        library:create( "UIPadding" , {
            PaddingTop = dim(0, 8);
            PaddingBottom = dim(0, 7);
            Parent = items[ "multi_section_button_holder" ];
            PaddingRight = dim(0, 7);
            PaddingLeft = dim(0, 7)
        });

        for _, section in cfg.tabs do
            local data = {items = {}}

            local multi_items = data.items; do
                multi_items[ "button" ] = library:create( "TextButton" , {
                    FontFace = fonts.font;
                    TextColor3 = themes[themes.current].accent;
                    BorderColor3 = rgb(0, 0, 0);
                    AutoButtonColor = false;
                    Text = "";
                    Parent = items[ "multi_section_button_holder" ];
                    Name = "\0";
                    Size = dim2(0, 0, 0, 39);
                    BackgroundTransparency = 1;
                    ClipsDescendants = true;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    TextSize = 16;
                    BackgroundColor3 = rgb(32, 32, 32)
                });

                multi_items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = themes[themes.current].accent;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = section;
                    Parent = multi_items[ "button" ];
                    Name = "\0";
                    Size = dim2(0, 0, 1, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIPadding" , {
                    Parent = multi_items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });

                multi_items[ "accent" ] = library:create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    AnchorPoint = vec2(0, 1);
                    Parent = multi_items[ "button" ];
                    BackgroundTransparency = 1;
                    Position = dim2(0, 10, 1, 4);
                    Name = "\0";
                    Size = dim2(1, -20, 0, 6);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes[themes.current].accent
                }); library:apply_theme(multi_items[ "accent" ], "accent", "BackgroundColor3");

                library:create( "UICorner" , {
                    Parent = multi_items[ "accent" ];
                    CornerRadius = dim(0, 999)
                });

                library:create( "UIPadding" , {
                    Parent = multi_items[ "button" ];
                    PaddingRight = dim(0, 10);
                    PaddingLeft = dim(0, 10)
                });

                library:create( "UICorner" , {
                    Parent = multi_items[ "button" ];
                    CornerRadius = dim(0, 7)
                });

                multi_items[ "tab" ] = library:create( "Frame" , {
                    Parent = library.cache;
                    BackgroundTransparency = 1;
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -20, 1, -20);
                    BorderSizePixel = 0;
                    Visible = false;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIListLayout" , {
                    FillDirection = Enum.FillDirection.Vertical;
                    HorizontalFlex = Enum.UIFlexAlignment.Fill;
                    Parent = multi_items[ "tab" ];
                    Padding = dim(0, 7);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    VerticalFlex = Enum.UIFlexAlignment.Fill
                });

                library:create( "UIPadding" , {
                    PaddingTop = dim(0, 7);
                    PaddingBottom = dim(0, 7);
                    Parent = multi_items[ "tab" ];
                    PaddingRight = dim(0, 7);
                    PaddingLeft = dim(0, 7)
                });
            end

            data.text = multi_items[ "name" ]
            data.accent = multi_items[ "accent" ]
            data.button = multi_items[ "button" ]
            data.page = multi_items[ "tab" ]
            data.parent = setmetatable(data, library):sub_tab({}).items[ "tab_parent" ]

            function data.open_page()
                local page = cfg.current_multi;

                if page and page.text ~= data.text then
                    self.items[ "global_fade" ].BackgroundTransparency = 0
                    library:tween(self.items[ "global_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)

                    local old_size = page.page.Size
                    page.page.Size = dim2(1, -20, 1, -20)
                end

                if page then
                    library:tween(page.text, {TextColor3 = rgb(62, 62, 63)})
                    library:tween(page.accent, {BackgroundTransparency = 1})
                    library:tween(page.button, {BackgroundTransparency = 1})

                    page.page.Visible = false
                    page.page.Parent = library[ "cache" ]
                end

                library:tween(data.text, {TextColor3 = themes[themes.current].accent})
                library:tween(data.accent, {BackgroundTransparency = 0})
                library:tween(data.button, {BackgroundTransparency = 0})
                library:tween(data.page, {Size = dim2(1, 0, 1, 0)}, Enum.EasingStyle.Quad, 0.4)

                data.page.Visible = true
                data.page.Parent = items["tab_holder"]

                cfg.current_multi = data

                library:close_element()
            end

            multi_items[ "button" ].MouseButton1Down:Connect(function()
                data.open_page()
            end)

            cfg.pages[#cfg.pages + 1] = setmetatable(data, library)
        end

        cfg.pages[1].open_page()
    end

    function cfg.open_tab()
        local selected_tab = self.selected_tab

        if selected_tab then
            if selected_tab[ 4 ] ~= items[ "tab_holder" ] then
                self.items[ "global_fade" ].BackgroundTransparency = 0

                library:tween(self.items[ "global_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
                selected_tab[ 4 ].Size = dim2(1, -216, 1, -101)
            end

            library:tween(selected_tab[ 1 ], {BackgroundTransparency = 1})
            library:tween(selected_tab[ 2 ], {ImageColor3 = rgb(72, 72, 73)})
            library:tween(selected_tab[ 3 ], {TextColor3 = rgb(72, 72, 73)})

            selected_tab[ 4 ].Visible = false
            selected_tab[ 4 ].Parent = library[ "cache" ]
            selected_tab[ 5 ].Visible = false
            selected_tab[ 5 ].Parent = library[ "cache" ]
        end

        library:tween(items[ "button" ], {BackgroundTransparency = 0})
        library:tween(items[ "icon" ], {ImageColor3 = themes[themes.current].accent})
        library:tween(items[ "name" ], {TextColor3 = themes[themes.current].accent})
        library:tween(items[ "tab_holder" ], {Size = dim2(1, -196, 1, -81)}, Enum.EasingStyle.Quad, 0.4)

        items[ "tab_holder" ].Visible = true
        items[ "tab_holder" ].Parent = self.items[ "main" ]
        items[ "multi_section_button_holder" ].Visible = true
        items[ "multi_section_button_holder" ].Parent = self.items[ "multi_holder" ]

        self.selected_tab = {
            items[ "button" ];
            items[ "icon" ];
            items[ "name" ];
            items[ "tab_holder" ];
            items[ "multi_section_button_holder" ];
        }

        library:close_element()
    end

    items[ "button" ].MouseButton1Down:Connect(function()
        cfg.open_tab()
    end)

    if not self.selected_tab then
        cfg.open_tab(true)
    end

    return unpack(cfg.pages)
end

function library:seperator(properties)
    local cfg = {items = {}, name = properties.Name or properties.name or "General"}

    local items = cfg.items do
        items[ "name" ] = library:create( "TextLabel" , {
            FontFace = fonts.font;
            TextColor3 = themes[themes.current].accent;
            BorderColor3 = rgb(0, 0, 0);
            Text = cfg.name;
            Parent = self.items[ "button_holder" ];
            Name = "\0";
            Size = dim2(1, 0, 0, 0);
            Position = dim2(0, 40, 0, 0);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 16;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        library:create( "UIPadding" , {
            Parent = items[ "name" ];
            PaddingRight = dim(0, 5);
            PaddingLeft = dim(0, 5)
        });
    end;

    return setmetatable(cfg, library)
end

function library:column(properties)
    local cfg = {items = {}, size = properties.size or 1}

    local items = cfg.items; do
        items[ "column" ] = library:create( "Frame" , {
            Parent = self[ "parent" ] or self.items["tab_parent"];
            BackgroundTransparency = 1;
            Name = "\0";
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 0, cfg.size, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        library:create( "UIPadding" , {
            PaddingBottom = dim(0, 10);
            Parent = items[ "column" ]
        });

        library:create( "UIListLayout" , {
            Parent = items[ "column" ];
            HorizontalFlex = Enum.UIFlexAlignment.Fill;
            Padding = dim(0, 10);
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder
        });
    end

    return setmetatable(cfg, library)
end

function library:sub_tab(properties)
    local cfg = {items = {}, order = properties.order or 0; size = properties.size or 1}

    local items = cfg.items; do
        items[ "tab_parent" ] = library:create( "Frame" , {
            Parent = self.items[ "tab" ];
            BackgroundTransparency = 1;
            Name = "\0";
            Size = dim2(0,0,cfg.size,0);
            BorderColor3 = rgb(0, 0, 0);
            BorderSizePixel = 0;
            Visible = true;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        library:create( "UIListLayout" , {
            FillDirection = Enum.FillDirection.Horizontal;
            HorizontalFlex = Enum.UIFlexAlignment.Fill;
            VerticalFlex = Enum.UIFlexAlignment.Fill;
            Parent = items[ "tab_parent" ];
            Padding = dim(0, 7);
            SortOrder = Enum.SortOrder.LayoutOrder;
        });
    end

    return setmetatable(cfg, library)
end

function library:section(properties)
    local cfg = {
        name = properties.name or properties.Name or "section";
        side = properties.side or properties.Side or "left";
        default = properties.default or properties.Default or false;
        size = properties.size or properties.Size or self.size or 0.5;
        icon = properties.icon or properties.Icon or "http://www.roblox.com/asset/?id=6022668898";
        fading_toggle = properties.fading or properties.Fading or false;
        items = {};
    };

    local items = cfg.items; do
        items[ "outline" ] = library:create( "Frame" , {
            Name = "\0";
            Parent = self.items[ "column" ];
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 0, cfg.size, -3);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(32, 32, 32)
        });

        library:create( "UICorner" , {
            Parent = items[ "outline" ];
            CornerRadius = dim(0, 7)
        });

        items[ "inline" ] = library:create( "Frame" , {
            Parent = items[ "outline" ];
            Name = "\0";
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, -2);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(32, 32, 32)
        });

        library:create( "UICorner" , {
            Parent = items[ "inline" ];
            CornerRadius = dim(0, 7)
        });

        items[ "scrolling" ] = library:create( "ScrollingFrame" , {
            ScrollBarImageColor3 = rgb(44, 44, 46);
            Active = true;
            AutomaticCanvasSize = Enum.AutomaticSize.Y;
            ScrollBarThickness = 2;
            Parent = items[ "inline" ];
            Name = "\0";
            Size = dim2(1, 0, 1, -40);
            BackgroundTransparency = 1;
            Position = dim2(0, 0, 0, 35);
            BackgroundColor3 = rgb(255, 255, 255);
            BorderColor3 = rgb(0, 0, 0);
            BorderSizePixel = 0;
            CanvasSize = dim2(0, 0, 0, 0)
        });

        items[ "elements" ] = library:create( "Frame" , {
            BorderColor3 = rgb(0, 0, 0);
            Parent = items[ "scrolling" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 10, 0, 10);
            Size = dim2(1, -20, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        library:create( "UIListLayout" , {
            Parent = items[ "elements" ];
            Padding = dim(0, 10);
            SortOrder = Enum.SortOrder.LayoutOrder
        });

        library:create( "UIPadding" , {
            PaddingBottom = dim(0, 15);
            Parent = items[ "elements" ]
        });

        items[ "button" ] = library:create( "TextButton" , {
            FontFace = fonts.font;
            TextColor3 = themes[themes.current].accent;
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            AutoButtonColor = false;
            Parent = items[ "outline" ];
            Name = "\0";
            Position = dim2(0, 1, 0, 1);
            Size = dim2(1, -2, 0, 35);
            BorderSizePixel = 0;
            TextSize = 16;
            BackgroundColor3 = rgb(32, 32, 32)
        });

        library:create( "UIStroke" , {
            Color = rgb(23, 23, 29);
            Parent = items[ "button" ];
            Enabled = false;
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        });

        library:create( "UICorner" , {
            Parent = items[ "button" ];
            CornerRadius = dim(0, 7)
        });

        items[ "Icon" ] = library:create( "ImageLabel" , {
            ImageColor3 = themes[themes.current].accent;
            BorderColor3 = rgb(0, 0, 0);
            Parent = items[ "button" ];
            AnchorPoint = vec2(0, 0.5);
            Image = cfg.icon;
            BackgroundTransparency = 1;
            Position = dim2(0, 10, 0.5, 0);
            Name = "\0";
            Size = dim2(0, 22, 0, 22);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        }); library:apply_theme(items[ "Icon" ], "accent", "ImageColor3");

        items[ "section_title" ] = library:create( "TextLabel" , {
            FontFace = fonts.font;
            TextColor3 = themes[themes.current].accent;
            BorderColor3 = rgb(0, 0, 0);
            Text = cfg.name;
            Parent = items[ "button" ];
            Name = "\0";
            Size = dim2(0, 0, 1, 0);
            AnchorPoint = vec2(0.5, 0.5);
            Position = dim2(0.5, 0, 0.5, -1);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Center;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 16;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        library:create( "Frame" , {
            AnchorPoint = vec2(0, 1);
            Parent = items[ "button" ];
            Position = dim2(0, 0, 1, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 0, 1);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(32, 32, 32)
        });

        if cfg.fading_toggle then
            items[ "toggle" ] = library:create( "TextButton" , {
                FontFace = fonts.small;
                TextColor3 = rgb(0, 0, 0);
                BorderColor3 = rgb(0, 0, 0);
                AutoButtonColor = false;
                Text = "";
                AnchorPoint = vec2(1, 0.5);
                Parent = items[ "button" ];
                Name = "\0";
                Position = dim2(1, -9, 0.5, 0);
                Size = dim2(0, 36, 0, 18);
                BorderSizePixel = 0;
                TextSize = 14;
                BackgroundColor3 = rgb(32, 32, 32)
            });  library:apply_theme(items[ "toggle" ], "accent", "BackgroundColor3");

            library:create( "UICorner" , {
                Parent = items[ "toggle" ];
                CornerRadius = dim(0, 999)
            });

            items[ "toggle_outline" ] = library:create( "Frame" , {
                Parent = items[ "toggle" ];
                Size = dim2(1, -2, 1, -2);
                Name = "\0";
                BorderMode = Enum.BorderMode.Inset;
                BorderColor3 = rgb(0, 0, 0);
                Position = dim2(0, 1, 0, 1);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(50, 50, 50)
            });  library:apply_theme(items[ "toggle_outline" ], "accent", "BackgroundColor3");

            library:create( "UICorner" , {
                Parent = items[ "toggle_outline" ];
                CornerRadius = dim(0, 999)
            });

            library:create( "UIGradient" , {
                Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))};
                Parent = items[ "toggle_outline" ]
            });

            items[ "toggle_circle" ] = library:create( "Frame" , {
                Parent = items[ "toggle_outline" ];
                Name = "\0";
                Position = dim2(0, 2, 0, 2);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(0, 12, 0, 12);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(86, 86, 88)
            });

            library:create( "UICorner" , {
                Parent = items[ "toggle_circle" ];
                CornerRadius = dim(0, 999)
            });

            library:create( "UICorner" , {
                Parent = items[ "outline" ];
                CornerRadius = dim(0, 7)
            });

            items[ "fade" ] = library:create( "Frame" , {
                Parent = items[ "outline" ];
                BackgroundTransparency = 0.800000011920929;
                Name = "\0";
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(1, 0, 1, 0);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(0, 0, 0)
            });

            library:create( "UICorner" , {
                Parent = items[ "fade" ];
                CornerRadius = dim(0, 7)
            });
        end
    end;

    if cfg.fading_toggle then
        items[ "button" ].MouseButton1Click:Connect(function()
            cfg.default = not cfg.default
            cfg.toggle_section(cfg.default)
        end)

        function cfg.toggle_section(bool)
            library:tween(items[ "toggle" ], {BackgroundColor3 = bool and themes[themes.current].accent or rgb(58, 58, 62)}, Enum.EasingStyle.Quad)
            library:tween(items[ "toggle_outline" ], {BackgroundColor3 = bool and themes[themes.current].accent or rgb(50, 50, 50)}, Enum.EasingStyle.Quad)
            library:tween(items[ "toggle_circle" ], {BackgroundColor3 = bool and rgb(255, 255, 255) or rgb(86, 86, 88), Position = bool and dim2(1, -14, 0, 2) or dim2(0, 2, 0, 2)}, Enum.EasingStyle.Quad)
            library:tween(items[ "fade" ], {BackgroundTransparency = bool and 1 or 0.8}, Enum.EasingStyle.Quad)
        end
    end

    return setmetatable(cfg, library)
end

function library:toggle(options)
    local cfg = {
        enabled = options.enabled or nil,
        name = options.name or "Toggle",
        info = options.info or nil,
        flag = options.flag or library:next_flag(),

        type = "checkbox",

        default = options.default or false,
        folding = options.folding or false,
        callback = options.callback or function() end,

        items = {};
        seperator = options.seperator or options.Seperator or false;
    }

    flags[cfg.flag] = cfg.default

    local items = cfg.items; do
        items[ "toggle" ] = library:create( "TextButton" , {
            FontFace = fonts.small;
            TextColor3 = rgb(0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            Parent = self.items[ "elements" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Size = dim2(1, 0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        items[ "name" ] = library:create( "TextLabel" , {
            FontFace = fonts.small;
            TextColor3 = themes[themes.current].accent;
            BorderColor3 = rgb(0, 0, 0);
            Text = cfg.name;
            Parent = items[ "toggle" ];
            Name = "\0";
            Size = dim2(1, 0, 0, 0);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 16;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        if cfg.info then
            items[ "info" ] = library:create( "TextLabel" , {
                FontFace = fonts.small;
                TextColor3 = rgb(130, 130, 130);
                BorderColor3 = rgb(0, 0, 0);
                TextWrapped = true;
                Text = cfg.info;
                Parent = items[ "toggle" ];
                Name = "\0";
                Position = dim2(0, 5, 0, 17);
                Size = dim2(1, -10, 0, 0);
                BackgroundTransparency = 1;
                TextXAlignment = Enum.TextXAlignment.Left;
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.XY;
                TextSize = 16;
                BackgroundColor3 = rgb(255, 255, 255)
            });
        end

        library:create( "UIPadding" , {
            Parent = items[ "name" ];
            PaddingRight = dim(0, 5);
            PaddingLeft = dim(0, 5)
        });

        items[ "right_components" ] = library:create( "Frame" , {
            Parent = items[ "toggle" ];
            Name = "\0";
            Position = dim2(1, 0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 0, 1, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        library:create( "UIListLayout" , {
            FillDirection = Enum.FillDirection.Horizontal;
            HorizontalAlignment = Enum.HorizontalAlignment.Right;
            Parent = items[ "right_components" ];
            Padding = dim(0, 9);
            SortOrder = Enum.SortOrder.LayoutOrder
        });

        items[ "toggle_button" ] = library:create( "TextButton" , {
            FontFace = fonts.small;
            TextColor3 = rgb(0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            LayoutOrder = 2;
            AutoButtonColor = false;
            AnchorPoint = vec2(1, 0);
            Parent = items[ "right_components" ];
            Name = "\0";
            Position = dim2(1, 0, 0, 0);
            Size = dim2(0, 16, 0, 16);
            BorderSizePixel = 0;
            TextSize = 14;
            BackgroundColor3 = rgb(67, 67, 68)
        }); library:apply_theme(items[ "toggle_button" ], "accent", "BackgroundColor3");

        library:create( "UICorner" , {
            Parent = items[ "toggle_button" ];
            CornerRadius = dim(0, 4)
        });

        items[ "outline" ] = library:create( "Frame" , {
            Parent = items[ "toggle_button" ];
            Size = dim2(1, -2, 1, -2);
            Name = "\0";
            BorderMode = Enum.BorderMode.Inset;
            BorderColor3 = rgb(0, 0, 0);
            Position = dim2(0, 1, 0, 1);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(32, 32, 32)
        }); library:apply_theme(items[ "outline" ], "accent", "BackgroundColor3");

        items[ "tick" ] = library:create( "ImageLabel" , {
            ImageTransparency = 1;
            BorderColor3 = rgb(0, 0, 0);
            Image = "rbxassetid://111862698467575";
            BackgroundTransparency = 1;
            Position = dim2(0, -1, 0, 0);
            Parent = items[ "outline" ];
            Size = dim2(1, 2, 1, 2);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255);
            ZIndex = 1;
        });

        library:create( "UICorner" , {
            Parent = items[ "outline" ];
            CornerRadius = dim(0, 4)
        });

        library:create( "UIGradient" , {
            Enabled = false;
            Parent = items[ "outline" ];
            Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))}
        });
    end;

    function cfg.set(bool)
        local found_index = nil
        for i, toggle in ipairs(arraylist.items) do
            if toggle.name == cfg.name then
                found_index = i
                break
            end
        end
        
        if bool then
            if not found_index then
                local toggle_data = {
                    name = cfg.name,
                    enabled = bool
                }
                table.insert(arraylist.items, toggle_data)
                
                if arraylist.holder then
                    library:tween(arraylist.holder, {BackgroundTransparency = 0}, Enum.EasingStyle.Quint, 0.3)
                end
            end
        else
            if found_index then
                table.remove(arraylist.items, found_index)
            end
        end
        
        library:update_arraylist()
        
        library:tween(items[ "tick" ], {Rotation = bool and 0 or 45, ImageTransparency = bool and 0 or 1})
        library:tween(items[ "toggle_button" ], {BackgroundColor3 = bool and themes[themes.current].accent or rgb(67, 67, 68)})
        library:tween(items[ "outline" ], {BackgroundColor3 = bool and themes[themes.current].accent or rgb(22, 22, 24)})

        cfg.callback(bool)

        if cfg.folding then
            self.items.elements.Visible = bool
        end

        flags[cfg.flag] = bool
        cfg.enabled = bool
    end

    items[ "toggle" ].MouseButton1Click:Connect(function()
        cfg.enabled = not cfg.enabled
        cfg.set(cfg.enabled)
    end)

    items[ "toggle_button" ].MouseButton1Click:Connect(function()
        cfg.enabled = not cfg.enabled
        cfg.set(cfg.enabled)
    end)

    if cfg.seperator then
        library:create( "Frame" , {
            AnchorPoint = vec2(0, 1);
            Parent = self.items[ "elements" ];
            Position = dim2(0, 0, 1, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 1, 0, 1);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(32, 32, 32)
        });
    end

    cfg.set(cfg.default)

    config_flags[cfg.flag] = cfg.set

    return setmetatable(cfg, library)
end

function library:dropdown(options)
    local cfg = {
        name = options.name or nil;
        info = options.info or nil;
        flag = options.flag or library:next_flag();
        options = options.items or {""};
        callback = options.callback or function() end;
        multi = options.multi or false;
        scrolling = options.scrolling or false;
        width = options.width or 130;
        open = false;
        option_instances = {};
        multi_items = {};
        ignore = options.ignore or false;
        items = {};
        y_size;
        seperator = options.seperator or options.Seperator or true;
    }

    cfg.default = options.default or (cfg.multi and {cfg.items[1]}) or cfg.items[1] or "None"
    flags[cfg.flag] = cfg.default

    local items = cfg.items; do
        items[ "dropdown_object" ] = library:create( "TextButton" , {
            FontFace = fonts.small;
            TextColor3 = rgb(0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            Parent = self.items[ "elements" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Size = dim2(1, 0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        items[ "name" ] = library:create( "TextLabel" , {
            FontFace = fonts.small;
            TextColor3 = themes[themes.current].accent;
            BorderColor3 = rgb(0, 0, 0);
            Text = "Dropdown";
            Parent = items[ "dropdown_object" ];
            Name = "\0";
            Size = dim2(1, 0, 0, 0);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 16;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        if cfg.info then
            items[ "info" ] = library:create( "TextLabel" , {
                FontFace = fonts.small;
                TextColor3 = rgb(130, 130, 130);
                BorderColor3 = rgb(0, 0, 0);
                TextWrapped = true;
                Text = cfg.info;
                Parent = items[ "dropdown_object" ];
                Name = "\0";
                Position = dim2(0, 5, 0, 17);
                Size = dim2(1, -10, 0, 0);
                BackgroundTransparency = 1;
                TextXAlignment = Enum.TextXAlignment.Left;
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.XY;
                TextSize = 16;
                BackgroundColor3 = rgb(255, 255, 255)
            });
        end

        library:create( "UIPadding" , {
            Parent = items[ "name" ];
            PaddingRight = dim(0, 5);
            PaddingLeft = dim(0, 5)
        });

        items[ "right_components" ] = library:create( "Frame" , {
            Parent = items[ "dropdown_object" ];
            Name = "\0";
            Position = dim2(1, 0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 0, 1, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        library:create( "UIListLayout" , {
            FillDirection = Enum.FillDirection.Horizontal;
            HorizontalAlignment = Enum.HorizontalAlignment.Right;
            Parent = items[ "right_components" ];
            Padding = dim(0, 7);
            SortOrder = Enum.SortOrder.LayoutOrder
        });

        items[ "dropdown" ] = library:create( "TextButton" , {
            FontFace = fonts.small;
            TextColor3 = rgb(0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            AutoButtonColor = false;
            AnchorPoint = vec2(1, 0);
            Parent = items[ "right_components" ];
            Name = "\0";
            Position = dim2(1, 0, 0, 0);
            Size = dim2(0, cfg.width, 0, 16);
            BorderSizePixel = 0;
            TextSize = 14;
            BackgroundColor3 = rgb(40, 40, 40)
        });

        library:create( "UICorner" , {
            Parent = items[ "dropdown" ];
            CornerRadius = dim(0, 4)
        });

        items[ "sub_text" ] = library:create( "TextLabel" , {
            FontFace = fonts.small;
            TextColor3 = rgb(86, 86, 87);
            BorderColor3 = rgb(0, 0, 0);
            Text = "awdawdawdawdawdawdawdaw";
            Parent = items[ "dropdown" ];
            Name = "\0";
            Size = dim2(1, -12, 0, 0);
            BorderSizePixel = 0;
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextTruncate = Enum.TextTruncate.AtEnd;
            AutomaticSize = Enum.AutomaticSize.Y;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        library:create( "UIPadding" , {
            Parent = items[ "sub_text" ];
            PaddingTop = dim(0, 1);
            PaddingRight = dim(0, 5);
            PaddingLeft = dim(0, 5)
        });

        items[ "indicator" ] = library:create( "ImageLabel" , {
            ImageColor3 = rgb(86, 86, 87);
            BorderColor3 = rgb(0, 0, 0);
            Parent = items[ "dropdown" ];
            AnchorPoint = vec2(1, 0.5);
            Image = "rbxassetid://101025591575185";
            BackgroundTransparency = 1;
            Position = dim2(1, -5, 0.5, 0);
            Name = "\0";
            Size = dim2(0, 12, 0, 12);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        items[ "dropdown_holder" ] = library:create( "Frame" , {
            BorderColor3 = rgb(0, 0, 0);
            Parent = library[ "items" ];
            Name = "\0";
            Visible = true;
            BackgroundTransparency = 1;
            Size = dim2(0, 0, 0, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(0, 0, 0);
            ZIndex = 10;
        });

        items[ "outline" ] = library:create( "Frame" , {
            Parent = items[ "dropdown_holder" ];
            Size = dim2(1, 0, 1, 0);
            ClipsDescendants = true;
            BorderColor3 = rgb(0, 0, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(40, 40, 40);
            ZIndex = 10;
        });

        library:create( "UIPadding" , {
            PaddingBottom = dim(0, 6);
            PaddingTop = dim(0, 3);
            PaddingLeft = dim(0, 3);
            Parent = items[ "outline" ]
        });

        library:create( "UIListLayout" , {
            Parent = items[ "outline" ];
            Padding = dim(0, 5);
            SortOrder = Enum.SortOrder.LayoutOrder
        });

        library:create( "UICorner" , {
            Parent = items[ "outline" ];
            CornerRadius = dim(0, 4)
        });
    end

    function cfg.render_option(text)
        local button = library:create( "TextButton" , {
            FontFace = fonts.small;
            TextColor3 = themes[themes.current].accent;
            BorderColor3 = rgb(0, 0, 0);
            Text = text;
            Parent = items[ "outline" ];
            Name = "\0";
            Size = dim2(1, -12, 0, 0);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255);
            ZIndex = 10;
        }); library:apply_theme(button, "accent", "TextColor3");

        library:create( "UIPadding" , {
            Parent = button;
            PaddingTop = dim(0, 1);
            PaddingRight = dim(0, 5);
            PaddingLeft = dim(0, 5)
        });

        return button
    end

    function cfg.set_visible(bool)
        local a = bool and cfg.y_size or 0
        library:tween(items[ "dropdown_holder" ], {Size = dim_offset(items[ "dropdown" ].AbsoluteSize.X, a)})

        items[ "dropdown_holder" ].Position = dim2(0, items[ "dropdown" ].AbsolutePosition.X, 0, items[ "dropdown" ].AbsolutePosition.Y + 80)
        if not (self.sanity and library.current_open == self) then
            library:close_element(cfg)
        end
    end

    function cfg.set(value)
        local selected = {}
        local isTable = type(value) == "table"

        for _, option in cfg.option_instances do
            if option.Text == value or (isTable and find(value, option.Text)) then
                insert(selected, option.Text)
                cfg.multi_items = selected
                option.TextColor3 = themes[themes.current].accent
            else
                option.TextColor3 = rgb(72, 72, 73)
            end
        end

        items[ "sub_text" ].Text = isTable and concat(selected, ", ") or selected[1] or ""
        flags[cfg.flag] = isTable and selected or selected[1]

        cfg.callback(flags[cfg.flag])
    end

    function cfg.refresh_options(list)
        cfg.y_size = 0

        for _, option in cfg.option_instances do
            option:Destroy()
        end

        cfg.option_instances = {}

        for _, option in list do
            local button = cfg.render_option(option)
            cfg.y_size += button.AbsoluteSize.Y + 6
            insert(cfg.option_instances, button)

            button.MouseButton1Down:Connect(function()
                if cfg.multi then
                    local selected_index = find(cfg.multi_items, button.Text)

                    if selected_index then
                        remove(cfg.multi_items, selected_index)
                    else
                        insert(cfg.multi_items, button.Text)
                    end

                    cfg.set(cfg.multi_items)
                else
                    cfg.set_visible(false)
                    cfg.open = false

                    cfg.set(button.Text)
                end
            end)
        end
    end

    items[ "dropdown" ].MouseButton1Click:Connect(function()
        cfg.open = not cfg.open

        cfg.set_visible(cfg.open)
    end)

    if cfg.seperator then
        library:create( "Frame" , {
            AnchorPoint = vec2(0, 1);
            Parent = self.items[ "elements" ];
            Position = dim2(0, 0, 1, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 1, 0, 1);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(32, 32, 32)
        });
    end

    flags[cfg.flag] = {}
    config_flags[cfg.flag] = cfg.set

    cfg.refresh_options(cfg.options)
    cfg.set(cfg.default)

    return setmetatable(cfg, library)
end

function library:label(options)
    local cfg = {
        enabled = options.enabled or nil,
        name = options.name or "Toggle",
        seperator = options.seperator or options.Seperator or false;
        info = options.info or nil;

        items = {};
    }

    local items = cfg.items; do
        items[ "label" ] = library:create( "TextButton" , {
            FontFace = fonts.small;
            TextColor3 = rgb(0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            Parent = self.items[ "elements" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Size = dim2(1, 0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        items[ "name" ] = library:create( "TextLabel" , {
            FontFace = fonts.small;
            TextColor3 = themes[themes.current].accent;
            BorderColor3 = rgb(0, 0, 0);
            Text = cfg.name;
            Parent = items[ "label" ];
            Name = "\0";
            Size = dim2(1, 0, 0, 0);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 16;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        if cfg.info then
            items[ "info" ] = library:create( "TextLabel" , {
                FontFace = fonts.small;
                TextColor3 = rgb(130, 130, 130);
                BorderColor3 = rgb(0, 0, 0);
                TextWrapped = true;
                Text = cfg.info;
                Parent = items[ "label" ];
                Name = "\0";
                Position = dim2(0, 5, 0, 17);
                Size = dim2(1, -10, 0, 0);
                BackgroundTransparency = 1;
                TextXAlignment = Enum.TextXAlignment.Left;
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.XY;
                TextSize = 16;
                BackgroundColor3 = rgb(255, 255, 255)
            });
        end

        library:create( "UIPadding" , {
            Parent = items[ "name" ];
            PaddingRight = dim(0, 5);
            PaddingLeft = dim(0, 5)
        });

        items[ "right_components" ] = library:create( "Frame" , {
            Parent = items[ "label" ];
            Name = "\0";
            Position = dim2(1, 0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 0, 1, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        library:create( "UIListLayout" , {
            FillDirection = Enum.FillDirection.Horizontal;
            HorizontalAlignment = Enum.HorizontalAlignment.Right;
            Parent = items[ "right_components" ];
            Padding = dim(0, 9);
            SortOrder = Enum.SortOrder.LayoutOrder
        });
    end

    if cfg.seperator then
        library:create( "Frame" , {
            AnchorPoint = vec2(0, 1);
            Parent = self.items[ "elements" ];
            Position = dim2(0, 0, 1, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 1, 0, 1);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(32, 32, 32)
        });
    end

    return setmetatable(cfg, library)
end

function library:textbox(options)
    local cfg = {
        name = options.name or "TextBox",
        placeholder = options.placeholder or options.placeholdertext or options.holder or options.holdertext or "type here...",
        default = options.default or "",
        flag = options.flag or library:next_flag(),
        callback = options.callback or function() end,
        visible = options.visible or true,
        finished = options.finished or false,
        cleartextonfocus = options.cleartextonfocus or false,
        items = {};
    }

    flags[cfg.flag] = cfg.default

    local items = cfg.items; do
        items[ "textbox" ] = library:create( "TextButton" , {
            FontFace = fonts.font;
            TextColor3 = rgb(0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            Parent = self.items[ "elements" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Size = dim2(1, 0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        items[ "name" ] = library:create( "TextLabel" , {
            FontFace = fonts.font;
            TextColor3 = themes[themes.current].accent;
            BorderColor3 = rgb(0, 0, 0);
            Text = cfg.name;
            Parent = items[ "textbox" ];
            Name = "\0";
            Size = dim2(1, 0, 0, 0);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 16;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        library:create( "UIPadding" , {
            Parent = items[ "name" ];
            PaddingRight = dim(0, 5);
            PaddingLeft = dim(0, 5)
        });

        items[ "right_components" ] = library:create( "Frame" , {
            Parent = items[ "textbox" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 4, 0, 19);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 0, 12);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        library:create( "UIListLayout" , {
            Parent = items[ "right_components" ];
            Padding = dim(0, 7);
            SortOrder = Enum.SortOrder.LayoutOrder;
            FillDirection = Enum.FillDirection.Horizontal
        });

        items[ "input" ] = library:create( "TextBox" , {
            FontFace = fonts.font;
            Text = "";
            Parent = items[ "right_components" ];
            Name = "\0";
            TextTruncate = Enum.TextTruncate.AtEnd;
            BorderSizePixel = 0;
            PlaceholderColor3 = themes[themes.current].accent;
            CursorPosition = -1;
            ClearTextOnFocus = false;
            TextSize = 14;
            TextColor3 = themes[themes.current].accent;
            BorderColor3 = rgb(0, 0, 0);
            Position = dim2(1, 0, 0, 0);
            Size = dim2(1, -4, 0, 30);
            BackgroundColor3 = rgb(40, 40, 40)
        });

        library:create( "UICorner" , {
            Parent = items[ "input" ];
            CornerRadius = dim(0, 3)
        });

        library:create( "UIPadding" , {
            Parent = items[ "right_components" ];
            PaddingTop = dim(0, 4);
            PaddingRight = dim(0, 4)
        });
    end

    function cfg.set(text)
        flags[cfg.flag] = text

        items[ "input" ].Text = text

        if not cfg.finished then
            cfg.callback(text)
        end
    end

    if not cfg.finished then
        items[ "input" ]:GetPropertyChangedSignal("Text"):Connect(function()
            cfg.set(items[ "input" ].Text)
        end)
    end

    items[ "input" ].Focused:Connect(function()
        library:tween(items[ "input" ], {TextColor3 = themes[themes.current].accent})
        
        if cfg.cleartextonfocus then
            items[ "input" ].Text = ""
        end
    end)

    items[ "input" ].FocusLost:Connect(function(enterPressed)
        library:tween(items[ "input" ], {TextColor3 = themes[themes.current].accent})
        
        if cfg.finished and enterPressed then
            cfg.callback(items[ "input" ].Text)
        end
    end)

    if cfg.default then
        cfg.set(cfg.default)
    end

    config_flags[cfg.flag] = cfg.set

    return setmetatable(cfg, library)
end

function library:keybind(options)
    local cfg = {
        flag = options.flag or library:next_flag(),
        callback = options.callback or function() end,
        name = options.name or nil,
        ignore_key = options.ignore or false,

        key = options.key or nil,
        mode = options.mode or "Toggle",
        active = options.default or false,

        open = false,
        binding = nil,

        hold_instances = {},
        items = {};
    }

    flags[cfg.flag] = {
        mode = cfg.mode,
        key = cfg.key,
        active = cfg.active
    }

    local items = cfg.items; do
        items[ "keybind_element" ] = library:create( "TextButton" , {
            FontFace = fonts.font;
            TextColor3 = rgb(0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            Parent = self.items[ "elements" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Size = dim2(1, 0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        items[ "name" ] = library:create( "TextLabel" , {
            FontFace = fonts.font;
            TextColor3 = themes[themes.current].accent;
            BorderColor3 = rgb(0, 0, 0);
            Text = cfg.name;
            Parent = items[ "keybind_element" ];
            Name = "\0";
            Size = dim2(1, 0, 0, 0);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 16;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        library:create( "UIPadding" , {
            Parent = items[ "name" ];
            PaddingRight = dim(0, 5);
            PaddingLeft = dim(0, 5)
        });

        items[ "right_components" ] = library:create( "Frame" , {
            Parent = items[ "keybind_element" ];
            Name = "\0";
            Position = dim2(1, 0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 0, 1, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        library:create( "UIListLayout" , {
            FillDirection = Enum.FillDirection.Horizontal;
            HorizontalAlignment = Enum.HorizontalAlignment.Right;
            Parent = items[ "right_components" ];
            Padding = dim(0, 7);
            SortOrder = Enum.SortOrder.LayoutOrder
        });

        items[ "keybind_holder" ] = library:create( "TextButton" , {
            FontFace = fonts.font;
            TextColor3 = rgb(0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            Parent = items[ "right_components" ];
            AutoButtonColor = false;
            AnchorPoint = vec2(1, 0);
            Size = dim2(0, 0, 0, 16);
            Name = "\0";
            Position = dim2(1, 0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.X;
            TextSize = 14;
            BackgroundColor3 = rgb(40, 40, 40)
        });

        library:create( "UICorner" , {
            Parent = items[ "keybind_holder" ];
            CornerRadius = dim(0, 4)
        });

        items[ "key" ] = library:create( "TextLabel" , {
            FontFace = fonts.font;
            TextColor3 = rgb(86, 86, 87);
            BorderColor3 = rgb(0, 0, 0);
            Text = "LSHIFT";
            Parent = items[ "keybind_holder" ];
            Name = "\0";
            Size = dim2(1, -12, 0, 0);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        library:create( "UIPadding" , {
            Parent = items[ "key" ];
            PaddingTop = dim(0, 1);
            PaddingRight = dim(0, 5);
            PaddingLeft = dim(0, 5)
        });

        items[ "dropdown" ] = library:create( "Frame" , {
            BorderColor3 = rgb(0, 0, 0);
            Parent = library.items;
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 0, 0, 0);
            Size = dim2(0, 0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.X;
            BackgroundColor3 = rgb(0, 0, 0)
        });

        items[ "inline" ] = library:create( "Frame" , {
            Parent = items[ "dropdown" ];
            Size = dim2(1, 0, 1, 0);
            Name = "\0";
            ClipsDescendants = true;
            BorderColor3 = rgb(0, 0, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(32, 32, 32)
        });

        library:create( "UIPadding" , {
            PaddingBottom = dim(0, 6);
            PaddingTop = dim(0, 3);
            PaddingLeft = dim(0, 3);
            Parent = items[ "inline" ]
        });

        library:create( "UIListLayout" , {
            Parent = items[ "inline" ];
            Padding = dim(0, 5);
            SortOrder = Enum.SortOrder.LayoutOrder
        });

        library:create( "UICorner" , {
            Parent = items[ "inline" ];
            CornerRadius = dim(0, 4)
        });

        local options = {"Hold", "Toggle", "Always"}

        cfg.y_size = 20
        for _, option in options do
            local name = library:create( "TextButton" , {
                FontFace = fonts.font;
                TextColor3 = themes[themes.current].accent;
                BorderColor3 = rgb(0, 0, 0);
                Text = option;
                Parent = items[ "inline" ];
                Name = "\0";
                Size = dim2(0, 0, 0, 0);
                BackgroundTransparency = 1;
                TextXAlignment = Enum.TextXAlignment.Left;
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.XY;
                TextSize = 14;
                BackgroundColor3 = rgb(255, 255, 255)
            }); cfg.hold_instances[option] = name
            library:apply_theme(name, "accent", "TextColor3")

            cfg.y_size += name.AbsoluteSize.Y

            library:create( "UIPadding" , {
                Parent = name;
                PaddingTop = dim(0, 1);
                PaddingRight = dim(0, 5);
                PaddingLeft = dim(0, 5)
            });

            name.MouseButton1Click:Connect(function()
                cfg.set(option)

                cfg.set_visible(false)

                cfg.open = false
            end)
        end
    end

    function cfg.modify_mode_color(path)
        for _, v in cfg.hold_instances do
            v.TextColor3 = rgb(72, 72, 72)
        end

        cfg.hold_instances[path].TextColor3 = themes[themes.current].accent
    end

    function cfg.set_mode(mode)
        cfg.mode = mode

        if mode == "Always" then
            cfg.set(true)
        elseif mode == "Hold" then
            cfg.set(false)
        end

        flags[cfg.flag]["mode"] = mode
        cfg.modify_mode_color(mode)
    end

    function cfg.set(input)
        if type(input) == "boolean" then
            cfg.active = input

            if cfg.mode == "Always" then
                cfg.active = true
            end
        elseif tostring(input):find("Enum") then
            input = input.Name == "Escape" and "NONE" or input

            cfg.key = input or "NONE"
        elseif find({"Toggle", "Hold", "Always"}, input) then
            if input == "Always" then
                cfg.active = true
            end

            cfg.mode = input
            cfg.set_mode(cfg.mode)
        elseif type(input) == "table" then
            input.key = type(input.key) == "string" and input.key ~= "NONE" and library:convert_enum(input.key) or input.key
            input.key = input.key == Enum.KeyCode.Escape and "NONE" or input.key

            cfg.key = input.key or "NONE"
            cfg.mode = input.mode or "Toggle"

            if input.active then
                cfg.active = input.active
            end

            cfg.set_mode(cfg.mode)
        end

        cfg.callback(cfg.active)

        local text = tostring(cfg.key) ~= "Enums" and (keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")) or nil
        local __text = text and (tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", ""))

        items[ "key" ].Text = __text

        flags[cfg.flag] = {
            mode = cfg.mode,
            key = cfg.key,
            active = cfg.active
        }
    end

    function cfg.set_visible(bool)
        local size = bool and cfg.y_size or 0
        library:tween(items[ "dropdown" ], {Size = dim_offset(items[ "keybind_holder" ].AbsoluteSize.X, size)})

        items[ "dropdown" ].Position = dim_offset(items[ "keybind_holder" ].AbsolutePosition.X, items[ "keybind_holder" ].AbsolutePosition.Y + items[ "keybind_holder" ].AbsoluteSize.Y + 60)
    end

    items[ "keybind_holder" ].MouseButton1Down:Connect(function()
        task.wait()
        items[ "key" ].Text = "..."

        cfg.binding = library:connection(uis.InputBegan, function(keycode, game_event)
            cfg.set(keycode.KeyCode ~= Enum.KeyCode.Unknown and keycode.KeyCode or keycode.UserInputType)

            cfg.binding:Disconnect()
            cfg.binding = nil
        end)
    end)

    items[ "keybind_holder" ].MouseButton2Down:Connect(function()
        cfg.open = not cfg.open

        cfg.set_visible(cfg.open)
    end)

    library:connection(uis.InputBegan, function(input, game_event)
        if not game_event then
            local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

            if selected_key == cfg.key then
                if cfg.mode == "Toggle" then
                    cfg.active = not cfg.active
                    cfg.set(cfg.active)
                elseif cfg.mode == "Hold" then
                    cfg.set(true)
                end
            end
        end
    end)

    library:connection(uis.InputEnded, function(input, game_event)
        if game_event then
            return
        end

        local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

        if selected_key == cfg.key then
            if cfg.mode == "Hold" then
                cfg.set(false)
            end
        end
    end)

    cfg.set({mode = cfg.mode, active = cfg.active, key = cfg.key})
    config_flags[cfg.flag] = cfg.set

    return setmetatable(cfg, library)
end

function library:button(options)
    local cfg = {
        name = options.name or "TextBox",
        callback = options.callback or function() end,
        items = {};
    }

    local items = cfg.items; do
        items[ "button_element" ] = library:create( "Frame" , {
            Parent = self.items[ "elements" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Size = dim2(1, 0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        items[ "button" ] = library:create( "TextButton" , {
            FontFace = fonts.font;
            TextColor3 = rgb(0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            AutoButtonColor = false;
            AnchorPoint = vec2(1, 0);
            Parent = items[ "button_element" ];
            Name = "\0";
            Position = dim2(1, -4, 0, 0);
            Size = dim2(1, -8, 0, 30);
            BorderSizePixel = 0;
            TextSize = 14;
            BackgroundColor3 = rgb(40, 40, 40)
        });

        library:create( "UICorner" , {
            Parent = items[ "button" ];
            CornerRadius = dim(0, 3)
        });

        items[ "name" ] = library:create( "TextLabel" , {
            FontFace = fonts.small;
            TextColor3 = themes[themes.current].accent;
            BorderColor3 = rgb(0, 0, 0);
            Text = cfg.name;
            Parent = items[ "button" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Size = dim2(1, 0, 1, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        }); library:apply_theme(items[ "name" ], "accent", "BackgroundColor3");
    end

    items[ "button" ].MouseButton1Click:Connect(function()
        cfg.callback()

        items[ "name" ].TextColor3 = themes[themes.current].accent
        library:tween(items[ "name" ], {TextColor3 = themes[themes.current].accent})
    end)

    return setmetatable(cfg, library)
end

function library:settings(options)
    local cfg = {
        open = false;
        items = {};
        sanity = true;
    }

    local items = cfg.items; do
        items[ "outline" ] = library:create( "Frame" , {
            Name = "\0";
            Visible = true;
            Parent = library[ "items" ];
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 0, 0, 0);
            ClipsDescendants = true;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundColor3 = rgb(32, 32, 32)
        });

        items[ "inline" ] = library:create( "Frame" , {
            Parent = items[ "outline" ];
            Name = "\0";
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, -2);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(32, 32, 32)
        });

        library:create( "UICorner" , {
            Parent = items[ "inline" ];
            CornerRadius = dim(0, 7)
        });

        items[ "elements" ] = library:create( "Frame" , {
            BorderColor3 = rgb(0, 0, 0);
            Parent = items[ "inline" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 10, 0, 10);
            Size = dim2(1, -20, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        library:create( "UIListLayout" , {
            Parent = items[ "elements" ];
            Padding = dim(0, 10);
            SortOrder = Enum.SortOrder.LayoutOrder
        });

        library:create( "UIPadding" , {
            PaddingBottom = dim(0, 15);
            Parent = items[ "elements" ]
        });

        library:create( "UICorner" , {
            Parent = items[ "outline" ];
            CornerRadius = dim(0, 7)
        });

        library:create( "UICorner" , {
            Parent = items[ "fade" ];
            CornerRadius = dim(0, 7)
        });

        items[ "tick" ] = library:create( "ImageButton" , {
            Image = "rbxassetid://128797200442698";
            Name = "\0";
            AutoButtonColor = false;
            Parent = self.items[ "right_components" ];
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 16, 0, 16);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        });
    end

    function cfg.set_visible(bool)
        library:tween(items[ "outline" ], {Size = dim_offset(bool and 240 or 0, 0)})
        items[ "outline" ].Position = dim_offset(items[ "tick" ].AbsolutePosition.X, items[ "tick" ].AbsolutePosition.Y + 90)
        library:close_element(cfg)
    end

    items[ "tick" ].MouseButton1Click:Connect(function()
        cfg.open = not cfg.open

        cfg.set_visible(cfg.open)
    end)

    return setmetatable(cfg, library)
end

function library:list(properties)
    local cfg = {
        items = {};
        options = properties.options or {"1", "2", "3"};
        flag = properties.flag or library:next_flag();
        callback = properties.callback or function() end;
        data_store = {};
        current_element;
    }

    local items = cfg.items; do
        items[ "list" ] = library:create( "Frame" , {
            Parent = self.items[ "elements" ];
            BackgroundTransparency = 1;
            Name = "\0";
            Size = dim2(1, 0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        library:create( "UIListLayout" , {
            Parent = items[ "list" ];
            Padding = dim(0, 10);
            SortOrder = Enum.SortOrder.LayoutOrder
        });

        library:create( "UIPadding" , {
            Parent = items[ "list" ];
            PaddingRight = dim(0, 4);
            PaddingLeft = dim(0, 4)
        });
    end

    function cfg.refresh_options(options_to_refresh)
        for _,option in cfg.data_store do
            option:Destroy()
        end

        for _, option_data in options_to_refresh do
            local button = library:create( "TextButton" , {
                FontFace = fonts.small;
                TextColor3 = rgb(0, 0, 0);
                BorderColor3 = rgb(0, 0, 0);
                Text = "";
                AutoButtonColor = false;
                AnchorPoint = vec2(1, 0);
                Parent = items[ "list" ];
                Name = "\0";
                Position = dim2(1, 0, 0, 0);
                Size = dim2(1, 0, 0, 30);
                BorderSizePixel = 0;
                TextSize = 14;
                BackgroundColor3 = rgb(40, 40, 40)
            }); cfg.data_store[#cfg.data_store + 1] = button;

            local name = library:create( "TextLabel" , {
                FontFace = fonts.font;
                TextColor3 = themes[themes.current].accent;
                BorderColor3 = rgb(0, 0, 0);
                Text = option_data;
                Parent = button;
                Name = "\0";
                BackgroundTransparency = 1;
                Size = dim2(1, 0, 1, 0);
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.XY;
                TextSize = 14;
                BackgroundColor3 = rgb(255, 255, 255)
            });

            library:create( "UICorner" , {
                Parent = button;
                CornerRadius = dim(0, 3)
            });

            button.MouseButton1Click:Connect(function()
                local current = cfg.current_element
                if current and current ~= name then
                    library:tween(current, {TextColor3 = rgb(72, 72, 72)})
                end

                flags[cfg.flag] = option_data
                cfg.callback(option_data)
                library:tween(name, {TextColor3 = rgb(245, 245, 245)})
                cfg.current_element = name
            end)

            name.MouseEnter:Connect(function()
                if cfg.current_element == name then
                    return
                end

                library:tween(name, {TextColor3 = rgb(140, 140, 140)})
            end)

            name.MouseLeave:Connect(function()
                if cfg.current_element == name then
                    return
                end

                library:tween(name, {TextColor3 = rgb(72, 72, 72)})
            end)
        end
    end

    cfg.refresh_options(cfg.options)

    return setmetatable(cfg, library)
end

function library:init_config(window)
    window:seperator({name = "Settings"})
    local main = window:tab({name = "Configs", tabs = {"Main"}})

    local column = main:column({})
    local section = column:section({name = "Configs", size = 1, default = true, icon = "rbxassetid://139628202576511"})
    config_holder = section:list({options = {"Report", "This", "Error", "To", "Finobe"}, callback = function(option) end, flag = "config_name_list"}); library:update_config_list()

    local column = main:column({})
    local section = column:section({name = "Settings", side = "right", size = 1, default = true, icon = "rbxassetid://129380150574313"})
    section:textbox({name = "Config name:", flag = "config_name_text"})
    section:button({name = "Save", callback = function() writefile(library.directory .. "/configs/" .. flags["config_name_text"] or flags["config_name_list"] .. ".cfg", library:get_config()) library:update_config_list() notifications:create_notification({name = "Configs", info = "Saved config to:\n" .. flags["config_name_list"] or flags["config_name_text"]}) end})
    section:button({name = "Load", callback = function() library:load_config(readfile(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg"))  library:update_config_list() notifications:create_notification({name = "Configs", info = "Loaded config:\n" .. flags["config_name_list"]}) end})
    section:button({name = "Delete", callback = function() delfile(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg")  library:update_config_list() notifications:create_notification({name = "Configs", info = "Deleted config:\n" .. flags["config_name_list"]}) end})
    section:keybind({name = "Menu Bind", callback = function(bool) window.toggle_menu(bool) end, default = true})
end

function notifications:refresh_notifs()
    local offset = 50

    for i, v in notifications.notifs do
        local Position = vec2(20, offset)
        library:tween(v, {Position = dim_offset(Position.X, Position.Y)}, Enum.EasingStyle.Quad, 0.4)
        offset += (v.AbsoluteSize.Y + 10)
    end

    return offset
end

function notifications:fade(path, is_fading)
    local fading = is_fading and 1 or 0

    library:tween(path, {BackgroundTransparency = fading}, Enum.EasingStyle.Quad, 1)

    for _, instance in path:GetDescendants() do
        if not instance:IsA("GuiObject") then
            if instance:IsA("UIStroke") then
                library:tween(instance, {Transparency = fading}, Enum.EasingStyle.Quad, 1)
            end

            continue
        end

        if instance:IsA("TextLabel") then
            library:tween(instance, {TextTransparency = fading})
        elseif instance:IsA("Frame") then
            library:tween(instance, {BackgroundTransparency = instance.Transparency and 0.6 and is_fading and 1 or 0.6}, Enum.EasingStyle.Quad, 1)
        end
    end
end

function notifications:create_notification(options)
    local cfg = {
        name = options.name or "This is a title!";
        info = options.info or "This is extra info!";
        lifetime = options.lifetime or 3;
        items = {};
        outline;
    }

    local items = cfg.items; do
        items[ "notification" ] = library:create( "Frame" , {
            Parent = library[ "items" ];
            Size = dim2(0, 210, 0, 53);
            Name = "\0";
            BorderColor3 = rgb(0, 0, 0);
            BorderSizePixel = 0;
            BackgroundTransparency = 1;
            AnchorPoint = vec2(1, 0);
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundColor3 = rgb(32, 32, 32)
        });

        library:create( "UIStroke" , {
            Color = rgb(23, 23, 29);
            Parent = items[ "notification" ];
            Transparency = 1;
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        });

        items[ "title" ] = library:create( "TextLabel" , {
            FontFace = fonts.font;
            TextColor3 = themes[themes.current].accent;
            BorderColor3 = rgb(0, 0, 0);
            Text = cfg.name;
            Parent = items[ "notification" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 7, 0, 6);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        library:create( "UICorner" , {
            Parent = items[ "notification" ];
            CornerRadius = dim(0, 3)
        });

        items[ "info" ] = library:create( "TextLabel" , {
            FontFace = fonts.font;
            TextColor3 = rgb(145, 145, 145);
            BorderColor3 = rgb(0, 0, 0);
            Text = cfg.info;
            Parent = items[ "notification" ];
            Name = "\0";
            Position = dim2(0, 9, 0, 22);
            BorderSizePixel = 0;
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextWrapped = true;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        library:create( "UIPadding" , {
            PaddingBottom = dim(0, 17);
            PaddingRight = dim(0, 8);
            Parent = items[ "info" ]
        });

        items[ "bar" ] = library:create( "Frame" , {
            AnchorPoint = vec2(0, 1);
            Parent = items[ "notification" ];
            Name = "\0";
            Position = dim2(0, 8, 1, -6);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 0, 0, 5);
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            BackgroundColor3 = themes[themes.current].accent
        });

        library:create( "UICorner" , {
            Parent = items[ "bar" ];
            CornerRadius = dim(0, 999)
        });

        library:create( "UIPadding" , {
            PaddingRight = dim(0, 8);
            Parent = items[ "notification" ]
        });
    end

    local index = #notifications.notifs + 1
    notifications.notifs[index] = items[ "notification" ]

    notifications:fade(items[ "notification" ], false)

    local offset = notifications:refresh_notifs()

    items[ "notification" ].Position = dim_offset(20, offset)

    library:tween(items[ "notification" ], {AnchorPoint = vec2(0, 0)}, Enum.EasingStyle.Quad, 1)
    library:tween(items[ "bar" ], {Size = dim2(1, -8, 0, 5)}, Enum.EasingStyle.Quad, cfg.lifetime)

    task.spawn(function()
        task.wait(cfg.lifetime)

        notifications.notifs[index] = nil

        notifications:fade(items[ "notification" ], true)

        library:tween(items[ "notification" ], {AnchorPoint = vec2(1, 0)}, Enum.EasingStyle.Quad, 1)

        task.wait(1)

        items[ "notification" ]:Destroy()
    end)
end

return library
