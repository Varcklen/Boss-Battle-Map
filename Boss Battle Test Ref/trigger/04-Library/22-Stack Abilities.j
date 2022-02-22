library StackAbilities requires Trigger

    struct AbilityStack
        readonly integer abilityRawCode
        private integer x
        private integer y
        private integer stackLimit
        
        private static integer LIMIT_X = 3
        private static integer LIMIT_Y = 2
        static framehandle array stackIcon[4][3]
        static framehandle array stackText[4][3]
        
        //Nulling Ability
        private static method NullingAbility_Conditions takes nothing returns boolean
            local integer abilityRawCode = LoadInteger(udg_hash, GetHandleId(GetTriggeringTrigger()), StringHash("stck") )
            return GetUnitAbilityLevel( udg_Event_NullingAbility_Unit, abilityRawCode) > 0
        endmethod

        private static method NullingAbility takes nothing returns nothing
            local integer x = LoadInteger(udg_hash, GetHandleId(GetTriggeringTrigger()), StringHash("stckx") )
            local integer y = LoadInteger(udg_hash, GetHandleId(GetTriggeringTrigger()), StringHash("stcky") )
            if GetLocalPlayer() == GetOwningPlayer( udg_Event_NullingAbility_Unit ) then
                call BlzFrameSetVisible( stackIcon[x][y], false )
            endif
        endmethod
        
        private method InitNullingAbility takes nothing returns nothing
            local trigger trig
            set trig = CreateEventTrigger( "udg_Event_NullingAbility_Real", function thistype.NullingAbility, function thistype.NullingAbility_Conditions )
            call SaveInteger(udg_hash, GetHandleId(trig), StringHash("stck"), .abilityRawCode )
            call SaveInteger(udg_hash, GetHandleId(trig), StringHash("stckx"), .x )
            call SaveInteger(udg_hash, GetHandleId(trig), StringHash("stcky"), .y )
            
            set trig = null
        endmethod
        
        //Ability Vision
        private static method Vision_Conditions takes nothing returns boolean
            return true //add something?
        endmethod
        
        private static method Vision takes nothing returns nothing
            local player owner = GetTriggerPlayer()
            local integer triggerId =  GetHandleId(GetTriggeringTrigger())
            local integer abilityRawCode = LoadInteger(udg_hash, triggerId, StringHash("stck") )
            local integer x = LoadInteger(udg_hash, triggerId, StringHash("stckx") )
            local integer y = LoadInteger(udg_hash, triggerId, StringHash("stcky") )
            
            if IsUnitHasAbility(GetTriggerUnit(), abilityRawCode) and GetTriggerPlayer() == GetOwningPlayer(GetTriggerUnit())  then
                if GetLocalPlayer() == owner then
                    call BlzFrameSetVisible( stackIcon[x][y], true )
                    call BlzFrameSetText( stackText[x][y], I2S(LoadInteger( udg_hash, abilityRawCode + GetHandleId(GetTriggerUnit()), StringHash( "stckc" ) )) )
                endif
            else
                if GetLocalPlayer() == owner then
                    call BlzFrameSetVisible( stackIcon[x][y], false )
                endif
            endif
            
            set owner = null
        endmethod
        
        private method InitVision takes nothing returns nothing
            local trigger trig = CreateTrigger()
            local integer i = 0
            
            loop
                exitwhen i > 3
                call TriggerRegisterPlayerSelectionEventBJ( trig, Player(i), true )
                set i = i + 1
            endloop
            call TriggerAddAction( trig, function thistype.Vision )
            call TriggerAddCondition( trig, Condition( function thistype.Vision_Conditions ) )
            call SaveInteger(udg_hash, GetHandleId(trig), StringHash("stck"), .abilityRawCode )
            call SaveInteger(udg_hash, GetHandleId(trig), StringHash("stckx"), .x )
            call SaveInteger(udg_hash, GetHandleId(trig), StringHash("stcky"), .y )
            
            set trig = null
        endmethod
        
        //Upgrade Ability
        private static method Upgrade_Conditions takes nothing returns boolean
            local integer abilityRawCode = LoadInteger(udg_hash, GetHandleId(GetTriggeringTrigger()), StringHash("stck") )
            return GetLearnedSkill() == abilityRawCode
        endmethod

        private static method Upgrade takes nothing returns nothing
            local unit hero = GetLearningUnit()
            local integer triggerId = GetHandleId(GetTriggeringTrigger())
            local integer abilityRawCode = LoadInteger(udg_hash, triggerId, StringHash("stck") )
            local integer stack = LoadInteger(udg_hash, triggerId, StringHash("stcks") )
            local integer x = LoadInteger(udg_hash, triggerId, StringHash("stckx") )
            local integer y = LoadInteger(udg_hash, triggerId, StringHash("stcky") )
            
            if GetUnitAbilityLevel( hero, abilityRawCode) == 1 then
                call SaveInteger( udg_hash, abilityRawCode + GetHandleId(hero), StringHash( "stckc" ), stack )
            endif
            if GetLocalPlayer() == GetOwningPlayer( hero ) then
                call BlzFrameSetVisible( stackIcon[x][y], true )
                call BlzFrameSetText( stackText[x][y], I2S( LoadInteger( udg_hash, abilityRawCode + GetHandleId(hero), StringHash( "stckc" ) ) ) )
            endif
            
            set hero = null
        endmethod

        private method InitUpgradeAbility takes nothing returns nothing
            local trigger trig = CreateTrigger()
            call TriggerRegisterAnyUnitEventBJ( trig, EVENT_PLAYER_HERO_SKILL )
            call TriggerAddCondition( trig, Condition( function thistype.Upgrade_Conditions ) )
            call TriggerAddAction( trig, function thistype.Upgrade )
            call SaveInteger(udg_hash, GetHandleId(trig), StringHash("stck"), .abilityRawCode )
            call SaveInteger(udg_hash, GetHandleId(trig), StringHash("stcks"), .stackLimit )
            call SaveInteger(udg_hash, GetHandleId(trig), StringHash("stckx"), .x )
            call SaveInteger(udg_hash, GetHandleId(trig), StringHash("stcky"), .y )
            
            set trig = null
        endmethod
        
        
        //Ability Cast
        private static method Cast_Conditions takes nothing returns boolean
            local integer abilityRawCode = LoadInteger(udg_hash, GetHandleId(GetTriggeringTrigger()), StringHash("stck") )
            return GetSpellAbilityId() == abilityRawCode
        endmethod

        private static method Charge takes nothing returns nothing 
            local integer id = GetHandleId( GetExpiredTimer( ) )
            local unit u = LoadUnitHandle( udg_hash, id, StringHash( "stcke" ) )
            local integer unitId = GetHandleId( u )
            local integer pat = LoadInteger( udg_hash, id, StringHash( "stcke" ) )
            local integer abilityRawCode = LoadInteger(udg_hash, id, StringHash( "stckea" ) )
            local integer stack = LoadInteger(udg_hash, id, StringHash( "stckes" ) )
            local framehandle frame = LoadFrameHandle(udg_hash, id, StringHash( "stckef" ) )
            local integer k = LoadInteger( udg_hash, abilityRawCode + unitId, StringHash( "stckc" ) )

            if pat == udg_Pattern then
                set k = k + 1
                if k > stack then
                    set k = stack
                endif
                if GetLocalPlayer() == GetOwningPlayer(u) then
                    call BlzFrameSetText( frame, I2S(k) )
                endif
                call SaveInteger( udg_hash, abilityRawCode + unitId, StringHash( "stckc" ), k )
                call BlzEndUnitAbilityCooldown( u, abilityRawCode )
            endif
            call FlushChildHashtable( udg_hash, id )
            
            set u = null
            set frame = null
        endmethod

        private static method Cooldown takes nothing returns nothing
            local integer id = GetHandleId( GetExpiredTimer() )
            local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "stckd" ) )
            local integer abilityRawCode = LoadInteger(udg_hash, id, StringHash( "stckd" ) )

            call BlzEndUnitAbilityCooldown( caster, abilityRawCode )
            call FlushChildHashtable( udg_hash, id )

            set caster = null
        endmethod

        private static method Cast takes nothing returns nothing
            local unit caster = GetSpellAbilityUnit()
            local integer triggerId =  GetHandleId(GetTriggeringTrigger())
            local integer abilityRawCode = LoadInteger(udg_hash, triggerId, StringHash("stck") )
            local integer stack = LoadInteger(udg_hash, triggerId, StringHash("stcks") )
            local integer x = LoadInteger(udg_hash, triggerId, StringHash("stckx") )
            local integer y = LoadInteger(udg_hash, triggerId, StringHash("stcky") )
            local integer unitId = GetHandleId( caster )
            local integer k = LoadInteger( udg_hash, abilityRawCode + unitId, StringHash( "stckc" ) )
            local real t
            local integer id
            
            if k > 0 then
                set k = k - 1
                call SaveInteger( udg_hash, abilityRawCode + unitId, StringHash( "stckc" ), k )
                
                set t = BlzGetAbilityRealLevelField(BlzGetUnitAbility(caster, abilityRawCode), ABILITY_RLF_COOLDOWN, 0) 
                if k > 0 then
                    set id = InvokeTimerWithUnit( caster, "stckd", 0.01, false, function thistype.Cooldown )
                    call SaveInteger(udg_hash, id, StringHash( "stckd" ), abilityRawCode )
                endif
                if GetLocalPlayer() == GetOwningPlayer(caster) then
                    call BlzFrameSetText( stackText[x][y], I2S(k) )
                endif
                
                set id = GetHandleId( caster )
                call SaveTimerHandle( udg_hash, id, StringHash( "stcke" ), CreateTimer() )
                set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "stcke" ) ) ) 
                call SaveUnitHandle( udg_hash, id, StringHash( "stcke" ), caster )
                call SaveInteger( udg_hash, id, StringHash( "stcke" ), udg_Pattern )
                call SaveInteger(udg_hash, id, StringHash( "stckea" ), abilityRawCode )
                call SaveInteger(udg_hash, id, StringHash( "stckes" ), stack )
                call SaveFrameHandle(udg_hash, id, StringHash( "stckef" ), stackText[x][y] )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "stcke" ) ), t, false, function thistype.Charge )
            endif
            
            set caster = null
        endmethod
        
        private method InitCast takes nothing returns nothing
            local trigger trig = CreateTrigger()
            call TriggerRegisterAnyUnitEventBJ( trig, EVENT_PLAYER_UNIT_SPELL_EFFECT )
            call TriggerAddCondition( trig, Condition( function thistype.Cast_Conditions ) )
            call TriggerAddAction( trig, function thistype.Cast )
            call SaveInteger(udg_hash, GetHandleId(trig), StringHash("stck"), .abilityRawCode )
            call SaveInteger(udg_hash, GetHandleId(trig), StringHash("stcks"), .stackLimit )
            call SaveInteger(udg_hash, GetHandleId(trig), StringHash("stckx"), .x )
            call SaveInteger(udg_hash, GetHandleId(trig), StringHash("stcky"), .y )
            
            set trig = null
        endmethod
        
        
        //Cooldown Reset
        private static method CooldownReset_Conditions takes nothing returns boolean
            local integer abilityRawCode = LoadInteger(udg_hash, GetHandleId(GetTriggeringTrigger()), StringHash("stck") )
            return IsUnitHasAbility( Event_CooldownReset_Hero, abilityRawCode)
        endmethod

        private static method CooldownReset takes nothing returns nothing
            local unit hero = Event_CooldownReset_Hero
            local integer triggerId =  GetHandleId(GetTriggeringTrigger())
            local integer abilityRawCode = LoadInteger(udg_hash, triggerId, StringHash("stck") )
            local integer x = LoadInteger(udg_hash, triggerId, StringHash("stckx") )
            local integer y = LoadInteger(udg_hash, triggerId, StringHash("stcky") )
            local integer stack = LoadInteger(udg_hash, triggerId, StringHash("stcks") )
            
            call SaveInteger( udg_hash, abilityRawCode + GetHandleId(hero), StringHash( "stckc" ), stack )
            if GetLocalPlayer() == GetOwningPlayer(hero) then
                call BlzFrameSetText( stackText[x][y], I2S(stack) )
            endif
            
            set hero = null
        endmethod
        
        private method InitResetCooldown takes nothing returns nothing
            local trigger trig = CreateTrigger()
            set trig = CreateEventTrigger( "Event_CooldownReset_Real", function thistype.CooldownReset, function thistype.CooldownReset_Conditions )
            call SaveInteger(udg_hash, GetHandleId(trig), StringHash("stck"), .abilityRawCode )
            call SaveInteger(udg_hash, GetHandleId(trig), StringHash("stckx"), .x )
            call SaveInteger(udg_hash, GetHandleId(trig), StringHash("stcky"), .y )
            call SaveInteger(udg_hash, GetHandleId(trig), StringHash("stcks"), .stackLimit )
            
            set trig = null
        endmethod
        
        //All triggers
        private method InitOther takes nothing returns nothing
            call InitUpgradeAbility()
            call InitNullingAbility()
            call InitVision()
            call InitCast()
            call InitResetCooldown()
            //call SaveInteger(udg_hash, .abilityRawCode, StringHash("stckc"), .stackLimit )
        endmethod
        
        static method create takes integer abilityRawCode, integer x, integer y, integer stackLimit returns AbilityStack
            local AbilityStack p = AbilityStack.allocate() 
            set p.abilityRawCode = abilityRawCode
            set p.x = IMinBJ( IMaxBJ(x,0), LIMIT_X )
            set p.y = IMinBJ( IMaxBJ(y,0), LIMIT_Y )
            set p.stackLimit = stackLimit
            call p.InitOther()
            return p
        endmethod
        
        private static method CreateStackIcon takes integer x, integer y returns nothing
            local framehandle text
            local framehandle backdrop
            local real xPos = 0.648 + (x*0.044)
            local real yPos = 0.102 - (y*0.044)
            
            set backdrop = BlzCreateFrameByType("BACKDROP", "", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "StandartFrameTemplate", 0)
            call BlzFrameSetSize( backdrop, 0.012, 0.012 )
            call BlzFrameSetAbsPoint(backdrop, FRAMEPOINT_CENTER, xPos, yPos)
            call BlzFrameSetTexture( backdrop, "war3mapImported\\BTNfeed-icon-red-1_result.blp",0, true)
            call BlzFrameSetVisible( backdrop, false )
            set stackIcon[x][y] = backdrop

            set text = BlzCreateFrameByType("TEXT", "", stackIcon[x][y], "StandartFrameTemplate", 0)
            call BlzFrameSetSize( text, 0.005, 0.01 )
            call BlzFrameSetAbsPoint(text, FRAMEPOINT_CENTER, xPos + 0.001, yPos)
            call BlzFrameSetText( text, "0" )
            set stackText[x][y] = text
            
            set text = null
            set backdrop = null
        endmethod
        
        private static method onInit takes nothing returns nothing
            local integer i
            local integer k
            
            set i = 0
            loop
                exitwhen i > LIMIT_X
                set k = 0
                loop
                    exitwhen k > LIMIT_Y
                    call CreateStackIcon(i, k)
                    set k = k + 1
                endloop
                set i = i + 1
            endloop
        endmethod
        
    endstruct
    
    public function AddAbilityStack takes integer whichAbility, integer x, integer y, integer stackLimit returns AbilityStack
        if udg_hash == null then
            set udg_hash = InitHashtable()
        endif
        return AbilityStack.create(whichAbility, x, y, stackLimit)
    endfunction

endlibrary
