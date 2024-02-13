local Widget = require "widgets/widget"
local Image = require "widgets/image"
local Text = require "widgets/text"
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
local Clamp01 = function(num) return math.min(math.max(num, 0), 1) end
local Lerp = function(a, b, t) return (b - a) * t + a end
local TableContains = function(table, value)
    for _, v in pairs(table) do if v == value then return true end end
    return false
end
local TableAdd = function(tableTo, value) if not TableContains(tableTo, value) then table.insert(tableTo, value) end end
local TableGetIndex = function(table, value) for k, v in pairs(table) do if v == value then return k end end end
local TableRemoveValue = function(tableTo, value)
    local index = TableGetIndex(tableTo, value)
    if index then table.remove(tableTo, index) end
end
--#region dycSlicedImage
local dycSlicedImage = Class(Widget,
    function(self, textures)
        Widget._ctor(self, "DYC_SlicedImage")
        self.images = {}
        self.mode = "slice13"
        self.texScale = textures.texScale or 1
        self.width = 100
        self.height = 100
        self:SetTextures(textures)
    end)
function dycSlicedImage:__tostring() return string.format("%s (%s)", self.name, self.mode) end

function dycSlicedImage:SetTextures(textures)
    assert(textures.mode)
    self.images = {}
    self.mode = textures.mode
    if self.mode == "slice13" or self.mode == "slice31" then
        local newImage = nil
        newImage = self:AddChild(Image(textures.atlas, textures.texname .. "_1.tex"))
        newImage.oriW, newImage.oriH = newImage:GetSize()
        newImage.imgPos = 1
        self.images[1] = newImage
        newImage = self:AddChild(Image(textures.atlas, textures.texname .. "_2.tex"))
        newImage.oriW, newImage.oriH = newImage:GetSize()
        newImage.imgPos = 2
        self.images[2] = newImage
        newImage = self:AddChild(Image(textures.atlas, textures.texname .. "_3.tex"))
        newImage.oriW, newImage.oriH = newImage:GetSize()
        newImage.imgPos = 3
        self.images[3] = newImage
        if self.mode == "slice13" then
            assert(self.images[1].oriH == self.images[3].oriH, "Height must be equal!")
            assert(self.images[1].oriH == self.images[2].oriH, "Height must be equal!")
        else
            assert(self.images[1].oriW == self.images[3].oriW, "Width must be equal!")
            assert(self.images[1].oriW == self.images[2].oriW, "Width must be equal!")
        end
        return
    elseif self.mode == "slice33" then
        local newImage = nil
        for i = 1, 3 do
            for j = 1, 3 do
                newImage = self:AddChild(Image(textures.atlas, textures.texname .. "_" .. i .. j .. ".tex"))
                newImage.oriW, newImage.oriH = newImage:GetSize()
                newImage.imgPos = i * 10 + j
                self.images[i * 10 + j] = newImage
                if i > 1 then assert(self.images[i * 10 + j].oriW == self.images[(i - 1) * 10 + j].oriW, "Width must be equal!") end
                if j > 1 then assert(self.images[i * 10 + j].oriH == self.images[i * 10 + j - 1].oriH, "Height must be equal!") end
            end
        end
        return
    end
    error("Mode not supported!")
    self:SetSize()
end

