Red [
    Title: "Dijkstra algorithm with priority queue"
]

do %../simple-priority-queue.red

max-int: 2147483647  ;(power 2 31) - 1

Edge: make object! [
    sid: tid: none
    weight: 0
]

Vertex: make object! [
    id: none
    dist: 0
]

graph: make object! [
    adj: none
    v: 0

    init: function [][
        self/adj: array/initial self/v copy []
    ]

    add-edge: function [ s t w ][
        append self/adj/(s) make Edge [sid: s tid: t weight: w]
    ]

    dijkstra: function [ s t ][
        v: self/v
        predecessor: array/initial v 0
        vertexes: collect [
            repeat i v [
                keep make Vertex [ id: i dist: max-int ]
            ]
        ]

        pqueue: make priority-queue [ 
            comparator: function [v1 v2][
                v1/dist - v2/dist
            ]

            update: function [ node ][
                foreach nd self/queue [
                    if nd/id = node/id [
                        nd/dist = node/dist
                        self/heapify
                        break
                    ]
                ]
            ]
        ]
        pqueue/init v
        inqueue: array/initial v false

        vertexes/(s)/dist: 0
        pqueue/add vertexes/(s)
        inqueue/(s): true

        while [not pqueue/is-empty] [
            min-vertex: pqueue/poll
            if min-vertex/id = t [
                break
            ]

            foreach e adj/(min-vertex/id) [
                next-vertex: vertexes/(e/tid)

                if min-vertex/dist + e/weight < next-vertex/dist [
                    next-vertex/dist: min-vertex/dist + e/weight
                    predecessor/(next-vertex/id): min-vertex/id

                    either inqueue/(next-vertex/id) [
                        pqueue/update next-vertex
                    ][
                        pqueue/add next-vertex
                        inqueue/(next-vertex/id): true
                    ]   
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

a-graph: make graph [ v: 10 ]
a-graph/init
a-graph/add-edge 1 2 60
a-graph/add-edge 1 3 20
a-graph/add-edge 2 4 10
a-graph/add-edge 3 2 30
a-graph/add-edge 3 4 50
a-graph/dijkstra 1 4

a-graph: make graph [ v: 10 ]
a-graph/init
a-graph/add-edge 1 2 10
a-graph/add-edge 2 3 20
a-graph/add-edge 3 5 30
a-graph/add-edge 3 4 1
a-graph/add-edge 4 2 1
a-graph/dijkstra 1 5
