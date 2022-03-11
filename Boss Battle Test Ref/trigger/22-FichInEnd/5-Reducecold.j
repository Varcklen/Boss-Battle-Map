function ReducecoldCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "hrpp" ) )
    local real r = LoadReal( udg_hash, id, StringHash( "hrpp" ) )
    local integer sk = LoadInteger( udg_hash, id, StringHash( "hrpp" ) )

    if BlzGetUnitAbilityCooldownRemaining(u, sk) != 0 and r > 0 then
        call BlzStartUnitAbilityCooldown( u, sk, BlzGetUnitAbilityCooldownRemaining(u, sk) * r )
    endif

    call FlushChildHashtable( udg_hash, id )

    set u = null
endfunction

function NoCast takes nothing returns boolean
    if GetSpellAbilityId() == 'A086' then
        return true
    endif
    if GetSpellAbilityId() == 'A0UG' then
        return true
    endif
    if GetSpellAbilityId() == 'A059' then
        return true
    endif
    if GetSpellAbilityId() == 'A067' then
        return true
    endif
    if GetSpellAbilityId() == 'A05W' then
        return true
    endif
    if GetSpellAbilityId() == 'A0KQ' then
        return true
    endif
    return false
endfunction

function cooldres takes unit caster, integer n returns real
	local real r = 1
	local integer i = GetPlayerId(GetOwningPlayer(caster)) + 1
    
	if GetUnitAbilityLevel( caster, 'A0TP') > 0 then
		set r = r - (0.04 * GetUnitAbilityLevel( caster, 'A0TP'))
	endif
	if inv(caster, 'I01V') > 0 then
		set r = r - (0.04 * SetCount_GetPieces(caster, SET_MECH))
	endif
    if inv(caster, 'I0E0') > 0 then
		set r = r - 0.1
        if AlchemyOnly(caster) then
            set r = r - 0.25
        endif
	endif
	if GetUnitAbilityLevel( caster, 'A0V4' ) > 0 then
		if luckylogic( caster, 2 + ( 2 * GetUnitAbilityLevel(caster, 'A0V4') ), 1, 100 ) then
			set r = r - 0.5
		endif
	endif
    if inv(caster, 'I0E5') > 0 and not(udg_logic[i + 26]) then
        set r = r + 0.15
    endif
    if inv(caster, 'I01K') > 0 and not(udg_logic[i + 26]) then
        set r = r + 0.15
    endif
    if inv(caster, 'I00B') > 0 and not(udg_logic[i + 26]) then
        set r = r + 0.25
    endif
    if inv(caster, 'I02H') > 0 then
        set r = r - 0.3
    endif
    if udg_modbad[23] then
        set r = r + 0.07
    endif
    if udg_Ability_Uniq[i] == n and inv(caster, 'I068') > 0 then
        set r = r - 0.5
    endif
	if NoCast() and udg_combatlogic[i] then
		set r = r * 12
	endif

	if r < 0.2 then
		set r = 0.2
	endif
	return r  
endfunction

function Trig_Reducecold_Actions takes nothing returns nothing
    local integer id 
    local real r = cooldres( GetSpellAbilityUnit(), GetSpellAbilityId())

    //if r < 1 then
        set id = GetHandleId( GetSpellAbilityUnit() )
        if LoadTimerHandle( udg_hash, id, StringHash( "hrpp" ) ) == null then
            call SaveTimerHandle( udg_hash, id, StringHash( "hrpp" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "hrpp" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "hrpp" ), GetSpellAbilityUnit() )
        call SaveReal( udg_hash, id, StringHash( "hrpp" ), r )
        call SaveInteger( udg_hash, id, StringHash( "hrpp" ), GetSpellAbilityId() )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "hrpp" ) ), 0.01, false, function ReducecoldCast )
    //endif 
endfunction

//===========================================================================
function InitTrig_Reducecold takes nothing returns nothing
    set gg_trg_Reducecold = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Reducecold, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddAction( gg_trg_Reducecold, function Trig_Reducecold_Actions )
endfunction

