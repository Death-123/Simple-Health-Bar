local function isDST() return GLOBAL.TheSim:GetGameID() == "DST" end
local function isClient() return isDST() and GLOBAL.TheNet:GetIsClient() end
local function getPlayer() if isDST() then return GLOBAL.ThePlayer else return GLOBAL.GetPlayer() end end
local function getWorld() if isDST() then return GLOBAL.TheWorld else return GLOBAL.GetWorld() end end
PrefabFiles = { "dychealthbar", }
Assets = {}
STRINGS = GLOBAL.STRINGS
RECIPETABS = GLOBAL.RECIPETABS
Recipe = GLOBAL.Recipe
Ingredient = GLOBAL.Ingredient
TECH = GLOBAL.TECH
TUNING = GLOBAL.TUNING
FRAMES = GLOBAL.FRAMES
SpawnPrefab = GLOBAL.SpawnPrefab
Vector3 = GLOBAL.Vector3
tostring = GLOBAL.tostring
tonumber = GLOBAL.tonumber
require = GLOBAL.require
TheSim = GLOBAL.TheSim
local RGBAColor = function(r, g, b, a)
    return {
        r = r or 1,
        g = g or 1,
        b = b or 1,
        a = a or 1,
        Get = function(self) return self.r, self.g, self.b, self.a end,
        Set = function(self, r, g, b, a)
            self.r = r or 1; self.g = g or 1; self.b = b or 1; self.a = a or 1;
        end,
    }
end
local colors = {
    New = RGBAColor,
    Red = RGBAColor(1, 0, 0, 1),
    Green = RGBAColor(0, 1, 0, 1),
    Blue = RGBAColor(0, 0, 1, 1),
    White = RGBAColor(1, 1, 1, 1),
    Black = RGBAColor(0, 0, 0, 1),
    Yellow = RGBAColor(1, 1, 0, 1),
    Magenta = RGBAColor(1, 0, 1, 1),
    Cyan = RGBAColor(0, 1, 1, 1),
    Gray = RGBAColor(0.5, 0.5, 0.5, 1),
    Orange = RGBAColor(1, 0.5, 0, 1),
    Purple = RGBAColor(0.5, 0, 1, 1),
    GetColor = function(self, key)
        if key == nil then return end
        for k, color in pairs(self) do
            if type(color) == "table" and color.r then
                if string.lower(k) == string.lower(key) then
                    return color
                end
            end
        end
    end,
}
local function foreceUpdateHealthBar()
    if not getWorld() then return end
    TUNING.DYC_HEALTHBAR_FORCEUPDATE = true
    getWorld():DoTaskInTime(GLOBAL.FRAMES * 4, function() TUNING.DYC_HEALTHBAR_FORCEUPDATE = false end)
end
GLOBAL.SHB = {}
GLOBAL.shb = GLOBAL.SHB
GLOBAL.SimpleHealthBar = GLOBAL.SHB
local SimpleHealthBar = GLOBAL.SHB
SimpleHealthBar.version = modinfo.version
SimpleHealthBar.Color = colors
SimpleHealthBar.ShowBanner = function() end
SimpleHealthBar.PushBanner = function() end
SimpleHealthBar.SetColor = function(colorOrR, g, b)
    if colorOrR and type(colorOrR) == "string" then
        if colorOrR == "cfg" then
            SimpleHealthBar.SetColor(TUNING.DYC_HEALTHBAR_COLOR_CFG)
            return
        end
        local colorName = string.lower(colorOrR)
        for k, color in pairs(colors) do
            if string.lower(k) == colorName and type(color) == "table" then
                TUNING.DYC_HEALTHBAR_COLOR = color
                foreceUpdateHealthBar()
                return
            end
        end
    elseif colorOrR and g and b and type(colorOrR) == "number" and type(g) == "number" and type(b) == "number" then
        TUNING.DYC_HEALTHBAR_COLOR = colors.New(colorOrR, g, b)
        foreceUpdateHealthBar()
        return
    end
    TUNING.DYC_HEALTHBAR_COLOR = colorOrR
    foreceUpdateHealthBar()
end
SimpleHealthBar.setcolor = SimpleHealthBar.SetColor
SimpleHealthBar.SETCOLOR = SimpleHealthBar.SetColor
SimpleHealthBar.SetLength = function(length)
    length = length or 10
    if type(length) ~= "number" then if length == "cfg" then length = TUNING.DYC_HEALTHBAR_CNUM_CFG else length = 10 end end
    length = math.floor(length)
    if length < 1 then length = 1 end
    if length > 100 then length = 100 end
    TUNING.DYC_HEALTHBAR_CNUM = length
    foreceUpdateHealthBar()
