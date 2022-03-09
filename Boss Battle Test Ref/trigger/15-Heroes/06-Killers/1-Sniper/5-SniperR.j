function Trig_SniperR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0LN'
endfunction

function Trig_SniperR_Actions takes nothing returns nothing
    local unit caster
    local item it
    local integer lvl
    local real x
    local real y
    local real heal
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        call textst( udg_string[0] + GetObjectName('A0LN'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif

    set heal = 90. + ( 90. * lvl )

        set it = CreateItem( 'I05T', x, y )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", x, y ) )
        call SaveUnitHandle( udg_hash, GetHandleId( it ), StringHash( "snpr" ), caster )
        call SaveReal( udg_hash, GetHandleId( it ), StringHash( "snpr" ), heal )
    
    set caster = null
    set it = null
endfunction

//===========================================================================
function InitTrig_SniperR takes nothing returns nothing
    set gg_trg_SniperR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SniperR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SniperR, Condition( function Trig_SniperR_Conditions ) )
    call TriggerAddAction( gg_trg_SniperR, function Trig_SniperR_Actions )
endfunction

