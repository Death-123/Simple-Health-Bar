local _p687 = require "widgets/widget"
local _vKVE = require "widgets/image"
local _kD2a = require "widgets/text"
local _NQZ0 = require "widgets/screen"
local _MRTf = require "widgets/button"
local _Q24p = require "widgets/spinner"
local _OX5t = {}
local function _cvrO() return TheSim:GetGameID() == "DST" end
local function _V4Zt() if _cvrO() then return ThePlayer else return GetPlayer() end end
local function _33o2() if _cvrO() then return TheWorld else return GetWorld() end end
local _iOOp = function()
    local _U2Q5, sh = TheSim:GetScreenSize()
    return _U2Q5 / 0x780
end
local _eS3z = function() return TheSim:GetScreenPos(TheInput:GetWorldPosition():Get()) end
local _ZWzx = function(_cSsI, _PBBZ, _lnpT, _1F6S) return { r = _cSsI or 0x1, g = _PBBZ or 0x1, b = _lnpT or 0x1, a = _1F6S or 0x1, Get = function(_D17c) return _D17c.r, _D17c.g, _D17c.b, _D17c.a end, } end
local _nOFV = function(_hapt, _C2Z8, _EBrk) return _hapt + (_C2Z8 - _hapt) * _EBrk end
local function _LPnR(_mZeG, _N6dI)
    if _N6dI == nil then _N6dI = "%s" end
    local _Vk58 = {}
    local _Zxjx = 0x1
    for _nGBO in string.gmatch(_mZeG, "([^" .. _N6dI .. "]+)") do
        _Vk58[_Zxjx] = _nGBO
        _Zxjx = _Zxjx + 0x1
    end
    return _Vk58
end
local _liws = function(_yqoz, _oWhX)
    for _NpZy, _K9ik in pairs(_yqoz) do if _K9ik == _oWhX then return true end end
    return false
end
local _6QIr = function(_70jh, _s37e) if not _liws(_70jh, _s37e) then table.insert(_70jh, _s37e) end end
local _oIFe = function(_CViw, _SOt9) for _dhuJ, _HUXo in pairs(_CViw) do if _HUXo == _SOt9 then return _dhuJ end end end
local _yrSF = function(_JfvH, _gghv)
    local _YdJf = _oIFe(_JfvH, _gghv)
    if _YdJf then table.remove(_JfvH, _YdJf) end
end
local _UU6Y = Class(_p687, function(_1VBs, _wJoZ)
    _p687._ctor(_1VBs, "DYC_Root")
    _1VBs.keepTop = _wJoZ.keepTop
    _1VBs.moveLayerTimer = 0x0
    if _wJoZ.keepTop then _1VBs:StartUpdating() end
end)
function _UU6Y:OnUpdate(_GKJH)
    _GKJH = _GKJH or 0x0
    self.moveLayerTimer = self.moveLayerTimer + _GKJH
    if self.keepTop and self.moveLayerTimer > 0.5 then
        self.moveLayerTimer = 0x0
        self:MoveToFront()
    end
end

_OX5t.Root = _UU6Y
local _fTP7 = Class(_kD2a,
    function(_0aFw, _AKqL, _G8k9, _IoZW, _Y8xN)
        if _AKqL and type(_AKqL) == "table" then
            local _Zzi9 = _AKqL
            _kD2a._ctor(_0aFw, _Zzi9.font or NUMBERFONT, _Zzi9.fontSize or 0x1e, _Zzi9.text)
            if _Zzi9.color then
                local _0FbG = _Zzi9.color
                _0aFw:SetColor(_0FbG.r or _0FbG[0x1] or 0x1, _0FbG.g or _0FbG[0x2] or 0x1, _0FbG.b or _0FbG[0x3] or 0x1, _0FbG.a or _0FbG[0x4] or 0x1)
            end
            if _Zzi9.regionSize then _0aFw:SetRegionSize(_Zzi9.regionSize.w, _Zzi9.regionSize.h) end
            _0aFw.alignH = _Zzi9.alignH
            _0aFw.alignV = _Zzi9.alignV
            _0aFw.focusFn = _Zzi9.focusFn
            _0aFw.unfocusFn = _Zzi9.unfocusFn
            _0aFw.hittest = _Zzi9.hittest
        else
            _kD2a._ctor(_0aFw, _AKqL or NUMBERFONT, _G8k9 or 0x1e, _IoZW)
            _0aFw.hittest = _Y8xN
            if _IoZW then _0aFw:SetText(_IoZW) end
        end
    end)
function _fTP7:GetImage()
    if not self.image then
        self.image = self:AddChild(_vKVE("images/ui.xml", "button.tex"))
        self.image:MoveToBack()
        self.image:SetTint(0x0, 0x0, 0x0, 0x0)
    end
    return self.image
end

function _fTP7:SetText(_GKpe)
    local _xMpT = self:GetWidth()
    local _pKyq = self:GetHeight()
    local _F0Vy = self:GetPosition()
    self:SetString(_GKpe)
    if self.alignH and self.alignH ~= ANCHOR_MIDDLE then
        local _yorr = self:GetWidth()
        _F0Vy.x = _F0Vy.x + (_yorr - _xMpT) / 0x2 * (self.alignH == ANCHOR_LEFT and 0x1 or -0x1)
    end
    if self.alignV and self.alignV ~= ANCHOR_MIDDLE then
        local _UXTh = self:GetHeight()
        _F0Vy.y = _F0Vy.y + (_UXTh - _pKyq) / 0x2 * (self.alignV == ANCHOR_BOTTOM and 0x1 or -0x1)
    end
    if self.alignH or self.alignV then self:SetPosition(_F0Vy) end
    if self.hittest then self:GetImage():SetSize(self:GetSize()) end
end

function _fTP7:SetColor(...) self:SetColour(...) end

function _fTP7:GetWidth()
    local _wchA, h = self:GetRegionSize()
    _wchA = _wchA < 0x2710 and _wchA or 0x0
    return _wchA
end

function _fTP7:GetHeight()
    local _2FF4, h = self:GetRegionSize()
    h = h < 0x2710 and h or 0x0
    return h
end

function _fTP7:GetSize()
    local _JTe6, h = self:GetRegionSize()
    _JTe6 = _JTe6 < 0x2710 and _JTe6 or 0x0
    h = h < 0x2710 and h or 0x0
    return _JTe6, h
end

function _fTP7:OnGainFocus()
    _fTP7._base.OnGainFocus(self)
    if self.focusFn then self.focusFn(self) end
end

function _fTP7:OnLoseFocus()
    _fTP7._base.OnLoseFocus(self)
    if self.unfocusFn then self.unfocusFn(self) end
end

function _fTP7:AnimateIn(_TfM6)
    self.textString = self.string
    self.animSpeed = _TfM6 or 0x3c
    self.animIndex = 0x0
    self.animTimer = 0x0
    self:SetText("")
    self:StartUpdating()
end

function _fTP7:OnUpdate(_9fHn)
    _9fHn = _9fHn or 0x0
    if _fTP7._base.OnUpdate then _fTP7._base.OnUpdate(self, _9fHn) end
    if _9fHn > 0x0 and self.animIndex and self.textString and #self.textString > 0x0 then
        self.animTimer = self.animTimer + _9fHn
        if self.animTimer > 0x1 / self.animSpeed then
            self.animTimer = 0x0
            self.animIndex = self.animIndex + 0x1
            if self.animIndex > #self.textString then
                self.animIndex = nil
                self:SetText(self.textString)
            else
                local _Kgh8 = string.byte(string.sub(self.textString, self.animIndex, self.animIndex))
                if _Kgh8 and _Kgh8 > 0x7f then self.animIndex = self.animIndex + 0x2 end
                self:SetText(string.sub(self.textString, 0x1, self.animIndex))
            end
        end
    end
end

_OX5t.Text = _fTP7
local _OTLM = Class(_p687,
    function(_oTVT, _0hSu)
        _p687._ctor(_oTVT, "DYC_SlicedImage")
        _oTVT.images = {}
        _oTVT.mode = "slice13"
        _oTVT.texScale = _0hSu.texScale or 0x1
        _oTVT.width = 0x64
        _oTVT.height = 0x64
        _oTVT:SetTextures(_0hSu)
    end)
function _OTLM:__tostring() return string.format("%s (%s)", self.name, self.mode) end

function _OTLM:SetTextures(_EZ1U)
    assert(_EZ1U.mode)
    self.images = {}
    self.mode = _EZ1U.mode
    if self.mode == "slice13" or self.mode == "slice31" then
        local _eDQV = nil
        _eDQV = self:AddChild(_vKVE(_EZ1U.atlas, _EZ1U.texname .. "_1.tex"))
        _eDQV.oriW, _eDQV.oriH = _eDQV:GetSize()
        _eDQV.imgPos = 0x1
        self.images[0x1] = _eDQV
        _eDQV = self:AddChild(_vKVE(_EZ1U.atlas, _EZ1U.texname .. "_2.tex"))
        _eDQV.oriW, _eDQV.oriH = _eDQV:GetSize()
        _eDQV.imgPos = 0x2
        self.images[0x2] = _eDQV
        _eDQV = self:AddChild(_vKVE(_EZ1U.atlas, _EZ1U.texname .. "_3.tex"))
        _eDQV.oriW, _eDQV.oriH = _eDQV:GetSize()
        _eDQV.imgPos = 0x3
        self.images[0x3] = _eDQV
        if self.mode == "slice13" then
            assert(self.images[0x1].oriH == self.images[0x3].oriH, "Height must be equal!")
            assert(self.images[0x1].oriH == self.images[0x2].oriH, "Height must be equal!")
        else
            assert(self.images[0x1].oriW == self.images[0x3].oriW, "Width must be equal!")
            assert(self.images[0x1].oriW == self.images[0x2].oriW, "Width must be equal!")
        end
        return
    elseif self.mode == "slice33" then
        local _VYPs = nil
        for _LvrP = 0x1, 0x3 do
            for _pFHp = 0x1, 0x3 do
                _VYPs = self:AddChild(_vKVE(_EZ1U.atlas, _EZ1U.texname .. "_" .. _LvrP .. _pFHp .. ".tex"))
                _VYPs.oriW, _VYPs.oriH = _VYPs:GetSize()
                _VYPs.imgPos = _LvrP * 0xa + _pFHp
                self.images[_LvrP * 0xa + _pFHp] = _VYPs
                if _LvrP > 0x1 then assert(self.images[_LvrP * 0xa + _pFHp].oriW == self.images[(_LvrP - 0x1) * 0xa + _pFHp].oriW, "Width must be equal!") end
                if _pFHp > 0x1 then assert(self.images[_LvrP * 0xa + _pFHp].oriH == self.images[_LvrP * 0xa + _pFHp - 0x1].oriH, "Height must be equal!") end
            end
        end
        return
    end
    error("Mode not supported!")
    self:SetSize()
end

