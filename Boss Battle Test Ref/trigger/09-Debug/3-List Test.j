function Trig_List_Test_Actions takes nothing returns nothing
    local ListInt list = ListInt.create()
    local ArrayInt myArray = ArrayInt.create()
    local integer i = 0
    local integer rand
    
    /*call BJDebugMsg("====================")
    call BJDebugMsg("Add")
    call BJDebugMsg("====================")
    loop
        exitwhen i > 9
        set rand = GetRandomInt(1,100)
        call list.Add(rand)
        call BJDebugMsg("rand: " + I2S(rand))
        set i = i + 1
    endloop*/
    
    call BJDebugMsg("====================")
    call BJDebugMsg("AddArray")
    call BJDebugMsg("====================")
    loop
        exitwhen i > 9
        set rand = GetRandomInt(1,100)
        set myArray[i] = rand
        call BJDebugMsg("rand: " + I2S(rand))
        set i = i + 1
    endloop
    call list.AddArray(myArray, 9)
    
    call BJDebugMsg("====================")
    call BJDebugMsg("RemoveByIndex")
    call BJDebugMsg("====================")
    //call list.RemoveByIndex(4)
    set i = 0
    loop
        exitwhen i > 8
        call BJDebugMsg("Number: " + I2S(list.GetIntegerByIndex(i)))
        set i = i + 1
    endloop
    

    call list.destroy()
    call myArray.destroy()
endfunction

//===========================================================================
function InitTrig_List_Test takes nothing returns nothing
    set gg_trg_List_Test = CreateTrigger(  )
    call TriggerRegisterPlayerChatEvent( gg_trg_List_Test, Player(0), "1", true )
    call TriggerAddAction( gg_trg_List_Test, function Trig_List_Test_Actions )
endfunction

