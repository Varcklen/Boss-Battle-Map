library SetCount

    globals
        constant integer SET_MECH = 1
        constant integer SET_WEAPON = 2
        constant integer SET_RING = 3
        constant integer SET_BLOOD = 4
        constant integer SET_RUNE = 5
        constant integer SET_MOON = 6
        constant integer SET_NATURE = 7
        constant integer SET_ALCHEMY = 8
        constant integer SET_CRYSTAL = 9
           
        constant string SET_NAME_MECH = "|cffb18904Mech|r"
        constant string SET_NAME_WEAPON = "|cff2d9995Weapon|r"
        constant string SET_NAME_RING = "|cff9001fdRing|r"
        constant string SET_NAME_BLOOD = "|cffb40431Blood|r"
        constant string SET_NAME_RUNE = "|cff848484Rune|r"
        constant string SET_NAME_MOON = "|cff5858faMoon|r"
        constant string SET_NAME_NATURE = "|cff7cfc00Nature|r"
        constant string SET_NAME_ALCHEMY = "|cfffe9a2eAlchemy|r"
        constant string SET_NAME_CRYSTAL = "|cff00cceeCrystal|r"
        
        private constant integer KEY_MECH = StringHash( "mech" )
        private constant integer KEY_WEAPON = StringHash( "weap" )
        private constant integer KEY_RING = StringHash( "ring" )
        private constant integer KEY_BLOOD = StringHash( "blood" )
        private constant integer KEY_RUNE = StringHash( "rune" )
        private constant integer KEY_MOON = StringHash( "moon" )
        private constant integer KEY_NATURE = StringHash( "natu" )
        private constant integer KEY_ALCHEMY = StringHash( "alch" )
        private constant integer KEY_CRYSTAL = StringHash( "crys" )
        
        real Event_MechAdded_Real
        integer Event_MechAdded_AddedMechs
        integer Event_MechAdded_NewCount
        integer Event_MechAdded_OldCount
        unit Event_MechAdded_Hero
    endglobals

    private function SetMech takes unit u, integer addedMechs, integer index returns integer
        local integer unitIndex = GetHandleId(u)
        local integer currentMech = LoadInteger(udg_hash, unitIndex, KEY_MECH )
        local integer oldMech = currentMech
        
        set currentMech = addedMechs
        
        call SaveInteger(udg_hash, unitIndex, KEY_MECH, currentMech )
        call MultiSetValue( udg_multi, ( 3 * udg_Multiboard_Position[index] ) + 1, 15, I2S( currentMech ) )
        
        set Event_MechAdded_Hero = u
        set Event_MechAdded_OldCount = oldMech
        set Event_MechAdded_AddedMechs = currentMech - oldMech
        set Event_MechAdded_NewCount = currentMech
        set Event_MechAdded_Real = 0.00
        set Event_MechAdded_Real = 1.00
        set Event_MechAdded_Real = 0.00
        
        set u = null
        return currentMech
    endfunction
    
    public function AddPiece takes unit hero, integer setCount, integer numberToAdd returns nothing
        local integer unitId = GetUnitUserData(hero)
    
        if setCount == SET_ALCHEMY then
            set udg_Set_Alchemy_Number[unitId] = udg_Set_Alchemy_Number[unitId] + numberToAdd
        elseif setCount == SET_BLOOD then
            set udg_Set_Blood_Number[unitId] = udg_Set_Blood_Number[unitId] + numberToAdd
        elseif setCount == SET_CRYSTAL then
            set udg_Set_Cristall_Number[unitId] = udg_Set_Cristall_Number[unitId] + numberToAdd
        elseif setCount == SET_MECH then
            call SetMech(hero, LoadInteger(udg_hash, GetHandleId(hero), KEY_MECH ) + numberToAdd, unitId)
        elseif setCount == SET_MOON then
            set udg_Set_Moon_Number[unitId] = udg_Set_Moon_Number[unitId] + numberToAdd
        elseif setCount == SET_NATURE then
            set udg_Set_Nature_Number[unitId] = udg_Set_Nature_Number[unitId] + numberToAdd
        elseif setCount == SET_RING then
            set udg_Set_Ring_Number[unitId] = udg_Set_Ring_Number[unitId] + numberToAdd
        elseif setCount == SET_RUNE then
            set udg_Set_Rune_Number[unitId] = udg_Set_Rune_Number[unitId] + numberToAdd
        elseif setCount == SET_WEAPON then
            set udg_Set_Weapon_Number[unitId] = udg_Set_Weapon_Number[unitId] + numberToAdd
        endif
        
        set hero = null
    endfunction
    
    public function SetPiece takes unit hero, integer setCount, integer numberToSet returns nothing
        local integer unitId = GetUnitUserData(hero)
    
        if setCount == SET_ALCHEMY then
            set udg_Set_Alchemy_Number[unitId] = numberToSet
        elseif setCount == SET_BLOOD then
            set udg_Set_Blood_Number[unitId] = numberToSet
        elseif setCount == SET_CRYSTAL then
            set udg_Set_Cristall_Number[unitId] = numberToSet
        elseif setCount == SET_MECH then
            call SetMech(hero, numberToSet, unitId)
        elseif setCount == SET_MOON then
            set udg_Set_Moon_Number[unitId] = numberToSet
        elseif setCount == SET_NATURE then
            set udg_Set_Nature_Number[unitId] = numberToSet
        elseif setCount == SET_RING then
            set udg_Set_Ring_Number[unitId] = numberToSet
        elseif setCount == SET_RUNE then
            set udg_Set_Rune_Number[unitId] = numberToSet
        elseif setCount == SET_WEAPON then
            set udg_Set_Weapon_Number[unitId] = numberToSet
        endif
        
        set hero = null
    endfunction
    
    public function GetPieces takes unit hero, integer setCount returns integer
        local integer count = 0
        local integer unitId = GetUnitUserData(hero)
    
        if setCount == SET_ALCHEMY then
            set count = udg_Set_Alchemy_Number[unitId]
        elseif setCount == SET_BLOOD then
            set count = udg_Set_Blood_Number[unitId]
        elseif setCount == SET_CRYSTAL then
            set count = udg_Set_Cristall_Number[unitId]
        elseif setCount == SET_MECH then
            set count = LoadInteger(udg_hash, GetHandleId(hero), KEY_MECH )
        elseif setCount == SET_MOON then
            set count = udg_Set_Moon_Number[unitId]
        elseif setCount == SET_NATURE then
            set count = udg_Set_Nature_Number[unitId]
        elseif setCount == SET_RING then
            set count = udg_Set_Ring_Number[unitId]
        elseif setCount == SET_RUNE then
            set count = udg_Set_Rune_Number[unitId]
        elseif setCount == SET_WEAPON then
            set count = udg_Set_Weapon_Number[unitId]
        endif
        
        set hero = null
        return count
    endfunction
    
    public function GetSetName takes integer setCount returns string
        if setCount == SET_ALCHEMY then
            return SET_NAME_ALCHEMY
        elseif setCount == SET_BLOOD then
            return SET_NAME_BLOOD
        elseif setCount == SET_CRYSTAL then
            return SET_NAME_CRYSTAL
        elseif setCount == SET_MECH then
            return SET_NAME_MECH
        elseif setCount == SET_MOON then
            return SET_NAME_MOON
        elseif setCount == SET_NATURE then
            return SET_NAME_NATURE
        elseif setCount == SET_RING then
            return SET_NAME_RING
        elseif setCount == SET_RUNE then
            return SET_NAME_RUNE
        elseif setCount == SET_WEAPON then
            return SET_NAME_WEAPON
        endif
        return ""
    endfunction
    
    function Mech_Logic takes item t returns boolean
        local integer cyclA = 1
        local integer cyclAEnd = udg_DB_SetItems_Num[1]
        local boolean l = false
        
        loop
            exitwhen cyclA > cyclAEnd
            if GetItemTypeId(t) == DB_SetItems[1][cyclA] then
                set l = true
                set cyclA = cyclAEnd
            endif
            set cyclA = cyclA + 1
        endloop
        set t = null
        return l
    endfunction

    function CristallLogic takes item t returns boolean
        local integer cyclA = 1
        local integer cyclAEnd = udg_DB_SetItems_Num[9]
        local boolean l = false
        
        loop
            exitwhen cyclA > cyclAEnd
            if GetItemTypeId(t) == DB_SetItems[9][cyclA] then
                set l = true
                set cyclA = cyclAEnd
            endif
            set cyclA = cyclA + 1
        endloop
        set t = null
        return l
    endfunction

    function BloodLogic takes item t returns boolean
        local integer cyclA = 1
        local integer cyclAEnd = udg_DB_SetItems_Num[4]
        local boolean l = false
        
        loop
            exitwhen cyclA > cyclAEnd
            if GetItemTypeId(t) == DB_SetItems[4][cyclA] then
                set l = true
                set cyclA = cyclAEnd
            endif
            set cyclA = cyclA + 1
        endloop
        set t = null
        return l
    endfunction

    function RuneLogic takes item t returns boolean
        local integer cyclA = 1
        local integer cyclAEnd = udg_DB_SetItems_Num[5]
        local boolean l = false
        
        loop
            exitwhen cyclA > cyclAEnd
            if GetItemTypeId(t) == DB_SetItems[5][cyclA] then
                set l = true
                set cyclA = cyclAEnd
            endif
            set cyclA = cyclA + 1
        endloop
        set t = null
        return l
    endfunction

    function MoonLogic takes item t returns boolean
        local integer cyclA = 1
        local integer cyclAEnd = udg_DB_SetItems_Num[6]
        local boolean l = false
        
        loop
            exitwhen cyclA > cyclAEnd
            if GetItemTypeId(t) == DB_SetItems[6][cyclA] then
                set l = true
                set cyclA = cyclAEnd
            endif
            set cyclA = cyclA + 1
        endloop
        set t = null
        return l
    endfunction

    function NatureLogic takes item t returns boolean
        local integer cyclA = 1
        local integer cyclAEnd = udg_DB_SetItems_Num[7]
        local boolean l = false
        
        loop
            exitwhen cyclA > cyclAEnd
            if GetItemTypeId(t) == DB_SetItems[7][cyclA] then
                set l = true
                set cyclA = cyclAEnd
            endif
            set cyclA = cyclA + 1
        endloop
        set t = null
        return l
    endfunction

    function AlchemyLogic takes item t returns boolean
        local integer cyclA = 1
        local integer cyclAEnd = udg_DB_SetItems_Num[8]
        local boolean l = false
        
        loop
            exitwhen cyclA > cyclAEnd
            if GetItemTypeId(t) == DB_SetItems[8][cyclA] then
                set l = true
                set cyclA = cyclAEnd
            endif
            set cyclA = cyclA + 1
        endloop
        set t = null
        return l
    endfunction

    function Weapon_Logic takes item t returns boolean
        local integer cyclA = 1
        local integer cyclAEnd = udg_DB_SetItems_Num[2]
        local boolean l = false
        
        loop
            exitwhen cyclA > cyclAEnd
            if GetItemTypeId(t) == DB_SetItems[2][cyclA] then
                set l = true
                set cyclA = cyclAEnd
            endif
            set cyclA = cyclA + 1
        endloop
        set t = null
        return l
    endfunction

    function Ring_Logic takes item t returns boolean
        local integer cyclA = 1
        local integer cyclAEnd = udg_DB_SetItems_Num[3]
        local boolean l = false
        
        loop
            exitwhen cyclA > cyclAEnd
            if GetItemTypeId(t) == DB_SetItems[3][cyclA] then
                set l = true
                set cyclA = cyclAEnd
            endif
            set cyclA = cyclA + 1
        endloop
        set t = null
        return l
    endfunction
    
    public function CheckItemSet takes item checkedItem, integer setCount returns boolean
        local boolean isCheckTrue = false
        if setCount == SET_ALCHEMY then
            set isCheckTrue = AlchemyLogic(checkedItem)
        elseif setCount == SET_BLOOD then
            set isCheckTrue = BloodLogic(checkedItem)
        elseif setCount == SET_CRYSTAL then
            set isCheckTrue = CristallLogic(checkedItem)
        elseif setCount == SET_MECH then
            set isCheckTrue = Mech_Logic(checkedItem)
        elseif setCount == SET_MOON then
            set isCheckTrue = MoonLogic(checkedItem)
        elseif setCount == SET_NATURE then
            set isCheckTrue = NatureLogic(checkedItem)
        elseif setCount == SET_RING then
            set isCheckTrue = Ring_Logic(checkedItem)
        elseif setCount == SET_RUNE then
            set isCheckTrue = RuneLogic(checkedItem)
        elseif setCount == SET_WEAPON then
            set isCheckTrue = Weapon_Logic(checkedItem)
        endif
        set checkedItem = null
        return isCheckTrue
    endfunction
endlibrary