end
SimpleHealthBar.setlength = SimpleHealthBar.SetLength
SimpleHealthBar.SETLENGTH = SimpleHealthBar.SetLength
SimpleHealthBar.SetDuration = function(duration)
    duration = duration or 8
    if type(duration) ~= "number" then duration = 8 end
    if duration < 4 then duration = 4 end
    if duration > 999999 then duration = 999999 end
    TUNING.DYC_HEALTHBAR_DURATION = duration
end
SimpleHealthBar.setduration = SimpleHealthBar.SetDuration
SimpleHealthBar.SETDURATION = SimpleHealthBar.SetDuration
SimpleHealthBar.SetStyle = function(styleOrC1, c2, mode)
    if styleOrC1 and c2 and type(styleOrC1) == "string" and type(c2) == "string" then
        TUNING.DYC_HEALTHBAR_STYLE = { c1 = styleOrC1, c2 = c2 }
    elseif styleOrC1 == "cfg" then
        TUNING.DYC_HEALTHBAR_STYLE = TUNING.DYC_HEALTHBAR_STYLE_CFG
    else
        if mode == "c" then
            TUNING.DYC_HEALTHBAR_STYLE_CHAR = styleOrC1 and string.lower(styleOrC1) or nil
        elseif mode == "b" then
            TUNING.DYC_HEALTHBAR_STYLE_BOSS = styleOrC1 and string.lower(styleOrC1) or nil
        else
            TUNING.DYC_HEALTHBAR_STYLE = styleOrC1 and string.lower(styleOrC1) or "standard"
        end
        -- local _9fL8 = styleOrC1 and GLOBAL["SimpleHealthBar"]["lib"]["TableContains"](GLOBAL["SimpleHealthBar"][GLOBAL["SimpleHealthBar"]["ds"]("{xmkqitPJ{")], styleOrC1)
        local isSpecial = styleOrC1 and GLOBAL["SimpleHealthBar"]["lib"]["TableContains"](GLOBAL["SimpleHealthBar"]["specialHBs"], styleOrC1)
        if isSpecial then GLOBAL["SimpleHealthBar"]["GetUData"](styleOrC1, function(data) if not data then GLOBAL["SimpleHealthBar"]["SetStyle"]("standard", nil, mode) end end) end
    end
    foreceUpdateHealthBar()
    if SimpleHealthBar.onUpdateHB then SimpleHealthBar.onUpdateHB(styleOrC1, c2) end
end
SimpleHealthBar.setstyle = SimpleHealthBar.SetStyle
SimpleHealthBar.SETSTYLE = SimpleHealthBar.SetStyle
local function setStyleC(styleOrC1, C2) if styleOrC1 == "global" then SimpleHealthBar.SetStyle(nil, nil, "c") else SimpleHealthBar.SetStyle(styleOrC1, C2, "c") end end
SimpleHealthBar.SetPos = function(pos)
    if pos and string.lower(pos) == "bottom" then
        TUNING.DYC_HEALTHBAR_POSITION = 0
    elseif pos and string.lower(pos) == "overhead2" then
        TUNING.DYC_HEALTHBAR_POSITION = 2
    elseif pos == "cfg" then
        TUNING.DYC_HEALTHBAR_POSITION =
            TUNING.DYC_HEALTHBAR_POSITION_CFG
    else
        TUNING.DYC_HEALTHBAR_POSITION = 1
    end
    foreceUpdateHealthBar()
end
SimpleHealthBar.setpos = SimpleHealthBar.SetPos
SimpleHealthBar.SETPOS = SimpleHealthBar.SetPos
SimpleHealthBar.SetPosition = SimpleHealthBar.SetPos
SimpleHealthBar.setposition = SimpleHealthBar.SetPos
SimpleHealthBar.SETPOSITION = SimpleHealthBar.SetPos
SimpleHealthBar.ValueOn = function()
    TUNING.DYC_HEALTHBAR_VALUE = true
    foreceUpdateHealthBar()
end
SimpleHealthBar.valueon = SimpleHealthBar.ValueOn
SimpleHealthBar.VALUEON = SimpleHealthBar.ValueOn
SimpleHealthBar.ValueOff = function()
    TUNING.DYC_HEALTHBAR_VALUE = false
    foreceUpdateHealthBar()
