function onRemoval takes unit u returns nothing
    call FlushChildHashtable( udg_hash, GetHandleId( u ) )
    set u = null
endfunction

hook RemoveUnit onRemoval