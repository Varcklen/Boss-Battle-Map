function Trig_KeeperR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0EF'
endfunction

function KeeperREnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "kepr1" ) )

    call spdst( u, -LoadReal( udg_hash, GetHandleId( u ), StringHash( "kepr1" ) ) )
    call UnitRemoveAbility( u, 'A0PV' )
    call UnitRemoveAbility( u, 'B09D' )
    call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( "kepr1" ) )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function KeeperRCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
	local unit u = LoadUnitHandle( udg_hash, id, StringHash( "kepr" ) )
    local integer spd = LoadInteger( udg_hash, id, StringHash( "kepr" ) )
    local integer id1
    local real isum
    local real t
    
    if GetUnitAbilityLevel( u, 'A0JB') > 0 and IsUnitType( u, UNIT_TYPE_HERO) then
        call UnitAddAbility( u, 'A0PV' )
        set t = timebonus(u, 5)

        call spdst( u, spd )
        set isum = LoadReal( udg_hash, GetHandleId( u ), StringHash( "kepr1" ) ) + spd
        call SaveReal( udg_hash, GetHandleId( u ), StringHash( "kepr1" ), isum )
        call DestroyEffect(AddSpecialEffectTarget("DarkSwirl.mdx", u, "overhead") )
        
        set id1 = GetHandleId( u )
        if LoadTimerHandle( udg_hash, id1, StringHash( "kepr1" ) ) == null then
            call SaveTimerHandle( udg_hash, id1, StringHash( "kepr1" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "kepr1" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "kepr1" ), u )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "kepr1" ) ), t, false, function KeeperREnd )
        
        call effst( u, u, null, 1, t )
    endif
    call UnitRemoveAbility( u, 'A0JB' )
    call FlushChildHashtable( udg_hash, id )

	set u = null
endfunction

function Trig_KeeperR_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local integer lvl
    local real t
    local real mana
    local integer spd
    local group g = CreateGroup()
    local unit u
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0EF'), caster, 64, 90, 10, 1.5 )
        set t = 3
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 3
    endif
    set t = timebonus(caster, t)
    set id = GetHandleId( caster )
    set mana = 40 + (lvl*20)
    set spd = 20+(20*lvl)
    
    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 450, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "all" ) then
            call spectime( "Abilities\\Spells\\Undead\\Darksummoning\\DarkSummonTarget.mdl", GetUnitX(u), GetUnitY(u), 1 )
            call UnitAddAbility( u, 'A0JB' )
            if IsUnitType( u, UNIT_TYPE_HERO) then
                if caster != u then
                    call manast( caster, u, mana )
                endif
                call shadowst(u)
            endif
            set id = GetHandleId( u )
            if LoadTimerHandle( udg_hash, id, StringHash( "kepr" ) ) == null then
       			call SaveTimerHandle( udg_hash, id, StringHash( "kepr" ), CreateTimer() )
    		endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "kepr" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "kepr" ), u )
            call SaveInteger( udg_hash, id, StringHash( "kepr" ), spd )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "kepr" ) ), t, false, function KeeperRCast )
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_KeeperR takes nothing returns nothing
    set gg_trg_KeeperR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_KeeperR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_KeeperR, Condition( function Trig_KeeperR_Conditions ) )
    call TriggerAddAction( gg_trg_KeeperR, function Trig_KeeperR_Actions )
endfunction

