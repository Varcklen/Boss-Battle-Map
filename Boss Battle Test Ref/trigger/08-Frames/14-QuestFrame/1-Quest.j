library Quest requires TextLib, SpecialEffect

    globals
        private constant string ANIMATION_COMPLETE = "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl"
    endglobals

    private function CompletedActions takes unit caster, integer questItemRawCode, integer rewardRawCode returns nothing
        local item questItem = GetItemOfTypeFromUnitBJ( caster, questItemRawCode)
    
        call textst( GetItemName(questItem) + " completed!", caster, 64, GetRandomReal( 45, 135 ), 12, 1.5 )
        call RemoveItem(questItem)
        call UnitAddItem(caster, CreateItem( rewardRawCode, GetUnitX(caster), GetUnitY(caster)))
        call PlaySpecialEffect(ANIMATION_COMPLETE, caster)
        set udg_QuestDone[GetUnitUserData(caster)] = true
        
        set questItem = null
        set caster = null
    endfunction
    
    public function QuestCondition takes unit caster, integer questItem, integer reward, integer currentCount, integer countNeeded returns boolean
        local boolean isCompleted = false
        
        if currentCount >= countNeeded then
            call CompletedActions(caster, questItem, reward)
            set isCompleted = true
        else
            call textst( "|c00ffffff " + I2S(currentCount) + "/" + I2S(countNeeded), caster, 64, GetRandomReal( 45, 135 ), 8, 1.5 )
        endif
        
        set caster = null
        return isCompleted
    endfunction

endlibrary