end
SimpleHealthBar.valueoff = SimpleHealthBar.ValueOff
SimpleHealthBar.VALUEOFF = SimpleHealthBar.ValueOff
SimpleHealthBar.DDOn = function() TUNING.DYC_HEALTHBAR_DDON = true end
SimpleHealthBar.ddon = SimpleHealthBar.DDOn
SimpleHealthBar.DDON = SimpleHealthBar.DDOn
SimpleHealthBar.DDOff = function() TUNING.DYC_HEALTHBAR_DDON = false end
SimpleHealthBar.ddoff = SimpleHealthBar.DDOff
SimpleHealthBar.DDOFF = SimpleHealthBar.DDOff
SimpleHealthBar.SetLimit = function(maxNum)
    maxNum = maxNum or 0
    maxNum = math.floor(maxNum)
    TUNING.DYC_HEALTHBAR_LIMIT = maxNum
    if TUNING.DYC_HEALTHBAR_LIMIT > 0 then
        while #SimpleHealthBar.hbs > TUNING.DYC_HEALTHBAR_LIMIT do
            local hb = SimpleHealthBar.hbs[1]
            table.remove(SimpleHealthBar.hbs, 1)
            hb:Remove()
        end
    end
end
SimpleHealthBar.setlimit = SimpleHealthBar.SetLimit
SimpleHealthBar.SETLIMIT = SimpleHealthBar.SetLimit
SimpleHealthBar.SetOpacity = function(opacity)
    opacity = opacity or 1
    opacity = math.max(0.1, math.min(opacity, 1))
    TUNING.DYC_HEALTHBAR_OPACITY = opacity
    if SimpleHealthBar.onUpdateHB then SimpleHealthBar.onUpdateHB(str, str2) end
end
SimpleHealthBar.setopacity = SimpleHealthBar.SetOpacity
SimpleHealthBar.SETOPACITY = SimpleHealthBar.SetOpacity
SimpleHealthBar.ToggleAnimation = function(enable) TUNING.DYC_HEALTHBAR_ANIMATION = enable and true or false end
SimpleHealthBar.toggleanimation = SimpleHealthBar.ToggleAnimation
SimpleHealthBar.TOGGLEANIMATION = SimpleHealthBar.ToggleAnimation
SimpleHealthBar.ToggleWallHB = function(enable) TUNING.DYC_HEALTHBAR_WALLHB = enable and true or false end
SimpleHealthBar.togglewallhb = SimpleHealthBar.ToggleWallHB
SimpleHealthBar.TOGGLEWALLHB = SimpleHealthBar.ToggleWallHB
SimpleHealthBar.SetThickness = function(thickness)
    thickness = thickness ~= nil and type(thickness) == "number" and thickness or 1.0
    TUNING.DYC_HEALTHBAR_THICKNESS = thickness
    if thickness > 2 then TUNING.DYC_HEALTHBAR_FIXEDTHICKNESS = true else TUNING.DYC_HEALTHBAR_FIXEDTHICKNESS = false end
end
SimpleHealthBar.setthickness = SimpleHealthBar.SetThickness
SimpleHealthBar.SETTHICKNESS = SimpleHealthBar.SetThickness
TUNING.DYC_HEALTHBAR_STYLE = GetModConfigData("hbstyle") or "standard"
TUNING.DYC_HEALTHBAR_STYLE_CFG = TUNING.DYC_HEALTHBAR_STYLE
TUNING.DYC_HEALTHBAR_CNUM = GetModConfigData("hblength") or 10
TUNING.DYC_HEALTHBAR_CNUM_CFG = TUNING.DYC_HEALTHBAR_CNUM
TUNING.DYC_HEALTHBAR_DURATION = 8
TUNING.DYC_HEALTHBAR_POSITION = GetModConfigData("hbpos") or "overhead"
TUNING.DYC_HEALTHBAR_POSITION_CFG = TUNING.DYC_HEALTHBAR_POSITION
TUNING.DYC_HEALTHBAR_VALUE = GetModConfigData("value") or (GetModConfigData("value") == nil and true)
TUNING.DYC_HEALTHBAR_VALUE_CFG = TUNING.DYC_HEALTHBAR_VALUE
local hbcolor = GetModConfigData("hbcolor")
TUNING.DYC_HEALTHBAR_COLOR_CFG = hbcolor
SimpleHealthBar.SetColor(hbcolor)
TUNING.DYC_HEALTHBAR_DDON = GetModConfigData("ddon") or (GetModConfigData("ddon") == nil and true)
TUNING.DYC_HEALTHBAR_DDON_CFG = TUNING.DYC_HEALTHBAR_DDON
TUNING.DYC_HEALTHBAR_DDDURATION = 0.65
TUNING.DYC_HEALTHBAR_DDSIZE1 = 20
TUNING.DYC_HEALTHBAR_DDSIZE2 = 50
TUNING.DYC_HEALTHBAR_DDTHRESHOLD = 0.1
TUNING.DYC_HEALTHBAR_MAXDIST = 35
TUNING.DYC_HEALTHBAR_LIMIT = 0
TUNING.DYC_HEALTHBAR_WALLHB = true
SimpleHealthBar.hbs = {}
local decode = function(str, offset, interval, flag)
    offset = offset or 8
    local num1, num2 = flag and 255 or 126, flag and 0 or 33
    local decodeStr = ""
    local encodeChar = function(char, offset, flag)
        if flag or (char ~= 9 and char ~= 10 and char ~= 13 and char ~= 32) then
            char = char + offset
            while char > num1 do char = char - (num1 - num2 + 1) end
            while char < num2 do char = char + (num1 - num2 + 1) end
        end
        return char
    end
    for i = 1, #str do
        local char = string.byte(string.sub(str, i, i))
        if interval and interval > 1 and i % interval == 0 then
            char = encodeChar(char, offset, flag)
        else
            char = encodeChar(char, -offset, flag)
        end
        decodeStr = decodeStr .. string.char(char)
    end
    return decodeStr
