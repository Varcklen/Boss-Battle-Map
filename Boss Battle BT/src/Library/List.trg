{
  "Id": 50332051,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "library List\r\n\r\n    globals \r\n        private constant integer LIST_LIMIT = 100\r\n    endglobals\r\n    \r\n    type ArrayInt extends integer array [LIST_LIMIT]\r\n\r\n    struct ListInt\r\n        private integer array list[LIST_LIMIT]\r\n        private boolean array isFill[LIST_LIMIT]\r\n        readonly integer Size = 0\r\n        \r\n        private method FindEmptyAndFill takes nothing returns nothing\r\n            local integer i = 0\r\n            local integer k = 0\r\n            local boolean end = false\r\n            \r\n            loop\r\n                exitwhen i > .Size or end\r\n                if .isFill[i] == false then\r\n                    set .Size = .Size - 1\r\n                    set k = i\r\n                    loop\r\n                        exitwhen k > .Size\r\n                        set .isFill[k] = .isFill[k+1]\r\n                        set .list[k] = .list[k+1]\r\n                        set k = k + 1\r\n                    endloop\r\n                    set end = true\r\n                endif\r\n                set i = i + 1\r\n            endloop\r\n        endmethod\r\n        \r\n        method Add takes integer numberToAdd returns nothing\r\n            set .list[.Size] = numberToAdd\r\n            set .isFill[.Size] = true\r\n            set .Size = .Size + 1\r\n            //call BJDebugMsg(\".Size: \" + I2S(.Size))\r\n        endmethod\r\n        \r\n        //not tested!\r\n        method AddArray takes ArrayInt arrayToAdd, integer arraySize returns nothing\r\n            local integer i = 0\r\n            local integer k = 0\r\n            \r\n            loop\r\n                exitwhen i > LIST_LIMIT or k > arraySize\r\n                if .isFill[i] == false then\r\n                    set .list[i] = arrayToAdd[k]\r\n                    set .isFill[i] = true\r\n                    set .Size = i\r\n                    set k = k + 1\r\n                endif\r\n                set i = i + 1\r\n            endloop\r\n            \r\n            call arrayToAdd.destroy()\r\n        endmethod\r\n        \r\n        method RemoveByIndex takes integer indexToRemove returns nothing\r\n            set .list[indexToRemove] = 0\r\n            set .isFill[indexToRemove] = false\r\n            call .FindEmptyAndFill()\r\n        endmethod\r\n        \r\n        method RemoveByData takes integer data returns nothing\r\n            local integer i = 0\r\n            local integer iMax = .Size\r\n            \r\n            loop\r\n                exitwhen i >= iMax\r\n                if .list[i] == data then\r\n                    call .RemoveByIndex(i)\r\n                    return\r\n                endif\r\n                set i = i + 1\r\n            endloop\r\n            call BJDebugMsg(\"Error! ListInt - RemoveByData: Data for remove are not found. Data: \" + I2S(data))\r\n        endmethod\r\n        \r\n        method GetIntegerByIndex takes integer index returns integer\r\n            if index > Size or index < 0 then\r\n                call BJDebugMsg(\"Error! You have gone beyond the list! Current: \" + I2S(index) + \". Size: \" + I2S(Size))\r\n                return 0\r\n            elseif .isFill[index] == false then\r\n                call BJDebugMsg(\"Error! You are trying to get a number from an empty index! Current: \" + I2S(index))\r\n                return 0\r\n            else\r\n                return .list[index]\r\n            endif\r\n        endmethod\r\n        \r\n        method IsEmpty takes nothing returns boolean\r\n            return .Size == 0\r\n        endmethod\r\n        \r\n        method GetRandomIndex takes nothing returns integer\r\n            return GetRandomInt(0, IMaxBJ(0, .Size - 1 ))\r\n        endmethod\r\n        \r\n        method GetRandomCell takes nothing returns integer\r\n        \tif .IsEmpty() then\r\n        \t\treturn -1\r\n        \tendif\r\n            return .list[GetRandomInt(0, IMaxBJ(0, .Size - 1 ))]\r\n        endmethod\r\n        \r\n        method GetRandomCellAndRemove takes nothing returns integer\r\n            local integer index = GetRandomInt(0, IMaxBJ(0, .Size - 1 ) )\r\n            local integer cell = .list[index]\r\n            call .RemoveByIndex(index)\r\n            return cell\r\n        endmethod\r\n        \r\n        method Shuffle takes nothing returns nothing\r\n            local integer i = 0\r\n            local integer iMax = .Size - 1\r\n            local integer rand\r\n            local integer temp\r\n            local boolean array shuffled\r\n            \r\n            loop\r\n                exitwhen i >= iMax\r\n                if shuffled[i] == false then\r\n                \tset rand = GetRandomInt(i + 1, iMax )\r\n                \tset temp = .list[i]\r\n                \tset .list[i] = .list[rand]\r\n                \tset .list[rand] = temp\r\n                \tset shuffled[rand] = true\r\n                endif\r\n                set i = i + 1\r\n            endloop\r\n        endmethod\r\n        \r\n        method CheckData takes nothing returns nothing\r\n            local integer i = 0\r\n            \r\n            call BJDebugMsg(\"================================\")\r\n            call BJDebugMsg(\"Checking list data:\")\r\n            loop\r\n                exitwhen i >= .Size\r\n                call BJDebugMsg(\"Data [\" + I2S(i) + \"]: \" + I2S(.list[i]))\r\n                set i = i + 1\r\n            endloop\r\n            call BJDebugMsg(\"================================\")\r\n        endmethod\r\n\r\n    endstruct\r\nendlibrary\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}