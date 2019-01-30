Red [
    Title: ""
]

insertion-sort: function [ list [block!]][
    if empty? list [
        return list
    ]

    len: length? list
    repeat i (len - 1) [
        value: list/(i + 1)
        j: i
        while [ j >= 1 ] [
            either list/(j) > value [
                list/(j + 1): list/(j)
            ][
                break
            ]
            j: j - 1
        ]
        list/(j + 1): value
    ]

    list
]

probe insertion-sort []
probe insertion-sort [1]
probe insertion-sort [3 1]
probe insertion-sort [4 5 6 3 2 1] ;[1 2 3 4 5 6]