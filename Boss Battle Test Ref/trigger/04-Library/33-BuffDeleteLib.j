library BuffDeleteLib requires SpellPower, ShamanBallLib, MajyteLib, Luck, Multiboard, UniquesLib, StatLib, PauseLib, JesterLib

    globals
        real Event_DeleteBuff_Real
        unit Event_DeleteBuff_Unit
    endglobals

    //Obsolete. Do not use
    function CreateTrigger_DeleteBuff takes code func returns nothing
        local trigger trig = CreateTrigger(  )

        call TriggerRegisterVariableEvent( trig, "Event_DeleteBuff_Real", EQUAL, 1.00 )
        call TriggerAddAction( trig, func )
        
        set trig = null
    endfunction

    function DelBuff takes unit u, boolean l returns nothing
        local real hp
        local real mp
        local integer array k
        local integer g
        local integer i = GetPlayerId(GetOwningPlayer(u))

        if l then
            call UnitRemoveAbility( u, 'A0EX' )
            if GetUnitAbilityLevel(u, 'A16J') > 0 then
                call UnitRemoveAbility( u, 'A16J' )
                call SaveUnitHandle( udg_hash, GetHandleId( u ), StringHash( "mdnqtt" ), u )
            endif
            if GetUnitAbilityLevel(u, 'A17U') > 0 then
                call UnitRemoveAbility( u, 'A17U' )
            endif
            if GetUnitAbilityLevel(u, 'A04U') > 0 then
                call BallEnergy( u, -3 )
            endif
        endif
        call IssueImmediateOrderBJ( u, "unimmolation" )
        
        set Event_DeleteBuff_Unit = u
        
        set Event_DeleteBuff_Real = 0
        set Event_DeleteBuff_Real = 1
        set Event_DeleteBuff_Real = 0
        
        if GetUnitAbilityLevel( u, 'BNsi') > 0 then
            call UnitRemoveAbility( u, 'BNsi' )
        endif
        if GetUnitAbilityLevel( u, 'B060') > 0 then
            call UnitRemoveAbility( u, 'B060')
        endif
        if GetUnitAbilityLevel(u, 'B02L') > 0 then
            call UnitRemoveAbility( u, 'A147' )
            call UnitRemoveAbility( u, 'B02L' )
        endif
        if GetUnitAbilityLevel(u, 'B09J') > 0 then
            call UnitRemoveAbility( u, 'A05W' )
            call UnitRemoveAbility( u, 'B09J' )
        endif
        if GetUnitAbilityLevel(u, 'B01T') > 0 then
            call UnitRemoveAbility( u, 'A0LB' )
            call UnitRemoveAbility( u, 'B01T' )
        endif
        if GetUnitAbilityLevel(u, 'B04O') > 0 then
            call UnitRemoveAbility( u, 'A067' )
            call UnitRemoveAbility( u, 'B04O' )
        endif
        if GetUnitAbilityLevel(u, 'B00Z') > 0 then
            call UnitRemoveAbility( u, 'A038' )
            call UnitRemoveAbility( u, 'B00Z' )
        endif
        if GetUnitAbilityLevel(u, 'B05Y') > 0 then
            call UnitRemoveAbility( u, 'A10I' )
            call UnitRemoveAbility( u, 'B05Y' )
        endif
        if GetUnitAbilityLevel(u, 'B012') > 0 then
            call UnitRemoveAbility( u, 'A04P' )
            call UnitRemoveAbility( u, 'B012' )
        endif
        if GetUnitAbilityLevel(u, 'B010') > 0 then
            call UnitRemoveAbility( u, 'A04I' )
            call UnitRemoveAbility( u, 'B010' )
        endif
        
        if GetUnitAbilityLevel(u, 'B02B') > 0 then
            call UnitRemoveAbility( u, 'A196' )
            call UnitRemoveAbility( u, 'A197' )
            call UnitRemoveAbility( u, 'B02B' )
        endif
        if GetUnitAbilityLevel(u, 'B09I') > 0 then
            call UnitRemoveAbility( u, 'A18L' )
            call UnitRemoveAbility( u, 'A18M' )
            call UnitRemoveAbility( u, 'A17P' )
            call UnitRemoveAbility( u, 'A17N' )
            call UnitRemoveAbility( u, 'B09I' )
        endif
        if GetUnitAbilityLevel(u, 'B09E') > 0 then
            call UnitRemoveAbility( u, 'A12C' )
            call UnitRemoveAbility( u, 'B09E' )
        endif
        if GetUnitAbilityLevel(u, 'B099') > 0 then
            call UnitRemoveAbility( u, 'A0ZC' )
            call UnitRemoveAbility( u, 'B099' )
        endif
        if GetUnitAbilityLevel( u, 'B08R' ) > 0 then
            call pausest( u, -1 )
            call UnitRemoveAbility( u, 'A02F' )
            call UnitRemoveAbility( u, 'A02G' )
            call UnitRemoveAbility( u, 'B08R' )
        endif
        if GetUnitAbilityLevel( u, 'A0JB' ) > 0 then
            call UnitRemoveAbility( u, 'A0JB' )
        endif
        if GetUnitAbilityLevel( u, 'B094' ) > 0 then
            call jesterst(u, -100, 1 )
        endif
        if GetUnitAbilityLevel(u, 'B08O') > 0 then
            call UnitRemoveAbility( u, 'A17Q' )
            call UnitRemoveAbility( u, 'B08O' )
            call UnitRemoveAbility( u, 'A181' )
            call UnitRemoveAbility( u, 'A180' )
        endif
        if GetUnitAbilityLevel(u, 'B08M') > 0 then
            call UnitRemoveAbility( u, 'A148' )
            call UnitRemoveAbility( u, 'B08M' )
        endif
        if GetUnitAbilityLevel(u, 'B08Q') > 0 then
            call UnitRemoveAbility( u, 'A18K' )
            call UnitRemoveAbility( u, 'B08Q' )
        endif
        if GetUnitAbilityLevel(u, 'B02H') > 0 then
            call UnitRemoveAbility( u, 'A0GE' )
            call UnitRemoveAbility( u, 'A0SU' )
            call UnitRemoveAbility( u, 'B02H' )
        endif
        if GetUnitAbilityLevel(u, 'B08K') > 0 then
            call UnitRemoveAbility( u, 'A146' )
            call UnitRemoveAbility( u, 'B08K' )
        endif
        if GetUnitAbilityLevel(u, 'B08J') > 0 then
            call UnitRemoveAbility( u, 'A145' )
            call UnitRemoveAbility( u, 'B08J' )
        endif
        if GetUnitAbilityLevel(u, 'B08D') > 0 then
            call UnitRemoveAbility( u, 'A08T' )
            call UnitRemoveAbility( u, 'B08D' )
        endif
        if GetUnitAbilityLevel(u, 'B08C') > 0 then
            call UnitRemoveAbility( u, 'A12Z' )
            call UnitRemoveAbility( u, 'A0FZ' )
            call UnitRemoveAbility( u, 'A0PB' )
            call UnitRemoveAbility( u, 'B08C' )
        endif
        if GetUnitAbilityLevel( u, 'B05T') > 0 then
            call UnitRemoveAbility( u, 'A12N' )
            call UnitRemoveAbility( u, 'B05T' )
        endif
        if GetUnitAbilityLevel( u, 'B05W') > 0 then
            call UnitRemoveAbility( u, 'A12V' )
            call UnitRemoveAbility( u, 'B05W' )
        endif
        if GetUnitAbilityLevel( u, 'B089') > 0 then
            call UnitRemoveAbility( u, 'A0ZR' )
            call UnitRemoveAbility( u, 'B089' )
        endif
        if GetUnitAbilityLevel( u, 'B08B') > 0 then
            call UnitRemoveAbility( u, 'A12X' )
            call UnitRemoveAbility( u, 'B08B' )
        endif
        if GetUnitAbilityLevel( u, 'B088') > 0 then
            call UnitRemoveAbility( u, 'A0YE' )
            call UnitRemoveAbility( u, 'B088' )
        endif
        if GetUnitAbilityLevel( u, 'B05W') > 0 then
            call PauseUnit( u, false )
            call UnitRemoveAbility( u, 'A0TT' )
            call UnitRemoveAbility( u, 'B016' )
        endif
        if GetUnitAbilityLevel( u, 'B05U') > 0 then
            call UnitRemoveAbility( u, 'A12P' )
            call UnitRemoveAbility( u, 'B05U' )
        endif
        if GetUnitAbilityLevel( u, 'B05V') > 0 then
            call UnitRemoveAbility( u, 'A12R' )
            call UnitRemoveAbility( u, 'B05V' )
        endif   
        if GetUnitAbilityLevel( u, 'B05R') > 0 then
            call UnitRemoveAbility( u, 'A128' )
            call UnitRemoveAbility( u, 'B05R' )
        endif
        if GetUnitAbilityLevel( u, 'B04E') > 0 then
            call UnitRemoveAbility( u, 'A0RL' )
            call UnitRemoveAbility( u, 'B04E' )
            call SaveUnitHandle( udg_hash, GetHandleId( u ), StringHash( "twhhtt" ), u )
        endif
        if GetUnitAbilityLevel( u, 'B01Z') > 0 then
            call UnitRemoveAbility( u, 'A0BO' )
            call UnitRemoveAbility( u, 'A0VE' )
            call UnitRemoveAbility( u, 'B01Z' )
        endif
        if GetUnitAbilityLevel( u, 'A10C') > 0 then
            call UnitRemoveAbility( u, 'A10C' )
        endif
        if GetUnitAbilityLevel( u, 'B01V') > 0 then
            call UnitRemoveAbility( u, 'A0Y2' )
            call UnitRemoveAbility( u, 'B01V' )
        endif
        if GetUnitAbilityLevel( u, 'B05M') > 0 then
            call UnitRemoveAbility( u, 'A0ZU' )
            call UnitRemoveAbility( u, 'B05M' )
        endif
        if GetUnitAbilityLevel(u, 'B06P') > 0 then
            call UnitRemoveAbility( u, 'A0U8' )
            call UnitRemoveAbility( u, 'B06P' )
        endif
        if GetUnitAbilityLevel(u, 'B033') > 0 then
            call UnitRemoveAbility( u, 'A0N9' )
            call UnitRemoveAbility( u, 'B033' )  
        endif
        if GetUnitAbilityLevel(u, 'B023') > 0 then
            call UnitRemoveAbility( u, 'A0D5' )
            call UnitRemoveAbility( u, 'B023' ) 
        endif
        if GetUnitAbilityLevel(u, 'B06N') > 0 then
            call UnitRemoveAbility( u, 'A0S2' )
            call UnitRemoveAbility( u, 'B06N' ) 
        endif
        if GetUnitAbilityLevel(u, 'B030') > 0 or GetUnitAbilityLevel(u, 'B02Z') > 0 then
            call UnitRemoveAbility( u, 'B02Z' )
            call UnitRemoveAbility( u, 'A0L4' ) 
            call UnitRemoveAbility( u, 'A0L8' )
            call UnitRemoveAbility( u, 'B030' )     
        endif
        if GetUnitAbilityLevel(u, 'B01J') > 0 then
            call UnitRemoveAbility( u, 'A0O7' )
            call UnitRemoveAbility( u, 'A0O6' )
            call UnitRemoveAbility( u, 'A08H' )
            call UnitRemoveAbility( u, 'A04S' )
            call UnitRemoveAbility( u, 'B01J' )
            call UnitRemoveAbility( u, 'B037' )  
        endif
        if GetUnitAbilityLevel(u, 'B004') > 0 then
            call UnitRemoveAbility( u, 'A0M2' )
            call UnitRemoveAbility( u, 'A0N2' )
            call UnitRemoveAbility( u, 'B004' )
        endif
        if GetUnitAbilityLevel(u, 'B01Q') > 0 then
            call UnitRemoveAbility( u, 'A0A0' )
            call UnitRemoveAbility( u, 'A09X' ) 
            call UnitRemoveAbility( u, 'A0RX' ) 
            call UnitRemoveAbility( u, 'B01Q' )
            call SaveInteger( udg_hash, GetHandleId( u ), StringHash( "hrnrs" ), 0 )
        endif
        if GetUnitAbilityLevel(u, 'B02S') > 0 then
            call UnitRemoveAbility( u, 'A07C' )
            call UnitRemoveAbility( u, 'B02S' ) 
        endif
        if GetUnitAbilityLevel(u, 'B03C') > 0 then
            call UnitRemoveAbility( u, 'A0QP' )
            call UnitRemoveAbility( u, 'B03C' )
        endif
        if GetUnitAbilityLevel(u, 'B03H') > 0 then
            call UnitRemoveAbility( u, 'A0QU' )
            call UnitRemoveAbility( u, 'B03H' )       
        endif
        if GetUnitAbilityLevel(u, 'BOhx') > 0 then
            call UnitRemoveAbility( u, 'BOhx' ) 
        endif
        if GetUnitAbilityLevel(u, 'B00S') > 0 then
            call UnitRemoveAbility( u, 'A0ML' )
            call UnitRemoveAbility( u, 'A0MI' ) 
            call UnitRemoveAbility( u, 'A06R' )
            call UnitRemoveAbility( u, 'B00S' )  
        endif
        if GetUnitAbilityLevel(u, 'B01F') > 0 then
            call UnitRemoveAbility( u, 'A0JS' ) 
            call UnitRemoveAbility( u, 'B01F' )     
        endif
        if GetUnitAbilityLevel(u, 'B024') > 0 then
            call UnitRemoveAbility( u, 'A0TD' )
            call UnitRemoveAbility( u, 'B024' )
        endif
        if GetUnitAbilityLevel(u, 'B06D') > 0 then
            call UnitRemoveAbility( u, 'A0H0' )
            call UnitRemoveAbility( u, 'B06D' )
        endif
        if GetUnitAbilityLevel(u, 'B03L') > 0 then
            call UnitRemoveAbility( u, 'A0U2' )
            call UnitRemoveAbility( u, 'A0A6' )
            call UnitRemoveAbility( u, 'B03L' )
        endif
        if GetUnitAbilityLevel(u, 'B03T') > 0 then
            call UnitRemoveAbility( u, 'A0XU' )
            call UnitRemoveAbility( u, 'B03T' )
        endif
        if GetUnitAbilityLevel(u, 'B06E') > 0 then
            call UnitRemoveAbility( u, 'A0GZ' )
            call UnitRemoveAbility( u, 'B06E' )
        endif
        if GetUnitAbilityLevel(u, 'B03U') > 0 then
            call UnitRemoveAbility( u, 'A0Y0' )
            call UnitRemoveAbility( u, 'B03U' )
        endif
        if GetUnitAbilityLevel(u, 'B03K') > 0 then
            call UnitRemoveAbility( u, 'A05G' )
            call UnitRemoveAbility( u, 'B03K' )
        endif
        if GetUnitAbilityLevel(u, 'B03Z') > 0 then
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "majt" ) ), 0, false, function MajyteCast ) 
        endif
        if GetUnitAbilityLevel(u, 'B02C') > 0 then
            call UnitRemoveAbility( u, 'A0SF' )
            call UnitRemoveAbility( u, 'B02C' )
        endif
        if GetUnitAbilityLevel(u, 'B07H') > 0 then
            call UnitRemoveAbility( u, 'A179' )
            call UnitRemoveAbility( u, 'B07H' )
        endif
        if GetUnitAbilityLevel(u, 'B01D') > 0 then
            call UnitRemoveAbility( u, 'A09Q' )
            call UnitRemoveAbility( u, 'B006' ) 
        endif
        if GetUnitAbilityLevel(u, 'B01O') > 0 then
            call UnitRemoveAbility( u, 'A0KE' )
            call UnitRemoveAbility( u, 'B01O' )
        endif
        if GetUnitAbilityLevel(u, 'B036') > 0 then
            call UnitRemoveAbility( u, 'A0HZ' )
            call UnitRemoveAbility( u, 'B036' )    
        endif
        if GetUnitAbilityLevel(u, 'B05B') > 0 then
            call UnitRemoveAbility( u, 'A092' )
            call UnitRemoveAbility( u, 'B05B' )    
        endif
        if GetUnitAbilityLevel(u, 'B04H') > 0 then
            call UnitRemoveAbility( u, 'A06V' )
            call UnitRemoveAbility( u, 'B04H' )    
        endif
        if GetUnitAbilityLevel(u, 'B07G') > 0 then
            call UnitRemoveAbility( u, 'A172' )
            call UnitRemoveAbility( u, 'B07G' )    
        endif
        if GetUnitAbilityLevel(u, 'B048') > 0 or GetUnitAbilityLevel(u, 'B049') > 0 then
            call UnitRemoveAbility( u, 'A0ZZ' )
            call UnitRemoveAbility( u, 'A0ZY' )  
            call UnitRemoveAbility( u, 'A09O' )
            call UnitRemoveAbility( u, 'B048' )  
            call UnitRemoveAbility( u, 'B049' )
        endif
        if GetUnitAbilityLevel(u, 'B00P') > 0 then
            call UnitRemoveAbility( u, 'A0LJ' )
            call UnitRemoveAbility( u, 'A0BE' )  
            call UnitRemoveAbility( u, 'B00P' )      
        endif
        if GetUnitAbilityLevel(u, 'B02Y') > 0 then
            call UnitRemoveAbility( u, 'A090' )
            call UnitRemoveAbility( u, 'B02Y' ) 
        endif
        if GetUnitAbilityLevel(u, 'B003') > 0 then
            call UnitRemoveAbility( u, 'A0EE' )
            call UnitRemoveAbility( u, 'B003' ) 
        endif
        if GetUnitAbilityLevel(u, 'B02P') > 0 then
            call UnitRemoveAbility( u, 'A0PX' )
            call UnitRemoveAbility( u, 'B02P' )
            call SaveInteger( udg_hash, GetHandleId( u ), StringHash( "hrnqs" ), 0 )
        endif
        if GetUnitAbilityLevel(u, 'B01S') > 0 then
            call UnitRemoveAbility( u, 'A0T4' )
            call UnitRemoveAbility( u, 'B01S' )     
        endif
        if GetUnitAbilityLevel(u, 'B04K' ) > 0 then
            call UnitRemoveAbility( u, 'A08T' )
            call UnitRemoveAbility( u, 'B04K' )  
        endif
        if GetUnitAbilityLevel(u, 'B04T' ) > 0 then
            call UnitRemoveAbility( u, 'B04T' )  
        endif
        if GetUnitAbilityLevel(u, 'B011' ) > 0 then
            call UnitRemoveAbility( u, 'A06V' )
            call UnitRemoveAbility( u, 'B011' )  
        endif
        if GetUnitAbilityLevel(u, 'B06R' ) > 0 then
            call UnitRemoveAbility( u, 'A11H' )
            call UnitRemoveAbility( u, 'B06R' )  
        endif
        if GetUnitAbilityLevel(u, 'B06X' ) > 0 then
            call UnitRemoveAbility( u, 'A152' )
            call UnitRemoveAbility( u, 'B06X' )  
        endif
        if GetUnitAbilityLevel(u, 'B04L') > 0 then
            call UnitRemoveAbility( u, 'A0C3' )
            call UnitRemoveAbility( u, 'A0B1' )
            call UnitRemoveAbility( u, 'B04L' )     
        endif
        if GetUnitAbilityLevel(u, 'B022') > 0 then
            call UnitRemoveAbility( u, 'A0RK' )
            call UnitRemoveAbility( u, 'B022' )
        endif
        if GetUnitAbilityLevel(u, 'B07B') > 0 then
            call UnitRemoveAbility( u, 'A16M' )
            call UnitRemoveAbility( u, 'B07B' )
        endif
        if GetUnitAbilityLevel(u, 'B072') > 0 then
            call UnitRemoveAbility( u, 'A15P' )
            call UnitRemoveAbility( u, 'B072' )
        endif
        if GetUnitAbilityLevel(u, 'B06Q') > 0 then
        call UnitRemoveAbility( u, 'A103' )
        call UnitRemoveAbility( u, 'B06Q' )
        endif
        if GetUnitAbilityLevel(u, 'B06W') > 0 then
        call UnitRemoveAbility( u, 'A14Z' )
        call UnitRemoveAbility( u, 'B06W' )
        endif
        if GetUnitAbilityLevel(u, 'B007') > 0 then
            call UnitRemoveAbility( u, 'A05A' )
            call UnitRemoveAbility( u, 'B007' ) 
        endif
        if GetUnitAbilityLevel(u, 'B06O') > 0 then
            call UnitRemoveAbility( u, 'A05C' )
            call UnitRemoveAbility( u, 'B06O' ) 
        endif
        if GetUnitAbilityLevel(u, 'B013') > 0 then
            call UnitRemoveAbility( u, 'A0SX' )
            call UnitRemoveAbility( u, 'B013' ) 
        endif
        if GetUnitAbilityLevel(u, 'B047') > 0 then
            call UnitRemoveAbility( u, 'A05X' )
            call UnitRemoveAbility( u, 'B047' ) 
        endif
        if GetUnitAbilityLevel(u, 'B014') > 0 then
            call UnitRemoveAbility( u, 'A0T3' )
            call UnitRemoveAbility( u, 'B014' ) 
        endif
        if GetUnitAbilityLevel(u, 'B06H') > 0 then
            call UnitRemoveAbility( u, 'A0KP' )
            call UnitRemoveAbility( u, 'B06H' ) 
        endif
        if GetUnitAbilityLevel(u, 'B00D') > 0 then
            call UnitRemoveAbility( u, 'A02O' )
            call UnitRemoveAbility( u, 'B00D' )  
        endif
        if GetUnitAbilityLevel(u, 'B00X') > 0 then
            call UnitRemoveAbility( u, 'A04B' )
            call UnitRemoveAbility( u, 'B00X' )  
        endif
        if GetUnitAbilityLevel(u, 'B032') > 0 and inv(u, 'I040') == 0  then
            call UnitRemoveAbility( u, 'A054' )
            call UnitRemoveAbility( u, 'B032' )
        endif
        if GetUnitAbilityLevel(u, 'Bply') > 0  then
            call UnitRemoveAbility( u, 'Bply' )
        endif
        if GetUnitAbilityLevel(u, 'B04R') > 0 then
            call UnitRemoveAbility( u, 'A0PJ' )
            call UnitRemoveAbility( u, 'B04R' )        
        endif
        if GetUnitAbilityLevel(u, 'B06Y') > 0 then
            call UnitRemoveAbility( u, 'A15A' )
            call UnitRemoveAbility( u, 'B06Y' )        
        endif
        if GetUnitAbilityLevel(u, 'B07C') > 0 then
            call UnitRemoveAbility( u, 'A16P' )
            call UnitRemoveAbility( u, 'B07C' )        
        endif
        if GetUnitAbilityLevel(u, 'B06M') > 0 then
            call UnitRemoveAbility( u, 'A0PN' )
            call UnitRemoveAbility( u, 'B06M' )        
        endif
        if GetUnitAbilityLevel(u, 'B00W') > 0 then
            call UnitRemoveAbility( u, 'A03G' )
            call UnitRemoveAbility( u, 'B00W' )        
        endif
        if GetUnitAbilityLevel(u, 'B07S') > 0 then
            call UnitRemoveAbility( u, 'A0EA' )
            call UnitRemoveAbility( u, 'B07S' )        
        endif
        if GetUnitAbilityLevel(u, 'A0QQ') > 0 then
            call UnitRemoveAbility( u, 'A0QQ' )
        endif
        if GetUnitAbilityLevel(u, 'B020') > 0 then
            call UnitRemoveAbility( u, 'B020')
        endif
        if GetUnitAbilityLevel(u, 'B054') > 0 then
            call UnitRemoveAbility( u, 'A0UP' )
            call UnitRemoveAbility( u, 'B054' )         
        endif
        if GetUnitAbilityLevel(u, 'B07K') > 0 then
            call UnitRemoveAbility( u, 'A17I' )
            call UnitRemoveAbility( u, 'B07K' )         
        endif
        if GetUnitAbilityLevel(u, 'B07J') > 0 then
            call UnitRemoveAbility( u, 'A17G' )
            call UnitRemoveAbility( u, 'B07J' )         
        endif
        if GetUnitAbilityLevel(u, 'B07V') > 0 then
            call UnitRemoveAbility( u, 'A0O4' )
            call UnitRemoveAbility( u, 'B07V' )         
        endif
            if GetUnitAbilityLevel(u, 'B07V') > 0 then
            call UnitRemoveAbility( u, 'A0P0' )
            call UnitRemoveAbility( u, 'B07W' )         
        endif
        if GetUnitAbilityLevel(u, 'B069') > 0 then
            call UnitRemoveAbility( u, 'A0EO' )
            call UnitRemoveAbility( u, 'B069' )         
        endif
        if GetUnitAbilityLevel(u, 'B07T') > 0 then
            call UnitRemoveAbility( u, 'A0IU' )
            call UnitRemoveAbility( u, 'B07T' )         
        endif
        if GetUnitAbilityLevel(u, 'B034') > 0 then
            call UnitRemoveAbility( u, 'A0NJ' )
            call UnitRemoveAbility( u, 'B034' )         
        endif
        if GetUnitAbilityLevel(u, 'B055') > 0 then
            call UnitRemoveAbility( u, 'A0UU' )
            call UnitRemoveAbility( u, 'B055' ) 
        endif
        if GetUnitAbilityLevel(u, 'B057') > 0  then
            call UnitRemoveAbility( u, 'A0V3' )
            call UnitRemoveAbility( u, 'B057' )       
        endif
        if GetUnitAbilityLevel(u, 'B058') > 0 then
            call UnitRemoveAbility( u, 'A0V7' )
            call UnitRemoveAbility( u, 'B058' )      
        endif
        if GetUnitAbilityLevel(u, 'B02E') > 0  then
            call UnitRemoveAbility( u, 'A0QM' )
            call UnitRemoveAbility( u, 'B02E' )      
        endif
        if GetUnitAbilityLevel(u, 'B07X') > 0  then
            call UnitRemoveAbility( u, 'A0S4' )
            call UnitRemoveAbility( u, 'B07X' )      
        endif
        if GetUnitAbilityLevel(u, 'B02F') > 0 then
            call UnitRemoveAbility( u, 'A0VO' )
            call UnitRemoveAbility( u, 'B02F' )      
        endif
        if GetUnitAbilityLevel(u, 'B02G') > 0 then
            call UnitRemoveAbility( u, 'A0VQ' )
            call UnitRemoveAbility( u, 'B02G' )      
        endif
        if GetUnitAbilityLevel(u, 'B067') > 0 then
            call UnitRemoveAbility( u, 'A0DP' )
            call UnitRemoveAbility( u, 'B067' )      
        endif
        if GetUnitAbilityLevel(u, 'B068') > 0 then
            call UnitRemoveAbility( u, 'A01E' )
            call UnitRemoveAbility( u, 'B068' )      
        endif
        if GetUnitAbilityLevel(u, 'B07P') > 0 then
            call UnitRemoveAbility( u, 'A0FU' )
            call UnitRemoveAbility( u, 'B07P' )      
        endif
        if GetUnitAbilityLevel(u, 'B04E') > 0 then
            call UnitRemoveAbility( u, 'A013' )
            call UnitRemoveAbility( u, 'B04E' )      
        endif
        if GetUnitAbilityLevel(u, 'B03F') > 0 then
            call UnitRemoveAbility( u, 'A0I5' )
            call UnitRemoveAbility( u, 'B03F' )      
        endif
        if GetUnitAbilityLevel(u, 'A0QG') > 0 then
            call UnitRemoveAbility( u, 'A0QG' )     
        endif
        if GetUnitAbilityLevel(u, 'A0MA') > 0 then
            call UnitRemoveAbility( u, 'A0MA' )  
            call UnitRemoveAbility( u, 'B01L' )
        endif
        if GetUnitAbilityLevel(u, 'A07M') > 0 then
            call UnitRemoveAbility( u, 'A0DZ' )  
            call UnitRemoveAbility( u, 'B07M' )
        endif
        if GetUnitAbilityLevel(u, 'B07I') > 0 then
            call UnitRemoveAbility( u, 'A17E' )  
            call UnitRemoveAbility( u, 'B07I' )
        endif
        if GetUnitAbilityLevel(u, 'A107') > 0 then 
            call UnitRemoveAbility( u, 'A107' )  
            call UnitRemoveAbility( u, 'B04A' )
            call pausest( u, -1 )
        endif
        if GetUnitAbilityLevel(u, 'B01D') > 0 then
            call UnitRemoveAbility( u, 'A0WN' )  
            call UnitRemoveAbility( u, 'B01D' )
        endif
        if GetUnitAbilityLevel(u, 'B01M') > 0 then
            call UnitRemoveAbility( u, 'A0WP' )  
            call UnitRemoveAbility( u, 'B01M' )
        endif
        if GetUnitAbilityLevel(u, 'B05E') > 0 then
            call UnitRemoveAbility( u, 'A0WX' )  
            call UnitRemoveAbility( u, 'B05E' )
        endif
        if GetUnitAbilityLevel(u, 'B05K') > 0 then
            call UnitRemoveAbility( u, 'A0XG' )  
            call UnitRemoveAbility( u, 'B05K' )
        endif
        if GetUnitAbilityLevel(u, 'B06F') > 0 then
            call UnitRemoveAbility( u, 'A0GX' )  
            call UnitRemoveAbility( u, 'B06F' )
        endif
        //zihi adds
        if GetUnitAbilityLevel(u, 'BZ02') > 0 then
            call UnitRemoveAbility( u, 'AZ02' )  
            call UnitRemoveAbility( u, 'BZ02' )
        endif
        //zihi stops
        if GetUnitAbilityLevel(u, 'B038') > 0 then
            call BlzSetUnitBaseDamage( u, BlzGetUnitBaseDamage(u, 0) - LoadInteger( udg_hash, GetHandleId( u ), StringHash( "rage" ) ), 0 )
            call UnitRemoveAbility( u, 'A19T' )
            call UnitRemoveAbility( u, 'B038' )
            call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( "rage" ) )
        endif 
        if GetUnitAbilityLevel(u, 'B00N') > 0 then
            call BlzSetUnitBaseDamage( u, BlzGetUnitBaseDamage(u, 0) - LoadInteger( udg_hash, GetHandleId( u ), StringHash( "prsw" ) ), 0 )
            call UnitRemoveAbility( u, 'A03W' )
            call UnitRemoveAbility( u, 'B00N' )
            call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( "prsw" ) )
        endif 
        if GetUnitAbilityLevel( u, 'B05P') > 0 then
            call SaveInteger( udg_hash, GetHandleId( u ), StringHash( "shieldnum" ), 0 )
            call SaveReal( udg_hash, GetHandleId( u ), StringHash( "shield" ), 0 )
            call SaveReal( udg_hash, GetHandleId( u ), StringHash( "shieldMax" ), 0 )
            call UnitRemoveAbility( u, 'A11F' )
            call UnitRemoveAbility( u, 'B05P' )
        endif
        if GetUnitAbilityLevel(u, 'B09D') > 0 then
            call spdst( u, -LoadReal( udg_hash, GetHandleId( u ), StringHash( "kepr1" ) ) )
            call UnitRemoveAbility( u, 'A0PV' )
            call UnitRemoveAbility( u, 'B09D' )
            call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( "kepr1" ) )
        endif
        if GetUnitAbilityLevel(u, 'B098') > 0 then
            call spdst( u, -LoadReal( udg_hash, GetHandleId( u ), StringHash( "orbntc1" ) ) )
            call UnitRemoveAbility( u, 'A0WU' )
            call UnitRemoveAbility( u, 'B098' )
            call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( "orbntc1" ) )
        endif
        if GetUnitAbilityLevel(u, 'B09K') > 0 then
            call spdst( u, -LoadReal( udg_hash, GetHandleId( u ), StringHash( "brde" ) ) )
            call UnitRemoveAbility( u, 'A1AU' )
            call UnitRemoveAbility( u, 'B09K' )
            call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( "brde" ) )
        endif
        if GetUnitAbilityLevel( u, 'B015') > 0 then
            call spdst( u, -LoadReal( udg_hash, GetHandleId( u ), StringHash( "mgct" ) ) )
            call UnitRemoveAbility( u, 'A0TG' )
            call UnitRemoveAbility( u, 'B015' )
            call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( "mgct" ) )
        endif
        if GetUnitAbilityLevel( u, 'B03Z') > 0 then
            call spdst( u, -LoadReal( udg_hash, GetHandleId( u ), StringHash( "majt" ) ) )
            call UnitRemoveAbility( u, 'A0YC' )
            call UnitRemoveAbility( u, 'B03Z' )
            call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( "majt" ) )
        endif
        if GetUnitAbilityLevel( u, 'B028') > 0 then
            call spdst( u, -LoadReal( udg_hash, GetHandleId( u ), StringHash( "sopp" ) ) )
            call UnitRemoveAbility( u, 'A0CJ' )
            call UnitRemoveAbility( u, 'B028' )
            call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( "sopp" ) )
        endif
        if GetUnitAbilityLevel( u, 'B093') > 0 then
            call spdst( u, -LoadReal( udg_hash, GetHandleId( u ), StringHash( "orbfp1" ) ) )
            call UnitRemoveAbility( u, 'A0I7' )
            call UnitRemoveAbility( u, 'B093' )
            call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( "orbfp1" ) )
        endif
        if GetUnitAbilityLevel(u, 'B07A') > 0 then
            call UnitRemoveAbility( u, 'A16I' )
            call UnitRemoveAbility( u, 'B07A' )
        endif
        if GetUnitAbilityLevel(u, 'B07O') > 0 then
            call UnitRemoveAbility( u, 'A0FP' )
            call UnitRemoveAbility( u, 'B07O' )
        endif
        if GetUnitAbilityLevel( u, 'B00Q') > 0 and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
            set hp = GetUnitState( u, UNIT_STATE_LIFE) / GetUnitState( u, UNIT_STATE_MAX_LIFE)
            set mp = GetUnitState( u, UNIT_STATE_LIFE) / GetUnitState( u, UNIT_STATE_MAX_LIFE)
            call statst( u, -LoadInteger( udg_hash, GetHandleId( u ), StringHash( "vamr" ) ), -LoadInteger( udg_hash, GetHandleId( u ), StringHash( "vamr" ) ), -LoadInteger( udg_hash, GetHandleId( u ), StringHash( "vamr" ) ), 0, false )
            call UnitRemoveAbility( u, 'A0K6' )
            call UnitRemoveAbility( u, 'B00Q' )
            call SetUnitState( u, UNIT_STATE_LIFE, hp * GetUnitState( u, UNIT_STATE_MAX_LIFE))
            call SetUnitState( u, UNIT_STATE_MANA, mp * GetUnitState( u, UNIT_STATE_MAX_MANA))
            call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( "vamr" ) )
        endif
        if GetUnitAbilityLevel( u, 'B05Q') > 0 and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
            set mp = GetUnitState( u, UNIT_STATE_MANA) / GetUnitState( u, UNIT_STATE_MAX_MANA)
            call statst( u, 0, -LoadInteger( udg_hash, GetHandleId( u ), StringHash( "outra" ) ), -LoadInteger( udg_hash, GetHandleId( u ), StringHash( "outri" ) ), 0, false )
            call UnitRemoveAbility( u, 'A081' )
            call UnitRemoveAbility( u, 'B05Q' )
            call SetUnitState( u, UNIT_STATE_MANA, mp * GetUnitState( u, UNIT_STATE_MAX_MANA))
            call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( "outra" ) )
            call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( "outri" ) )
        endif
        if GetUnitAbilityLevel( u, 'B051') > 0 then
            call luckyst( u, -LoadInteger( udg_hash, GetHandleId( u ), StringHash( "gldc" ) ) )
            call UnitRemoveAbility( u, 'A0TM' )
            call UnitRemoveAbility( u, 'B051' )
            call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( "gldc" ) )
        endif
        if GetUnitAbilityLevel( u, 'B03J') > 0 then
            call luckyst( u, -LoadInteger( udg_hash, GetHandleId( u ), StringHash( "cirr" ) ) )
            call UnitRemoveAbility( u, 'A0SL' )
            call UnitRemoveAbility( u, 'B03J' )
            call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( "cirr" ) )
        endif
        if GetUnitAbilityLevel( u, 'A0UX') > 0 and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
            set hp = GetUnitState( u, UNIT_STATE_LIFE) / GetUnitState( u, UNIT_STATE_MAX_LIFE)
            call statst( u, -LoadInteger( udg_hash, GetHandleId( u ), StringHash( "comrs" ) ), 0, 0, 0, false )
            call SetUnitState( u, UNIT_STATE_LIFE, hp * GetUnitState( u, UNIT_STATE_MAX_LIFE))
            call UnitRemoveAbility( u, 'A0UX' )
            call UnitRemoveAbility( u, 'B056' )
            call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( "comrs" ) )
        endif
        
        set u = null
    endfunction

endlibrary