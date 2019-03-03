Red [
    Title: "The longest common subsequence algorithm"
]

do %../utils.red

longest-common-subseq: function [ s1 [string!] s2 [string!]][
    m: length? s1
    n: length? s2  ;m x n
    memo: array/initial (m + 1) array/initial (n + 1) 0

    foreach i range/from (m + 1) 2 [
        foreach j range/from (n + 1) 2 [
            either s1/(i - 1) = s2/(j - 1) [
                memo/(i)/(j): memo/(i - 1)/(j - 1) + 1
            ][
                memo/(i)/(j): max memo/(i - 1)/(j) memo/(i)/(j - 1)
            ]
        ]
    ]

    probe memo
    memo/(m + 1)/(n + 1)
]

probe longest-common-subseq "blue" "clues" ;3
probe longest-common-subseq "fosh" "fish" ; 3
probe longest-common-subseq "fosh" "fort" ; 2
probe longest-common-subseq "hish" "fish" ; 3
probe longest-common-subseq "hish" "vista" ; 2
probe longest-common-subseq "mitcmu" "mtacnu" ; 4