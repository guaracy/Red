```maze.red``` implementa três algoritmos para a geração de labirintos:

![Recursive Backtracking](http://weblog.jamisbuck.org/2010/12/27/maze-generation-recursive-backtracking)

![](https://github.com/guaracy/Red/blob/master/maze/images/maze-rb.png)

![Binary Tree algorithm](http://weblog.jamisbuck.org/2011/2/1/maze-generation-binary-tree-algorithm.html)

![](https://github.com/guaracy/Red/blob/master/maze/images/maze-bt.png)

![Sidewinder algorithm](http://weblog.jamisbuck.org/2011/2/3/maze-generation-sidewinder-algorithm.html)

![](https://github.com/guaracy/Red/blob/master/maze/images/maze-sw2.png)

Alterando weight

![](https://github.com/guaracy/Red/blob/master/maze/images/maze-sw20.png)


Utilização:

```red
ctx-maze/new width height
```
Gera um labirinto com o número de caminhos verticais (width) e horizontas (height) informados

```red
ctx-maze/wight integer
```
Apenas para o algoritmo sidewinder. Um número maior ou igual a zero e unfluencia no número de passagens para o norte que cada caminho horizontal terá.

```red
ctx-maze/maze
```

Retorna um bloco de strings identificando cada célula do labirinto onde w = parede e p = caminho.

```red
ctx-maze/method: 'algoritmo
```

onde, ```algoritmo``` pode ser:

'rb = recursive backtracker
'bt = binary tree
'sw = sidewinder


O programa ```test/teste.red``` permite testar os algorítmos.
