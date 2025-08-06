package modular

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
    for mod in app {
        if mod^.init == nil do continue
        mod^.init()
    }

    caller: ^System

    for mod in app do for sys in mod^.systems {
        if len(sys.tags) <= 0 do continue
        if sys.tags[0] != "caller" do continue
        caller = sys
    }

    caller.run()
    
    for mod in app {
        if mod^.unload == nil do continue
        mod^.unload()
    }
}
