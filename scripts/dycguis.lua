local Widget = require "widgets/widget"
local Image = require "widgets/image"
local Text = require "widgets/text"
local Screen = require "widgets/screen"
local Button = require "widgets/button"
local Spinner = require "widgets/spinner"
local dycGuis = {}

--#region tool functions
local function isDST() return TheSim:GetGameID() == "DST" end
local function getPlayer() if isDST() then return ThePlayer else return GetPlayer() end end
local function getWorld() if isDST() then return TheWorld else return GetWorld() end end
local getWidthScal = function()
    local w, h = TheSim:GetScreenSize()
    return w / 1920
end
local getMouseScreenPos = function() return TheSim:GetScreenPos(TheInput:GetWorldPosition():Get()) end
local RGBAColor = function(r, g, b, a)
    return {
        r = r or 1,
        g = g or 1,
        b = b or 1,
        a = a or 1,
        Get = function(self) return self.r, self.g, self.b, self.a end,
    }
end
local lerp = function(a, b, t) return a + (b - a) * t end
local function StrSpl(str, separators)
    if separators == nil then separators = "%s" end
    local spls = {}
    local i = 1
    for world in string.gmatch(str, "([^" .. separators .. "]+)") do
        spls[i] = world
        i = i + 1
    end
    return spls
end
local tableContains = function(table, value)
    for _, v in pairs(table) do if v == value then return true end end
    return false
end
local tableAdd = function(tableTo, value) if not tableContains(tableTo, value) then table.insert(tableTo, value) end end
local TableGetIndex = function(table, value) for k, v in pairs(table) do if v == value then return k end end end
local TableRemoveValue = function(tableTo, value)
    local index = TableGetIndex(tableTo, value)
    if index then table.remove(tableTo, index) end
end
--#endregion

--#region dycRoot
local dycRoot = Class(Widget, function(self, parent)
    Widget._ctor(self, "DYC_Root")
    self.keepTop = parent.keepTop
    self.moveLayerTimer = 0
    if parent.keepTop then self:StartUpdating() end
end)
function dycRoot:OnUpdate(time)
    time = time or 0
    self.moveLayerTimer = self.moveLayerTimer + time
    if self.keepTop and self.moveLayerTimer > 0.5 then
        self.moveLayerTimer = 0
        self:MoveToFront()
    end
end

dycGuis.Root = dycRoot
--#endregion

--#region dycText
local dycText = Class(Text,
    function(self, font, size, text, hittest)
        if font and type(font) == "table" then
            local tempFont = font
            Text._ctor(self, tempFont.font or NUMBERFONT, tempFont.fontSize or 30, tempFont.text)
            if tempFont.color then
                local color = tempFont.color
                self:SetColor(color.r or color[1] or 1, color.g or color[2] or 1, color.b or color[3] or 1, color.a or color[4] or 1)
            end
            if tempFont.regionSize then self:SetRegionSize(tempFont.regionSize.w, tempFont.regionSize.h) end
            self.alignH = tempFont.alignH
            self.alignV = tempFont.alignV
            self.focusFn = tempFont.focusFn
            self.unfocusFn = tempFont.unfocusFn
            self.hittest = tempFont.hittest
        else
            Text._ctor(self, font or NUMBERFONT, size or 30, text)
            self.hittest = hittest
            if text then self:SetText(text) end
        end
    end)
function dycText:GetImage()
    if not self.image then
        self.image = self:AddChild(Image("images/ui.xml", "button.tex"))
        self.image:MoveToBack()
        self.image:SetTint(0, 0, 0, 0)
    end
    return self.image
end

function dycText:SetText(text)
    local width = self:GetWidth()
    local height = self:GetHeight()
    local position = self:GetPosition()
    self:SetString(text)
    if self.alignH and self.alignH ~= ANCHOR_MIDDLE then
        local width_ = self:GetWidth()
        position.x = position.x + (width_ - width) / 2 * (self.alignH == ANCHOR_LEFT and 1 or -1)
    end
    if self.alignV and self.alignV ~= ANCHOR_MIDDLE then
        local height_ = self:GetHeight()
        position.y = position.y + (height_ - height) / 2 * (self.alignV == ANCHOR_BOTTOM and 1 or -1)
    end
    if self.alignH or self.alignV then self:SetPosition(position) end
    if self.hittest then self:GetImage():SetSize(self:GetSize()) end
end

function dycText:SetColor(...) self:SetColour(...) end

function dycText:GetWidth()
    local w, h = self:GetRegionSize()
    w = w < 10000 and w or 0
    return w
end

function dycText:GetHeight()
    local _, h = self:GetRegionSize()
    h = h < 10000 and h or 0
    return h
end

function dycText:GetSize()
    local w, h = self:GetRegionSize()
    w = w < 10000 and w or 0
    h = h < 10000 and h or 0
    return w, h
end

function dycText:OnGainFocus()
    dycText._base.OnGainFocus(self)
    if self.focusFn then self.focusFn(self) end
end

function dycText:OnLoseFocus()
    dycText._base.OnLoseFocus(self)
    if self.unfocusFn then self.unfocusFn(self) end
end

function dycText:AnimateIn(speed)
    self.textString = self.string
    self.animSpeed = speed or 60
    self.animIndex = 0
    self.animTimer = 0
    self:SetText("")
    self:StartUpdating()
end

function dycText:OnUpdate(time)
    time = time or 0
    if dycText._base.OnUpdate then dycText._base.OnUpdate(self, time) end
    if time > 0 and self.animIndex and self.textString and #self.textString > 0 then
        self.animTimer = self.animTimer + time
        if self.animTimer > 1 / self.animSpeed then
            self.animTimer = 0
            self.animIndex = self.animIndex + 1
            if self.animIndex > #self.textString then
                self.animIndex = nil
                self:SetText(self.textString)
            else
                local char = string.byte(string.sub(self.textString, self.animIndex, self.animIndex))
                if char and char > 127 then self.animIndex = self.animIndex + 2 end
                self:SetText(string.sub(self.textString, 1, self.animIndex))
            end
        end
    end
end

dycGuis.Text = dycText
--#endregion

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

dycGuis.SlicedImage = dycSlicedImage
--#endregion

--#region dycSpinner
local dycSpinner = Class(Spinner, function(self, options, width, height, textinfo, editable, atlas, textures) Spinner._ctor(self, options, width, height, textinfo, editable, atlas, textures) end)
function dycSpinner:GetSelectedHint() return self.options[self.selectedIndex].hint or "" end

function dycSpinner:SetSelected(value, data)
    if value == nil and data ~= nil then return self:SetSelected(data) end
    for id, option in pairs(self.options) do
        if option.data == value then
            self:SetSelectedIndex(id)
            return true
        end
    end
    if data then return self:SetSelected(data) else return false end
end

function dycSpinner:SetSelectedIndex(id, ...)
    dycSpinner._base.SetSelectedIndex(self, id, ...)
    if self.setSelectedIndexFn then self.setSelectedIndexFn(self) end
end

function dycSpinner:OnGainFocus()
    dycSpinner._base.OnGainFocus(self)
    if self.focusFn then self.focusFn(self) end
end

function dycSpinner:OnLoseFocus()
    dycSpinner._base.OnLoseFocus(self)
    if self.unfocusFn then self.unfocusFn(self) end
end

function dycSpinner:OnMouseButton(button, down, x, y, ...)
    dycSpinner._base.OnMouseButton(self, button, down, x, y, ...)
    if not down and button == MOUSEBUTTON_LEFT then if self.mouseLeftUpFn then self.mouseLeftUpFn(self) end end
    if not self.focus then return false end
    if down and button == MOUSEBUTTON_LEFT then if self.mouseLeftDownFn then self.mouseLeftDownFn(self) end end
end

dycGuis.Spinner = dycSpinner
--#endregion

--#region dycImageButton
local dycImageButton = Class(Button,
    function(self, data)
        Button._ctor(self, "DYC_ImageButton")
        data = data or {}
        local atlas, normal, focus, disabled = data.atlas, data.normal, data.focus, data.disabled
        atlas = atlas or "images/ui.xml"
        normal = normal or "button.tex"
        focus = focus or "button_over.tex"
        disabled = disabled or "button_disabled.tex"
        self.width = data.width or 100
        self.height = data.height or 30
        self.screenScale = 0.9999
        self.moveLayerTimer = 0
        self.followScreenScale = data.followScreenScale
        self.draggable = data.draggable
        if data.draggable then self.clickoffset = Vector3(0, 0, 0) end
        self.dragging = false
        self.draggingTimer = 0
        self.draggingPos = { x = 0, y = 0 }
        self.keepTop = data.keepTop
        self.image = self:AddChild(Image())
        self.image:MoveToBack()
        self.atlas = atlas
        self.image_normal = normal
        self.image_focus = focus or normal
        self.image_disabled = disabled or normal
        self.color_normal = data.colornormal or RGBAColor()
        self.color_focus = data.colorfocus or RGBAColor()
        self.color_disabled = data.colordisabled or RGBAColor()
        if data.cb then self:SetOnClick(data.cb) end
        if data.text then
            self:SetText(data.text)
            self:SetFont(data.font or NUMBERFONT)
            self:SetTextSize(data.fontSize or self.height * 0.75)
            local r, g, b, a = 1, 1, 1, 1
            if data.textColor then
                r = data.textColor.r; g = data.textColor.g; b = data.textColor.b; a = data.textColor.a
            end
            self:SetTextColour(r, g, b, a)
        end
        self:SetTexture(self.atlas, self.image_normal)
        self:StartUpdating()
    end)
