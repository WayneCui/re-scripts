Red [
    Title: "Levenshtein Distance"
    Author: "Wayne"
]

do %../utils.red

ldist: function [ str1 [string!] str2 [string!]][
    n: length? str1 ;行
    m: length? str2 ;列

    memo: array/initial n array/initial m 0

    ;初始化第1行
    repeat k m [
        case [
            str1/1 = str2/(k) [ memo/1/(k): k - 1]
            k = 1 [ memo/1/(k): 1]
            true [ memo/1/(k): memo/1/(k - 1) + 1]
        ]
    ]

    ;初始化第1列
    repeat t n [
        case [
            str1/(t) = str2/(1) [ memo/(t)/1: t - 1]
            t = 1 [ memo/(t)/1: 1]
            true [ memo/(t)/1: memo/(t - 1)/1 + 1]
        ]
    ]
    
    foreach i range/from n 2 [
        foreach j range/from m 2 [
            either str1/(i) = str2/(j) [
                memo/(i)/(j): min? reduce [ memo/(i - 1)/(j) + 1 memo/(i)/(j - 1) + 1 memo/(i - 1)/(j - 1)]
            ][
                memo/(i)/(j): min? reduce [ memo/(i - 1)/(j) + 1  memo/(i)/(j - 1) + 1 memo/(i - 1)/(j - 1) + 1]
            ]
        ]
    ]

    probe memo
    memo/(i)/(j)
]



str1: "mitcmu"
str2: "mtacnu"
probe ldist str1 str2 ;3

str1: "kitten"
str2: "sitting"
probe ldist str1 str2 ;3

str1: "flaw"
str2: "lawn"
probe ldist str1 str2 ;2