end
SimpleHealthBar.ds = decode
local readFile = function(path)
    -- local _E447 = GLOBAL[decode("qw")][decode("wxmv")]
    local open = GLOBAL["io"]["open"]
    local file, err = open(path, "r")
    if err then else
        local content = file:read("*all")
        file:close()
        return content
    end
    return ""
end
local loadModFile = function(path)
    local modRoot = "../mods/" .. modname .. "/"
    -- local _eXvz = GLOBAL[decode("stmqtwilt}i")](modRoot .. _VirW)
    local fn = GLOBAL["kleiloadlua"](modRoot .. path)
    if fn ~= nil and type(fn) == "function" then
        return fn
    elseif fn ~= nil and type(fn) == "string" then
        -- local _jZ1B = decode(_NVCv(modRoot .. _VirW), 11, 3)
        local luaStringDecoded = decode(readFile(modRoot .. path), 11, 3)
        return GLOBAL.loadstring(luaStringDecoded)
    else
        return nil
    end
end
local function loadFile(path, env)
    local fn = loadModFile(path)
    if fn then
        if env then setfenv(fn, env) end
        return fn(), path .. " is loaded."
    else
        return nil, "Error loading " .. path .. "!"
    end
end
SimpleHealthBar.lf = loadFile
-- local _yRKA = GLOBAL["TheSim"][decode("Om|]{mzQL")](GLOBAL["TheSim"])
local userId = GLOBAL["TheSim"]["GetUserID"](GLOBAL["TheSim"])
-- SimpleHealthBar[decode("}ql")] = userId
SimpleHealthBar["uid"] = userId
-- SimpleHealthBar[decode("tqj")] = lf(decode("{kzqx|{7l#kuq{k6t}i"))
SimpleHealthBar["lib"] = loadFile("scripts/dycmisc.lua")
-- SimpleHealthBar[decode("twkitq$i|qwv")] = loadFile(decode("twkitq$i|qwv6t}i"))
SimpleHealthBar["localization"] = loadFile("localization.lua")
-- SimpleHealthBar[decode("OPJ")] = loadFile(decode("{kzqx|{7l#kopj6t}i"))
SimpleHealthBar["GHB"] = loadFile("scripts/dycghb.lua")
-- SimpleHealthBar[decode("twkitLi|i")] = SimpleHealthBar["lib"][decode("TwkitLi|i")]()
SimpleHealthBar["localData"] = SimpleHealthBar["lib"]["LocalData"]()
-- SimpleHealthBar[decode("twkitLi|i")]:SetName("SimpleHealthBar")
SimpleHealthBar["localData"]:SetName("SimpleHealthBar")
-- SimpleHealthBar[decode("o}q{")] = loadFile(decode("{kzqx|{7l#ko}q{6t}i"))
SimpleHealthBar["guis"] = loadFile("scripts/dycguis.lua")
local StrSpl = SimpleHealthBar.lib.StrSpl
local function loadLocalData()
    local localData = SimpleHealthBar["localData"]
    local menu = SimpleHealthBar.menu
    localData:GetString("gstyle", function(data) menu.gStyleSpinner:SetSelected(data, "standard") end)
    localData:GetString("bstyle", function(data) menu.bStyleSpinner:SetSelected(data, "global") end)
    localData:GetString("cstyle", function(data) menu.cStyleSpinner:SetSelected(data, "global") end)
    localData:GetString("value", function(data) menu.valueSpinner:SetSelected(data, "true") end)
    localData:GetString("length", function(data) if data == "cfg" then menu.lengthSpinner:SetSelected(data, 10) else menu.lengthSpinner:SetSelected(data ~= nil and tonumber(data), 10) end end)
    localData:GetString("thickness", function(data) menu.thicknessSpinner:SetSelected(data ~= nil and tonumber(data), 0x16) end)
    localData:GetString("pos", function(data) menu.posSpinner:SetSelected(data, "overhead2") end)
    localData:GetString("color", function(data) menu.colorSpinner:SetSelected(data, "dynamic2") end)
    localData:GetString("opacity", function(data) menu.opacitySpinner:SetSelected(data ~= nil and tonumber(data), 0.8) end)
    localData:GetString("dd", function(data) menu.ddSpinner:SetSelected(data, "true") end)
    localData:GetString("limit", function(data) menu.limitSpinner:SetSelected(data ~= nil and tonumber(data), 0) end)
    localData:GetString("anim", function(data) menu.animSpinner:SetSelected(data, "true") end)
    localData:GetString("wallhb", function(data) menu.wallhbSpinner:SetSelected(data, "false") end)
    localData:GetString("hotkey", function(data) menu.hotkeySpinner:SetSelected(data, "KEY_H") end)
    localData:GetString("icon", function(data) menu.iconSpinner:SetSelected(data, "true") end)
