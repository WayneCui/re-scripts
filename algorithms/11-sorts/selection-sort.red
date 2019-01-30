Red [
    Title: ""
]

selection-sort: function [ list [block!]][
    if empty? list [ return list ]

    len: length? list
    repeat i len [
        value: list/(i)
        idx: none
        repeat j (len - i) [
            if list/(j + i) < value [
                value: list/(j + i)
                idx: j + i
            ]
        ]

        if not none? idx [
            swap list i idx
        ]
    ]

    list
]
swap: function [list [block!] a [integer!] b[integer!]][
    tmp: list/(a)
    list/(a): list/(b)
    list/(b): tmp
]

probe selection-sort []
probe selection-sort [1]
probe selection-sort [3 1]
probe selection-sort [4 5 6 3 2 1] ;[1 2 3 4 5 6]