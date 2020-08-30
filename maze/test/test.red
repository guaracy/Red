Red [Needs: View]

#include %../maze.red

; hero.png : https://opengameart.org/content/base-character-spritesheet-16x16
hero:  load %hero.png
wall:  load %wall.png
floor: load %floor.png
door:  load %door.png

imsz: wall/size/x
maze-size: 10x10 ;15x10

draw-to: function [des src [image!] pos [pair!]][
    dx: pos/y - 1 * des/size/x + pos/x
    sw: src/size/x
    sh: src/size/y
    sx: 1
    sy: 1
    loop sh [
        loop sw [
            des/:dx: src/:sx
            dx: dx + 1
            sx: sx + 1
        ]
        dx: dx - sw + des/size/x
    ]
]

maze: function [][
    ctx-maze/new maze-size/x maze-size/y
    pic: make image! to-pair reduce [maze-size/x * 2 + 1 * imsz  maze-size/y * 2 + 1 * imsz]
    dd: 1
    ds: 1
    x: 1
    y: 1
    foreach l ctx-maze/maze [
        foreach c l [
            either c = #"w" [
                draw-to pic wall to-pair reduce [x y]
            ][
                draw-to pic floor to-pair reduce [x y]
            ]
            x: x + imsz
        ]
        y: y + imsz
        x: 1
    ]
    return pic
]

pic: maze

new-maze: func[/local s][
    try [s: load fsize/text]
    if pair? s [maze-size: s]
    ;print [maze-size ":" s]
    pic: attempt [maze]
    if none? pic [
        alert rejoin [
            maze-size " is to high for recursion." newline
            "try a different algorithms" newline
            "binary-tree or sidewinder"
        ]
        exit
    ]
    lab/image: pic
    lab/size: pic/size
    sdoor/offset: lab/offset + lab/size - 32x32
    lay/size: lab/offset + pic/size + 10
]

lay: layout [
    title "maze"
    below
    space 2x2
    button "New maze" [
        new-maze
    ]
    text "Size"
    fsize: field data "10x10"
    text "Algorithm"
    method: drop-list select 1 data ["recursive-backtracker" "binary-tree" "sidewinder"]
    on-change [
        sw/enabled?: false
        switch method/selected [
            1 [ctx-maze/method: 'rb]
            2 [ctx-maze/method: 'bt]
            3 [ctx-maze/method: 'sw sw/enabled?: true]
        ]
        new-maze
    ]
    text "Weight"
    sw: field disabled data "2"
    on-change [
        if none? sw/data [exit]
        try [nsw: to-integer sw/data]
        if integer? nsw [
            ctx-maze/weight: nsw
            new-maze
        ]
    ]
    return
    lab: image pic
    on-change [
        print "imagem mudou"
    ]
    at lab/offset + 16
    shero: image hero
    at lab/offset + lab/size - 32x32
    sdoor: image door
]

view lay