local _Rjh5 = require "widgets/widget"
local _hGR4 = require "widgets/image"
local _wipt = require "widgets/text"
local _uo5E = function(_1JC3, _Bv7Z, _dIGm, _dE6r)
    return {
        r = _1JC3 or 0x1,
        g = _Bv7Z or 0x1,
        b = _dIGm or 0x1,
        a = _dE6r or 0x1,
        Get = function(_1Tzr) return _1Tzr.r, _1Tzr.g, _1Tzr.b, _1Tzr.a end,
        Set = function(
            _71ll, _dLU5, _7EQl, _DEAn, _Pm9v)
            _71ll.r = _dLU5 or 0x1; _71ll.g = _7EQl or 0x1; _71ll.b = _DEAn or 0x1; _71ll.a = _Pm9v or 0x1;
        end,
    }
end
local _lr2J = function(_aF01) return math.min(math.max(_aF01, 0x0), 0x1) end
local _m8CL = function(_YOG9, _xqZ0, _Kb1I) return _YOG9 + (_xqZ0 - _YOG9) * _Kb1I end
local _2uSI = function(_dSLO, _TdfP)
    for _9MlI, _U3T9 in pairs(_dSLO) do if _U3T9 == _TdfP then return true end end
    return false
end
local _cfwZ = function(_8BZy, _wjVk) if not _2uSI(_8BZy, _wjVk) then table.insert(_8BZy, _wjVk) end end
local _AtQP = function(_WsXE, _wX1V) for _J0aV, _frgQ in pairs(_WsXE) do if _frgQ == _wX1V then return _J0aV end end end
local _s2FW = function(_83KM, _2msJ)
    local _r5pP = _AtQP(_83KM, _2msJ)
    if _r5pP then table.remove(_83KM, _r5pP) end
end
local _5GVB = Class(_Rjh5,
    function(_fpMp, _nLqh)
        _Rjh5._ctor(_fpMp, "DYC_SlicedImage")
        _fpMp.images = {}
        _fpMp.mode = "slice13"
        _fpMp.texScale = _nLqh.texScale or 0x1
        _fpMp.width = 0x64
        _fpMp.height = 0x64
        _fpMp:SetTextures(_nLqh)
    end)
function _5GVB:__tostring() return string.format("%s (%s)", self.name, self.mode) end

function _5GVB:SetTextures(_Betf)
    assert(_Betf.mode)
    self.images = {}
    self.mode = _Betf.mode
    if self.mode == "slice13" or self.mode == "slice31" then
        local _cf1H = nil
        _cf1H = self:AddChild(_hGR4(_Betf.atlas, _Betf.texname .. "_1.tex"))
        _cf1H.oriW, _cf1H.oriH = _cf1H:GetSize()
        _cf1H.imgPos = 0x1
        self.images[0x1] = _cf1H
        _cf1H = self:AddChild(_hGR4(_Betf.atlas, _Betf.texname .. "_2.tex"))
        _cf1H.oriW, _cf1H.oriH = _cf1H:GetSize()
        _cf1H.imgPos = 0x2
        self.images[0x2] = _cf1H
        _cf1H = self:AddChild(_hGR4(_Betf.atlas, _Betf.texname .. "_3.tex"))
        _cf1H.oriW, _cf1H.oriH = _cf1H:GetSize()
        _cf1H.imgPos = 0x3
        self.images[0x3] = _cf1H
        if self.mode == "slice13" then
            assert(self.images[0x1].oriH == self.images[0x3].oriH, "Height must be equal!")
            assert(self.images[0x1].oriH == self.images[0x2].oriH, "Height must be equal!")
        else
            assert(self.images[0x1].oriW == self.images[0x3].oriW, "Width must be equal!")
            assert(self.images[0x1].oriW == self.images[0x2].oriW, "Width must be equal!")
        end
        return
    elseif self.mode == "slice33" then
        local _X4R3 = nil
        for _SkLk = 0x1, 0x3 do
            for _FrDN = 0x1, 0x3 do
                _X4R3 = self:AddChild(_hGR4(_Betf.atlas, _Betf.texname .. "_" .. _SkLk .. _FrDN .. ".tex"))
                _X4R3.oriW, _X4R3.oriH = _X4R3:GetSize()
                _X4R3.imgPos = _SkLk * 0xa + _FrDN
                self.images[_SkLk * 0xa + _FrDN] = _X4R3
                if _SkLk > 0x1 then assert(self.images[_SkLk * 0xa + _FrDN].oriW == self.images[(_SkLk - 0x1) * 0xa + _FrDN].oriW, "Width must be equal!") end
                if _FrDN > 0x1 then assert(self.images[_SkLk * 0xa + _FrDN].oriH == self.images[_SkLk * 0xa + _FrDN - 0x1].oriH, "Height must be equal!") end
            end
        end
        return
    end
    error("Mode not supported!")
    self:SetSize()
