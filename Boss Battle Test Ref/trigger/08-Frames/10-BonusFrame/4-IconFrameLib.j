library IconFrameLib

globals
    framehandle array bonusframe
	framehandle array bnfrtlp
	framehandle array bonustxt
	framehandle array bonustxtnm
	real bnspos = 0
endglobals

function IconMax takes integer index returns nothing
    local integer k = index
    local boolean l
    local integer fix
    
    set udg_IconMax = index
    
    set l = false
    set fix = 0
    set bnspos = 0
    loop
        exitwhen l
        if fix > 10 then
            call BJDebugMsg("Function \"IconMax\" is not working correctly. Please report this to the developer.")
            set l = true
        elseif k > 8 then
            set bnspos = bnspos + 0.03
            set k = k - 8
        else
            set l = true
        endif
        set fix = fix + 1
    endloop
endfunction

function IconFrameDel takes string k returns nothing
    local integer cyclA
    local integer max = 0

    set cyclA = 1
    loop
        exitwhen cyclA > udg_IconLim
        if udg_IconKey[cyclA] == k then
            set udg_IconKey[cyclA] = ""
            call BlzFrameSetVisible(bonusframe[cyclA], false)
            set cyclA = udg_IconLim
        endif
        set cyclA = cyclA + 1
    endloop
    
    set cyclA = 1
    loop
        exitwhen cyclA > udg_IconLim
        if udg_IconKey[cyclA] != "" then
            set max = cyclA
        endif
        set cyclA = cyclA + 1
    endloop
    call IconMax(max)
endfunction

function StringSizeIconTool takes string s returns real
	return 0.04+(0.0003*StringLength(s))
endfunction

function IconFrame takes string k, string icon, string name, string tool returns nothing
    local integer cyclA
    local integer i = 0
    local boolean l = true
    local boolean n = false
    
    set cyclA = 1
    loop
        exitwhen cyclA > udg_IconLim
        if udg_IconKey[cyclA] == k then
            set i = cyclA
            set l = false
            set cyclA = udg_IconLim
        endif
        set cyclA = cyclA + 1
    endloop
    
    if l then
        set cyclA = 1
        loop
            exitwhen cyclA > udg_IconLim or n
            if udg_IconKey[cyclA] == "" then
                set n = true
                set i = cyclA
                set cyclA = udg_IconLim
            endif
            set cyclA = cyclA + 1
        endloop
        if n then
            call BlzFrameSetText( bonustxtnm[i], name ) 
            call BlzFrameSetText( bonustxt[i], tool )
            call BlzFrameSetSize( bnfrtlp[i], 0.35, StringSizeIconTool(tool))
            call BlzFrameSetTexture(bonusframe[i], icon, 0, true)
            call BlzFrameSetVisible(bonusframe[i], true)
            set udg_IconKey[i] = k
            
            if i > udg_IconMax then
                call IconMax(i)
            endif
        endif
    else
        call BlzFrameSetText( bonustxtnm[i], name ) 
        call BlzFrameSetText( bonustxt[i], tool )
        call BlzFrameSetSize( bnfrtlp[i], 0.35, StringSizeIconTool(tool))
        call BlzFrameSetTexture(bonusframe[i], icon, 0, true)
    endif
endfunction

function IconFrameReplaceDescription takes string keyWord, string newDescription returns nothing
    local integer i = 1
    local boolean end = false
    
    loop
        exitwhen i > udg_IconLim or end
        if keyWord == udg_IconKey[i] then
            call BlzFrameSetText( bonustxt[i], newDescription )
            call BlzFrameSetSize( bnfrtlp[i], 0.35, StringSizeIconTool(newDescription))
            set end = true
        endif
        set i = i + 1
    endloop
endfunction

function GetIconFrameNumberByKey takes string keyWord returns integer
    local integer i = 1
    
    loop
        exitwhen i > udg_IconLim
        if keyWord == udg_IconKey[i] then
            return i
        endif
        set i = i + 1
    endloop
    return -1
endfunction

endlibrary