function Trig_Tear_of_Asha_Conditions takes nothing returns boolean
    return combat( GetSpellAbilityUnit(), false, 0 ) and not( udg_fightmod[3] ) and inv( GetSpellAbilityUnit(), 'I0GH') > 0
endfunction

function Trig_Tear_of_Asha_Actions takes nothing returns nothing
    local unit u = GetSpellAbilityUnit()
    local item it = GetItemOfTypeFromUnitBJ( u, 'I0GH')
    local integer id = GetHandleId( it )
    local integer s = LoadInteger( udg_hash, id, StringHash( "tosh" ) ) + 1
    
    if BlzGetItemAbility( it, 'A125' ) == null then
        call SaveInteger( udg_hash, id, StringHash( "tosh" ), s )
        if s < 20 then
            call textst( "|c005050FF " + I2S(s) + "/20", u, 64, GetRandomReal( 0, 360 ), 7, 1.5 )
        else
            call textst( "|c005050FF +350% mana regeneration!", u, 64, 90, 10, 1.5 )
            call DestroyEffect( AddSpecialEffect("war3mapImported\\SoulRitual.mdx", GetUnitX( u ), GetUnitY( u ) ) )
            call BlzItemAddAbilityBJ( it, 'A125' )
        endif
    endif
    
    set u = null
    set it = null
endfunction

//===========================================================================
function InitTrig_Tear_of_Asha takes nothing returns nothing
    set gg_trg_Tear_of_Asha = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Tear_of_Asha, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Tear_of_Asha, Condition( function Trig_Tear_of_Asha_Conditions ) )
    call TriggerAddAction( gg_trg_Tear_of_Asha, function Trig_Tear_of_Asha_Actions )
endfunction

scope TearofAsha initializer init
    private function Conditions takes nothing returns boolean
        return IsHeroHasItem(udg_FightStart_Unit, 'I0GH')
    endfunction
    
    private function Action takes nothing returns nothing
        local unit hero = udg_FightStart_Unit
        local integer i
        local item it

        set i = 0
        loop
            exitwhen i > 5
            set it = UnitItemInSlot( hero, i)
            if GetItemTypeId(it) == 'I0GH' then
                call SaveInteger( udg_hash, GetHandleId( it ), StringHash( "tosh" ), 0 )
                call BlzItemRemoveAbilityBJ( it, 'A125' )
            endif
            set i = i + 1
        endloop
        
        set it = null
        set hero = null
    endfunction

    private function init takes nothing returns nothing
        call CreateEventTrigger( "udg_FightEnd_Real", function Action, function Conditions )
    endfunction
endscope
