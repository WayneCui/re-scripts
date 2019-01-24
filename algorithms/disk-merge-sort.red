Red [
    Title: "Disk Merge Sort"
    Purpose: {See: https://mp.weixin.qq.com/s/fiHTFsnJNDoAe4GfLOtasg}
]

generate-files: function [ n [integer!] min-entries [integer!] max-entries [integer!]][
    files: copy []
    repeat i n [
        file-name: rejoin ["input-" i ".txt"]
        entries: to-integer ((random 1.0) * (max-entries - min-entries) + 5)
        tmp: copy []
        repeat k entries [
            append tmp random 10000000
        ]
        write/lines to-file file-name sort tmp
        append files file-name
    ]

    files
]

prepare: function [files][
    bins: copy []
    foreach file-name files [
        f: make-source file-name
        append/only bins reduce [f f/get-next] 
    ]

    sort/compare bins function [a b] [a/2 < b/2]
    bins
]

source-obj: make object! [
    file-name: NONE
    buf: copy []
    postion: 0
    cached-line: NONE
    exhausted: false
    has-next: function [ ][
        either self/exhausted [
            false
        ] [
            either empty? self/buf [
                print "re-read"
                err: error? try [ self/buf: read/lines/seek/part (to-file file-name) postion (500 * 3)]
                if err [
                    self/exhausted: true
                    return false
                ]
                return not (empty? self/buf)
            ] [
                true
            ]
        ]
    ]

    get-next: function [ ][
        if empty? self/buf [
            self/buf: read/lines/seek/part (to-file file-name) self/postion (500 * 3)
            self/postion: self/postion + 500
        ]

        cached-line: first self/buf
        ; probe cached-line
        self/buf: next self/buf
        either empty? trim cached-line [
            trim cached-line
        ][
            to-integer trim cached-line
        ]

        ; to-integer trim cached-line
    ]
]

make-source: function [ name [string!]][
    obj: make source-obj [ file-name: name ]
]

output: function [ bin ][
    out-file: %output.txt
    write/append/lines to file! out-file bin/2
]

binary-search: function [ bins [block!] bin [block!]][
    low: 1
    high: (length? bins)

    while [ low <= high ] [
        mid: (low + high) >>> 1
        ; mid: (high - low) / 2 + low
        mid-val: bins/(mid)

        case [
            mid-val/2 < bin/2 [ low: mid + 1]
            mid-val/2 > bin/2 [ high: mid - 1]
            mid-val/2 = bin/2 [ return mid ] ; key found
        ]
    ]

    negate (low) ; key not found
]

merge-sort: function [ bins ][
    probe-bins bins
    while [ true ] [
        probe-bins bins
        current: first first bins 
        either current/has-next [
            new-bin: reduce [ current current/get-next ]
            index: binary-search bins new-bin
            probe index

            either (index = 1) [
                output new-bin
            ][
                if index <= 0 [
                    index: absolute index
                    insert/only at bins index new-bin

                    ; output
                    min-bin: first bins
                    probe min-bin/2
                    remove bins
                    output min-bin
                ]
            ]
        ] [
            min-bin: first bins
            remove bins
            output min-bin

            if empty? bins [
                break
            ]
        ]
    ]
]

probe-bins: function [ bins ][
    print "probe-bins"
    print collect [
        foreach bin bins [
            keep bin/1/file-name
            keep bin/2
        ]
    ]
]


; test
comment [
    file-name: "input-1.txt"
    s-obj: make-source file-name
    probe s-obj/get-next
    probe s-obj/get-next
]

files: generate-files 2 5 10
bins: prepare files
probe-bins bins
merge-sort bins