end

function _5GVB:SetSize(_Lu0I, _FPKd)
    _Lu0I = _Lu0I or self.width
    _FPKd = _FPKd or self.height
    if self.mode == "slice13" then
        local _qqIw = self.images[0x1]
        local _MClY = self.images[0x2]
        local _2mHm = self.images[0x3]
        local _eS1b = math.min(self.texScale, math.min(_Lu0I / (_qqIw.oriW + _2mHm.oriW), _FPKd / _qqIw.oriH))
        local _Z2S5 = _qqIw.oriW * _eS1b
        local _NCT5 = _2mHm.oriW * _eS1b
        local _iMGh = math.max(0x0, _Lu0I - _Z2S5 - _NCT5)
        _qqIw:SetSize(_Z2S5, _FPKd)
        _MClY:SetSize(_iMGh, _FPKd)
        _2mHm:SetSize(_NCT5, _FPKd)
        local _nVJx = (_Z2S5 - _NCT5) / 0x2
        local _EXrH = -_Z2S5 / 0x2 - _iMGh / 0x2 + _nVJx
        local _vuqp = _NCT5 / 0x2 + _iMGh / 0x2 + _nVJx
        _qqIw:SetPosition(_EXrH, 0x0, 0x0)
        _MClY:SetPosition(_nVJx, 0x0, 0x0)
        _2mHm:SetPosition(_vuqp, 0x0, 0x0)
        self.width = _Z2S5 + _iMGh + _NCT5
        self.height = _FPKd
    elseif self.mode == "slice31" then
        local _9Xrs = self.images[0x1]
        local _UqJ2 = self.images[0x2]
        local _CZTN = self.images[0x3]
        local _6PAY = math.min(self.texScale, math.min(_FPKd / (_9Xrs.oriH + _CZTN.oriH), _Lu0I / _9Xrs.oriW))
        local _HNoa = _9Xrs.oriH * _6PAY
        local _6eKh = _CZTN.oriH * _6PAY
        local _MjSq = math.max(0x0, _FPKd - _HNoa - _6eKh)
        _9Xrs:SetSize(_Lu0I, _HNoa)
        _UqJ2:SetSize(_Lu0I, _MjSq)
        _CZTN:SetSize(_Lu0I, _6eKh)
        local _BuPE = (_HNoa - _6eKh) / 0x2
        local _LC5Z = -_HNoa / 0x2 - _MjSq / 0x2 + _BuPE
        local _kAk1 = _6eKh / 0x2 + _MjSq / 0x2 + _BuPE
        _9Xrs:SetPosition(0x0, _LC5Z, 0x0)
        _UqJ2:SetPosition(0x0, _BuPE, 0x0)
        _CZTN:SetPosition(0x0, _kAk1, 0x0)
        self.height = _HNoa + _MjSq + _6eKh
        self.width = _Lu0I
    elseif self.mode == "slice33" then
        local _dNOy = self.images
        local _b6BY = math.min(self.texScale, math.min(_Lu0I / (_dNOy[0xb].oriW + _dNOy[0xd].oriW), _FPKd / (_dNOy[0xb].oriH + _dNOy[0x1f].oriH)))
        local _wD9S, hs, xs, ys = {}, {}, {}, {}
        _wD9S[0x1] = _dNOy[0xb].oriW * _b6BY
        _wD9S[0x3] = _dNOy[0xd].oriW * _b6BY
        _wD9S[0x2] = math.max(0x0, _Lu0I - _wD9S[0x1] - _wD9S[0x3])
        hs[0x1] = _dNOy[0xb].oriH * _b6BY
        hs[0x3] = _dNOy[0x1f].oriH * _b6BY
        hs[0x2] = math.max(0x0, _FPKd - hs[0x1] - hs[0x3])
        xs[0x2] = (_wD9S[0x1] - _wD9S[0x3]) / 0x2
        xs[0x1] = -_wD9S[0x1] / 0x2 - _wD9S[0x2] / 0x2 + xs[0x2]
        xs[0x3] = _wD9S[0x3] / 0x2 + _wD9S[0x2] / 0x2 + xs[0x2]
        ys[0x2] = (hs[0x1] - hs[0x3]) / 0x2
        ys[0x1] = -hs[0x1] / 0x2 - hs[0x2] / 0x2 + ys[0x2]
        ys[0x3] = hs[0x3] / 0x2 + hs[0x2] / 0x2 + ys[0x2]
        for _gqt4 = 0x1, 0x3 do
            for _mkPL = 0x1, 0x3 do
                _dNOy[_gqt4 * 0xa + _mkPL]:SetSize(_wD9S[_mkPL], hs[_gqt4])
                _dNOy[_gqt4 * 0xa + _mkPL]:SetPosition(xs[_mkPL], ys[_gqt4], 0x0)
            end
        end
        self.width = _wD9S[0x1] + _wD9S[0x2] + _wD9S[0x3]
        self.height = hs[0x1] + hs[0x2] + hs[0x3]
    end
