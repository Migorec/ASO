set terminal pdf size 13cm,13cm
set output "plot.pdf"

set xrange [-2.23:2.23]
set yrange [-2.23:2.23]
set xtics -2.23, 0.894 nomirror offset -2, -2 rotate by 45
set ytics -2.23, 0.894 nomirror  rotate by 45
set border 3
set grid
plot x notitle with lines lc rgb "black"
