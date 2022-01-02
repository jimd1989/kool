/ functions written for theoretical clarity over performance (sorry)

/ constants
pi:3.141592653589793115997963468544185161590576171875
euler:2.718281828459045090795598298427648842334747314453125
phi:1.618033988749894848204586834365638117720309179805

/ custom modulo of `x` and `y`, because builtin acts weird
md:{y-x*_y%x}
/ fractional part of float `x`
frac:{md[_x;x]}

/ `x` to the power of `y`
pow:{*/y#x}
powf:{exp y * log x}

/ useful serieses and sieves
twon:|pow[2]'!64
abc:"abcdefghijklmnopqrstuvwxyzABCEFGHIJKLMNOPQRSTUVWXYZ"
digits:"0123456789"

/ odd and even indices of array `x`
odd:{x[&md[2]'!#x]}
even:{x[&~md[2]'!#x]}

/ i combinator: return `x` itself
id:{x}
/ k combinator: only return `x`
const:{[x;y]x}
/ chain dyad `h` against the outputs of monads `g` and `f`
fork:{[h;g;f;x]h[g x;f x]}
/ flip arguments `y` and `z` to function `x`
flip:{x[z;y]}

/ append vector `x` to matrix `y`
app:{(,(x)),y}
/ all permutations of a set with `x` members
perms:{+!x#2}
/ all `x`-sized groups of a set `y` items large
groupn:{ps:perms y;ps[&(x=)'(+/)'ps]}
/ add values at `c` to indices `b` of vector `a`
paste:{[a;b;c]{@[x;y;z]}/[a;b;c]}
/ set all values of array `y` to zero except index `x`
isolate:{@[(#y)#0;x;y@x]}
/ cartesian grouping of vectors `x` and `y`
cross:{x,/:\:y}
/ if `x` is member of `y`
member:{(#y)>y?x}

/ magnitude of vector `x`
mag:{sqrt+/sqr'x}
/ normalize vector `x`
normal:{x%mag x}
/ vector dot product between `x` and `y`
vdot:(+/*)
/ multiply matrices `x` and `y`
mmu:{x(+/*)/:\:+y}
/ identity matrix `x` by `x`
identity:{xs:1+!x;1=xs%\:xs}
/ centering matrix `x` by `x`
center:{(identity x)-(1%x)*x^(x*x)#1}
/ covariance matrix of matrix `x`
covar:{n:#x;cx:mmu[center n;x];mmu[+cx;cx]%n-1}
/ perform gram-schmidt on a reversed matrix `x`, with output reversed as well (slow and ugly?)
gramsci:{$[1=#x;x;{v:*x;u:gramsci 1_x;gs:+/app[v;{(-y)*vdot[x;y]%vdot[y;y]}[v]'|u];app[gs;u]}x]}
/ orthonormalize matrix `x` (Q in QR decomposition)
orthonor:{+{%'[x;{sqrt vdot[x;x]}'x]}(|)gramsci(|+x)}
/ qr decomposition of matrix `x` (no inverse for R, but works anyway?)
qr:{Q:orthonor x;R:mmu[mmu[mmu[+Q;Q];+Q];x];R;`Q`R!(Q;R)}
/ qr algorithm for eigenvalues and vectors on symmetrical matrix `x`, `y` iterations
/ TODO - generalize to non-symmetrical, format eigens better
/ TODO - confirm assumption that eigenvalue n refers to column n
qra:{qs:{[x;y]{q:qr(*x);(mmu[q`R;q`Q];q`Q)}x}\[(x;identity(#x));!y];d:diagr[**|qs];val:d(_(#d)%2);vec:{x%last x}'+mmu/qs[;1];|^+`val`vec!(val;vec)}

/ return the first suffix of `x` where `y` holds true, where `x` is ,(pred;suffix)
cond:{ps:(*)'x;(*x[&ps@\:y])1}

/ if `y` is a subset of `x`
subset:{*/(#x)>/:x?/:y}

/ infer the type of atom `x`, ranked by inclusivity
infer:{ds:"-.0123456789";$[subset[ds;x];$[1=+/"."=x;1;$["-"=*x;2;3]];0]}
/ infer the most inclusive type of all in `x`
infera:{`lc`f`j`i[&/infer':x]}
/ if `x` is not `lc or `i, fill in nulls in string array `y` with zero strings
fillz:{$[(`i=x)&`lc=x;y;@[y;&0=#'y;"0"]]}
/ parse a column `x` into its inferred type
parsec:{s:infera x;(s$)'fillz[s]x}
/ make inferred table from `x`, where `x` is 0:file.csv, slow as shit atm
ifromcsv:{xs:(","\)':x;k:(`n$)'*xs;+k!parsec':+1_xs}
/ where `x` is an explicit list of types and `y` is 0:file.csv, make table
fromcsv:{ys:(","\)'y;k:(`n$)'*ys;v:1_ys;t:k!+v;+{[a;k;s]@[a;k;(s$)']}/[t;!t;x]}
/ turn table `x` into csv format, ready to write with file 0: table
tocsv:{t:+x;h:(","/$!t);b:","/'$'+t[];(,h),b}

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

/ sliding window `a` width across array `b` "i" = includes ramp up/down to full window
window:{[a;b](a-1)_{1_x,y}\[a#0;b]}
windowi:{[a;b]{1_x,y}\[a#0N;b,(a-1)#0N]}

/ convert a binary array `x` to an integer, and back
bitsi:{+/x*(-#x)#twon}
ibits:{[a]1_|md[2]'{_x%2}\:a}

/ convert midi note `x` to frequency
midifreq:{8.1757989156*powf[2;x%12]}

/ fft in progress scratchpad
cis:{(cos x;sin x)}
/ discrete fourrier transform: slow
dft:{b:{[k;n;N](-2*pi*k*n)%N};N:#x;+/+x*/:{cis y x}[N]''(!N){x[y]z}[b]/:\:!N}
cmul:{s:(1=#x)|1=#y;$[s;x*y;(((x 0)*y 0)-(x 1)*y 1;((x 1)* y 0)+(x 0)*y 1)]}
/ butterfly indices for a `x` item series, where `x` is power of 2
butterfly:{[a]$[1=+/ibits a;{(even x),odd x}\:!a;,0N]}

/ other feature ideas
/ linear interpolation
/ levenshtein
/ standard deviation
