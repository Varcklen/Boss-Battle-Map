library CastRandomAbility

    function CastRandomAbility takes unit caster, integer level, trigger usedTrigger returns nothing
        if caster == null or usedTrigger == null or level < 0 or level > 5 then
            call BJDebugMsg("Warning! Cannot use random ability!")
            call BJDebugMsg("caster: " + GetUnitName(caster) )
            call BJDebugMsg("level: " + I2S(level) )
            if usedTrigger == null then
                call BJDebugMsg("usedTrigger is null")
            endif
            return
        endif
    
        set udg_RandomLogic = true
        set udg_Caster = caster
        set udg_Level = level
        set RandomMode = true
        call TriggerExecute( usedTrigger )
        set RandomMode = false
        
        set caster = null
        set usedTrigger = null
    endfunction

endlibrary