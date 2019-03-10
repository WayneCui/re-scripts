Red [
    Title: "Topological sorting"
]

do %../utils.red

graph: make object! [
    v: 0
    adj: none

    init: function [][
        self/adj: array/initial self/v copy []
    ]

    add-edge: function [ from  to ][
        append self/adj/(from) to
        probe self/adj
    ]

    sorting-by-kahn: function [][
        in-degree: array/initial self/v 0
        repeat i self/v [
            repeat j length? self/adj/(i) [
                to: self/adj/(i)/(j)
                in-degree/(to): in-degree/(to) + 1
            ]
        ]

        probe in-degree

        queue: copy []
        repeat i v [
            if in-degree/(i) = 0 [
                append queue i
            ]
        ]

        while [not empty? queue] [
            i: take queue
            print rejoin [ "->" i]
            repeat j length? self/adj/(i) [
                k: self/adj/(i)/(j)
                in-degree/(k): in-degree/(k) - 1
                if in-degree/(k) = 0 [
                    append queue k
                ]
            ]
        ]
    ]
]

dag: make graph [ v: 4 ]
dag/init
dag/add-edge 2 1
dag/add-edge 3 2
dag/add-edge 2 4
dag/add-edge 4 1
dag/sorting-by-kahn