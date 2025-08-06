package modular

import "core:fmt"
import "core:slice"

Module :: struct {
    name: string,
    dependencies: []string,
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
    check_dependencies()

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

check_dependencies :: proc() {
    has: map[string]bool

    for mod in app do has[mod^.name] = true

    has_all := true
    for mod in app do for dep in mod^.dependencies do if !has[dep] {
        fmt.eprintf("app does not have dependency \"%s\" from module \"%s\"\n", dep, mod^.name)
        has_all = false
    }

    assert(has_all, "not all dependencies have been added")
}
