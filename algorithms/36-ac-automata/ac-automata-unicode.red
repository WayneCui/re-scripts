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
    make ac-node [ data: v children: make map! []]
]

; alpha-index?: function [ char [char! string!]][
;     (to-integer to-char char) + 1
; ]

new-ac-trie: function [][
    make object! [
        root: new-ac-node "/"

        insert: function [ text [string!]][
            node: self/root
            foreach char text [
                if not node/children/(char) [
                    node/children/(char): new-ac-node to-string char
                ]

                node: node/children/(char)
            ]

            node/is-ending-char: true
            node/length: length? text
        ]

        build-failure-pointer: function [ ][
            root: self/root
            queue: copy []
            append queue root
            
            while [ not empty? queue ] [
                p: take queue
                
                foreach pc values-of p/children [
                    if none? pc [ continue ]
                    either p = root [
                        pc/fail: root
                    ][
                        q: p/fail
                        while [ not none? q] [
                            qc: q/children/(to-char pc/data)
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
                    char: text/(i)
                    while [ (none? p/children/(char)) and (not p = root) ] [
                        p: p/fail
                    ]

                    p: p/children/(char)
                    if none? p [
                        p: self/root
                    ]

                    tmp: p
                    while [not (tmp = root)] [
                        if tmp/is-ending-char = true [
                            pos: i - tmp/length + 1
                            print rejoin [" 匹配起始下标：" pos "; 长度：" tmp/length]
                            ;keep pos keep  tmp/length
                            keep copy/part at text pos tmp/length
                        ]

                        tmp: tmp/fail
                    ]
                ]
            ]
            
        ]
    ]
]

automata-2: new-ac-trie
patterns: ["Fxtec Pro1" "谷歌Pixel" ]
foreach pattern patterns [
    automata-2/insert pattern
]

automata-2/build-failure-pointer

text: "一家总部位于伦敦的公司Fxtex在MWC上就推出了一款名为Fxtec Pro1的手机，该机最大的亮点就是采用了侧滑式全键盘设计。DxOMark年度总榜发布 华为P20 Pro/谷歌Pixel 3争冠"

result: automata-2/match text
probe result