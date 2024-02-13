local function _iwq3() return GLOBAL.TheSim:GetGameID() == "DST" end
local function _4BNu() return _iwq3() and GLOBAL.TheNet:GetIsClient() end
local function _HYMM() if _iwq3() then return GLOBAL.ThePlayer else return GLOBAL.GetPlayer() end end
local function _aWci() if _iwq3() then return GLOBAL.TheWorld else return GLOBAL.GetWorld() end end
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
local _gAlQ = function(_mYbz, _Buge, _eOK3, _7Iap)
    return {
        r = _mYbz or 0x1,
        g = _Buge or 0x1,
        b = _eOK3 or 0x1,
        a = _7Iap or 0x1,
        Get = function(_c0iF) return _c0iF.r, _c0iF.g, _c0iF.b, _c0iF.a end,
        Set = function(
            _8H1L, _lgRB, _3r8c, _GMKu, _v1BJ)
            _8H1L.r = _lgRB or 0x1; _8H1L.g = _3r8c or 0x1; _8H1L.b = _GMKu or 0x1; _8H1L.a = _v1BJ or 0x1;
        end,
    }
end
local _uJp3 = {
    New = _gAlQ,
    Red = _gAlQ(0x1, 0x0, 0x0, 0x1),
    Green = _gAlQ(0x0, 0x1, 0x0, 0x1),
    Blue = _gAlQ(0x0, 0x0, 0x1, 0x1),
    White = _gAlQ(0x1, 0x1, 0x1, 0x1),
    Black = _gAlQ(0x0, 0x0, 0x0, 0x1),
    Yellow =
        _gAlQ(0x1, 0x1, 0x0, 0x1),
    Magenta = _gAlQ(0x1, 0x0, 0x1, 0x1),
    Cyan = _gAlQ(0x0, 0x1, 0x1, 0x1),
    Gray = _gAlQ(0.5, 0.5, 0.5, 0x1),
    Orange = _gAlQ(0x1, 0.5, 0x0, 0x1),
    Purple = _gAlQ(0.5, 0x0, 0x1, 0x1),
    GetColor = function(
        _nTOC, _WXgq)
        if _WXgq == nil then return end
        for _sQSP, _6zou in pairs(_nTOC) do if type(_6zou) == "table" and _6zou.r then if string.lower(_sQSP) == string.lower(_WXgq) then return _6zou end end end
    end,
}
local function _NPlW()
    if not _aWci() then return end
    TUNING.DYC_HEALTHBAR_FORCEUPDATE = true
    _aWci():DoTaskInTime(GLOBAL.FRAMES * 0x4, function() TUNING.DYC_HEALTHBAR_FORCEUPDATE = false end)
end
GLOBAL.SHB = {}
GLOBAL.shb = GLOBAL.SHB
GLOBAL.SimpleHealthBar = GLOBAL.SHB
local _PHxu = GLOBAL.SHB
local _7P3k = GLOBAL.SHB
_PHxu.version = modinfo.version
_PHxu.Color = _uJp3
_PHxu.ShowBanner = function() end
_PHxu.PushBanner = function() end
_PHxu.SetColor = function(_yIkz, _r7yC, _BoPg)
    if _yIkz and type(_yIkz) == "string" then
        if _yIkz == "cfg" then
            _PHxu.SetColor(TUNING.DYC_HEALTHBAR_COLOR_CFG)
            return
        end
        local _lRUZ = string.lower(_yIkz)
        for _45y6, _Mg6P in pairs(_uJp3) do
            if string.lower(_45y6) == _lRUZ and type(_Mg6P) == "table" then
                TUNING.DYC_HEALTHBAR_COLOR = _Mg6P
                _NPlW()
                return
            end
        end
    elseif _yIkz and _r7yC and _BoPg and type(_yIkz) == "number" and type(_r7yC) == "number" and type(_BoPg) == "number" then
        TUNING.DYC_HEALTHBAR_COLOR = _uJp3.New(_yIkz, _r7yC, _BoPg)
        _NPlW()
        return
    end
    TUNING.DYC_HEALTHBAR_COLOR = _yIkz
    _NPlW()
end
_PHxu.setcolor = _PHxu.SetColor
_PHxu.SETCOLOR = _PHxu.SetColor
_PHxu.SetLength = function(_xDoP)
    _xDoP = _xDoP or 0xa
    if type(_xDoP) ~= "number" then if _xDoP == "cfg" then _xDoP = TUNING.DYC_HEALTHBAR_CNUM_CFG else _xDoP = 0xa end end
    _xDoP = math.floor(_xDoP)
    if _xDoP < 0x1 then _xDoP = 0x1 end
    if _xDoP > 0x64 then _xDoP = 0x64 end
    TUNING.DYC_HEALTHBAR_CNUM = _xDoP
    _NPlW()