function dycSlicedImage:SetSize(width, height)
    width = width or self.width
    height = height or self.height
    if self.mode == "slice13" then
        local image1 = self.images[1]
        local image2 = self.images[2]
        local image3 = self.images[3]
        local texScale = math.min(self.texScale, math.min(width / (image1.oriW + image3.oriW), height / image1.oriH))
        local w1 = math.floor(image1.oriW * texScale)
        local w2 = math.floor(image3.oriW * texScale)
        local w3 = math.max(0, width - w1 - w2)
        image1:SetSize(w1, height)
        image2:SetSize(w3, height)
        image3:SetSize(w2, height)
        local x2 = (w1 - w2) / 2
        local x1 = -w1 / 2 - w3 / 2 + x2
        local x3 = w2 / 2 + w3 / 2 + x2
        image1:SetPosition(x1, 0, 0)
        image2:SetPosition(x2, 0, 0)
        image3:SetPosition(x3, 0, 0)
        self.width = w1 + w3 + w2
        self.height = height
    elseif self.mode == "slice31" then
        local image1 = self.images[1]
        local image2 = self.images[2]
        local image3 = self.images[3]
        local texScale = math.min(self.texScale, math.min(height / (image1.oriH + image3.oriH), width / image1.oriW))
        local h1 = math.floor(image1.oriH * texScale)
        local h3 = math.floor(image3.oriH * texScale)
        local h2 = math.max(0, height - h1 - h3)
        image1:SetSize(width, h1)
        image2:SetSize(width, h2)
        image3:SetSize(width, h3)
        local y2 = (h1 - h3) / 2
        local y1 = -h1 / 2 - h2 / 2 + y2
        local y3 = h3 / 2 + h2 / 2 + y2
        image1:SetPosition(0, y1, 0)
        image2:SetPosition(0, y2, 0)
        image3:SetPosition(0, y3, 0)
        self.height = h1 + h2 + h3
        self.width = width
    elseif self.mode == "slice33" then
        local images = self.images
        local texScale = math.min(self.texScale, math.min(width / (images[11].oriW + images[13].oriW), height / (images[11].oriH + images[31].oriH)))
        local ws, hs, xs, ys = {}, {}, {}, {}
        ws[1] = math.floor(images[11].oriW * texScale)
        ws[3] = math.floor(images[13].oriW * texScale)
        ws[2] = math.max(0, width - ws[1] - ws[3])
        hs[1] = math.floor(images[11].oriH * texScale)
        hs[3] = math.floor(images[31].oriH * texScale)
        hs[2] = math.max(0, height - hs[1] - hs[3])
        xs[2] = (ws[1] - ws[3]) / 2
        xs[1] = -ws[1] / 2 - ws[2] / 2 + xs[2]
        xs[3] = ws[3] / 2 + ws[2] / 2 + xs[2]
        ys[2] = (hs[1] - hs[3]) / 2
        ys[1] = -hs[1] / 2 - hs[2] / 2 + ys[2]
        ys[3] = hs[3] / 2 + hs[2] / 2 + ys[2]
        for i = 1, 3 do
            for j = 1, 3 do
                images[i * 10 + j]:SetSize(ws[j], hs[i])
                images[i * 10 + j]:SetPosition(xs[j], ys[i], 0)
            end
        end
        self.width = ws[1] + ws[2] + ws[3]
        self.height = hs[1] + hs[2] + hs[3]
    end
end

function dycSlicedImage:GetSize() return self.width, self.height end

function dycSlicedImage:SetTint(r, g, b, a) for _, image in pairs(self.images) do image:SetTint(r, g, b, a) end end

function dycSlicedImage:SetClickable(clickable) for _, image in pairs(self.images) do image:SetClickable(clickable) end end

--#endregion

--#region dycTextHealthbar
local dycTextHealthbar = Class(Widget,
    function(self, data)
        Widget._ctor(self, "DYC_TextHealthbar")
        self.text = self:AddChild(Text(NUMBERFONT, 18, ""))
        self.c1 = data.c1 or "="
        self.c2 = data.c2 or "#"
        self.cnum = data.cnum or 10
        self.numCoeff = data.numCoeff or 1
        self.percentage = 1
        self.fontSize = data.fontSize or 18
        self.hbScale = data.hbScale or 1
        self:SetPercentage()
        self:SetHBScale()
        if data.color then self:SetTextColor(data.color) end
    end)
function dycTextHealthbar:SetStrings(c1, c2, cnum)
    c1 = c1 or self.c1;
    c2 = c2 or self.c2;
    cnum = cnum or self.cnum;
    cnum = math.max(1, cnum)
    self.c1 = c1;
    self.c2 = c2;
    self.cnum = cnum;
    self:SetPercentage()
end

function dycTextHealthbar:SetLength(length)
    length = length or self.cnum
    self.cnum = length
    self:SetPercentage()
end