end
local function setLocalData(data)
    local localData = SimpleHealthBar["localData"]
    localData:SetString("gstyle", data.gstyle)
    localData:SetString("bstyle", data.bstyle)
    localData:SetString("cstyle", data.cstyle)
    localData:SetString("value", data.value)
    localData:SetString("length", tostring(data.length))
    localData:SetString("thickness", tostring(data.thickness))
    localData:SetString("pos", data.pos)
    localData:SetString("color", data.color)
    localData:SetString("opacity", tostring(data.opacity))
    localData:SetString("dd", data.dd)
    localData:SetString("limit", tostring(data.limit))
    localData:SetString("anim", data.anim)
    localData:SetString("wallhb", data.wallhb)
    localData:SetString("hotkey", data.hotkey)
    localData:SetString("icon", data.icon)
end
local function Reset()
    local menu = SimpleHealthBar.menu
    menu.gStyleSpinner:SetSelected("standard")
    menu.bStyleSpinner:SetSelected("global")
    menu.cStyleSpinner:SetSelected("global")
    menu.valueSpinner:SetSelected("true")
    menu.lengthSpinner:SetSelected(10)
    menu.thicknessSpinner:SetSelected(0x16)
    menu.posSpinner:SetSelected("overhead2")
    menu.colorSpinner:SetSelected("dynamic2")
    menu.opacitySpinner:SetSelected(0.8)
    menu.ddSpinner:SetSelected("true")
    menu.limitSpinner:SetSelected(0)
    menu.animSpinner:SetSelected("true")
    menu.wallhbSpinner:SetSelected("false")
    menu.hotkeySpinner:SetSelected("KEY_H")
    menu.iconSpinner:SetSelected("true")
    menu:DoApply()
end
SimpleHealthBar.Reset = Reset
SimpleHealthBar.reset = Reset
SimpleHealthBar.RESET = Reset
SimpleHealthBar.SetLanguage = function(language)
    SimpleHealthBar.localization:SetLanguage(language)
    SimpleHealthBar.menu:RefreshPage()
    loadLocalData()
    print("Language has been set to " .. SimpleHealthBar.localization.supportedLanguage)
end
SimpleHealthBar.setlanguage = SimpleHealthBar.SetLanguage
SimpleHealthBar.SETLANGUAGE = SimpleHealthBar.SetLanguage
SimpleHealthBar.sl = SimpleHealthBar.SetLanguage
local yiyu1 = "\121\105\121\117"
local yiyu2 = "\231\191\188\232\175\173"
local banlist = {
    "642704851",
    "701574438",
    "834039799",
    "845740921",
    "1088165487",
    "1161719409",
    "1546144229",
    "1559975778",
    "1626938843",
    "1656314475",
    "1656333678",
    "1883082987",
    "2199037549203167410",
    "2199037549203167802",
    "2199037549203167776",
    "2199037549203167775",
    "2199037549203168585",
}
local isBaned = function(name)
    if name and (string.find(string.lower(name), yiyu1, 1, true) or string.find(string.lower(name), yiyu2, 1, true)) then return true end
    for _, id in pairs(banlist) do if name and name == "workshop-" .. id then return true end end
    return false
end
local banlist2 = { "1883724202", }
local function isBaned2(name)
    local baned = isBaned(name)
    local flag = false
    for _, id in pairs(banlist2) do
        if name and name == "workshop-" .. id then
            flag = true
            break
        end
    end
    return baned or flag
