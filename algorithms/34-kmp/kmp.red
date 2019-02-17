Red [
    Title: "KMP algorithm"
]

do %../utils.red

find-by-kmp: function [ s [string!] pattern [string!]][
    s-len: length? s
    p-len: length? pattern
    if s-len < p-len [ return none ]

    nexts: get-nexts pattern

    j: 1
    repeat i s-len [
        while [(j > 1) and not(s/(i) = pattern/(j))][
            j: nexts/(j - 1) + 1
        ]

        if s/(i) = pattern/(j) [
            if j = p-len [
                return at s i - p-len + 1
            ]
            j: j + 1
        ]
    ]

    return none
]

get-nexts: function [ pattern [string!]][
    m: length? pattern
    nexts: array/initial m 0

    foreach i range/from (m - 1) 2 [
        j: nexts/(i - 1)

        while [(not-equal? pattern/(j + 1) pattern/(i)) and (not-equal? j 0)][
            j: nexts/(j)
        ]

        if pattern/(j + 1) = pattern/(i) [
            j: j + 1
        ] 
        nexts/(i): j
    ]

    nexts
]

s: "aabbbbaaabbababbabbbabaaabb"
pattern: "abab"
print (find-by-kmp s pattern) = (find s pattern)

s: "aabbbbaaabbababbabbbabaaabb"
pattern: "ababacd"
print (find-by-kmp s pattern) = (find s pattern)

s: "abc abcdab abcdabcdabde"
pattern: "bcdabd"
print (find-by-kmp s pattern) = (find s pattern)

s: "hello"
pattern: "ll"
print (find-by-kmp s pattern) = (find s pattern)