end
_PHxu.setlength = _PHxu.SetLength
_PHxu.SETLENGTH = _PHxu.SetLength
_PHxu.SetDuration = function(_vuFg)
    _vuFg = _vuFg or 0x8
    if type(_vuFg) ~= "number" then _vuFg = 0x8 end
    if _vuFg < 0x4 then _vuFg = 0x4 end
    if _vuFg > 0xf423f then _vuFg = 0xf423f end
    TUNING.DYC_HEALTHBAR_DURATION = _vuFg
end
_PHxu.setduration = _PHxu.SetDuration
_PHxu.SETDURATION = _PHxu.SetDuration
_PHxu.SetStyle = function(_352T, _Gtx8, _bW3z)
    if _352T and _Gtx8 and type(_352T) == "string" and type(_Gtx8) == "string" then
        TUNING.DYC_HEALTHBAR_STYLE = { c1 = _352T, c2 = _Gtx8 }
    elseif _352T == "cfg" then
        TUNING.DYC_HEALTHBAR_STYLE =
            TUNING.DYC_HEALTHBAR_STYLE_CFG
    else
        if _bW3z == "c" then
            TUNING.DYC_HEALTHBAR_STYLE_CHAR = _352T and string.lower(_352T) or nil
        elseif _bW3z == "b" then
            TUNING.DYC_HEALTHBAR_STYLE_BOSS = _352T and string.lower(_352T) or nil
        else
            TUNING.DYC_HEALTHBAR_STYLE =
                _352T and string.lower(_352T) or "standard"
        end
        local _9fL8 = _352T and GLOBAL["SimpleHealthBar"]["lib"]["TableContains"](GLOBAL["SimpleHealthBar"][GLOBAL["SimpleHealthBar"]["ds"]("{xmkqitPJ{")], _352T)
        if _9fL8 then GLOBAL["SimpleHealthBar"]["GetUData"](_352T, function(_XIAc) if not _XIAc then GLOBAL["SimpleHealthBar"]["SetStyle"]("standard", nil, _bW3z) end end) end
    end
    _NPlW()
    if _PHxu.onUpdateHB then _PHxu.onUpdateHB(_352T, _Gtx8) end
end
_PHxu.setstyle = _PHxu.SetStyle
_PHxu.SETSTYLE = _PHxu.SetStyle
local function _r7Ir(_MEbY, _TSgh) if _MEbY == "global" then _PHxu.SetStyle(nil, nil, "c") else _PHxu.SetStyle(_MEbY, _TSgh, "c") end end
_PHxu.SetPos = function(_TImp)
    if _TImp and string.lower(_TImp) == "bottom" then
        TUNING.DYC_HEALTHBAR_POSITION = 0x0
    elseif _TImp and string.lower(_TImp) == "overhead2" then
        TUNING.DYC_HEALTHBAR_POSITION = 0x2
    elseif _TImp == "cfg" then
        TUNING.DYC_HEALTHBAR_POSITION =
            TUNING.DYC_HEALTHBAR_POSITION_CFG
    else
        TUNING.DYC_HEALTHBAR_POSITION = 0x1
    end
    _NPlW()
end
_PHxu.setpos = _PHxu.SetPos
_PHxu.SETPOS = _PHxu.SetPos
_PHxu.SetPosition = _PHxu.SetPos
_PHxu.setposition = _PHxu.SetPos
_PHxu.SETPOSITION = _PHxu.SetPos
_PHxu.ValueOn = function()
    TUNING.DYC_HEALTHBAR_VALUE = true
    _NPlW()
end
_PHxu.valueon = _PHxu.ValueOn
_PHxu.VALUEON = _PHxu.ValueOn
_PHxu.ValueOff = function()
    TUNING.DYC_HEALTHBAR_VALUE = false
    _NPlW()
end
_PHxu.valueoff = _PHxu.ValueOff
_PHxu.VALUEOFF = _PHxu.ValueOff
_PHxu.DDOn = function() TUNING.DYC_HEALTHBAR_DDON = true end
_PHxu.ddon = _PHxu.DDOn
_PHxu.DDON = _PHxu.DDOn
_PHxu.DDOff = function() TUNING.DYC_HEALTHBAR_DDON = false end
_PHxu.ddoff = _PHxu.DDOff
_PHxu.DDOFF = _PHxu.DDOff
_PHxu.SetLimit = function(_ZatL)
    _ZatL = _ZatL or 0x0
    _ZatL = math.floor(_ZatL)
    TUNING.DYC_HEALTHBAR_LIMIT = _ZatL
    if TUNING.DYC_HEALTHBAR_LIMIT > 0x0 then
        while #_PHxu.hbs > TUNING.DYC_HEALTHBAR_LIMIT do
            local _Iz50 = _PHxu.hbs[0x1]
            table.remove(_PHxu.hbs, 0x1)
            _Iz50:Remove()
        end
    end
