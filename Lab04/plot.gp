set terminal pdfcairo font ",3"
set output "plot.pdf"

set multiplot layout 2, 2
unset key

plot "test.dat" using 1:3 ps 0.3 lc 2, "test.dat" using 1:2 w l lc 1

plot "test1.dat" using 1:3 with boxes, "test1.dat" using 1:2 with impulses, 1/(sqrt(2*pi))*exp(-x*x/2)


plot "test.dat" using 1:3 ps 0.3 lc 2, "test.dat" using 1:4 w l lc 1

plot "test2.dat" using 1:3 with boxes, "test2.dat" using 1:2 with impulses, 1/(sqrt(2*pi))*exp(-x*x/2)
