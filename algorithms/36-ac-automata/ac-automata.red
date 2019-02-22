Red [
    Title: "ac-automata.red"
    Author: "Wayne Cui"
    Desc: "Aho-Corasick Algorithm"
]

do %../utils.red

ac-node: make object! [
    data: none
    children: array/initial 128 none
    is-ending-char: false
    fail: none
    length: 0
]

new-ac-node: function [ v ][
    make ac-node [ data: v fail: none]
]

alpha-index?: function [ char [char! string!]][
    (to-integer to-char char) + 1
]

new-ac-trie: function [][
    make object! [
        root: new-ac-node "/"

        insert: function [ text [string!]][
            node: self/root
            foreach char text [
                index: alpha-index? char
                if not node/children/(index) [
                    node/children/(index): new-ac-node to-string char
                ]

                node: node/children/(index)
            ]

            node/is-ending-char: true
            node/length: length? text
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

        build-failure-pointer: function [ ][
            root: self/root
            queue: copy []
            append queue root
            
            while [ not empty? queue ] [
                p: take queue
                
                foreach pc p/children [
                    if none? pc [ continue ]
                    either p = root [
                        pc/fail: root
                    ][
                        q: p/fail
                        while [ not none? q] [
                            qc: q/children/(alpha-index? pc/data)
                            if not none? qc [
                                pc/fail: qc
                                break
                            ]

                            q: q/fail
                        ]
                        
                        if none? q [
                            pc/fail: root
                        ]
                    ]

                    append queue pc
                ]
            ]
        ]

        match: function [ text [string!]][
            n: length? text
            p: self/root

            collect[
                repeat i n [
                    idx: alpha-index? text/(i)
                    while [ (none? p/children/(idx)) and (not p = root) ] [
                        p: p/fail
                    ]

                    p: p/children/(idx)
                    if none? p [
                        p: self/root
                    ]

                    tmp: p
                    while [not (tmp = root)] [
                        if tmp/is-ending-char = true [
                            pos: i - tmp/length + 1
                            print rejoin [" 匹配起始下标：" pos "; 长度：" tmp/length]
                            keep pos keep  tmp/length
                        ]

                        tmp: tmp/fail
                    ]
                ]
            ]
            
        ]
    ]
]


automata-1: new-ac-trie
patterns: ["at" "art" "oars" "soar"]
foreach pattern patterns [
    automata-1/insert pattern
]

automata-1/build-failure-pointer
automata-1/match "soarsoars"

print "========================="

automata-2: new-ac-trie
patterns: ["fuck" "shit" "tmd"]
foreach pattern patterns [
    automata-2/insert pattern
]

automata-2/build-failure-pointer

result: automata-2/match a: "fuck you what is that shit tmd"
probe result = collect [ 
    parse a [ 
        some [
            t: "fuck"  (keep (index? t) keep 4) | 
            t: "shit" (keep (index? t) keep 4) | 
            t: "tmd"  (keep (index? t) keep 3) | 
            skip]
        ]
]

;collect [parse a [ some [t: "fuck"  (print (index? t)) | t: "shit" (print (index? t)) | t: "tmd"  (print (index? t) ) | skip]]]