end
_PHxu.setlimit = _PHxu.SetLimit
_PHxu.SETLIMIT = _PHxu.SetLimit
_PHxu.SetOpacity = function(_nHQr)
    _nHQr = _nHQr or 0x1
    _nHQr = math.max(0.1, math.min(_nHQr, 0x1))
    TUNING.DYC_HEALTHBAR_OPACITY = _nHQr
    if _PHxu.onUpdateHB then _PHxu.onUpdateHB(str, str2) end
end
_PHxu.setopacity = _PHxu.SetOpacity
_PHxu.SETOPACITY = _PHxu.SetOpacity
_PHxu.ToggleAnimation = function(_2q2X) TUNING.DYC_HEALTHBAR_ANIMATION = _2q2X and true or false end
_PHxu.toggleanimation = _PHxu.ToggleAnimation
_PHxu.TOGGLEANIMATION = _PHxu.ToggleAnimation
_PHxu.ToggleWallHB = function(_4DZ5) TUNING.DYC_HEALTHBAR_WALLHB = _4DZ5 and true or false end
_PHxu.togglewallhb = _PHxu.ToggleWallHB
_PHxu.TOGGLEWALLHB = _PHxu.ToggleWallHB
_PHxu.SetThickness = function(_xLhb)
    _xLhb = _xLhb ~= nil and type(_xLhb) == "number" and _xLhb or 1.0
    TUNING.DYC_HEALTHBAR_THICKNESS = _xLhb
    if _xLhb > 0x2 then TUNING.DYC_HEALTHBAR_FIXEDTHICKNESS = true else TUNING.DYC_HEALTHBAR_FIXEDTHICKNESS = false end
end
_PHxu.setthickness = _PHxu.SetThickness
_PHxu.SETTHICKNESS = _PHxu.SetThickness
TUNING.DYC_HEALTHBAR_STYLE = GetModConfigData("hbstyle") or "standard"
TUNING.DYC_HEALTHBAR_STYLE_CFG = TUNING.DYC_HEALTHBAR_STYLE
TUNING.DYC_HEALTHBAR_CNUM = GetModConfigData("hblength") or 0xa
TUNING.DYC_HEALTHBAR_CNUM_CFG = TUNING.DYC_HEALTHBAR_CNUM
TUNING.DYC_HEALTHBAR_DURATION = 0x8
TUNING.DYC_HEALTHBAR_POSITION = GetModConfigData("hbpos") or "overhead"
TUNING.DYC_HEALTHBAR_POSITION_CFG = TUNING.DYC_HEALTHBAR_POSITION
TUNING.DYC_HEALTHBAR_VALUE = GetModConfigData("value") or (GetModConfigData("value") == nil and true)
TUNING.DYC_HEALTHBAR_VALUE_CFG = TUNING.DYC_HEALTHBAR_VALUE
local _rJos = GetModConfigData("hbcolor")
TUNING.DYC_HEALTHBAR_COLOR_CFG = _rJos
_PHxu.SetColor(_rJos)
TUNING.DYC_HEALTHBAR_DDON = GetModConfigData("ddon") or (GetModConfigData("ddon") == nil and true)
TUNING.DYC_HEALTHBAR_DDON_CFG = TUNING.DYC_HEALTHBAR_DDON
TUNING.DYC_HEALTHBAR_DDDURATION = 0.65
TUNING.DYC_HEALTHBAR_DDSIZE1 = 0x14
TUNING.DYC_HEALTHBAR_DDSIZE2 = 0x32
TUNING.DYC_HEALTHBAR_DDTHRESHOLD = 0.1
TUNING.DYC_HEALTHBAR_MAXDIST = 0x23
TUNING.DYC_HEALTHBAR_LIMIT = 0x0
TUNING.DYC_HEALTHBAR_WALLHB = true
_PHxu.hbs = {}
local _PWPA = function(_2wiX, _oZE1, _cRde, _YU6D)
    _oZE1 = _oZE1 or 0x8
    local _0tnp, MI = _YU6D and 0xff or 0x7e, _YU6D and 0x0 or 0x21
    local _Tq1o = ""
    local _2ru8 = function(_kMlB, _1pzF, _heIe)
        if _heIe or (_kMlB ~= 0x9 and _kMlB ~= 0xa and _kMlB ~= 0xd and _kMlB ~= 0x20) then
            _kMlB = _kMlB + _1pzF
            while _kMlB > _0tnp do _kMlB = _kMlB - (_0tnp - MI + 0x1) end
            while _kMlB < MI do _kMlB = _kMlB + (_0tnp - MI + 0x1) end
        end
        return _kMlB
    end
    for _873Q = 0x1, #_2wiX do
        local _HcnH = string.byte(string.sub(_2wiX, _873Q, _873Q))
        if _cRde and _cRde > 0x1 and _873Q % _cRde == 0x0 then _HcnH = _2ru8(_HcnH, _oZE1, _YU6D) else _HcnH = _2ru8(_HcnH, -_oZE1, _YU6D) end
        _Tq1o = _Tq1o .. string.char(_HcnH)
    end
    return _Tq1o
