library EnvironmentLib

    globals
        integer Moon_Counter = 0
        
        real Event_MoonChange_Real
        boolean Event_MoonChange_isNight
        unit Event_MoonChange_Unit
    endglobals
    
    function IsNight takes nothing returns boolean
        return LoadBoolean( udg_hash, 1, StringHash( "moon" ) )
    endfunction

    function moonst takes integer i returns nothing
        local boolean b = LoadBoolean( udg_hash, 1, StringHash( "moon" ) )
        local boolean isChanged = false
        local integer k
        local boolean isNight = false

        set Moon_Counter = Moon_Counter + i

        if Moon_Counter >= 1 and not(b) then
            set isNight = true
            call SaveBoolean( udg_hash, 1, StringHash( "moon" ), isNight )
            call SetFloatGameState(GAME_STATE_TIME_OF_DAY, 0)
            set isChanged = true
        elseif Moon_Counter < 1 and b then
            set isNight = false
            call SaveBoolean( udg_hash, 1, StringHash( "moon" ), isNight )
            call SetFloatGameState(GAME_STATE_TIME_OF_DAY, 12)
            set isChanged = true
        endif
        
        if isChanged then
            set k = 1
            loop
                exitwhen k > 4
                if udg_hero[k] != null then
                    set Event_MoonChange_isNight = isNight
                    set Event_MoonChange_Unit = udg_hero[k]
                    
                    set Event_MoonChange_Real = 0.00
                    set Event_MoonChange_Real = 1.00
                    set Event_MoonChange_Real = 0.00
                endif
                set k = k + 1
            endloop
        endif
    endfunction

    function rainst takes integer i returns nothing
        local integer g = LoadInteger( udg_hash, 1, StringHash( "rain" ) ) + i
        local boolean b = LoadBoolean( udg_hash, 1, StringHash( "rain" ) )

        if g >= 1 and not(b) then
            call SaveBoolean( udg_hash, 1, StringHash( "rain" ), true )
            call EnableWeatherEffect( udg_rain, true )
        elseif g < 1 and b then
            call SaveBoolean( udg_hash, 1, StringHash( "rain" ), false )
            call EnableWeatherEffect( udg_rain, false )
        endif
    endfunction

endlibrary