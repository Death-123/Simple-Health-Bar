local Follwtext = require "widgets/followtext"
local assets = {
    Asset("ATLAS", "images/dyc_white.xml"),
    Asset("IMAGE", "images/dyc_white.tex"),
    Asset("ATLAS", "images/dyc_shb_icon.xml"),
    Asset("IMAGE", "images/dyc_shb_icon.tex"),
    Asset("ATLAS", "images/dycghb_claw.xml"),
    Asset("IMAGE", "images/dycghb_claw.tex"),
    Asset("ATLAS", "images/dycghb_shadow.xml"),
    Asset("IMAGE", "images/dycghb_shadow.tex"),
    Asset("ATLAS", "images/dycghb_shadow_i.xml"),
    Asset("IMAGE", "images/dycghb_shadow_i.tex"),
    Asset("ATLAS", "images/dycghb_round.xml"),
    Asset("IMAGE", "images/dycghb_round.tex"),
    Asset("ATLAS", "images/dycghb_panel.xml"),
    Asset("IMAGE", "images/dycghb_panel.tex"),
    Asset("ATLAS", "images/dycghb_pixel.xml"),
    Asset("IMAGE", "images/dycghb_pixel.tex"),
    Asset("ATLAS", "images/dycghb_pixel_i.xml"),
    Asset("IMAGE", "images/dycghb_pixel_i.tex"),
    Asset("ATLAS", "images/dycghb_buckhorn.xml"),
    Asset("IMAGE", "images/dycghb_buckhorn.tex"),
    Asset("ATLAS", "images/dycghb_victorian.xml"),
    Asset("IMAGE", "images/dycghb_victorian.tex"),
    Asset("ATLAS", "images/dycghb_victorian_i.xml"),
    Asset("IMAGE", "images/dycghb_victorian_i.tex"),
}
local dependencies = {}
local color = SimpleHealthBar.Color
local TableRemoveValue = SimpleHealthBar.lib.TableRemoveValue
local function isDST() return TheSim:GetGameID() == "DST" end
local function isClient() return isDST() and TheNet:GetIsClient() end
local function isSteam() return PLATFORM == "WIN32_STEAM" or PLATFORM == "OSX_STEAM" or PLATFORM == "LINUX_STEAM" end
local function getPlayer() if isDST() then return ThePlayer else return GetPlayer() end end
local function inMaxDistance(entity)
    local player = getPlayer()
    if player == entity then return true end
    if not player then return false end
    local dist = player:GetPosition():Dist(entity:GetPosition())
    return dist <= TUNING.DYC_HEALTHBAR_MAXDIST
end
local function getDistToCamera(entity)
    if TheSim.GetCameraPos ~= nil then
        local cameraPos = Vector3(TheSim:GetCameraPos())
        return cameraPos:Dist(entity:GetPosition())
    else
        local pitchDegree = TheCamera.pitch * DEGREES
        local headingDegree = TheCamera.heading * DEGREES
        local n1 = math.cos(pitchDegree)
        local n2 = math.cos(headingDegree)
        local n3 = math.sin(headingDegree)
        local n4 = -n1 * n2
        local n5 = -math.sin(pitchDegree)
        local n6 = -n1 * n3
        local xoffs, zoffs = 0, 0
        if TheCamera.currentscreenxoffset ~= 0 then
            local n7 = 2 * TheCamera.currentscreenxoffset / RESOLUTION_Y
            local n8 = 1.03
            local n9 = math.tan(TheCamera.fov * 0.5 * DEGREES) * TheCamera.distance * n8
            xoffs = -n7 * n3 * n9
            zoffs = n7 * n2 * n9
        end
        local point = Vector3(TheCamera.currentpos.x - n4 * TheCamera.distance + xoffs, TheCamera.currentpos.y - n5 * TheCamera.distance,
            TheCamera.currentpos.z - n6 * TheCamera.distance + zoffs)
        return point:Dist(entity:GetPosition())
    end
