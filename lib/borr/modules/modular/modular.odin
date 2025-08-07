package modular

import "core:fmt"
import "core:slice"

Module :: struct {
    name: string,
    init: proc(),
    unload: proc(),
    systems: []^System,
    state: rawptr
}

System :: struct {
    name: string,
    run: proc(),
    tags: []string,
    enabled: bool
}

app: []^Module

start :: proc() {
    for mod in app {
        if mod^.init == nil do continue
        mod^.init()
    }

    caller: ^System

    for mod in app do for sys in mod^.systems {
        if !slice.contains(sys.tags, "caller") do continue
        caller = sys
    }

    assert(caller != nil, "no system was tagged as caller")
    caller.run()
    
    for mod in app {
        if mod^.unload == nil do continue
        mod^.unload()
    }
}

