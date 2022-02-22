scope ManaReg initializer init

    globals
        private timer ManaRegTimer = null
        private real manaPast = 0
    endglobals

    private function ShowText takes nothing returns nothing
        local unit hero = udg_hero[1]
        local real manaNow
        local real manaDeviation
        local real manaReg
    
        if hero == null then
            set hero = null
            return
        endif
        //call BJDebugMsg("udg_hero[1] mana regen: " + R2S(BlzGetUnitRealField(hero, UNIT_RF_MANA_REGENERATION)) )
        set manaNow = GetUnitState(hero, UNIT_STATE_MANA)
        set manaDeviation = manaNow - manaPast
        set manaReg = manaDeviation / 60
        if manaReg >= 0 then
            call BJDebugMsg("udg_hero[1] mana regen: " + R2S(manaReg) )
        else
            call BJDebugMsg("Unknown. Mana is consumed.")
        endif
        set manaPast = GetUnitState(hero, UNIT_STATE_MANA)
        
        set hero = null
    endfunction

    private function Trig_ManaReg_Actions takes nothing returns nothing
        local unit hero = udg_hero[1]
        
        if hero == null then
            call BJDebugMsg("udg_hero[1] is null.")
            return
        endif
        
        if ManaRegTimer == null then
            set ManaRegTimer = CreateTimer()
            set manaPast = GetUnitState(hero, UNIT_STATE_MANA)
            call TimerStart(ManaRegTimer, 1, true, function ShowText)
            call BJDebugMsg("Mana regen enabled.")
        else
            call DestroyTimer(ManaRegTimer)
            set ManaRegTimer = null
            call BJDebugMsg("Mana regen disabled.")
        endif
        
        set hero = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_ManaReg = CreateTrigger()
        call DisableTrigger( gg_trg_ManaReg )
        call TriggerRegisterPlayerChatEvent( gg_trg_ManaReg, Player(0), "-manareg", false )
        call TriggerAddAction( gg_trg_ManaReg, function Trig_ManaReg_Actions )
    endfunction

endscope