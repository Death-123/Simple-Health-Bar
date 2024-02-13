local _4tGd = require "widgets/followtext"
local _aY5n = { Asset("ATLAS", "images/dyc_white.xml"), Asset("IMAGE", "images/dyc_white.tex"), Asset("ATLAS", "images/dyc_shb_icon.xml"), Asset("IMAGE", "images/dyc_shb_icon.tex"), Asset("ATLAS",
    "images/dycghb_claw.xml"), Asset("IMAGE", "images/dycghb_claw.tex"), Asset("ATLAS", "images/dycghb_shadow.xml"), Asset("IMAGE", "images/dycghb_shadow.tex"), Asset("ATLAS",
    "images/dycghb_shadow_i.xml"), Asset("IMAGE", "images/dycghb_shadow_i.tex"), Asset("ATLAS", "images/dycghb_round.xml"), Asset("IMAGE", "images/dycghb_round.tex"), Asset("ATLAS",
    "images/dycghb_panel.xml"), Asset("IMAGE", "images/dycghb_panel.tex"), Asset("ATLAS", "images/dycghb_pixel.xml"), Asset("IMAGE", "images/dycghb_pixel.tex"), Asset("ATLAS",
    "images/dycghb_pixel_i.xml"), Asset("IMAGE", "images/dycghb_pixel_i.tex"), Asset("ATLAS", "images/dycghb_buckhorn.xml"), Asset("IMAGE", "images/dycghb_buckhorn.tex"), Asset("ATLAS",
    "images/dycghb_victorian.xml"), Asset("IMAGE", "images/dycghb_victorian.tex"), Asset("ATLAS", "images/dycghb_victorian_i.xml"), Asset("IMAGE", "images/dycghb_victorian_i.tex"), }
local _MCVf = {}
local _JcG4 = SimpleHealthBar.Color
local _3hIQ = SimpleHealthBar.lib.TableRemoveValue
local function _ACTF() return TheSim:GetGameID() == "DST" end
local function _DDjQ() return _ACTF() and TheNet:GetIsClient() end
local function _84vX() return PLATFORM == "WIN32_STEAM" or PLATFORM == "OSX_STEAM" or PLATFORM == "LINUX_STEAM" end
local function _CBdA() if _ACTF() then return ThePlayer else return GetPlayer() end end
local function _R9x6(_xZtm)
    local _fdOh = _CBdA()
    if _fdOh == _xZtm then return true end
    if not _fdOh then return false end
    local _0vr7 = _fdOh:GetPosition():Dist(_xZtm:GetPosition())
    return _0vr7 <= TUNING.DYC_HEALTHBAR_MAXDIST
end
local function _sFNB(_KbJG)
    if TheSim.GetCameraPos ~= nil then
        local _OppS = Vector3(TheSim:GetCameraPos())
        return _OppS:Dist(_KbJG:GetPosition())
    else
        local _h7Nh = TheCamera.pitch * DEGREES
        local _8gn3 = TheCamera.heading * DEGREES
        local _UMsL = math.cos(_h7Nh)
        local _iGAz = math.cos(_8gn3)
        local _ZbZN = math.sin(_8gn3)
        local _NyE7 = -_UMsL * _iGAz
        local _XL0P = -math.sin(_h7Nh)
        local _z0ri = -_UMsL * _ZbZN
        local _KLfh, zoffs = 0x0, 0x0
        if TheCamera.currentscreenxoffset ~= 0x0 then
            local _AGjU = 0x2 * TheCamera.currentscreenxoffset / RESOLUTION_Y
            local _ixmQ = 1.03
            local _mcsd = math.tan(TheCamera.fov * .5 * DEGREES) * TheCamera.distance * _ixmQ
            _KLfh = -_AGjU * _ZbZN * _mcsd
            zoffs = _AGjU * _iGAz * _mcsd
        end
        local _KjRN = Vector3(TheCamera.currentpos.x - _NyE7 * TheCamera.distance + _KLfh, TheCamera.currentpos.y - _XL0P * TheCamera.distance,
            TheCamera.currentpos.z - _z0ri * TheCamera.distance + zoffs)
        return _KjRN:Dist(_KbJG:GetPosition())
    end