function dycTextHealthbar:SetPercentage(percentage)
    percentage = percentage or self.percentage
    percentage = math.max(0, math.min(percentage, 1))
    self.percentage = percentage
    local c1 = self.c1
    local c2 = self.c2
    local length = self.cnum * self.numCoeff
    local str = ""
    for i = 1, length do
        if percentage == 0 or (i ~= 1 and i * 1.0 / length > percentage) then
            str = str .. c1
        else
            str = str .. c2
        end
    end
    self.text:SetString(str)
end

function dycTextHealthbar:SetFontSize(fontSize)
    fontSize = fontSize or self.fontSize
    self.fontSize = fontSize
    self.text:SetSize(self.fontSize * self.hbScale)
end

function dycTextHealthbar:SetHBScale(hbScale)
    hbScale = hbScale or self.hbScale
    self.hbScale = hbScale
    self:SetFontSize()
end

function dycTextHealthbar:SetColor(colorOrR, g, b, a)
    colorOrR = colorOrR or 1
    g = g or 1
    b = b or 1
    a = a or 1
    if type(colorOrR) == "table" then
        colorOrR.r = colorOrR.r or colorOrR.x or colorOrR[1] or 1
        colorOrR.g = colorOrR.g or colorOrR.y or colorOrR[2] or 1
        colorOrR.b = colorOrR.b or colorOrR.z or colorOrR[3] or 1
        colorOrR.a = colorOrR.a or colorOrR[1] or 1
        self.text:SetColour(colorOrR.r, colorOrR.g, colorOrR.b, colorOrR.a)
    else
        self.text:SetColour(colorOrR, g, b, a)
    end
end
--#endregion

--#region dycGraphicHealthbar
local dycGraphicHealthbar = Class(Widget,
    function(self, data)
        Widget._ctor(self, "DYC_GraphicHealthbar")
        self:SetScaleMode(data.isDemo and SCALEMODE_NONE or SCALEMODE_PROPORTIONAL)
        self:SetMaxPropUpscale(999)
        self.worldOffset = Vector3(0, 0, 0)
        self.screen_offset = Vector3(0, 0, 0)
        self.isDemo = data.isDemo
        self.bg = self:AddChild(Image(data.basic.atlas, data.basic.texture))
        self.bg:SetClickable(self.isDemo or false)
        self.bg2 = self:AddChild(Image(data.basic.atlas, data.basic.texture))
        self.bg2:SetClickable(self.isDemo or false)
        self.text = self:AddChild(Text(NUMBERFONT, 18, ""))
        self.healthReductions = {}
        self.style = "textonbar"
        self.showBg = true
        self.showBg2 = true
        self.showValue = true
        self.hp = 100
        self.hpMax = 100
        self.percentage = 1
        self.opacity = 1
        self.hbScale = 1
        self.hbYOffset = 0
        self.hbWidth = 120
        self.hbHeight = 18
        self.barMargin = { x1 = 3, x2 = 3, y1 = 3, y2 = 3, fixed = true }
        self.fontSize = 18
        self.hrDuration = 0.8
        self.screenWidth = 1920
        self.screenHeight = 1080
        self.bgColor = RGBAColor(1, 1, 1)
        self.bg2Color = RGBAColor(0, 0, 0)
        self.barColor = RGBAColor(1, 1, 1)
        self.hrColor = RGBAColor(1, 1, 1)
        self.preUpdateFn = nil
        self.onSetPercentage = nil
        self:SetData(data)
        self:SetOpacity()
        self:SetHBSize(120, 18)
        self:SetFontSize(20)
        self:StartUpdating()
        self:AddToTable()
    end)
dycGraphicHealthbar.ghbs = {}
function dycGraphicHealthbar:AddToTable() TableAdd(dycGraphicHealthbar.ghbs, self) end

function dycGraphicHealthbar:SetData(data)
    self.data = data
    self.basicAtlas = data.basic.atlas
    self.basicTex = data.basic.texture
    self.bgAtlas = data.bg and data.bg.atlas
    self.bgTex = data.bg and data.bg.texture
    self.barAtlas = data.bar and data.bar.atlas
    self.barTex = data.bar and data.bar.texture
    self:SetBgSkn(data.bgSkn)
    self:SetBarSkn(data.barSkn)
end