end

function _5GVB:GetSize() return self.width, self.height end

function _5GVB:SetTint(_IsBh, _jpbD, _TKNg, _Cw6t) for _zmfQ, _S337 in pairs(self.images) do _S337:SetTint(_IsBh, _jpbD, _TKNg, _Cw6t) end end

function _5GVB:SetClickable(_u7xv) for _jbNa, _VJtU in pairs(self.images) do _VJtU:SetClickable(_u7xv) end end

local _lHoW = Class(_Rjh5,
    function(_47fW, _Z3pU)
        _Rjh5._ctor(_47fW, "DYC_TextHealthbar")
        _47fW.text = _47fW:AddChild(_wipt(NUMBERFONT, 0x14, ""))
        _47fW.c1 = _Z3pU.c1 or "="
        _47fW.c2 = _Z3pU.c2 or "#"
        _47fW.cnum = _Z3pU.cnum or 0xa
        _47fW.numCoeff = _Z3pU.numCoeff or 0x1
        _47fW.percentage = 0x1
        _47fW.fontSize = _Z3pU.fontSize or 0x14
        _47fW.hbScale = _Z3pU.hbScale or 0x1
        _47fW:SetPercentage()
        _47fW:SetHBScale()
        if _Z3pU.color then _47fW:SetTextColor(_Z3pU.color) end
    end)
function _lHoW:SetStrings(_taE9, _e93O, _zDWm)
    _taE9 = _taE9 or self.c1; _e93O = _e93O or self.c2; _zDWm = _zDWm or self.cnum; _zDWm = math.max(0x1, _zDWm)
    self.c1 = _taE9; self.c2 = _e93O; self.cnum = _zDWm; self:SetPercentage()
end

function _lHoW:SetLength(_1QuS)
    _1QuS = _1QuS or self.cnum
    self.cnum = _1QuS
    self:SetPercentage()
end

function _lHoW:SetPercentage(_7Nv2)
    _7Nv2 = _7Nv2 or self.percentage
    _7Nv2 = math.max(0x0, math.min(_7Nv2, 0x1))
    self.percentage = _7Nv2
    local _dmh2 = self.c1
    local _8sWU = self.c2
    local _YhhB = self.cnum * self.numCoeff
    local _RNbj = ""
    for _GN5W = 0x1, _YhhB do if _7Nv2 == 0x0 or (_GN5W ~= 0x1 and _GN5W * 1.0 / _YhhB > _7Nv2) then _RNbj = _RNbj .. _dmh2 else _RNbj = _RNbj .. _8sWU end end
    self.text:SetString(_RNbj)
end

function _lHoW:SetFontSize(_POvR)
    _POvR = _POvR or self.fontSize
    self.fontSize = _POvR
    self.text:SetSize(self.fontSize * self.hbScale)
end

function _lHoW:SetHBScale(_Uc5n)
    _Uc5n = _Uc5n or self.hbScale
    self.hbScale = _Uc5n
    self:SetFontSize()
end

function _lHoW:SetColor(_NwYm, _IwRh, _3MbW, _mj0r)
    _NwYm = _NwYm or 0x1
    _IwRh = _IwRh or 0x1
    _3MbW = _3MbW or 0x1
    _mj0r = _mj0r or 0x1
    if type(_NwYm) == "table" then
        _NwYm.r = _NwYm.r or _NwYm.x or _NwYm[0x1] or 0x1
        _NwYm.g = _NwYm.g or _NwYm.y or _NwYm[0x2] or 0x1
        _NwYm.b = _NwYm.b or _NwYm.z or _NwYm[0x3] or 0x1
        _NwYm.a = _NwYm.a or _NwYm[0x1] or 0x1
        self.text:SetColour(_NwYm.r, _NwYm.g, _NwYm.b, _NwYm.a)
    else
        self.text:SetColour(_NwYm, _IwRh, _3MbW, _mj0r)
    end