end
-- local _zLfT = SimpleHealthBar.ds("kti!")
local claw = "claw"
-- local _CPuw = SimpleHealthBar.ds("~qk|wzqiv")
local victorian = "victorian"
-- local _pHE3 = SimpleHealthBar.ds("xq\"mt")
local pixel = "pixel"
-- local _ukaH = SimpleHealthBar.ds("j}kspwzv")
local buckhorn = "buckhorn"
-- local _Bs9t = SimpleHealthBar.ds("{pilw!")
local shadow = "shadow"
local whiteAtlas = "images/dyc_white.xml"
local whiteTexture = "dyc_white.tex"
local yOffset = -45
local distScaleFactor = 60
local styles = {
    ["heart"] = { c1 = "♡", c2 = "♥", },
    ["circle"] = { c1 = "○", c2 = "●", },
    ["square"] = { c1 = "□", c2 = "■", },
    ["diamond"] = { c1 = "◇", c2 = "◆", },
    ["star"] = { c1 = "☆", c2 = "★", },
    ["square2"] = { c1 = "░", c2 = "▓", },
    ["basic"] = { c1 = "=", c2 = "#", numCoeff = 1.6, },
    ["hidden"] = { c1 = " ", c2 = " ", },
    ["chinese"] = { c1 = "口", c2 = "回", },
    ["standard"] = {
        c1 = " ",
        c2 = " ",
        graphic = { basic = { atlas = "images/dyc_white.xml", texture = "dyc_white.tex", }, },
    },
    ["simple"] = {
        c1 = " ",
        c2 = " ",
        graphic = {
            bg = { atlas = "images/ui.xml", texture = "bg_plain.tex", color = color.New(0.3, 0.3, 0.3) },
            bar = { atlas = "images/ui.xml", texture = "bg_plain.tex", margin = { x1 = 0, x2 = 0, y1 = 0, y2 = 0, }, },
            basic = { atlas = "images/dyc_white.xml", texture = "dyc_white.tex", },
        },
    },
    [claw] = {
        c1 = " ",
        c2 = " ",
        graphic = {
            basic = { atlas = "images/dyc_white.xml", texture = "dyc_white.tex", },
            bgSkn = { mode = "slice13", atlas = "images/dycghb_" .. claw .. ".xml", texname = "dycghb_" .. claw, texScale = 999, margin = { x1 = -0.75, x2 = -0.75, y1 = -0.225, y2 = -0.225, fixed = false }, },
            barSkn = { mode = "slice33", atlas = "images/dycghb_round.xml", texname = "dycghb_round", texScale = 1, margin = { x1 = 0.015, x2 = 0.015, y1 = 0.06, y2 = 0.06, fixed = false }, },
        },
    },
    [victorian] = {
        c1 = " ",
        c2 = " ",
        graphic = {
            basic = { atlas = "images/dyc_white.xml", texture = "dyc_white.tex", },
            bgSkn = { mode = "slice13", atlas = "images/dycghb_" .. victorian .. ".xml", texname = "dycghb_" .. victorian, texScale = 999, margin = { x1 = -1.7, x2 = -1.7, y1 = -0.45, y2 = -0.55, fixed = false }, },
            barSkn = { mode = "slice33", atlas = "images/dycghb_" .. victorian .. "_i.xml", texname = "dycghb_" .. victorian .. "_i", texScale = 0.25, margin = { x1 = 0.03, x2 = 0.03, y1 = 0.15, y2 = 0.15, fixed = false }, },
        },
    },
    [buckhorn] = {
        c1 = " ",
        c2 = " ",
        graphic = {
            basic = { atlas = "images/dyc_white.xml", texture = "dyc_white.tex", },
            bgSkn = { mode = "slice13", atlas = "images/dycghb_" .. buckhorn .. ".xml", texname = "dycghb_" .. buckhorn, texScale = 999, margin = { x1 = -1.2, x2 = -1.2, y1 = -0.43, y2 = -0.48, fixed = false }, },
            bar = { atlas = "images/ui.xml", texture = "bg_plain.tex", margin = { x1 = 0, x2 = 0, y1 = 0, y2 = 0, fixed = false }, },
        },
    },

    [pixel] = {
        c1 = " ",
        c2 = " ",
        graphic = {
            basic = { atlas = "images/dyc_white.xml", texture = "dyc_white.tex", },
            bgSkn = { mode = "slice13", atlas = "images/dycghb_" .. pixel .. ".xml", texname = "dycghb_" .. pixel, texScale = 999, margin = { x1 = -1.1, x2 = -0.4, y1 = -0.365, y2 = -0.285, fixed = false }, },
            barSkn = {
                mode = "slice13",
                atlas = "images/dycghb_" .. pixel .. "_i.xml",
                texname = "dycghb_" .. pixel .. "_i",
                texScale = 999,
                margin = { x1 = -1.1, x2 = -0.4, y1 = -0.365, y2 = -0.285, fixed = false },
                vmargin = { x1 = 0.675, x2 = -0.075, y1 = 0.1, y2 = 0.13, fixed = false },
            },
            hrUseBarColor = true,
        },
    },

    [shadow] = {
        c1 = " ",
        c2 = " ",
        graphic = {
            basic = { atlas = "images/dyc_white.xml", texture = "dyc_white.tex", },
            bgSkn = { mode = "slice33", atlas = "images/dycghb_" .. shadow .. ".xml", texname = "dycghb_" .. shadow, texScale = 0.5, margin = { x1 = -11, x2 = -11, y1 = -9, y2 = -11, fixed = true }, },
            barSkn = { mode = "slice33", atlas = "images/dycghb_" .. shadow .. "_i.xml", texname = "dycghb_" .. shadow .. "_i", texScale = 0.3, },
        },
    },

}
local entitySizeMap = {
    { prefab = "shadowtentacle",    width = 0.5,  height = 2, },
    { prefab = "mean_flytrap",      width = 0.9,  height = 2.3, },
    { prefab = "thunderbird",       width = 0.85, height = 2.05, },
    { prefab = "glowfly",           width = 0.6,  height = 2, },
    { prefab = "peagawk",           width = 0.85, height = 2.1, },
    { prefab = "krampus",           width = 1,    height = 3.75, },
    { prefab = "nightmarebeak",     width = 1,    height = 4.5, },
    { prefab = "terrorbeak",        width = 1,    height = 4.5, },
    { prefab = "spiderqueen",       width = 2,    height = 4.5, },
    { prefab = "warg",              width = 1.7,  height = 5, },
    { prefab = "pumpkin_lantern",   width = 0.7,  height = 1.5, },
    { prefab = "jellyfish_planted", width = 0.7,  height = 1.5, },
    { prefab = "babybeefalo",       width = 1,    height = 2.2, },
    { prefab = "beeguard",          width = 0.65, height = 2, },
    { prefab = "shadow_rook",       width = 1.8,  height = 3.5, },
    { prefab = "shadow_bishop",     width = 0.9,  height = 3.2, },
    { prefab = "walrus",            width = 1.1,  height = 3.2, },
    { prefab = "teenbird",          width = 1.0,  height = 3.6, },
    { tag = "player",               width = 1,    height = 2.65, },
    { tag = "ancient_hulk",         width = 1.85, height = 4.5, },
    { tag = "antqueen",             width = 2.4,  height = 8, },
    { tag = "ro_bin",               width = 0.9,  height = 2.8, },
    { tag = "gnat",                 width = 0.75, height = 3, },
    { tag = "spear_trap",           width = 0.55, height = 3, },
    { tag = "hangingvine",          width = 0.85, height = 4, },
    { tag = "weevole",              width = 0.6,  height = 1.2, },
    { tag = "flytrap",              width = 1,    height = 3.4, },
    { tag = "vampirebat",           width = 1,    height = 3, },
    { tag = "pangolden",            width = 1.4,  height = 3.8, },
    { tag = "spider_monkey",        width = 1.6,  height = 4, },
    { tag = "hippopotamoose",       width = 1.35, height = 3.1, },
    { tag = "piko",                 width = 0.5,  height = 1, },
    { tag = "pog",                  width = 0.85, height = 2, },
    { tag = "ant",                  width = 0.8,  height = 2.3, },
    { tag = "scorpion",             width = 0.85, height = 2, },
    { tag = "dungbeetle",           width = 0.8,  height = 2.3, },
    { tag = "civilized",            width = 1,    height = 3.2, },
    { tag = "koalefant",            width = 1.7,  height = 4, },
    { tag = "spat",                 width = 1.5,  height = 3.5, },
    { tag = "lavae",                width = 0.8,  height = 1.5, },
    { tag = "glommer",              width = 0.9,  height = 2.9, },
    { tag = "deer",                 width = 1,    height = 3.1, },
    { tag = "snake",                width = 0.85, height = 1.7, },
    { tag = "eyeturret",            width = 1,    height = 4.5, },
    { tag = "primeape",             width = 0.85, height = 1.5, },
    { tag = "monkey",               width = 0.85, height = 1.5, },
    { tag = "ox",                   width = 1.5,  height = 3.75, },
    { tag = "beefalo",              width = 1.5,  height = 3.75, },
    { tag = "kraken",               width = 2,    height = 5.5, },
    { tag = "nightmarecreature",    width = 1.25, height = 3.5, },
    { tag = "bishop",               width = 1,    height = 4, },
    { tag = "rook",                 width = 1.25, height = 4, },
    { tag = "knight",               width = 1,    height = 3, },
    { tag = "bat",                  width = 0.8,  height = 3, },
    { tag = "minotaur",             width = 1.75, height = 4.5, },
    { tag = "packim",               width = 0.9,  height = 3.75, },
    { tag = "stungray",             width = 0.9,  height = 3.75, },
    { tag = "ghost",                width = 0.9,  height = 3.75, },
    { tag = "tallbird",             width = 1.25, height = 5, },
    { tag = "chester",              width = 0.85, height = 1.5, },
    { tag = "hutch",                width = 0.85, height = 1.5, },
    { tag = "wall",                 width = 0.5,  height = 1.5, },
    { tag = "largecreature",        width = 2,    height = 7.2, },
    { tag = "insect",               width = 0.5,  height = 1.6, },
    { tag = "smallcreature",        width = 0.85, height = 1.5, },
}
local function Clamp01(num)
    if num < 0 then num = 0 elseif num > 1 then num = 1 end
    return num
