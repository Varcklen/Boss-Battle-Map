function Trig_DryadR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0HP'
endfunction

function DryadRCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "drdr" ) )
    
    call UnitRemoveAbility( u, 'A0H0' )
    call UnitRemoveAbility( u, 'B06D' )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function DryadR1Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    
    call DestroyEffect( LoadEffectHandle( udg_hash, id, StringHash( "drdr1" ) ) )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_DryadR_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local integer id 
    local integer lvl
    local unit caster
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0HP'), caster, 64, 90, 10, 1.5 )
        set t = 15
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )
        set t = 15
    endif
    set id = GetHandleId( caster )
    
    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 600, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "ally") then
            call healst( caster, u, 25+(25*lvl) )
            call manast( caster, u, 10+(10*lvl) )
            call UnitAddAbility( u, 'A0H0' )
            call SetUnitAbilityLevel( u, 'A0H3', lvl )
            set id = GetHandleId( u )
            if LoadTimerHandle( udg_hash, id, StringHash( "drdr" ) ) == null then
                call SaveTimerHandle( udg_hash, id, StringHash( "drdr" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "drdr" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "drdr" ), u )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "drdr" ) ), t, false, function DryadRCast )
    
            if BuffLogic() then
                call effst( caster, u, null, lvl, t )
            endif
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    set bj_lastCreatedEffect = AddSpecialEffect( "Abilities\\Spells\\NightElf\\Tranquility\\Tranquility.mdl", GetUnitX(caster), GetUnitY(caster) )
    
    set id = GetHandleId( bj_lastCreatedEffect )
    if LoadTimerHandle( udg_hash, id, StringHash( "drdr1" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "drdr1" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "drdr1" ) ) )
    call SaveEffectHandle( udg_hash, id, StringHash( "drdr1" ), bj_lastCreatedEffect )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedEffect ), StringHash( "drdr1" ) ), 2.5, false, function DryadR1Cast )
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_DryadR takes nothing returns nothing
    set gg_trg_DryadR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DryadR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DryadR, Condition( function Trig_DryadR_Conditions ) )
    call TriggerAddAction( gg_trg_DryadR, function Trig_DryadR_Actions )
endfunction

