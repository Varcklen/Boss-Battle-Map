library TargetRelation
    
    globals
        
        
        constant integer TARGET_ALLY_NUM = 0
        constant integer TARGET_ENEMY_NUM = 1
        constant integer TARGET_ALL_NUM = 2
        
        private constant integer ENUM_MAX = 2
    endglobals

    struct TargetRelation
        readonly integer enum
    
        method isEnumCorrect takes nothing returns boolean
            return enum >= 0 or enum <= ENUM_MAX
        endmethod
    
        static method create takes integer enum returns TargetRelation
            // Если мы переопределяем метод create
            // мы сами должны вызвать метод allocate
            local TargetRelation p = TargetRelation.allocate()
            set p.enum = enum
            
            // Возвращаем созданный экземпляр
            if p.enum < 0 then
                set p.enum = 0
                call BJDebugMsg("Warning! The specified enum was less than 0. It is now 0.")
            elseif p.enum > ENUM_MAX then
                set p.enum = ENUM_MAX
                call BJDebugMsg("Warning! The specified enum was more than " + I2S(ENUM_MAX) + ". It is now "+ I2S(ENUM_MAX) +".")
            endif
            return p
        endmethod
    
        static method TARGET_ALLY takes nothing returns integer
            return TARGET_ALLY_NUM
        endmethod
        
        static method TARGET_ENEMY takes nothing returns integer
            return TARGET_ENEMY_NUM
        endmethod
        
        static method TARGET_ALL takes nothing returns integer
            return TARGET_ALL_NUM
        endmethod
    endstruct
endlibrary