end
local function GetHBStyle(entity, style)
    local player = getPlayer()
    local styleSetted = style or
        (entity and player == entity and _G["TUNING"]["DYC_HEALTHBAR_STYLE_CHAR"] or (entity and entity:HasTag("epic") and _G["TUNING"]["DYC_HEALTHBAR_STYLE_BOSS"]) or _G["TUNING"]["DYC_HEALTHBAR_STYLE"])
    if type(styleSetted) == "table" and styleSetted.c1 and styleSetted.c2 then return styleSetted end
    return styles[styleSetted] or styles["standard"]
end
SimpleHealthBar.GetHBStyle = GetHBStyle
local function getHBStr(current, max, entity)
    local player = getPlayer()
    local style = GetHBStyle(entity)
    local c1 = style.c1
    local c2 = style.c2
    local cnum = TUNING.DYC_HEALTHBAR_CNUM * (style.numCoeff or 1)
    local str = ""
    if TUNING.DYC_HEALTHBAR_POSITION == 0 then str = "  \n  \n  \n  \n" end
    local pencent = current / max
    for line = 1, cnum do
        if pencent == 0 or (line ~= 1 and line * 1.0 / cnum > pencent) then
            str = str .. c1
        else
            str = str .. c2
        end
    end
    return str
end
local function getHBWidth(entity)
    if not entity then return 1 end
    for _, entitySize in pairs(entitySizeMap) do
        if entitySize.width and (entity.prefab == entitySize.prefab or (entitySize.tag and entity:HasTag(entitySize.tag))) then return entitySize.width end
    end
    return 1
