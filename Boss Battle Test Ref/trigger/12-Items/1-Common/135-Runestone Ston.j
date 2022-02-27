scope RuneStoneSton initializer init

    globals
        private constant integer ID_ITEM = 'I00M'
        private constant integer DURATION = 5
        
        private constant integer EFFECT = 'A0WL'
        private constant integer BUFF = 'B018'
    endglobals

    function Trig_Runestone_Ston_Conditions takes nothing returns boolean
        return udg_IsDamageSpell == false and IsHeroHasItem(udg_DamageEventSource,  ID_ITEM )
    endfunction

    function Trig_Runestone_Ston_Actions takes nothing returns nothing
        local integer id 
        local unit caster = udg_DamageEventSource
        local unit target = udg_DamageEventTarget
        local real duration = timebonus(caster, DURATION)
        
        call bufst(caster, target, EFFECT, BUFF, "ston", duration )
        call debuffst( caster, target, null, 1, duration )
        
        set caster = null
        set target = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call CreateEventTrigger("udg_AfterDamageEvent", function Trig_Runestone_Ston_Actions, function Trig_Runestone_Ston_Conditions )
    endfunction

endscope