end

local _vvEo = Class(_Rjh5,
    function(_Pklu, _SIny)
        _Rjh5._ctor(_Pklu, "DYC_GraphicHealthbar")
        _Pklu:SetScaleMode(_SIny.isDemo and SCALEMODE_NONE or SCALEMODE_PROPORTIONAL)
        _Pklu:SetMaxPropUpscale(0x3e7)
        _Pklu.worldOffset = Vector3(0x0, 0x0, 0x0)
        _Pklu.screen_offset = Vector3(0x0, 0x0, 0x0)
        _Pklu.isDemo = _SIny.isDemo
        _Pklu.bg = _Pklu:AddChild(_hGR4(_SIny.basic.atlas, _SIny.basic.texture))
        _Pklu.bg:SetClickable(_Pklu.isDemo or false)
        _Pklu.bg2 = _Pklu:AddChild(_hGR4(_SIny.basic.atlas, _SIny.basic.texture))
        _Pklu.bg2:SetClickable(_Pklu.isDemo or false)
        _Pklu.text = _Pklu:AddChild(_wipt(NUMBERFONT, 0x14, ""))
        _Pklu.healthReductions = {}
        _Pklu.style = "textonbar"
        _Pklu.showBg = true
        _Pklu.showBg2 = true
        _Pklu.showValue = true
        _Pklu.hp = 0x64
        _Pklu.hpMax = 0x64
        _Pklu.percentage = 0x1
        _Pklu.opacity = 0x1
        _Pklu.hbScale = 0x1
        _Pklu.hbYOffset = 0x0
        _Pklu.hbWidth = 0x78
        _Pklu.hbHeight = 0x12
        _Pklu.barMargin = { x1 = 0x3, x2 = 0x3, y1 = 0x3, y2 = 0x3, fixed = true }
        _Pklu.fontSize = 0x14
        _Pklu.hrDuration = 0.8
        _Pklu.screenWidth = 0x780
        _Pklu.screenHeight = 0x438
        _Pklu.bgColor = _uo5E(0x1, 0x1, 0x1)
        _Pklu.bg2Color = _uo5E(0x0, 0x0, 0x0)
        _Pklu.barColor = _uo5E(0x1, 0x1, 0x1)
        _Pklu.hrColor = _uo5E(0x1, 0x1, 0x1)
        _Pklu.preUpdateFn = nil
        _Pklu.onSetPercentage = nil
        _Pklu:SetData(_SIny)
        _Pklu:SetOpacity()
        _Pklu:SetHBSize(0x78, 0x12)
        _Pklu:SetFontSize(0x14)
        _Pklu:StartUpdating()
        _Pklu:AddToTable()
    end)
_vvEo.ghbs = {}
function _vvEo:AddToTable() _cfwZ(_vvEo.ghbs, self) end

function _vvEo:SetData(_0zh5)
    self.data = _0zh5
    self.basicAtlas = _0zh5.basic.atlas
    self.basicTex = _0zh5.basic.texture
    self.bgAtlas = _0zh5.bg and _0zh5.bg.atlas
    self.bgTex = _0zh5.bg and _0zh5.bg.texture
    self.barAtlas = _0zh5.bar and _0zh5.bar.atlas
    self.barTex = _0zh5.bar and _0zh5.bar.texture
    self:SetBgSkn(_0zh5.bgSkn)
    self:SetBarSkn(_0zh5.barSkn)
end

function _vvEo:SetBgTexture(_wJgB, _s52u)
    self.bg:SetTexture(_wJgB, _s52u)
    self.bg2:SetTexture(_wJgB, _s52u)
end

function _vvEo:SetBgSkn(_63q4)
    self.bgSknData = _63q4 or nil
    if self.bgSkn then
        self.bgSkn:Kill()
        self.bgSkn = nil
    end
    if self.bgSknData then
        self.bgSkn = self:AddChild(_5GVB(self.bgSknData))
        self.bgSkn:SetClickable(self.isDemo or false)
        self.bgSkn:MoveToBack()
        self.showBg = false
    else
        self:SetBgTexture(self.bgAtlas or self.basicAtlas, self.bgTex or self.basicTex)
        self.showBg = true
    end
    if self.data and (self.data.bg2 or not self.data.bg) then self.showBg2 = true else self.showBg2 = false end
    self.bgColor = self.data and self.data.bg and self.data.bg.color or _uo5E(0x1, 0x1, 0x1)
    self.bg2Color = self.data and self.data.bg2 and self.data.bg2.color or _uo5E(0x0, 0x0, 0x0)