end
local checkBanMod = function()
    local banedNames = ""
    for name, mod in pairs(GLOBAL.KnownModIndex.savedata.known_mods) do
        if mod.enabled and (isBaned2(name) or (mod.modinfo and mod.modinfo.author and isBaned2(mod.modinfo.author))) then
            banedNames = #banedNames > 0 and banedNames .. "," .. name or name
        end
    end
    if #banedNames > 0 then
        GLOBAL.error("The game is incompatible with following mod(s):\n" .. banedNames)
        GLOBAL.assert(nil, "The game is incompatible with following mod(s):\n" .. banedNames)
        print("‘]]" + 4)
        local err = GLOBAL.error
        GLOBAL.error(banedNames)
        GLOBAL.error("" .. math.random())
        GLOBAL.assert(nil)
        err(list)
        local _TAAL = math.max + {}
        err(ent)
        AddPrefabPostInit = zzz
        AddPrefabPostInitAny = qqq
        SimpleHealthBar = 0x309
        SuperWall = fff
    end
end
local function run(world)
    world:DoPeriodicTask(FRAMES,
        function()
            local player = getPlayer()
            if not player then return end
            if world.DYCSHBPlayerHud == player.HUD or player.HUD == nil then return else world.DYCSHBPlayerHud = player.HUD end
            checkBanMod(444)
            local localData = SimpleHealthBar["localData"]
            local langStrings = SimpleHealthBar.localization:GetStrings()
            local Root = SimpleHealthBar.guis.Root
            local dycSHBRoot = player.HUD.root:AddChild(Root({ keepTop = true, }))
            player.HUD.dycSHBRoot = dycSHBRoot
            SimpleHealthBar["ShowMessage"] = function(message, title, callback, fontSize, animateWidth, animateHeight, width, height, ifAnimateIn)
                SimpleHealthBar.guis["MessageBox"]["ShowMessage"](message, title, dycSHBRoot, langStrings, callback, fontSize, animateWidth, animateHeight, width, height, ifAnimateIn)
            end
            local CfgMenu = SimpleHealthBar.guis.CfgMenu
            local menu = dycSHBRoot:AddChild(CfgMenu({
                localization = SimpleHealthBar.localization,
                strings = langStrings,
                GHB = SimpleHealthBar.GHB,
                GetHBStyle = SimpleHealthBar.GetHBStyle,
                GetEntHBColor = SimpleHealthBar.GetEntHBColor,
                ["ShowMessage"] = SimpleHealthBar["ShowMessage"]
            }))
            SimpleHealthBar.menu = menu
            menu:Hide()
            loadLocalData()
            menu.applyFn = function(self, data)
                langStrings = SimpleHealthBar.localization.strings
                SimpleHealthBar.SetStyle(data.gstyle)
                SimpleHealthBar.SetStyle(data.bstyle ~= "global" and data.bstyle, nil, "b")
                setStyleC(data.cstyle)
                if data.value == "cfg" then
                    if TUNING.DYC_HEALTHBAR_VALUE_CFG then SimpleHealthBar.ValueOn() else SimpleHealthBar.ValueOff() end
                elseif data.value == "true" then
                    SimpleHealthBar.ValueOn()
                else
                    SimpleHealthBar.ValueOff()
                end
                SimpleHealthBar.SetLength(data.length)
                SimpleHealthBar.SetThickness(data.thickness)
                SimpleHealthBar.SetPos(data.pos)
                SimpleHealthBar.SetColor(data.color)
                SimpleHealthBar.SetOpacity(data.opacity)
                if data.dd == "cfg" then
                    if TUNING.DYC_HEALTHBAR_DDON_CFG then SimpleHealthBar.DDOn() else SimpleHealthBar.DDOff() end
                else
                    if data.dd == "true" then
                        SimpleHealthBar.DDOn()
                    else
                        SimpleHealthBar.DDOff()
                    end
                end
                SimpleHealthBar.SetLimit(data.limit)
                if data.anim == "false" then SimpleHealthBar.ToggleAnimation(false) else SimpleHealthBar.ToggleAnimation(true) end
                if data.wallhb == "false" then SimpleHealthBar.ToggleWallHB(false) else SimpleHealthBar.ToggleWallHB(true) end
                if data.icon == "false" then if SimpleHealthBar.menuSwitch then SimpleHealthBar.menuSwitch:Hide() end else if SimpleHealthBar.menuSwitch then SimpleHealthBar.menuSwitch:Show() end end
                if data.icon == "false" and data.hotkey == "" then
                    SimpleHealthBar.PushBanner(langStrings:GetString("hint_mistake"), 25, { 1, 1, 0.7 })
                elseif data.icon == "false" and data.hotkey ~= "" then
                    SimpleHealthBar.PushBanner(string.format(langStrings:GetString("hint_hotkeyreminder"), data.hotkey), 8, { 1, 1, 0.7 })
                end
                setLocalData(data)
            end
            menu.cancelFn = function(self) loadLocalData() end
            local ImageButton = SimpleHealthBar.guis.ImageButton
            local menuSwitch = dycSHBRoot:AddChild(ImageButton({
                width = 60,
                height = 60,
                draggable = true,
                followScreenScale = true,
                atlas = "images/dyc_shb_icon.xml",
                normal = "dyc_shb_icon.tex",
                focus = "dyc_shb_icon.tex",
                disabled = "dyc_shb_icon.tex",
                colornormal = RGBAColor(1, 1, 1, 0.7),
                colorfocus = RGBAColor(1, 1, 1, 1),
                colordisabled = RGBAColor(0.4, 0.4, 0.4, 1),
                cb = function()
                    menu:Toggle()
                    menu.dragging = false
                end,
            }))
            local oldSetPosition = menuSwitch.SetPosition
            menuSwitch.SetPosition = function(self, x, y, z, useOld)
                if useOld then
                    oldSetPosition(self, x, y, z)
                    return
                end
                local pos = nil
                if x and type(x) == "table" then pos = x else pos = Vector3(x or 0, y or 0, z or 0) end
                local sw, sh = GLOBAL.TheSim:GetScreenSize()
                local sx, sy = self:GetWorldPosition():Get()
                local x, y = self:GetPosition():Get()
                sx = sx + pos.x - x
                sy = sy + pos.y - y
                x, y = pos.x, pos.y
                local dx = (sx < -sw and -sw - sx) or (sx > 0 and -sx) or 0
                local dy = (sy < -sh and -sh - sy) or (sy > 0 and -sy) or 0
                oldSetPosition(self, x + dx, y + dy)
            end
            menuSwitch:SetHAnchor(GLOBAL.ANCHOR_RIGHT)
            menuSwitch:SetVAnchor(GLOBAL.ANCHOR_TOP)
            menuSwitch:SetPosition(-680, -60)
            menuSwitch.hintText = menuSwitch:AddChild(SimpleHealthBar.guis.Text({ fontSize = 30, color = RGBAColor(1, 0.4, 0.3, 1), }))
            menuSwitch.hintText:SetPosition(0, -60, 0)
            menuSwitch.hintText:Hide()
            menuSwitch.focusFn = function()
                menuSwitch.hintText:Show()
                menuSwitch.hintText:SetText(langStrings:GetString("title") .. "\n(" .. langStrings:GetString("draggable") .. ")")
                menuSwitch.hintText:AnimateIn()
            end
            menuSwitch.unfocusFn = function() menuSwitch.hintText:Hide() end
            menuSwitch.dragEndFn = function()
                local x, y = menuSwitch:GetPosition():Get()
                x = x / (menuSwitch.screenScale or 1)
                y = y / (menuSwitch.screenScale or 1)
                localData:SetString("iconx", tostring(x))
                localData:SetString("icony", tostring(y))
            end
            localData:GetString("iconx",
                function(data)
                    local x = data ~= nil and tonumber(data)
                    localData:GetString("icony", function(data_)
                        local y = data_ ~= nil and tonumber(data_)
                        if x and y then menuSwitch:SetPosition(x, y, 0, true) end
                    end)
                end)
            SimpleHealthBar.menuSwitch = menuSwitch
            local BannerHolder = SimpleHealthBar.guis.BannerHolder
            local dycSHBBannerHolder = player.HUD.root:AddChild(BannerHolder())
            player.HUD.dycSHBBannerHolder = dycSHBBannerHolder
            SimpleHealthBar.bannerSystem = dycSHBBannerHolder
            SimpleHealthBar.ShowBanner = function(...) SimpleHealthBar.bannerSystem:ShowMessage(...) end
            SimpleHealthBar.PushBanner = function(...) SimpleHealthBar.bannerSystem:PushMessage(...) end
            menu:DoApply()
            -- local _DFYE = GLOBAL[decode("\\]VQVO")][decode("LI[JgLWVM")]
            local DASB_DONE = GLOBAL["TUNING"]["DASB_DONE"]
            -- GLOBAL[decode("i{{mz|")](DASB_DONE, decode("M{{mv|qit nqtm uq{{qvo)"))
            GLOBAL["assert"](DASB_DONE, "Essential file missing!")
            -- local _XmS2 = env[decode("zknv")]
            local rcfn = env["rcfn"]
            if rcfn then
                local err = rcfn()
                -- if err then GLOBAL[decode("mzzwz")](err) end
                if err then GLOBAL["error"](err) end
            end
        end)
