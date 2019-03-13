Red [
    Title: "Topological sorting by kahn"
]

do %../utils.red

new-graph: function [][
    make object! [
        adj: make map! []

        add-edge: function [ from  to ][
            either none? find self/adj from [
                self/adj/(from):  copy reduce [ to ]
            ][
                append self/adj/(from) to
            ]
        ]

        sorting-by-kahn: function [][
            v: length? self/adj
            in-degree: make map! copy []
            foreach w words-of self/adj [
                if none? in-degree/(w) [
                    in-degree/(w): 0
                ]

                repeat j length? self/adj/(w) [
                    to: self/adj/(w)/(j)
                    either none? in-degree/(to) [
                        in-degree/(to): 1
                    ][
                        in-degree/(to): in-degree/(to) + 1
                    ]
                ]
            ]

            probe in-degree

            queue: copy []
            foreach w words-of in-degree [
                if in-degree/(w) = 0 [
                    append queue w
                ]
            ]

            ; probe queue

            collect [
                while [not empty? queue] [
                    i: take queue
                    ; print rejoin [ "->" i]
                    keep i

                    if not none? self/adj/(i) [
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
        ]
    ]
]

dag: new-graph
dag/add-edge 2 1
dag/add-edge 3 2
dag/add-edge 2 4
dag/add-edge 4 1
; probe dag/adj
probe dag/sorting-by-kahn


; example from https://en.wikipedia.org/wiki/Tsort
dag: new-graph
dag/add-edge 3 8
dag/add-edge 3 10
dag/add-edge 5 11
dag/add-edge 7 8
dag/add-edge 7 11
dag/add-edge 8 9
dag/add-edge 11 2
dag/add-edge 11 9
dag/add-edge 11 10
; probe dag/adj
probe dag/sorting-by-kahn

; example from https://en.wikipedia.org/wiki/Tsort
dag: new-graph
dag/add-edge 'main 'parse_options
dag/add-edge 'main 'tail_file
dag/add-edge 'main 'tail_forever
dag/add-edge 'tail_file 'pretty_name
dag/add-edge 'tail_file 'write_header
dag/add-edge 'tail_file 'tail
dag/add-edge 'tail_forever 'recheck
dag/add-edge 'tail_forever 'pretty_name
dag/add-edge 'tail_forever 'write_header
dag/add-edge 'tail_forever 'dump_remainder
dag/add-edge 'tail 'tail_lines
dag/add-edge 'tail 'tail_bytes
dag/add-edge 'tail_lines 'start_lines
dag/add-edge 'tail_lines 'dump_remainder
dag/add-edge 'tail_lines 'file_lines
dag/add-edge 'tail_lines 'pipe_lines
dag/add-edge 'tail_bytes 'xlseek
dag/add-edge 'tail_bytes 'start_bytes
dag/add-edge 'tail_bytes 'dump_remainder
dag/add-edge 'tail_bytes 'pipe_bytes
dag/add-edge 'file_lines 'dump_remainder
dag/add-edge 'recheck 'pretty_name
probe reverse dag/sorting-by-kahn