end

function _vvEo:SetBarSkn(_LiJG)
    self.barSknData = _LiJG or nil
    if self.bar then
        self.bar:Kill()
        self.bar = nil
    end
    if self.barSknData then
        self.bar = self:AddChild(_5GVB(self.barSknData))
        self.bar:SetClickable(self.isDemo or false)
        self.bar:MoveToFront()
        self.text:MoveToFront()
    else
        self.bar = self:AddChild(_hGR4(self.barAtlas or self.basicAtlas, self.barTex or self.basicTex))
        self.bar:SetClickable(self.isDemo or false)
        self.bar:MoveToFront()
        self.text:MoveToFront()
    end
end

function _vvEo:SetBarTexture(_Xdwz, _HRHD) if self.bar.SetTexture then self.bar:SetTexture(_Xdwz, _HRHD) end end

function _vvEo:SetValue(_lED9, _jsqD, _EgzN)
    self.hp = _lED9 or self.hp
    self.hpMax = _jsqD or self.hpMax
    self.text:SetString(string.format("%d/%d", _lED9, _jsqD))
    self:SetPercentage(_lED9 / _jsqD, _EgzN)
end

function _vvEo:SetYOffSet(_cy9A, _CjrV)
    _cy9A = _cy9A or self.hbYOffset
    self.hbYOffset = _cy9A
    local _4qSJ = self.screenWidth / 0x780
    self:SetScreenOffset(-0x5 * _4qSJ, self.hbYOffset * (_CjrV and self.hbScale or 0x1) * _4qSJ)
end

function _vvEo:SetPercentage(_9QKX, _dRxP)
    local _bNpX = self.percentage
    _9QKX = _9QKX or self.percentage
    _9QKX = math.max(0x0, math.min(_9QKX, 0x1))
    if _bNpX - _9QKX > 0.01 and not _dRxP and self.shown then self:DisplayHealthReduction(_bNpX, _9QKX) end
    self.percentage = _9QKX
    local _B2kN, h = self:GetSize()
    local _NWzF, barH = self:GetBarFullSize()
    local _S6Dz, barVH = self:GetBarVirtualSize()
    local _e56y = _NWzF - _S6Dz * (0x1 - _9QKX)
    local _zWI4, oy = self:GetBarOffset()
    self.bar:SetSize(_e56y, barH)
    self.bar:SetPosition(-(_NWzF - _e56y) / 0x2 + _zWI4, oy, 0x0)
    if self.textHealthBar then self.textHealthBar:SetPercentage(_9QKX) end
    if self.onSetPercentage then self.onSetPercentage(self, _9QKX) end
end

function _vvEo:SetHBSize(_W4aD, _RDAW)
    _W4aD = _W4aD or self.hbWidth
    _RDAW = _RDAW or self.hbHeight
    _W4aD = math.max(_W4aD, 0x0)
    _RDAW = math.max(_RDAW, 0x0)
    self.hbWidth = _W4aD
    self.hbHeight = _RDAW
    _W4aD = _W4aD * self.hbScale
    _RDAW = _RDAW * self.hbScale
    self.bg:SetSize(_W4aD, _RDAW)
    self.bg2:SetSize(math.max(_W4aD - 0x2, 0x0), math.max(_RDAW - 0x2, 0x0))
    if self.bgSknData and self.bgSkn then
        local _SUMz, bgh = self:GetBgSknSize()
        self.bgSkn:SetSize(_SUMz, bgh)
        local _il8K, oy = self:GetBgOffset()
        self.bgSkn:SetPosition(_il8K, oy, 0x0)
    end
    self:SetPercentage()
    self:SetYOffSet()
    if self.textHealthBar then self.textHealthBar:SetFontSize(self.hbHeight * 0x1) end
end

function _vvEo:SetFontSize(_8Oih)
    _8Oih = _8Oih or self.fontSize
    self.fontSize = _8Oih
    self.text:SetSize(self.fontSize * self.hbScale)
    local _1n0d, h = self:GetSize()
    if self.style == "textoverbar" then
        self.text:SetPosition(0x0, h / 0x2 + self.fontSize * self.hbScale * 0.35, 0x0)
    elseif self.style == "barovertext" then
        self.text:SetPosition(0x0,
            -h / 0x2 - self.fontSize * self.hbScale * 0.35, 0x0)
    else
        self.text:SetPosition(0x0, 0x0, 0x0)
    end