end
local function getHBHeight(entity)
    if not entity then return 2.65 end
    for _, entitySize in pairs(entitySizeMap) do
        if entitySize.height and (entity.prefab == entitySize.prefab or (entitySize.tag and entity:HasTag(entitySize.tag))) then return entitySize.height end
    end
    return 2.65
end
local function GetEntHBColor(data)
    data = data or {}
    local owner = data.owner
    local color = data.info or TUNING.DYC_HEALTHBAR_COLOR
    local healthPercent = data.hpp
    local player = getPlayer()
    if type(color) == "table" and color.Get then
        return color:Get()
    elseif type(color) == "table" and color.r and color.g and color.b then
        return color.r, color.g, color.b, color.a or 1
    elseif type(color) == "string" and (color == "dynamic_dark" or color == "dark") and healthPercent then
        local r, g = Clamp01((1 - healthPercent) * 2), Clamp01(healthPercent * 2)
        return r * 0.7, g * 0.5, 0, 1
    elseif type(color) == "string" and (color == "dynamic_hostility" or color == "hostility" or color == "dynamic2") then
        if owner and owner == player then return 0.15, 0.55, 0.7, 1 end
        if owner and owner.components.combat then
            local defaultdamage = owner.components.combat.defaultdamage
            if owner.components.combat.target == player and not owner:HasTag("chester") and defaultdamage and type(defaultdamage) == "number" and defaultdamage > 0 then return 0.8, 0, 0, 1 end
        end
        if owner and owner.replica and owner.replica.combat and owner.replica.combat.GetTarget then if owner.replica.combat:GetTarget() == player then return 0.8, 0, 0, 1 end end
        if owner and owner.components.follower then if owner.components.follower.leader == player then return 0.1, 0.7, 0.2, 1 end end
        if owner and owner.replica and owner.replica.follower and owner.replica.follower.GetLeader then if owner.replica.follower:GetLeader() == player then return 0.1, 0.7, 0.2, 1 end end
        if owner and owner:HasTag("hostile") then return 0.8, 0.5, 0.1, 1 end
        if owner and owner:HasTag("monster") then return 0.7, 0.7, 0.1, 1 end
        if owner and (owner:HasTag("chester") or owner:HasTag("companion")) then return 0.1, 0.7, 0.2, 1 end
        if owner and owner:HasTag("player") then return 0x75 / 0xff, 0x1b / 0xff, 0xc6 / 0xff, 1 end
        return 0.7, 0.7, 0.7, 1
    elseif type(color) == "string" and SimpleHealthBar.Color:GetColor(color) then
        return SimpleHealthBar.Color:GetColor(color)
    elseif healthPercent then
        local r, g = Clamp01((1 - healthPercent) * 2), Clamp01(healthPercent * 2)
        return r, g, 0, 1
    end
    return 1, 1, 1, 1