function dycGraphicHealthbar:SetBgTexture(atlas, texture)
    self.bg:SetTexture(atlas, texture)
    self.bg2:SetTexture(atlas, texture)
end

function dycGraphicHealthbar:SetBgSkn(bgSknData)
    self.bgSknData = bgSknData or nil
    if self.bgSkn then
        self.bgSkn:Kill()
        self.bgSkn = nil
    end
    if self.bgSknData then
        self.bgSkn = self:AddChild(dycSlicedImage(self.bgSknData))
        self.bgSkn:SetClickable(self.isDemo or false)
        self.bgSkn:MoveToBack()
        self.showBg = false
    else
        self:SetBgTexture(self.bgAtlas or self.basicAtlas, self.bgTex or self.basicTex)
        self.showBg = true
    end
    if self.data and (self.data.bg2 or not self.data.bg) then self.showBg2 = true else self.showBg2 = false end
    self.bgColor = self.data and self.data.bg and self.data.bg.color or RGBAColor(1, 1, 1)
    self.bg2Color = self.data and self.data.bg2 and self.data.bg2.color or RGBAColor(0, 0, 0)
end

function dycGraphicHealthbar:SetBarSkn(barSknData)
    self.barSknData = barSknData or nil
    if self.bar then
        self.bar:Kill()
        self.bar = nil
    end
    if self.barSknData then
        self.bar = self:AddChild(dycSlicedImage(self.barSknData))
        self.bar:SetClickable(self.isDemo or false)
        self.bar:MoveToFront()
        self.text:MoveToFront()
    else
        self.bar = self:AddChild(Image(self.barAtlas or self.basicAtlas, self.barTex or self.basicTex))
        self.bar:SetClickable(self.isDemo or false)
        self.bar:MoveToFront()
        self.text:MoveToFront()
    end
end

function dycGraphicHealthbar:SetBarTexture(atlas, texture) if self.bar.SetTexture then self.bar:SetTexture(atlas, texture) end end

function dycGraphicHealthbar:SetValue(hp, hpMax, notShowReduction)
    self.hp = hp or self.hp
    self.hpMax = hpMax or self.hpMax
    self.text:SetString(string.format("%d/%d", hp, hpMax))
    self:SetPercentage(hp / hpMax, notShowReduction)
end

function dycGraphicHealthbar:SetYOffSet(hbYOffset, useScale)
    hbYOffset = hbYOffset or self.hbYOffset
    self.hbYOffset = hbYOffset
    local wSacle = self.screenWidth / 1920
    self:SetScreenOffset(-5 * wSacle, self.hbYOffset * (useScale and self.hbScale or 1) * wSacle)
end

function dycGraphicHealthbar:SetPercentage(percentage, notShowReduction)
    local oldPercentage = self.percentage
    percentage = percentage or self.percentage
    percentage = math.max(0, math.min(percentage, 1))
    if oldPercentage - percentage > 0.01 and not notShowReduction and self.shown then self:DisplayHealthReduction(oldPercentage, percentage) end
    self.percentage = percentage
    local w, h = self:GetSize()
    local barW, barH = self:GetBarFullSize()
    local barVW, barVH = self:GetBarVirtualSize()
    local barRW = barW - barVW * (1 - percentage)
    local ox, oy = self:GetBarOffset()
    self.bar:SetSize(barRW, barH)
    self.bar:SetPosition(-(barW - barRW) / 2 + ox, oy, 0)
    if self.textHealthBar then self.textHealthBar:SetPercentage(percentage) end
    if self.onSetPercentage then self.onSetPercentage(self, percentage) end
end

function dycGraphicHealthbar:SetHBSize(hbWidth, hbHeight)
    hbWidth = hbWidth or self.hbWidth
    hbHeight = hbHeight or self.hbHeight
    hbWidth = math.max(hbWidth, 0)
    hbHeight = math.max(hbHeight, 0)
    self.hbWidth = hbWidth
    self.hbHeight = hbHeight
    hbWidth = hbWidth * self.hbScale
    hbHeight = hbHeight * self.hbScale
    self.bg:SetSize(hbWidth, hbHeight)
    self.bg2:SetSize(math.max(hbWidth - 2, 0), math.max(hbHeight - 2, 0))
    if self.bgSknData and self.bgSkn then
        local bgw, bgh = self:GetBgSknSize()
        self.bgSkn:SetSize(bgw, bgh)
        local ox, oy = self:GetBgOffset()
        self.bgSkn:SetPosition(ox, oy, 0)
    end
    self:SetPercentage()
    self:SetYOffSet()
    if self.textHealthBar then self.textHealthBar:SetFontSize(self.hbHeight * 1) end
