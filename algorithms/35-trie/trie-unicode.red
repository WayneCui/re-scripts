Red [
    Title: "trie for unicode"
    Author: "Wayne Cui"
]

do %../utils.red

trie-node: make object! [
    data: none
    children: none
    is-ending-char: false
]

new-node: function [ v ][
    make trie-node [ data: v children: make map! []]
]

trie-tree-template: make object! [
    root: new-node "/"

    insert: function [ text [string!]][
        node: self/root
        foreach char text [
            if not node/children/(char) [
                node/children/(char): new-node to-string char
            ]

            node: node/children/(char)
        ]

        node/is-ending-char: true
    ]

    search: function [ pattern [string!]][
        node: self/root
        foreach char pattern [
            if not node/children/(char) [
                return false
            ]

            node: node/children/(char)
        ]

        node/is-ending-char
    ]
]

strs: ["how"  "hi"  "her"  "hello"  "so"  "see" "iPhone6 plus"  "K8s" "ChromeOS" "Docker" "华为"]

trie-tree: make trie-tree-template []
foreach str strs [
    trie-tree/insert str
]

blk: collect [
    foreach str strs [
        keep trie-tree/search str
    ]
]
probe (all blk) = true

to-find: ["he" "seen" "Java" "docker" "华"]

blk: collect [
    foreach s to-find [
        keep trie-tree/search s 
    ]
]

probe (any blk) = none