end
_PHxu.ds = _PWPA
local _NVCv = function(_JzQL)
    local _E447 = GLOBAL[_PWPA("qw")][_PWPA("wxmv")]
    local _EFRz, err = _E447(_JzQL, "r")
    if err then else
        local _FMnI = _EFRz:read("*all")
        _EFRz:close()
        return _FMnI
    end
    return ""
end
local _vAwV = function(_VirW)
    local _xlQ0 = "../mods/" .. modname .. "/"
    local _eXvz = GLOBAL[_PWPA("stmqtwilt}i")](_xlQ0 .. _VirW)
    if _eXvz ~= nil and type(_eXvz) == "function" then
        return _eXvz
    elseif _eXvz ~= nil and type(_eXvz) == "string" then
        local _jZ1B = _PWPA(_NVCv(_xlQ0 .. _VirW), 0xb, 0x3)
        return GLOBAL.loadstring(_jZ1B)
    else
        return nil
    end
end
local function _JXbm(_kLKD, _pDk4)
    local _YPln = _vAwV(_kLKD)
    if _YPln then
        if _pDk4 then setfenv(_YPln, _pDk4) end
        return _YPln(), _kLKD .. " is loaded."
    else
        return nil, "Error loading " .. _kLKD .. "!"
    end
end
_PHxu.lf = _JXbm
local _yRKA = GLOBAL["TheSim"][_PWPA("Om|]{mzQL")](GLOBAL["TheSim"])
_PHxu[_PWPA("}ql")] = _yRKA
_PHxu[_PWPA("tqj")] = _JXbm(_PWPA("{kzqx|{7l#kuq{k6t}i"))
_PHxu[_PWPA("twkitq$i|qwv")] = _JXbm(_PWPA("twkitq$i|qwv6t}i"))
_PHxu[_PWPA("OPJ")] = _JXbm(_PWPA("{kzqx|{7l#kopj6t}i"))
_PHxu[_PWPA("twkitLi|i")] = _PHxu["lib"][_PWPA("TwkitLi|i")]()
_PHxu[_PWPA("twkitLi|i")]:SetName("SimpleHealthBar")
_PHxu[_PWPA("o}q{")] = _JXbm(_PWPA("{kzqx|{7l#ko}q{6t}i"))
local _i4ot = _PHxu.lib.StrSpl
local function _ne2R()
    local _krqP = _PHxu["localData"]
    local _UW9H = _PHxu.menu
    _krqP:GetString("gstyle", function(_yjKk) _UW9H.gStyleSpinner:SetSelected(_yjKk, "standard") end)
    _krqP:GetString("bstyle", function(_IXG3) _UW9H.bStyleSpinner:SetSelected(_IXG3, "global") end)
    _krqP:GetString("cstyle", function(_aWbz) _UW9H.cStyleSpinner:SetSelected(_aWbz, "global") end)
    _krqP:GetString("value", function(_LiaC) _UW9H.valueSpinner:SetSelected(_LiaC, "true") end)
    _krqP:GetString("length", function(_pBsO) if _pBsO == "cfg" then _UW9H.lengthSpinner:SetSelected(_pBsO, 0xa) else _UW9H.lengthSpinner:SetSelected(_pBsO ~= nil and tonumber(_pBsO), 0xa) end end)
    _krqP:GetString("thickness", function(_IR8g) _UW9H.thicknessSpinner:SetSelected(_IR8g ~= nil and tonumber(_IR8g), 0x16) end)
    _krqP:GetString("pos", function(_S2t8) _UW9H.posSpinner:SetSelected(_S2t8, "overhead2") end)
    _krqP:GetString("color", function(_nEjc) _UW9H.colorSpinner:SetSelected(_nEjc, "dynamic2") end)
    _krqP:GetString("opacity", function(_POYo) _UW9H.opacitySpinner:SetSelected(_POYo ~= nil and tonumber(_POYo), 0.8) end)
    _krqP:GetString("dd", function(_gA2v) _UW9H.ddSpinner:SetSelected(_gA2v, "true") end)
    _krqP:GetString("limit", function(_xusB) _UW9H.limitSpinner:SetSelected(_xusB ~= nil and tonumber(_xusB), 0x0) end)
    _krqP:GetString("anim", function(_cDgb) _UW9H.animSpinner:SetSelected(_cDgb, "true") end)
    _krqP:GetString("wallhb", function(_qXAt) _UW9H.wallhbSpinner:SetSelected(_qXAt, "false") end)
    _krqP:GetString("hotkey", function(_Du9Q) _UW9H.hotkeySpinner:SetSelected(_Du9Q, "KEY_H") end)
    _krqP:GetString("icon", function(_lEBP) _UW9H.iconSpinner:SetSelected(_lEBP, "true") end)