end

function _vvEo:SetHBScale(_mlSh)
    _mlSh = _mlSh or self.hbScale
    self.hbScale = _mlSh
    self:SetHBSize()
    self:SetFontSize()
    if self.textHealthBar then self.textHealthBar:SetHBScale(_mlSh) end
end

function _vvEo:SetStyle(_V9po)
    _V9po = _V9po or self.style
    if _V9po == self.style then return end
    self.style = _V9po
    self:SetFontSize()
end

function _vvEo:SetOpacity(_evbH)
    _evbH = _evbH or self.opacity
    self.opacity = _evbH
    local _2R6j = self.bgColor
    self.bg:SetTint(_2R6j.r, _2R6j.g, _2R6j.b, self.showBg and _evbH or 0x0)
    _2R6j = self.bg2Color
    self.bg2:SetTint(_2R6j.r, _2R6j.g, _2R6j.b, self.showBg and self.showBg2 and _evbH or 0x0)
    _2R6j = self.barColor
    self.bar:SetTint(_2R6j.r, _2R6j.g, _2R6j.b, _evbH)
    if self.bgSkn then self.bgSkn:SetTint(0x1, 0x1, 0x1, _evbH) end
end

function _vvEo:SetBarColor(_vMW8, _teq2, _7wzV)
    _vMW8 = _vMW8 or 0x1
    _teq2 = _teq2 or 0x1
    _7wzV = _7wzV or 0x1
    if type(_vMW8) == "table" then
        self.barColor.r = _vMW8.r or _vMW8.x or _vMW8[0x1] or 0x1
        self.barColor.g = _vMW8.g or _vMW8.y or _vMW8[0x2] or 0x1
        self.barColor.b = _vMW8.b or _vMW8.z or _vMW8[0x3] or 0x1
    else
        self.barColor.r = _vMW8
        self.barColor.g = _teq2
        self.barColor.b = _7wzV
    end
    self:SetOpacity()
    if self.textHealthBar then self.textHealthBar:SetColor(_vMW8, _teq2, _7wzV) end
end

function _vvEo:SetTextColor(_NAdI, _d7qG, _UtbS, _ExuX)
    _NAdI = _NAdI or 0x1
    _d7qG = _d7qG or 0x1
    _UtbS = _UtbS or 0x1
    _ExuX = _ExuX or 0x1
    if type(_NAdI) == "table" then
        _NAdI.r = _NAdI.r or _NAdI.x or _NAdI[0x1] or 0x1
        _NAdI.g = _NAdI.g or _NAdI.y or _NAdI[0x2] or 0x1
        _NAdI.b = _NAdI.b or _NAdI.z or _NAdI[0x3] or 0x1
        _NAdI.a = _NAdI.a or _NAdI[0x1] or 0x1
        self.text:SetColour(_NAdI.r, _NAdI.g, _NAdI.b, _NAdI.a)
    else
        self.text:SetColour(_NAdI, _d7qG, _UtbS, _ExuX)
    end
end

function _vvEo:DisplayHealthReduction(_kARq, _S9Wo)
    local _A2Ti = self.bg2:AddChild(_hGR4(self.basicAtlas, self.basicTex))
    _A2Ti:SetClickable(self.isDemo or false)
    local _50ky, h = self:GetSize()
    local _KEKO, h2 = self:GetBarVirtualSize()
    local _rCE5 = _KEKO * math.max(0x0, _kARq - _S9Wo)
    local _Bzyc = ((_S9Wo + _kARq) / 0x2 - 0.5) * _KEKO
    local _KeD5, oy = self:GetBarVirtualOffset()
    local _UCRG = self.data and self.data.hrUseBarColor and self.barColor or self.hrColor
    _A2Ti:SetSize(_rCE5, h2)
    _A2Ti:SetPosition(_Bzyc + _KeD5, oy, 0x0)
    _A2Ti:SetTint(_UCRG.r, _UCRG.g, _UCRG.b, self.opacity)
    _A2Ti.fadeTimer = self.hrDuration
    table.insert(self.healthReductions, _A2Ti)
end

