function Trig_Unstable_Potions_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A1B3'
endfunction

function Unstable_PotionsCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "unst" ) )

    call RemoveItem(it)
    call FlushChildHashtable( udg_hash, id )
    
    set it = null
endfunction

function Trig_Unstable_Potions_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A1B3'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
    if UnitInventoryCount(caster) < 6 then
        set bj_lastCreatedItem = CreateItem( 'I056', GetUnitX(caster), GetUnitY(caster) )
        call SaveBoolean( udg_hash, GetHandleId( bj_lastCreatedItem ), StringHash( "nocrt" ), true )
        call UnitAddItem( caster, bj_lastCreatedItem )
        call BlzStartUnitAbilityCooldown( caster, 'A04E', 0.1 )
        
        set id = GetHandleId( bj_lastCreatedItem )
        if LoadTimerHandle( udg_hash, id, StringHash( "unst" ) ) == null then
            call SaveTimerHandle( udg_hash, id, StringHash( "unst" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "unst" ) ) ) 
        call SaveItemHandle( udg_hash, id, StringHash( "unst" ), bj_lastCreatedItem )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedItem ), StringHash( "unst" ) ), 2, false, function Unstable_PotionsCast ) 
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Unstable_Potions takes nothing returns nothing
    set gg_trg_Unstable_Potions = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Unstable_Potions, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Unstable_Potions, Condition( function Trig_Unstable_Potions_Conditions ) )
    call TriggerAddAction( gg_trg_Unstable_Potions, function Trig_Unstable_Potions_Actions )
endfunction

