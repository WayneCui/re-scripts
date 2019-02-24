Red [
    Title: "stations.red"
    Desc: "greedy algorithm from Grokking Algorithms"
    Author: "Wayne Cui"
]

states-needed: ["mt"  "wa"  "or"  "id"  "nv"  "ut"  "ca"  "az"]
final-stations: copy []
stations: [ 
    "kone" ["id"  "nv"  "ut"]
    "ktwo" ["wa"  "id"  "mt"]
    "kthree" ["or"  "nv"  "ca"]
    "kfour" ["nv"  "ut"] 
    "kfive" ["ca"  "az"]
]

while [not empty? states-needed] [
    best-station: none
    states-covered: copy []
    foreach [station states] stations [
        covered: intersect states-needed states
        if (length? covered) > (length? states-covered) [
            best-station: station
            states-covered: covered
        ]
    ]

    states-needed: difference states-needed states-covered
    unique append final-stations best-station
]

probe final-stations ;["kone" "ktwo" "kthree" "kfive"]