end

function dycGraphicHealthbar:SetFontSize(fontSize)
    fontSize = fontSize or self.fontSize
    self.fontSize = fontSize
    self.text:SetSize(self.fontSize * self.hbScale)
    local w, h = self:GetSize()
    if self.style == "textoverbar" then
        self.text:SetPosition(0, h / 2 + self.fontSize * self.hbScale * 0.35, 0)
    elseif self.style == "barovertext" then
        self.text:SetPosition(0,
            -h / 2 - self.fontSize * self.hbScale * 0.35, 0)
    else
        self.text:SetPosition(0, 0, 0)
    end
end

function dycGraphicHealthbar:SetHBScale(hbScale)
    hbScale = hbScale or self.hbScale
    self.hbScale = hbScale
    self:SetHBSize()
    self:SetFontSize()
    if self.textHealthBar then self.textHealthBar:SetHBScale(hbScale) end
end

function dycGraphicHealthbar:SetStyle(style)
    style = style or self.style
    if style == self.style then return end
    self.style = style
    self:SetFontSize()
end

function dycGraphicHealthbar:SetOpacity(opacity)
    opacity = opacity or self.opacity
    self.opacity = opacity
    local bgColor = self.bgColor
    self.bg:SetTint(bgColor.r, bgColor.g, bgColor.b, self.showBg and opacity or 0)
    bgColor = self.bg2Color
    self.bg2:SetTint(bgColor.r, bgColor.g, bgColor.b, self.showBg and self.showBg2 and opacity or 0)
    bgColor = self.barColor
    self.bar:SetTint(bgColor.r, bgColor.g, bgColor.b, opacity)
    if self.bgSkn then self.bgSkn:SetTint(1, 1, 1, opacity) end
end

function dycGraphicHealthbar:SetBarColor(colorOrR, g, b)
    colorOrR = colorOrR or 1
    g = g or 1
    b = b or 1
    if type(colorOrR) == "table" then
        self.barColor.r = colorOrR.r or colorOrR.x or colorOrR[1] or 1
        self.barColor.g = colorOrR.g or colorOrR.y or colorOrR[2] or 1
        self.barColor.b = colorOrR.b or colorOrR.z or colorOrR[3] or 1
    else
        self.barColor.r = colorOrR
        self.barColor.g = g
        self.barColor.b = b
    end
    self:SetOpacity()
    if self.textHealthBar then self.textHealthBar:SetColor(colorOrR, g, b) end
end

function dycGraphicHealthbar:SetTextColor(colorOrR, g, b, a)
    colorOrR = colorOrR or 1
    g = g or 1
    b = b or 1
    a = a or 1
    if type(colorOrR) == "table" then
        colorOrR.r = colorOrR.r or colorOrR.x or colorOrR[1] or 1
        colorOrR.g = colorOrR.g or colorOrR.y or colorOrR[2] or 1
        colorOrR.b = colorOrR.b or colorOrR.z or colorOrR[3] or 1
        colorOrR.a = colorOrR.a or colorOrR[1] or 1
        self.text:SetColour(colorOrR.r, colorOrR.g, colorOrR.b, colorOrR.a)
    else
        self.text:SetColour(colorOrR, g, b, a)
    end
end

function dycGraphicHealthbar:DisplayHealthReduction(old, new)
    local reduction = self.bg2:AddChild(Image(self.basicAtlas, self.basicTex))
    reduction:SetClickable(self.isDemo or false)
    local w, h = self:GetSize()
    local w2, h2 = self:GetBarVirtualSize()
    local w3 = w2 * math.max(0, old - new)
    local dx = ((new + old) / 2 - 0.5) * w2
    local ox, oy = self:GetBarVirtualOffset()
    local color = self.data and self.data.hrUseBarColor and self.barColor or self.hrColor
    reduction:SetSize(w3, h2)
    reduction:SetPosition(dx + ox, oy, 0)
    reduction:SetTint(color.r, color.g, color.b, self.opacity)
    reduction.fadeTimer = self.hrDuration
    table.insert(self.healthReductions, reduction)