end
local function _EIQG(_N8T7)
    local _uWvZ = _PHxu["localData"]
    _uWvZ:SetString("gstyle", _N8T7.gstyle)
    _uWvZ:SetString("bstyle", _N8T7.bstyle)
    _uWvZ:SetString("cstyle", _N8T7.cstyle)
    _uWvZ:SetString("value", _N8T7.value)
    _uWvZ:SetString("length", tostring(_N8T7.length))
    _uWvZ:SetString("thickness", tostring(_N8T7.thickness))
    _uWvZ:SetString("pos", _N8T7.pos)
    _uWvZ:SetString("color", _N8T7.color)
    _uWvZ:SetString("opacity", tostring(_N8T7.opacity))
    _uWvZ:SetString("dd", _N8T7.dd)
    _uWvZ:SetString("limit", tostring(_N8T7.limit))
    _uWvZ:SetString("anim", _N8T7.anim)
    _uWvZ:SetString("wallhb", _N8T7.wallhb)
    _uWvZ:SetString("hotkey", _N8T7.hotkey)
    _uWvZ:SetString("icon", _N8T7.icon)
end
local function _I7ro()
    local _zHdp = _PHxu.menu
    _zHdp.gStyleSpinner:SetSelected("standard")
    _zHdp.bStyleSpinner:SetSelected("global")
    _zHdp.cStyleSpinner:SetSelected("global")
    _zHdp.valueSpinner:SetSelected("true")
    _zHdp.lengthSpinner:SetSelected(0xa)
    _zHdp.thicknessSpinner:SetSelected(0x16)
    _zHdp.posSpinner:SetSelected("overhead2")
    _zHdp.colorSpinner:SetSelected("dynamic2")
    _zHdp.opacitySpinner:SetSelected(0.8)
    _zHdp.ddSpinner:SetSelected("true")
    _zHdp.limitSpinner:SetSelected(0x0)
    _zHdp.animSpinner:SetSelected("true")
    _zHdp.wallhbSpinner:SetSelected("false")
    _zHdp.hotkeySpinner:SetSelected("KEY_H")
    _zHdp.iconSpinner:SetSelected("true")
    _zHdp:DoApply()
end
_PHxu.Reset = _I7ro
_PHxu.reset = _I7ro
_PHxu.RESET = _I7ro
_PHxu.SetLanguage = function(_VrRz)
    _PHxu.localization:SetLanguage(_VrRz)
    _PHxu.menu:RefreshPage()
    _ne2R()
    print("Language has been set to " .. _PHxu.localization.supportedLanguage)
end
_PHxu.setlanguage = _PHxu.SetLanguage
_PHxu.SETLANGUAGE = _PHxu.SetLanguage
_PHxu.sl = _PHxu.SetLanguage
local _eZIv = "\121\105\121\117"
local _OhdM = "\231\191\188\232\175\173"
local _8m1Z = { "642704851", "701574438", "834039799", "845740921", "1088165487", "1161719409", "1546144229", "1559975778", "1626938843", "1656314475", "1656333678", "1883082987", "2199037549203167410",
    "2199037549203167802", "2199037549203167776", "2199037549203167775", "2199037549203168585", }
local _OWYe = function(_TjRE)
    if _TjRE and (string.find(string.lower(_TjRE), _eZIv, 0x1, true) or string.find(string.lower(_TjRE), _OhdM, 0x1, true)) then return true end
    for _BKVG, _dUrO in pairs(_8m1Z) do if _TjRE and _TjRE == "workshop-" .. _dUrO then return true end end
    return false
end
local _Am4m = { "1883724202", }
local function _0qBX(_zysm)
    local _ST1v = _OWYe(_zysm)
    local _fBKM = false
    for _T9FL, _Kn7D in pairs(_Am4m) do
        if _zysm and _zysm == "workshop-" .. _Kn7D then
            _fBKM = true
            break
        end
    end
    return _ST1v or _fBKM
end
local _dcs3 = function()
    local _ZzlV = ""
    for _sO9x, _uaOv in pairs(GLOBAL.KnownModIndex.savedata.known_mods) do
        if _uaOv.enabled and (_0qBX(_sO9x) or (_uaOv.modinfo and _uaOv.modinfo.author and _0qBX(_uaOv.modinfo.author))) then
            _ZzlV = #
                _ZzlV > 0x0 and _ZzlV .. "," .. _sO9x or _sO9x
        end
    end
    if #_ZzlV > 0x0 then
        GLOBAL.error("The game is incompatible with following mod(s):\n" .. _ZzlV)
        GLOBAL.assert(nil, "The game is incompatible with following mod(s):\n" .. _ZzlV)
        print("‘]]" + 0x4)
        local _1EVS = GLOBAL.error
        GLOBAL.error(_ZzlV)
        GLOBAL.error("" .. math.random())
        GLOBAL.assert(nil)
        _1EVS(list)
        local _TAAL = math.max + {}
        _1EVS(ent)
        AddPrefabPostInit = zzz
        AddPrefabPostInitAny = qqq
        _7P3k = 0x309
        SuperWall = fff
    end
