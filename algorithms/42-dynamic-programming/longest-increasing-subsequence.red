Red [
    Title: "The longest increasing subsequence algorithm"
    Desc: "Refer: https://leetcode.com/problems/longest-increasing-subsequence/solution/"
]

do %../utils.red

length-of-LIS: function [ nums [block!]][
    n: length? nums

    if n = 0 [ return 0 ]
    dp: array/initial n 0  ; dp/(i) 表示以 nums/(i) 结尾的序列的个数
    dp/1: 1
    maxans: 1
    foreach i range/from n 2 [
        maxval: 0
        foreach j range (i - 1) [
            if nums/(j) < nums/(i) [
                maxval: max maxval dp/(j)
            ]
        ]

        dp/(i): maxval + 1
        maxans: max maxans dp/(i)
    ]    

    maxans
]


blk-1: [10 9 2 5 3 7 101]
probe length-of-LIS blk-1  ;4

blk-2: [2 9 3 6 5 1 7]
probe length-of-LIS blk-2  ;4

blk-3: [0 8 4 12 2 10 6 14 1 9 5 13 3 11 7 15]
probe length-of-LIS blk-3  ;6