library AUI

globals
    private integer ibar = 0
    private integer kbar = 0

    unit bossbar = null
    unit bossbar1 = null

    framehandle hpbar1 = null
    framehandle hpbar2 = null
    
    framehandle hpPerc1 = null
    framehandle hpPerc2 = null
endglobals

function HpSetter1z takes nothing returns nothing 
    local integer hp = R2I(GetUnitStateSwap(UNIT_STATE_LIFE, bossbar)/GetUnitStateSwap(UNIT_STATE_MAX_LIFE, bossbar)*100)

    if GetUnitState(bossbar, UNIT_STATE_LIFE) <= 0.405 or not(udg_fightmod[0]) then
        set bossbar = null
        call BlzFrameSetVisible( hpbar1, false )
        call BlzFrameSetVisible( hpPerc1, false )
        call DestroyTimer( GetExpiredTimer() )
        return
    endif

    call BlzFrameSetValue(BlzGetFrameByName("MyBarEx",1), hp)
    call BlzFrameSetText(BlzGetFrameByName("MyBarExText",1), I2S(R2I(GetUnitStateSwap(UNIT_STATE_LIFE, bossbar)))+"/"+I2S(R2I(GetUnitStateSwap(UNIT_STATE_MAX_LIFE, bossbar))))
    call BlzFrameSetText( hpPerc1, "|cffbababc" + I2S(hp)+ "%|r" )

    if hp >= 66 and ibar != 0 then
        set ibar = 0
        call BlzFrameSetTexture(hpbar1, "Replaceabletextures\\Teamcolor\\Teamcolor22.blp", 0, true)
    elseif hp < 66 and hp >= 33 and ibar != 1 then
        set ibar = 1
        call BlzFrameSetTexture(hpbar1, "Replaceabletextures\\Teamcolor\\Teamcolor05.blp", 0, true)
    elseif hp < 33 and ibar != 2 then
        set ibar = 2
        call BlzFrameSetTexture(hpbar1, "Replaceabletextures\\Teamcolor\\Teamcolor12.blp", 0, true)
    endif
endfunction

function HpSetter2z takes nothing returns nothing 
    local integer hp = R2I(GetUnitStateSwap(UNIT_STATE_LIFE, bossbar1)/GetUnitStateSwap(UNIT_STATE_MAX_LIFE, bossbar1)*100)
    
    if GetUnitState(bossbar1, UNIT_STATE_LIFE) <= 0.405 or not(udg_fightmod[0]) then
        set bossbar1 = null
        call BlzFrameSetVisible( hpbar2, false )
        call BlzFrameSetVisible( hpPerc2, false )
        call DestroyTimer( GetExpiredTimer() )
        return
    endif
    
    call BlzFrameSetValue(BlzGetFrameByName("MyBarEx",2), hp)
    call BlzFrameSetText(BlzGetFrameByName("MyBarExText",2), I2S(R2I(GetUnitStateSwap(UNIT_STATE_LIFE, bossbar1)))+"/"+I2S(R2I(GetUnitStateSwap(UNIT_STATE_MAX_LIFE, bossbar1))))
    call BlzFrameSetText( hpPerc2, "|cffbababc" + I2S(hp)+ "%|r" )
    
    if hp >= 66 and kbar != 0 then
        set kbar = 0
        call BlzFrameSetTexture(hpbar2, "Replaceabletextures\\Teamcolor\\Teamcolor22.blp", 0, true)
    elseif hp < 66 and hp >= 33 and kbar != 1 then
        set kbar = 1
        call BlzFrameSetTexture(hpbar2, "Replaceabletextures\\Teamcolor\\Teamcolor05.blp", 0, true)
    elseif hp < 33 and kbar != 2 then
        set kbar = 2
        call BlzFrameSetTexture(hpbar2, "Replaceabletextures\\Teamcolor\\Teamcolor12.blp", 0, true)
    endif
endfunction

public function TimerGo takes nothing returns nothing
	if bossbar != null then
		set ibar = 0
		call BlzFrameSetVisible( hpbar1, true )
        call BlzFrameSetVisible( hpPerc1, true )
		call BlzFrameSetTexture(hpbar1, "Replaceabletextures\\Teamcolor\\Teamcolor22.blp", 0, true)
        call TimerStart(CreateTimer(),0.05,true,function HpSetter1z)
	endif
	if bossbar1 != null then
		set kbar = 0
		call BlzFrameSetVisible( hpbar2, true )
        call BlzFrameSetVisible( hpPerc2, true )
		call BlzFrameSetTexture(hpbar2, "Replaceabletextures\\Teamcolor\\Teamcolor22.blp", 0, true)
		call TimerStart(CreateTimer(),0.05,true,function HpSetter2z)
	endif
endfunction

public function HpBarHide takes nothing returns nothing
    call BlzFrameSetVisible( hpbar1, false )
    call BlzFrameSetVisible( hpPerc1, false )

    call BlzFrameSetVisible( hpbar2, false )
    call BlzFrameSetVisible( hpPerc2, false )
endfunction

endlibrary