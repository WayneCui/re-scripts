Red [
    Title: ""
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

range: function [ max-val [integer!] /from from-value [integer!] /reverse][
    blk: collect [
        either from [
            repeat i (max-val - from-value + 1) [
                keep (from-value + i - 1)
            ]
        ][
            repeat i max-val [
                keep i
            ]
        ]
    ]

    either reverse [ system/words/reverse blk ] [blk]
]

; range 7 
; range/reverse 7

assert: function [ conditions [block!]][
    unless do conditions [
        throw rejoin [ to-string conditions " is not meeted!" ] 
    ]

    print "valid"
]

; probe assert [ 1 > 0 ]
; probe assert [ 1 > 2 ]

log: function ['word[word!] value [any-type!]][
    probe rejoin [word ": " value]
]

; a: 1
; log a a


min?: function [blk [block!]][
    if empty? blk [ return none ]
    if (length? blk) = 1 [ return first blk ]
    tmp: first blk
    foreach item blk [
        tmp: min item tmp
    ]

    tmp
]

max?: function [blk [block!]][
    if empty? blk [ return none ]
    if (length? blk) = 1 [ return first blk ]
    tmp: first blk
    foreach item blk [
        tmp: max item tmp
    ]

    tmp
]
