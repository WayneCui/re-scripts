Red [
    Title: "Huffman Code"
]

; 各个字符在字符串中出现的次数，即计算优先度
char-frequency: function [ str [string!]][
    d: copy []

    foreach char str [
        k: to string! char
        either none? d/(k) [
            append d reduce [k 1]
        ][
            d/(k): d/(k) + 1
        ]
    ]

    sort/skip/compare/reverse d 2 2
]

make-tree-node: function [ data [block!]][
    make object! [
        val: data/1
        priority: data/2
        left: none
        right: none
        code: copy ""
    ]
]


queue-obj: function [ freq-dict ][
    make-queue: function [ freq-dict [block!]][
        q: copy []
        foreach [k v] freq-dict [
            insert q make-tree-node reduce [k v]
        ]

        q
    ]

    make object! [
        queue: make-queue freq-dict
        size: length? self/queue

        add: function [ node ][
            self/queue: add-to-queue node

            self/size: self/size + 1
        ]

        pop: function [ ][
            self/size: self/size - 1
            take self/queue
        ]

        add-to-queue: function [ new-node ][
            if empty? self/queue [ return reduce [ new-node ] ]

            foreach node self/queue [
                if node/priority >= new-node/priority [
                    return head insert find self/queue node new-node
                ]
            ]

            append self/queue new-node
        ]
    ]
]

creat-huffman-tree: function [ node-q ][
    ; probe node-q 
    while [not (length? node-q/queue) = 1] [
        node-1: node-q/pop
        node-2: node-q/pop

        node: make-tree-node reduce [none node-1/priority + node-2/priority ]
        node/left: node-1
        node/right: node-2
        node-q/add node
    ]

    node-q/pop
]


dict1: make map! []
dict2: make map! []
huffman-code-dict: function [ tree x][
    if not none? tree [
        huffman-code-dict tree/left copy append x "0"
        append tree/code x

        if not not tree/val [
            dict2/(tree/code): tree/val
            dict1/(tree/val): tree/code
        ]
        huffman-code-dict tree/right copy append x "1"
    ]
]

encode: function [ str [string!]][
    transcode: copy ""
    foreach char str [
        append transcode dict1/(to-string char)
    ]

    transcode
]

decode: function[ encoded [string!]][
    code: copy ""
    ans: copy ""
    foreach ch encoded [
        append code ch
        if find dict2 code [
            append ans dict2/(code)
            code: copy ""
        ]
    ]

    ans
]

origin: "AAGGDCCCDDDGFBBBFFGGDDDDGGGEFFDDCCCCDDFGAAA"
; origin: "AAAAAAAAAAAAAAAGGGGGDCCCCCC"
probe char-frequency origin
htree: creat-huffman-tree queue-obj char-frequency origin
probe htree
huffman-code-dict htree copy ""

probe dict1
probe dict2

encoded: encode origin
probe encoded
decoded: decode encoded
probe decoded
print decoded = origin