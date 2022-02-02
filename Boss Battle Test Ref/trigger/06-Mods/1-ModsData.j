library ModsData initializer init

    private function SetMods takes nothing returns nothing
        //Bless
        set udg_base = 0
        set udg_DB_GoodMod[BaseNum()] = 'A0BB'
        set udg_DB_GoodMod[BaseNum()] = 'A03P'
        set udg_DB_GoodMod[BaseNum()] = 'A0QI'
        set udg_DB_GoodMod[BaseNum()] = 'A0E4'
        set udg_DB_GoodMod[BaseNum()] = 'A0BA'
        set udg_DB_GoodMod[BaseNum()] = 'A0DJ'
        set udg_DB_GoodMod[BaseNum()] = 'A0QL'
        set udg_DB_GoodMod[BaseNum()] = 'A0FH'
        set udg_DB_GoodMod[BaseNum()] = 'A0FY'
        set udg_DB_GoodMod[BaseNum()] = 'A00A'
        set udg_DB_GoodMod[BaseNum()] = 'A0QF'
        set udg_DB_GoodMod[BaseNum()] = 'A0Q8'
        set udg_DB_GoodMod[BaseNum()] = 'A0QE'
        set udg_DB_GoodMod[BaseNum()] = 'A0AK'
        set udg_DB_GoodMod[BaseNum()] = 'A0QC'
        set udg_DB_GoodMod[BaseNum()] = 'A0FI'
        set udg_DB_GoodMod[BaseNum()] = 'A11B'
        set udg_DB_GoodMod[BaseNum()] = 'A110'
        set udg_DB_GoodMod[BaseNum()] = 'A116'
        set udg_DB_GoodMod[BaseNum()] = 'A115'
        set udg_DB_GoodMod[BaseNum()] = 'A118'
        set udg_DB_GoodMod[BaseNum()] = 'A114'
        set udg_DB_GoodMod[BaseNum()] = 'A119'
        set udg_DB_GoodMod[BaseNum()] = 'A117'
        set udg_DB_GoodMod[BaseNum()] = 'A113'
        set udg_DB_GoodMod[BaseNum()] = 'A112'
        set udg_DB_GoodMod[BaseNum()] = 'A0MK'
        set udg_DB_GoodMod[BaseNum()] = 'A0NF'
        set udg_DB_GoodMod[BaseNum()] = 'A0P1'
        set udg_DB_GoodMod[BaseNum()] = 'A0SY'
        set udg_DB_GoodMod[BaseNum()] = 'A00S'
        set udg_DB_GoodMod[BaseNum()] = 'A18S'
        set udg_DB_GoodMod[BaseNum()] = 'A19M'
        set udg_DB_GoodMod[BaseNum()] = 'A0GU'
        set udg_DB_GoodMod[BaseNum()] = 'A0IG'
        set udg_DB_GoodMod[BaseNum()] = 'A14F'
        set udg_DB_GoodMod[BaseNum()] = 'A14I'//37
        set udg_DB_GoodMod[BaseNum()] = 'A1DJ'//38
        set udg_Database_NumberItems[7] = udg_base
        
        //Curse
        set udg_base = 0
        set udg_DB_BadMod[BaseNum()] = 'A0FX'
        set udg_DB_BadMod[BaseNum()] = 'A0FM'
        set udg_DB_BadMod[BaseNum()] = 'A0HA'
        set udg_DB_BadMod[BaseNum()] = 'A0QA'
        set udg_DB_BadMod[BaseNum()] = 'A0GG'
        set udg_DB_BadMod[BaseNum()] = 'A0H9'
        set udg_DB_BadMod[BaseNum()] = 'A0G9'
        set udg_DB_BadMod[BaseNum()] = 'A0FW'
        set udg_DB_BadMod[BaseNum()] = 'A10W'
        set udg_DB_BadMod[BaseNum()] = 'A10X'
        set udg_DB_BadMod[BaseNum()] = 'A10T'
        set udg_DB_BadMod[BaseNum()] = 'A10U'
        set udg_DB_BadMod[BaseNum()] = 'A10V'
        set udg_DB_BadMod[BaseNum()] = 'A10R'
        set udg_DB_BadMod[BaseNum()] = 'A10Q'
        set udg_DB_BadMod[BaseNum()] = 'A0LW'
        set udg_DB_BadMod[BaseNum()] = 'A0M4'
        set udg_DB_BadMod[BaseNum()] = 'A0MQ'
        set udg_DB_BadMod[BaseNum()] = 'A0MY'
        set udg_DB_BadMod[BaseNum()] = 'A0NL'
        set udg_DB_BadMod[BaseNum()] = 'A0P5'
        set udg_DB_BadMod[BaseNum()] = 'A0SZ'
        set udg_DB_BadMod[BaseNum()] = 'A0T0'
        set udg_DB_BadMod[BaseNum()] = 'A0YT'
        set udg_DB_BadMod[BaseNum()] = 'A00W'
        set udg_DB_BadMod[BaseNum()] = 'A0JR'
        set udg_DB_BadMod[BaseNum()] = 'A0KI'
        set udg_DB_BadMod[BaseNum()] = 'A14O'
        set udg_DB_BadMod[BaseNum()] = 'A14Q'
        set udg_DB_BadMod[BaseNum()] = 'A1CY'
        set udg_DB_BadMod[BaseNum()] = 'A1CZ'
        set udg_DB_BadMod[BaseNum()] = 'A1D1'//32
        set udg_Database_NumberItems[22] = udg_base
    endfunction

    public function init takes nothing returns nothing
        call TimerStart( CreateTimer(), 0.01, false, function SetMods )
    endfunction
endlibrary