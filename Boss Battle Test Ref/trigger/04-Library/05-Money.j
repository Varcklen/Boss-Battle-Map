library Money requires TextLib, QuestDiscLib

    globals
        real Event_OnMoneyChange_Real
        private integer Event_OnMoneyChange_StaticMoney
        real Event_OnMoneyChange_Money
        unit Event_OnMoneyChange_Caster
        
        real Event_AfterMoneyAdded_Real
        integer Event_AfterMoneyAdded_Money
        unit Event_AfterMoneyAdded_Caster
    endglobals
    
    function GetStaticMoney takes nothing returns integer
        return Event_OnMoneyChange_StaticMoney
    endfunction

    function moneyst takes unit caster, integer money returns nothing
        local integer n = GetPlayerId( GetOwningPlayer( caster ) ) + 1
        local integer i
        local integer sum = money
        local integer cyclA = 1
        local integer cyclAEnd
        local integer id
        
        set Event_OnMoneyChange_StaticMoney = money
        set Event_OnMoneyChange_Money = money
        set Event_OnMoneyChange_Caster = caster
    
        set Event_OnMoneyChange_Real = 0.00
        set Event_OnMoneyChange_Real = 1.00
        set Event_OnMoneyChange_Real = 0.00
        
        set sum = R2I(Event_OnMoneyChange_Money)
        
        if inv( caster, 'I02A' ) > 0 then
            set sum = sum + R2I( money * 0.2 ) 
        endif
        if GetUnitAbilityLevel( caster, 'A0GA' ) > 0 then
            set sum = sum + R2I( money * 0.25 ) 
        endif
        if inv( caster, 'I09W' ) > 0 and not( udg_logic[n + 26] ) then
            set sum = sum - R2I( money * 0.2 ) 
        endif
        if GetUnitAbilityLevel( caster, 'A00K' ) > 0 then
            set sum = sum + R2I( money * 0.5 )
        endif
        if inv( caster, 'I05L' ) > 0 then
            set sum = sum + R2I( money * 0.35 )
        endif
        if GetUnitAbilityLevel( caster, 'A17W' ) > 0 then
            set sum = sum + R2I( money * ( (0.04*GetUnitAbilityLevel( caster, 'A17W' ) ) + (0.02 * BlzGetUnitArmor(caster) ) ) )
        endif
        if udg_modgood[7] then
            set sum = sum + R2I( money * 0.15 )
        endif
        if udg_logic[4] then
            set sum = sum + R2I( money * 0.25 )
        endif
        if udg_logic[78] and not( udg_logic[2] ) and not( udg_fightmod[2] ) and not( udg_fightmod[4] ) then
            set sum = sum + R2I( money * 0.5 )
        endif
        if udg_logic[101] then
            set sum = sum - R2I( money * 0.2 )
        endif
        if inv( caster, 'I051') > 0 then
            set sum = sum - R2I( money * 0.9 )
        endif
        if GetUnitAbilityLevel( caster, 'B04Z' ) > 0 or udg_logic[3] then
            set sum = sum + R2I( money * ((0.05 * GetUnitAbilityLevel( udg_UnitHero[27], 'A0RY' ))+ 0.05 ) )
            if udg_logic[3] then
                set udg_logic[3] = false
            endif
        endif
        
        if inv( caster, 'I05L' ) > 0 and not(udg_logic[n + 26]) then
            set id = GetHandleId( caster )
            set i = LoadInteger( udg_hash, id, StringHash( "pik" ) ) + 1

            if i >= 5 then
            set sum = 0
                call SaveInteger( udg_hash, id, StringHash( "pik" ), 0 )
            else
                call SaveInteger( udg_hash, id, StringHash( "pik" ), i )
            endif
        endif
        
        if inv( caster, 'I051') > 0 and sum < money * 0.1 then
            set sum = R2I(money * 0.1)
        elseif sum < 0 then
            set sum = 0
        endif
        
        call SetPlayerState( GetOwningPlayer( caster ), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState( GetOwningPlayer( caster ), PLAYER_STATE_RESOURCE_GOLD ) + sum )
        
        set udg_GoldAllTime[n] = udg_GoldAllTime[n] + sum
        
        if inv(caster, 'I080' ) > 0 and GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
            if udg_GoldAllTime[n] >= udg_QuestNum[15] then
                call RemoveItem(GetItemOfTypeFromUnitBJ(caster, 'I080'))
                call UnitAddItem(caster, CreateItem( 'I08S', GetUnitX(caster), GetUnitY(caster)))
                call textst( "|c00ffffff Greed is gold done!", caster, 64, GetRandomReal( 45, 135 ), 12, 1.5 )
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", GetUnitX(caster), GetUnitY(caster) ) )
                set udg_QuestDone[n] = true
            else
                call QuestDiscription( caster, 'I080', udg_GoldAllTime[n], udg_QuestNum[15] )
            endif
        endif
        
        if GetUnitState( caster, UNIT_STATE_LIFE ) > 0.405 and not( IsUnitLoaded( caster ) ) then
            call DestroyEffect(AddSpecialEffect( "UI\\Feedback\\GoldCredit\\GoldCredit.mdl", GetUnitX( caster ), GetUnitY( caster ) ))
            call textst( "|c00FFFF00 +" + I2S( sum ), caster, 64, GetRandomReal(45, 135), 10, 1 )
        endif
        
        set Event_AfterMoneyAdded_Money = sum
        set Event_AfterMoneyAdded_Caster = caster
        set Event_AfterMoneyAdded_Real = 0.00
        set Event_AfterMoneyAdded_Real = 1.00
        set Event_AfterMoneyAdded_Real = 0.00
        
        set caster = null
    endfunction

endlibrary