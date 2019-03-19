Red [
    Title: "simple-priority-queue.red"
]

do %utils.red

priority-queue: make object! [
    queue: none
    count: 0    ;the number of elements in the priority queue.
    comparator: function [a b][
        case [
            a > b [1]
            a = b [0]
            a < b [-1]
        ]
    ]

    init: function [ v ][
        self/queue: array/initial v none
        self/count: 0
    ]

    poll: function [][
        if zero? self/count [
            return none
        ]

        s: self/count
        self/count: self/count - 1
        result: first queue

        x: self/queue/(s)
        self/queue/(s): none

        if not zero? s [
            self/sift-down 1 x
        ]
        result
    ]

    add: function [ e ][
        if none? e [ throw "none value!"]
        i: self/count
        self/count: self/count + 1
        either zero? i [
            self/queue/1: e
        ][
            sift-up (i + 1) e
        ]

        true
    ]

    update: function [ 'old 'new ][
        if find self/queue old [
            idx: index? find self/queue old
            self/queue/(idx): new
            self/heapify
        ]
    ]

    is-empty: function [][
        zero? self/count
    ]

    sift-up: function [k [integer!] x ][
        while [ k > 1] [
            parent: k >>> 1
            e: self/queue/(parent)

            if (comparator x e) >= 0 [
                break
            ]
            
            self/queue/(k): e
            k: parent
        ]

        queue/(k): x
    ]

    sift-down: function [ k [integer!] x ][ 
        half: self/count >>> 1
        while [ k < half ] [
            child: k << 1
            c: self/queue/(child)
            right: child + 1
            if (right < self/count) and ((comparator c self/queue/(right)) > 0) [
                child: right
                c: self/queue/(child)
            ]

            if (comparator x c) < 0 [
                break
            ]

            self/queue/(k): c
            k: child
        ]

        self/queue/(k): x
    ]

    heapify: function [][
        i: self/count >>> 1
        while [i >= 1][
            self/sift-down i self/queue/(i)
            i: i - 1
        ]
    ]
]

a-pqueue: make priority-queue []
a-pqueue/init 10
a-pqueue/add 'd
a-pqueue/add 'a
a-pqueue/add 'e
a-pqueue/add 'c
a-pqueue/add 'b
a-pqueue/add 'f
probe a-pqueue/queue

a-pqueue/update 'a 'x
probe a-pqueue/queue

a-pqueue/poll
a-pqueue/poll
probe a-pqueue/queue