end
AddPrefabPostInit("world", run)
-- SimpleHealthBar[decode("{xmkqitPJ{")] = { decode("~qk|wzqiv"), decode("j}kspwzv"), decode("xq\"mt"), }
SimpleHealthBar["specialHBs"] = { "victorian", "buckhorn", "pixel", }
-- SimpleHealthBar[decode("Om|]Li|i")] = function(_bMHB, _52aY)
SimpleHealthBar["GetUData"] = function(key, fn)
    local localData = SimpleHealthBar["localData"]
    -- local _ItMq = SimpleHealthBar[decode("}ql")]
    local uid = SimpleHealthBar["uid"]
    if not uid then
        if fn then fn() end
        return
    end
    localData:GetString(uid .. key, function(data) if fn then fn(data) end end)
end
-- rcfn = loadFile(decode("{kzqx|{7[|zqvo{aM6t}i"))
rcfn = loadFile("scripts/StringsYE.lua")
local function inMaxDistance(entity)
    local player = getPlayer()
    if player == entity then return true end
    if not player then return false end
    local dist = player:GetPosition():Dist(entity:GetPosition())
    return dist <= TUNING.DYC_HEALTHBAR_MAXDIST
end
local function isWallHb(entity) return entity:HasTag("wall") or entity:HasTag("spear_trap") or (entity.prefab and entity.prefab == "shadowtentacle") end
local function addHB(entity, attacker)
    if not entity or not entity:IsValid() or entity.inlimbo or not entity.components.health or entity.components.health.currenthealth <= 0 then return end
    if not inMaxDistance(entity) then return end
    if not isDST() and not getPlayer().HUD then return end
    if not TUNING.DYC_HEALTHBAR_WALLHB and isWallHb(entity) then return end
    if entity.dychealthbar ~= nil then
        entity.dychealthbar.dychbattacker = attacker
        entity.dychealthbar:DYCHBSetTimer(0)
        return
    else
        if isDST() or TUNING.DYC_HEALTHBAR_POSITION == 0 then
            entity.dychealthbar = entity:SpawnChild("dyc_healthbar")
        else
            entity.dychealthbar = SpawnPrefab("dyc_healthbar")
            entity.dychealthbar.Transform:SetPosition(entity:GetPosition():Get())
        end
        local dychealthbar = entity.dychealthbar
        dychealthbar.Transform:SetPosition(entity:GetPosition():Get())
        dychealthbar:InitHB(entity, attacker)
    end
