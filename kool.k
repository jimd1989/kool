/ custom modulo of `x` and `y`, because builtin acts weird
md:{y-x*_y%x}
/ identity matrix `x` rows long
id:{xs:1+!x;1=xs%\:xs}
/ all permutations of a set with `x` members
perms:{+!x#2}
/ all `x`-sized groups of a set `y` items large
groupn:{ps:perms y;ps[&(x=)'(+/)'ps]}
/ add values at `c` to indices `b` of array `a`
paste:{[a;b;c]{@[x;y;z]}/[a;b;c]}
/ set all values of array `y` to zero except index `x`
isolate:{@[(#y)#0;x;y@x]}
/ cartesian grouping of arrays `x` and `y`
cross:{x,/:\:y}

/ rotate array of `y` items -left/+right `x` times, "i" functions are inclusive
rotsli:{md[y]'(!x)+/:\:!y}
rotsl:{1_rotsli[x+1;y]}
rotsr:{md[y]'(|(y-x)+!x)+/:\:!y}
rotsri:{(,!y),rotsr[x-1;y]}
rots:{$[x<0;rotsl[abs x;y];rotsr[x;y]]}
rotsi:{$[x<0;rotsli[abs x;y];rotsri[x;y]]}
rot:{y[,/((abs x)-1)_(rots[x;#y])]}

/ left/right diagonal runs of matrix `x`
diagonals:{c:,/cross[!x;!y];c[(=(+/)'c)[]]}
diagl:{x ./:/:diagonals[#x;#x@0]}
diagr:{(|'x) ./:/:diagonals[#x;#x@0]}
