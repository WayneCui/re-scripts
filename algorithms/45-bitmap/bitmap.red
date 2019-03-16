Red [
    title: "bitmap.red"
]

do %../utils.red

bitmap: make object! [
    blk: copy []
    nbits: 0

    init: function[][
        self/blk: array/initial (self/nbits / 16 + 1) 0
    ]

    set: function [ k[integer!] ][
        if k > self/nbits [ return ]

        byte-index: k / 16 + 1
        bit-index: k // 16 + 1
        self/blk/(byte-index): self/blk/(byte-index) or (1 << bit-index)
    ]

    get: function [ k[integer!] ][
        if k > self/nbits [ return false ]
        byte-index: k / 16 + 1
        bit-index: k // 16 + 1

        return not equal? (self/blk/(byte-index) and ( 1 << bit-index)) 0
    ]
]

a-bitmap: make bitmap [
    blk: copy []
    nbits: 10
]

a-bitmap/init

probe a-bitmap/blk
a-bitmap/set 1
a-bitmap/set 3
a-bitmap/set 5
a-bitmap/set 7
a-bitmap/set 9

repeat i 10 [
    print a-bitmap/get i
] 