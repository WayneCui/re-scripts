Red [
    Title: "knapsack 0-1 problem"
    Author: "Wayne"
    Desc: "from Grokking Algorithms"
]

do %../utils.red

planning: function [ capacity [integer!] things [block!]][
    len: length? things
    memo: array/initial len array/initial capacity 0

    repeat i len [
        item: things/(i)
        repeat j capacity [
            cur-weight: either item/2 <= j [ item/2 ][ 0 ]

            last: either none? memo/(i - 1) [ 0 ][ memo/(i - 1)/(j) ]
            current: either item/2 <= j [ item/1 ][ 0 ]
            remainder: either (none? memo/(i - 1)) or ((j - cur-weight) <= 0) [ 0 ][ memo/(i - 1)/(j - cur-weight) ]
            memo/(i)/(j): max last (current + remainder)
        ]
    ]

    probe memo
    memo/(length? things)/(capacity)
]

;guarded by sentinel
planning-2: function [ capacity [integer!] things [block!]][
    len: length? things
    memo: array/initial (len + 1) array/initial capacity 0

    foreach i range/from (len + 1) 2 [
        item: things/(i - 1)
        foreach j range capacity [
            cur-weight: either item/2 <= j [ item/2 ][ 0 ]

            last: memo/(i - 1)/(j)
            current: either item/2 <= j [ item/1 ][ 0 ]
            remainder: either item/2 < j [ memo/(i - 1)/(j - cur-weight) ][ 0 ]
            memo/(i)/(j): max last (current + remainder)
        ]
    ]

    probe memo
    memo/(len + 1)/(capacity)
]

capacity: 4
things: [
    [1500 1]
    [3000 4]
    [2000 3]
    [2000 1]
]

probe (planning capacity random things) = 4000
probe (planning-2 capacity random things) = 4000