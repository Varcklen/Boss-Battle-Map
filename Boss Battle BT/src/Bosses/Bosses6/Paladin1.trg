{
  "Id": 50333551,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "scope Paladin01\r\n\r\n    globals\r\n        private constant integer HEALTH_CHECK = 75\r\n        \r\n        private constant integer LIMIT = 30\r\n        private constant integer SPEED = 40\r\n        private constant integer AREA = 128\r\n        private constant integer DAMAGE = 150\r\n        private constant integer PATH_LIMIT = 100\r\n        private constant real CREATION_COOLDOWN = 0.5\r\n        private constant real TIME_MOVE = 0.04\r\n        \r\n        private constant string TELEPORTATION_ANIMATION = \"Abilities\\\\Spells\\\\Human\\\\MassTeleport\\\\MassTeleportCaster.mdl\"\r\n        private constant string ANIMATION = \"Abilities\\\\Spells\\\\Orc\\\\Shockwave\\\\ShockwaveMissile.mdl\"\r\n        \r\n        private trigger Wave_Use = null\r\n    endglobals\r\n\r\n    function Trig_Paladin1_Conditions takes nothing returns boolean\r\n        return GetUnitTypeId( udg_DamageEventTarget ) == 'h00M' and GetUnitLifePercent(udg_DamageEventTarget) <= HEALTH_CHECK\r\n    endfunction\r\n    \r\n    /*private function PaladinDealDamage takes unit boss, effect wave, group nodmg returns nothing\r\n        local group g = CreateGroup()\r\n        local unit u\r\n    \r\n        call GroupEnumUnitsInRange( g, BlzGetLocalSpecialEffectX( wave ), BlzGetLocalSpecialEffectY( wave ), AREA, null )\r\n        loop\r\n            set u = FirstOfGroup(g)\r\n            exitwhen u == null\r\n            if unitst( u, boss, \"enemy\" ) and not( IsUnitInGroup( u, nodmg ) ) then\r\n                call UnitTakeDamage(boss, u, DAMAGE, DAMAGE_TYPE_MAGIC)\r\n                call GroupAddUnit( nodmg, u )\r\n            endif\r\n            call GroupRemoveUnit(g,u)\r\n        endloop\r\n    \r\n        call GroupClear( g )\r\n        call DestroyGroup( g )\r\n        set u = null\r\n        set g = null\r\n        set wave = null\r\n        set nodmg = null\r\n        set boss = null\r\n    endfunction\r\n    \r\n    private function PaladinWave takes nothing returns nothing\r\n        local integer id = GetHandleId( GetExpiredTimer() )\r\n        local effect wave = LoadEffectHandle( udg_hash, id, StringHash( \"bspl2\" ) )\r\n        local integer counter = LoadInteger( udg_hash, id, StringHash( \"bspl2\" ) ) + 1\r\n        local unit boss = LoadUnitHandle( udg_hash, id, StringHash( \"bspl2cs\" ) )\r\n        local real yaw = LoadReal( udg_hash, id, StringHash( \"bspl2\" ) )\r\n        local group nodmg = LoadGroupHandle( udg_hash, id, StringHash( \"bspl2g\" ) )\r\n        local point newPoint = 0\r\n        \r\n        if counter >= PATH_LIMIT or wave == null then\r\n            call DestroyEffect( wave )\r\n            call GroupClear( nodmg )\r\n            call DestroyGroup( nodmg )\r\n            call FlushChildHashtable( udg_hash, id )\r\n            call DestroyTimer( GetExpiredTimer() )\r\n        else\r\n            set newPoint = GetMovedPoint( wave, yaw, SPEED )\r\n            call BlzSetSpecialEffectPosition( wave, newPoint.x, newPoint.y, BlzGetLocalSpecialEffectZ(wave) )\r\n            call PaladinDealDamage(boss, wave, nodmg)\r\n            call SaveInteger( udg_hash, id, StringHash( \"bspl2\" ), counter )\r\n        endif\r\n        \r\n        call newPoint.destroy()\r\n        set nodmg = null\r\n        set wave = null\r\n        set boss = null\r\n    endfunction*/\r\n\r\n    private function EndWaves takes unit boss returns nothing\r\n        call SetUnitAnimation( boss, \"stand\" )\r\n        call pausest(boss, -1)\r\n        call UnitRemoveAbility( boss, 'Avul' )\r\n        call UnitRemoveAbility( boss, 'A0AC' )\r\n\r\n        set boss = null\r\n    endfunction\r\n    \r\n    function RotateEffect takes unit target, Math_point startPoint returns real\r\n        local Math_point unitPoint = Math_point.create()\r\n        local real yaw = 0\r\n        \r\n        set unitPoint.x = GetUnitX(target)\r\n        set unitPoint.y = GetUnitY(target)\r\n        \r\n        set yaw = GetAngleBetweenPoints(unitPoint, startPoint)\r\n\r\n        call startPoint.destroy()\r\n        call unitPoint.destroy()\r\n        set target = null\r\n        return yaw\r\n    endfunction\r\n    \r\n    private function DealDamage takes nothing returns nothing\r\n        call UnitTakeDamage(Event_WaveHit_Caster, Event_WaveHit_Target, DAMAGE, DAMAGE_TYPE_MAGIC)\r\n    endfunction\r\n    \r\n    private function CreateWave takes unit boss, unit target returns nothing\r\n        //local integer id = 0\r\n        local integer rand = 0\r\n        local Math_point startPoint = Math_point.create()\r\n        //local real yaw = 0\r\n    \r\n        set rand = GetRandomInt( 1, 4 )\r\n        set startPoint.x = GetRectCenterX( udg_Boss_Rect ) + 2000 * Cos( ( 45 + ( 90 * rand ) ) * bj_DEGTORAD )//startPoint.\r\n        set startPoint.y = GetRectCenterY( udg_Boss_Rect ) + 2000 * Sin( ( 45 + ( 90 * rand ) ) * bj_DEGTORAD )//startPoint.\r\n        \r\n        /*set wave = AddSpecialEffect( ANIMATION, startPoint.x, startPoint.y)\r\n        set yaw = RotateEffect(wave, target, startPoint )\r\n        //call BJDebugMsg(\"yaw: \" + R2S(yaw))\r\n        \r\n        set id = InvokeTimerWithEffect( wave, \"bspl2\", TIME_MOVE, true, function PaladinWave )\r\n        call SaveUnitHandle( udg_hash, id, StringHash( \"bspl2cs\" ), boss )\r\n        call SaveReal( udg_hash, id, StringHash( \"bspl2\" ), yaw )\r\n        call SaveGroupHandle( udg_hash, id, StringHash( \"bspl2g\" ), CreateGroup() )*/\r\n        \r\n        call Wave_CreateWave( boss, startPoint.x, startPoint.y, RotateEffect(target, startPoint), TIME_MOVE, AREA, PATH_LIMIT, SPEED, TARGET_ENEMY, WAVE_BASE_ANIMATION, Wave_Use, null )\r\n\r\n        call startPoint.destroy()\r\n        set boss = null\r\n        set target = null\r\n    endfunction\r\n\r\n    function PaladinCast takes nothing returns nothing\r\n        local integer id = GetHandleId( GetExpiredTimer( ) )\r\n        local unit boss = LoadUnitHandle( udg_hash, id, StringHash( \"bspl\" ) )\r\n        local integer counter = LoadInteger( udg_hash, id, StringHash( \"bspl\" ) ) + 1\r\n        local unit target = null\r\n        \r\n        if IsUnitDead(boss) or udg_fightmod[0] == false or counter >= LIMIT then\r\n            call EndWaves(boss)\r\n            call FlushChildHashtable( udg_hash, id )\r\n            call DestroyTimer( GetExpiredTimer() )\r\n        else\r\n            call SaveInteger( udg_hash, id, StringHash( \"bspl\" ), counter )\r\n            \r\n            if Math_IsNumberInteger(I2R(counter)/5) then\r\n                call SetUnitAnimationWithRarity( boss, \"spell channel\", RARITY_FREQUENT )\r\n            endif\r\n            \r\n            set target = GroupPickRandomUnit(udg_otryad)\r\n            if target != null then\r\n                call CreateWave(boss, target)\r\n                \r\n                //set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', x, y, bj_RADTODEG * Atan2( GetUnitY( u ) - y, GetUnitX( u ) - x ) )\r\n                //call UnitAddAbility( bj_lastCreatedUnit, 'A02M')\r\n                //call UnitAddAbility( bj_lastCreatedUnit, 'A0N5')\r\n                /*call SaveTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( \"bspl2\" ), CreateTimer() )\r\n                set id1 = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( \"bspl2\" ) ) ) \r\n                call SaveUnitHandle( udg_hash, id1, StringHash( \"bspl2\" ), bj_lastCreatedUnit )\r\n                \r\n                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( \"bspl2\" ) ),  )*/\r\n            endif\r\n        endif\r\n        \r\n        set target = null\r\n        set boss = null\r\n    endfunction\r\n\r\n    public function WaveStart takes unit boss, real cooldown returns nothing\r\n        call UnitAddAbility( boss, 'Avul')\r\n        call UnitAddAbility( boss, 'A0AC')\r\n        call DestroyEffect( AddSpecialEffect( TELEPORTATION_ANIMATION, GetUnitX(boss), GetUnitY(boss)) )\r\n        call SetUnitPosition( boss, GetRectCenterX(udg_Boss_Rect), GetRectCenterY(udg_Boss_Rect) + 600 )\r\n        call DestroyEffect( AddSpecialEffectTarget( TELEPORTATION_ANIMATION, boss, \"origin\") )\r\n        call pausest(boss, 1)\r\n        call SetUnitFacing( boss, bj_UNIT_FACING )\r\n        call SetUnitAnimationWithRarity( boss, \"spell channel\", RARITY_FREQUENT )\r\n        \r\n        call InvokeTimerWithUnit(boss, \"bspl\", cooldown, true, function PaladinCast)\r\n        \r\n        set boss = null\r\n    endfunction\r\n\r\n    function Trig_Paladin1_Actions takes nothing returns nothing\r\n        call DisableTrigger( GetTriggeringTrigger() )\r\n        call WaveStart(udg_DamageEventTarget, CREATION_COOLDOWN)\r\n    endfunction\r\n\r\n    //===========================================================================\r\n    function InitTrig_Paladin1 takes nothing returns nothing\r\n        set gg_trg_Paladin1 = CreateTrigger(  )\r\n        call DisableTrigger( gg_trg_Paladin1 )\r\n        call TriggerRegisterVariableEvent( gg_trg_Paladin1, \"udg_AfterDamageEvent\", EQUAL, 1.00 )\r\n        call TriggerAddCondition( gg_trg_Paladin1, Condition( function Trig_Paladin1_Conditions ) )\r\n        call TriggerAddAction( gg_trg_Paladin1, function Trig_Paladin1_Actions )\r\n        \r\n        set Wave_Use = CreateTrigger()\r\n        call TriggerAddAction( Wave_Use, function DealDamage )\r\n    endfunction\r\n\r\nendscope",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}