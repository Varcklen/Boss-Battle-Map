scope ShamanWCheese initializer init

    globals
        private constant integer ID_UNIT = 'h01V'
        private constant integer CHANCE = 20
        private constant real HEAL_SCALE = 2.5
        
        private constant string ANIMATION = "Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl"
    endglobals

    private function AfterDamageEvent_Conditions takes nothing returns boolean
        return GetUnitTypeId(udg_DamageEventTarget) == 'h01V' and IsUnitType( udg_DamageEventSource, UNIT_TYPE_HERO)
    endfunction

    private function AfterDamageEvent takes nothing returns nothing
        local integer cheeseId = GetHandleId(udg_DamageEventTarget)
        local unit caster = LoadUnitHandle( udg_hash, cheeseId, StringHash( "ches" ) )
        local unit cheese = udg_DamageEventTarget
        local unit dealer = udg_DamageEventSource
        local real heal = HEAL_SCALE * udg_DamageEventAmount
    
        call healst( caster, dealer, heal )
        call PlaySpecialEffect( ANIMATION, dealer )
		if LuckChance( caster, CHANCE ) then
			set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'u015', GetUnitX( cheese ), GetUnitY( cheese ), GetRandomReal( 0, 360 ) )
            call UnitApplyTimedLife(bj_lastCreatedUnit, 'BTLF', 20 )
            call SetUnitVertexColor( bj_lastCreatedUnit, 255, 255, 255, 200 )
            call BlzSetUnitBaseDamage( bj_lastCreatedUnit, LoadInteger( udg_hash, cheeseId, StringHash( "ches" ) ), 0 )
            call spectimeunit( bj_lastCreatedUnit, "Abilities\\Spells\\Human\\Banish\\BanishTarget.mdl", "origin", 20 )
		endif
        
        set caster = null
        set dealer = null
        set cheese = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call CreateEventTrigger( "udg_AfterDamageEvent", function AfterDamageEvent, function AfterDamageEvent_Conditions )
    endfunction
    
endscope