** assumptions
    local rho .1
    local r01 .4
    local p .8

** yields
    local effect .3 // 30% increase in output
    foreach takeup in .3 .4 .5{
        local diluted = `effect' * `takeup'
        sampsi 0 `diluted', sd(1) r01(`r01') pre(1) post(1) p(`p') method(ancova)
        sampclus, numclus(300) rho(`rho')
    }

** adoption
    local effect .05
    sampsi 0 `effect', p(`p')
    sampclus, numclus(300) rho(`rho')
