function Trig_Muta_Mushroom_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0OB'
endfunction

function Trig_Muta_Mushroom_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local integer cyclA = 1
    local integer cyclAEnd 
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0OB'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set cyclAEnd =  eyest( caster )

    loop
        exitwhen cyclA > cyclAEnd
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 450, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "all" ) and not( IsUnitType( u, UNIT_TYPE_HERO) ) and not( IsUnitType( u, UNIT_TYPE_ANCIENT) ) and GetUnitAbilityLevel( u, 'Avul') == 0  then
                call KillUnit( u )
                set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( u ), udg_Database_RandomUnit[GetRandomInt(1, udg_Database_NumberItems[5])], GetUnitX( u ), GetUnitY( u ), GetRandomReal( 0, 360 ) )
                call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 20)
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", bj_lastCreatedUnit, "origin" ) )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
        set cyclA = cyclA + 1
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_Muta_Mushroom takes nothing returns nothing
    set gg_trg_Muta_Mushroom = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Muta_Mushroom, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Muta_Mushroom, Condition( function Trig_Muta_Mushroom_Conditions ) )
    call TriggerAddAction( gg_trg_Muta_Mushroom, function Trig_Muta_Mushroom_Actions )
endfunction

