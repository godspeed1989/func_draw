func_draw
=========

homework of func_draw language parser.   
example:   
```
origin is (120,120);
scale is (80,80);
rot is 0;

for t from 0 to 3*pi step pi/60 draw(cos(t),sin(t));

for t from 0 to pi*20 step pi/50 draw
    ( (1-1/(10/7))*cos(t)+1/(10/7)*cos(-t*((10/7)-1)),
      (1-1/(10/7))*sin(t)+1/(10/7)*sin(-t*((10/7)-1)) );

sleep 2;
```

