{
  "Id": 50332562,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_Blood_Knife_Conditions takes nothing returns boolean\r\n    return GetSpellAbilityId() == 'A0X6' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )\r\nendfunction\r\n\r\nfunction Blood_KnifeEnd takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer() )\r\n    local unit u = LoadUnitHandle( udg_hash, id, StringHash( \"blkn1\" ) )\r\n    \r\n    if combat( u, false, 0 ) and IsUnitDead(u) then\r\n        call ReviveHero( u, GetUnitX( u ), GetUnitY(u), true )\r\n        call ShowUnitShow( u )\r\n        if IsUnitDead(u) then\r\n            call BJDebugMsg(\"Error! Blood_KnifeEnd: Ressurection unseccesful!\")\r\n        else\r\n            call PauseUnit( u, false )\r\n            call SetUnitState( u, UNIT_STATE_LIFE, GetUnitState( u, UNIT_STATE_MAX_LIFE) * 0.5 )\r\n            call SetUnitState( u, UNIT_STATE_MANA, GetUnitState( u, UNIT_STATE_MAX_MANA) * 0.5 )\r\n        endif\r\n    endif\r\n    call DeathSystem_SetUnkillable(u, false)\r\n    //call UnitRemoveAbility( u, 'A0EX' )\r\n    \r\n    call FlushChildHashtable( udg_hash, id )\r\n    set u = null\r\nendfunction\r\n\r\nfunction Blood_KnifeCast takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer( ) )\r\n    local group g = CreateGroup()\r\n    local unit target = LoadUnitHandle( udg_hash, id, StringHash( \"blkn\" ) )\r\n    local integer id1 = GetHandleId( target )\r\n    local effect particle\r\n\r\n    if combat( target, false, 0 ) then\r\n    \tset particle = AddSpecialEffect( \"Abilities\\\\Spells\\\\Human\\\\Resurrect\\\\ResurrectCaster.mdl\",  GetUnitX( target ), GetUnitY( target ) )\r\n    \tcall BlzSetSpecialEffectYaw( particle, Deg2Rad(270) )\r\n        call DestroyEffect( particle )\r\n    \r\n    \t//call UnitAddAbility( target, 'A0EX' )\r\n    \t\r\n        if LoadTimerHandle( udg_hash, id1, StringHash( \"blkn1\" ) ) == null then\r\n            call SaveTimerHandle( udg_hash, id1, StringHash( \"blkn1\" ), CreateTimer() )\r\n        endif\r\n        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( \"blkn1\" ) ) ) \r\n        call SaveUnitHandle( udg_hash, id1, StringHash( \"blkn1\" ), target )\r\n        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( \"blkn1\" ) ), 3, false, function Blood_KnifeEnd )\r\n        \r\n        call DeathSystem_SetUnkillable(target, true)\r\n        \r\n        call KillUnit( target )\r\n    endif\r\n    \r\n    call FlushChildHashtable( udg_hash, id )\r\n    \r\n    set particle = null\r\n    set target = null\r\nendfunction   \r\n\r\nfunction Trig_Blood_Knife_Actions takes nothing returns nothing\r\n    local integer id \r\n    local unit caster\r\n    local integer x\r\n    \r\n    if CastLogic() then\r\n        set caster = udg_Caster\r\n    elseif RandomLogic() then\r\n        set caster = udg_Caster\r\n        call textst( udg_string[0] + GetObjectName('A0X6'), caster, 64, 90, 10, 1.5 )\r\n    else\r\n        set caster = GetSpellAbilityUnit()\r\n    endif\r\n    \r\n    set x = eyest( caster )\r\n    set id = GetHandleId( caster )\r\n    \r\n    if LoadTimerHandle( udg_hash, id, StringHash( \"blkn\" ) ) == null then \r\n        call SaveTimerHandle( udg_hash, id, StringHash( \"blkn\" ), CreateTimer() )\r\n    endif\r\n\tset id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"blkn\" ) ) ) \r\n\tcall SaveUnitHandle( udg_hash, id, StringHash( \"blkn\" ), caster )\r\n\tcall TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( \"blkn\" ) ), 0.01, false, function Blood_KnifeCast )\r\n    \r\n    set caster = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_Blood_Knife takes nothing returns nothing\r\n    set gg_trg_Blood_Knife = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_Blood_Knife, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n    call TriggerAddCondition( gg_trg_Blood_Knife, Condition( function Trig_Blood_Knife_Conditions ) )\r\n    call TriggerAddAction( gg_trg_Blood_Knife, function Trig_Blood_Knife_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}