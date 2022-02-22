library SpellPower initializer init requires TextLib

    globals
        private constant integer KEY_SPELL_POWER = StringHash("spd")
        private constant real BASE_SPELL_POWER = 1
        
        private real BossSpellPower = 1
        private constant real BOSS_SPELL_POWER_MIN = 0.2
        private constant real BOSS_SPELL_POWER_MAX = 10
    endglobals

    private function UpdateFrames takes integer heroIndex, real newSpellPower returns nothing
        local string spellPowerText
        local real k
    
        set spellPowerText = R2SW( newSpellPower, 1, 2 )
        call MultiSetValue( udg_multi, ( udg_Multiboard_Position[heroIndex] * 3 ) - 1, 4, spellPowerText + udg_perc )
        set k = StringLength(spellPowerText) * 0.004
        if GetLocalPlayer() == Player(heroIndex-1) then
            call BlzFrameSetText(spelltext, spellPowerText + udg_perc)
            call BlzFrameSetAbsPoint( spelltext, FRAMEPOINT_CENTER, 0.636 - k, 0.578 )
        endif
    endfunction

    function spdst takes unit u, real spd returns nothing
        local integer index = GetUnitUserData(u)
        local integer unitId = GetHandleId(u)
        local real oldSpellPower = LoadReal(udg_hash, unitId, KEY_SPELL_POWER )
        local real newSpellPower
        local real realForText
        
        if index <= 0 or index > PLAYERS_LIMIT then
            set u = null
            return
        endif
        
        set newSpellPower = oldSpellPower + ( spd / 100 )
        call SaveReal(udg_hash, unitId, KEY_SPELL_POWER, newSpellPower )

        set realForText = 100 * ( newSpellPower - 1 )
        if realForText < 0 and realForText > -1 then
            set realForText = 0
        endif

        call UpdateFrames( index, realForText )
        
        set u = null
    endfunction

    function SpellPotionUnit takes unit hero, real spd returns nothing
        local integer p = GetUnitUserData(hero)
        local player pl = GetOwningPlayer(hero)
        local integer i = p
        local string str
        local real r 
        local real a
        local real k
        
        set udg_SpellDamagePotion[i] = udg_SpellDamagePotion[i] + ( spd / 100 ) 
        set r = 100 * ( udg_SpellDamagePotion[i] - 1 )
        set a = r - 1

        if a < 0 and a > -1 then
            set a = 0
        endif

        set str = R2SW( a, 1, 2 )
        set k = StringLength(str) * 0.004
        if GetLocalPlayer() == pl then
            call BlzFrameSetText(extraPanelNumPotion, str + udg_perc)
            call BlzFrameSetPoint(extraPanelNumPotion, FRAMEPOINT_LEFT, extraPanelBackground, FRAMEPOINT_LEFT, 0.051 - k, -0.006)
        endif
        
        set hero = null
        set pl = null
    endfunction

    function SpellUniqueUnit takes unit hero, real spd returns nothing
        local integer i = GetUnitUserData(hero)
        local player pl = GetOwningPlayer(hero)
        local string str
        local real r 
        local real a
        local real k
        
        set udg_SpellDamageSpec[i] = udg_SpellDamageSpec[i] + ( spd / 100 ) 
        set r = 100 * ( udg_SpellDamageSpec[i] - 1 )
        set a = r - 1

        if a < 0 and a > -1 then
            set a = 0
        endif
        
        set str = R2SW( a, 1, 2 )
        set k = StringLength(str) * 0.004
        if GetLocalPlayer() == pl then
            call BlzFrameSetText(extraPanelNumUnique, str + udg_perc)
            call BlzFrameSetPoint(extraPanelNumUnique, FRAMEPOINT_LEFT, extraPanelBackground, FRAMEPOINT_LEFT, 0.051 - k, -0.025)
        endif

        set pl = null
        set hero = null
    endfunction
    
    function GetUnitSpellPower takes unit myUnit returns real
        local player owner = GetOwningPlayer(myUnit)
        local integer unitId = GetHandleId(myUnit)
        local real spellPower

        if owner == Player(10) or owner == Player(11) or owner == Player(PLAYER_NEUTRAL_AGGRESSIVE) then
            set spellPower = BossSpellPower
        elseif IsUnitInGroup(myUnit, udg_heroinfo) then
            set spellPower = LoadReal(udg_hash, unitId, KEY_SPELL_POWER )
        else
            set unitId = GetHandleId(udg_hero[GetPlayerId( GetOwningPlayer(myUnit) ) + 1])
            set spellPower = LoadReal(udg_hash, unitId, KEY_SPELL_POWER )
        endif
        set owner = null
        set myUnit = null
        return spellPower
    endfunction
    
    function GetPotionSpellPower takes unit myUnit returns real
        local real spellPower = udg_SpellDamagePotion[GetUnitUserData(myUnit)]
        
        set myUnit = null
        return spellPower
    endfunction
    
    function GetUniqueSpellPower takes unit myUnit returns real
        local real spellPower = udg_SpellDamageSpec[GetUnitUserData(myUnit)]
        
        set myUnit = null
        return spellPower
    endfunction

    //Obsolete. Do not use.
    function SpellPotion takes integer p, real spd returns nothing
        local player pl = Player( p-1 )
        local integer i = GetPlayerId( pl ) + 1
        local string str
        local real r 
        local real a
        local real k
        
        set udg_SpellDamagePotion[i] = udg_SpellDamagePotion[i] + ( spd / 100 ) 
        set r = 100 * ( udg_SpellDamagePotion[i] - 1 )
        set a = r - 1

        if a < 0 and a > -1 then
            set a = 0
        endif

        set str = R2SW( a, 1, 2 )
        set k = StringLength(str) * 0.004
        if GetLocalPlayer() == pl then
            call BlzFrameSetText(extraPanelNumPotion, str + udg_perc)
            call BlzFrameSetPoint(extraPanelNumPotion, FRAMEPOINT_LEFT, extraPanelBackground, FRAMEPOINT_LEFT, 0.051 - k, -0.006)
        endif
        
        set pl = null
    endfunction
    
    public function SetBossSpellPower takes real newBossSpellPower returns nothing
        set BossSpellPower = newBossSpellPower
        if BossSpellPower < BOSS_SPELL_POWER_MIN then
            set BossSpellPower = BOSS_SPELL_POWER_MIN
        elseif BossSpellPower > BOSS_SPELL_POWER_MAX then
            set BossSpellPower = BOSS_SPELL_POWER_MAX
        endif
    endfunction
    
    public function AddBossSpellPower takes real addedBossSpellPower returns nothing
        set BossSpellPower = BossSpellPower + addedBossSpellPower
        if BossSpellPower < BOSS_SPELL_POWER_MIN then
            set BossSpellPower = BOSS_SPELL_POWER_MIN
        endif
    endfunction

    public function GetBossSpellPower takes nothing returns real
        return BossSpellPower
    endfunction
    
    
    private function HeroChoose takes nothing returns nothing
        local integer unitId = GetHandleId(Event_HeroChoose_Hero)
        
        call SaveReal(udg_hash, unitId, KEY_SPELL_POWER, BASE_SPELL_POWER )
    endfunction
    
    private function OnDamageChange_Conditions takes nothing returns boolean
        return udg_IsDamageSpell and IsUnitHasAbility( udg_DamageEventSource, 'A0N5' ) == false and IsDisableSpellPower == false
    endfunction
    
    private function OnDamageChange takes nothing returns nothing
        set udg_DamageEventAmount = udg_DamageEventAmount + ( Event_OnDamageChange_StaticDamage * ( GetUnitSpellPower(udg_DamageEventSource) - 1 ) )
    endfunction
 
    private function init takes nothing returns nothing
        call CreateEventTrigger( "Event_HeroChoose_Real", function HeroChoose, null )
        call CreateEventTrigger( "Event_OnDamageChange_Real", function OnDamageChange, function OnDamageChange_Conditions )
        
        /*set cyclA = 0
        loop
            exitwhen cyclA > 3
            if GetPlayerSlotState(Player(cyclA)) == PLAYER_SLOT_STATE_PLAYING then
                call spdstpl( cyclA, 1 )
                call spdstpl( cyclA, -1 )
            endif
            set cyclA = cyclA + 1
        endloop*/
    endfunction

endlibrary