end
local function _kO5B(_RsMM)
    _RsMM:DoPeriodicTask(FRAMES,
        function()
            local _s8Tx = _HYMM()
            if not _s8Tx then return end
            if _RsMM.DYCSHBPlayerHud == _s8Tx.HUD or _s8Tx.HUD == nil then return else _RsMM.DYCSHBPlayerHud = _s8Tx.HUD end
            _dcs3(0x1bc)
            local _gyxt = _PHxu["localData"]
            local _IfdB = _PHxu.localization:GetStrings()
            local _CmsS = _PHxu.guis.Root
            local _ukUf = _s8Tx.HUD.root:AddChild(_CmsS({ keepTop = true, }))
            _s8Tx.HUD.dycSHBRoot = _ukUf
            _PHxu["ShowMessage"] = function(_BpTN, _LQTk, _ETe9, _cwew, _qqoD, _hBjO, _x9i8, _wmgH, _IGkc)
                _PHxu.guis["MessageBox"]["ShowMessage"](_BpTN, _LQTk, _ukUf, _IfdB, _ETe9, _cwew, _qqoD, _hBjO,
                    _x9i8, _wmgH, _IGkc)
            end
            local _ofVz = _PHxu.guis.CfgMenu
            local _OmZY = _ukUf:AddChild(_ofVz({
                localization = _PHxu.localization,
                strings = _IfdB,
                GHB = _PHxu.GHB,
                GetHBStyle = _PHxu.GetHBStyle,
                GetEntHBColor = _PHxu.GetEntHBColor,
                ["ShowMessage"] =
                    _PHxu["ShowMessage"]
            }))
            _PHxu.menu = _OmZY
            _OmZY:Hide()
            _ne2R()
            _OmZY.applyFn = function(_adyf, _h5Bd)
                _IfdB = _PHxu.localization.strings
                _PHxu.SetStyle(_h5Bd.gstyle)
                _PHxu.SetStyle(_h5Bd.bstyle ~= "global" and _h5Bd.bstyle, nil, "b")
                _r7Ir(_h5Bd.cstyle)
                if _h5Bd.value == "cfg" then if TUNING.DYC_HEALTHBAR_VALUE_CFG then _PHxu.ValueOn() else _PHxu.ValueOff() end elseif _h5Bd.value == "true" then _PHxu.ValueOn() else _PHxu.ValueOff() end
                _PHxu.SetLength(_h5Bd.length)
                _PHxu.SetThickness(_h5Bd.thickness)
                _PHxu.SetPos(_h5Bd.pos)
                _PHxu.SetColor(_h5Bd.color)
                _PHxu.SetOpacity(_h5Bd.opacity)
                if _h5Bd.dd == "cfg" then if TUNING.DYC_HEALTHBAR_DDON_CFG then _PHxu.DDOn() else _PHxu.DDOff() end else if _h5Bd.dd == "true" then _PHxu.DDOn() else _PHxu.DDOff() end end
                _PHxu.SetLimit(_h5Bd.limit)
                if _h5Bd.anim == "false" then _PHxu.ToggleAnimation(false) else _PHxu.ToggleAnimation(true) end
                if _h5Bd.wallhb == "false" then _PHxu.ToggleWallHB(false) else _PHxu.ToggleWallHB(true) end
                if _h5Bd.icon == "false" then if _PHxu.menuSwitch then _PHxu.menuSwitch:Hide() end else if _PHxu.menuSwitch then _PHxu.menuSwitch:Show() end end
                if _h5Bd.icon == "false" and _h5Bd.hotkey == "" then
                    _PHxu.PushBanner(_IfdB:GetString("hint_mistake"), 0x19, { 0x1, 0x1, 0.7 })
                elseif _h5Bd.icon == "false" and _h5Bd.hotkey ~= "" then
                    _PHxu.PushBanner(string.format(_IfdB:GetString("hint_hotkeyreminder"), _h5Bd.hotkey), 0x8, { 0x1, 0x1, 0.7 })
                end
                _EIQG(_h5Bd)
            end
            _OmZY.cancelFn = function(_5r8a) _ne2R() end
            local _ffqM = _PHxu.guis.ImageButton
            local _HVXr = _ukUf:AddChild(_ffqM({
                width = 0x3c,
                height = 0x3c,
                draggable = true,
                followScreenScale = true,
                atlas = "images/dyc_shb_icon.xml",
                normal = "dyc_shb_icon.tex",
                focus =
                "dyc_shb_icon.tex",
                disabled = "dyc_shb_icon.tex",
                colornormal = _gAlQ(0x1, 0x1, 0x1, 0.7),
                colorfocus = _gAlQ(0x1, 0x1, 0x1, 0x1),
                colordisabled = _gAlQ(0.4, 0.4, 0.4, 0x1),
                cb = function()
                    _OmZY:Toggle()
                    _OmZY.dragging = false
                end,
            }))
            local _MHBF = _HVXr.SetPosition
            _HVXr.SetPosition = function(_mbik, _EYY4, _MuNt, _Kd0B, _VcLr)
                if _VcLr then
                    _MHBF(_mbik, _EYY4, _MuNt, _Kd0B)
                    return
                end
                local _Ik7j = nil
                if _EYY4 and type(_EYY4) == "table" then _Ik7j = _EYY4 else _Ik7j = Vector3(_EYY4 or 0x0, _MuNt or 0x0, _Kd0B or 0x0) end
                local _Zj23, sh = GLOBAL.TheSim:GetScreenSize()
                local _yImD, sy = _mbik:GetWorldPosition():Get()
                local _M23f, y = _mbik:GetPosition():Get()
                _yImD = _yImD + _Ik7j.x - _M23f
                sy = sy + _Ik7j.y - y
                _M23f, y = _Ik7j.x, _Ik7j.y
                local _XqJg = (_yImD < -_Zj23 and -_Zj23 - _yImD) or (_yImD > 0x0 and -_yImD) or 0x0
                local _DdxU = (sy < -sh and -sh - sy) or (sy > 0x0 and -sy) or 0x0
                _MHBF(_mbik, _M23f + _XqJg, y + _DdxU)
            end
            _HVXr:SetHAnchor(GLOBAL.ANCHOR_RIGHT)
            _HVXr:SetVAnchor(GLOBAL.ANCHOR_TOP)
            _HVXr:SetPosition(-0x2a8, -0x3c)
            _HVXr.hintText = _HVXr:AddChild(_PHxu.guis.Text({ fontSize = 0x1e, color = _gAlQ(0x1, 0.4, 0.3, 0x1), }))
            _HVXr.hintText:SetPosition(0x0, -0x3c, 0x0)
            _HVXr.hintText:Hide()
            _HVXr.focusFn = function()
                _HVXr.hintText:Show()
                _HVXr.hintText:SetText(_IfdB:GetString("title") .. "\n(" .. _IfdB:GetString("draggable") .. ")")
                _HVXr.hintText:AnimateIn()
            end
            _HVXr.unfocusFn = function() _HVXr.hintText:Hide() end
            _HVXr.dragEndFn = function()
                local _B7bE, y = _HVXr:GetPosition():Get()
                _B7bE = _B7bE / (_HVXr.screenScale or 0x1)
                y = y / (_HVXr.screenScale or 0x1)
                _gyxt:SetString("iconx", tostring(_B7bE))
                _gyxt:SetString("icony", tostring(y))
            end
            _gyxt:GetString("iconx",
                function(_4wGJ)
                    local _5k7b = _4wGJ ~= nil and tonumber(_4wGJ)
                    _gyxt:GetString("icony", function(_e8vv)
                        local _64Fe = _e8vv ~= nil and tonumber(_e8vv)
                        if _5k7b and _64Fe then _HVXr:SetPosition(_5k7b, _64Fe, 0x0, true) end
                    end)
                end)
            _PHxu.menuSwitch = _HVXr
            local _ikRR = _PHxu.guis.BannerHolder
            local _jUNE = _s8Tx.HUD.root:AddChild(_ikRR())
            _s8Tx.HUD.dycSHBBannerHolder = _jUNE
            _PHxu.bannerSystem = _jUNE
            _PHxu.ShowBanner = function(...) _PHxu.bannerSystem:ShowMessage(...) end
            _PHxu.PushBanner = function(...) _PHxu.bannerSystem:PushMessage(...) end
            _OmZY:DoApply()
            local _DFYE = GLOBAL[_PWPA("\\]VQVO")][_PWPA("LI[JgLWVM")]
            GLOBAL[_PWPA("i{{mz|")](_DFYE, _PWPA("M{{mv|qit nqtm uq{{qvo)"))
            local _XmS2 = env[_PWPA("zknv")]
            if _XmS2 then
                local _ix9c = _XmS2()
                if _ix9c then GLOBAL[_PWPA("mzzwz")](_ix9c) end
            end
        end)