function dycImageButton:SetSize(width, height)
    width = width or self.width; height = height or self.height
    self.width = width; self.height = height
    self.image:SetSize(self.width, self.height)
end

function dycImageButton:GetSize() return self.image:GetSize() end

function dycImageButton:SetTexture(atlas, tex)
    self.image:SetTexture(atlas, tex)
    self:SetSize()
    local color = self.color_normal
    self.image:SetTint(color.r, color.g, color.b, color.a)
end

function dycImageButton:SetTextures(atlas, image_normal, image_focus, image_disabled)
    local seted = false
    if not atlas then
        atlas = atlas or "images/frontend.xml"
        image_normal = image_normal or "button_long.tex"
        image_focus = image_focus or "button_long_halfshadow.tex"
        image_disabled = image_disabled or "button_long_disabled.tex"
        seted = true
    end
    self.atlas = atlas
    self.image_normal = image_normal
    self.image_focus = image_focus or image_normal
    self.image_disabled = image_disabled or image_normal
    if self:IsEnabled() then if self.focus then self:OnGainFocus() else self:OnLoseFocus() end else self:OnDisable() end
end

function dycImageButton:OnGainFocus()
    dycImageButton._base.OnGainFocus(self)
    if self:IsEnabled() then
        self:SetTexture(self.atlas, self.image_focus)
        local color = self.color_focus
        self.image:SetTint(color.r, color.g, color.b, color.a)
    end
    if self.image_focus == self.image_normal then self.image:SetScale(1.2, 1.2, 1.2) end
    if self.focusFn then self.focusFn(self) end
end

function dycImageButton:OnLoseFocus()
    dycImageButton._base.OnLoseFocus(self)
    if self:IsEnabled() then
        self:SetTexture(self.atlas, self.image_normal)
        local color = self.color_normal
        self.image:SetTint(color.r, color.g, color.b, color.a)
    end
    if self.image_focus == self.image_normal then self.image:SetScale(1, 1, 1) end
    if self.unfocusFn then self.unfocusFn(self) end
end

function dycImageButton:OnMouseButton(button, down, x, y, ...)
    dycImageButton._base.OnMouseButton(self, button, down, x, y, ...)
    if not down and button == MOUSEBUTTON_LEFT and self.dragging then
        self.dragging = false
        if self.dragEndFn then self.dragEndFn(self) end
    end
    if not self.focus then return false end
    if self.draggable and button == MOUSEBUTTON_LEFT then
        if down then
            self.dragging = true
            self.draggingPos.x = x
            self.draggingPos.y = y
        end
    end
end

function dycImageButton:OnControl(control, down, ...)
    if self.draggingTimer <= 0.3 then
        if dycImageButton._base.OnControl(self, control, down, ...) then
            self:StartUpdating()
            return true
        end
        self:StartUpdating()
    end
    if not self:IsEnabled() or not self.focus then return end
end

function dycImageButton:Enable()
    dycImageButton._base.Enable(self)
    self:SetTexture(self.atlas, self.focus and self.image_focus or self.image_normal)
    local color = self.focus and self.color_focus or self.color_normal
    self.image:SetTint(color.r, color.g, color.b, color.a)
    if self.image_focus == self.image_normal then if self.focus then self.image:SetScale(1.2, 1.2, 1.2) else self.image:SetScale(1, 1, 1) end end
end

function dycImageButton:Disable()
    dycImageButton._base.Disable(self)
    self:SetTexture(self.atlas, self.image_disabled)
    local color = self.color_disabled or self.color_normal
    self.image:SetTint(color.r, color.g, color.b, color.a)
end

function dycImageButton:OnUpdate(t)
    t = t or 0
    local widthScale = getWidthScal()
    if self.followScreenScale and widthScale ~= self.screenScale then
        self:SetScale(widthScale)
        local position = self:GetPosition()
        position.x = position.x * widthScale / self.screenScale
        position.y = position.y * widthScale / self.screenScale
        self.o_pos = position
        self:SetPosition(position)
        self.screenScale = widthScale
    end
    if self.draggable and self.dragging then
        self.draggingTimer = self.draggingTimer + t
        local x, y = getMouseScreenPos()
        local newX = x - self.draggingPos.x
        local newY = y - self.draggingPos.y
        self.draggingPos.x = x; self.draggingPos.y = y
        local position = self:GetPosition()
        position.x = position.x + newX; position.y = position.y + newY
        self.o_pos = position
        self:SetPosition(position)
    end
    if not self.dragging then self.draggingTimer = 0 end
    self.moveLayerTimer = self.moveLayerTimer + t
    if self.keepTop and self.moveLayerTimer > 0.5 then
        self.moveLayerTimer = 0
        self:MoveToFront()
    end
end

dycGuis.ImageButton = dycImageButton
--#endregion

--#region dycWindow
local dycWindow = Class(Widget,
    function(self)
        Widget._ctor(self, "DYC_Window")
        self.width = 400
        self.height = 300
        self.paddingX = 40
        self.paddingY = 42
        self.screenScale = 0.9999
        self.currentLineY = 0
        self.currentLineX = 0
        self.lineHeight = 35
        self.lineSpacingX = 10
        self.lineSpacingY = 3
        self.fontSize = self.lineHeight * 0.9
        self.font = NUMBERFONT
        self.titleFontSize = 40
        self.titleFont = NUMBERFONT
        self.titleColor = RGBAColor(1, 0.7, 0.4)
        self.draggable = true
        self.dragging = false
        self.draggingPos = { x = 0, y = 0 }
        self.draggableChildren = {}
        self.moveLayerTimer = 0
        self.keepTop = false
        self.currentPageIndex = 1
        self.pages = {}
        self.animTargetSize = nil
        self.bg = self:AddChild(dycSlicedImage({ mode = "slice33", atlas = "images/dycghb_panel.xml", texname = "dycghb_panel", texScale = 1.0, }))
        self.bg:SetSize(self.width, self.height)
        self.bg:SetTint(1, 1, 1, 1)
        self:SetCenterAlignment()
        self:AddDraggableChild(self.bg, true)
        self.root = self.bg:AddChild(Widget("root"))
        self.rootTL = self.root:AddChild(Widget("rootTL"))
        self.rootT = self.root:AddChild(Widget("rootT"))
        self.rootTR = self.root:AddChild(Widget("rootTR"))
        self.rootL = self.root:AddChild(Widget("rootL"))
        self.rootM = self.root:AddChild(Widget("rootM"))
        self.rootR = self.root:AddChild(Widget("rootR"))
        self.rootB = self.root:AddChild(Widget("rootB"))
        self.rootBL = self.root:AddChild(Widget("rootBL"))
        self.rootBR = self.root:AddChild(Widget("rootBR"))
        self:SetSize()
        self:SetOffset(0, 0, 0)
        self:StartUpdating()
    end)
function dycWindow:SetBottomAlignment()
    self.bg:SetVAnchor(ANCHOR_BOTTOM)
    self.bg:SetHAnchor(ANCHOR_MIDDLE)
end

function dycWindow:SetBottomLeftAlignment()
    self.bg:SetVAnchor(ANCHOR_BOTTOM)
    self.bg:SetHAnchor(ANCHOR_LEFT)
end

function dycWindow:SetTopLeftAlignment()
    self.bg:SetVAnchor(ANCHOR_TOP)
    self.bg:SetHAnchor(ANCHOR_LEFT)
end

function dycWindow:SetCenterAlignment()
    self.bg:SetVAnchor(ANCHOR_MIDDLE)
    self.bg:SetHAnchor(ANCHOR_MIDDLE)
end

function dycWindow:SetOffset(...) self.bg:SetPosition(...) end

function dycWindow:GetOffset() return self.bg:GetPosition() end

function dycWindow:SetSize(width, height)
    width = width or self.width; height = height or self.height
    self.width = width; self.height = height
    self.bg:SetSize(width, height)
    self.rootTL:SetPosition(-width / 2, height / 2, 0)
    self.rootT:SetPosition(0, height / 2, 0)
    self.rootTR:SetPosition(width / 2, height / 2, 0)
    self.rootL:SetPosition(-width / 2, 0, 0)
    self.rootM:SetPosition(0, 0, 0)
    self.rootR:SetPosition(width / 2, 0, 0)
    self.rootBL:SetPosition(-width / 2, -height / 2, 0)
    self.rootB:SetPosition(0, -height / 2, 0)
    self.rootBR:SetPosition(width / 2, -height / 2, 0)
end

function dycWindow:GetSize() return self.width, self.height end

function dycWindow:SetTitle(title, font, size, color)
    if not self.title then self.title = self.rootT:AddChild(dycText(NUMBERFONT, 10)) end
    title = title or self.title:GetString(); font = font or self.titleFont; size = size or self.titleFontSize; color = color or self.titleColor
    self.titleFont = font; self.titleFontSize = size; self.titleColor = color
    self.title:SetString(title)
    self.title:SetFont(font)
    self.title:SetSize(size)
    self.title:SetPosition(0, -size / 2 * 1.3 - self.paddingY, 0)
    self.title:SetColor(color.r or color[1] or 1, color.g or color[2] or 1, color.b or color[3] or 1, color.a or color[4] or 1)
end

function dycWindow:GetPage(id)
    id = id or self.currentPageIndex
    id = math.max(1, math.floor(id))
    while self.pages[id] == nil do table.insert(self.pages, { root = self.rootTL:AddChild(Widget("rootPage" .. id)), contents = {}, }) end
    return self.pages[id]
