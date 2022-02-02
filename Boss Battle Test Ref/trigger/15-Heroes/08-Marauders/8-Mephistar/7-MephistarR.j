globals
    constant integer MEPHISTAR_R_DAMAGE_FIST_LEVEL = 5
    constant integer MEPHISTAR_R_DAMAGE_LEVEL_BONUS = 20
endglobals

function Trig_MephistarR_Conditions takes nothing returns boolean
    return udg_DamageEventAmount > 0 and not( udg_IsDamageSpell ) and IsUnitEnemy( udg_DamageEventSource, GetOwningPlayer( udg_DamageEventTarget ) ) and luckylogic( udg_DamageEventSource, 2+(4*GetUnitAbilityLevel( udg_DamageEventSource, 'A161')), 1, 100 ) and GetUnitAbilityLevel( udg_DamageEventSource, 'A161') > 0
endfunction

function Trig_MephistarR_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local unit c = udg_DamageEventSource
    local unit t = udg_DamageEventTarget
    local integer lvl = GetUnitAbilityLevel( c, 'A161')
    local real dmg = MEPHISTAR_R_DAMAGE_FIST_LEVEL + (MEPHISTAR_R_DAMAGE_LEVEL_BONUS*lvl)
    
    call DestroyEffect( AddSpecialEffect( "war3mapImported\\ArcaneExplosion.mdx", GetUnitX(t), GetUnitY(t) ) )
    
    call dummyspawn( c, 1, 0, 0, 0 )
    call GroupEnumUnitsInRange( g, GetUnitX( t ), GetUnitY( t ), 300, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, c, "enemy" ) then
            if GetRandomInt( 1, 4 ) == 1 and combat( c, false, 0 ) and not( udg_fightmod[3] ) then
                set bj_lastCreatedItem = CreateItem( 'I02U', GetUnitX( u ) + GetRandomReal( -200, 200 ), GetUnitY( u ) + GetRandomReal( -200, 200 ) )
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetItemX( bj_lastCreatedItem ), GetItemY( bj_lastCreatedItem ) ) )
            endif
            call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
        elseif unitst( u, c, "ally" ) then
            if GetRandomInt( 1, 3 ) == 1 and combat( c, false, 0 ) and not( udg_fightmod[3] ) then
                set bj_lastCreatedItem = CreateItem( 'I02U', GetUnitX( u ) + GetRandomReal( -200, 200 ), GetUnitY( u ) + GetRandomReal( -200, 200 ) )
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetItemX( bj_lastCreatedItem ), GetItemY( bj_lastCreatedItem ) ) )
            endif
            call healst(c, u, dmg )
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set c = null
    set t = null
endfunction

//===========================================================================
function InitTrig_MephistarR takes nothing returns nothing
    set gg_trg_MephistarR = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_MephistarR, "udg_DamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_MephistarR, Condition( function Trig_MephistarR_Conditions ) )
    call TriggerAddAction( gg_trg_MephistarR, function Trig_MephistarR_Actions )
endfunction

