function Trig_Necro_Wool_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0YM'
endfunction

function Trig_Necro_Wool_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local integer cyclA = 1
    local integer cyclAEnd 
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0YM'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set cyclAEnd = eyest( caster )
  
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", caster, "origin" ) )
     loop
        exitwhen cyclA > cyclAEnd
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 600, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if IsUnitAlly( u, GetOwningPlayer( caster ) ) and not( IsUnitType( u, UNIT_TYPE_HERO) ) and not( IsUnitType( u, UNIT_TYPE_ANCIENT) ) and GetUnitAbilityLevel( u, 'Avul') == 0 then
                call UnitAddAbility( u, 'A0YO')
                call GroupAddUnit( udg_NecroWool, u )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
        set cyclA = cyclA + 1
    endloop
    
    set u = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_Necro_Wool takes nothing returns nothing
    set gg_trg_Necro_Wool = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Necro_Wool, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Necro_Wool, Condition( function Trig_Necro_Wool_Conditions ) )
    call TriggerAddAction( gg_trg_Necro_Wool, function Trig_Necro_Wool_Actions )
endfunction

