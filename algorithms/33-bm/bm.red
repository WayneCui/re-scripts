Red [
    Title: "bm.red"
    Desc: {Boyer-Moore string-search algorithm. 
          See: http://www.cs.jhu.edu/~langmea/resources/lecture_notes/boyer_moore.pdf}
    Author: "Wayne Cui"
]

do %../utils.red

SIZE: 256

generate-bc-dict: function [ pattern [string!] ][
    bad-char-dict: array/initial SIZE 0

    foreach index range length? pattern [
        ascii: to-integer pattern/(index)
        bad-char-dict/(ascii): index
    ]

    bad-char-dict
]

generate-gs-dict: function [ pattern [string!] ][
    m: length? pattern
    suffix: array/initial m -1
    prefix: array/initial m false

    repeat i m - 1 [
        j: i
        len: 0
        while [(j >= 1) and (pattern/(j) = pattern/(m - len))] [
            j: j - 1
            len: len + 1
            suffix/(len + 1): j + 1 
        ]

        if j = 0 [ 
            prefix/(len + 1): true
        ]
    ]    
    
    reduce [suffix prefix]
]

move-by-gs: function [ 
    bc-index [integer!] {模式串中与坏字符对应的字符的下标}
    suffix [block!] 
    prefix [block!]
][
    m: length? suffix
    gs-len: m - bc-index ;好后缀长度

    if not (suffix/(gs-len + 1) = -1) [ return bc-index - suffix/(gs-len + 1) + 2 ]
    
    ;r is a index
    ;why bc-index + 2 ?
    ;because bc-index + 1 will be the whole suffix string
    foreach len range/reverse ( m - bc-index - 2) [
        if prefix/len = true [
            return m - len
        ]
    ]
    ; foreach r range/from m bc-index + 2 [
    ;     if prefix/(m - r + 1) = true [
    ;         return r - 1 ;m - (m - r + 1)
    ;     ]
    ; ]

    return m
]

find-by-bm: function [ main [string!] pattern [string!]][
    n: length? main
    m: length? pattern
    if n < m [ return -1 ]

    bad-char-dict: generate-bc-dict pattern
    gs-dict: generate-gs-dict pattern
    suffix: gs-dict/1
    prefix: gs-dict/2

    index: 1
    while [ index <= (n - m + 1)] [
        flag: 0
        foreach j range/reverse m [
            if not main/(index + j - 1) = pattern/(j) [
                break
            ]

            flag: flag + 1
        ]

        if flag = m [
            return index
        ]
        print "============================"

        ; advance index: bad-character rule
        bc: main/(index + j - 1)
        bc-step-len: j - bad-char-dict/(to-integer main/(index + j - 1))

        gs-step-len: 0
        if j < m [
            gs-step-len: move-by-gs j suffix prefix
        ]

        step: max bc-step-len gs-step-len
        log step step
        index: index + step
        
        log index index
        log main copy at main index 

    ]

    return -1
]


;;;;;;;;;;;;;;;;;;;;;;;;;;
s: "Here is a simple example"
pattern: "example"
; gs-dict: generate-gs-dict pattern
; probe gs-dict/1
; probe gs-dict/2
probe find-by-bm s pattern

s: "abcdcccdc"
pattern: "cccd"
print((index? find s pattern) = (find-by-bm s pattern))