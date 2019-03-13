Red [
    Title: "Depth-First Traversa"
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

        sorting-by-dsf: function [][
            inverse-adj: make map! []

            foreach w words-of self/adj [
                blk: self/adj/(w)
                if not empty? blk [
                    foreach v blk [
                        either find inverse-adj v [
                            append inverse-adj/(v) w
                        ][
                            inverse-adj/(v): reduce [ w ]
                        ]
                    ]
                ]
            ]

            ; probe inverse-adj

            vertexes: union words-of self/adj words-of inverse-adj
            visited: copy []
            
            ordered: copy []
            foreach w vertexes [
                if none? (find visited w) [
                    append visited w
                    self/dsf w inverse-adj visited ordered
                ]
            ]
        ]

        dsf: function [ w  inverse-adj visited ordered ][
            if none? inverse-adj/(w) [
                inverse-adj/(w): copy []
            ]
            
            foreach v inverse-adj/(w) [
                if find visited v [
                    continue
                ]

                append visited v
                self/dsf v inverse-adj visited ordered
            ]

            print rejoin ["-> " w]
            collect/into [ keep w] ordered
        ]
    ]
]

dag: new-graph
dag/add-edge 2 1
dag/add-edge 3 2
dag/add-edge 2 4
dag/add-edge 4 1
; probe dag/adj
probe dag/sorting-by-dsf


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
probe dag/sorting-by-dsf

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
probe reverse dag/sorting-by-dsf