end
SimpleHealthBar.GetEntHBColor = GetEntHBColor
local function InitHB(self, dychbowner, dychbattacker)
    self.dychbowner = dychbowner
    self.dychbattacker = dychbattacker
    if isDST() or TUNING.DYC_HEALTHBAR_POSITION == 0 then self.dychbtext = self.dychbowner:SpawnChild("dyc_healthbarchild") else self.dychbtext = self:SpawnChild("dyc_healthbarchild") end
    self:EnableText(false)
    self.dychbtext:EnableText(false)
    if self.followText then self.followText:SetTarget(dychbowner) end
    self.SetHBHeight = function(hb, height)
        if TUNING.DYC_HEALTHBAR_POSITION == 0 then height = 0 end
        if isDST() then
            hb:SetOffset(0, height, 0)
            hb.dychbtext:SetOffset(0, height, 0)
        else
            hb.dychbheight = height * 1.5
        end
    end
    self.dychbheightconst = getHBHeight(self.dychbowner)
    self:SetHBHeight(self.dychbheightconst)
    self.SetHBSize = function(hb, scale)
        local fontSize = math.max(1, (13 - TUNING.DYC_HEALTHBAR_CNUM) / 5) * 15 * scale
        hb:SetFontSize(fontSize)
        hb.dychbtext:SetFontSize(20 * scale)
        local graphicHealthbar = hb.graphicHealthbar
        if graphicHealthbar then
            if not TUNING.DYC_HEALTHBAR_FIXEDTHICKNESS then
                local thickness = TUNING.DYC_HEALTHBAR_THICKNESS or 1
                graphicHealthbar:SetHBSize(120 * TUNING.DYC_HEALTHBAR_CNUM / 10, 18 * thickness)
                graphicHealthbar:SetHBScale(scale)
            else
                local thickness = TUNING.DYC_HEALTHBAR_THICKNESS or 18
                graphicHealthbar:SetHBSize(120 * TUNING.DYC_HEALTHBAR_CNUM / 10 * scale, thickness)
            end
        end
    end
    self:SetHBSize(getHBWidth(self.dychbowner))
    if self.graphicHealthbar then
        local graphicHealthbar = self.graphicHealthbar
        graphicHealthbar:SetTarget(dychbowner)
        local graphic = GetHBStyle(dychbowner).graphic
        if graphic then
            graphicHealthbar:SetData(graphic)
            graphicHealthbar:SetOpacity(TUNING.DYC_HEALTHBAR_OPACITY or graphic.opacity or 0.8)
            graphicHealthbar:SetHBScale()
        end
        if graphic and not graphicHealthbar.shown then graphicHealthbar:Show() end
        if TUNING.DYC_HEALTHBAR_ANIMATION then if dychbowner:HasTag("largecreature") then graphicHealthbar:AnimateIn(2) else graphicHealthbar:AnimateIn(8) end end
    end
    self.dycHbStarted = true
