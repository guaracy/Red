Red [
    Title: "Maze generator"
    Date: 25-Aug-2020
    Author: @guaracy
    File: %maze.red
    Purpouse: {
        An implementation of maze generation using Binary Tree algorithm
        You get a block of strings in maze/maze where w = wall and p = path
        Source: weblog.jamisbuck.org/2011/2/1/maze-generation-binary-tree-algorithm.html
    }
    
    ]

ctx-maze: context [

    width: none
    height: none
    method: 'rb
    ; 'rb = recursive backtracker
    ; 'bt = binary tree
    ; 'sw = sidewinder
    weight: 2
    random/seed now/time/precise

    grid: none
    maze: none

    set [N S E W] [1 2 4 8]

    DX:       #(E: 1 W: -1 N:  0 S: 0)
    DY:       #(E: 0 W:  0 N: -1 S: 1)
    OPPOSITE: #(E: 8 W:  4 N:  2 S: 1)

    ;; http://weblog.jamisbuck.org/2010/12/27/maze-generation-recursive-backtracking
    recursive-backtracker: func[cx cy /local nx ny directions][
        directions: random copy [n s e w]
        foreach direction directions [
            nx: cx + DX/:direction
            ny: cy + DY/:direction
            if all [(ny >= 1) (ny <= height) (nx >= 1) (nx <= width) (grid/:ny/:nx = 0)][
                grid/:cy/:cx: grid/:cy/:cx or get direction
                grid/:ny/:nx: grid/:ny/:nx or OPPOSITE/:direction
                recursive-backtracker nx ny
            ]
        ]
    ]

    ;; http://weblog.jamisbuck.org/2011/2/1/maze-generation-binary-tree-algorithm.html
    binary-tree: does [
        repeat y height [
            repeat x width [
                dirs: copy []
                if y > 1 [append dirs [N]]
                if x > 1 [append dirs [W]]
                if direction: random/only dirs [
                    nx: x + DX/:direction
                    ny: y + DY/:direction
                    grid/:ny/:nx: grid/:ny/:nx or OPPOSITE/:direction
                ]
            ]
        ]
    ]

    ;; http://weblog.jamisbuck.org/2011/2/3/maze-generation-sidewinder-algorithm.html
    sidewinder: does [
        repeat y height [
            run-start: 1
            repeat x width [
                either (y > 1) and ((x = width) or ((random weight) = 1)) [
                    cell: run-start + random(x - run-start)
                    grid/(y)/:cell: grid/(y)/:cell or N
                    grid/(y - 1)/:cell: grid/(y - 1)/:cell or S
                    run-start: x + 1
                ][
                    if x < width [
                        grid/:y/:x:  grid/:y/:x or E
                        grid/:y/(x + 1):  grid/:y/(x + 1) or W
                    ]
                ]
            ]
        ]
    ]

    seed: has [s [integer!]][
        random/seed s
    ]

    init-gtid: func[][
        grid: copy []
        loop height [
            append grid make vector! compose [integer! 8 (width)]
        ]
    ]

    new: func[w h [integer!]][
        width: w
        height: h
        maze: copy []
        init-gtid
        switch method [
            rb [recursive-backtracker 1 1]
            bt [binary-tree]
            sw [sidewinder]
        ]
        loop height * 2 + 1 [
            append maze pad/with copy "" width * 2 + 1 #"w"
        ]
        iy: 2
        forall grid [
            ix: 2
            foreach f grid/1 [
                poke maze/:iy ix #"p"
                if (f and S <> 0) [poke maze/(iy + 1) ix #"p"]
                if (f and E <> 0) [poke maze/:iy ix + 1 #"p"]
                ix: ix + 2
            ]
            iy: iy + 2
        ]
    ]
]
