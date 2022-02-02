library List

    globals 
        private constant integer LIST_LIMIT = 100
    endglobals
    
    type ArrayInt extends integer array [LIST_LIMIT]

    struct ListInt
        private integer array list[LIST_LIMIT]
        private boolean array isFill[LIST_LIMIT]
        private integer max = 0
        
        private method FindEmptyAndFill takes nothing returns nothing
            local integer i = 0
            local integer k = 0
            local boolean end = false
            
            loop
                exitwhen i > .max or end
                if .isFill[i] == false then
                    set .max = .max - 1
                    set k = i
                    loop
                        exitwhen k > .max
                        set .isFill[k] = .isFill[k+1]
                        set .list[k] = .list[k+1]
                        set k = k + 1
                    endloop
                    set end = true
                endif
                set i = i + 1
            endloop
        endmethod
        
        method Add takes integer numberToAdd returns nothing
            set .list[.max] = numberToAdd
            set .isFill[.max] = true
            //call BJDebugMsg(".max: " + I2S(.max))
            set .max = .max + 1
        endmethod
        
        //not tested!
        method AddArray takes ArrayInt arrayToAdd, integer arraySize returns nothing
            local integer i = 0
            local integer k = 0
            
            loop
                exitwhen i > LIST_LIMIT or k > arraySize
                if .isFill[i] == false then
                    set .list[i] = arrayToAdd[k]
                    set .isFill[i] = true
                    set .max = i
                    set k = k + 1
                endif
                set i = i + 1
            endloop
            
            call arrayToAdd.destroy()
        endmethod
        
        //not tested!
        method RemoveByIndex takes integer indexToRemove returns nothing
            set .list[indexToRemove] = 0
            set .isFill[indexToRemove] = false
            call .FindEmptyAndFill()
        endmethod
        
        method GetIntegerByIndex takes integer index returns integer
            if index > max or index < 0 then
                call BJDebugMsg("Error! You have gone beyond the list! Current: " + I2S(index) + ". max: " + I2S(max))
                return 0
            elseif .isFill[index] == false then
                call BJDebugMsg("Error! You are trying to get a number from an empty index! Current: " + I2S(index))
                return 0
            else
                return .list[index]
            endif
        endmethod
        
        method Size takes nothing returns integer
            return max
        endmethod
    endstruct
endlibrary
