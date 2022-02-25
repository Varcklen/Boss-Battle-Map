function Trig_Sheep_bite_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0YU'
endfunction

function Trig_Sheep_bite_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local integer cyclA = 1
    local integer cyclAEnd 
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0YU'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set cyclAEnd = eyest( caster )
  
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", caster, "origin" ) )
    loop
        exitwhen cyclA > cyclAEnd
        set bj_livingPlayerUnitsTypeId = ID_SHEEP
        call GroupEnumUnitsOfPlayer(g, GetOwningPlayer( caster ), filterLivingPlayerUnitsOfTypeId)
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", u, "origin" ) )
            call BlzSetUnitBaseDamage( u, BlzGetUnitBaseDamage(u, 0)+8, 0 )
            call BlzSetUnitMaxHP( u, ( BlzGetUnitMaxHP(u) + 150 ) )
            call SetUnitState( u, UNIT_STATE_LIFE, GetUnitState( u, UNIT_STATE_LIFE) + 150 )
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
        set cyclA = cyclA + 1
    endloop
    
    set u = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_Sheep_bite takes nothing returns nothing
    set gg_trg_Sheep_bite = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Sheep_bite, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Sheep_bite, Condition( function Trig_Sheep_bite_Conditions ) )
    call TriggerAddAction( gg_trg_Sheep_bite, function Trig_Sheep_bite_Actions )
endfunction

