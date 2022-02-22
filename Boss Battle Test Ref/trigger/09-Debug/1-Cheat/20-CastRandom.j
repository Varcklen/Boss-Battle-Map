function TestRandomCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit hero = LoadUnitHandle( udg_hash, id, StringHash("test") )
    local integer key1 = LoadInteger( udg_hash, id, StringHash("test1") )
    local integer key2 = LoadInteger( udg_hash, id, StringHash("test2") )
    local trigger trig = null
    
    set key1 = key1 + 1
    if key1 > udg_Database_NumberItems[13+key2] then
        set key1 = 1
        set key2 = key2 + 1
        if key2 >= 4 then
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
            return
        endif
    endif

    if key2 == 1 then
        set trig = udg_DB_Trigger_One[key1]
    elseif key2 == 2 then
        set trig = udg_DB_Trigger_Two[key1]
    elseif key2 == 3 then
        set trig = udg_DB_Trigger_Three[key1]
    endif
    set udg_combatlogic[1] = true
    set udg_fightmod[0] = true
    call BJDebugMsg("===================================")
    call BJDebugMsg("Ability: key1: " + I2S(key1) + " key2: " + I2S(key2) )
    call CastRandomAbility(hero, 5, trig )
    call SaveInteger( udg_hash, id, StringHash("test1"), key1 )
    call SaveInteger( udg_hash, id, StringHash("test2"), key2 )
    
    set trig = null
    set hero = null
endfunction

function Trig_CastRandom_Actions takes nothing returns nothing
    local integer id
    if udg_hero[1] == null then
        return
    endif
    set id = InvokeTimerWithUnit(udg_hero[1], "test", 0.5, true, function TestRandomCast )
    call SaveInteger( udg_hash, id, StringHash("test2"), 1 )
    call BJDebugMsg("Start cast ALL abilities random.")
endfunction

//===========================================================================
function InitTrig_CastRandom takes nothing returns nothing
    set gg_trg_CastRandom = CreateTrigger(  )
    call DisableTrigger( gg_trg_CastRandom )
    call TriggerRegisterPlayerChatEvent( gg_trg_CastRandom, Player(0), "-castrandom", true )
    call TriggerAddAction( gg_trg_CastRandom, function Trig_CastRandom_Actions )
endfunction