end
local _zLfT = SimpleHealthBar.ds("kti!")
local _CPuw = SimpleHealthBar.ds("~qk|wzqiv")
local _pHE3 = SimpleHealthBar.ds("xq\"mt")
local _ukaH = SimpleHealthBar.ds("j}kspwzv")
local _Bs9t = SimpleHealthBar.ds("{pilw!")
local _2fEp = "images/dyc_white.xml"
local _lXUU = "dyc_white.tex"
local _tXep = -0x2d
local _jOS8 = 0x3c
local _GvOU = {
    ["heart"] = { c1 = "♡", c2 = "♥", },
    ["circle"] = { c1 = "○", c2 = "●", },
    ["square"] = { c1 = "□", c2 = "■", },
    ["diamond"] = { c1 = "◇", c2 = "◆", },
    ["star"] = { c1 = "☆", c2 = "★", },
    ["square2"] = { c1 = "░", c2 = "▓", },
    ["basic"] = { c1 = "=", c2 = "#", numCoeff = 1.6, },
    ["hidden"] = { c1 = " ", c2 = " ", },
    ["chinese"] = { c1 = "口", c2 = "回", },
    ["standard"] = { c1 = " ", c2 = " ", graphic = { basic = { atlas = "images/dyc_white.xml", texture = "dyc_white.tex", }, }, },
    ["simple"] = { c1 = " ", c2 = " ", graphic = { bg = { atlas = "images/ui.xml", texture = "bg_plain.tex", color = _JcG4.New(0.3, 0.3, 0.3) }, bar = { atlas = "images/ui.xml", texture = "bg_plain.tex", margin = { x1 = 0x0, x2 = 0x0, y1 = 0x0, y2 = 0x0, }, }, basic = { atlas = "images/dyc_white.xml", texture = "dyc_white.tex", }, }, },
    [_zLfT] = { c1 = " ", c2 = " ", graphic = { basic = { atlas = "images/dyc_white.xml", texture = "dyc_white.tex", }, bgSkn = { mode = "slice13", atlas = "images/dycghb_" .. _zLfT .. ".xml", texname = "dycghb_" .. _zLfT, texScale = 0x3e7, margin = { x1 = -0.75, x2 = -0.75, y1 = -0.225, y2 = -0.225, fixed = false }, }, barSkn = { mode = "slice33", atlas = "images/dycghb_round.xml", texname = "dycghb_round", texScale = 0x1, margin = { x1 = 0.015, x2 = 0.015, y1 = 0.06, y2 = 0.06, fixed = false }, }, }, },
    [_CPuw] = { c1 = " ", c2 = " ", graphic = { basic = { atlas = "images/dyc_white.xml", texture = "dyc_white.tex", }, bgSkn = { mode = "slice13", atlas = "images/dycghb_" .. _CPuw .. ".xml", texname = "dycghb_" .. _CPuw, texScale = 0x3e7, margin = { x1 = -1.7, x2 = -1.7, y1 = -0.45, y2 = -0.55, fixed = false }, }, barSkn = { mode = "slice33", atlas = "images/dycghb_" .. _CPuw .. "_i.xml", texname = "dycghb_" .. _CPuw .. "_i", texScale = 0.25, margin = { x1 = 0.03, x2 = 0.03, y1 = 0.15, y2 = 0.15, fixed = false }, }, }, },
    [_ukaH] = { c1 = " ", c2 = " ", graphic = { basic = { atlas = "images/dyc_white.xml", texture = "dyc_white.tex", }, bgSkn = { mode = "slice13", atlas = "images/dycghb_" .. _ukaH .. ".xml", texname = "dycghb_" .. _ukaH, texScale = 0x3e7, margin = { x1 = -1.2, x2 = -1.2, y1 = -0.43, y2 = -0.48, fixed = false }, }, bar = { atlas = "images/ui.xml", texture = "bg_plain.tex", margin = { x1 = 0x0, x2 = 0x0, y1 = 0x0, y2 = 0x0, fixed = false }, }, }, },
    [_pHE3] = { c1 = " ", c2 = " ", graphic = { basic = { atlas = "images/dyc_white.xml", texture = "dyc_white.tex", }, bgSkn = { mode = "slice13", atlas = "images/dycghb_" .. _pHE3 .. ".xml", texname = "dycghb_" .. _pHE3, texScale = 0x3e7, margin = { x1 = -1.1, x2 = -0.4, y1 = -0.365, y2 = -0.285, fixed = false }, }, barSkn = { mode = "slice13", atlas = "images/dycghb_" .. _pHE3 .. "_i.xml", texname = "dycghb_" .. _pHE3 .. "_i", texScale = 0x3e7, margin = { x1 = -1.1, x2 = -0.4, y1 = -0.365, y2 = -0.285, fixed = false }, vmargin = { x1 = 0.675, x2 = -0.075, y1 = 0.1, y2 = 0.13, fixed = false }, }, hrUseBarColor = true, }, },
    [_Bs9t] = { c1 = " ", c2 = " ", graphic = { basic = { atlas = "images/dyc_white.xml", texture = "dyc_white.tex", }, bgSkn = { mode = "slice33", atlas = "images/dycghb_" .. _Bs9t .. ".xml", texname = "dycghb_" .. _Bs9t, texScale = 0.5, margin = { x1 = -0xb, x2 = -0xb, y1 = -0x9, y2 = -0xb, fixed = true }, }, barSkn = { mode = "slice33", atlas = "images/dycghb_" .. _Bs9t .. "_i.xml", texname = "dycghb_" .. _Bs9t .. "_i", texScale = 0.3, }, }, },
}
local _mWEL = { { prefab = "shadowtentacle", width = 0.5, height = 0x2, }, { prefab = "mean_flytrap", width = 0.9, height = 2.3, }, { prefab = "thunderbird", width = 0.85, height = 2.05, }, { prefab = "glowfly", width = 0.6, height = 0x2, }, { prefab = "peagawk", width = 0.85, height = 2.1, }, { prefab = "krampus", width = 0x1, height = 3.75, }, { prefab = "nightmarebeak", width = 0x1, height = 4.5, }, { prefab = "terrorbeak", width = 0x1, height = 4.5, }, { prefab = "spiderqueen", width = 0x2, height = 4.5, }, { prefab = "warg", width = 1.7, height = 0x5, }, { prefab = "pumpkin_lantern", width = 0.7, height = 1.5, }, { prefab = "jellyfish_planted", width = 0.7, height = 1.5, }, { prefab = "babybeefalo", width = 0x1, height = 2.2, }, { prefab = "beeguard", width = 0.65, height = 0x2, }, { prefab = "shadow_rook", width = 1.8, height = 3.5, }, { prefab = "shadow_bishop", width = 0.9, height = 3.2, }, { prefab = "walrus", width = 1.1, height = 3.2, }, { prefab = "teenbird", width = 1.0, height = 3.6, }, { tag = "player", width = 0x1, height = 2.65, }, { tag = "ancient_hulk", width = 1.85, height = 4.5, }, { tag = "antqueen", width = 2.4, height = 0x8, }, { tag = "ro_bin", width = 0.9, height = 2.8, }, { tag = "gnat", width = 0.75, height = 0x3, }, { tag = "spear_trap", width = 0.55, height = 0x3, }, { tag = "hangingvine", width = 0.85, height = 0x4, }, { tag = "weevole", width = 0.6, height = 1.2, }, { tag = "flytrap", width = 0x1, height = 3.4, }, { tag = "vampirebat", width = 0x1, height = 0x3, }, { tag = "pangolden", width = 1.4, height = 3.8, }, { tag = "spider_monkey", width = 1.6, height = 0x4, }, { tag = "hippopotamoose", width = 1.35, height = 3.1, }, { tag = "piko", width = 0.5, height = 0x1, }, { tag = "pog", width = 0.85, height = 0x2, }, { tag = "ant", width = 0.8, height = 2.3, }, { tag = "scorpion", width = 0.85, height = 0x2, }, { tag = "dungbeetle", width = 0.8, height = 2.3, }, { tag = "civilized", width = 0x1, height = 3.2, }, { tag = "koalefant", width = 1.7, height = 0x4, }, { tag = "spat", width = 1.5, height = 3.5, }, { tag = "lavae", width = 0.8, height = 1.5, }, { tag = "glommer", width = 0.9, height = 2.9, }, { tag = "deer", width = 0x1, height = 3.1, }, { tag = "snake", width = 0.85, height = 1.7, }, { tag = "eyeturret", width = 0x1, height = 4.5, }, { tag = "primeape", width = 0.85, height = 1.5, }, { tag = "monkey", width = 0.85, height = 1.5, }, { tag = "ox", width = 1.5, height = 3.75, }, { tag = "beefalo", width = 1.5, height = 3.75, }, { tag = "kraken", width = 0x2, height = 5.5, }, { tag = "nightmarecreature", width = 1.25, height = 3.5, }, { tag = "bishop", width = 0x1, height = 0x4, }, { tag = "rook", width = 1.25, height = 0x4, }, { tag = "knight", width = 0x1, height = 0x3, }, { tag = "bat", width = 0.8, height = 0x3, }, { tag = "minotaur", width = 1.75, height = 4.5, }, { tag = "packim", width = 0.9, height = 3.75, }, { tag = "stungray", width = 0.9, height = 3.75, }, { tag = "ghost", width = 0.9, height = 3.75, }, { tag = "tallbird", width = 1.25, height = 0x5, }, { tag = "chester", width = 0.85, height = 1.5, }, { tag = "hutch", width = 0.85, height = 1.5, }, { tag = "wall", width = 0.5, height = 1.5, }, { tag = "largecreature", width = 0x2, height = 7.2, }, { tag = "insect", width = 0.5, height = 1.6, }, { tag = "smallcreature", width = 0.85, height = 1.5, }, }
local function _3swb(_cVLs)
    if _cVLs < 0x0 then _cVLs = 0x0 elseif _cVLs > 0x1 then _cVLs = 0x1 end
    return _cVLs
