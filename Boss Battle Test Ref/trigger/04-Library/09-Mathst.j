library Math initializer init

    struct point
        real x
        real y
        
        method Set takes real x, real y returns nothing
            set .x = x
            set .y = y
        endmethod
        
        method SetFromPoint takes point p returns nothing
            set .x = p.x
            set .y = p.y
            call p.destroy()
        endmethod
    endstruct

    globals
        point Point
    endglobals

    function AngleBetweenUnits takes unit a, unit b returns real
        local real r = bj_RADTODEG * Atan2(GetUnitY(a) - GetUnitY(b), GetUnitX(a) - GetUnitX(b))
        set a = null
        set b = null
        return r
    endfunction
    
    function GetAngleBetweenPoints takes point a, point b returns real
        local real r = bj_RADTODEG * Atan2(a.y - b.y, a.x - b.x)
        call a.destroy()
        call b.destroy()
        return r
    endfunction

    function DistanceBetweenUnits takes unit u, unit n returns real
        local real dx = GetUnitX(u) - GetUnitX(n)
        local real dy = GetUnitY(u) - GetUnitY(n)
        set u = null
        set n = null
        return SquareRoot(dx * dx + dy * dy)
    endfunction
    
    function DistanceBetweenCustomPoints takes point a, point b returns real
        local real dx = a.x - b.x
        local real dy = a.y - b.y
        call a.destroy()
        call b.destroy()
        return SquareRoot(dx * dx + dy * dy)
    endfunction

    function MoveLightningUnits takes lightning l, unit u, unit n returns nothing
        call MoveLightningEx(l, true, GetUnitX(u), GetUnitY(u), GetUnitFlyHeight(u), GetUnitX(n), GetUnitY(n), GetUnitFlyHeight(n))
        set l = null
        set u = null
        set n = null
    endfunction

    function SpecialEffectAngle takes string str, real angle, real x, real y returns nothing
        local effect fx = AddSpecialEffect(str, x, y )
        call BlzSetSpecialEffectYaw( fx, angle*3.14/180 )
        call DestroyEffect( fx )
        set fx = null
    endfunction

    function GetMovedPointBetweenUnits takes unit unitWho, unit unitTo, real distance returns point
        local real angle = Atan2( GetUnitY( unitTo ) - GetUnitY( unitWho ), GetUnitX( unitTo ) - GetUnitX( unitWho ) )
        
        set Point.x = GetUnitX( unitWho ) + distance * Cos( angle )
        set Point.y = GetUnitY( unitWho ) + distance * Sin( angle )
        set unitWho = null
        set unitTo = null
        return Point
    endfunction

    /*function GetMovedLocationBetweenLocation takes location loc1, location loc2, real distance returns location
        local real angle = Atan2( GetLocationY( loc2 ) - GetLocationY( loc1 ), GetLocationX( loc2 ) - GetLocationX( loc1 ) )
        local real NewX = GetLocationX( loc1 ) + distance * Cos( angle )
        local real NewY = GetLocationY( loc1 ) + distance * Sin( angle )
        set loc = Location(NewX, NewY)
        set loc1 = null
        set loc2 = null
        return loc
    endfunction*/

    public function Split takes integer i returns integer
        return R2I((i+1)/2)
    endfunction
    
    public function IsNumberInteger takes real r returns boolean
        //call BJDebugMsg("Check r: " + R2S(r) )
        //call BJDebugMsg("Check i: " + I2S(R2I(r)) )
        return R2I(r) == r
    endfunction

    public function GetUnitRandomX takes unit whichUnit, real scatter returns real
        return GetUnitX(whichUnit) + GetRandomReal(-scatter, scatter)
    endfunction

    public function GetUnitRandomY takes unit whichUnit, real scatter returns real
        return GetUnitY(whichUnit) + GetRandomReal(-scatter, scatter)
    endfunction
    
    public function GetRandomX takes real x, real scatter returns real
        return x + GetRandomReal(-scatter, scatter)
    endfunction

    public function GetRandomY takes real y, real scatter returns real
        return y + GetRandomReal(-scatter, scatter)
    endfunction
    
    function GetRandomPointInRect takes rect whichRect returns point
        set Point.x = GetRandomReal(GetRectMinX(whichRect), GetRectMaxX(whichRect))
        set Point.y = GetRandomReal(GetRectMinY(whichRect), GetRectMaxY(whichRect))
        set whichRect = null
        return Point
    endfunction
    
    function GetMovedPoint takes effect wave, real yaw, real distance returns point
        set Point.x = BlzGetLocalSpecialEffectX( wave ) + distance * Cos( yaw )
        set Point.y = BlzGetLocalSpecialEffectY( wave ) + distance * Sin( yaw )
        set wave = null
        return Point
    endfunction
    
    function GetMovedPointByPoint takes point p, real yaw, real distance returns point
        set Point.x = p.x + distance * Cos( yaw )
        set Point.y = p.y + distance * Sin( yaw )
        call p.destroy()
        return Point
    endfunction
    
    private function init takes nothing returns nothing
        set Point = point.create()
    endfunction
endlibrary