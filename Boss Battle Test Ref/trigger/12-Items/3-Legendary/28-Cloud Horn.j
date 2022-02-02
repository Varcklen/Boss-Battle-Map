scope CloudHorn initializer init

    globals
        private constant integer ID_ABILITY = 'A0YL'
        
        private constant integer LIFE_TIME = 25
        private constant integer SCATTER = 400
        
        private constant integer SPAWN_MIN = 20
        private constant integer SPAWN_MAX = 30
        
        private constant string ANIMATION = "Abilities\\Spells\\Other\\Silence\\SilenceAreaBirth.mdl"
    endglobals

    function Trig_Cloud_Horn_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_ABILITY
    endfunction

    function Trig_Cloud_Horn_Actions takes nothing returns nothing
        local integer i
        local integer iEnd  
        local unit caster
        local unit sheep
        
        if CastLogic() then
            set caster = udg_Caster
        elseif RandomLogic() then
            set caster = udg_Caster
            call textst( udg_string[0] + GetObjectName(ID_ABILITY), caster, 64, 90, 10, 1.5 )
        else
            set caster = GetSpellAbilityUnit()
        endif
        
        set i = 1
        set iEnd = eyest( caster ) * GetRandomInt(SPAWN_MIN, SPAWN_MAX)
        loop
            exitwhen i > iEnd
            set sheep = CreateUnit( GetOwningPlayer(caster), ID_SHEEP, Math_GetRandomX(GetUnitX( caster ), SCATTER), Math_GetRandomY(GetUnitY( caster ), SCATTER), GetRandomReal(0, 360) )
            call spectimeunit( sheep, ANIMATION, "origin", 0.6 )
            call UnitApplyTimedLife( sheep, 'BTLF', LIFE_TIME )
            set i = i + 1
        endloop
        
        set caster = null
        set sheep = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_Cloud_Horn = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_Cloud_Horn, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_Cloud_Horn, Condition( function Trig_Cloud_Horn_Conditions ) )
        call TriggerAddAction( gg_trg_Cloud_Horn, function Trig_Cloud_Horn_Actions )
    endfunction
endscope