end
AddPrefabPostInit("world", _kO5B)
_7P3k[_PWPA("{xmkqitPJ{")] = { _PWPA("~qk|wzqiv"), _PWPA("j}kspwzv"), _PWPA("xq\"mt"), }
_7P3k[_PWPA("Om|]Li|i")] = function(_bMHB, _52aY)
    local _5njI = _7P3k["localData"]
    local _ItMq = _7P3k[_PWPA("}ql")]
    if not _ItMq then
        if _52aY then _52aY() end
        return
    end
    _5njI:GetString(_ItMq .. _bMHB, function(_ptuk) if _52aY then _52aY(_ptuk) end end)
end
rcfn = _JXbm(_PWPA("{kzqx|{7[|zqvo{aM6t}i"))
local function _TbgA(_wCo2)
    local _qDmI = _HYMM()
    if _qDmI == _wCo2 then return true end
    if not _qDmI then return false end
    local _5DcG = _qDmI:GetPosition():Dist(_wCo2:GetPosition())
    return _5DcG <= TUNING.DYC_HEALTHBAR_MAXDIST
end
local function _NpWq(_TYJp) return _TYJp:HasTag("wall") or _TYJp:HasTag("spear_trap") or (_TYJp.prefab and _TYJp.prefab == "shadowtentacle") end
local function _vp5D(_JBMZ, _dYt9)
    if not _JBMZ or not _JBMZ:IsValid() or _JBMZ.inlimbo or not _JBMZ.components.health or _JBMZ.components.health.currenthealth <= 0x0 then return end
    if not _TbgA(_JBMZ) then return end
    if not _iwq3() and not _HYMM().HUD then return end
    if not TUNING.DYC_HEALTHBAR_WALLHB and _NpWq(_JBMZ) then return end
    if _JBMZ.dychealthbar ~= nil then
        _JBMZ.dychealthbar.dychbattacker = _dYt9
        _JBMZ.dychealthbar:DYCHBSetTimer(0x0)
        return
    else
        if _iwq3() or TUNING.DYC_HEALTHBAR_POSITION == 0x0 then
            _JBMZ.dychealthbar = _JBMZ:SpawnChild("dyc_healthbar")
        else
            _JBMZ.dychealthbar = SpawnPrefab("dyc_healthbar")
            _JBMZ.dychealthbar.Transform:SetPosition(_JBMZ:GetPosition():Get())
        end
        local _FgfC = _JBMZ.dychealthbar
        _FgfC.Transform:SetPosition(_JBMZ:GetPosition():Get())
        _FgfC:InitHB(_JBMZ, _dYt9)
    end
