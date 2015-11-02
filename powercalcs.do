** assumptions
    local rho .05
    local r01 .4
    local p .8

/* let's say 400 villages and 10 hh per village - about 4,000 households in total
    1. NMLR (135)
    2. DG (110)
    3. DG + self-efficacy (55)
    4. DG + risk (55)
    5. DG + self-efficacy + risk (55)
*/

** yields: compare NMLR vs DG (2/3 of villages are DG)
    local effect .3 // 30% increase in output
    foreach takeup in .35{
        local diluted = `effect' * `takeup'
        sampsi 0 `diluted', sd(1) r01(`r01') pre(1) post(1) p(`p') method(ancova) ratio(2)
        sampclus, numclus(400) rho(`rho')
    }

** adoption differential within DG (e.g. compare 2 vs 3-5)
    sampsi .4 .48, p(`p')
    sampclus, numclus(220) rho(`rho')

** self-efficacy within DG (e.g. compare 2 vs 3-5)
    sampsi 0 .14, sd(1) r01(`r01') pre(1) post(1) p(`p') method(ancova)
    sampclus, numclus(220) rho(`rho')
