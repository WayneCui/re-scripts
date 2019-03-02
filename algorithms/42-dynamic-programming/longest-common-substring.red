Red [
    Title: "longest-common-substring algorithms"
    Author: "Wayne"
    Desc: "from Grokking Algorithms"
]

do %../utils.red

longest-common-substring: function [ s1 [string!] s2 [string!]][
    m: length? s1
    n: length? s2  ;m x n
    memo: array/initial (m + 1) array/initial (n + 1) 0

    foreach i range/from (m + 1) 2 [
        foreach j range/from (n + 1) 2 [
            if s1/(i - 1) = s2/(j - 1) [
                memo/(i)/(j): memo/(i - 1)/(j - 1) + 1
            ]
        ]
    ]

    probe memo
    sort/compare memo function [b1 b2][
        sort b1 sort b2
        b1/(n + 1) < b2/(n + 1)
    ]

    memo/(m + 1)/(n + 1)
]

probe longest-common-substring "blue" "clues" ;3
probe longest-common-substring "fosh" "fish" ; 2
probe longest-common-substring "fosh" "fort" ; 2
probe longest-common-substring "hish" "fish" ; 3
probe longest-common-substring "hish" "vista" ; 2