scope BoStaff initializer init

    globals
        private constant integer ID_ITEM = 'I0H8'
        private constant integer ULT_WEAPON = 'I030'
        private constant integer ULT_NUMBER = 20
        
        private constant integer EXTRA_ATTACK = 1
        private constant integer COOLDOWN = 10
    endglobals

    function Trig_Bo_Staff_Conditions takes nothing returns boolean 
        return GetItemTypeId(GetManipulatedItem()) == ID_ITEM  or ( GetItemTypeId(GetManipulatedItem()) == ULT_WEAPON and udg_Set_Weapon_Logic[GetPlayerId(GetOwningPlayer( GetManipulatingUnit() )) + 1 + ULT_NUMBER] ) 
    endfunction 

    function Bo_StaffCast takes nothing returns nothing 
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit hero = LoadUnitHandle( udg_hash, id, StringHash( "bstac" ) )
        local item it = LoadItemHandle( udg_hash, id, StringHash( "bsta" ) )
        local integer heroId =  GetHandleId( hero )
        local integer bonusAttack = LoadInteger(udg_hash, heroId, StringHash( "bstat" ) )
        
        if not(UnitHasItem(hero,it)) then
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        elseif IsUnitAlive(hero) and combat(hero, false, 0) then
            call BlzSetUnitBaseDamage( hero, BlzGetUnitBaseDamage(hero, 0) + EXTRA_ATTACK, 0 )
            call SaveInteger(udg_hash, heroId, StringHash( "bstat" ), bonusAttack + EXTRA_ATTACK )
        endif
        
        set hero = null
        set it = null
    endfunction

    function Trig_Bo_Staff_Actions takes nothing returns nothing
        local integer id
        local unit caster
        local item it

        if udg_CastLogic then
            set udg_CastLogic = false
            set caster = udg_Caster
            set it = udg_CastItem
        else    
            set caster = GetManipulatingUnit()
            set it = GetManipulatedItem()
        endif

        set id = InvokeTimerWithItem(it, "bsta", COOLDOWN, true, function Bo_StaffCast )
        call SaveUnitHandle( udg_hash, id, StringHash( "bstac" ), caster )

        set caster = null
        set it = null
    endfunction
    
    private function FightEnd_Conditions takes nothing returns boolean
        return LoadInteger(udg_hash, GetHandleId( udg_FightEnd_Unit ), StringHash( "bstat" ) ) > 0
    endfunction
    
    private function FightEnd takes nothing returns nothing
        local unit hero = udg_FightEnd_Unit
        local integer heroId =  GetHandleId( hero )
        local integer bonusAttack = LoadInteger(udg_hash, heroId, StringHash( "bstat" ) )

        call BlzSetUnitBaseDamage( hero, BlzGetUnitBaseDamage(hero, 0) - bonusAttack, 0 )
        call SaveInteger(udg_hash, heroId, StringHash( "bstat" ), 0 )
        
        set hero = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_Bo_Staff = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_Bo_Staff, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
        call TriggerAddCondition( gg_trg_Bo_Staff, Condition( function Trig_Bo_Staff_Conditions ) ) 
        call TriggerAddAction( gg_trg_Bo_Staff, function Trig_Bo_Staff_Actions )
        
        call CreateEventTrigger( "udg_FightEnd_Real", function FightEnd, function FightEnd_Conditions )
    endfunction

endscope