function _vvEo:AnimateIn(_OidO)
    self.animHBWidth = self.hbWidth
    self.animIn = true
    self.animSpeed = _OidO or 0x5
    self:SetHBSize(0x0, self.hbHeight)
end

function _vvEo:AnimateOut(_OZik)
    self.animHBWidth = 0x0
    self.animOut = true
    self.animSpeed = _OZik or 0x5
end

function _vvEo:Kill()
    _s2FW(_vvEo.ghbs, self)
    _Rjh5.Kill(self)
end

function _vvEo:OnMouseButton(_niK4, _jNia, _WPGR, _6WZs, ...)
    local _KUNw = _vvEo._base.OnMouseButton(self, _niK4, _jNia, _WPGR, _6WZs, ...)
    if not _jNia and _niK4 == MOUSEBUTTON_LEFT then self.dragging = false end
    if not self.focus then return false end
    if self.isDemo and _jNia and _niK4 == MOUSEBUTTON_LEFT then self.dragging = true end
    return _KUNw
end

function _vvEo:GetSize()
    local _yXxD, h = self.bg:GetSize()
    _yXxD = _yXxD or 0x1
    h = h or 0x1
    return _yXxD, h
end

function _vvEo:GetBgMargin()
    local _iNTB, h = self:GetSize()
    local _A69C = self.bgSknData and self.bgSknData.margin or (self.data and self.data.bg and self.data.bg.margin) or { x1 = 0x0, x2 = 0x0, y1 = 0x0, y2 = 0x0, }
    local _utSt = _A69C.fixed and _A69C.x1 or _A69C.x1 * h
    local _ZD27 = _A69C.fixed and _A69C.x2 or _A69C.x2 * h
    local _5Cie = _A69C.fixed and _A69C.y1 or _A69C.y1 * h
    local _6aJ2 = _A69C.fixed and _A69C.y2 or _A69C.y2 * h
    return _utSt, _ZD27, _5Cie, _6aJ2
end

function _vvEo:GetBarMargin()
    local _tVd4, h = self:GetSize()
    local _lVWz = self.barSknData and self.barSknData.margin or (self.data and self.data.bar and self.data.bar.margin) or self.barMargin
    local _UhWF = _lVWz.fixed and _lVWz.x1 or _lVWz.x1 * h
    local _3RJ0 = _lVWz.fixed and _lVWz.x2 or _lVWz.x2 * h
    local _PdxN = _lVWz.fixed and _lVWz.y1 or _lVWz.y1 * h
    local _eFCg = _lVWz.fixed and _lVWz.y2 or _lVWz.y2 * h
    return _UhWF, _3RJ0, _PdxN, _eFCg
end

function _vvEo:GetBarVirtualMargin()
    local _1PB5, h = self:GetSize()
    local _OsGi = self.barSknData and self.barSknData.vmargin or (self.data and self.data.bar and self.data.bar.vmargin) or (self.barSknData and self.barSknData.margin) or
        (self.data and self.data.bar and self.data.bar.margin) or self.barMargin
    local _e1iP = _OsGi.fixed and _OsGi.x1 or _OsGi.x1 * h
    local _2fqI = _OsGi.fixed and _OsGi.x2 or _OsGi.x2 * h
    local _HsIR = _OsGi.fixed and _OsGi.y1 or _OsGi.y1 * h
    local _Rxeo = _OsGi.fixed and _OsGi.y2 or _OsGi.y2 * h
    return _e1iP, _2fqI, _HsIR, _Rxeo
end

function _vvEo:GetBgOffset()
    local _3sy2, mx2, my1, my2 = self:GetBgMargin()
    return (_3sy2 - mx2) / 0x2, (my1 - my2) / 0x2
end

function _vvEo:GetBarOffset()
    local _M6YX, mx2, my1, my2 = self:GetBarMargin()
    return (_M6YX - mx2) / 0x2, (my1 - my2) / 0x2
end

function _vvEo:GetBarVirtualOffset()
    local _s6dF, px2, py1, py2 = self:GetBarVirtualMargin()
    return (_s6dF - px2) / 0x2, (py1 - py2) / 0x2
end

function _vvEo:GetBgSknSize()
    local _u0UB, h = self:GetSize()
    local _KNBc, mx2, my1, my2 = self:GetBgMargin()
    return math.max(_u0UB - _KNBc - mx2, 0x2), math.max(h - my1 - my2, 0x2)
end

function _vvEo:GetBarFullSize()
    local _J48K, h = self:GetSize()
    local _XYgV, mx2, my1, my2 = self:GetBarMargin()
    return math.max(_J48K - _XYgV - mx2, 0x2), math.max(h - my1 - my2, 0x2)