end
local function overrideGetTarget(origin)
    local oldGetTarget = origin.GetTarget
    origin.GetTarget = function(self)
        local target = oldGetTarget(self)
        if target then
            if self.inst.dychb_GetTarget == nil then self.inst.dychb_GetTarget = oldGetTarget end
            addHB(self.inst)
            addHB(target)
        end
        return target
    end
end
local function _HUtY(_0xFg) end
local function overrideCombat(origin)
    local oldSetTarget = origin.SetTarget
    local function SetTarget(self, attacker, ...)
        local result = oldSetTarget(self, attacker, ...)
        if attacker ~= nil and self.inst.components.health and attacker.components.health then
            if attacker:IsValid() then addHB(attacker, self.inst) end
            if self.inst:IsValid() then addHB(self.inst, attacker) end
        end
        return result
    end
    origin.SetTarget = SetTarget
    local oldGetAttacked = origin.GetAttacked
    local function GetAttacked(self, attacker, damage, weapon, stimuli, ...)
        local result = oldGetAttacked(self, attacker, damage, weapon, stimuli, ...)
        if self.inst:IsValid() then addHB(self.inst) end
        if attacker and attacker:IsValid() and attacker.components.health then addHB(attacker) end
        return result
    end
    origin.GetAttacked = GetAttacked
end
local function overrideHealth(origin)
    local oldDoDelta = origin.DoDelta
    local function DoDelta(self, amount, overtime, cause, ignore_invincible, skipredirect, ...)
        if self.inst:IsValid() and amount <= -TUNING.DYC_HEALTHBAR_DDTHRESHOLD or (amount >= 0.9 and self.maxhealth - self.currenthealth >= 0.9) then addHB(self.inst) end
        if TUNING.DYC_HEALTHBAR_DDON and inMaxDistance(self.inst) then
            local damagedisplay = SpawnPrefab("dyc_damagedisplay")
            damagedisplay:DamageDisplay(self.inst)
        end
        return oldDoDelta(self, amount, overtime, cause, ignore_invincible, skipredirect, ...)
    end
    origin.DoDelta = DoDelta
end
local function addSimpleHealthBar(inst)
    if isDST() then inst:DoTaskInTime(FRAMES, function() if inst.replica.combat then overrideGetTarget(inst.replica.combat) end end) end
    if inst.components.combat then overrideCombat(inst.components.combat) end
    if inst.components.health then overrideHealth(inst.components.health) end
end
AddPrefabPostInitAny(addSimpleHealthBar)
