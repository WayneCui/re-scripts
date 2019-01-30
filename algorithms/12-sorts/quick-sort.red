Red [
    Title: "quick-sort"
]

quick-sort: function [ list [block!] ][
    if (empty? list) or ((length? list) = 1)[
        return list
    ]
    sort-internally list 1 length? list
    list
]

sort-internally: function [ list [block!] low [integer!] high [integer!]][
    if low >= high [ return none ]

    flag: partition list low high
    sort-internally list low (flag - 1)
    sort-internally list (flag + 1) high
]

partition: function [list [block!] low [integer!] high [integer!]][
    pivot: list/(high)
    flag: low
    repeat k (high - low) [
        j: k + low - 1
        if list/(j) < pivot [
            swap list flag j
            flag: flag + 1
        ]
    ]

    swap list flag high
    flag
]

swap: function [list [block!] a [integer!] b[integer!]][
    tmp: list/(a)
    list/(a): list/(b)
    list/(b): tmp
]


probe quick-sort [] ;[]
probe quick-sort [1] ;[1]
probe quick-sort [2 1] ;[1 2]
probe quick-sort [3 5 6 7 8] ;[3 5 6 7 8]
probe quick-sort [2 2 2 2] ;[2 2 2 2]
probe quick-sort [4 3 2 1] ;[1 2 3 4]
probe quick-sort [5 -1 9 3 7 8 3 -2 9] ;[-2 -1 3 3 5 7 8 9 9]