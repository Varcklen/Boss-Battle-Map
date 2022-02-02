function Trig_BossKill_Conditions takes nothing returns boolean
    return IsUnitInGroup(GetDyingUnit(), udg_Bosses)
endfunction

function HeroesTP takes nothing returns nothing
    local integer cyclA = 1

    loop
        exitwhen cyclA > 4
        if udg_hero[cyclA] != null and GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
            if not( IsUnitLoaded( udg_hero[cyclA] ) ) then
                call DestroyEffect( AddSpecialEffect("Void Teleport Caster.mdx", GetUnitX(udg_hero[cyclA]), GetUnitY(udg_hero[cyclA]) ) ) 
            endif
            call ShowUnitHide( udg_hero[cyclA] )
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

function Trig_BossKill_Actions takes nothing returns nothing
    local integer cyclA
    local integer cyclB
    local integer i
    local integer id
    local integer s
    local integer rand
    local integer dying = GetUnitTypeId( GetDyingUnit() )
    local boolean l = false
    local group g = CreateGroup()
    local unit u
    local integer v
    
    if not( udg_fightmod[4] ) then
        call GroupRemoveUnit(udg_Bosses, GetDyingUnit())
    endif
    
    if GetUnitTypeId(GetDyingUnit()) != 'h009' and GetUnitTypeId(GetDyingUnit()) != 'n01V' and GetUnitTypeId(GetDyingUnit()) != 'n01W' and GetUnitTypeId(GetDyingUnit()) != 'h01H' and GetUnitTypeId(GetDyingUnit()) != 'h005' and GetUnitTypeId(GetDyingUnit()) != 'h013' and GetUnitTypeId(GetDyingUnit()) != 'n01U' and GetUnitTypeId(GetDyingUnit()) != 'h00C' then
        set udg_number[1] = udg_number[1] + 1
    endif

    if not(udg_fightmod[4]) and IsUnitGroupEmptyBJ(udg_Bosses) and not( udg_logic[1] ) and GetUnitTypeId(GetDyingUnit()) != 'n01T' and GetUnitTypeId(GetDyingUnit()) != 'n01U' and GetUnitTypeId(GetDyingUnit()) != 'n01V' then
        if udg_Boss_LvL == 10 then
            call IconFrameDel( "boss" )
            if udg_logic[78] and udg_Boss_LvL > 1 then
                call IconFrameDel( "second boss" )
            endif
            call TriggerExecute( gg_trg_Victory )
            call FightEnd()
            call UnitAddAbility( gg_unit_h00A_0034, 'A0JQ' )
        else
            call TimerStart( CreateTimer(), 1, false, function HeroesTP )
            call Between( "end_boss" )
        endif
    elseif GetUnitTypeId(GetDyingUnit()) == 'n00A' then
        call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 30, "|cffffcc00PROMPT|r" )
        call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 30, "To finish the battle, defeat all the bosses." )
    endif
    
    set cyclA = 1
    loop
        exitwhen cyclA > 4
        if inv(udg_hero[cyclA], 'I098') > 0 and GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and GetUnitTypeId( GetDyingUnit() ) != 'n01U' and GetUnitTypeId( GetDyingUnit() ) != 'n01U' and GetUnitTypeId( GetDyingUnit() ) != 'n01U' then
            set id = GetHandleId( udg_hero[cyclA] )
            set s = LoadInteger( udg_hash, id, StringHash( udg_QuestItemCode[3] ) ) + 1
            call SaveInteger( udg_hash, id, StringHash( udg_QuestItemCode[3] ), s )
            if s >= udg_QuestNum[3] then
                call SetWidgetLife( GetItemOfTypeFromUnitBJ(udg_hero[cyclA], 'I098'), 0 )
                set bj_lastCreatedItem = CreateItem( 'I03G', GetUnitX(udg_hero[cyclA]), GetUnitY(udg_hero[cyclA]))
                call UnitAddItem(udg_hero[cyclA], bj_lastCreatedItem)
                call textst( "|c00ffffff Fulfillment of will done!", udg_hero[cyclA], 64, GetRandomReal( 45, 135 ), 12, 1.5 )
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", udg_hero[cyclA], "origin" ) )
                set udg_QuestDone[cyclA] = true
            else
                call QuestDiscription( udg_hero[cyclA], 'I098', s, udg_QuestNum[3] )
            endif
        endif
        set cyclA = cyclA + 1
    endloop

    if dying == 'o011' then
        set cyclA = 0
         loop
            exitwhen cyclA > 3
            set cyclB = 0
            loop
                exitwhen cyclB > 3
                if cyclA != cyclB then
                    call SetPlayerAllianceStateBJ( Player(cyclA), Player(cyclB), bj_ALLIANCE_ALLIED_VISION )
                endif
                set cyclB = cyclB + 1
            endloop
            set cyclA = cyclA + 1
        endloop
    endif
    
    if dying == 'n02W' then
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if GetPlayerSlotState( Player( cyclA - 1 ) ) == PLAYER_SLOT_STATE_PLAYING then
                call DelBuff( udg_hero[cyclA], false )
            endif
            set cyclA = cyclA + 1
        endloop
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if GetPlayerSlotState( Player( cyclA - 1 ) ) == PLAYER_SLOT_STATE_PLAYING then
                if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
                    call PanCameraToTimedLocForPlayer( Player( cyclA - 1 ), GetUnitLoc( udg_hero[cyclA] ), 0 )
                endif
                call SetUnitOwner( udg_hero[cyclA], Player(cyclA - 1), true )
            endif
            set cyclA = cyclA + 1
        endloop
    endif
    
    set cyclA = 1
    loop
        exitwhen cyclA > 6
        if DB_Boss_id[udg_Boss_LvL - 1][cyclA] == dying then
            set cyclB = 1
            loop
                exitwhen l
                set i = cyclB + ( ( cyclA - 1 ) * 10 )
                if DB_Trigger_Boss[udg_Boss_LvL][i] != null and cyclB <= 10 then
                    call DisableTrigger( DB_Trigger_Boss[udg_Boss_LvL][i] )
                    set cyclB = cyclB + 1
                else
                    set l = true
                endif
            endloop
        endif
        set cyclA = cyclA + 1
    endloop

    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
endfunction

//===========================================================================
function InitTrig_BossKill takes nothing returns nothing
    set gg_trg_BossKill = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BossKill, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_BossKill, Condition( function Trig_BossKill_Conditions ) )
    call TriggerAddAction( gg_trg_BossKill, function Trig_BossKill_Actions )
endfunction

