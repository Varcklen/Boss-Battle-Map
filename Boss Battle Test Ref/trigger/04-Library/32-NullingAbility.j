library NullingAbility requires SpdLibLib, StatLib, ShamanBallLib

    function delspellpas takes unit caster returns nothing
        local integer i = GetPlayerId( GetOwningPlayer( caster ) ) + 1
        local integer lvl
        local integer cyclA

        call IssueImmediateOrderBJ( caster, "unimmolation" )
        
        call MMD_LogEvent1("used_tome_of_oblivion_" + I2S(i),GetUnitName(caster) )
        
        set udg_Event_NullingAbility_Unit = caster
        
        set udg_Event_NullingAbility_Real = 0.00
        set udg_Event_NullingAbility_Real = 1.00
        set udg_Event_NullingAbility_Real = 0.00

        if GetUnitTypeId( caster ) == udg_Database_Hero[6] then
            call DestroyTimer( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "angelpas" )))
            call RemoveSavedBoolean(udg_hash, GetHandleId( caster ), StringHash( "angelpas" ) )
            call RemoveSavedReal(udg_hash, GetHandleId( caster ), StringHash( "angelpas" ) )
            call RemoveSavedHandle(udg_hash, GetHandleId( caster ), StringHash( "angelpas" ) )
        endif
        if GetUnitTypeId( caster ) == udg_Database_Hero[59] then
            call DestroyTimer( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "wgne" )))
        endif
        if GetUnitTypeId( caster ) == udg_Database_Hero[19] then
            call DestroyTimer( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "hrne" )))
        endif
        if GetUnitTypeId( caster ) == udg_Database_Hero[60] then
            call UnitRemoveAbility( caster, 'A0BS')
        endif
        if GetUnitTypeId( caster ) == udg_Database_Hero[61] then
            if GetLocalPlayer() == GetOwningPlayer( caster ) then
                call BlzFrameSetVisible( mephuse, false )
            endif
        endif
        
        if GetUnitTypeId( caster ) == udg_Database_Hero[20] then
            call SpellPotion(i, -15* GetUnitAbilityLevel( caster, 'A0DC'))
        endif
        
        if GetUnitTypeId( caster ) == udg_Database_Hero[18] then
            call DestroyTimer( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "snp" )))
            call RemoveSavedHandle( udg_hash, GetHandleId( caster ), StringHash( "snp" ) )
            call UnitRemoveAbility( caster, 'A18P' )
            call UnitRemoveAbility( caster, 'A18Q' ) 
            call UnitRemoveAbility( caster, 'A18R' ) 
            call UnitRemoveAbility( caster, 'B031' ) 
        endif
        
        if GetUnitTypeId( caster ) == udg_Database_Hero[25] then
            call RemoveSavedHandle(udg_hash, GetHandleId( caster ), StringHash( "bkp" ) )
            call DestroyTimer( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "bkp" )))
            call UnitRemoveAbility( caster, 'A0ZY' )
            call UnitRemoveAbility( caster, 'A0ZZ' )
            call UnitRemoveAbility( caster, 'S005' )
            call UnitRemoveAbility( caster, 'A09O' )
            call UnitRemoveAbility( caster, 'B048' )
            call UnitRemoveAbility( caster, 'B049' ) 
        endif
        
        if GetUnitTypeId( caster ) == udg_Database_Hero[51] then
            call UnitRemoveAbility( caster, 'A17X' )
        endif
        
        if GetUnitTypeId( caster ) == udg_Database_Hero[5] then
            call RemoveSavedHandle( udg_hash, 1, StringHash( "sklp" ) )
        endif
        
        if GetUnitTypeId( caster ) == udg_Database_Hero[67] then
            if GetUnitAbilityLevel( caster, 'A0LD') >= 1 then
                call BlzSetUnitMaxHP( caster, BlzGetUnitMaxHP(caster) - 50 )
            endif
            call BlzSetUnitMaxHP( caster, BlzGetUnitMaxHP(caster) - (30*GetUnitAbilityLevel( caster, 'A0LD')) )
        endif

        if GetUnitTypeId( caster ) == udg_Database_Hero[14] then
        set lvl = GetUnitAbilityLevel( caster, 'A083')
            call statst( caster, (-4*lvl)-2, (-2*lvl)-1, (-2*lvl)-1, 0, false )
        endif
        
        if GetUnitTypeId( caster ) == udg_Database_Hero[26] then
            call DestroyTimer( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "sdap" ) ) )
            call RemoveSavedHandle( udg_hash, GetHandleId( caster ), StringHash( "sdap" ) )
        endif

        if GetUnitTypeId( caster ) == udg_Database_Hero[7] then
                call UnitRemoveAbility( caster, 'A008' )
                call DestroyTimer( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "brnp" )))
                call RemoveSavedInteger(udg_hash, GetHandleId( caster ), StringHash( "brnplvl" ) )
                call RemoveSavedHandle(udg_hash, GetHandleId( caster ), StringHash( "brnp" ) )
            endif

        if GetUnitTypeId( caster ) == udg_Database_Hero[35] then
            call BlzSetUnitMaxHP( caster, BlzGetUnitMaxHP(caster) - (75*GetUnitAbilityLevel( caster, 'A04L')) )
        endif

        if GetUnitTypeId( caster ) == udg_Database_Hero[39] then
            call spdst( caster, -1*LoadReal( udg_hash, GetHandleId( caster ), StringHash( "mtmqpn" ) ) )
            call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "mtmqpn" ), 0 )
            call DestroyTimer( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "mtmqp" ) ) )
        endif
        
        if GetUnitTypeId( caster ) == udg_Database_Hero[66] then
            call spdst( caster, -1*LoadReal( udg_hash, GetHandleId( caster ), StringHash( "prse" ) ) )
            call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "prse" ), 0 )
            call DestroyTimer( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "prse" ) ) )
        endif

        if GetUnitTypeId( caster ) == udg_Database_Hero[41] then
            call UnitRemoveAbility( caster, 'A0RW')
            call UnitRemoveAbility( caster, 'A0S6')
            call UnitRemoveAbility( caster, 'A0SD')
            call SetPlayerTechResearchedSwap( 'R004', 0, GetOwningPlayer(caster) )
        endif

        if GetUnitTypeId( caster ) == udg_Database_Hero[53] then
            if GetLocalPlayer() == GetOwningPlayer(caster) then
                call BlzFrameSetVisible( shamanframe, false )
            endif
            call BallEnergy( caster, -3 )
        endif
        
        if GetUnitTypeId( caster ) == udg_Database_Hero[54] then
            if GetLocalPlayer() == GetOwningPlayer(caster) then
                call BlzFrameSetVisible( outcastframe, false )
            endif
        endif
        
        if GetUnitTypeId( caster ) == udg_Database_Hero[58] then
            set cyclA = 1
            loop
                exitwhen cyclA > 5
                call BlzSetAbilityIcon( 'A122', BlzGetAbilityStringField(BlzGetUnitAbility(caster, 'A122'), ABILITY_SF_ICON_RESEARCH) )
                call BlzSetAbilityExtendedTooltip( 'A122', DestroyerTool[1][cyclA], cyclA-1 )
                call BlzSetAbilityIntegerLevelFieldBJ( BlzGetUnitAbility(caster, 'A122'), ABILITY_ILF_MANA_COST, cyclA-1, DestroyerMana[1][cyclA] )
                
                call BlzSetAbilityIcon( 'A129', BlzGetAbilityStringField(BlzGetUnitAbility(caster, 'A129'), ABILITY_SF_ICON_RESEARCH) )
                call BlzSetAbilityExtendedTooltip( 'A129', DestroyerTool[2][cyclA], cyclA-1 )
                call BlzSetAbilityIntegerLevelFieldBJ( BlzGetUnitAbility(caster, 'A129'), ABILITY_ILF_MANA_COST, cyclA-1, DestroyerMana[2][cyclA] )
                
                call BlzSetAbilityIcon( 'A12B', BlzGetAbilityStringField(BlzGetUnitAbility(caster, 'A12B'), ABILITY_SF_ICON_RESEARCH) )
                call BlzSetAbilityExtendedTooltip( 'A12B', DestroyerTool[3][cyclA], cyclA-1 )
                call BlzSetAbilityIntegerLevelFieldBJ( BlzGetUnitAbility(caster, 'A12B'), ABILITY_ILF_MANA_COST, cyclA-1, DestroyerMana[3][cyclA] )
                set cyclA = cyclA + 1
            endloop
        endif
        if GetUnitTypeId( caster ) == udg_Database_Hero[69] then
            call UnitRemoveAbility( caster, 'A1A6')
            call UnitRemoveAbility( caster, 'A1A7')
            call RemoveSavedReal( udg_hash, GetHandleId( caster ), StringHash( "infe" ) )
            call RemoveSavedReal( udg_hash, GetHandleId( caster ), StringHash( "infen" ) )
        endif
        
        set caster = null
    endfunction 
    
endlibrary