function _OTLM:SetSize(_4iVi, _43P0)
    _4iVi = _4iVi or self.width
    _43P0 = _43P0 or self.height
    if self.mode == "slice13" then
        local _8vgL = self.images[0x1]
        local _xsBk = self.images[0x2]
        local _nXjg = self.images[0x3]
        local _zwnZ = math.min(self.texScale, math.min(_4iVi / (_8vgL.oriW + _nXjg.oriW), _43P0 / _8vgL.oriH))
        local _esa3 = _8vgL.oriW * _zwnZ
        local _BfDv = _nXjg.oriW * _zwnZ
        local _KDzv = math.max(0x0, _4iVi - _esa3 - _BfDv)
        _8vgL:SetSize(_esa3, _43P0)
        _xsBk:SetSize(_KDzv, _43P0)
        _nXjg:SetSize(_BfDv, _43P0)
        local _dTZl = (_esa3 - _BfDv) / 0x2
        local _Y0XA = -_esa3 / 0x2 - _KDzv / 0x2 + _dTZl
        local _Sd5t = _BfDv / 0x2 + _KDzv / 0x2 + _dTZl
        _8vgL:SetPosition(_Y0XA, 0x0, 0x0)
        _xsBk:SetPosition(_dTZl, 0x0, 0x0)
        _nXjg:SetPosition(_Sd5t, 0x0, 0x0)
        self.width = _esa3 + _KDzv + _BfDv
        self.height = _43P0
    elseif self.mode == "slice31" then
        local _3hCC = self.images[0x1]
        local _wAZI = self.images[0x2]
        local _56dL = self.images[0x3]
        local _2Wy2 = math.min(self.texScale, math.min(_43P0 / (_3hCC.oriH + _56dL.oriH), _4iVi / _3hCC.oriW))
        local _1Ua3 = _3hCC.oriH * _2Wy2
        local _2ghD = _56dL.oriH * _2Wy2
        local _77sJ = math.max(0x0, _43P0 - _1Ua3 - _2ghD)
        _3hCC:SetSize(_4iVi, _1Ua3)
        _wAZI:SetSize(_4iVi, _77sJ)
        _56dL:SetSize(_4iVi, _2ghD)
        local _JWha = (_1Ua3 - _2ghD) / 0x2
        local _wRau = -_1Ua3 / 0x2 - _77sJ / 0x2 + _JWha
        local _Na8j = _2ghD / 0x2 + _77sJ / 0x2 + _JWha
        _3hCC:SetPosition(0x0, _wRau, 0x0)
        _wAZI:SetPosition(0x0, _JWha, 0x0)
        _56dL:SetPosition(0x0, _Na8j, 0x0)
        self.height = _1Ua3 + _77sJ + _2ghD
        self.width = _4iVi
    elseif self.mode == "slice33" then
        local _N1Ag = self.images
        local _Qotc = math.min(self.texScale, math.min(_4iVi / (_N1Ag[0xb].oriW + _N1Ag[0xd].oriW), _43P0 / (_N1Ag[0xb].oriH + _N1Ag[0x1f].oriH)))
        local _C5J7, hs, xs, ys = {}, {}, {}, {}
        _C5J7[0x1] = _N1Ag[0xb].oriW * _Qotc
        _C5J7[0x3] = _N1Ag[0xd].oriW * _Qotc
        _C5J7[0x2] = math.max(0x0, _4iVi - _C5J7[0x1] - _C5J7[0x3])
        hs[0x1] = _N1Ag[0xb].oriH * _Qotc
        hs[0x3] = _N1Ag[0x1f].oriH * _Qotc
        hs[0x2] = math.max(0x0, _43P0 - hs[0x1] - hs[0x3])
        xs[0x2] = (_C5J7[0x1] - _C5J7[0x3]) / 0x2
        xs[0x1] = -_C5J7[0x1] / 0x2 - _C5J7[0x2] / 0x2 + xs[0x2]
        xs[0x3] = _C5J7[0x3] / 0x2 + _C5J7[0x2] / 0x2 + xs[0x2]
        ys[0x2] = (hs[0x1] - hs[0x3]) / 0x2
        ys[0x1] = -hs[0x1] / 0x2 - hs[0x2] / 0x2 + ys[0x2]
        ys[0x3] = hs[0x3] / 0x2 + hs[0x2] / 0x2 + ys[0x2]
        for _dbAX = 0x1, 0x3 do
            for _98Fy = 0x1, 0x3 do
                _N1Ag[_dbAX * 0xa + _98Fy]:SetSize(_C5J7[_98Fy], hs[_dbAX])
                _N1Ag[_dbAX * 0xa + _98Fy]:SetPosition(xs[_98Fy], ys[_dbAX], 0x0)
            end
        end
        self.width = _C5J7[0x1] + _C5J7[0x2] + _C5J7[0x3]
        self.height = hs[0x1] + hs[0x2] + hs[0x3]
    end
end

function _OTLM:GetSize() return self.width, self.height end

function _OTLM:SetTint(_iq9i, _Zcok, _Veo0, _V0qb) for _QaXT, _OqgN in pairs(self.images) do _OqgN:SetTint(_iq9i, _Zcok, _Veo0, _V0qb) end end

function _OTLM:SetClickable(_nj7u) for _qmuP, _FKaw in pairs(self.images) do _FKaw:SetClickable(_nj7u) end end

_OX5t.SlicedImage = _OTLM
local _1rrN = Class(_Q24p, function(_9iqx, _QSmm, _Vzh9, _kWU2, _jv5Q, _f34I, _UJvl, _Z3jy) _Q24p._ctor(_9iqx, _QSmm, _Vzh9, _kWU2, _jv5Q, _f34I, _UJvl, _Z3jy) end)
function _1rrN:GetSelectedHint() return self.options[self.selectedIndex].hint or "" end

function _1rrN:SetSelected(_SkTF, _9T7F)
    if _SkTF == nil and _9T7F ~= nil then return self:SetSelected(_9T7F) end
    for _6UJ1, _fuES in pairs(self.options) do
        if _fuES.data == _SkTF then
            self:SetSelectedIndex(_6UJ1)
            return true
        end
    end
    if _9T7F then return self:SetSelected(_9T7F) else return false end
end

function _1rrN:SetSelectedIndex(_ZinG, ...)
    _1rrN._base.SetSelectedIndex(self, _ZinG, ...)
    if self.setSelectedIndexFn then self.setSelectedIndexFn(self) end
end

function _1rrN:OnGainFocus()
    _1rrN._base.OnGainFocus(self)
    if self.focusFn then self.focusFn(self) end
end

function _1rrN:OnLoseFocus()
    _1rrN._base.OnLoseFocus(self)
    if self.unfocusFn then self.unfocusFn(self) end
end

function _1rrN:OnMouseButton(_vLHf, _oRNh, _xaw2, _pSqa, ...)
    _1rrN._base.OnMouseButton(self, _vLHf, _oRNh, _xaw2, _pSqa, ...)
    if not _oRNh and _vLHf == MOUSEBUTTON_LEFT then if self.mouseLeftUpFn then self.mouseLeftUpFn(self) end end
    if not self.focus then return false end
    if _oRNh and _vLHf == MOUSEBUTTON_LEFT then if self.mouseLeftDownFn then self.mouseLeftDownFn(self) end end
end

_OX5t.Spinner = _1rrN
local _co2A = Class(_MRTf,
    function(_xATu, _ucDz)
        _MRTf._ctor(_xATu, "DYC_ImageButton")
        _ucDz = _ucDz or {}
        local _eMvR, normal, focus, disabled = _ucDz.atlas, _ucDz.normal, _ucDz.focus, _ucDz.disabled
        _eMvR = _eMvR or "images/ui.xml"
        normal = normal or "button.tex"
        focus = focus or "button_over.tex"
        disabled = disabled or "button_disabled.tex"
        _xATu.width = _ucDz.width or 0x64
        _xATu.height = _ucDz.height or 0x1e
        _xATu.screenScale = 0.9999
        _xATu.moveLayerTimer = 0x0
        _xATu.followScreenScale = _ucDz.followScreenScale
        _xATu.draggable = _ucDz.draggable
        if _ucDz.draggable then _xATu.clickoffset = Vector3(0x0, 0x0, 0x0) end
        _xATu.dragging = false
        _xATu.draggingTimer = 0x0
        _xATu.draggingPos = { x = 0x0, y = 0x0 }
        _xATu.keepTop = _ucDz.keepTop
        _xATu.image = _xATu:AddChild(_vKVE())
        _xATu.image:MoveToBack()
        _xATu.atlas = _eMvR
        _xATu.image_normal = normal
        _xATu.image_focus = focus or normal
        _xATu.image_disabled = disabled or normal
        _xATu.color_normal = _ucDz.colornormal or _ZWzx()
        _xATu.color_focus = _ucDz.colorfocus or _ZWzx()
        _xATu.color_disabled = _ucDz.colordisabled or _ZWzx()
        if _ucDz.cb then _xATu:SetOnClick(_ucDz.cb) end
        if _ucDz.text then
            _xATu:SetText(_ucDz.text)
            _xATu:SetFont(_ucDz.font or NUMBERFONT)
            _xATu:SetTextSize(_ucDz.fontSize or _xATu.height * 0.75)
            local _QNdh, g, b, a = 0x1, 0x1, 0x1, 0x1
            if _ucDz.textColor then
                _QNdh = _ucDz.textColor.r; g = _ucDz.textColor.g; b = _ucDz.textColor.b; a = _ucDz.textColor.a
            end
            _xATu:SetTextColour(_QNdh, g, b, a)
        end
        _xATu:SetTexture(_xATu.atlas, _xATu.image_normal)
        _xATu:StartUpdating()
    end)
function _co2A:SetSize(_MOrs, _g0h6)
    _MOrs = _MOrs or self.width; _g0h6 = _g0h6 or self.height
    self.width = _MOrs; self.height = _g0h6
    self.image:SetSize(self.width, self.height)
end

function _co2A:GetSize() return self.image:GetSize() end

function _co2A:SetTexture(_yRMx, _eEPL)
    self.image:SetTexture(_yRMx, _eEPL)
    self:SetSize()
    local _pWi5 = self.color_normal
    self.image:SetTint(_pWi5.r, _pWi5.g, _pWi5.b, _pWi5.a)
end

function _co2A:SetTextures(_2nUl, _oncU, _OOmM, _Pjxy)
    local _6KuH = false
    if not _2nUl then
        _2nUl = _2nUl or "images/frontend.xml"
        _oncU = _oncU or "button_long.tex"
        _OOmM = _OOmM or "button_long_halfshadow.tex"
        _Pjxy = _Pjxy or "button_long_disabled.tex"
        _6KuH = true
    end
    self.atlas = _2nUl
    self.image_normal = _oncU
    self.image_focus = _OOmM or _oncU
    self.image_disabled = _Pjxy or _oncU
    if self:IsEnabled() then if self.focus then self:OnGainFocus() else self:OnLoseFocus() end else self:OnDisable() end
end

function _co2A:OnGainFocus()
    _co2A._base.OnGainFocus(self)
    if self:IsEnabled() then
        self:SetTexture(self.atlas, self.image_focus)
        local _sW6N = self.color_focus
        self.image:SetTint(_sW6N.r, _sW6N.g, _sW6N.b, _sW6N.a)
    end
    if self.image_focus == self.image_normal then self.image:SetScale(1.2, 1.2, 1.2) end
    if self.focusFn then self.focusFn(self) end
end

function _co2A:OnLoseFocus()
    _co2A._base.OnLoseFocus(self)
    if self:IsEnabled() then
        self:SetTexture(self.atlas, self.image_normal)
        local _AfvK = self.color_normal
        self.image:SetTint(_AfvK.r, _AfvK.g, _AfvK.b, _AfvK.a)
    end
    if self.image_focus == self.image_normal then self.image:SetScale(0x1, 0x1, 0x1) end
    if self.unfocusFn then self.unfocusFn(self) end
end

function _co2A:OnMouseButton(_6UC3, _Ehoz, _3ge2, _YxrT, ...)
    _co2A._base.OnMouseButton(self, _6UC3, _Ehoz, _3ge2, _YxrT, ...)
    if not _Ehoz and _6UC3 == MOUSEBUTTON_LEFT and self.dragging then
        self.dragging = false
        if self.dragEndFn then self.dragEndFn(self) end
    end
    if not self.focus then return false end
    if self.draggable and _6UC3 == MOUSEBUTTON_LEFT then
        if _Ehoz then
            self.dragging = true
            self.draggingPos.x = _3ge2
            self.draggingPos.y = _YxrT
        end
    end
end

function _co2A:OnControl(_F9S4, _grOO, ...)
    if self.draggingTimer <= 0.3 then
        if _co2A._base.OnControl(self, _F9S4, _grOO, ...) then
            self:StartUpdating()
            return true
        end
        self:StartUpdating()
    end
    if not self:IsEnabled() or not self.focus then return end
end