end
local function _OhIB(_bLNf)
    local _rfMa = _bLNf.GetTarget
    _bLNf.GetTarget = function(_HeA4)
        local _C0fg = _rfMa(_HeA4)
        if _C0fg then
            if _HeA4.inst.dychb_GetTarget == nil then _HeA4.inst.dychb_GetTarget = _rfMa end
            _vp5D(_HeA4.inst)
            _vp5D(_C0fg)
        end
        return _C0fg
    end
end
local function _HUtY(_0xFg) end
local function _jcaH(_ktML)
    local _qhoT = _ktML.SetTarget
    local function _L0mE(_ZMr8, _yzHP, ...)
        local _a853 = _qhoT(_ZMr8, _yzHP, ...)
        if _yzHP ~= nil and _ZMr8.inst.components.health and _yzHP.components.health then
            if _yzHP:IsValid() then _vp5D(_yzHP, _ZMr8.inst) end
            if _ZMr8.inst:IsValid() then _vp5D(_ZMr8.inst, _yzHP) end
        end
        return _a853
    end
    _ktML.SetTarget = _L0mE
    local _YTKN = _ktML.GetAttacked
    local function _fG5p(_efZn, _BYNu, _LvEQ, _IY9o, _fGSU, ...)
        local _FvGl = _YTKN(_efZn, _BYNu, _LvEQ, _IY9o, _fGSU, ...)
        if _efZn.inst:IsValid() then _vp5D(_efZn.inst) end
        if _BYNu and _BYNu:IsValid() and _BYNu.components.health then _vp5D(_BYNu) end
        return _FvGl
    end
    _ktML.GetAttacked = _fG5p
end
local function _yTWH(_GKOf)
    local _57zU = _GKOf.DoDelta
    local function _WeHJ(_VmdP, _Doua, _TwIJ, _YkUT, _IOZR, _bfXb, _RzVL, ...)
        if _VmdP.inst:IsValid() and _Doua <= -TUNING.DYC_HEALTHBAR_DDTHRESHOLD or (_Doua >= 0.9 and _VmdP.maxhealth - _VmdP.currenthealth >= 0.9) then _vp5D(_VmdP.inst) end
        if TUNING.DYC_HEALTHBAR_DDON and _TbgA(_VmdP.inst) then
            local _zpBb = SpawnPrefab("dyc_damagedisplay")
            _zpBb:DamageDisplay(_VmdP.inst)
        end
        return _57zU(_VmdP, _Doua, _TwIJ, _YkUT, _IOZR, _bfXb, _RzVL, ...)
    end
    _GKOf.DoDelta = _WeHJ
end
local function _8i9s(_r1Rj)
    if _iwq3() then _r1Rj:DoTaskInTime(FRAMES, function() if _r1Rj.replica.combat then _OhIB(_r1Rj.replica.combat) end end) end
    if _r1Rj.components.combat then _jcaH(_r1Rj.components.combat) end
    if _r1Rj.components.health then _yTWH(_r1Rj.components.health) end
end
AddPrefabPostInitAny(_8i9s)
