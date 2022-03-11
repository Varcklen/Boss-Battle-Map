function Trig_ShoggothW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A195'
endfunction

function Trig_ShoggothW_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local unit caster
    local integer lvl
    local real x
    local real y
    local real xc
    local real yc
    local real t
    local integer cyclA
    local integer k
    local real r
    
    if CastLogic() then
        set caster = udg_Caster
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        call textst( udg_string[0] + GetObjectName('A195'), caster, 64, 90, 10, 1.5 )
        set t = 10
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
        set t = 10
    endif
    set t = timebonus(caster, t)
    
    set k = 3 + lvl
    call GroupEnumUnitsInRange( g, x, y, 350, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "enemy" ) then
            if GetUnitDefaultMoveSpeed(u) != 0 then
                call DestroyEffect( AddSpecialEffect("Void Teleport Caster.mdx", GetUnitX(u), GetUnitY(u) ) )
                call SetUnitPosition( u, x, y )
                call DestroyEffect( AddSpecialEffect( "Void Teleport Caster.mdx", GetUnitX(u), GetUnitY(u) ) )
            endif
            call bufallst( caster, u, 'A196', 'A197', 0, 0, 0, 'B02B', "shgw", t )
            call SetUnitAbilityLevel( u, 'A197', lvl )
            call debuffst( caster, u, null, lvl, t )
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    set r = 360/k
    set cyclA = 1
    loop
        exitwhen cyclA > k
        set xc = x + 200 * Cos( r * cyclA * bj_DEGTORAD)
        set yc = y + 200 * Sin( r * cyclA * bj_DEGTORAD)
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer(caster), 'n03F', xc, yc, 270 )
        call UnitApplyTimedLife( bj_lastCreatedUnit , 'BTLF', 15 )
        call SetUnitAnimation( bj_lastCreatedUnit, "birth" )
        call QueueUnitAnimation( bj_lastCreatedUnit, "stand" )
        set cyclA = cyclA + 1
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_ShoggothW takes nothing returns nothing
    set gg_trg_ShoggothW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ShoggothW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ShoggothW, Condition( function Trig_ShoggothW_Conditions ) )
    call TriggerAddAction( gg_trg_ShoggothW, function Trig_ShoggothW_Actions )
endfunction