end
local function _kyUu(_hZIO, _4JdC)
    local _CoUQ = _CBdA()
    local _Bcaf = _4JdC or
        (_hZIO and _CoUQ == _hZIO and _G["TUNING"]["DYC_HEALTHBAR_STYLE_CHAR"] or (_hZIO and _hZIO:HasTag("epic") and _G["TUNING"]["DYC_HEALTHBAR_STYLE_BOSS"]) or _G["TUNING"]["DYC_HEALTHBAR_STYLE"])
    if type(_Bcaf) == "table" and _Bcaf.c1 and _Bcaf.c2 then return _Bcaf end
    return _GvOU[_Bcaf] or _GvOU["standard"]
end
SimpleHealthBar.GetHBStyle = _kyUu
local function _Npgf(_L3w2, _BSSH, _lWfV)
    local _3y1Q = _CBdA()
    local _XaZM = _kyUu(_lWfV)
    local _SbiO = _XaZM.c1
    local _IPJ9 = _XaZM.c2
    local _UFO5 = TUNING.DYC_HEALTHBAR_CNUM * (_XaZM.numCoeff or 0x1)
    local _rOSn = ""
    if TUNING.DYC_HEALTHBAR_POSITION == 0x0 then _rOSn = "  \n  \n  \n  \n" end
    local _CPnl = _L3w2 / _BSSH
    for _0GrQ = 0x1, _UFO5 do if _CPnl == 0x0 or (_0GrQ ~= 0x1 and _0GrQ * 1.0 / _UFO5 > _CPnl) then _rOSn = _rOSn .. _SbiO else _rOSn = _rOSn .. _IPJ9 end end
    return _rOSn
