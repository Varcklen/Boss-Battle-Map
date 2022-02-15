/*function MoonclothLogic takes nothing returns boolean
    local integer cyclA = 1
    local integer cyclAEnd = udg_Database_InfoNumberHeroes
    local boolean l = false
    
    loop
        exitwhen cyclA > cyclAEnd
        if GetSpellAbilityId() == udg_DB_Hero_FirstSpell[cyclA] then
            set l = true
            set cyclA = cyclAEnd
        endif
        set cyclA = cyclA  + 1
    endloop
    return l
endfunction*/

function Trig_Mooncloth_Conditions takes nothing returns boolean//MoonclothLogic() and
    return IsUnitInGroup(GetSpellAbilityUnit(), udg_heroinfo) and inv( GetSpellAbilityUnit(), 'I0AD' ) > 0 and GetSpellAbilityId() == Database_Hero_Abilities[1][udg_HeroNum[GetUnitUserData(GetSpellAbilityUnit())]]
endfunction

function MoonclothCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local integer t = LoadInteger( udg_hash, id, StringHash( "mncl" ) ) + 1
    local real counter = LoadReal( udg_hash, id, StringHash( "mncl" ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "mncl" ) )

    if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 and t >= 2 then
        call manast( u, null, GetUnitState( u, UNIT_STATE_MAX_MANA) * 0.01 )
        set t = 0
    endif
    
    if counter > 1 and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
        call SaveReal( udg_hash, id, StringHash( "mncl" ), counter - 1 )
        call SaveInteger( udg_hash, id, StringHash( "mncl" ), t )
    else
        call UnitRemoveAbility( u, 'A0ZU' )
        call UnitRemoveAbility( u, 'B05M' )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    endif
    
    set u = null
endfunction

function Trig_Mooncloth_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer k
    local integer id
    local real t
    local unit u
    local unit caster
    local unit target
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set t = udg_Time
    else
        set caster = GetSpellAbilityUnit()
        set target = null
        set t = 12
    endif
    set t = timebonus(caster, t)
    
    if udg_BuffLogic then
        set k = 1
    else
        set k = 4
    endif
    loop
        exitwhen cyclA > k
        if udg_BuffLogic then
            set u = target
        else
            set u = udg_hero[cyclA]
        endif
        if unitst( u, GetSpellAbilityUnit(), "ally" ) then
            set id = GetHandleId( u )

            call UnitAddAbility( u, 'A0ZU' )
            
            if LoadTimerHandle( udg_hash, id, StringHash( "mncl" ) ) == null  then
                call SaveTimerHandle( udg_hash, id, StringHash( "mncl" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mncl" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "mncl" ), u )
            call SaveReal( udg_hash, id, StringHash( "mncl" ), t )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "mncl" ) ), 1, true, function MoonclothCast ) 
            
            if BuffLogic() then
                call effst( caster, u, "Trig_Mooncloth_Actions", 1, 12 )
            endif
        endif
        set cyclA = cyclA + 1
    endloop

    set caster = null
    set target = null
    set u = null
endfunction

//===========================================================================
function InitTrig_Mooncloth takes nothing returns nothing
    set gg_trg_Mooncloth = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Mooncloth, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Mooncloth, Condition( function Trig_Mooncloth_Conditions ) )
    call TriggerAddAction( gg_trg_Mooncloth, function Trig_Mooncloth_Actions )
endfunction

