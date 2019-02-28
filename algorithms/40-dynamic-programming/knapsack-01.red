Red [
    Title: "knapsack 0-1 problem"
    Author: "Wayne"
    Desc: "from Grokking Algorithms"
]

do %../utils.red

planning: function [ capacity [integer!] things [block!]][
    memo: array/initial length? things array/initial capacity 0

    repeat i length? things [
        item: things/(i)
        repeat j capacity [
            cur-weight: either item/2 <= j [
                item/2
            ][
                0
            ]

            last: either none? memo/(i - 1) [ 0 ][ memo/(i - 1)/(j) ]
            current: either item/2 <= j [ item/1 ][ 0 ]
            remainder: either (none? memo/(i - 1)) or ((j - cur-weight) <= 0) [ 0 ][ memo/(i - 1)/(j - cur-weight) ]
            memo/(i)/(j): max last (current + remainder)
        ]
    ]

    probe memo
    memo/(length? things)/(capacity)
]

capacity: 4
things: [
    [1500 1]
    [3000 4]
    [2000 3]
    [2000 1]
]

probe (planning capacity random things) = 4000