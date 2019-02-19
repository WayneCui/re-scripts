Red [
    Title: "trie.red"
    Author: "Wayne Cui"
]

do %../utils.red

trie-node: make object! [
    data: none
    children: array/initial 27 none
    is-ending-char: false
]

new-node: function [ v ][
    make trie-node [ data: v ]
]

trie-tree-template: make object! [
    root: new-node "/"

    insert: function [ text [string!]][
        node: self/root
        foreach char text [
            index: to-integer char - to-integer #"a" + 1
            if not node/children/(index) [
                node/children/(index): new-node to-string char
            ]

            node: node/children/(index)
        ]

        node/is-ending-char: true
    ]

    search: function [ pattern [string!]][
        node: self/root
        foreach char pattern [
            index: to-integer char - to-integer #"a" + 1
            if not node/children/(index) [
                return false
            ]

            node: node/children/(index)
        ]

        node/is-ending-char
    ]
]

strs: ["how"  "hi"  "her"  "hello"  "so"  "see"]
trie-tree: make trie-tree-template []
foreach str strs [
    trie-tree/insert str
]

foreach str strs [
    print trie-tree/search str
]

print trie-tree/search "he"
print trie-tree/search "seen"
