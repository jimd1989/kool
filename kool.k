/ identity matrix `x` rows long
id:{xs:1+!x;1=xs%\:xs}
/ all permutations of a set with `x` members
perms:{+!x#2}
/ custom modulo of `x` and `y`, because builtin acts weird
md:{y-x*_y%x}
/ `y` rotation rows of `x` indices, to the right
rotsr:{(md[x])'(|(x-y)+!y)+y^!x*y}
/ inclusive `rotsr` that starts with `x` in order
rotsri:{(,!x),rotsr[x;y-1]}
/ inclusive `rotsl` that starts with `x` in order
rotsli:{(md[x])'(!y)+y^!x*y}
/ `y` rotation rows of `x` indices, to the left
rotsl:{1_rotsli[x;y+1]}
/ general rotation where negative `y` = left
rots:{$[y<0;rotsl[x;abs y];rotsr[x;y]]}
/ general inclusive rotation where negative `y` = left
rotsi:{$[y<0;rotsli[x;abs y];rotsri[x;y]]}
/ single direct rotation where negative `y` = left
rot:{x[,/((abs y)-1)_(rots[#x;y])]}
/ all `x`-sized groups of a set `y` items large
groupn:{ps:perms y;ps[&(x=)'(+/)'ps]}
/ add values at `c` to indices `b` of array `a`
paste:{[a;b;c]{@[x;y;z]}/[a;b;c]}
