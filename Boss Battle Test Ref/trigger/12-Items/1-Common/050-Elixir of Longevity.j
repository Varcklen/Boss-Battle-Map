function Trig_Elixir_of_Longevity_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0UE'
endfunction

function Trig_Elixir_of_Longevity_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local integer cyclA = 1
    local integer cyclAEnd 
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0UE'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set cyclAEnd =  eyest( caster )
    
    loop
        exitwhen cyclA > cyclAEnd
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 600, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "ally" ) and not(IsUnitType( u, UNIT_TYPE_HERO)) and not( IsUnitType(u, UNIT_TYPE_ANCIENT) ) and GetUnitTypeId(u) != 'u00X' then
                call healst( caster, u, 100 )
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl", u, "origin" ) )
                call BlzSetUnitBaseDamage( u, BlzGetUnitBaseDamage(u, 0)+IMaxBJ(1,R2I(BlzGetUnitBaseDamage(u, 0)*0.15)), 0 )
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
function InitTrig_Elixir_of_Longevity takes nothing returns nothing
    set gg_trg_Elixir_of_Longevity = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Elixir_of_Longevity, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Elixir_of_Longevity, Condition( function Trig_Elixir_of_Longevity_Conditions ) )
    call TriggerAddAction( gg_trg_Elixir_of_Longevity, function Trig_Elixir_of_Longevity_Actions )
endfunction

