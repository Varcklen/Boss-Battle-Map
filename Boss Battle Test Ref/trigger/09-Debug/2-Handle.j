globals
    leaderboard HandleBoard = null
endglobals

function HandleCounter_Update takes nothing returns nothing
   local integer i = 0
   local integer id
   local location array P
   local real result=0
   loop
      exitwhen i >= 50
      set i = i + 1
      set P[i] = Location(0,0)
      set id = GetHandleId(P[i])
      set result = result + (id-0x100000)
   endloop
   set result = result/i-i/2
   loop
      call RemoveLocation(P[i])
      set P[i] = null
      exitwhen i <= 1
      set i = i - 1
   endloop
   call LeaderboardSetItemValue(HandleBoard,0,R2I(result))
endfunction

function HandleCounter_Actions takes nothing returns nothing
   set HandleBoard = CreateLeaderboard()
   call LeaderboardSetLabel(HandleBoard, "Handle Counter")
   call PlayerSetLeaderboard(GetLocalPlayer(),HandleBoard)
   call LeaderboardDisplay(HandleBoard,true)
   call LeaderboardAddItem(HandleBoard,"Handles",0,Player(0))
   call LeaderboardSetSizeByItemCount(HandleBoard,1)
   call HandleCounter_Update()
   call TimerStart(GetExpiredTimer(),0.05,true,function HandleCounter_Update)
endfunction

function Trig_Handle_Actions takes nothing returns nothing
    call TimerStart(CreateTimer(),0,false,function HandleCounter_Actions)
endfunction

//===========================================================================
function InitTrig_Handle takes nothing returns nothing
    set gg_trg_Handle = CreateTrigger(  )
    call TriggerAddAction( gg_trg_Handle, function Trig_Handle_Actions )
endfunction