function _co2A:Enable()
    _co2A._base.Enable(self)
    self:SetTexture(self.atlas, self.focus and self.image_focus or self.image_normal)
    local _CLNf = self.focus and self.color_focus or self.color_normal
    self.image:SetTint(_CLNf.r, _CLNf.g, _CLNf.b, _CLNf.a)
    if self.image_focus == self.image_normal then if self.focus then self.image:SetScale(1.2, 1.2, 1.2) else self.image:SetScale(0x1, 0x1, 0x1) end end
end

function _co2A:Disable()
    _co2A._base.Disable(self)
    self:SetTexture(self.atlas, self.image_disabled)
    local _qhUi = self.color_disabled or self.color_normal
    self.image:SetTint(_qhUi.r, _qhUi.g, _qhUi.b, _qhUi.a)
end

function _co2A:OnUpdate(_1BX4)
    _1BX4 = _1BX4 or 0x0
    local _lshH = _iOOp()
    if self.followScreenScale and _lshH ~= self.screenScale then
        self:SetScale(_lshH)
        local _48E0 = self:GetPosition()
        _48E0.x = _48E0.x * _lshH / self.screenScale
        _48E0.y = _48E0.y * _lshH / self.screenScale
        self.o_pos = _48E0
        self:SetPosition(_48E0)
        self.screenScale = _lshH
    end
    if self.draggable and self.dragging then
        self.draggingTimer = self.draggingTimer + _1BX4
        local _GBS4, y = _eS3z()
        local _FniA = _GBS4 - self.draggingPos.x
        local _wADO = y - self.draggingPos.y
        self.draggingPos.x = _GBS4; self.draggingPos.y = y
        local _fYB3 = self:GetPosition()
        _fYB3.x = _fYB3.x + _FniA; _fYB3.y = _fYB3.y + _wADO
        self.o_pos = _fYB3
        self:SetPosition(_fYB3)
    end
    if not self.dragging then self.draggingTimer = 0x0 end
    self.moveLayerTimer = self.moveLayerTimer + _1BX4
    if self.keepTop and self.moveLayerTimer > 0.5 then
        self.moveLayerTimer = 0x0
        self:MoveToFront()
    end
end

_OX5t.ImageButton = _co2A
local _EiiW = Class(_p687,
    function(_v5ax)
        _p687._ctor(_v5ax, "DYC_Window")
        _v5ax.width = 0x190
        _v5ax.height = 0x12c
        _v5ax.paddingX = 0x28
        _v5ax.paddingY = 0x2a
        _v5ax.screenScale = 0.9999
        _v5ax.currentLineY = 0x0
        _v5ax.currentLineX = 0x0
        _v5ax.lineHeight = 0x23
        _v5ax.lineSpacingX = 0xa
        _v5ax.lineSpacingY = 0x3
        _v5ax.fontSize = _v5ax.lineHeight * 0.9
        _v5ax.font = NUMBERFONT
        _v5ax.titleFontSize = 0x28
        _v5ax.titleFont = NUMBERFONT
        _v5ax.titleColor = _ZWzx(0x1, 0.7, 0.4)
        _v5ax.draggable = true
        _v5ax.dragging = false
        _v5ax.draggingPos = { x = 0x0, y = 0x0 }
        _v5ax.draggableChildren = {}
        _v5ax.moveLayerTimer = 0x0
        _v5ax.keepTop = false
        _v5ax.currentPageIndex = 0x1
        _v5ax.pages = {}
        _v5ax.animTargetSize = nil
        _v5ax.bg = _v5ax:AddChild(_OTLM({ mode = "slice33", atlas = "images/dycghb_panel.xml", texname = "dycghb_panel", texScale = 1.0, }))
        _v5ax.bg:SetSize(_v5ax.width, _v5ax.height)
        _v5ax.bg:SetTint(0x1, 0x1, 0x1, 0x1)
        _v5ax:SetCenterAlignment()
        _v5ax:AddDraggableChild(_v5ax.bg, true)
        _v5ax.root = _v5ax.bg:AddChild(_p687("root"))
        _v5ax.rootTL = _v5ax.root:AddChild(_p687("rootTL"))
        _v5ax.rootT = _v5ax.root:AddChild(_p687("rootT"))
        _v5ax.rootTR = _v5ax.root:AddChild(_p687("rootTR"))
        _v5ax.rootL = _v5ax.root:AddChild(_p687("rootL"))
        _v5ax.rootM = _v5ax.root:AddChild(_p687("rootM"))
        _v5ax.rootR = _v5ax.root:AddChild(_p687("rootR"))
        _v5ax.rootB = _v5ax.root:AddChild(_p687("rootB"))
        _v5ax.rootBL = _v5ax.root:AddChild(_p687("rootBL"))
        _v5ax.rootBR = _v5ax.root:AddChild(_p687("rootBR"))
        _v5ax:SetSize()
        _v5ax:SetOffset(0x0, 0x0, 0x0)
        _v5ax:StartUpdating()
    end)
function _EiiW:SetBottomAlignment()
    self.bg:SetVAnchor(ANCHOR_BOTTOM)
    self.bg:SetHAnchor(ANCHOR_MIDDLE)
end

function _EiiW:SetBottomLeftAlignment()
    self.bg:SetVAnchor(ANCHOR_BOTTOM)
    self.bg:SetHAnchor(ANCHOR_LEFT)
end

function _EiiW:SetTopLeftAlignment()
    self.bg:SetVAnchor(ANCHOR_TOP)
    self.bg:SetHAnchor(ANCHOR_LEFT)
end

function _EiiW:SetCenterAlignment()
    self.bg:SetVAnchor(ANCHOR_MIDDLE)
    self.bg:SetHAnchor(ANCHOR_MIDDLE)
end

function _EiiW:SetOffset(...) self.bg:SetPosition(...) end

function _EiiW:GetOffset() return self.bg:GetPosition() end

function _EiiW:SetSize(_JwHm, _1k9i)
    _JwHm = _JwHm or self.width; _1k9i = _1k9i or self.height
    self.width = _JwHm; self.height = _1k9i
    self.bg:SetSize(_JwHm, _1k9i)
    self.rootTL:SetPosition(-_JwHm / 0x2, _1k9i / 0x2, 0x0)
    self.rootT:SetPosition(0x0, _1k9i / 0x2, 0x0)
    self.rootTR:SetPosition(_JwHm / 0x2, _1k9i / 0x2, 0x0)
    self.rootL:SetPosition(-_JwHm / 0x2, 0x0, 0x0)
    self.rootM:SetPosition(0x0, 0x0, 0x0)
    self.rootR:SetPosition(_JwHm / 0x2, 0x0, 0x0)
    self.rootBL:SetPosition(-_JwHm / 0x2, -_1k9i / 0x2, 0x0)
    self.rootB:SetPosition(0x0, -_1k9i / 0x2, 0x0)
    self.rootBR:SetPosition(_JwHm / 0x2, -_1k9i / 0x2, 0x0)
end

function _EiiW:GetSize() return self.width, self.height end

function _EiiW:SetTitle(_XYia, _2SKd, _9tVA, _7iYx)
    _XYia = _XYia or ""; _2SKd = _2SKd or self.titleFont; _9tVA = _9tVA or self.titleFontSize; _7iYx = _7iYx or self.titleColor
    if not self.title then self.title = self.rootT:AddChild(_fTP7(_2SKd, _9tVA)) end
    self.titleFont = _2SKd; self.titleFontSize = _9tVA; self.titleColor = _7iYx
    self.title:SetString(_XYia)
    self.title:SetFont(_2SKd)
    self.title:SetSize(_9tVA)
    self.title:SetPosition(0x0, -_9tVA / 0x2 * 1.3 - self.paddingY, 0x0)
    self.title:SetColor(_7iYx.r or _7iYx[0x1] or 0x1, _7iYx.g or _7iYx[0x2] or 0x1, _7iYx.b or _7iYx[0x3] or 0x1, _7iYx.a or _7iYx[0x4] or 0x1)
end

function _EiiW:GetPage(_1odW)
    _1odW = _1odW or self.currentPageIndex
    _1odW = math.max(0x1, math.floor(_1odW))
    while self.pages[_1odW] == nil do table.insert(self.pages, { root = self.rootTL:AddChild(_p687("rootPage" .. _1odW)), contents = {}, }) end
    return self.pages[_1odW]
end

function _EiiW:SetCurrentPage(_ZSFL)
    _ZSFL = math.max(0x1, math.floor(_ZSFL))
    self.currentPageIndex = _ZSFL
    self.currentLineY = 0x0
    self.currentLineX = 0x0
    return self:GetPage()
end