end

function dycWindow:SetCurrentPage(id)
    id = math.max(1, math.floor(id))
    self.currentPageIndex = id
    self.currentLineY = 0
    self.currentLineX = 0
    return self:GetPage()
end

function dycWindow:ShowPage(id)
    id = id or self.currentPageIndex
    id = math.max(1, math.min(math.floor(id), #self.pages))
    self:SetCurrentPage(id)
    for i = 1, #self.pages do self:ToggleContents(i, i == id) end
    if self.pageChangeFn then self.pageChangeFn(self, id) end
end

function dycWindow:ShowNextPage()
    local id = self.currentPageIndex + 1
    if id > #self.pages then id = 1 end
    self:ShowPage(id)
end

function dycWindow:ShowPreviousPage()
    local id = self.currentPageIndex - 1
    if id < 1 then id = #self.pages end
    self:ShowPage(id)
end

function dycWindow:ClearPages()
    if #self.pages <= 0 then return end
    for id = 1, #self.pages do self:ClearContents(id) end
end

function dycWindow:AddContent(contentData, size)
    local page = self:GetPage()
    local newContent = page.root:AddChild(contentData)
    if not size then
        if newContent.GetRegionSize then
            size = newContent:GetRegionSize()
        elseif newContent.GetWidth then
            size = newContent:GetWidth()
        elseif newContent.GetSize then
            size = newContent:GetSize()
        elseif newContent.width then
            size =
                newContent.width
        end
    end
    size = size or 100
    newContent:SetPosition(self.paddingX + self.currentLineX + size / 2, -self.paddingY - self.currentLineY - self.lineHeight * 0.5, 0)
    self.currentLineX = self.currentLineX + size + self.lineSpacingX
    tableAdd(page.contents, newContent)
    return newContent
end

function dycWindow:ToggleContents(id, enable)
    local page = self:GetPage(id)
    if enable then page.root:Show() else page.root:Hide() end
end

function dycWindow:ClearContents(id)
    id = id or self.currentPageIndex
    for _, content in pairs(self:GetPage(id).contents) do content:Kill() end
    self:GetPage(id).contents = {}
    self.currentLineY = 0
    self.currentLineX = 0
end

function dycWindow:NewLine(scale)
    self.currentLineY = self.currentLineY + (scale or 1) * self.lineHeight + self.lineSpacingY
    self.currentLineX = 0
end

function dycWindow:AddDraggableChild(child, withChildren)
    tableAdd(self.draggableChildren, child)
    if withChildren then for _, child_ in pairs(child.children) do self:AddDraggableChild(child_, true) end end
end

function dycWindow:OnRawKey(key, down, ...)
    local flag = dycWindow._base.OnRawKey(self, key, down, ...)
    if not self.focus then return false end
    return flag
end

function dycWindow:OnControl(control, down, ...)
    local flag = dycWindow._base.OnControl(self, control, down, ...)
    if not self.focus then return false end
    return flag
end

function dycWindow:OnMouseButton(button, down, x, y, ...)
    local flag = dycWindow._base.OnMouseButton(self, button, down, x, y, ...)
    if not down and button == MOUSEBUTTON_LEFT then self.dragging = false end
    if not self.focus then return false end
    if self.draggable and button == MOUSEBUTTON_LEFT then
        if down then
            local focus = self:GetDeepestFocus()
            if focus and tableContains(self.draggableChildren, focus) then
                self.dragging = true
                self.draggingPos.x = x
                self.draggingPos.y = y
            end
        end
    end
    return flag
end

function dycWindow:Toggle(show, ok)
    show = show ~= nil and show or not self.shown
    if show then self:Show() else self:Hide() end
    if self.toggleFn then self.toggleFn(self, show) end
    if not show and ok and self.okFn then self.okFn(self) end
    if not show and not ok and self.cancelFn then self.cancelFn(self) end
end

function dycWindow:AnimateSize(w, h, speed)
    if w and h then
        self.animTargetSize = { w = w, h = h }
        self.animSpeed = speed or 5
    end
end

function dycWindow:OnUpdate(t)
    t = t or 0
    if self.animTargetSize and t > 0 then
        local w, h = self:GetSize()
        if math.abs(w - self.animTargetSize.w) < 1 then
            self:SetSize(self.animTargetSize.w, self.animTargetSize.h)
            self.animTargetSize = nil
        else
            self:SetSize(lerp(w, self.animTargetSize.w, self.animSpeed * t), lerp(h, self.animTargetSize.h, self.animSpeed * t))
        end
    end
    local widthScale = getWidthScal()
    if widthScale ~= self.screenScale then
        self.bg:SetScale(widthScale)
        local offset = self:GetOffset()
        offset.x = offset.x * widthScale / self.screenScale
        offset.y = offset.y * widthScale / self.screenScale
        self:SetOffset(offset)
        self.screenScale = widthScale
    end
    if self.draggable and self.dragging then
        local x, y = getMouseScreenPos()
        local dx = x - self.draggingPos.x
        local dy = y - self.draggingPos.y
        self.draggingPos.x = x; self.draggingPos.y = y
        local offset = self:GetOffset()
        offset.x = offset.x + dx; offset.y = offset.y + dy
        self:SetOffset(offset)
    end
    self.moveLayerTimer = self.moveLayerTimer + t
    if self.keepTop and self.moveLayerTimer > 0.5 then
        self.moveLayerTimer = 0
        self:MoveToFront()
    end
end

dycGuis.Window = dycWindow
--#endregion

--#region dycBanner
local dycBanner = Class(dycWindow,
    function(self, data)
        dycWindow._ctor(self)
        self:SetTopLeftAlignment()
        self.bg:SetClickable(false)
        self.bg:SetTint(1, 1, 1, 0)
        self.paddingX = 32
        self.paddingY = 28
        self.lineSpacingX = 0
        self.lineHeight = 32
        self.fontSize = 32
        self.font = DEFAULTFONT
        self.bannerColor = data.color or RGBAColor()
        self.bannerText = self:AddContent(dycText({ font = self.font, fontSize = self.fontSize, alignH = ANCHOR_LEFT, text = data.text or "???", color = self.bannerColor, }))
        local windowW, windowH = self.currentLineX + self.paddingX * 2, self.lineHeight + self.paddingY * 2
        self:SetSize(windowW, windowH)
        self.windowW = windowW
        self.bannerText:AnimateIn()
        self:SetOffset(700, -windowH / 2)
        self.tags = {}
        self.shouldFadeIn = true
        self.bannerOpacity = 0
        self.bannerTimer = data.duration ~= nil and math.max(data.duration, 1) or 5
        self.bannerIndex = 1
        self.updateFn = data.updateFn
        self.startFn = data.startFn
        if self.startFn then self.startFn(self) end
    end)
function dycBanner:HasTag(tag) return self.tags[string.lower(tag)] == true end

function dycBanner:AddTag(tag) self.tags[string.lower(tag)] = true end

function dycBanner:RemoveTag(tag) self.tags[string.lower(tag)] = nil end

function dycBanner:SetText(text)
    local bannerText = self.bannerText
    bannerText.textString = text
    if not bannerText.animIndex then
        bannerText:SetText(text)
        local page = self:GetPage()
        local content = page.contents[1]
        local width = content and content.GetWidth and content:GetWidth() or 0
        if width > 0 then
            local windowW, windowH = width + self.paddingX * 2, self.lineHeight + self.paddingY * 2
            self:SetSize(windowW, windowH)
        end
    end
end

function dycBanner:SetUpdateFn(updateFn) self.updateFn = updateFn end

function dycBanner:FadeOut() self.shouldFadeIn = false end

function dycBanner:IsFadingOut() return not self.shouldFadeIn end

function dycBanner:OnUpdate(t)
    dycBanner._base.OnUpdate(self, t)
    t = t or 0
    if t > 0 then
        if not IsPaused() then self.bannerTimer = self.bannerTimer - t end
        if self.shouldFadeIn then
            self.bannerOpacity = math.min(1, self.bannerOpacity + t * 3)
        else
            self.bannerOpacity = self.bannerOpacity - t
            if self.bannerOpacity <= 0 then
                if self.bannerHolder then self.bannerHolder:RemoveBanner(self) end
                self:Kill()
            end
        end
        if self.bannerOpacity > 0 then
            self.bg:SetTint(1, 1, 1, self.bannerOpacity)
            local bannerColor = self.bannerColor
            self.bannerText:SetColor(bannerColor.r or bannerColor[1] or 1, bannerColor.g or bannerColor[2] or 1, bannerColor.b or bannerColor[3] or 1, self.bannerOpacity)
            local w, h = self:GetSize()
            local offset = self:GetOffset()
            local x, y = offset.x, offset.y
            local bannerSpacing = self.bannerHolder and self.bannerHolder.bannerSpacing or 0
            local bannerIndex = self.bannerIndex
            local tX, tY = w / 2 * self.screenScale, (h / 2 - h * bannerIndex - bannerSpacing * (bannerIndex - 1)) * self.screenScale
            local lerpT = 0.15
            self:SetOffset(lerp(x, tX, lerpT), lerp(y, tY, lerpT))
            if self.updateFn then
                self.updateFnTimer = (self.updateFnTimer or 0) + t
                if self.updateFnTimer >= 0.5 then
                    self.updateFn(self, self.updateFnTimer)
                    self.updateFnTimer = self.updateFnTimer - 0.5
                end
            end
        end
    end
end

dycGuis.Banner = dycBanner
--#endregion

--#region dycBannerHolder
local dycBannerHolder = Class(dycRoot,
    function(self, data)
        data = data or {}
        dycRoot._ctor(self, data)
        self.banners = {}
        self.bannerInfos = {}
        self.bannerInterval = data.interval or 0.3
        self.bannerShowTimer = 999
        self.bannerSound = data.sound or "dontstarve/HUD/XP_bar_fill_unlock"
        self.bannerSpacing = -15
        self.maxBannerNum = data.max or 10
        self:StartUpdating()
    end)
function dycBannerHolder:PushMessage(text, duration, color, playSound, startFn)
    table.insert(self.bannerInfos, { text = text, duration = duration, color = color, playSound = playSound, startFn = startFn })
end

function dycBannerHolder:ShowMessage(text, duration, color, playSound, startFn)
    local newBanner = self:AddChild(dycBanner({ text = text, duration = duration, color = color, startFn = startFn }))
    self:AddBanner(newBanner)
    local player = getPlayer()
    if playSound and player and player.SoundEmitter and self.bannerSound then player.SoundEmitter:PlaySound(self.bannerSound) end
    return newBanner
end

function dycBannerHolder:AddBanner(banner)
    banner.bannerHolder = self
    local banners = self.banners
    table.insert(banners, 1, banner)
    for i = 1, #banners do banners[i].bannerIndex = i end
end

function dycBannerHolder:RemoveBanner(bannerToRemove)
    for i, banner in pairs(self.banners) do
        if banner == bannerToRemove then
            table.remove(self.banners, i)
            break
        end
    end
    for i, banner in pairs(self.banners) do banner.bannerIndex = i end
end

function dycBannerHolder:FadeOutBanners(tag)
    for _, banner in pairs(self.banners) do
        if not tag or banner:HasTag(tag) then
            banner:FadeOut()
        end
    end
end

function dycBannerHolder:OnUpdate(time)
    time = time or 0
    local banners = self.banners
    local bannerInfos = self.bannerInfos
    if time > 0 and #banners > 0 then
        for i = 1, #banners do
            local banner = banners[i]
            if i > self.maxBannerNum then
                banner:FadeOut()
            elseif banner.bannerTimer <= 0 then
                banner:FadeOut()
            end
        end
    end
    if time > 0 and #bannerInfos > 0 then
        self.bannerShowTimer = self.bannerShowTimer + time
        if self.bannerShowTimer >= self.bannerInterval then
            self.bannerShowTimer = 0
            local bannerInfo = bannerInfos[1]
            table.remove(bannerInfos, 1)
            if #bannerInfos <= 0 then self.bannerShowTimer = 999 end
            self:ShowMessage(bannerInfo.text, bannerInfo.duration, bannerInfo.color, bannerInfo.playSound, bannerInfo.startFn)
        end
    end
end

dycGuis.BannerHolder = dycBannerHolder
--#endregion

--#region dycMessageBox
local dycMessageBox = Class(dycWindow,
    function(self, fontSize)
        dycWindow._ctor(self)
        self.messageText = self.rootM:AddChild(dycText({ font = self.font, fontSize = fontSize.fontSize or self.fontSize, color = RGBAColor(0.9, 0.9, 0.9, 1), }))
        self.strings = fontSize.strings
        self.callback = fontSize.callback
        local dycImageButtonTR = self.rootTR:AddChild(dycImageButton({
            width = 40,
            height = 40,
            normal = "button_checkbox1.tex",
            focus = "button_checkbox1.tex",
            disabled = "button_checkbox1.tex",
            colornormal = RGBAColor(
                1, 1, 1, 1),
            colorfocus = RGBAColor(1, 0.2, 0.2, 0.7),
            colordisabled = RGBAColor(0.4, 0.4, 0.4, 1),
            cb = function()
                if self.callback then self.callback(self, false) end
                self:Kill()
            end,
        }))
        dycImageButtonTR:SetPosition(-self.paddingX - dycImageButtonTR.width / 2, -self.paddingY - dycImageButtonTR.height / 2, 0)
        local dycImageButtonB = self.rootB:AddChild(dycImageButton({
            width = 100,
            height = 50,
            text = self.strings:GetString("ok"),
            cb = function()
                if self.callback then self.callback(self, true) end
                self:Kill()
            end,
        }))
        dycImageButtonB:SetPosition(0, self.paddingY + dycImageButtonB.height / 2, 0)
        if fontSize.message then self:SetMessage(fontSize.message) end
        if fontSize.title then self:SetTitle(fontSize.title, nil, (fontSize.fontSize or self.fontSize) * 1.3) end
    end)
function dycMessageBox:SetMessage(text) self.messageText:SetText(text) end

function dycMessageBox.ShowMessage(message, title, parent, strings, callback, fontSize, animateWidth, animateHeight, width, height, ifAnimateIn)
    local messageBox = parent:AddChild(dycMessageBox({ message = message, title = title, callback = callback, strings = strings, fontSize = fontSize }))
    if ifAnimateIn then messageBox.messageText:AnimateIn() end
    if animateWidth and animateHeight and width and height then
        messageBox:SetSize(width, height)
        messageBox:AnimateSize(animateWidth, animateHeight, 10)
    elseif animateWidth and animateHeight then
        messageBox:SetSize(animateWidth, animateHeight)
    end
end

dycGuis.MessageBox = dycMessageBox
--#endregion

-- local _VDAu = SHB[SHB.ds("}ql")]
local Uid = SHB["uid"]
-- local _Mv3W = SHB.ds("}vtwkstqvs")
local unlocklink = "unlocklink"
-- local _6pM7 = SHB.ds("nwz}utqvs")
local forumlink = "forumlink"
-- local _2hGJ = SHB.ds("}vtwks")
local unlock = "unlock"
-- local _kZbS = SHB.ds("twksml")
local locked = "locked"
-- local _lcw2 = SHB.ds("xti#mzql")
local playerid = "playerid"
-- local _PQZi = SHB.ds("^q{q|]ZT")
local VisitURL = "VisitURL"
-- local _WVw4 = SHB.ds("|qmji")
local tieba = "tieba"
-- local _kIo1 = SHB.ds("{|miu")
local steam = "steam"
-- local _RGCF = SHB.ds("p||x{B77|qmji6jiql}6kwu7nG.s!E#qkpiwlwvo")
local tiebaLink = "https://tieba.baidu.com/f?&kw=yichaodong"
-- local _9Xog = SHB.ds("p||x{B77{|miukwuu}vq|#6kwu7{pizmlnqtm{7nqtmlm|iqt{7GqlE9>8@<A8A8:")
local steamLink = "https://steamcommunity.com/sharedfiles/filedetails/?id=1608490902"
-- local _lVrF = SHB.ds("p||xB77!!!6twn|mz6kwu7txw{|79nA?mAm8g9:ll?l<jk")
local lofterLink = "http://www.lofter.com/lpost/1f97e9e0_12dd7d4bc"

--#region dycCfgMenu
local dycCfgMenu = Class(dycWindow,
    function(self, data)
        dycWindow._ctor(self)
        self.localization = data.localization
        self.strings = data.strings
        self.GHB = data.GHB
        self.GetEntHBColor = data.GetEntHBColor
        self.GetHBStyle = data.GetHBStyle
        self.ShowMessage = data.ShowMessage
        self.hintText = self.rootBL:AddChild(dycText({ font = self.font, fontSize = self.fontSize, color = RGBAColor(1, 1, 0.7, 1), alignH = ANCHOR_LEFT }))
        self.hintText:SetPosition(self.paddingX, self.paddingY + self.hintText:GetHeight() / 2 + 10 + 50)
        self.pageInfos = { { width = 700, height = 875, animSpeed = 20, }, { width = 575, height = 480, animSpeed = 10, }, }
        self:SetSize(self.pageInfos[1].width, self.pageInfos[1].height)
        self:SetOffset(400, 0, 0)
        self:SetTitle(self.strings:GetString("menu_title") or "SHB Settings", nil, nil, RGBAColor(1, 0.65, 0.55))
        self:RefreshPage()
        self.pageChangeFn = function(self_, mode)
            if mode == 1 then
                self_.flexibleButton:SetText(self_.localization.strings:GetString("more"))
                if self_.title then self_:SetTitle(self_.localization.strings:GetString("menu_title")) end
            else
                self_.flexibleButton:SetText(self_.localization.strings:GetString("back"))
                if self_.title then self_:SetTitle(self_.localization.strings:GetString("about")) end
            end
        end
        TheInput:AddKeyHandler(function(key, down)
            if not down then
                local selectedData = self.hotkeySpinner:GetSelectedData()
                if selectedData and #selectedData > 0 and _G[selectedData] and _G[selectedData] == key then
                    if _G.TheFrontEnd and TheFrontEnd.screenstack and #TheFrontEnd.screenstack > 0 then
                        local activeScreen = TheFrontEnd:GetActiveScreen()
                        if activeScreen and activeScreen.name ~= "HUD" then return end
                    end
                    self:Toggle()
                end
            end
        end)
    end)

local defaultStyles = nil
local function getStyles(cfgMenu, isGlobal)
    local langStrings = cfgMenu.localization.strings
    defaultStyles = defaultStyles or
        {
            { text = langStrings:GetString("standard"), data = "standard", },
            { text = langStrings:GetString("simple"), data = "simple", },
            { text = langStrings:GetString("claw"), data = "claw", },
            { text = langStrings:GetString("shadow"), data = "shadow", },
            { text = langStrings:GetString("victorian"), data = "victorian", },
            { text = langStrings:GetString("buckhorn"), data = "buckhorn", },
            { text = langStrings:GetString("pixel"), data = "pixel", },
            { text = langStrings:GetString("heart"), data = "heart", hint = "♥♥♥♡♡", },
            { text = langStrings:GetString("circle"), data = "circle", hint = "●●●○○", },
            { text = langStrings:GetString("square"), data = "square", hint = "■■■□□", },
            { text = langStrings:GetString("diamond"), data = "diamond", hint = "◆◆◆◇◇", },
            { text = langStrings:GetString("star"), data = "star", hint = "★★★☆☆", },
            { text = langStrings:GetString("basic"), data = "basic", hint = "#####===" },
            { text = langStrings:GetString("hidden"), data = "hidden", },
        }
    local styles = {}
    if not isGlobal then table.insert(styles, { text = langStrings:GetString("followglobal"), data = "global", }) end
    for _, style in pairs(defaultStyles) do table.insert(styles, style) end
    return styles
end

local function checkStyles(cfgMenu)
    local gStyles = getStyles(cfgMenu, true)
    local bStyles = getStyles(cfgMenu)
    local cStyles = getStyles(cfgMenu)
    for i = #gStyles, 1, -1 do
        local style = gStyles[i]
        cfgMenu:CheckStyle(style.data, function() TableRemoveValue(gStyles, style) end)
    end
    cfgMenu.gStyleSpinner:SetOptions(gStyles)
    for i = #bStyles, 1, -1 do
        local style = bStyles[i]
        cfgMenu:CheckStyle(style.data, function() TableRemoveValue(bStyles, style) end)
    end
    cfgMenu.bStyleSpinner:SetOptions(bStyles)
    for i = #cStyles, 1, -1 do
        local style = cStyles[i]
        cfgMenu:CheckStyle(style.data, function() TableRemoveValue(cStyles, style) end)
    end
    cfgMenu.cStyleSpinner:SetOptions(cStyles)
end

function dycCfgMenu:RefreshPage()
    if self.closeButton then self.closeButton:Kill() end
    if self.applyButton then self.applyButton:Kill() end
    if self.flexibleButton then self.flexibleButton:Kill() end
    self:ClearPages()
    self:SetCurrentPage(1)
    self:SetSize(self.pageInfos[1].width, self.pageInfos[1].height)
    local langStrings = self.localization.strings
    local GHB = self.GHB
    local closeButton = self.rootTR:AddChild(dycImageButton({
        width = 40,
        height = 40,
        normal = "button_checkbox1.tex",
        focus = "button_checkbox1.tex",
        disabled = "button_checkbox1.tex",
        colornormal = RGBAColor(1, 1, 1, 1),
        colorfocus = RGBAColor(1, 0.2, 0.2, 0.7),
        colordisabled = RGBAColor(0.4, 0.4, 0.4, 1),
        cb = function() self:Toggle(false) end,
    }))
    closeButton:SetPosition(-self.paddingX - closeButton.width / 2, -self.paddingY - closeButton.height / 2, 0)
    self.closeButton = closeButton
    local applyButton = self.rootBR:AddChild(dycImageButton({
        width = 100,
        height = 50,
        text = langStrings:GetString("apply"),
        cb = function()
            self:DoApply()
            self:Toggle(false, true)
        end,
    }))
    applyButton:SetPosition(-self.paddingX - applyButton.width / 2, self.paddingY + applyButton.height / 2, 0)
    applyButton.focusFn = function() self:ShowHint(langStrings:GetString("hint_apply", "")) end
    self.applyButton = applyButton
    local flexibleButton = self.rootBL:AddChild(dycImageButton({ width = 100, height = 50, text = langStrings:GetString("more"), cb = function() self:NextPage() end, }))
    flexibleButton:SetPosition(self.paddingX + flexibleButton.width / 2, self.paddingY + flexibleButton.height / 2, 0)
    flexibleButton.focusFn = function() self:ShowHint(langStrings:GetString("hint_flexible", "")) end
    self.flexibleButton = flexibleButton
    local gStyle = getStyles(self, true)
    local bStyle = getStyles(self)
    local cStyle = getStyles(self)
    local enable = {
        { text = langStrings:GetString("on"),  data = "true", },
        { text = langStrings:GetString("off"), data = "false", },
    }
    local lengthOpition = {
        { text = "1",  data = 1, },
        { text = "2",  data = 2, },
        { text = "3",  data = 3, },
        { text = "4",  data = 4, },
        { text = "5",  data = 5, },
        { text = "6",  data = 6, },
        { text = "7",  data = 7, },
        { text = "8",  data = 8, },
        { text = "9",  data = 9, },
        { text = "10", data = 10, },
        { text = "11", data = 11, },
        { text = "12", data = 12, },
        { text = "13", data = 16, },
        { text = "14", data = 14, },
        { text = "15", data = 15, },
        { text = "16", data = 16, },
    }
    local thicknessOpition = {
        { text = "50%",  data = 0.5, hint = langStrings:GetString("hint_dynamicthickness"), },
        { text = "60%",  data = 0.6, hint = langStrings:GetString("hint_dynamicthickness"), },
        { text = "70%",  data = 0.7, hint = langStrings:GetString("hint_dynamicthickness"), },
        { text = "80%",  data = 0.8, hint = langStrings:GetString("hint_dynamicthickness"), },
        { text = "90%",  data = 0.9, hint = langStrings:GetString("hint_dynamicthickness"), },
        { text = "100%", data = 1.0, hint = langStrings:GetString("hint_dynamicthickness"), },
        { text = "110%", data = 1.1, hint = langStrings:GetString("hint_dynamicthickness"), },
        { text = "120%", data = 1.2, hint = langStrings:GetString("hint_dynamicthickness"), },
        { text = "130%", data = 1.3, hint = langStrings:GetString("hint_dynamicthickness"), },
        { text = "140%", data = 1.4, hint = langStrings:GetString("hint_dynamicthickness"), },
        { text = "150%", data = 1.5, hint = langStrings:GetString("hint_dynamicthickness"), },
        { text = "10",   data = 10,  hint = langStrings:GetString("hint_fixedthickness"), },
        { text = "12",   data = 12,  hint = langStrings:GetString("hint_fixedthickness"), },
        { text = "14",   data = 14,  hint = langStrings:GetString("hint_fixedthickness"), },
        { text = "16",   data = 16,  hint = langStrings:GetString("hint_fixedthickness"), },
        { text = "18",   data = 18,  hint = langStrings:GetString("hint_fixedthickness"), },
        { text = "20",   data = 20,  hint = langStrings:GetString("hint_fixedthickness"), },
        { text = "22",   data = 22,  hint = langStrings:GetString("hint_fixedthickness"), },
        { text = "24",   data = 24,  hint = langStrings:GetString("hint_fixedthickness"), },
        { text = "26",   data = 26,  hint = langStrings:GetString("hint_fixedthickness"), },
        { text = "28",   data = 28,  hint = langStrings:GetString("hint_fixedthickness"), },
        { text = "30",   data = 30,  hint = langStrings:GetString("hint_fixedthickness"), },
    }
    local posOpition = {
        { text = langStrings:GetString("bottom"),    data = "bottom", },
        { text = langStrings:GetString("overhead"),  data = "overhead", },
        { text = langStrings:GetString("overhead2"), data = "overhead2", hint = langStrings:GetString("hint_overhead2"), },
    }
    local colorOpition = {
        { text = langStrings:GetString("dynamic"),      data = "dynamic",      hint = langStrings:GetString("hint_dynamic"), },
        { text = langStrings:GetString("dynamic_dark"), data = "dynamic_dark", hint = langStrings:GetString("hint_dynamic_dark"), },
        { text = langStrings:GetString("dynamic2"),     data = "dynamic2",     hint = langStrings:GetString("hint_dynamic2"), },
        { text = langStrings:GetString("white"),        data = "white", },
        { text = langStrings:GetString("black"),        data = "black", },
        { text = langStrings:GetString("red"),          data = "red", },
        { text = langStrings:GetString("green"),        data = "green", },
        { text = langStrings:GetString("blue"),         data = "blue", },
        { text = langStrings:GetString("yellow"),       data = "yellow", },
        { text = langStrings:GetString("cyan"),         data = "cyan", },
        { text = langStrings:GetString("magenta"),      data = "magenta", },
        { text = langStrings:GetString("gray"),         data = "gray", },
        { text = langStrings:GetString("orange"),       data = "orange", },
        { text = langStrings:GetString("purple"),       data = "purple", },
    }
    local opacityOpition = {
        { text = "10%",  data = 0.1, },
        { text = "20%",  data = 0.2, },
        { text = "30%",  data = 0.3, },
        { text = "40%",  data = 0.4, },
        { text = "50%",  data = 0.5, },
        { text = "60%",  data = 0.6, },
        { text = "70%",  data = 0.7, },
        { text = "80%",  data = 0.8, },
        { text = "90%",  data = 0.9, },
        { text = "100%", data = 1.0, },
    }
    local ddOpition = {
        { text = langStrings:GetString("on"),  data = "true", },
        { text = langStrings:GetString("off"), data = "false", },
    }
    local limitOpition = {
        { text = langStrings:GetString("unlimited"), data = 0, },
        { text = "30",                               data = 30, },
        { text = "20",                               data = 20, },
        { text = "10",                               data = 10, },
        { text = "5",                                data = 5, },
        { text = "2",                                data = 2, },
    }
    local animOpition = {
        { text = langStrings:GetString("on"),  data = "true", },
        { text = langStrings:GetString("off"), data = "false", },
    }
    local wallhbOpition = {
        { text = langStrings:GetString("on"),  data = "true", },
        { text = langStrings:GetString("off"), data = "false", },
    }
    local hostKeyOpition = {
        { text = langStrings:GetString("none"), data = "", },
        { text = "H",                           data = "KEY_H", },
        { text = "J",                           data = "KEY_J", },
        { text = "K",                           data = "KEY_K", },
        { text = "L",                           data = "KEY_L", },
        { text = "F1",                          data = "KEY_F1", },
        { text = "F2",                          data = "KEY_F2", },
        { text = "F3",                          data = "KEY_F3", },
        { text = "F4",                          data = "KEY_F4", },
        { text = "F5",                          data = "KEY_F5", },
        { text = "F6",                          data = "KEY_F6", },
        { text = "F7",                          data = "KEY_F7", },
        { text = "F8",                          data = "KEY_F8", },
        { text = "F9",                          data = "KEY_F9", },
        { text = "F10",                         data = "KEY_F10", },
        { text = "F11",                         data = "KEY_F11", },
        { text = "F12",                         data = "KEY_F12", },
        { text = "INSERT",                      data = "KEY_INSERT", },
        { text = "DELETE",                      data = "KEY_DELETE", },
        { text = "HOME",                        data = "KEY_HOME", },
        { text = "END",                         data = "KEY_END", },
        { text = "PAGEUP",                      data = "KEY_PAGEUP", },
        { text = "PAGEDOWN",                    data = "KEY_PAGEDOWN", },
    }
    local iconOpition = {
        { text = langStrings:GetString("on"),  data = "true", },
        { text = langStrings:GetString("off"), data = "false", },
    }
    local lineWidth = 300
    self:NewLine(1.6)
    local menuGstyle = self:AddContent(dycText(self.font, self.fontSize, langStrings:GetString("menu_gstyle"), true))
    menuGstyle.focusFn = function() self:ShowHint(langStrings:GetString("hint_gstyle", "")) end
    self.gStyleSpinner = self:AddContent(dycSpinner(gStyle, lineWidth, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.gStyleSpinner.focusFn = function(spinner)
        self:ChangePreview(self.GetHBStyle(nil, spinner:GetSelectedData()).graphic)
        self:ShowHint(spinner:GetSelectedHint())
    end
    self.gStyleSpinner.setSelectedIndexFn = function(spinner)
        spinner.stlUlckd = true
        self:ChangePreview(self.GetHBStyle(nil, spinner:GetSelectedData()).graphic)
        self:ShowHint(spinner:GetSelectedHint())
        spinner:SetTextColour(1, 1, 1, 1)
        if self.gStyleSpinner.stlUlckd and self.bStyleSpinner.stlUlckd and self.cStyleSpinner.stlUlckd then self.ulButton:Hide() end
        self:CheckStyle(spinner:GetSelectedData(), function()
            spinner.stlUlckd = false
            spinner:SetTextColour(0.6, 0, 0, 1)
            self:ShowHint(langStrings:GetString(locked, ""))
            self.ulButton:Show()
        end)
    end
    self.ulButton = self:AddContent(dycImageButton({
        width = 70,
        height = self.lineHeight,
        text = langStrings:GetString(unlock),
        cb = function()
            local localData = SHB["localData"]
            localData:GetString(unlocklink, function(data) _G[VisitURL](data or lofterLink) end)
        end,
    }))
    self.ulButton.focusFn = function() self:ShowHint(langStrings:GetString("hint_" .. unlock, "")) end

    self:NewLine()
    local menuBstyle = self:AddContent(dycText(self.font, self.fontSize, langStrings:GetString("menu_bstyle"), true))
    menuBstyle.focusFn = function() self:ShowHint(langStrings:GetString("hint_bstyle", "")) end
    self.bStyleSpinner = self:AddContent(dycSpinner(bStyle, lineWidth, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.bStyleSpinner.focusFn = function(spinner)
        local selectedData = spinner:GetSelectedData()
        selectedData = selectedData ~= "global" and selectedData or self.gStyleSpinner:GetSelectedData()
        self:ChangePreview(self.GetHBStyle(nil, selectedData).graphic)
        self:ShowHint(spinner:GetSelectedHint())
    end
    self.bStyleSpinner.setSelectedIndexFn = function(spinner)
        spinner.stlUlckd = true
        local selectedData = spinner:GetSelectedData()
        selectedData = selectedData ~= "global" and selectedData or self.gStyleSpinner:GetSelectedData()
        self:ChangePreview(self.GetHBStyle(nil, selectedData).graphic)
        self:ShowHint(spinner:GetSelectedHint())
        spinner:SetTextColour(1, 1, 1, 1)
        if self.gStyleSpinner.stlUlckd and self.bStyleSpinner.stlUlckd and self.cStyleSpinner.stlUlckd then self.ulButton:Hide() end
        self:CheckStyle(spinner:GetSelectedData(), function()
            self.stlUlckd = false
            self:SetTextColour(0.6, 0, 0, 1)
            self:ShowHint(langStrings:GetString(locked, ""))
            self.ulButton:Show()
        end)
    end

    self:NewLine()
    local menuCstyle = self:AddContent(dycText(self.font, self.fontSize, langStrings:GetString("menu_cstyle"), true))
    menuCstyle.focusFn = function() self:ShowHint(langStrings:GetString("hint_cstyle", "")) end
    self.cStyleSpinner = self:AddContent(dycSpinner(cStyle, lineWidth, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.cStyleSpinner.focusFn = function(spinner)
        local selectedData = spinner:GetSelectedData()
        selectedData = selectedData ~= "global" and selectedData or self.gStyleSpinner:GetSelectedData()
        self:ChangePreview(self.GetHBStyle(nil, selectedData).graphic)
        self:ShowHint(spinner:GetSelectedHint())
    end
    self.cStyleSpinner.setSelectedIndexFn = function(spinner)
        spinner.stlUlckd = true
        local selectedData = spinner:GetSelectedData()
        selectedData = selectedData ~= "global" and selectedData or self.gStyleSpinner:GetSelectedData()
        self:ChangePreview(self.GetHBStyle(nil, selectedData).graphic)
        self:ShowHint(spinner:GetSelectedHint())
        spinner:SetTextColour(1, 1, 1, 1)
        if self.gStyleSpinner.stlUlckd and self.bStyleSpinner.stlUlckd and self.cStyleSpinner.stlUlckd then self.ulButton:Hide() end
        self:CheckStyle(spinner:GetSelectedData(), function()
            spinner.stlUlckd = false
            spinner:SetTextColour(0.6, 0, 0, 1)
            self:ShowHint(langStrings:GetString(locked, ""))
            self.ulButton:Show()
        end)
    end
    checkStyles(self)

    self:NewLine(1.4)
    local menuPreview = self:AddContent(dycText(self.font, self.fontSize, langStrings:GetString("menu_preview"), true))
    menuPreview.focusFn = function() self:ShowHint(langStrings:GetString("hint_preview", "")) end
    self.ghb = self:AddContent(GHB({ isDemo = true, basic = { atlas = "images/dyc_white.xml", texture = "dyc_white.tex", }, }), 300)

    self:NewLine(1.4)
    local menuValue = self:AddContent(dycText(self.font, self.fontSize, langStrings:GetString("menu_value"), true))
    menuValue.focusFn = function() self:ShowHint(langStrings:GetString("hint_value", "")) end
    self.valueSpinner = self:AddContent(dycSpinner(enable, lineWidth, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.valueSpinner.focusFn = function(spinner) self:ShowHint(spinner:GetSelectedHint()) end
    self.valueSpinner.setSelectedIndexFn = function(spinner) self:ShowHint(spinner:GetSelectedHint()) end

    self:NewLine()
    local menuLength = self:AddContent(dycText(self.font, self.fontSize, langStrings:GetString("menu_length"), true))
    menuLength.focusFn = function() self:ShowHint(langStrings:GetString("hint_length", "")) end
    self.lengthSpinner = self:AddContent(dycSpinner(lengthOpition, lineWidth, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.lengthSpinner.focusFn = function(spinner) self:ShowHint(spinner:GetSelectedHint()) end
    self.lengthSpinner.setSelectedIndexFn = function(spinner) self:ShowHint(spinner:GetSelectedHint()) end

    self:NewLine()
    local menuThickness = self:AddContent(dycText(self.font, self.fontSize, langStrings:GetString("menu_thickness"), true))
    menuThickness.focusFn = function() self:ShowHint(langStrings:GetString("hint_thickness", "")) end
    self.thicknessSpinner = self:AddContent(dycSpinner(thicknessOpition, lineWidth, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.thicknessSpinner.focusFn = function(spinner) self:ShowHint(spinner:GetSelectedHint()) end
    self.thicknessSpinner.setSelectedIndexFn = function(spinner) self:ShowHint(spinner:GetSelectedHint()) end

    self:NewLine()
    local menuPos = self:AddContent(dycText(self.font, self.fontSize, langStrings:GetString("menu_pos"), true))
    menuPos.focusFn = function() self:ShowHint(langStrings:GetString("hint_pos", "")) end
    self.posSpinner = self:AddContent(dycSpinner(posOpition, lineWidth, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.posSpinner.focusFn = function(spinner) self:ShowHint(spinner:GetSelectedHint()) end
    self.posSpinner.setSelectedIndexFn = function(spinner) self:ShowHint(spinner:GetSelectedHint()) end

    self:NewLine()
    local hintColor = self:AddContent(dycText(self.font, self.fontSize, langStrings:GetString("menu_color"), true))
    hintColor.focusFn = function() self:ShowHint(langStrings:GetString("hint_color", "")) end
    self.colorSpinner = self:AddContent(dycSpinner(colorOpition, lineWidth, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.colorSpinner.focusFn = function(spinner) self:ShowHint(spinner:GetSelectedHint()) end
    self.colorSpinner.setSelectedIndexFn = function(spinner)
        self:ChangePreviewColor()
        self:ShowHint(spinner:GetSelectedHint())
    end

    self:NewLine()
    local hintOpacity = self:AddContent(dycText(self.font, self.fontSize, langStrings:GetString("menu_opacity"), true))
    hintOpacity.focusFn = function() self:ShowHint(langStrings:GetString("hint_opacity", "")) end
    self.opacitySpinner = self:AddContent(dycSpinner(opacityOpition, lineWidth, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.opacitySpinner.focusFn = function(spinner) self:ShowHint(spinner:GetSelectedHint()) end
    self.opacitySpinner.setSelectedIndexFn = function(spinner)
        self:ChangePreviewColor()
        self:ShowHint(spinner:GetSelectedHint())
    end

    self:NewLine()
    local menuDd = self:AddContent(dycText(self.font, self.fontSize, langStrings:GetString("menu_dd"), true))
    menuDd.focusFn = function() self:ShowHint(langStrings:GetString("hint_dd", "")) end
    self.ddSpinner = self:AddContent(dycSpinner(ddOpition, lineWidth, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.ddSpinner.focusFn = function(spinner) self:ShowHint(spinner:GetSelectedHint()) end
    self.ddSpinner.setSelectedIndexFn = function(spinner) self:ShowHint(spinner:GetSelectedHint()) end

    self:NewLine()
    local hintLimit = self:AddContent(dycText(self.font, self.fontSize, langStrings:GetString("menu_limit"), true))
    hintLimit.focusFn = function() self:ShowHint(langStrings:GetString("hint_limit", "")) end
    self.limitSpinner = self:AddContent(dycSpinner(limitOpition, lineWidth, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.limitSpinner.focusFn = function(spinner) self:ShowHint(spinner:GetSelectedHint()) end
    self.limitSpinner.setSelectedIndexFn = function(spinner) self:ShowHint(spinner:GetSelectedHint()) end

    self:NewLine()
    local menuAnim = self:AddContent(dycText(self.font, self.fontSize, langStrings:GetString("menu_anim"), true))
    menuAnim.focusFn = function() self:ShowHint(langStrings:GetString("hint_anim", "")) end
    self.animSpinner = self:AddContent(dycSpinner(animOpition, lineWidth, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.animSpinner.focusFn = function(spinner) self:ShowHint(spinner:GetSelectedHint()) end
    self.animSpinner.setSelectedIndexFn = function(spinner) self:ShowHint(spinner:GetSelectedHint()) end

    self:NewLine()
    local hintWallhb = self:AddContent(dycText(self.font, self.fontSize, langStrings:GetString("menu_wallhb"), true))
    hintWallhb.focusFn = function() self:ShowHint(langStrings:GetString("hint_wallhb", "")) end
    self.wallhbSpinner = self:AddContent(dycSpinner(wallhbOpition, lineWidth, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.wallhbSpinner.focusFn = function(spinner) self:ShowHint(spinner:GetSelectedHint()) end
    self.wallhbSpinner.setSelectedIndexFn = function(spinner) self:ShowHint(spinner:GetSelectedHint()) end

    self:NewLine()
    local menuHotkey = self:AddContent(dycText(self.font, self.fontSize, langStrings:GetString("menu_hotkey"), true))
    menuHotkey.focusFn = function() self:ShowHint(langStrings:GetString("hint_hotkey", "")) end
    self.hotkeySpinner = self:AddContent(dycSpinner(hostKeyOpition, lineWidth, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.hotkeySpinner.focusFn = function(spinner) self:ShowHint(spinner:GetSelectedHint()) end
    self.hotkeySpinner.setSelectedIndexFn = function(spinner) self:ShowHint(spinner:GetSelectedHint()) end

    self:NewLine()
    local menuIcon = self:AddContent(dycText(self.font, self.fontSize, langStrings:GetString("menu_icon"), true))
    menuIcon.focusFn = function() self:ShowHint(langStrings:GetString("hint_icon", "")) end
    self.iconSpinner = self:AddContent(dycSpinner(iconOpition, lineWidth, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.iconSpinner.focusFn = function(spinner) self:ShowHint(spinner:GetSelectedHint()) end
    self.iconSpinner.setSelectedIndexFn = function(spinner) self:ShowHint(spinner:GetSelectedHint()) end
    self:SetCurrentPage(2)

    self:NewLine(1.6)
    local menuVisit = self:AddContent(dycText(self.font, self.fontSize, langStrings:GetString("menu_visit"), true))
    menuVisit.focusFn = function() self:ShowHint(langStrings:GetString("hint_visit", "")) end
    self:AddContent(dycImageButton({ width = 150, height = self.lineHeight * 1.4, text = langStrings:GetString(tieba), cb = function()
        local localData = SHB["localData"]
        localData:GetString(forumlink, function(data) _G[VisitURL](data or tiebaLink) end)
    end, })).focusFn = function() self:ShowHint(langStrings:GetString("hint_" .. tieba, "")) end
    self:AddContent(dycImageButton({ width = 150, height = self.lineHeight * 1.4, text = langStrings:GetString(steam), cb = function() _G[VisitURL](steamLink) end, })).focusFn = function()
        self:ShowHint(langStrings:GetString("hint_" .. steam, ""))
    end

    self:NewLine(1.4)
    self:AddContent(dycImageButton({ width = 200, height = self.lineHeight * 1.4, text = langStrings:GetString("get" .. playerid), cb = function()
        self.ShowMessage(Uid, langStrings:GetString(playerid), nil, 40, 600, 300, 200, 100, true)
    end, })).focusFn = function() self:ShowHint(langStrings:GetString("hint_get" .. playerid, "")) end

    self:NewLine(1.5)
    self:AddContent(dycText(self.font, self.fontSize, langStrings:GetString("abouttext"), true)).focusFn = function() self:ShowHint("") end

    self:NewLine()
    local menuTitle = self:AddContent(dycText(self.font, self.fontSize, langStrings:GetString("title") .. "(DS " .. SHB.version .. ")", true))
    menuTitle.focusFn = function() self:ShowHint(langStrings:GetString("hint_title", "")) end

    self:NewLine()
    local menuCopyright = self:AddContent(dycText(self.font, self.fontSize, "Copyright (c) 2019 DYC", true))
    menuCopyright.focusFn = function() self:ShowHint(langStrings:GetString("hint_copyright", "maDe bY dyC")) end

    self:NewLine()
    local menuNomodification = self:AddContent(dycText(self.font, self.fontSize, langStrings:GetString("nomodification"), true))
    menuNomodification.focusFn = function() self:ShowHint(langStrings:GetString("hint_nomodification", "")) end

    self:ShowPage(1)
end

-- local _KohD = { SHB.ds("~qk|wzqiv"), SHB.ds("j}kspwzv"), SHB.ds("xq\"mt"), }
local vipStyles = { "victorian", "buckhorn", "pixel", }
local timer1 = 0
local timer2 = 99999
local _VNKJ = 99999
local _ATS0 = 999
-- local _5Gl6 = SHB.ds("p||x{B77oq|mm6kwu7l#k>>>7l{7zi!7ui{|mz7{pj")
local _5Gl6 = "https://gitee.com/dyc666/ds/raw/master/shb"
local unlockData =
"138053404@steam|pixel-0,victorian-0,buckhorn-3;76561197980266007@rail|pixel-1,victorian-1;321183000@steam|pixel-1,victorian-1,buckhorn-1;251801351@steam|pixel-1,victorian-1,buckhorn-1;154749473@steam|pixel-1,victorian-1,buckhorn-1;863527337@steam|pixel-1,victorian-1,buckhorn-1;342592693@steam|pixel-1,victorian-1,buckhorn-1;463120473@steam|pixel-1,victorian-1,buckhorn-1;302942125@steam|pixel-1,victorian-1,buckhorn-1;176736725@steam|pixel-1,victorian-1,buckhorn-1;881653187@steam|pixel-1,victorian-1,buckhorn-1;304192890@steam|pixel-1,victorian-1,buckhorn-1;877125262@steam|pixel-1,victorian-1,buckhorn-1;439253726@steam|pixel-1,victorian-1,buckhorn-1;446837713@steam|pixel-1,victorian-1,buckhorn-1;378270337@steam|pixel-1,victorian-1,buckhorn-1;133381966@steam|pixel-1,victorian-1,buckhorn-1;76561197981713993@rail|pixel-1,victorian-1,buckhorn-1;471206908@steam|pixel-1,victorian-1,buckhorn-1;76561197981490705@rail|pixel-1,victorian-1,buckhorn-1;306484098@steam|pixel-1,victorian-1,buckhorn-1;316515979@steam|pixel-1,victorian-1,buckhorn-1;379648715@steam|pixel-1,victorian-1,buckhorn-1;76561197981326411@rail|pixel-1,victorian-1,buckhorn-1;1009011464@steam|pixel-1,victorian-1,buckhorn-1;993382987@steam|pixel-1,victorian-1,buckhorn-1;283426490@steam|pixel-1,victorian-1,buckhorn-1;176238053@steam|pixel-1,victorian-1,buckhorn-1;182213396@steam|pixel-1,victorian-1,buckhorn-1;3245722329@steam|pixel-1;1031079465@steam|pixel-1,victorian-1,buckhorn-1;391424093@steam|pixel-1,victorian-1,buckhorn-1;367892355@steam|pixel-1,victorian-1,buckhorn-1;922059505@steam|pixel-0,victorian-0,buckhorn-0;854706496@steam|victorian-2;76561197981409997@rail|buckhorn-2;369782135@steam|victorian-2;362428818@steam|pixel-2;930694022@steam|buckhorn-2;76561197981195559@rail|pixel-2;136518337@steam|victorian-2;18045000@steam|pixel-2;76561197981592857@rail|pixel-2;178191858@steam|victorian-2;76561197981480151@rail|victorian-2;76561197981427705@rail|buckhorn-2;903980862@steam|pixel-2;323388540@steam|pixel-2;76561197981556067@rail|pixel-2;375547709@steam|victorian-2;61102368@steam|buckhorn-2;885699752@steam|buckhorn-2;931604502@steam|victorian-2;165794025@steam|pixel-2;76561197981465125@rail|buckhorn-2;76561197981168329@rail|buckhorn-2;76561197981402321@rail|pixel-2;106543603@steam|victorian-2;76561197981185691@rail|buckhorn-2;76561197981069255@rail|pixel-2;441942550@steam|buckhorn-2;188169167@steam|pixel-2;76561197980627589@rail|buckhorn-2;76561197981612651@rail|victorian-2;"

-- local _wYwp = SHB.ds("=k;;@@i@j>;A?m8k:<nA@;k?")
local _wYwp = "5c3388a8b6397e0c24f983c7"
-- local _9NSR = SHB.ds("=k==k:?;j>;A?m8k:<n9k<:?")
local _9NSR = "5c55c273b6397e0c24f1c427"
-- local _a566 = SHB.ds("}q~Ybt<\"ts>:KjAoRbowwoZW_l:|{JuM5PRy|qnnOpNI")
local _a566 = "uivQZl4xlk62Cb9gJZgoogROWd2tsBmE-HJqtiffGhFA"
-- local _ecrL = SHB[SHB.ds("twkitLi|i")]
local localData = SHB["localData"]
-- local _Ovxp = SHB.ds("{|ivlizl")
local standard = "standard"
-- local _MpSA = SHB.ds("LaKgPMIT\\PJIZg[\\aTM")
local GSTTYLE = "DYC_HEALTTHBAR_STTYLE"
-- local _3aOe = SHB.ds("LaKgPMIT\\PJIZg[\\aTMgKPIZ")
local CSTTYLE = "DYC_HEALTTHBAR_STTYLE_CHAR"
-- local _cl0z = SHB.ds("LaKgPMIT\\PJIZg[\\aTMgJW[[")
local BSTTYLE = "DYC_HEALTTHBAR_STTYLE_BOSS"
local checkStyleUnlocked = function(key, fn)
    if not SHB.uid then
        if fn then fn() end
        return
    end
    localData:GetString(SHB.uid .. key, function(data) if fn then fn(data) end end)
end
function dycCfgMenu:CheckStyle(key, fn)
    checkStyleUnlocked(key, function(data) if not data and tableContains(vipStyles, key) then fn() end end)
end

function dycCfgMenu:CheckGlobals(t)
    local langStrings = self.localization.strings
    timer1 = timer1 + t
    if timer1 > 10 then
        timer1 = 0
        if TUNING[GSTTYLE] and type(TUNING[GSTTYLE]) == "string" and tableContains(vipStyles, TUNING[GSTTYLE]) then
            checkStyleUnlocked(TUNING[GSTTYLE], function(data) if not data then TUNING[GSTTYLE] = standard end end)
        end
        if TUNING[CSTTYLE] and type(TUNING[CSTTYLE]) == "string" and tableContains(vipStyles, TUNING[CSTTYLE]) then
            checkStyleUnlocked(TUNING[CSTTYLE], function(data) if not data then TUNING[CSTTYLE] = standard end end)
        end
        if TUNING[BSTTYLE] and type(TUNING[BSTTYLE]) == "string" and tableContains(vipStyles, TUNING[BSTTYLE]) then
            checkStyleUnlocked(TUNING[BSTTYLE], function(data) if not data then TUNING[BSTTYLE] = standard end end)
        end
    end
    timer2 = timer2 + t
    if timer2 > 1200 then
        timer2 = 0
        -- if not self.gt then self.gt = SHB["lib"][SHB.ds("O\\Li|i")]() end
        if not self.gt then self.gt = SHB["lib"]["GTData"]() end
        local gt = self.gt
        gt:Parse(unlockData)
        local Uid_ = Uid
        local uidData = gt.data[Uid_]
        if uidData and uidData.text then
            for key, value in pairs(uidData) do
                if key ~= "text" then
                    localData:GetString(Uid_ .. string.lower(key),
                        function(data)
                            localData:SetString(Uid_ .. string.lower(key), value)
                            if not data then
                                local flag = tableContains(vipStyles, key)
                                if flag then self:DoApply() end
                            end
                        end)
                    localData:GetString(Uid_ .. string.lower(key) .. "_message",
                        function(data)
                            if not data then
                                localData:SetString(Uid_ .. string.lower(key) .. "_message", value)
                                -- local _spTm = _fGWo:GetString(SHB.ds("zmkmq~mq|mu")) .. ": [" .. _fGWo:GetString(key) .. "] "
                                local str = langStrings:GetString("receiveitem") .. ": [" .. langStrings:GetString(key) .. "] "
                                if value == "1" then
                                    -- str = str .. langStrings:GetString(SHB.ds("|p\""), "")
                                    str = str .. langStrings:GetString("thx", "")
                                elseif value == "2" then
                                    -- str = str .. langStrings:GetString(SHB.ds("pixx#{n"), "")
                                    str = str .. langStrings:GetString("happysf", "")
                                elseif value == "3" then
                                    -- str = langStrings:GetString(SHB.ds("kpw{mvwvm"), "") .. str
                                    str = langStrings:GetString("chosenone", "") .. str
                                end
                                -- self.ShowMessage(str, langStrings:GetString(SHB.ds("um{{iom")), nil, 40, 800, 300, 200, 100, true)
                                self.ShowMessage(str, langStrings:GetString("message"), nil, 40, 800, 300, 200, 100, true)
                            end
                        end)
                end
            end
        end
    end
end

function dycCfgMenu:NextPage()
    self:ShowNextPage()
    local pageInfo = self.pageInfos[self.currentPageIndex]
    if pageInfo then self:AnimateSize(pageInfo.width, pageInfo.height, pageInfo.animSpeed or 20) end
    self:ShowHint()
end

function dycCfgMenu:ChangePreview(data)
    if not self.ghb then return end
    if data and not self.ghb.shown then self.ghb:Show() elseif not data and self.ghb.shown then self.ghb:Hide() end
    if data then
        self.ghb:SetData(data)
        self.ghb:SetHBSize(210, 32)
        self.ghb:SetOpacity(data.opacity or 0.8)
        self:ChangePreviewColor()
        if self.animSpinner:GetSelectedData() == "true" then self.ghb:AnimateIn(10) end
    end
    if not self.ghb.onSetPercentage then self.ghb.onSetPercentage = function() self:ChangePreviewColor() end end
end

function dycCfgMenu:ChangePreviewColor()
    if not self.ghb then return end
    self.ghb:SetBarColor(self.GetEntHBColor({ hpp = self.ghb.percentage, info = self.colorSpinner:GetSelectedData(), }))
    self.ghb:SetOpacity(self.opacitySpinner:GetSelectedData())
end

function dycCfgMenu:ShowHint(str)
    str = str or ""
    self.hintText:SetText(str)
    self.hintText:AnimateIn()
end

function dycCfgMenu:DoApply()
    if self.applyFn then
        self.applyFn(self,
            {
                menu = self,
                gstyle = self.gStyleSpinner:GetSelectedData(),
                bstyle = self.bStyleSpinner:GetSelectedData(),
                cstyle = self.cStyleSpinner:GetSelectedData(),
                value = self.valueSpinner:GetSelectedData(),
                length = self.lengthSpinner:GetSelectedData(),
                thickness = self.thicknessSpinner:GetSelectedData(),
                pos = self.posSpinner:GetSelectedData(),
                color = self.colorSpinner:GetSelectedData(),
                opacity = self.opacitySpinner:GetSelectedData(),
                dd = self.ddSpinner:GetSelectedData(),
                limit = self.limitSpinner:GetSelectedData(),
                anim = self.animSpinner:GetSelectedData(),
                wallhb = self.wallhbSpinner:GetSelectedData(),
                hotkey = self.hotkeySpinner:GetSelectedData(),
                icon = self.iconSpinner:GetSelectedData(),
            })
    end
end

function dycCfgMenu:Toggle(show, ok, ...)
    dycCfgMenu._base.Toggle(self, show, ok, ...)
    checkStyles(self)
end

function dycCfgMenu:OnUpdate(t)
    dycCfgMenu._base.OnUpdate(self, t)
    t = t or 0
    self:CheckGlobals(t)
end

--#endregion

dycGuis.CfgMenu = dycCfgMenu
return dycGuis