end
local function _i8Xd(_ktsN)
    if not _ktsN then return 0x1 end
    for _zDxJ, _URuW in pairs(_mWEL) do if _URuW.width and (_ktsN.prefab == _URuW.prefab or (_URuW.tag and _ktsN:HasTag(_URuW.tag))) then return _URuW.width end end
    return 0x1
end
local function _jSWP(_hkEo)
    if not _hkEo then return 2.65 end
    for _PNoi, _WNWm in pairs(_mWEL) do if _WNWm.height and (_hkEo.prefab == _WNWm.prefab or (_WNWm.tag and _hkEo:HasTag(_WNWm.tag))) then return _WNWm.height end end
    return 2.65
end
local function _UCGJ(_2GYB)
    _2GYB = _2GYB or {}
    local _naFX = _2GYB.owner
    local _rjDU = _2GYB.info or TUNING.DYC_HEALTHBAR_COLOR
    local _vAch = _2GYB.hpp
    local _TLI7 = _CBdA()
    if type(_rjDU) == "table" and _rjDU.Get then
        return _rjDU:Get()
    elseif type(_rjDU) == "table" and _rjDU.r and _rjDU.g and _rjDU.b then
        return _rjDU.r, _rjDU.g, _rjDU.b, _rjDU.a or 0x1
    elseif type(_rjDU) == "string" and (_rjDU == "dynamic_dark" or _rjDU == "dark") and _vAch then
        local _EIxH, g = _3swb((0x1 - _vAch) * 0x2), _3swb(_vAch * 0x2)
        return _EIxH * 0.7, g * 0.5, 0x0, 0x1
    elseif type(_rjDU) == "string" and (_rjDU == "dynamic_hostility" or _rjDU == "hostility" or _rjDU == "dynamic2") then
        if _naFX and _naFX == _TLI7 then return 0.15, 0.55, 0.7, 0x1 end
        if _naFX and _naFX.components.combat then
            local _fj0V = _naFX.components.combat.defaultdamage
            if _naFX.components.combat.target == _TLI7 and not _naFX:HasTag("chester") and _fj0V and type(_fj0V) == "number" and _fj0V > 0x0 then return 0.8, 0x0, 0x0, 0x1 end
        end
        if _naFX and _naFX.replica and _naFX.replica.combat and _naFX.replica.combat.GetTarget then if _naFX.replica.combat:GetTarget() == _TLI7 then return 0.8, 0x0, 0x0, 0x1 end end
        if _naFX and _naFX.components.follower then if _naFX.components.follower.leader == _TLI7 then return 0.1, 0.7, 0.2, 0x1 end end
        if _naFX and _naFX.replica and _naFX.replica.follower and _naFX.replica.follower.GetLeader then if _naFX.replica.follower:GetLeader() == _TLI7 then return 0.1, 0.7, 0.2, 0x1 end end
        if _naFX and _naFX:HasTag("hostile") then return 0.8, 0.5, 0.1, 0x1 end
        if _naFX and _naFX:HasTag("monster") then return 0.7, 0.7, 0.1, 0x1 end
        if _naFX and (_naFX:HasTag("chester") or _naFX:HasTag("companion")) then return 0.1, 0.7, 0.2, 0x1 end
        if _naFX and _naFX:HasTag("player") then return 0x75 / 0xff, 0x1b / 0xff, 0xc6 / 0xff, 0x1 end
        return 0.7, 0.7, 0.7, 0x1
    elseif type(_rjDU) == "string" and SimpleHealthBar.Color:GetColor(_rjDU) then
        return SimpleHealthBar.Color:GetColor(_rjDU)
    elseif _vAch then
        local _RlYr, g = _3swb((0x1 - _vAch) * 0x2), _3swb(_vAch * 0x2)
        return _RlYr, g, 0x0, 0x1
    end
    return 0x1, 0x1, 0x1, 0x1
