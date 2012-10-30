set terminal pdf  size 13cm,20cm
set output "plot.pdf"

set multiplot layout 2, 1


unset border
set xzeroaxis lt -1
set yzeroaxis lt -1
set xtics axis #rotate by 90
set ytics rotate by -90 nomirror


set xtics nomirror rotate by -90

set y2zeroaxis lt - 1

set yrange [] 
set xrange [-5:5]
set arrow 1 from 2.23606797749979, 1.47857666015625e-2

set arrow 1 to 2.23606797749979, screen 0.47 nohead


plot "data1.dat" using 1:3 with linespoints notitle pt 3 lw 5, "data1.dat" using 1:2 with impulses notitle lw 10 lc 4,"data1.dat" using 1:2 with points notitle pt 1 lw 10 lc 4  

set arrow 1 to 2.23606797749979, 5
set arrow 2 from 2.23606797749979, 5 to 0, 5 nohead 
unset yrange
set yrange [0:20] reverse
set trange [0.001:20]
unset xtics
set x2tics nomirror
set x2range [-0.5:0.5]
set parametric
plot  t, t*t with lines notitle, 1/sqrt(2*pi*t)*exp(-t/2), t with lines notitle axes x2y1 lw 10, "data2.dat" using 2:1 with points notitle axe x2y1 lw 10

