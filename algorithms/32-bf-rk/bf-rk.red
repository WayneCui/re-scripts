Red [
    Title: "string matching"
]

do %../utils.red

bf: function [ 
    {brute force}
    main [string!]  "main string"
    pattern [string!] "pattern string"
][
    n: length? main
    m: length? pattern

    if n < m [ return -1 ]

    repeat i ( n - m + 1) [
        repeat j m [
            either main/(i + j - 1) = pattern/(j) [
                either j = m [
                    return i
                ][
                    continue
                ]
            ][
                break
            ]
        ]
    ]

    return -1
]

; bf "abcdefg" "a"

bf-parse: function [ 
    {brute force}
    main [string!]  "main string"
    pattern [string!] "pattern string"
][
    n: length? main
    m: length? pattern

    if n < m [ return -1 ]

    repeat i ( n - m + 1) [
        ; repeat j m [
        ;     either main/(i + j - 1) = pattern/(j) [
        ;         either j = m [
        ;             return i
        ;         ][
        ;             continue
        ;         ]
        ;     ][
        ;         break
        ;     ]
        ; ]
        if parse at main i [ pattern to end][
            return i
        ]
    ]

    return -1
]

rk: function [
    {brute force}
    main [string!]  "main string"
    pattern [string!] "pattern string"
][
    n: length? main
    m: length? pattern
    if n < m [ return -1 ]

    hash-p: simple-hash pattern
    hash-memo: copy []
    append hash-memo hash-1st: simple-hash/end main m
    if hash-1st = hash-p [
        if (copy/part main m) = pattern [
            return 1
        ]
    ]
    
    foreach i range/from (n - m + 1) 2 [
        append hash-memo hash-m: hash-memo/(i - 1) - (simple-hash to-string main/(i - 1)) + (simple-hash to-string main/(i + m - 1))
        ; probe hash-memo
        if hash-m = hash-p [
            either (copy/part at main i m) = pattern [
                return i
            ][
                continue
            ]
        ]
    ]

    -1
]

simple-hash: function [ str [string!] /start s [integer!] /end e [integer!]][
    ret: 0
    from: either start [ s ][ 1 ]
    to: either end [ e ][ length? str ]

    foreach i range/from to from [
        ret: ret + (to-integer to-binary str/(i))
    ] 

    ret
]

; probe rk "abcdefg" "cdex"
; probe simple-hash "cde"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
m-str: rejoin array/initial 10000 "a"
p-str: rejoin append array/initial 200 "a" "b"

print { time consume: }
t: now/time
print rejoin [ {[bf] result: } bf m-str p-str ]
print rejoin [ {[bf] time cost: } now/time - t ]

t: now/time
print rejoin [ {[bf-parse] result: } bf-parse m-str p-str ]
print rejoin [ {[bf-parse] time cost: } now/time - t ]

t: now/time
print rejoin [ {[rk] result: } rk m-str p-str ]
print rejoin [ {[rk] time cost: } now/time - t ]

print {--- search ---}
m-str: "thequickbrownfoxjumpsoverthelazydog"
p-str: "jump"
print rejoin [{[bf] result: } bf m-str p-str]
print rejoin [{[bf] result: } bf-parse m-str p-str]
print rejoin [{[rk] result: } rk m-str p-str]