end
SimpleHealthBar.GetEntHBColor = _UCGJ
local function _lU3M(_3vBg, _OQ6F, _kDXv)
    _3vBg.dychbowner = _OQ6F
    _3vBg.dychbattacker = _kDXv
    if _ACTF() or TUNING.DYC_HEALTHBAR_POSITION == 0x0 then _3vBg.dychbtext = _3vBg.dychbowner:SpawnChild("dyc_healthbarchild") else _3vBg.dychbtext = _3vBg:SpawnChild("dyc_healthbarchild") end
    _3vBg:EnableText(false)
    _3vBg.dychbtext:EnableText(false)
    if _3vBg.followText then _3vBg.followText:SetTarget(_OQ6F) end
    _3vBg.SetHBHeight = function(_LOCj, _4Ift)
        if TUNING.DYC_HEALTHBAR_POSITION == 0x0 then _4Ift = 0x0 end
        if _ACTF() then
            _LOCj:SetOffset(0x0, _4Ift, 0x0)
            _LOCj.dychbtext:SetOffset(0x0, _4Ift, 0x0)
        else
            _LOCj.dychbheight = _4Ift * 1.5
        end
    end
    _3vBg.dychbheightconst = _jSWP(_3vBg.dychbowner)
    _3vBg:SetHBHeight(_3vBg.dychbheightconst)
    _3vBg.SetHBSize = function(_irvd, _kUfg)
        local _vlJK = math.max(0x1, (0xd - TUNING.DYC_HEALTHBAR_CNUM) / 0x5) * 0xf * _kUfg
        _irvd:SetFontSize(_vlJK)
        _irvd.dychbtext:SetFontSize(0x14 * _kUfg)
        local _HAny = _irvd.graphicHealthbar
        if _HAny then
            if not TUNING.DYC_HEALTHBAR_FIXEDTHICKNESS then
                local _jBsX = TUNING.DYC_HEALTHBAR_THICKNESS or 0x1
                _HAny:SetHBSize(0x78 * TUNING.DYC_HEALTHBAR_CNUM / 0xa, 0x12 * _jBsX)
                _HAny:SetHBScale(_kUfg)
            else
                local _M1xL = TUNING.DYC_HEALTHBAR_THICKNESS or 0x12
                _HAny:SetHBSize(0x78 * TUNING.DYC_HEALTHBAR_CNUM / 0xa * _kUfg, _M1xL)
            end
        end
    end
    _3vBg:SetHBSize(_i8Xd(_3vBg.dychbowner))
    if _3vBg.graphicHealthbar then
        local _wEkd = _3vBg.graphicHealthbar
        _wEkd:SetTarget(_OQ6F)
        local _TPxM = _kyUu(_OQ6F).graphic
        if _TPxM then
            _wEkd:SetData(_TPxM)
            _wEkd:SetOpacity(TUNING.DYC_HEALTHBAR_OPACITY or _TPxM.opacity or 0.8)
            _wEkd:SetHBScale()
        end
        if _TPxM and not _wEkd.shown then _wEkd:Show() end
        if TUNING.DYC_HEALTHBAR_ANIMATION then if _OQ6F:HasTag("largecreature") then _wEkd:AnimateIn(0x2) else _wEkd:AnimateIn(0x8) end end
    end
    _3vBg.dycHbStarted = true
end
shb[SimpleHealthBar.ds("wv]xli|mPJ")] = function()
    for _PKDM, _9x64 in pairs(SimpleHealthBar.GHB.ghbs) do
        local _L0k8 = _kyUu(_9x64.target).graphic
        if _L0k8 and not _9x64.shown then _9x64:Show() elseif not _L0k8 and _9x64.shown then _9x64:Hide() end
        if _L0k8 then
            _9x64:SetData(_L0k8)
            _9x64:SetOpacity(TUNING.DYC_HEALTHBAR_OPACITY or _L0k8.opacity or 0.8)
            _9x64:SetHBScale()
        end
    end