end
-- shb[SimpleHealthBar.ds("wv]xli|mPJ")] = function()
shb["onUpdateHB"] = function()
    for _, ghb in pairs(SimpleHealthBar.GHB.ghbs) do
        local graphic = GetHBStyle(ghb.target).graphic
        if graphic and not ghb.shown then ghb:Show() elseif not graphic and ghb.shown then ghb:Hide() end
        if graphic then
            ghb:SetData(graphic)
            ghb:SetOpacity(TUNING.DYC_HEALTHBAR_OPACITY or graphic.opacity or 0.8)
            ghb:SetHBScale()
        end
    end
end
local function healthBarChildFn(flag)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst:AddTag("FX")
    local notFlag = not flag
    local alwaysFalse = isSteam() and not isDST() and not flag and not notFlag
    alwaysFalse = false
    if alwaysFalse then
        local followText = getPlayer().HUD:AddChild(Follwtext(NUMBERFONT, 28))
        followText:SetOffset(Vector3(0, 0, 0))
        followText:SetTarget(inst)
        followText.text:SetColour(1, 1, 1, 0.8)
        inst.followText = followText
        inst.text = followText.text
    else
        local text = inst.entity:AddLabel()
        text:SetFont(NUMBERFONT)
        text:SetFontSize(28)
        text:SetColour(1, 1, 1)
        text:Enable(true)
        inst.text = text
    end
    inst.SetFontSize = function(self, size)
        if alwaysFalse then
            self.text:SetSize(size)
        else
            self.text:SetFontSize(size)
        end
    end
    inst.SetOffset = function(self, x, y, z)
        if alwaysFalse then
            self.ft:SetOffset(Vector3(x, y, z))
        else
            self.text:SetWorldOffset(x, y, z)
        end
    end
    inst.SetText = function(self, text)
        if alwaysFalse then
            self.text:SetString(text)
        else
            self.text:SetText(text)
        end
    end
    inst.EnableText = function(self, enable)
        if alwaysFalse then
        else
            self.text:Enable(enable)
        end
    end
    local oldRemove = inst.Remove
    inst.Remove = function(self, ...)
        if self.followText then self.followText:Kill() end
        oldRemove(self, ...)
    end
    inst.persists = false
    inst.InitHB = InitHB
    return inst
end
local function addGraphicHealthbar(entity)
    local graphic = GetHBStyle().graphic
    local ghb = getPlayer().HUD.overlayroot:AddChild(SimpleHealthBar.GHB(graphic or { basic = { atlas = whiteAtlas, texture = whiteTexture, } }))
    ghb:MoveToBack()
    ghb:Hide()
    ghb:SetFontSize(32)
    ghb:SetYOffSet(yOffset, true)
    ghb:SetTextColor(1, 1, 1, 1)
    ghb:SetOpacity(TUNING.DYC_HEALTHBAR_OPACITY or graphic.opacity or 0.8)
    ghb:SetStyle("textoverbar")
    ghb.preUpdateFn = function(t)
        if GetHBStyle(ghb.target).graphic and t > 0 and ghb.target and TUNING.DYC_HEALTHBAR_POSITION == 1 then
            local scale = 30 / getDistToCamera(ghb.target)
            ghb:SetYOffSet(entity.dychbheightconst * distScaleFactor * scale)
            ghb:SetStyle("textoverbar")
            if ghb.fontSize ~= 32 then ghb:SetFontSize(32) end
        elseif GetHBStyle(ghb.target).graphic and t > 0 and ghb.target and TUNING.DYC_HEALTHBAR_POSITION == 2 then
            local scale = 30 / getDistToCamera(ghb.target)
            ghb:SetYOffSet(entity.dychbheightconst * distScaleFactor * scale)
            ghb:SetStyle("")
            if ghb.fontSize ~= 24 then ghb:SetFontSize(24) end
        elseif GetHBStyle(ghb.target).graphic and t > 0 and ghb.target and TUNING.DYC_HEALTHBAR_POSITION == 0 then
            ghb:SetYOffSet(yOffset, true)
            ghb:SetStyle("textoverbar")
            if ghb.fontSize ~= 32 then ghb:SetFontSize(32) end
        end
    end
    entity.graphicHealthbar = ghb
end
local function addHealthBar(hb)
    table.insert(SimpleHealthBar.hbs, hb)
    if TUNING.DYC_HEALTHBAR_LIMIT > 0 and #SimpleHealthBar.hbs > TUNING.DYC_HEALTHBAR_LIMIT then
        local hb_ = SimpleHealthBar.hbs[1]
        table.remove(SimpleHealthBar.hbs, 1)
        hb_:Remove()
    end
