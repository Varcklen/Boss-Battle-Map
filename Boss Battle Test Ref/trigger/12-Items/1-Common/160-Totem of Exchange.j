function Trig_Totem_of_Exchange_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A17S' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function Trig_Totem_of_Exchange_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd 
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A17S'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif 
    
    call DestroyEffect( AddSpecialEffectTarget( "Blood Explosion.mdx", caster, "origin" ) )
    set cyclAEnd  = eyest( caster )
    loop
        exitwhen cyclA > cyclAEnd
        if BlzGetUnitIntegerField(caster,UNIT_IF_PRIMARY_ATTRIBUTE) == 1 and GetHeroStr( caster, false) > 2 then
            call statst( caster, -2, 2, 2, 0, true )
        elseif BlzGetUnitIntegerField(caster,UNIT_IF_PRIMARY_ATTRIBUTE) == 2 and GetHeroInt( caster, false) > 2 then
            call statst( caster, 2, 2, -2, 0, true )
        elseif BlzGetUnitIntegerField(caster,UNIT_IF_PRIMARY_ATTRIBUTE) == 3 and GetHeroAgi( caster, false) > 2 then
            call statst( caster, 2, -2, 2, 0, true )
        endif
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Totem_of_Exchange takes nothing returns nothing
    set gg_trg_Totem_of_Exchange = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Totem_of_Exchange, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Totem_of_Exchange, Condition( function Trig_Totem_of_Exchange_Conditions ) )
    call TriggerAddAction( gg_trg_Totem_of_Exchange, function Trig_Totem_of_Exchange_Actions )
endfunction

