globals
    constant integer JAGOT_COOLDOWN_REDUCTION = 4
    constant integer JAGOT_CLOCK_ID = 'I0GJ'
    
    constant string JAGOT_ANIMATION = "war3mapImported\\TimeUpheaval.mdl"
endglobals

function Trig_Jagot_Conditions takes nothing returns boolean
    return inv( GetSpellAbilityUnit(), 'I0GI' ) > 0 and GetSpellAbilityId() == udg_DB_Hero_FirstSpell[udg_HeroNum[GetUnitUserData(GetSpellAbilityUnit())]]
endfunction

function Trig_Jagot_Actions takes nothing returns nothing
    local unit caster = GetSpellAbilityUnit()

    set bj_lastCreatedItem = CreateItem( JAGOT_CLOCK_ID, Math_GetUnitRandomX(caster, 200), Math_GetUnitRandomY(caster, 200) )
    call DestroyEffect( AddSpecialEffect( JAGOT_ANIMATION, GetItemX( bj_lastCreatedItem ), GetItemY( bj_lastCreatedItem ) ) )

    set caster = null
endfunction

//===========================================================================
function InitTrig_Jagot takes nothing returns nothing
    set gg_trg_Jagot = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Jagot, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Jagot, Condition( function Trig_Jagot_Conditions ) )
    call TriggerAddAction( gg_trg_Jagot, function Trig_Jagot_Actions )
endfunction

