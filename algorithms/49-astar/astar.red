Red [
    Title: "A* algorithms"
]

do %../28-heap/simple-priority-queue.red

max-int: 2147483647  ;(power 2 31) - 1

Edge: make object! [
    sid: tid: none
    weight: 0
]

Vertex: make object! [
    id: none
    x: 0
    y: 0
    f: max-int
    dist: max-int
]

graph: make object! [
    adj: none
    v: 0
    vertexes: none

    init: function [][
        self/adj: array/initial self/v copy []
        self/vertexes: array/initial self/v none
    ]

    add-edge: function [ s t w ][
        ; probe s
        append self/adj/(s) make Edge [sid: s tid: t weight: w]
    ]

    add-vertex: function [ vid vx vy][
        self/vertexes/(vid): make Vertex [ id: vid x: vx y: vy]
    ]

    h-manhattan: function [ v1 v2 ][
        absolute (v1/x - v2/x) + absolute (v1/y - v2/y)
    ]

    a*: function [ s t ][
        vertexes: self/vertexes
        v: self/v
        predecessor: array/initial v 0
        
        pqueue: make priority-queue [ 
            comparator: function [v1 v2][
                v1/f - v2/f
            ]

            update: function [ node ][
                foreach nd self/queue [
                    if nd/id = node/id [
                        nd/f = node/f
                        self/heapify
                        break
                    ]
                ]
            ]
        ]
        pqueue/init v
        inqueue: array/initial v false

        ; probe vertexes
        ; probe s
        ; probe vertexes/(s)
        vertexes/(s)/dist: 0
        vertexes/(s)/f: 0
        pqueue/add vertexes/(s)
        inqueue/(s): true

        while [not pqueue/is-empty] [
            min-vertex: pqueue/poll

            foreach e adj/(min-vertex/id) [
                next-vertex: vertexes/(e/tid)

                if min-vertex/dist + e/weight < next-vertex/dist [
                    next-vertex/dist: min-vertex/dist + e/weight
                    next-vertex/f: next-vertex/dist + (h-manhattan next-vertex vertexes/(t))
                    predecessor/(next-vertex/id): min-vertex/id

                    either inqueue/(next-vertex/id) [
                        pqueue/update next-vertex
                    ][
                        pqueue/add next-vertex
                        inqueue/(next-vertex/id): true
                    ]   
                ]

                if next-vertex/id = t [
                    pqueue/clear
                    break
                ]
            ] 
        ]

        print rejoin ["-> " s] 
        print-path s t predecessor

    ]

    print-path: function [s t predecessor][
        if not s = t [ 
            print-path s predecessor/(t) predecessor
            print rejoin ["-> " t] 
        ]
    ]
]


a-graph: make graph [ v: 20 ]
a-graph/init
a-graph/add-edge 1 2 20
a-graph/add-edge 2 3 20
a-graph/add-edge 3 4 10
a-graph/add-edge 4 13 40
a-graph/add-edge 4 14 30
a-graph/add-edge 1 6 60
a-graph/add-edge 6 11 50
a-graph/add-edge 1 5 60
a-graph/add-edge 1 7 60
a-graph/add-edge 7 14 50
a-graph/add-edge 7 8 70
a-graph/add-edge 8 12 50
a-graph/add-edge 6 9 70
a-graph/add-edge 6 10 80
a-graph/add-edge 9 10 50
a-graph/add-edge 10 11 60
a-graph/add-edge 12 11 60
a-graph/add-edge 5 13 40
a-graph/add-edge 5 9 50

a-graph/add-vertex 1 320 630
a-graph/add-vertex 2 300 630
a-graph/add-vertex 3 280 625
a-graph/add-vertex 4 270 630 
a-graph/add-vertex 5 320 700
a-graph/add-vertex 6 360 620
a-graph/add-vertex 7 320 590
a-graph/add-vertex 8 370 580
a-graph/add-vertex 9 350 730
a-graph/add-vertex 10 390 690
a-graph/add-vertex 11 400 620
a-graph/add-vertex 12 400 590
a-graph/add-vertex 13 270 700
a-graph/add-vertex 14 270 590

a-graph/a* 1 11