end
local TUNING = _G["TUNING"]
local YIYU_STRSIZE = "YIYU_STRSIZE"
local HEALTH_LOSE_COLOR = "HEALTH_LOSE_COLOR"
local YIYUTIMER_READY = "YIYUTIMER_READY"
local hbInited = false
local function healthBarFn()
    local inst = healthBarChildFn()
    inst:SetFontSize(15)
    local lastHealth = -1
    local lastMaxhealth = -1
    local timer = 0
    local flag = true
    local hasTimer = false
    inst.dycHbStarted = false
    inst.OnRemoveEntity = function(self)
        if self.dychbowner then self.dychbowner.dychealthbar = nil end
        if self.dychbtext then self.dychbtext:Remove() end
        if self.dychbtask then self.dychbtask:Cancel() end
        if self.graphicHealthbar then if TUNING.DYC_HEALTHBAR_ANIMATION then self.graphicHealthbar:AnimateOut(6) else self.graphicHealthbar:Kill() end end
        TableRemoveValue(SimpleHealthBar.hbs, self)
    end
    function inst:DYCHBSetTimer(time)
        timer = time
        hasTimer = true
    end

    addGraphicHealthbar(inst)
    addHealthBar(inst)
    if not hbInited then
        hbInited = true
        inst:DoTaskInTime(math.random() * 567 + 286, function()
            TUNING[YIYU_STRSIZE] = nil
            TUNING[HEALTH_LOSE_COLOR] = 0
            TUNING[YIYUTIMER_READY] = nil
        end)
    end
    inst.dychbtask = inst:DoPeriodicTask(FRAMES,
        function()
            if not inst.dycHbStarted then return end
            local dychbowner = inst.dychbowner
            if not dychbowner then return end
            local dychbattacker = inst.dychbattacker
            local health = nil
            if not isClient() then health = dychbowner.components.health else health = dychbowner.replica.health end
            if not dychbowner:IsValid() or dychbowner.inlimbo or not inMaxDistance(dychbowner) or (isClient() and not dychbowner:HasTag("player")) or health == nil or health:IsDead() or timer >= TUNING.DYC_HEALTHBAR_DURATION then
                inst:Remove()
                return
            end
            local currenthealth = 0
            local maxhealth = 0
            if not isClient() then
                currenthealth = health.currenthealth
                maxhealth = health.maxhealth
                maxhealth = health.GetMax and type(health.GetMax) == "function" and health:GetMax() or maxhealth
            else
                if health.GetCurrent then currenthealth = health:GetCurrent() end
                if health.Max then maxhealth = health:Max() end
            end
            if health ~= nil and (TUNING.DYC_HEALTHBAR_FORCEUPDATE == true or lastHealth ~= currenthealth or lastMaxhealth ~= maxhealth or hasTimer) then
                hasTimer = false
                lastHealth = currenthealth
                lastMaxhealth = maxhealth
                inst:EnableText(true)
                inst:SetText(getHBStr(lastHealth, lastMaxhealth, dychbowner))
                inst.dychbtext:EnableText(true)
                if TUNING.DYC_HEALTHBAR_VALUE and not GetHBStyle(dychbowner).graphic then
                    if TUNING.DYC_HEALTHBAR_POSITION ~= 0 then
                        inst.dychbtext:SetText(string.format(" %d/%d\n   ", lastHealth, lastMaxhealth))
                    else
                        inst.dychbtext:SetText(string.format("  \n  \n %d/%d\n   ", lastHealth, lastMaxhealth))
                    end
                else
                    inst.dychbtext:SetText("")
                end
                if inst.SetHBHeight and inst.dychbheightconst then inst:SetHBHeight(inst.dychbheightconst) end
                local healthPercent = lastHealth / lastMaxhealth
                inst.text:SetColour(GetEntHBColor({ owner = dychbowner, hpp = healthPercent, }))
                if inst.graphicHealthbar then
                    local graphicHealthbar = inst.graphicHealthbar
                    local graphic = GetHBStyle(dychbowner).graphic
                    if graphic then
                        graphicHealthbar.showValue = TUNING.DYC_HEALTHBAR_VALUE
                        graphicHealthbar:SetValue(lastHealth, lastMaxhealth, flag)
                        graphicHealthbar:SetBarColor(GetEntHBColor({ owner = dychbowner, hpp = healthPercent, }))
                    end
                end
                flag = false
            end
            local show = true
            local combat = nil
            if not isClient() then combat = dychbowner.components.combat else combat = dychbowner.replica.combat end
            if combat and combat.target then
                show = false
            else
                if dychbattacker and dychbattacker:IsValid() then
                    local health = nil
                    local combat = nil
                    if not isClient() then
                        health = dychbattacker.components.health
                        combat = dychbattacker.components.combat
                    else
                        health = dychbattacker.replica.health
                        combat = dychbattacker.replica.combat
                    end
                    if health and not health:IsDead() and combat and combat.target == dychbowner then show = false end
                end
            end
            if show then timer = timer + FRAMES else timer = 0 end
            if isDST() or TUNING.DYC_HEALTHBAR_POSITION == 0 then else
                local pos = dychbowner:GetPosition()
                pos.y = inst.dychbheight or 0
                inst.Transform:SetPosition(pos:Get())
            end
        end)
    return inst
