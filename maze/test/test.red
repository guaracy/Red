Red [Needs: View]

#include %../maze.red

wall:  load %wall.png
floor: load %floor.png
door:  load %door.png

; hero.png : https://opengameart.org/content/base-character-spritesheet-16x16
hero-spritesheet: load %heros.png
tile-size: 16x16
sprite: function [pos [pair!]][
    copy/part skip hero-spritesheet pos tile-size
]
hero-up:    reduce [sprite 0x0  sprite 16x0  sprite 32x0  sprite 48x0 ]
hero-down:  reduce [sprite 0x16 sprite 16x16 sprite 32x16 sprite 48x16]
hero-left:  reduce [sprite 0x32 sprite 16x32 sprite 32x32 sprite 48x32]
hero-right: reduce [sprite 0x48 sprite 16x48 sprite 32x48 sprite 48x48]
hero-idle:  reduce [sprite 0x64 sprite 16x64 sprite 32x64 sprite 48x64]

hero: hero-idle/1

hero-direction: 0x0
hero-position: 2x2
hero-dest: 2x2
hero-moves: 0
hero-speed: 20

imsz: wall/size/x
maze-size: 5x5

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
    pic: make image! as-pair maze-size/x * 2 + 1 * imsz  maze-size/y * 2 + 1 * imsz
    dd: 1
    ds: 1
    x: 1
    y: 1
    foreach l ctx-maze/maze [
        foreach c l [
            either c = #"w" [
                draw-to pic wall as-pair x y
            ][
                draw-to pic floor as-pair x y
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
    shero/offset: lab/offset + 16x16
    sdoor/offset: lab/offset + lab/size - 32x32
    lay/size: lab/offset + pic/size + 10
    hero-direction: 0x0
    hero-position: 2x2
]

can-move?: func[/local npos][
  npos: hero-position + hero-step
  ctx-maze/maze/(npos/y)/(npos/x) <> #"w"
]

hero-move: func[npos [pair!]][
    unless none? shero/rate [exit]
    hero-step: 0x0
    hero-dest: npos / 16 + 1 - hero-position
    if all [hero-dest/x <> 0 hero-dest/y <> 0][exit]
    hero-step: as-pair sign? hero-dest/x sign? hero-dest/y
    unless can-move? [exit]
    hero-direction: hero-step * 4
    switch hero-step [
         0x-1 [hero: hero-up    hero-direction:   0x-4]
         0x1  [hero: hero-down  hero-direction:   0x4 ]
        -1x0  [hero: hero-left  hero-direction:  -4x0 ]
         1x0  [hero: hero-right hero-direction:   4x0 ]
    ]
    hero-dest: hero-position + hero-dest
    shero/rate: hero-speed
]

lay: layout [
    title "maze"
    below
    space 2x2
    button "New maze" [
        new-maze
    ]
    text "Size"
    fsize: field data "5x5"
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
    on-down [
        hero-move event/offset
    ]
    at lab/offset + 16x16
    shero: image hero
    on-time [
        if tail? hero [
            hero: head hero
            hero-position: hero-position + hero-step
            hero-moves: hero-moves + 1
            if not can-move? [
                hero-dest: hero-position    
            ]
            if hero-position = hero-dest [
                shero/rate: none
            ]
            if shero/offset = sdoor/offset [
                alert rejoin ["EXIT!!!" newline hero-moves " moves"]
            ]
            exit
        ]
        shero/image: hero/1
        shero/offset: shero/offset + hero-direction
        hero: next hero
    ]
    at lab/offset + lab/size - 32x32
    sdoor: image door
]

view lay