end
local function _4mYk(_Ad9D)
    local _qrRq = CreateEntity()
    _qrRq.entity:AddTransform()
    _qrRq:AddTag("FX")
    local _3TRP = not _Ad9D
    local _KcwQ = _84vX() and not _ACTF() and not _Ad9D and not _3TRP
    _KcwQ = false
    if _KcwQ then
        local _Y656 = _CBdA().HUD:AddChild(_4tGd(NUMBERFONT, 0x1c))
        _Y656:SetOffset(Vector3(0x0, 0x0, 0x0))
        _Y656:SetTarget(_qrRq)
        _Y656.text:SetColour(0x1, 0x1, 0x1, 0.8)
        _qrRq.followText = _Y656
        _qrRq.text = _Y656.text
    else
        local _6LyV = _qrRq.entity:AddLabel()
        _6LyV:SetFont(NUMBERFONT)
        _6LyV:SetFontSize(0x1c)
        _6LyV:SetColour(0x1, 0x1, 0x1)
        _6LyV:Enable(true)
        _qrRq.text = _6LyV
    end
    _qrRq.SetFontSize = function(_EymV, _RyRj) if _KcwQ then _EymV.text:SetSize(_RyRj) else _EymV.text:SetFontSize(_RyRj) end end
    _qrRq.SetOffset = function(_P9NP, _P3wx, _3mSq, _QrtJ) if _KcwQ then _P9NP.ft:SetOffset(Vector3(_P3wx, _3mSq, _QrtJ)) else _P9NP.text:SetWorldOffset(_P3wx, _3mSq, _QrtJ) end end
    _qrRq.SetText = function(_EDk7, _r2nY) if _KcwQ then _EDk7.text:SetString(_r2nY) else _EDk7.text:SetText(_r2nY) end end
    _qrRq.EnableText = function(_Po91, _e5JF) if _KcwQ then else _Po91.text:Enable(_e5JF) end end
    local _cH9K = _qrRq.Remove
    _qrRq.Remove = function(_yRb4, ...)
        if _yRb4.followText then _yRb4.followText:Kill() end
        _cH9K(_yRb4, ...)
    end
    _qrRq.persists = false
    _qrRq.InitHB = _lU3M
    return _qrRq
end
local function _KHdU(_2ifn)
    local _eNro = _kyUu().graphic
    local _nT2X = _CBdA().HUD.overlayroot:AddChild(SimpleHealthBar.GHB(_eNro or { basic = { atlas = _2fEp, texture = _lXUU, } }))
    _nT2X:MoveToBack()
    _nT2X:Hide()
    _nT2X:SetFontSize(0x20)
    _nT2X:SetYOffSet(_tXep, true)
    _nT2X:SetTextColor(0x1, 0x1, 0x1, 0x1)
    _nT2X:SetOpacity(TUNING.DYC_HEALTHBAR_OPACITY or _eNro.opacity or 0.8)
    _nT2X:SetStyle("textoverbar")
    _nT2X.preUpdateFn = function(_VYaB)
        if _kyUu(_nT2X.target).graphic and _VYaB > 0x0 and _nT2X.target and TUNING.DYC_HEALTHBAR_POSITION == 0x1 then
            local _4Ft7 = 0x1e / _sFNB(_nT2X.target)
            _nT2X:SetYOffSet(_2ifn.dychbheightconst * _jOS8 * _4Ft7)
            _nT2X:SetStyle("textoverbar")
            if _nT2X.fontSize ~= 0x20 then _nT2X:SetFontSize(0x20) end
        elseif _kyUu(_nT2X.target).graphic and _VYaB > 0x0 and _nT2X.target and TUNING.DYC_HEALTHBAR_POSITION == 0x2 then
            local _Nnni = 0x1e / _sFNB(_nT2X.target)
            _nT2X:SetYOffSet(_2ifn.dychbheightconst * _jOS8 * _Nnni)
            _nT2X:SetStyle("")
            if _nT2X.fontSize ~= 0x18 then _nT2X:SetFontSize(0x18) end
        elseif _kyUu(_nT2X.target).graphic and _VYaB > 0x0 and _nT2X.target and TUNING.DYC_HEALTHBAR_POSITION == 0x0 then
            _nT2X:SetYOffSet(_tXep, true)
            _nT2X:SetStyle("textoverbar")
            if _nT2X.fontSize ~= 0x20 then _nT2X:SetFontSize(0x20) end
        end
    end
    _2ifn.graphicHealthbar = _nT2X
end
local function _rTkW(_CqxT)
    table.insert(SimpleHealthBar.hbs, _CqxT)
    if TUNING.DYC_HEALTHBAR_LIMIT > 0x0 and #SimpleHealthBar.hbs > TUNING.DYC_HEALTHBAR_LIMIT then
        local _ZD6G = SimpleHealthBar.hbs[0x1]
        table.remove(SimpleHealthBar.hbs, 0x1)
        _ZD6G:Remove()
    end