end

function dycGraphicHealthbar:AnimateIn(speed)
    self.animHBWidth = self.hbWidth
    self.animIn = true
    self.animSpeed = speed or 5
    self:SetHBSize(0, self.hbHeight)
end

function dycGraphicHealthbar:AnimateOut(speed)
    self.animHBWidth = 0
    self.animOut = true
    self.animSpeed = speed or 5
end

function dycGraphicHealthbar:Kill()
    TableRemoveValue(dycGraphicHealthbar.ghbs, self)
    Widget.Kill(self)
end

function dycGraphicHealthbar:OnMouseButton(button, down, x, y, ...)
    local result = dycGraphicHealthbar._base.OnMouseButton(self, button, down, x, y, ...)
    if not down and button == MOUSEBUTTON_LEFT then self.dragging = false end
    if not self.focus then return false end
    if self.isDemo and down and button == MOUSEBUTTON_LEFT then self.dragging = true end
    return result
end

function dycGraphicHealthbar:GetSize()
    local w, h = self.bg:GetSize()
    w = w or 1
    h = h or 1
    return w, h
end

function dycGraphicHealthbar:GetBgMargin()
    local w, h = self:GetSize()
    local margin = self.bgSknData and self.bgSknData.margin or (self.data and self.data.bg and self.data.bg.margin) or { x1 = 0, x2 = 0, y1 = 0, y2 = 0, }
    local x1 = margin.fixed and margin.x1 or margin.x1 * h
    local x2 = margin.fixed and margin.x2 or margin.x2 * h
    local y1 = margin.fixed and margin.y1 or margin.y1 * h
    local y2 = margin.fixed and margin.y2 or margin.y2 * h
    return x1, x2, y1, y2
end

function dycGraphicHealthbar:GetBarMargin()
    local w, h = self:GetSize()
    local margin = self.barSknData and self.barSknData.margin or (self.data and self.data.bar and self.data.bar.margin) or self.barMargin
    local x1 = margin.fixed and margin.x1 or margin.x1 * h
    local x2 = margin.fixed and margin.x2 or margin.x2 * h
    local y1 = margin.fixed and margin.y1 or margin.y1 * h
    local y2 = margin.fixed and margin.y2 or margin.y2 * h
    return x1, x2, y1, y2
end

function dycGraphicHealthbar:GetBarVirtualMargin()
    local w, h = self:GetSize()
    local margin = self.barSknData and self.barSknData.vmargin or (self.data and self.data.bar and self.data.bar.vmargin) or (self.barSknData and self.barSknData.margin) or
        (self.data and self.data.bar and self.data.bar.margin) or self.barMargin
    local x1 = margin.fixed and margin.x1 or margin.x1 * h
    local x2 = margin.fixed and margin.x2 or margin.x2 * h
    local y1 = margin.fixed and margin.y1 or margin.y1 * h
    local y2 = margin.fixed and margin.y2 or margin.y2 * h
    return x1, x2, y1, y2
end

function dycGraphicHealthbar:GetBgOffset()
    local mx1, mx2, my1, my2 = self:GetBgMargin()
    return (mx1 - mx2) / 2, (my1 - my2) / 2
end

function dycGraphicHealthbar:GetBarOffset()
    local mx1, mx2, my1, my2 = self:GetBarMargin()
    return (mx1 - mx2) / 2, (my1 - my2) / 2
end

function dycGraphicHealthbar:GetBarVirtualOffset()
    local px1, px2, py1, py2 = self:GetBarVirtualMargin()
    return (px1 - px2) / 2, (py1 - py2) / 2
end

function dycGraphicHealthbar:GetBgSknSize()
    local w, h = self:GetSize()
    local mx1, mx2, my1, my2 = self:GetBgMargin()
    return math.max(w - mx1 - mx2, 2), math.max(h - my1 - my2, 2)
