Red [
    Title: "merge-sort"
]

merge-sort: function [list [block!]][
    if (empty? list) or ((length? list) = 1) [
        return list
    ]

    sort-internal list 1 length? list
    list
]

sort-internal: function [ list [block!] low [integer!] high [integer!]][
    if low >= high [ return none ]

    mid: ( low + high ) / 2
    sort-internal list low mid
    sort-internal list (mid + 1) high
    merge list low mid high
]

merge: function [ list [block!] low [integer!] mid [integer!] high [integer!]][
    i: low
    j: mid + 1
    tmp: copy []
    while [(i <= mid) and (j <= high)] [
        either list/(i) < list/(j) [
            append tmp list/(i)
            i: i + 1
        ][
            append tmp list/(j)
            j: j + 1
        ]
    ]

    either j <= high [
        start: j
        end: high
    ][
        start: i
        end: mid
    ]

    while [start <= end] [
        append tmp list/(start)
        start: start + 1
    ]

    repeat m (high - low + 1) [
        list/(low + m - 1): tmp/(m)
    ]
]

swap: function [list [block!] a [integer!] b[integer!]][
    tmp: list/(a)
    list/(a): list/(b)
    list/(b): tmp
]


probe merge-sort [] ;[]
probe merge-sort [1] ;[1]
probe merge-sort [2 1] ;[1 2]
probe merge-sort [3 5 6 7 8] ;[3 5 6 7 8]
probe merge-sort [2 2 2 2] ;[2 2 2 2]
probe merge-sort [4 3 2 1] ;[1 2 3 4]
probe merge-sort [5 -1 9 3 7 8 3 -2 9] ;[-2 -1 3 3 5 7 8 9 9]