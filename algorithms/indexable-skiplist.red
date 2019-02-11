Red [
    Title: "indexable-skiplist"
    Desc: "translated from https://code.activestate.com/recipes/576930/"
    Author: "Wayne Cui"
]

log: function [arg][
    write/append/lines %out.txt arg
]

; rebol3 array function
array: function [
    "Makes and initializes a series of a given size."
    size [integer! block!] "Size or block of sizes for each dimension"
    /initial "Specify an initial value for all elements"
    value {Initial value (will be called each time if a function)}
][
    if block? size [
        if tail? rest: next size [rest: none]
        unless integer? set/any 'size first size [
            cause-error 'script 'expect-arg reduce ['array 'size type? :size]
        ]
    ]
    block: make block! size
    case [
        block? rest [
            loop size [block: insert/only block array/initial rest :value]
        ]
        series? :value [
            loop size [block: insert/only block copy/deep value]
        ]
        any-function? :value [
            loop size [block: insert/only block value]
        ]
        insert/dup block value size
    ]
    head block
]

; probe array 5
; probe array/initial 5 10

range: function [ max-val [integer!] /from from-value [integer!]][
    collect [
        either from [
            repeat i (max-val - from-value) [
                keep (from-value + i)
            ]
        ][
            repeat i max-val [
                keep i
            ]
        ]
    ]
]

lesser??: function [value1 value2][
    case [
        (value1 = 'End) and (value2 = 'End) [ return false ]
        value1 = 'End [ return false ]
        value2 = 'End [ return true  ]
        (value1 = 'HEAD) and (value2 = 'HEAD) [ return false ]
        value1 = 'HEAD [ return true ]
        value2 = 'HEAD [ return false  ]
        (not (value1 = 'End)) and (not (value2 = 'End)) [return lesser? value1 value2 ]
    ]
]

; probe range 10
; probe range/from 10 3

Node: make object! [
    value: next: width: none
]

;Sentinel object that always compares greater than another object
NIL: make Node [value: 'End next: copy [] width: copy []]  ;Singleton terminator node

; Sorted collection supporting O(lg n) insertion, removal, and lookup by rank.
indexable-skiplist: make object! [
    size: 0
    expected_size: 100
    maxlevels: to integer! (1 + log-2 expected_size)
    head: make Node [
        value: 'HEAD
        next: array/initial maxlevels NIL
        width:      array/initial maxlevels 1 
    ]

    len: function [][ self/size ]
    get-item: function [ i ][
        node: self/head
        i: i + 1
        foreach level reverse range self/maxlevels [
            while [node/(level) <= i] [
                i: i - node/width/(level)
                node: node/next/(level)
            ]
        ]

        return node/value
    ]

    ;find first node on each level where node.next[levels].value > value
    insert: function [ val ][
        log "107:args: value: ========================"
        log val
        chain: array self/maxlevels
        steps-at-level: array/initial maxlevels 0
        node: self/head
        log "line: 111=============================="
        log node
        foreach level reverse range self/maxlevels [
            log level
            log node/next/(level)/value
            log lesser?? node/next/(level)/value val
            while [ lesser?? node/next/(level)/value val ] [                
                steps-at-level/(level): steps-at-level/(level) + node/width/(level)
                log node/next/(level)
                node: node/next/(level)
            ]
            chain/(level): node
        ]

        ;insert a link to the newnode at each level
        d: random self/maxlevels   
        newnode: make Node [
            value: val 
            next: array d 
            width: array d
        ]

        log "newnode_//////////////////////////////////////////"
        log newnode
        steps: 0

        log "chain: ==========================================="
        log chain
       
        foreach level range d [
            prevnode: chain/(level)
            log "prevnode_//////////////////////////////////////////"
            log prevnode
            log "newnode_//////////////////////////////////////////"
            log newnode
            newnode/next/(level): prevnode/next/(level)
            prevnode/next/(level): newnode

            log "update_//////////////////////////////////////////"
            log prevnode
            log newnode

            newnode/width/(level): prevnode/width/(level) - steps
            prevnode/width/(level): steps + 1
            steps: steps + steps-at-level/(level)
        ]

        foreach level range/from (self/maxlevels - 1) d [
            chain/(level)/width/(level): chain/(level)/width/(level) + 1
        ]

        self/size: self/size + 1
    ]

    
    remove: function [ 
        "find first node on each level where node.next[levels].value >= value"
        value 
    ][
        chain: array/initial self/maxlevels none
        node: self/head

        foreach level reverse range self/maxlevels [
            while [ lesser?? node/next/(level)/value value ][
                node: node/next/(level)
            ]
            chain/(level): node
        ]

        if not (chain/1/next/1/value = value) [
            throw "Not Found"
        ]

        ;remove one link at each level
        d: length? chain/1/next/1/next
        foreach level range d [
            prevnode: chain/(level)
            prevnode/width/(level): prevnode/width/(level) + (prevnode/next/(level)/width/(level) - 1)
            prevnode/next/(level): prevnode/next/(level)/next/(level)
        ]

        foreach level range/from maxlevels d [
            chain/(level)/width/(level): chain/(level)/width/(level) - 1
        ]

        self/size: self/size - 1
    ]

    iter: function [ "Iterate over values in sorted order" ][
        node: self/head/next/1
        collect [
            while [not (node = NIL)] [
                keep node/value
                node: node/next/1
            ]
        ]
    ]
]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Demonstrate and test the IndexableSkiplist() collection class
demo: ["F" "O" "U" "R" "S" "Q" "U" "A" "R" "E"]
excluded: ["X" "Y"]

probe rejoin ["Building an indexable skiplist containing " rejoin demo ]
s: make indexable-skiplist [expected_size: length? demo]
random demo         ;shuffle
foreach char demo [
    s/insert char
    probe rejoin ["Adding: " char ", [" s/iter "], " s/len]
]

foreach char excluded [
    probe rejoin ["Attempting to remove: "  char " -->"]
    catch [
        s/remove char
    ]
]

probe s/len = length? demo
probe s/iter = sort demo

random demo   ;shuffle demo
foreach char demo [
    s/remove char
    probe rejoin ["Removing: " char ", [" s/iter "], " s/len]
]

probe s/iter = [] 
probe s/len = 0