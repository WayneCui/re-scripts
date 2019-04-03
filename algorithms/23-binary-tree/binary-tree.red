Red [
    Title: "Binary tree"
]

TreeNode: make object! [
    val: none
    left: none
    right: none
]


pre-order: function [ root ][
    collect [
        if root [
            keep root/val
            keep pre-order root/left
            keep pre-order root/right
        ]
    ] 
]

in-order: function [ root ][
    collect [
        if root [
            keep in-order root/left
            keep root/val            
            keep in-order root/right
        ]
    ] 
]

post-order: function [ root ][
    collect [
        if root [
            keep post-order root/left
            keep post-order root/right
            keep root/val
        ]
    ]
]

layer-order: function [ root ][
    queue: copy []
    if root [ append queue root ]

    collect [
        while [not empty? queue] [
            node: take queue
            keep node/val
            if node/left [ append queue node/left ]
            if node/right [ append queue node/right ]
        ]
    ]
]


node1: make TreeNode [val: 'D]
node2: make TreeNode [val: 'E]
node3: make TreeNode [val: 'B left: node1 right: node2]
node4: make TreeNode [val: 'F]
node5: make TreeNode [val: 'G]
node6: make TreeNode [val: 'C left: node4 right: node5]
root: make TreeNode [val: 'A left: node3 right: node6]

probe pre-order root
probe in-order root
probe post-order root
probe layer-order root