library List

    globals 
        private constant integer LIST_LIMIT = 100
    endglobals
    
    type ArrayInt extends integer array [LIST_LIMIT]

    struct ListInt
        private integer array list[LIST_LIMIT]
        private boolean array isFill[LIST_LIMIT]
        readonly integer Size = 0
        
        private method FindEmptyAndFill takes nothing returns nothing
            local integer i = 0
            local integer k = 0
            local boolean end = false
            
            loop
                exitwhen i > .Size or end
                if .isFill[i] == false then
                    set .Size = .Size - 1
                    set k = i
                    loop
                        exitwhen k > .Size
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
            set .list[.Size] = numberToAdd
            set .isFill[.Size] = true
            set .Size = .Size + 1
            //call BJDebugMsg(".Size: " + I2S(.Size))
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
                    set .Size = i
                    set k = k + 1
                endif
                set i = i + 1
            endloop
            
            call arrayToAdd.destroy()
        endmethod
        
        method RemoveByIndex takes integer indexToRemove returns nothing
            set .list[indexToRemove] = 0
            set .isFill[indexToRemove] = false
            call .FindEmptyAndFill()
        endmethod
        
        method GetIntegerByIndex takes integer index returns integer
            if index > Size or index < 0 then
                call BJDebugMsg("Error! You have gone beyond the list! Current: " + I2S(index) + ". Size: " + I2S(Size))
                return 0
            elseif .isFill[index] == false then
                call BJDebugMsg("Error! You are trying to get a number from an empty index! Current: " + I2S(index))
                return 0
            else
                return .list[index]
            endif
        endmethod
        
        method GetRandomIndex takes nothing returns integer
            return GetRandomInt(0, IMaxBJ(0, .Size - 1 ))
        endmethod
        
        method GetRandomCell takes nothing returns integer
            return .list[GetRandomInt(0, IMaxBJ(0, .Size - 1 ))]
        endmethod
        
        method GetRandomCellAndRemove takes nothing returns integer
            local integer index = GetRandomInt(0, IMaxBJ(0, .Size - 1 ) )
            local integer cell = .list[index]
            call .RemoveByIndex(index)
            return cell
        endmethod
        
        method IsEmpty takes nothing returns boolean
            return .Size == 0
        endmethod
    endstruct
endlibrary
