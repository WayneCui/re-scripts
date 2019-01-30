Red [
    Title: ""
]

bubble-sort: function [ list [block!] ][
    if empty? list [ return list ]

    repeat k ((length? list) - 1) [
        swap?: false
        repeat i ((length? list) - 1) [
            if list/(i) > list/(i + 1) [
                tmp: list/(i)
                list/(i): list/(i + 1)
                list/(i + 1): tmp

                swap?: true
            ]
        ]

        if not swap? [ break ]
    ]
    

    list
]

probe bubble-sort []
probe bubble-sort [1]
probe bubble-sort [3 1]
probe bubble-sort [4 5 6 3 2 1] ;[1 2 3 4 5 6]