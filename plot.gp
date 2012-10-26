set terminal epslatex color 
set output "plot.tex"
set key box
set xlabel "k"
set xtics nomirror
set x2label '$\xi$'
set y2zeroaxis lt - 1
set style line 22 lt 3 lw 4
set style line 10 lt 1 lw 4
plot "test.dat" using 1:3 title "$P_B$" ls 10,"test.dat" using 1:4 with boxes title "$f_B$" ls 10, "test.dat" using 2:5 title "$f_G$" smooth cspline ls 22 with lines axes x2y1




