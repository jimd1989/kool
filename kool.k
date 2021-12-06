/ identity matrix `x` rows long
id:{xs:1+!x;1=xs%\:xs}
/ all permutations of a set with `x` members
perms:{+!x#2}
/ custom modulo of `x` and `y`, because builtin acts weird
md:{y-x*_y%x}
/ `y` rotation rows of `x` indices, to the right
rots:{(md[x])'(|(x-y)+!y)+y^!x*y}
/ inclusive `rots` that starts with `x` in order
rotsi:{(,!x),rots[x;y-1]}
/ all `x`-sized groups of a set `y` items large
groupn:{ps:perms y;ps[&(x=)'(+/)'ps]}
