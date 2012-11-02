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
set xrange [-4.47213595499958:4.47213595499958]
set arrow 11 from 0.4472135954999579, 0.16017913818359375
set arrow 12 from 0.8944271909999159, 0.12013435363769531
set arrow 13 from 1.3416407864998738, 7.39288330078125e-2
set arrow 14 from 1.7888543819998317, 3.696441650390625e-2
set arrow 15 from 2.23606797749979, 1.47857666015625e-2
set arrow 16 from 2.6832815729997477, 4.620552062988281e-3
set arrow 17 from 3.1304951684997055, 1.087188720703125e-3
set arrow 18 from 3.5777087639996634, 1.811981201171875e-4
set arrow 19 from 4.024922359499621, 1.9073486328125e-5
set arrow 20 from 4.47213595499958, 9.5367431640625e-7
set arrow 11 to 0.4472135954999579, screen 0.47 nohead
set arrow 12 to 0.8944271909999159, screen 0.47 nohead
set arrow 13 to 1.3416407864998738, screen 0.47 nohead
set arrow 14 to 1.7888543819998317, screen 0.47 nohead
set arrow 15 to 2.23606797749979, screen 0.47 nohead
set arrow 16 to 2.6832815729997477, screen 0.47 nohead
set arrow 17 to 3.1304951684997055, screen 0.47 nohead
set arrow 18 to 3.5777087639996634, screen 0.47 nohead
set arrow 19 to 4.024922359499621, screen 0.47 nohead
set arrow 20 to 4.47213595499958, screen 0.47 nohead
plot "data1.dat" using 1:3 with linespoints notitle pt 3 lw 5 smooth cspline, "data1.dat" using 1:2 with impulses notitle lw 10 lc 4,"data1.dat" using 1:2 with points notitle pt 1 lw 10 lc 4
set arrow 11 to 0.4472135954999579, 0.19999999999999998
set arrow 12 to 0.8944271909999159, 0.7999999999999999
set arrow 13 to 1.3416407864998738, 1.8
set arrow 14 to 1.7888543819998317, 3.1999999999999997
set arrow 15 to 2.23606797749979, 5.000000000000001
set arrow 16 to 2.6832815729997477, 7.2
set arrow 17 to 3.1304951684997055, 9.8
set arrow 18 to 3.5777087639996634, 12.799999999999999
set arrow 19 to 4.024922359499621, 16.2
set arrow 20 to 4.47213595499958, 20.000000000000004
set arrow 31 from 0.4472135954999579, 0.19999999999999998 to 0, 0.19999999999999998
set arrow 32 from 0.8944271909999159, 0.7999999999999999 to 0, 0.7999999999999999
set arrow 33 from 1.3416407864998738, 1.8 to 0, 1.8
set arrow 34 from 1.7888543819998317, 3.1999999999999997 to 0, 3.1999999999999997
set arrow 35 from 2.23606797749979, 5.000000000000001 to 0, 5.000000000000001
set arrow 36 from 2.6832815729997477, 7.2 to 0, 7.2
set arrow 37 from 3.1304951684997055, 9.8 to 0, 9.8
set arrow 38 from 3.5777087639996634, 12.799999999999999 to 0, 12.799999999999999
set arrow 39 from 4.024922359499621, 16.2 to 0, 16.2
set arrow 40 from 4.47213595499958, 20.000000000000004 to 0, 20.000000000000004
unset yrange
set yrange [0:20.000000000000004] reverse
set trange [0.001:20.000000000000004]
unset xtics
set x2tics nomirror rotate by -90 offset 0, graph 0.05
set x2range [-0.8809852600097657:0.8809852600097657]
set parametric
set arrow 40 from 0,0.0 to second 0.8809852600097657,  0.0 lt rgb 'blue' lw 10 nohead
set arrow 41 from 0,0.19999999999999998 to second 0.5339304606119792,  0.19999999999999998 lt rgb 'blue' lw 10 nohead
set arrow 42 from 0,0.7999999999999999 to second 0.24026870727539063,  0.7999999999999999 lt rgb 'blue' lw 10 nohead
set arrow 43 from 0,1.8 to second 0.10561261858258932,  1.8 lt rgb 'blue' lw 10 nohead
set arrow 44 from 0,3.1999999999999997 to second 4.1071573893229144e-2,  3.1999999999999997 lt rgb 'blue' lw 10 nohead
set arrow 45 from 0,5.000000000000001 to second 1.344160600142046e-2,  5.000000000000001 lt rgb 'blue' lw 10 nohead
set arrow 46 from 0,7.2 to second 3.5542708176832926e-3,  7.2 lt rgb 'blue' lw 10 nohead
set arrow 47 from 0,9.8 to second 7.247924804687504e-4,  9.8 lt rgb 'blue' lw 10 nohead
set arrow 48 from 0,12.799999999999999 to second 1.0658712948069852e-4,  12.799999999999999 lt rgb 'blue' lw 10 nohead
set arrow 49 from 0,16.2 to second 1.003867701480262e-5,  16.2 lt rgb 'blue' lw 10 nohead
plot  t, t*t with lines notitle, 1/sqrt(2*pi*t)*exp(-t/2), t with lines notitle axes x2y1 lw 10, "data2.dat" using 2:1 with points notitle axe x2y1 lw 10