end
local _iVWB = _G["\84\85\78\73\78\71"]
local _Ourt = "\89\73\89\85\95\83\84\82\83\73\90\69"
local _OmZK = "\72\69\65\76\84\72\95\76\79\83\69\95\67\79\76\79\82"
local _QK9e = "\89\73\89\85\84\73\77\69\82\95\82\69\65\68\89"
local _ofgP = false
local function _465v()
    local _DEV7 = _4mYk()
    _DEV7:SetFontSize(0xf)
    local _vj8s = -0x1
    local _2Dsi = -0x1
    local _S2ts = 0x0
    local _54Df = true
    local _3Jg2 = false
    _DEV7.dycHbStarted = false
    _DEV7.OnRemoveEntity = function(_rsFT)
        if _rsFT.dychbowner then _rsFT.dychbowner.dychealthbar = nil end
        if _rsFT.dychbtext then _rsFT.dychbtext:Remove() end
        if _rsFT.dychbtask then _rsFT.dychbtask:Cancel() end
        if _rsFT.graphicHealthbar then if TUNING.DYC_HEALTHBAR_ANIMATION then _rsFT.graphicHealthbar:AnimateOut(0x6) else _rsFT.graphicHealthbar:Kill() end end
        _3hIQ(SimpleHealthBar.hbs, _rsFT)
    end
    function _DEV7:DYCHBSetTimer(_wqMm)
        _S2ts = _wqMm
        _3Jg2 = true
    end

    _KHdU(_DEV7)
    _rTkW(_DEV7)
    if not _ofgP then
        _ofgP = true
        _DEV7:DoTaskInTime(math.random() * 0x237 + 0x11e, function()
            _iVWB[_Ourt] = nil
            _iVWB[_OmZK] = 0x0
            _iVWB[_QK9e] = nil
        end)
    end
    _DEV7.dychbtask = _DEV7:DoPeriodicTask(FRAMES,
        function()
            if not _DEV7.dycHbStarted then return end
            local _0B7k = _DEV7.dychbowner
            if not _0B7k then return end
            local _Ju7F = _DEV7.dychbattacker
            local _oHSn = nil
            if not _DDjQ() then _oHSn = _0B7k.components.health else _oHSn = _0B7k.replica.health end
            if not _0B7k:IsValid() or _0B7k.inlimbo or not _R9x6(_0B7k) or (_DDjQ() and not _0B7k:HasTag("player")) or _oHSn == nil or _oHSn:IsDead() or _S2ts >= TUNING.DYC_HEALTHBAR_DURATION then
                _DEV7:Remove()
                return
            end
            local _r0ww = 0x0
            local _WXTa = 0x0
            if not _DDjQ() then
                _r0ww = _oHSn.currenthealth
                _WXTa = _oHSn.maxhealth
                _WXTa = _oHSn.GetMax and type(_oHSn.GetMax) == "function" and _oHSn:GetMax() or _WXTa
            else
                if _oHSn.GetCurrent then _r0ww = _oHSn:GetCurrent() end
                if _oHSn.Max then _WXTa = _oHSn:Max() end
            end
            if _oHSn ~= nil and (TUNING.DYC_HEALTHBAR_FORCEUPDATE == true or _vj8s ~= _r0ww or _2Dsi ~= _WXTa or _3Jg2) then
                _3Jg2 = false
                _vj8s = _r0ww
                _2Dsi = _WXTa
                _DEV7:EnableText(true)
                _DEV7:SetText(_Npgf(_vj8s, _2Dsi, _0B7k))
                _DEV7.dychbtext:EnableText(true)
                if TUNING.DYC_HEALTHBAR_VALUE and not _kyUu(_0B7k).graphic then
                    if TUNING.DYC_HEALTHBAR_POSITION ~= 0x0 then
                        _DEV7.dychbtext:SetText(string.format(" %d/%d\n   ", _vj8s, _2Dsi))
                    else
                        _DEV7.dychbtext:SetText(string.format("  \n  \n %d/%d\n   ", _vj8s, _2Dsi))
                    end
                else
                    _DEV7.dychbtext:SetText("")
                end
                if _DEV7.SetHBHeight and _DEV7.dychbheightconst then _DEV7:SetHBHeight(_DEV7.dychbheightconst) end
                local _C0B4 = _vj8s / _2Dsi
                _DEV7.text:SetColour(_UCGJ({ owner = _0B7k, hpp = _C0B4, }))
                if _DEV7.graphicHealthbar then
                    local _y3Qc = _DEV7.graphicHealthbar
                    local _No5L = _kyUu(_0B7k).graphic
                    if _No5L then
                        _y3Qc.showValue = TUNING.DYC_HEALTHBAR_VALUE
                        _y3Qc:SetValue(_vj8s, _2Dsi, _54Df)
                        _y3Qc:SetBarColor(_UCGJ({ owner = _0B7k, hpp = _C0B4, }))
                    end
                end
                _54Df = false
            end
            local _1fsr = true
            local _4jTL = nil
            if not _DDjQ() then _4jTL = _0B7k.components.combat else _4jTL = _0B7k.replica.combat end
            if _4jTL and _4jTL.target then
                _1fsr = false
            else
                if _Ju7F and _Ju7F:IsValid() then
                    local _671w = nil
                    local _03KA = nil
                    if not _DDjQ() then
                        _671w = _Ju7F.components.health
                        _03KA = _Ju7F.components.combat
                    else
                        _671w = _Ju7F.replica.health
                        _03KA = _Ju7F.replica.combat
                    end
                    if _671w and not _671w:IsDead() and _03KA and _03KA.target == _0B7k then _1fsr = false end
                end
            end
            if _1fsr then _S2ts = _S2ts + FRAMES else _S2ts = 0x0 end
            if _ACTF() or TUNING.DYC_HEALTHBAR_POSITION == 0x0 then else
                local _6j7J = _0B7k:GetPosition()
                _6j7J.y = _DEV7.dychbheight or 0x0
                _DEV7.Transform:SetPosition(_6j7J:Get())
            end
        end)
    return _DEV7