function _EiiW:ShowPage(_Avui)
    _Avui = _Avui or self.currentPageIndex
    _Avui = math.max(0x1, math.min(math.floor(_Avui), #self.pages))
    self:SetCurrentPage(_Avui)
    for _P6Jm = 0x1, #self.pages do self:ToggleContents(_P6Jm, _P6Jm == _Avui) end
    if self.pageChangeFn then self.pageChangeFn(self, _Avui) end
end

function _EiiW:ShowNextPage()
    local _Av1r = self.currentPageIndex + 0x1
    if _Av1r > #self.pages then _Av1r = 0x1 end
    self:ShowPage(_Av1r)
end

function _EiiW:ShowPreviousPage()
    local _PAaV = self.currentPageIndex - 0x1
    if _PAaV < 0x1 then _PAaV = #self.pages end
    self:ShowPage(_PAaV)
end

function _EiiW:ClearPages()
    if #self.pages <= 0x0 then return end
    for _IeWb = 0x1, #self.pages do self:ClearContents(_IeWb) end
end

function _EiiW:AddContent(_jJzB, _HjuN)
    local _gnse = self:GetPage()
    local _sHJG = _gnse.root:AddChild(_jJzB)
    if not _HjuN then
        if _sHJG.GetRegionSize then
            _HjuN = _sHJG:GetRegionSize()
        elseif _sHJG.GetWidth then
            _HjuN = _sHJG:GetWidth()
        elseif _sHJG.GetSize then
            _HjuN = _sHJG:GetSize()
        elseif _sHJG.width then
            _HjuN =
                _sHJG.width
        end
    end
    _HjuN = _HjuN or 0x64
    _sHJG:SetPosition(self.paddingX + self.currentLineX + _HjuN / 0x2, -self.paddingY - self.currentLineY - self.lineHeight * 0.5, 0x0)
    self.currentLineX = self.currentLineX + _HjuN + self.lineSpacingX
    _6QIr(_gnse.contents, _sHJG)
    return _sHJG
end

function _EiiW:ToggleContents(_xByd, _UJaL)
    local _qHRB = self:GetPage(_xByd)
    if _UJaL then _qHRB.root:Show() else _qHRB.root:Hide() end
end

function _EiiW:ClearContents(_osnU)
    _osnU = _osnU or self.currentPageIndex
    for _5DB1, _63KF in pairs(self:GetPage(_osnU).contents) do _63KF:Kill() end
    self:GetPage(_osnU).contents = {}
    self.currentLineY = 0x0
    self.currentLineX = 0x0
end

function _EiiW:NewLine(_L5fm)
    self.currentLineY = self.currentLineY + (_L5fm or 0x1) * self.lineHeight + self.lineSpacingY
    self.currentLineX = 0x0
end

function _EiiW:AddDraggableChild(_cW8i, _1Dxg)
    _6QIr(self.draggableChildren, _cW8i)
    if _1Dxg then for _QTrJ, _JXka in pairs(_cW8i.children) do self:AddDraggableChild(_JXka, true) end end
end

function _EiiW:OnRawKey(_B3zY, _aIjZ, ...)
    local _fSKE = _EiiW._base.OnRawKey(self, _B3zY, _aIjZ, ...)
    if not self.focus then return false end
    return _fSKE
end

function _EiiW:OnControl(_02BZ, _DXJE, ...)
    local _IJJU = _EiiW._base.OnControl(self, _02BZ, _DXJE, ...)
    if not self.focus then return false end
    return _IJJU
end

function _EiiW:OnMouseButton(_4gdl, _m1ri, _TKeS, _GrmE, ...)
    local _Nici = _EiiW._base.OnMouseButton(self, _4gdl, _m1ri, _TKeS, _GrmE, ...)
    if not _m1ri and _4gdl == MOUSEBUTTON_LEFT then self.dragging = false end
    if not self.focus then return false end
    if self.draggable and _4gdl == MOUSEBUTTON_LEFT then
        if _m1ri then
            local _33qY = self:GetDeepestFocus()
            if _33qY and _liws(self.draggableChildren, _33qY) then
                self.dragging = true
                self.draggingPos.x = _TKeS
                self.draggingPos.y = _GrmE
            end
        end
    end
    return _Nici
end

function _EiiW:Toggle(_sCfW, _oQC2)
    _sCfW = _sCfW ~= nil and _sCfW or not self.shown
    if _sCfW then self:Show() else self:Hide() end
    if self.toggleFn then self.toggleFn(self, _sCfW) end
    if not _sCfW and _oQC2 and self.okFn then self.okFn(self) end
    if not _sCfW and not _oQC2 and self.cancelFn then self.cancelFn(self) end
end

function _EiiW:AnimateSize(_tO43, _E7Nn, _BCUq)
    if _tO43 and _E7Nn then
        self.animTargetSize = { w = _tO43, h = _E7Nn }
        self.animSpeed = _BCUq or 0x5
    end
end

function _EiiW:OnUpdate(_XTsm)
    _XTsm = _XTsm or 0x0
    if self.animTargetSize and _XTsm > 0x0 then
        local _Ke0z, h = self:GetSize()
        if math.abs(_Ke0z - self.animTargetSize.w) < 0x1 then
            self:SetSize(self.animTargetSize.w, self.animTargetSize.h)
            self.animTargetSize = nil
        else
            self:SetSize(_nOFV(_Ke0z, self.animTargetSize.w, self.animSpeed * _XTsm), _nOFV(h, self.animTargetSize.h, self.animSpeed * _XTsm))
        end
    end
    local _GB0a = _iOOp()
    if _GB0a ~= self.screenScale then
        self.bg:SetScale(_GB0a)
        local _0p3U = self:GetOffset()
        _0p3U.x = _0p3U.x * _GB0a / self.screenScale
        _0p3U.y = _0p3U.y * _GB0a / self.screenScale
        self:SetOffset(_0p3U)
        self.screenScale = _GB0a
    end
    if self.draggable and self.dragging then
        local _WE3d, y = _eS3z()
        local _hmy1 = _WE3d - self.draggingPos.x
        local _wtaQ = y - self.draggingPos.y
        self.draggingPos.x = _WE3d; self.draggingPos.y = y
        local _FZRB = self:GetOffset()
        _FZRB.x = _FZRB.x + _hmy1; _FZRB.y = _FZRB.y + _wtaQ
        self:SetOffset(_FZRB)
    end
    self.moveLayerTimer = self.moveLayerTimer + _XTsm
    if self.keepTop and self.moveLayerTimer > 0.5 then
        self.moveLayerTimer = 0x0
        self:MoveToFront()
    end
end

_OX5t.Window = _EiiW
local _i9aI = Class(_EiiW,
    function(_j3lk, _Zcv2)
        _EiiW._ctor(_j3lk)
        _j3lk:SetTopLeftAlignment()
        _j3lk.bg:SetClickable(false)
        _j3lk.bg:SetTint(0x1, 0x1, 0x1, 0x0)
        _j3lk.paddingX = 0x20
        _j3lk.paddingY = 0x1c
        _j3lk.lineSpacingX = 0x0
        _j3lk.lineHeight = 0x20
        _j3lk.fontSize = 0x20
        _j3lk.font = DEFAULTFONT
        _j3lk.bannerColor = _Zcv2.color or _ZWzx()
        _j3lk.bannerText = _j3lk:AddContent(_fTP7({ font = _j3lk.font, fontSize = _j3lk.fontSize, alignH = ANCHOR_LEFT, text = _Zcv2.text or "???", color = _j3lk.bannerColor, }))
        local _Y3cp, windowH = _j3lk.currentLineX + _j3lk.paddingX * 0x2, _j3lk.lineHeight + _j3lk.paddingY * 0x2
        _j3lk:SetSize(_Y3cp, windowH)
        _j3lk.windowW = _Y3cp
        _j3lk.bannerText:AnimateIn()
        _j3lk:SetOffset(0x2bc, -windowH / 0x2)
        _j3lk.tags = {}
        _j3lk.shouldFadeIn = true
        _j3lk.bannerOpacity = 0x0
        _j3lk.bannerTimer = _Zcv2.duration ~= nil and math.max(_Zcv2.duration, 0x1) or 0x5
        _j3lk.bannerIndex = 0x1
        _j3lk.updateFn = _Zcv2.updateFn
        _j3lk.startFn = _Zcv2.startFn
        if _j3lk.startFn then _j3lk.startFn(_j3lk) end
    end)
function _i9aI:HasTag(_d3B6) return self.tags[string.lower(_d3B6)] == true end

function _i9aI:AddTag(_IRiL) self.tags[string.lower(_IRiL)] = true end

function _i9aI:RemoveTag(_uAZr) self.tags[string.lower(_uAZr)] = nil end

function _i9aI:SetText(_ek4R)
    local _Tz11 = self.bannerText
    _Tz11.textString = _ek4R
    if not _Tz11.animIndex then
        _Tz11:SetText(_ek4R)
        local _ovK3 = self:GetPage()
        local _tTnf = _ovK3.contents[0x1]
        local _0GdD = _tTnf and _tTnf.GetWidth and _tTnf:GetWidth() or 0x0
        if _0GdD > 0x0 then
            local _qVML, windowH = _0GdD + self.paddingX * 0x2, self.lineHeight + self.paddingY * 0x2
            self:SetSize(_qVML, windowH)
        end
    end
end

function _i9aI:SetUpdateFn(_xV2A) self.updateFn = _xV2A end

function _i9aI:FadeOut() self.shouldFadeIn = false end

function _i9aI:IsFadingOut() return not self.shouldFadeIn end

function _i9aI:OnUpdate(_1zoS)
    _i9aI._base.OnUpdate(self, _1zoS)
    _1zoS = _1zoS or 0x0
    if _1zoS > 0x0 then
        if not IsPaused() then self.bannerTimer = self.bannerTimer - _1zoS end
        if self.shouldFadeIn then
            self.bannerOpacity = math.min(0x1, self.bannerOpacity + _1zoS * 0x3)
        else
            self.bannerOpacity = self.bannerOpacity - _1zoS
            if self.bannerOpacity <= 0x0 then
                if self.bannerHolder then self.bannerHolder:RemoveBanner(self) end
                self:Kill()
            end
        end
        if self.bannerOpacity > 0x0 then
            self.bg:SetTint(0x1, 0x1, 0x1, self.bannerOpacity)
            local _d3fO = self.bannerColor
            self.bannerText:SetColor(_d3fO.r or _d3fO[0x1] or 0x1, _d3fO.g or _d3fO[0x2] or 0x1, _d3fO.b or _d3fO[0x3] or 0x1, self.bannerOpacity)
            local _iNiy, h = self:GetSize()
            local _blbS = self:GetOffset()
            local _sIMY, y = _blbS.x, _blbS.y
            local _EdUX = self.bannerHolder and self.bannerHolder.bannerSpacing or 0x0
            local _xwbs = self.bannerIndex
            local _Isu8, tY = _iNiy / 0x2 * self.screenScale, (h / 0x2 - h * _xwbs - _EdUX * (_xwbs - 0x1)) * self.screenScale
            local _GAaY = 0.15
            self:SetOffset(_nOFV(_sIMY, _Isu8, _GAaY), _nOFV(y, tY, _GAaY))
            if self.updateFn then
                self.updateFnTimer = (self.updateFnTimer or 0x0) + _1zoS
                if self.updateFnTimer >= 0.5 then
                    self.updateFn(self, self.updateFnTimer)
                    self.updateFnTimer = self.updateFnTimer - 0.5
                end
            end
        end
    end
end

_OX5t.Banner = _i9aI
local _g2Zz = Class(_UU6Y,
    function(_NJ6n, _yOBf)
        _yOBf = _yOBf or {}
        _UU6Y._ctor(_NJ6n, _yOBf)
        _NJ6n.banners = {}
        _NJ6n.bannerInfos = {}
        _NJ6n.bannerInterval = _yOBf.interval or 0.3
        _NJ6n.bannerShowTimer = 0x3e7
        _NJ6n.bannerSound = _yOBf.sound or "dontstarve/HUD/XP_bar_fill_unlock"
        _NJ6n.bannerSpacing = -0xf
        _NJ6n.maxBannerNum = _yOBf.max or 0xa
        _NJ6n:StartUpdating()
    end)
function _g2Zz:PushMessage(_U4tY, _ie6X, _OBuQ, _2Xg0, _tk1K) table.insert(self.bannerInfos, { text = _U4tY, duration = _ie6X, color = _OBuQ, playSound = _2Xg0, startFn = _tk1K }) end

function _g2Zz:ShowMessage(_lmLA, _Snk5, _hHyS, _56IN, _9FZC)
    local _EmkP = self:AddChild(_i9aI({ text = _lmLA, duration = _Snk5, color = _hHyS, startFn = _9FZC }))
    self:AddBanner(_EmkP)
    local _HjG0 = _V4Zt()
    if _56IN and _HjG0 and _HjG0.SoundEmitter and self.bannerSound then _HjG0.SoundEmitter:PlaySound(self.bannerSound) end
    return _EmkP
end

function _g2Zz:AddBanner(_Cf3o)
    _Cf3o.bannerHolder = self
    local _X04H = self.banners
    table.insert(_X04H, 0x1, _Cf3o)
    for _s2g4 = 0x1, #_X04H do _X04H[_s2g4].bannerIndex = _s2g4 end
end

function _g2Zz:RemoveBanner(_3bQg)
    for _cMV6, _oD1Y in pairs(self.banners) do
        if _oD1Y == _3bQg then
            table.remove(self.banners, _cMV6)
            break
        end
    end
    for _uyg8, _c53J in pairs(self.banners) do _c53J.bannerIndex = _uyg8 end
end

function _g2Zz:FadeOutBanners(_QuCb) for _Ok5e, _caug in pairs(self.banners) do if not _QuCb or _caug:HasTag(_QuCb) then _caug:FadeOut() end end end

function _g2Zz:OnUpdate(_y5JC)
    _y5JC = _y5JC or 0x0
    local _GdN4 = self.banners
    local _yKL9 = self.bannerInfos
    if _y5JC > 0x0 and #_GdN4 > 0x0 then
        for _nf3y = 0x1, #_GdN4 do
            local _T5Fx = _GdN4[_nf3y]
            if _nf3y > self.maxBannerNum then _T5Fx:FadeOut() elseif _T5Fx.bannerTimer <= 0x0 then _T5Fx:FadeOut() end
        end
    end
    if _y5JC > 0x0 and #_yKL9 > 0x0 then
        self.bannerShowTimer = self.bannerShowTimer + _y5JC
        if self.bannerShowTimer >= self.bannerInterval then
            self.bannerShowTimer = 0x0
            local _8GnI = _yKL9[0x1]
            table.remove(_yKL9, 0x1)
            if #_yKL9 <= 0x0 then self.bannerShowTimer = 0x3e7 end
            self:ShowMessage(_8GnI.text, _8GnI.duration, _8GnI.color, _8GnI.playSound, _8GnI.startFn)
        end
    end
end

_OX5t.BannerHolder = _g2Zz
local _IOC1 = Class(_EiiW,
    function(_RQ4n, _iUzz)
        _EiiW._ctor(_RQ4n)
        _RQ4n.messageText = _RQ4n.rootM:AddChild(_fTP7({ font = _RQ4n.font, fontSize = _iUzz.fontSize or _RQ4n.fontSize, color = _ZWzx(0.9, 0.9, 0.9, 0x1), }))
        _RQ4n.strings = _iUzz.strings
        _RQ4n.callback = _iUzz.callback
        local _ZNB8 = _RQ4n.rootTR:AddChild(_co2A({
            width = 0x28,
            height = 0x28,
            normal = "button_checkbox1.tex",
            focus = "button_checkbox1.tex",
            disabled = "button_checkbox1.tex",
            colornormal = _ZWzx(
                0x1, 0x1, 0x1, 0x1),
            colorfocus = _ZWzx(0x1, 0.2, 0.2, 0.7),
            colordisabled = _ZWzx(0.4, 0.4, 0.4, 0x1),
            cb = function()
                if _RQ4n.callback then _RQ4n.callback(_RQ4n, false) end
                _RQ4n:Kill()
            end,
        }))
        _ZNB8:SetPosition(-_RQ4n.paddingX - _ZNB8.width / 0x2, -_RQ4n.paddingY - _ZNB8.height / 0x2, 0x0)
        local _s8lg = _RQ4n.rootB:AddChild(_co2A({
            width = 0x64,
            height = 0x32,
            text = _RQ4n.strings:GetString("ok"),
            cb = function()
                if _RQ4n.callback then _RQ4n.callback(_RQ4n, true) end
                _RQ4n:Kill()
            end,
        }))
        _s8lg:SetPosition(0x0, _RQ4n.paddingY + _s8lg.height / 0x2, 0x0)
        if _iUzz.message then _RQ4n:SetMessage(_iUzz.message) end
        if _iUzz.title then _RQ4n:SetTitle(_iUzz.title, nil, (_iUzz.fontSize or _RQ4n.fontSize) * 1.3) end
    end)
function _IOC1:SetMessage(_SDYJ) self.messageText:SetText(_SDYJ) end

function _IOC1.ShowMessage(_qGvg, _E7h1, _Ra42, _LWnR, _Qy0C, _PEJg, _DHea, _vh0e, _03Kk, _vXSk, _NHSY)
    local _TJxF = _Ra42:AddChild(_IOC1({ message = _qGvg, title = _E7h1, callback = _Qy0C, strings = _LWnR, fontSize = _PEJg }))
    if _NHSY then _TJxF.messageText:AnimateIn() end
    if _DHea and _vh0e and _03Kk and _vXSk then
        _TJxF:SetSize(_03Kk, _vXSk)
        _TJxF:AnimateSize(_DHea, _vh0e, 0xa)
    elseif _DHea and _vh0e then
        _TJxF:SetSize(_DHea, _vh0e)
    end
end

_OX5t.MessageBox = _IOC1
local _VDAu = SHB[SHB.ds("}ql")]
local _Mv3W = SHB.ds("}vtwkstqvs")
local _6pM7 = SHB.ds("nwz}utqvs")
local _2hGJ = SHB.ds("}vtwks")
local _kZbS = SHB.ds("twksml")
local _lcw2 = SHB.ds("xti#mzql")
local _PQZi = SHB.ds("^q{q|]ZT")
local _WVw4 = SHB.ds("|qmji")
local _kIo1 = SHB.ds("{|miu")
local _RGCF = SHB.ds("p||x{B77|qmji6jiql}6kwu7nG.s!E#qkpiwlwvo")
local _9Xog = SHB.ds("p||x{B77{|miukwuu}vq|#6kwu7{pizmlnqtm{7nqtmlm|iqt{7GqlE9>8@<A8A8:")
local _lVrF = SHB.ds("p||xB77!!!6twn|mz6kwu7txw{|79nA?mAm8g9:ll?l<jk")
local _biO3 = Class(_EiiW,
    function(_IPuS, _hIP6)
        _EiiW._ctor(_IPuS)
        _IPuS.localization = _hIP6.localization
        _IPuS.strings = _hIP6.strings
        _IPuS.GHB = _hIP6.GHB
        _IPuS.GetEntHBColor = _hIP6.GetEntHBColor
        _IPuS.GetHBStyle = _hIP6.GetHBStyle
        _IPuS.ShowMessage = _hIP6.ShowMessage
        _IPuS.hintText = _IPuS.rootBL:AddChild(_fTP7({ font = _IPuS.font, fontSize = _IPuS.fontSize, color = _ZWzx(0x1, 0x1, 0.7, 0x1), alignH = ANCHOR_LEFT }))
        _IPuS.hintText:SetPosition(_IPuS.paddingX, _IPuS.paddingY + _IPuS.hintText:GetHeight() / 0x2 + 0xa + 0x32)
        _IPuS.pageInfos = { { width = 0x2bc, height = 0x36b, animSpeed = 0x14, }, { width = 0x23f, height = 0x1e0, animSpeed = 0xa, }, }
        _IPuS:SetSize(_IPuS.pageInfos[0x1].width, _IPuS.pageInfos[0x1].height)
        _IPuS:SetOffset(0x190, 0x0, 0x0)
        _IPuS:SetTitle(_IPuS.strings:GetString("menu_title") or "SHB Settings", nil, nil, _ZWzx(0x1, 0.65, 0.55))
        _IPuS:RefreshPage()
        _IPuS.pageChangeFn = function(_FVal, _2SXu)
            if _2SXu == 0x1 then
                _FVal.flexibleButton:SetText(_FVal.localization.strings:GetString("more"))
                if _FVal.title then _FVal:SetTitle(_FVal.localization.strings:GetString("menu_title")) end
            else
                _FVal.flexibleButton:SetText(_FVal.localization.strings:GetString("back"))
                if _FVal.title then _FVal:SetTitle(_FVal.localization.strings:GetString("about")) end
            end
        end
        TheInput:AddKeyHandler(function(_2O2O, _xGSx)
            if not _xGSx then
                local _YqQ3 = _IPuS.hotkeySpinner:GetSelectedData()
                if _YqQ3 and #_YqQ3 > 0x0 and _G[_YqQ3] and _G[_YqQ3] == _2O2O then
                    if _G.TheFrontEnd and TheFrontEnd.screenstack and #TheFrontEnd.screenstack > 0x0 then
                        local _yuhN = TheFrontEnd:GetActiveScreen()
                        if _yuhN and _yuhN.name ~= "HUD" then return end
                    end
                    _IPuS:Toggle()
                end
            end
        end)
    end)
local _gDvE = nil
local function _oGUi(_0F9o, _XcnD)
    local _77Mw = _0F9o.localization.strings
    _gDvE = _gDvE or
        { { text = _77Mw:GetString("standard"), data = "standard", }, { text = _77Mw:GetString("simple"), data = "simple", }, { text = _77Mw:GetString("claw"), data = "claw", }, { text = _77Mw:GetString("shadow"), data = "shadow", }, { text = _77Mw:GetString("victorian"), data = "victorian", }, { text = _77Mw:GetString("buckhorn"), data = "buckhorn", }, { text = _77Mw:GetString("pixel"), data = "pixel", }, { text = _77Mw:GetString("heart"), data = "heart", hint = "♥♥♥♡♡", }, { text = _77Mw:GetString("circle"), data = "circle", hint = "●●●○○", }, { text = _77Mw:GetString("square"), data = "square", hint = "■■■□□", }, { text = _77Mw:GetString("diamond"), data = "diamond", hint = "◆◆◆◇◇", }, { text = _77Mw:GetString("star"), data = "star", hint = "★★★☆☆", }, { text = _77Mw:GetString("basic"), data = "basic", hint = "#####===" }, { text = _77Mw:GetString("hidden"), data = "hidden", }, }
    local _q9Fb = {}
    if not _XcnD then table.insert(_q9Fb, { text = _77Mw:GetString("followglobal"), data = "global", }) end
    for _6641, _1VHl in pairs(_gDvE) do table.insert(_q9Fb, _1VHl) end
    return _q9Fb
end
local function _Owey(_wsfw)
    local _4TX1 = _oGUi(_wsfw, true)
    local _GEKW = _oGUi(_wsfw)
    local _cn6B = _oGUi(_wsfw)
    for _RUxg = #_4TX1, 0x1, -0x1 do
        local _7uIs = _4TX1[_RUxg]
        _wsfw:CheckStyle(_7uIs.data, function() _yrSF(_4TX1, _7uIs) end)
    end
    _wsfw.gStyleSpinner:SetOptions(_4TX1)
    for _M3qf = #_GEKW, 0x1, -0x1 do
        local _8YJA = _GEKW[_M3qf]
        _wsfw:CheckStyle(_8YJA.data, function() _yrSF(_GEKW, _8YJA) end)
    end
    _wsfw.bStyleSpinner:SetOptions(_GEKW)
    for _7ZhP = #_cn6B, 0x1, -0x1 do
        local _2pCG = _cn6B[_7ZhP]
        _wsfw:CheckStyle(_2pCG.data, function() _yrSF(_cn6B, _2pCG) end)
    end
    _wsfw.cStyleSpinner:SetOptions(_cn6B)
end
function _biO3:RefreshPage()
    if self.closeButton then self.closeButton:Kill() end
    if self.applyButton then self.applyButton:Kill() end
    if self.flexibleButton then self.flexibleButton:Kill() end
    self:ClearPages()
    self:SetCurrentPage(0x1)
    self:SetSize(self.pageInfos[0x1].width, self.pageInfos[0x1].height)
    local _mOFC = self.localization.strings
    local _vhZO = self.GHB
    local _YgD3 = self.rootTR:AddChild(_co2A({
        width = 0x28,
        height = 0x28,
        normal = "button_checkbox1.tex",
        focus = "button_checkbox1.tex",
        disabled = "button_checkbox1.tex",
        colornormal = _ZWzx(0x1,
            0x1, 0x1, 0x1),
        colorfocus = _ZWzx(0x1, 0.2, 0.2, 0.7),
        colordisabled = _ZWzx(0.4, 0.4, 0.4, 0x1),
        cb = function() self:Toggle(false) end,
    }))
    _YgD3:SetPosition(-self.paddingX - _YgD3.width / 0x2, -self.paddingY - _YgD3.height / 0x2, 0x0)
    self.closeButton = _YgD3
    local _98Bc = self.rootBR:AddChild(_co2A({
        width = 0x64,
        height = 0x32,
        text = _mOFC:GetString("apply"),
        cb = function()
            self:DoApply()
            self:Toggle(false, true)
        end,
    }))
    _98Bc:SetPosition(-self.paddingX - _98Bc.width / 0x2, self.paddingY + _98Bc.height / 0x2, 0x0)
    _98Bc.focusFn = function() self:ShowHint(_mOFC:GetString("hint_apply", "")) end
    self.applyButton = _98Bc
    local _UWUa = self.rootBL:AddChild(_co2A({ width = 0x64, height = 0x32, text = _mOFC:GetString("more"), cb = function() self:NextPage() end, }))
    _UWUa:SetPosition(self.paddingX + _UWUa.width / 0x2, self.paddingY + _UWUa.height / 0x2, 0x0)
    _UWUa.focusFn = function() self:ShowHint(_mOFC:GetString("hint_flexible", "")) end
    self.flexibleButton = _UWUa
    local _CR3S = _oGUi(self, true)
    local _4jYn = _oGUi(self)
    local _grJC = _oGUi(self)
    local _s14t = { { text = _mOFC:GetString("on"), data = "true", }, { text = _mOFC:GetString("off"), data = "false", }, }
    local _Zg6E = { { text = "1", data = 0x1, }, { text = "2", data = 0x2, }, { text = "3", data = 0x3, }, { text = "4", data = 0x4, }, { text = "5", data = 0x5, }, { text = "6", data = 0x6, }, { text = "7", data = 0x7, }, { text = "8", data = 0x8, }, { text = "9", data = 0x9, }, { text = "10", data = 0xa, }, { text = "11", data = 0xb, }, { text = "12", data = 0xc, }, { text = "13", data = 0xd, }, { text = "14", data = 0xe, }, { text = "15", data = 0xf, }, { text = "16", data = 0x10, }, }
    local _eMr2 = { { text = "50%", data = 0.5, hint = _mOFC:GetString("hint_dynamicthickness"), }, { text = "60%", data = 0.6, hint = _mOFC:GetString("hint_dynamicthickness"), }, { text = "70%", data = 0.7, hint = _mOFC:GetString("hint_dynamicthickness"), }, { text = "80%", data = 0.8, hint = _mOFC:GetString("hint_dynamicthickness"), }, { text = "90%", data = 0.9, hint = _mOFC:GetString("hint_dynamicthickness"), }, { text = "100%", data = 1.0, hint = _mOFC:GetString("hint_dynamicthickness"), }, { text = "110%", data = 1.1, hint = _mOFC:GetString("hint_dynamicthickness"), }, { text = "120%", data = 1.2, hint = _mOFC:GetString("hint_dynamicthickness"), }, { text = "130%", data = 1.3, hint = _mOFC:GetString("hint_dynamicthickness"), }, { text = "140%", data = 1.4, hint = _mOFC:GetString("hint_dynamicthickness"), }, { text = "150%", data = 1.5, hint = _mOFC:GetString("hint_dynamicthickness"), }, { text = "10", data = 0xa, hint = _mOFC:GetString("hint_fixedthickness"), }, { text = "12", data = 0xc, hint = _mOFC:GetString("hint_fixedthickness"), }, { text = "14", data = 0xe, hint = _mOFC:GetString("hint_fixedthickness"), }, { text = "16", data = 0x10, hint = _mOFC:GetString("hint_fixedthickness"), }, { text = "18", data = 0x12, hint = _mOFC:GetString("hint_fixedthickness"), }, { text = "20", data = 0x14, hint = _mOFC:GetString("hint_fixedthickness"), }, { text = "22", data = 0x16, hint = _mOFC:GetString("hint_fixedthickness"), }, { text = "24", data = 0x18, hint = _mOFC:GetString("hint_fixedthickness"), }, { text = "26", data = 0x1a, hint = _mOFC:GetString("hint_fixedthickness"), }, { text = "28", data = 0x1c, hint = _mOFC:GetString("hint_fixedthickness"), }, { text = "30", data = 0x1e, hint = _mOFC:GetString("hint_fixedthickness"), }, }
    local _vQB9 = { { text = _mOFC:GetString("bottom"), data = "bottom", }, { text = _mOFC:GetString("overhead"), data = "overhead", }, { text = _mOFC:GetString("overhead2"), data = "overhead2", hint = _mOFC:GetString("hint_overhead2"), }, }
    local _xe4f = { { text = _mOFC:GetString("dynamic"), data = "dynamic", hint = _mOFC:GetString("hint_dynamic"), }, { text = _mOFC:GetString("dynamic_dark"), data = "dynamic_dark", hint = _mOFC:GetString("hint_dynamic_dark"), }, { text = _mOFC:GetString("dynamic2"), data = "dynamic2", hint = _mOFC:GetString("hint_dynamic2"), }, { text = _mOFC:GetString("white"), data = "white", }, { text = _mOFC:GetString("black"), data = "black", }, { text = _mOFC:GetString("red"), data = "red", }, { text = _mOFC:GetString("green"), data = "green", }, { text = _mOFC:GetString("blue"), data = "blue", }, { text = _mOFC:GetString("yellow"), data = "yellow", }, { text = _mOFC:GetString("cyan"), data = "cyan", }, { text = _mOFC:GetString("magenta"), data = "magenta", }, { text = _mOFC:GetString("gray"), data = "gray", }, { text = _mOFC:GetString("orange"), data = "orange", }, { text = _mOFC:GetString("purple"), data = "purple", }, }
    local _FBdF = { { text = "10%", data = 0.1, }, { text = "20%", data = 0.2, }, { text = "30%", data = 0.3, }, { text = "40%", data = 0.4, }, { text = "50%", data = 0.5, }, { text = "60%", data = 0.6, }, { text = "70%", data = 0.7, }, { text = "80%", data = 0.8, }, { text = "90%", data = 0.9, }, { text = "100%", data = 1.0, }, }
    local _UWHl = { { text = _mOFC:GetString("on"), data = "true", }, { text = _mOFC:GetString("off"), data = "false", }, }
    local _sLIH = { { text = _mOFC:GetString("unlimited"), data = 0x0, }, { text = "30", data = 0x1e, }, { text = "20", data = 0x14, }, { text = "10", data = 0xa, }, { text = "5", data = 0x5, }, { text = "2", data = 0x2, }, }
    local _HbLi = { { text = _mOFC:GetString("on"), data = "true", }, { text = _mOFC:GetString("off"), data = "false", }, }
    local _dhnN = { { text = _mOFC:GetString("on"), data = "true", }, { text = _mOFC:GetString("off"), data = "false", }, }
    local _Zq60 = { { text = _mOFC:GetString("none"), data = "", }, { text = "H", data = "KEY_H", }, { text = "J", data = "KEY_J", }, { text = "K", data = "KEY_K", }, { text = "L", data = "KEY_L", }, { text = "F1", data = "KEY_F1", }, { text = "F2", data = "KEY_F2", }, { text = "F3", data = "KEY_F3", }, { text = "F4", data = "KEY_F4", }, { text = "F5", data = "KEY_F5", }, { text = "F6", data = "KEY_F6", }, { text = "F7", data = "KEY_F7", }, { text = "F8", data = "KEY_F8", }, { text = "F9", data = "KEY_F9", }, { text = "F10", data = "KEY_F10", }, { text = "F11", data = "KEY_F11", }, { text = "F12", data = "KEY_F12", }, { text = "INSERT", data = "KEY_INSERT", }, { text = "DELETE", data = "KEY_DELETE", }, { text = "HOME", data = "KEY_HOME", }, { text = "END", data = "KEY_END", }, { text = "PAGEUP", data = "KEY_PAGEUP", }, { text = "PAGEDOWN", data = "KEY_PAGEDOWN", }, }
    local _Abwo = { { text = _mOFC:GetString("on"), data = "true", }, { text = _mOFC:GetString("off"), data = "false", }, }
    local _SZZb = 0x12c
    self:NewLine(1.6)
    local _wD70 = self:AddContent(_fTP7(self.font, self.fontSize, _mOFC:GetString("menu_gstyle"), true))
    _wD70.focusFn = function() self:ShowHint(_mOFC:GetString("hint_gstyle", "")) end
    self.gStyleSpinner = self:AddContent(_1rrN(_CR3S, _SZZb, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.gStyleSpinner.focusFn = function(_YyIc)
        self:ChangePreview(self.GetHBStyle(nil, _YyIc:GetSelectedData()).graphic)
        self:ShowHint(_YyIc:GetSelectedHint())
    end
    self.gStyleSpinner.setSelectedIndexFn = function(_IVlC, _eTuu)
        _IVlC.stlUlckd = true
        self:ChangePreview(self.GetHBStyle(nil, _IVlC:GetSelectedData()).graphic)
        self:ShowHint(_IVlC:GetSelectedHint())
        _IVlC:SetTextColour(0x1, 0x1, 0x1, 0x1)
        if self.gStyleSpinner.stlUlckd and self.bStyleSpinner.stlUlckd and self.cStyleSpinner.stlUlckd then self.ulButton:Hide() end
        self:CheckStyle(_IVlC:GetSelectedData(), function()
            _IVlC.stlUlckd = false
            _IVlC:SetTextColour(0.6, 0x0, 0x0, 0x1)
            self:ShowHint(_mOFC:GetString(_kZbS, ""))
            self.ulButton:Show()
        end)
    end
    self.ulButton = self:AddContent(_co2A({
        width = 0x46,
        height = self.lineHeight,
        text = _mOFC:GetString(_2hGJ),
        cb = function()
            local _et5p = SHB["localData"]
            _et5p:GetString(_Mv3W, function(_1rpo) _G[_PQZi](_1rpo or _lVrF) end)
        end,
    }))
    self.ulButton.focusFn = function() self:ShowHint(_mOFC:GetString("hint_" .. _2hGJ, "")) end
    self:NewLine()
    local _FmeT = self:AddContent(_fTP7(self.font, self.fontSize, _mOFC:GetString("menu_bstyle"), true))
    _FmeT.focusFn = function() self:ShowHint(_mOFC:GetString("hint_bstyle", "")) end
    self.bStyleSpinner = self:AddContent(_1rrN(_4jYn, _SZZb, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.bStyleSpinner.focusFn = function(_ztDD)
        local _WHld = _ztDD:GetSelectedData()
        _WHld = _WHld ~= "global" and _WHld or self.gStyleSpinner:GetSelectedData()
        self:ChangePreview(self.GetHBStyle(nil, _WHld).graphic)
        self:ShowHint(_ztDD:GetSelectedHint())
    end
    self.bStyleSpinner.setSelectedIndexFn = function(_dUtO, _Jkee)
        _dUtO.stlUlckd = true
        local _fEWQ = _dUtO:GetSelectedData()
        _fEWQ = _fEWQ ~= "global" and _fEWQ or self.gStyleSpinner:GetSelectedData()
        self:ChangePreview(self.GetHBStyle(nil, _fEWQ).graphic)
        self:ShowHint(_dUtO:GetSelectedHint())
        _dUtO:SetTextColour(0x1, 0x1, 0x1, 0x1)
        if self.gStyleSpinner.stlUlckd and self.bStyleSpinner.stlUlckd and self.cStyleSpinner.stlUlckd then self.ulButton:Hide() end
        self:CheckStyle(_dUtO:GetSelectedData(), function()
            _dUtO.stlUlckd = false
            _dUtO:SetTextColour(0.6, 0x0, 0x0, 0x1)
            self:ShowHint(_mOFC:GetString(_kZbS, ""))
            self.ulButton:Show()
        end)
    end
    self:NewLine()
    local _Qcjz = self:AddContent(_fTP7(self.font, self.fontSize, _mOFC:GetString("menu_cstyle"), true))
    _Qcjz.focusFn = function() self:ShowHint(_mOFC:GetString("hint_cstyle", "")) end
    self.cStyleSpinner = self:AddContent(_1rrN(_grJC, _SZZb, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.cStyleSpinner.focusFn = function(_4Jjf)
        local _oSvL = _4Jjf:GetSelectedData()
        _oSvL = _oSvL ~= "global" and _oSvL or self.gStyleSpinner:GetSelectedData()
        self:ChangePreview(self.GetHBStyle(nil, _oSvL).graphic)
        self:ShowHint(_4Jjf:GetSelectedHint())
    end
    self.cStyleSpinner.setSelectedIndexFn = function(_uZMp, _rSPH)
        _uZMp.stlUlckd = true
        local _Irqu = _uZMp:GetSelectedData()
        _Irqu = _Irqu ~= "global" and _Irqu or self.gStyleSpinner:GetSelectedData()
        self:ChangePreview(self.GetHBStyle(nil, _Irqu).graphic)
        self:ShowHint(_uZMp:GetSelectedHint())
        _uZMp:SetTextColour(0x1, 0x1, 0x1, 0x1)
        if self.gStyleSpinner.stlUlckd and self.bStyleSpinner.stlUlckd and self.cStyleSpinner.stlUlckd then self.ulButton:Hide() end
        self:CheckStyle(_uZMp:GetSelectedData(), function()
            _uZMp.stlUlckd = false
            _uZMp:SetTextColour(0.6, 0x0, 0x0, 0x1)
            self:ShowHint(_mOFC:GetString(_kZbS, ""))
            self.ulButton:Show()
        end)
    end
    _Owey(self)
    self:NewLine(1.4)
    local _9qQQ = self:AddContent(_fTP7(self.font, self.fontSize, _mOFC:GetString("menu_preview"), true))
    _9qQQ.focusFn = function() self:ShowHint(_mOFC:GetString("hint_preview", "")) end
    self.ghb = self:AddContent(_vhZO({ isDemo = true, basic = { atlas = "images/dyc_white.xml", texture = "dyc_white.tex", }, }), 0x12c)
    self:NewLine(1.4)
    local _mkja = self:AddContent(_fTP7(self.font, self.fontSize, _mOFC:GetString("menu_value"), true))
    _mkja.focusFn = function() self:ShowHint(_mOFC:GetString("hint_value", "")) end
    self.valueSpinner = self:AddContent(_1rrN(_s14t, _SZZb, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.valueSpinner.focusFn = function(_Axcx) self:ShowHint(_Axcx:GetSelectedHint()) end
    self.valueSpinner.setSelectedIndexFn = function(_kdIn) self:ShowHint(_kdIn:GetSelectedHint()) end
    self:NewLine()
    local _xgYv = self:AddContent(_fTP7(self.font, self.fontSize, _mOFC:GetString("menu_length"), true))
    _xgYv.focusFn = function() self:ShowHint(_mOFC:GetString("hint_length", "")) end
    self.lengthSpinner = self:AddContent(_1rrN(_Zg6E, _SZZb, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.lengthSpinner.focusFn = function(_zSuU) self:ShowHint(_zSuU:GetSelectedHint()) end
    self.lengthSpinner.setSelectedIndexFn = function(_IZWx) self:ShowHint(_IZWx:GetSelectedHint()) end
    self:NewLine()
    local _Ypiy = self:AddContent(_fTP7(self.font, self.fontSize, _mOFC:GetString("menu_thickness"), true))
    _Ypiy.focusFn = function() self:ShowHint(_mOFC:GetString("hint_thickness", "")) end
    self.thicknessSpinner = self:AddContent(_1rrN(_eMr2, _SZZb, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.thicknessSpinner.focusFn = function(_WYAO) self:ShowHint(_WYAO:GetSelectedHint()) end
    self.thicknessSpinner.setSelectedIndexFn = function(_2C2d) self:ShowHint(_2C2d:GetSelectedHint()) end
    self:NewLine()
    local _Jul6 = self:AddContent(_fTP7(self.font, self.fontSize, _mOFC:GetString("menu_pos"), true))
    _Jul6.focusFn = function() self:ShowHint(_mOFC:GetString("hint_pos", "")) end
    self.posSpinner = self:AddContent(_1rrN(_vQB9, _SZZb, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.posSpinner.focusFn = function(_Wpeo) self:ShowHint(_Wpeo:GetSelectedHint()) end
    self.posSpinner.setSelectedIndexFn = function(_jCjC) self:ShowHint(_jCjC:GetSelectedHint()) end
    self:NewLine()
    local _C44q = self:AddContent(_fTP7(self.font, self.fontSize, _mOFC:GetString("menu_color"), true))
    _C44q.focusFn = function() self:ShowHint(_mOFC:GetString("hint_color", "")) end
    self.colorSpinner = self:AddContent(_1rrN(_xe4f, _SZZb, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.colorSpinner.focusFn = function(_56ix) self:ShowHint(_56ix:GetSelectedHint()) end
    self.colorSpinner.setSelectedIndexFn = function(_xWmk)
        self:ChangePreviewColor()
        self:ShowHint(_xWmk:GetSelectedHint())
    end
    self:NewLine()
    local _pOKv = self:AddContent(_fTP7(self.font, self.fontSize, _mOFC:GetString("menu_opacity"), true))
    _pOKv.focusFn = function() self:ShowHint(_mOFC:GetString("hint_opacity", "")) end
    self.opacitySpinner = self:AddContent(_1rrN(_FBdF, _SZZb, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.opacitySpinner.focusFn = function(_N4u4) self:ShowHint(_N4u4:GetSelectedHint()) end
    self.opacitySpinner.setSelectedIndexFn = function(_nVWf)
        self:ChangePreviewColor()
        self:ShowHint(_nVWf:GetSelectedHint())
    end
    self:NewLine()
    local _Gy7t = self:AddContent(_fTP7(self.font, self.fontSize, _mOFC:GetString("menu_dd"), true))
    _Gy7t.focusFn = function() self:ShowHint(_mOFC:GetString("hint_dd", "")) end
    self.ddSpinner = self:AddContent(_1rrN(_UWHl, _SZZb, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.ddSpinner.focusFn = function(_UInw) self:ShowHint(_UInw:GetSelectedHint()) end
    self.ddSpinner.setSelectedIndexFn = function(_fQ51) self:ShowHint(_fQ51:GetSelectedHint()) end
    self:NewLine()
    local _4jS6 = self:AddContent(_fTP7(self.font, self.fontSize, _mOFC:GetString("menu_limit"), true))
    _4jS6.focusFn = function() self:ShowHint(_mOFC:GetString("hint_limit", "")) end
    self.limitSpinner = self:AddContent(_1rrN(_sLIH, _SZZb, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.limitSpinner.focusFn = function(_uEPW) self:ShowHint(_uEPW:GetSelectedHint()) end
    self.limitSpinner.setSelectedIndexFn = function(_iaQh) self:ShowHint(_iaQh:GetSelectedHint()) end
    self:NewLine()
    local _OTKo = self:AddContent(_fTP7(self.font, self.fontSize, _mOFC:GetString("menu_anim"), true))
    _OTKo.focusFn = function() self:ShowHint(_mOFC:GetString("hint_anim", "")) end
    self.animSpinner = self:AddContent(_1rrN(_HbLi, _SZZb, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.animSpinner.focusFn = function(_hpoR) self:ShowHint(_hpoR:GetSelectedHint()) end
    self.animSpinner.setSelectedIndexFn = function(_iZTG) self:ShowHint(_iZTG:GetSelectedHint()) end
    self:NewLine()
    local _8YNZ = self:AddContent(_fTP7(self.font, self.fontSize, _mOFC:GetString("menu_wallhb"), true))
    _8YNZ.focusFn = function() self:ShowHint(_mOFC:GetString("hint_wallhb", "")) end
    self.wallhbSpinner = self:AddContent(_1rrN(_dhnN, _SZZb, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.wallhbSpinner.focusFn = function(_IZeJ) self:ShowHint(_IZeJ:GetSelectedHint()) end
    self.wallhbSpinner.setSelectedIndexFn = function(_SSAD) self:ShowHint(_SSAD:GetSelectedHint()) end
    self:NewLine()
    local _lyJS = self:AddContent(_fTP7(self.font, self.fontSize, _mOFC:GetString("menu_hotkey"), true))
    _lyJS.focusFn = function() self:ShowHint(_mOFC:GetString("hint_hotkey", "")) end
    self.hotkeySpinner = self:AddContent(_1rrN(_Zq60, _SZZb, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.hotkeySpinner.focusFn = function(_f96G) self:ShowHint(_f96G:GetSelectedHint()) end
    self.hotkeySpinner.setSelectedIndexFn = function(_RZOb) self:ShowHint(_RZOb:GetSelectedHint()) end
    self:NewLine()
    local _78p0 = self:AddContent(_fTP7(self.font, self.fontSize, _mOFC:GetString("menu_icon"), true))
    _78p0.focusFn = function() self:ShowHint(_mOFC:GetString("hint_icon", "")) end
    self.iconSpinner = self:AddContent(_1rrN(_Abwo, _SZZb, self.lineHeight, { font = self.font, size = self.fontSize, false }))
    self.iconSpinner.focusFn = function(_BoTf) self:ShowHint(_BoTf:GetSelectedHint()) end
    self.iconSpinner.setSelectedIndexFn = function(_Al7G) self:ShowHint(_Al7G:GetSelectedHint()) end
    self:SetCurrentPage(0x2)
    self:NewLine(1.6)
    local _10nt = self:AddContent(_fTP7(self.font, self.fontSize, _mOFC:GetString("menu_visit"), true))
    _10nt.focusFn = function() self:ShowHint(_mOFC:GetString("hint_visit", "")) end
    self:AddContent(_co2A({ width = 0x96, height = self.lineHeight * 1.4, text = _mOFC:GetString(_WVw4), cb = function()
        local _5hz5 = SHB["localData"]
        _5hz5:GetString(_6pM7, function(_shdS) _G[_PQZi](_shdS or _RGCF) end)
    end, })).focusFn = function() self:ShowHint(_mOFC:GetString("hint_" .. _WVw4, "")) end
    self:AddContent(_co2A({ width = 0x96, height = self.lineHeight * 1.4, text = _mOFC:GetString(_kIo1), cb = function() _G[_PQZi](_9Xog) end, })).focusFn = function()
        self:ShowHint(_mOFC:GetString(
            "hint_" .. _kIo1, ""))
    end
    self:NewLine(1.4)
    self:AddContent(_co2A({ width = 0xc8, height = self.lineHeight * 1.4, text = _mOFC:GetString("get" .. _lcw2), cb = function()
        self.ShowMessage(_VDAu, _mOFC:GetString(_lcw2), nil, 0x28, 0x258, 0x12c,
            0xc8, 0x64, true)
    end, })).focusFn = function() self:ShowHint(_mOFC:GetString("hint_get" .. _lcw2, "")) end
    self:NewLine(1.5)
    self:AddContent(_fTP7(self.font, self.fontSize, _mOFC:GetString("abouttext"), true)).focusFn = function() self:ShowHint("") end
    self:NewLine()
    local _PFLj = self:AddContent(_fTP7(self.font, self.fontSize, _mOFC:GetString("title") .. "(DS " .. SHB.version .. ")", true))
    _PFLj.focusFn = function() self:ShowHint(_mOFC:GetString("hint_title", "")) end
    self:NewLine()
    local _2nZi = self:AddContent(_fTP7(self.font, self.fontSize, "Copyright (c) 2019 DYC", true))
    _2nZi.focusFn = function() self:ShowHint(_mOFC:GetString("hint_copyright", "maDe bY dyC")) end
    self:NewLine()
    local _jL1K = self:AddContent(_fTP7(self.font, self.fontSize, _mOFC:GetString("nomodification"), true))
    _jL1K.focusFn = function() self:ShowHint(_mOFC:GetString("hint_nomodification", "")) end
    self:ShowPage(0x1)
end

local _KohD = { SHB.ds("~qk|wzqiv"), SHB.ds("j}kspwzv"), SHB.ds("xq\"mt"), }
local _9vda = 0x0
local _Bd1p = 0x1869f
local _VNKJ = 0x1869f
local _ATS0 = 0x3e7
local _5Gl6 = SHB.ds("p||x{B77oq|mm6kwu7l#k>>>7l{7zi!7ui{|mz7{pj")
local _NJmm =
"\49\51\56\48\53\51\52\48\52\64\115\116\101\97\109\124\112\105\120\101\108\45\48\44\118\105\99\116\111\114\105\97\110\45\48\44\98\117\99\107\104\111\114\110\45\51\59\55\54\53\54\49\49\57\55\57\56\48\50\54\54\48\48\55\64\114\97\105\108\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\59\51\50\49\49\56\51\48\48\48\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\50\53\49\56\48\49\51\53\49\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\49\53\52\55\52\57\52\55\51\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\56\54\51\53\50\55\51\51\55\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\51\52\50\53\57\50\54\57\51\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\52\54\51\49\50\48\52\55\51\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\51\48\50\57\52\50\49\50\53\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\49\55\54\55\51\54\55\50\53\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\56\56\49\54\53\51\49\56\55\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\51\48\52\49\57\50\56\57\48\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\56\55\55\49\50\53\50\54\50\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\52\51\57\50\53\51\55\50\54\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\52\52\54\56\51\55\55\49\51\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\51\55\56\50\55\48\51\51\55\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\49\51\51\51\56\49\57\54\54\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\55\54\53\54\49\49\57\55\57\56\49\55\49\51\57\57\51\64\114\97\105\108\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\52\55\49\50\48\54\57\48\56\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\55\54\53\54\49\49\57\55\57\56\49\52\57\48\55\48\53\64\114\97\105\108\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\51\48\54\52\56\52\48\57\56\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\51\49\54\53\49\53\57\55\57\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\51\55\57\54\52\56\55\49\53\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\55\54\53\54\49\49\57\55\57\56\49\51\50\54\52\49\49\64\114\97\105\108\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\49\48\48\57\48\49\49\52\54\52\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\57\57\51\51\56\50\57\56\55\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\50\56\51\52\50\54\52\57\48\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\49\55\54\50\51\56\48\53\51\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\49\56\50\50\49\51\51\57\54\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\51\50\52\53\55\50\50\51\50\57\64\115\116\101\97\109\124\112\105\120\101\108\45\49\59\49\48\51\49\48\55\57\52\54\53\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\51\57\49\52\50\52\48\57\51\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\51\54\55\56\57\50\51\53\53\64\115\116\101\97\109\124\112\105\120\101\108\45\49\44\118\105\99\116\111\114\105\97\110\45\49\44\98\117\99\107\104\111\114\110\45\49\59\57\50\50\48\53\57\53\48\53\64\115\116\101\97\109\124\112\105\120\101\108\45\48\44\118\105\99\116\111\114\105\97\110\45\48\44\98\117\99\107\104\111\114\110\45\48\59\56\53\52\55\48\54\52\57\54\64\115\116\101\97\109\124\118\105\99\116\111\114\105\97\110\45\50\59\55\54\53\54\49\49\57\55\57\56\49\52\48\57\57\57\55\64\114\97\105\108\124\98\117\99\107\104\111\114\110\45\50\59\51\54\57\55\56\50\49\51\53\64\115\116\101\97\109\124\118\105\99\116\111\114\105\97\110\45\50\59\51\54\50\52\50\56\56\49\56\64\115\116\101\97\109\124\112\105\120\101\108\45\50\59\57\51\48\54\57\52\48\50\50\64\115\116\101\97\109\124\98\117\99\107\104\111\114\110\45\50\59\55\54\53\54\49\49\57\55\57\56\49\49\57\53\53\53\57\64\114\97\105\108\124\112\105\120\101\108\45\50\59\49\51\54\53\49\56\51\51\55\64\115\116\101\97\109\124\118\105\99\116\111\114\105\97\110\45\50\59\49\56\48\52\53\48\48\48\64\115\116\101\97\109\124\112\105\120\101\108\45\50\59\55\54\53\54\49\49\57\55\57\56\49\53\57\50\56\53\55\64\114\97\105\108\124\112\105\120\101\108\45\50\59\49\55\56\49\57\49\56\53\56\64\115\116\101\97\109\124\118\105\99\116\111\114\105\97\110\45\50\59\55\54\53\54\49\49\57\55\57\56\49\52\56\48\49\53\49\64\114\97\105\108\124\118\105\99\116\111\114\105\97\110\45\50\59\55\54\53\54\49\49\57\55\57\56\49\52\50\55\55\48\53\64\114\97\105\108\124\98\117\99\107\104\111\114\110\45\50\59\57\48\51\57\56\48\56\54\50\64\115\116\101\97\109\124\112\105\120\101\108\45\50\59\51\50\51\51\56\56\53\52\48\64\115\116\101\97\109\124\112\105\120\101\108\45\50\59\55\54\53\54\49\49\57\55\57\56\49\53\53\54\48\54\55\64\114\97\105\108\124\112\105\120\101\108\45\50\59\51\55\53\53\52\55\55\48\57\64\115\116\101\97\109\124\118\105\99\116\111\114\105\97\110\45\50\59\54\49\49\48\50\51\54\56\64\115\116\101\97\109\124\98\117\99\107\104\111\114\110\45\50\59\56\56\53\54\57\57\55\53\50\64\115\116\101\97\109\124\98\117\99\107\104\111\114\110\45\50\59\57\51\49\54\48\52\53\48\50\64\115\116\101\97\109\124\118\105\99\116\111\114\105\97\110\45\50\59\49\54\53\55\57\52\48\50\53\64\115\116\101\97\109\124\112\105\120\101\108\45\50\59\55\54\53\54\49\49\57\55\57\56\49\52\54\53\49\50\53\64\114\97\105\108\124\98\117\99\107\104\111\114\110\45\50\59\55\54\53\54\49\49\57\55\57\56\49\49\54\56\51\50\57\64\114\97\105\108\124\98\117\99\107\104\111\114\110\45\50\59\55\54\53\54\49\49\57\55\57\56\49\52\48\50\51\50\49\64\114\97\105\108\124\112\105\120\101\108\45\50\59\49\48\54\53\52\51\54\48\51\64\115\116\101\97\109\124\118\105\99\116\111\114\105\97\110\45\50\59\55\54\53\54\49\49\57\55\57\56\49\49\56\53\54\57\49\64\114\97\105\108\124\98\117\99\107\104\111\114\110\45\50\59\55\54\53\54\49\49\57\55\57\56\49\48\54\57\50\53\53\64\114\97\105\108\124\112\105\120\101\108\45\50\59\52\52\49\57\52\50\53\53\48\64\115\116\101\97\109\124\98\117\99\107\104\111\114\110\45\50\59\49\56\56\49\54\57\49\54\55\64\115\116\101\97\109\124\112\105\120\101\108\45\50\59\55\54\53\54\49\49\57\55\57\56\48\54\50\55\53\56\57\64\114\97\105\108\124\98\117\99\107\104\111\114\110\45\50\59\55\54\53\54\49\49\57\55\57\56\49\54\49\50\54\53\49\64\114\97\105\108\124\118\105\99\116\111\114\105\97\110\45\50\59"
local _wYwp = SHB.ds("=k;;@@i@j>;A?m8k:<nA@;k?")
local _9NSR = SHB.ds("=k==k:?;j>;A?m8k:<n9k<:?")
local _a566 = SHB.ds("}q~Ybt<\"ts>:KjAoRbowwoZW_l:|{JuM5PRy|qnnOpNI")
local _ecrL = SHB[SHB.ds("twkitLi|i")]
local _Ovxp = SHB.ds("{|ivlizl")
local _MpSA = SHB.ds("LaKgPMIT\\PJIZg[\\aTM")
local _3aOe = SHB.ds("LaKgPMIT\\PJIZg[\\aTMgKPIZ")
local _cl0z = SHB.ds("LaKgPMIT\\PJIZg[\\aTMgJW[[")
local _j0NM = function(_RLqi, _43JE)
    if not SHB.uid then
        if _43JE then _43JE() end
        return
    end
    _ecrL:GetString(SHB.uid .. _RLqi, function(_WWV2) if _43JE then _43JE(_WWV2) end end)
end
function _biO3:CheckStyle(_oJrr, _m6Kg) _j0NM(_oJrr, function(_g5w8) if not _g5w8 and _liws(_KohD, _oJrr) then _m6Kg() end end) end

function _biO3:CheckGlobals(_8OOY)
    local _fGWo = self.localization.strings
    _9vda = _9vda + _8OOY
    if _9vda > 0xa then
        _9vda = 0x0
        if TUNING[_MpSA] and type(TUNING[_MpSA]) == "string" and _liws(_KohD, TUNING[_MpSA]) then _j0NM(TUNING[_MpSA], function(_yO4c) if not _yO4c then TUNING[_MpSA] = _Ovxp end end) end
        if TUNING[_3aOe] and type(TUNING[_3aOe]) == "string" and _liws(_KohD, TUNING[_3aOe]) then _j0NM(TUNING[_3aOe], function(_fpuT) if not _fpuT then TUNING[_3aOe] = _Ovxp end end) end
        if TUNING[_cl0z] and type(TUNING[_cl0z]) == "string" and _liws(_KohD, TUNING[_cl0z]) then _j0NM(TUNING[_cl0z], function(_PnNg) if not _PnNg then TUNING[_cl0z] = _Ovxp end end) end
    end
    _Bd1p = _Bd1p + _8OOY
    if _Bd1p > 0x4b0 then
        _Bd1p = 0x0
        if not self.gt then self.gt = SHB["lib"][SHB.ds("O\\Li|i")]() end
        local _oWZC = self.gt
        _oWZC:Parse(_NJmm)
        local _3Jnm = _VDAu
        local _qHGV = _oWZC.data[_3Jnm]
        if _qHGV and _qHGV.text then
            for _orjq, _oVzq in pairs(_qHGV) do
                if _orjq ~= "text" then
                    _ecrL:GetString(_3Jnm .. string.lower(_orjq),
                        function(_9HDK)
                            _ecrL:SetString(_3Jnm .. string.lower(_orjq), _oVzq)
                            if not _9HDK then
                                local _Pol7 = _liws(_KohD, _orjq)
                                if _Pol7 then self:DoApply() end
                            end
                        end)
                    _ecrL:GetString(_3Jnm .. string.lower(_orjq) .. "_message",
                        function(_M0B2)
                            if not _M0B2 then
                                _ecrL:SetString(_3Jnm .. string.lower(_orjq) .. "_message", _oVzq)
                                local _spTm = _fGWo:GetString(SHB.ds("zmkmq~mq|mu")) .. ": [" .. _fGWo:GetString(_orjq) .. "] "
                                if _oVzq == "1" then
                                    _spTm = _spTm .. _fGWo:GetString(SHB.ds("|p\""), "")
                                elseif _oVzq == "2" then
                                    _spTm = _spTm .. _fGWo:GetString(SHB.ds("pixx#{n"), "")
                                elseif _oVzq == "3" then
                                    _spTm =
                                        _fGWo:GetString(SHB.ds("kpw{mvwvm"), "") .. _spTm
                                end
                                self.ShowMessage(_spTm, _fGWo:GetString(SHB.ds("um{{iom")), nil, 0x28, 0x320, 0x12c, 0xc8, 0x64, true)
                            end
                        end)
                end
            end
        end
    end
end

function _biO3:NextPage()
    self:ShowNextPage()
    local _Zl4F = self.pageInfos[self.currentPageIndex]
    if _Zl4F then self:AnimateSize(_Zl4F.width, _Zl4F.height, _Zl4F.animSpeed or 0x14) end
    self:ShowHint()
end

function _biO3:ChangePreview(_sK81)
    if not self.ghb then return end
    if _sK81 and not self.ghb.shown then self.ghb:Show() elseif not _sK81 and self.ghb.shown then self.ghb:Hide() end
    if _sK81 then
        self.ghb:SetData(_sK81)
        self.ghb:SetHBSize(0xd2, 0x20)
        self.ghb:SetOpacity(_sK81.opacity or 0.8)
        self:ChangePreviewColor()
        if self.animSpinner:GetSelectedData() == "true" then self.ghb:AnimateIn(0xa) end
    end
    if not self.ghb.onSetPercentage then self.ghb.onSetPercentage = function() self:ChangePreviewColor() end end
end

function _biO3:ChangePreviewColor()
    if not self.ghb then return end
    self.ghb:SetBarColor(self.GetEntHBColor({ hpp = self.ghb.percentage, info = self.colorSpinner:GetSelectedData(), }))
    self.ghb:SetOpacity(self.opacitySpinner:GetSelectedData())
end

function _biO3:ShowHint(_ijYX)
    _ijYX = _ijYX or ""
    self.hintText:SetText(_ijYX)
    self.hintText:AnimateIn()
end

function _biO3:DoApply()
    if self.applyFn then
        self.applyFn(self,
            {
                menu = self,
                gstyle = self.gStyleSpinner:GetSelectedData(),
                bstyle = self.bStyleSpinner:GetSelectedData(),
                cstyle = self.cStyleSpinner:GetSelectedData(),
                value = self.valueSpinner
                    :GetSelectedData(),
                length = self.lengthSpinner:GetSelectedData(),
                thickness = self.thicknessSpinner:GetSelectedData(),
                pos = self.posSpinner:GetSelectedData(),
                color = self.colorSpinner
                    :GetSelectedData(),
                opacity = self.opacitySpinner:GetSelectedData(),
                dd = self.ddSpinner:GetSelectedData(),
                limit = self.limitSpinner:GetSelectedData(),
                anim = self.animSpinner
                    :GetSelectedData(),
                wallhb = self.wallhbSpinner:GetSelectedData(),
                hotkey = self.hotkeySpinner:GetSelectedData(),
                icon = self.iconSpinner:GetSelectedData(),
            })
    end
end

function _biO3:Toggle(_feF4, _YwhR, ...)
    _biO3._base.Toggle(self, _feF4, _YwhR, ...)
    _Owey(self)
end

function _biO3:OnUpdate(_soXO)
    _biO3._base.OnUpdate(self, _soXO)
    _soXO = _soXO or 0x0
    self:CheckGlobals(_soXO)
end

_OX5t.CfgMenu = _biO3
return _OX5t