end

function _vvEo:GetBarVirtualSize()
    local _7UzD, h = self:GetSize()
    local _Lmcw, px2, py1, py2 = self:GetBarVirtualMargin()
    return math.max(_7UzD - _Lmcw - px2, 0x0), math.max(h - py1 - py2, 0x0)
end

function _vvEo:SetTarget(_4OFh)
    self.target = _4OFh
    self:OnUpdate()
end

function _vvEo:SetWorldOffset(_cuw5)
    self.worldOffset = _cuw5
    self:OnUpdate()
end

function _vvEo:SetScreenOffset(_cUoR, _Iggd)
    self.screen_offset.x = _cUoR
    self.screen_offset.y = _Iggd
    self:OnUpdate()
end

function _vvEo:GetScreenOffset() return self.screen_offset.x, self.screen_offset.y end

function _vvEo:OnUpdate(_6bP8)
    _6bP8 = _6bP8 or 0x0
    if self.target and self.target:IsValid() then
        if self.preUpdateFn then self.preUpdateFn(_6bP8) end
        local _uYfY = nil
        if self.target.AnimState then
            _uYfY = Vector3(self.target.AnimState:GetSymbolPosition(self.symbol or "", self.worldOffset.x, self.worldOffset.y, self.worldOffset.z))
        else
            _uYfY = self.target
                :GetPosition()
        end
        if _uYfY then
            local _0dZH = Vector3(TheSim:GetScreenPos(_uYfY:Get()))
            _0dZH.x = _0dZH.x + self.screen_offset.x
            _0dZH.y = _0dZH.y + self.screen_offset.y
            self:SetPosition(_0dZH)
        end
    end
    if self.animOut and _6bP8 > 0x0 then
        if math.abs(self.hbWidth - self.animHBWidth) < 0x3 then
            self.animOut = false
            self:SetHBSize(self.animHBWidth, self.hbHeight)
            self:Kill()
            return
        else
            self:SetHBSize(_m8CL(self.hbWidth, self.animHBWidth, self.animSpeed * _6bP8), self.hbHeight)
        end
    elseif self.animIn and _6bP8 > 0x0 then
        if math.abs(self.hbWidth - self.animHBWidth) < 0x1 then
            self.animIn = false
            self:SetHBSize(self.animHBWidth, self.hbHeight)
        else
            self:SetHBSize(_m8CL(self.hbWidth, self.animHBWidth, self.animSpeed * _6bP8), self.hbHeight)
        end
    end
    local _HJ4h = self.healthReductions
    if #_HJ4h > 0x0 and _6bP8 > 0x0 then
        for _XyH6 = #_HJ4h, 0x1, -0x1 do
            local _it9o = _HJ4h[_XyH6]
            _it9o.fadeTimer = _it9o.fadeTimer - _6bP8
            if _it9o.fadeTimer < 0x0 then
                table.remove(_HJ4h, _XyH6)
                _it9o:Kill()
                break
            end
            local _IcHc = self.data and self.data.hrUseBarColor and self.barColor or self.hrColor
            _it9o:SetTint(_IcHc.r, _IcHc.g, _IcHc.b, self.opacity * _it9o.fadeTimer / self.hrDuration)
        end
    end
    if self.showValue and not self.text.shown then self.text:Show() elseif not self.showValue and self.text.shown then self.text:Hide() end
    local _Kyn0, sh = TheSim:GetScreenSize()
    if _Kyn0 ~= self.screenWidth or sh ~= self.screenHeight then
        self.screenWidth = _Kyn0
        self.screenHeight = sh
        self:SetYOffSet()
    end
    if self.isDemo and self.dragging and _6bP8 > 0x0 then
        local _NvHK = self:GetScale()
        local _Hecf, y = TheInput:GetScreenPosition():Get()
        local _IRr9 = self:GetWorldPosition()
        local _FYyD, barH = self:GetBarVirtualSize()
        _FYyD = _FYyD * _NvHK.x
        barH = barH * _NvHK.y
        local _0g3j, oy = self:GetBarVirtualOffset()
        _0g3j = _0g3j * _NvHK.x
        oy = oy * _NvHK.y
        local _Ij5M = (_Hecf - (_IRr9.x + _0g3j) + _FYyD / 0x2) / _FYyD
        self:SetPercentage(_Ij5M, true)
        if not self.focus then self.dragging = false end
    end
end

return _vvEo
