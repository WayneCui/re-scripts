Red [
    Title: "Dijkstra algorithm"
    Desc: "See Grokking Algorithms"
]

infinity: 2147483647  ;(power 2 31) - 1

dijkstra: function [ graph start finish ][

    find-lowest-cost-node: function [ costs [map!] ][
        lowest-cost: infinity
        lowest-cost-node: none

        foreach node words-of costs [
            cost: costs/(node)
            if (cost < lowest-cost) and (none? find processed node) [
                lowest-cost: cost
                lowest-cost-node: node
            ]
        ]

        lowest-cost-node
    ]

    costs: make map! reduce [ finish infinity]
    parents: make map! reduce [ finish none ]

    foreach [point weight] graph/(start) [
        costs/(point): weight
        parents/(point): (start)
    ]

    processed: copy []

    node: find-lowest-cost-node costs
    while [ not none? node ] [
        cost: costs/(node)
        neighbors: graph/(node)

        foreach [ n w ] neighbors [
            new-cost: cost + neighbors/(n)
            case [
                none? costs/(n) [ costs/(n): new-cost parents/(n): node ]
                (costs/(n) > new-cost) [ costs/(n): new-cost parents/(n): node ]
                true []
            ]
        ]  
        append processed node
        node: find-lowest-cost-node costs
    ]

    parents
]

print-path: function [ parents [map!] start finish][
    blk: copy []
    node: finish
    until [
        insert blk node
        node: parents/(node)
        node = start
    ]
    
    insert blk 'start
    probe blk
]

graph: [ 
    start [ 
        a 6 
        b 2
    ] 
    a [
        fin 1
    ] 
    b [
        a 3 
        fin 5
    ] 
    fin [ ]
]

parents: dijkstra graph 'start 'fin 
print-path parents 'start 'fin ;[start b a fin]


graph: [ 
    start [ 
        a 5
        b 2
    ] 
    a [
        c 4
        d 2
    ] 
    b [
        a 8
        d 7
    ] 

    c [ 
        fin 3 
        d 6
    ]
    d [fin 1]
    fin [ ]
]

parents: dijkstra graph 'start 'fin 
print-path parents 'start 'fin  ;[start a d fin]

graph: [ 
    start [ 
        a 10
    ] 
    a [
        b 20
    ] 
    b [
        fin 30
        c 1
    ] 

    c [ 
        a 1
    ]
    fin [ ]
]

parents: dijkstra graph 'start 'fin
print-path parents 'start 'fin ;[start a b fin]