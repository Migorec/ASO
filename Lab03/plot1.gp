set terminal pngcairo size 500, 500 
set output "plot.png"
set xrange [-4.83:2.07]
set yrange [-4.83:2.07]
set xtics (-4.83, -4.14, -3.45, -2.76, -2.07, -1.38, -0.69, 0.00, 0.69, 1.38, 2.07) nomirror offset -2, -2 rotate by 45
set ytics (-4.83, -4.14, -3.45, -2.76, -2.07, -1.38, -0.69, 0.00, 0.69, 1.38, 2.07) nomirror rotate by 45
set border 3
set grid
plot x notitle with lines lc rgb "black"