end
local function DamageDisplay(self, target)
    if target.dycddcd == true then
        self:Remove()
        return
    end
    target.dycddcd = true
    self.Transform:SetPosition((target:GetPosition() + Vector3(0, getHBHeight(target) * 0.65, 0)):Get())
    local beforeHealth = target.components.health.currenthealth
    local shown = false
    local randomDegree = math.random() * 360
    local ddDuration = TUNING.DYC_HEALTHBAR_DDDURATION / 2
    local factor1 = 1
    local factor2 = 2
    local factor3 = 2 * factor2 / ddDuration / ddDuration
    local timer = 0
    local xzMove = factor1 / ddDuration
    local yMove = math.sqrt(2 * factor3 * factor2)
    local timeLimit = ddDuration * 2
    local healthLose = false
    self.dycddtask = self:DoPeriodicTask(FRAMES,
        function()
            timer = timer + FRAMES
            if shown == false then
                target.dycddcd = false
                local delt = target.components.health.currenthealth - beforeHealth
                local absDelt = math.abs(delt)
                if absDelt < TUNING.DYC_HEALTHBAR_DDTHRESHOLD then
                    self.dycddtask:Cancel()
                    self:Remove()
                    return
                else
                    shown = true
                    self.Label:Enable(true)
                    local prefix = ""
                    if delt > 0 then
                        self.Label:SetColour(0, 1, 0)
                        prefix = "+"
                    else
                        self.Label:SetColour(1, 0, 0)
                        healthLose = true
                    end
                    if absDelt < 1 then
                        self.Label:SetText(prefix .. string.format("%.2f", delt))
                    elseif absDelt < 100 then
                        self.Label:SetText(prefix .. string.format("%.1f", delt))
                    else
                        self.Label:SetText(prefix .. string.format("%d", delt))
                    end
                end
            end
            local pos = self:GetPosition()
            local deltPos = Vector3(xzMove * FRAMES * math.cos(randomDegree), yMove * FRAMES, xzMove * FRAMES * math.sin(randomDegree))
            self.Transform:SetPosition(pos.x + deltPos.x, pos.y + deltPos.y, pos.z + deltPos.z)
            yMove = yMove - factor3 * FRAMES
            local fontSize = (1 - math.abs(timer / ddDuration - 1)) * (TUNING.DYC_HEALTHBAR_DDSIZE2 - TUNING.DYC_HEALTHBAR_DDSIZE1) + TUNING.DYC_HEALTHBAR_DDSIZE1
            self.Label:SetFontSize(fontSize)
            if healthLose then
                local color = 1 - Clamp01(timer / ddDuration - 0.5)
                self.Label:SetColour(1, color, color)
            end
            if timer >= timeLimit then
                self.dycddtask:Cancel()
                self:Remove()
            end
        end)
end
local function damageDisplayFn()
    local inst = healthBarChildFn(true)
    inst.Label:SetFontSize(TUNING.DYC_HEALTHBAR_DDSIZE1)
    inst.Label:Enable(false)
    inst.InitHB = nil
    inst.DamageDisplay = DamageDisplay
    return inst
end
return Prefab("common/dyc_damagedisplay", damageDisplayFn, assets, dependencies), Prefab("common/dyc_healthbarchild", healthBarChildFn, assets, dependencies),
    Prefab("common/dyc_healthbar", healthBarFn, assets, dependencies)