end

function dycGraphicHealthbar:GetBarFullSize()
    local w, h = self:GetSize()
    local mx1, mx2, my1, my2 = self:GetBarMargin()
    return math.max(w - mx1 - mx2, 2), math.max(h - my1 - my2, 2)
end

function dycGraphicHealthbar:GetBarVirtualSize()
    local w, h = self:GetSize()
    local px1, px2, py1, py2 = self:GetBarVirtualMargin()
    return math.max(w - px1 - px2, 0), math.max(h - py1 - py2, 0)
end

function dycGraphicHealthbar:SetTarget(target)
    self.target = target
    self:OnUpdate()
end

function dycGraphicHealthbar:SetWorldOffset(worldOffset)
    self.worldOffset = worldOffset
    self:OnUpdate()
end

function dycGraphicHealthbar:SetScreenOffset(x, y)
    self.screen_offset.x = x
    self.screen_offset.y = y
    self:OnUpdate()
end

function dycGraphicHealthbar:GetScreenOffset() return self.screen_offset.x, self.screen_offset.y end

function dycGraphicHealthbar:OnUpdate(t)
    t = t or 0
    if self.target and self.target:IsValid() then
        if self.preUpdateFn then self.preUpdateFn(t) end
        local pos = nil
        if self.target.AnimState then
            pos = Vector3(self.target.AnimState:GetSymbolPosition(self.symbol or "", self.worldOffset.x, self.worldOffset.y, self.worldOffset.z))
        else
            pos = self.target:GetPosition()
        end
        if pos then
            local posNew = Vector3(TheSim:GetScreenPos(pos:Get()))
            posNew.x = posNew.x + self.screen_offset.x
            posNew.y = posNew.y + self.screen_offset.y
            self:SetPosition(posNew)
        end
    end
    if self.animOut and t > 0 then
        if math.abs(self.hbWidth - self.animHBWidth) < 3 then
            self.animOut = false
            self:SetHBSize(self.animHBWidth, self.hbHeight)
            self:Kill()
            return
        else
            self:SetHBSize(Lerp(self.hbWidth, self.animHBWidth, self.animSpeed * t), self.hbHeight)
        end
    elseif self.animIn and t > 0 then
        if math.abs(self.hbWidth - self.animHBWidth) < 1 then
            self.animIn = false
            self:SetHBSize(self.animHBWidth, self.hbHeight)
        else
            self:SetHBSize(Lerp(self.hbWidth, self.animHBWidth, self.animSpeed * t), self.hbHeight)
        end
    end
    local healthReductions = self.healthReductions
    if #healthReductions > 0 and t > 0 then
        for i = #healthReductions, 1, -1 do
            local healthReduction = healthReductions[i]
            healthReduction.fadeTimer = healthReduction.fadeTimer - t
            if healthReduction.fadeTimer < 0 then
                table.remove(healthReductions, i)
                healthReduction:Kill()
                break
            end
            local color = self.data and self.data.hrUseBarColor and self.barColor or self.hrColor
            healthReduction:SetTint(color.r, color.g, color.b, self.opacity * healthReduction.fadeTimer / self.hrDuration)
        end
    end
    if self.showValue and not self.text.shown then self.text:Show() elseif not self.showValue and self.text.shown then self.text:Hide() end
    local sw, sh = TheSim:GetScreenSize()
    if sw ~= self.screenWidth or sh ~= self.screenHeight then
        self.screenWidth = sw
        self.screenHeight = sh
        self:SetYOffSet()
    end
    if self.isDemo and self.dragging and t > 0 then
        local scale = self:GetScale()
        local x, y = TheInput:GetScreenPosition():Get()
        local pos = self:GetWorldPosition()
        local barW, barH = self:GetBarVirtualSize()
        barW = barW * scale.x
        barH = barH * scale.y
        local ox, oy = self:GetBarVirtualOffset()
        ox = ox * scale.x
        oy = oy * scale.y
        local percentage = (x - (pos.x + ox) + barW / 2) / barW
        self:SetPercentage(percentage, true)
        if not self.focus then self.dragging = false end
    end
end

return dycGraphicHealthbar