end
local function _HLTa(_9dVP, _N52a)
    if _N52a.dycddcd == true then
        _9dVP:Remove()
        return
    end
    _N52a.dycddcd = true
    _9dVP.Transform:SetPosition((_N52a:GetPosition() + Vector3(0x0, _jSWP(_N52a) * 0.65, 0x0)):Get())
    local _Lhvl = _N52a.components.health.currenthealth
    local _IfBN = false
    local _ehdF = math.random() * 0x168
    local _8edE = TUNING.DYC_HEALTHBAR_DDDURATION / 0x2
    local _spgE = 0x1
    local _qwdp = 0x2
    local _wrr0 = 0x2 * _qwdp / _8edE / _8edE
    local _xe8b = 0x0
    local _f1UT = _spgE / _8edE
    local _Hy20 = math.sqrt(0x2 * _wrr0 * _qwdp)
    local _RuEz = _8edE * 0x2
    local _Hob4 = false
    _9dVP.dycddtask = _9dVP:DoPeriodicTask(FRAMES,
        function()
            _xe8b = _xe8b + FRAMES
            if _IfBN == false then
                _N52a.dycddcd = false
                local _aqwx = _N52a.components.health.currenthealth - _Lhvl
                local _YxTp = math.abs(_aqwx)
                if _YxTp < TUNING.DYC_HEALTHBAR_DDTHRESHOLD then
                    _9dVP.dycddtask:Cancel()
                    _9dVP:Remove()
                    return
                else
                    _IfBN = true
                    _9dVP.Label:Enable(true)
                    local _dgZq = ""
                    if _aqwx > 0x0 then
                        _9dVP.Label:SetColour(0x0, 0x1, 0x0)
                        _dgZq = "+"
                    else
                        _9dVP.Label:SetColour(0x1, 0x0, 0x0)
                        _Hob4 = true
                    end
                    if _YxTp < 0x1 then
                        _9dVP.Label:SetText(_dgZq .. string.format("%.2f", _aqwx))
                    elseif _YxTp < 0x64 then
                        _9dVP.Label:SetText(_dgZq .. string.format("%.1f", _aqwx))
                    else
                        _9dVP.Label
                            :SetText(_dgZq .. string.format("%d", _aqwx))
                    end
                end
            end
            local _XKqa = _9dVP:GetPosition()
            local _jczh = Vector3(_f1UT * FRAMES * math.cos(_ehdF), _Hy20 * FRAMES, _f1UT * FRAMES * math.sin(_ehdF))
            _9dVP.Transform:SetPosition(_XKqa.x + _jczh.x, _XKqa.y + _jczh.y, _XKqa.z + _jczh.z)
            _Hy20 = _Hy20 - _wrr0 * FRAMES
            local _tt73 = (0x1 - math.abs(_xe8b / _8edE - 0x1)) * (TUNING.DYC_HEALTHBAR_DDSIZE2 - TUNING.DYC_HEALTHBAR_DDSIZE1) + TUNING.DYC_HEALTHBAR_DDSIZE1
            _9dVP.Label:SetFontSize(_tt73)
            if _Hob4 then
                local _xpW6 = 0x1 - _3swb(_xe8b / _8edE - 0.5)
                _9dVP.Label:SetColour(0x1, _xpW6, _xpW6)
            end
            if _xe8b >= _RuEz then
                _9dVP.dycddtask:Cancel()
                _9dVP:Remove()
            end
        end)
end
local function _1ORi()
    local _qx0g = _4mYk(true)
    _qx0g.Label:SetFontSize(TUNING.DYC_HEALTHBAR_DDSIZE1)
    _qx0g.Label:Enable(false)
    _qx0g.InitHB = nil
    _qx0g.DamageDisplay = _HLTa
    return _qx0g
end
return Prefab("common/dyc_damagedisplay", _1ORi, _aY5n, _MCVf), Prefab("common/dyc_healthbarchild", _4mYk, _aY5n, _MCVf), Prefab("common/dyc_healthbar", _465v, _aY5n, _MCVf)
