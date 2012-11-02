module Lab02 where

import Math.Combinatorics.Exact.Binomial
import Numeric.Tools.Integration
import Data.Maybe (fromJust)
import Data.List (zipWith5, zipWith7, intersperse)
import Text.Printf
import System.Cmd
import System.Environment
import Data.Ratio
import Data.List (inits)

main = do [p, n] <- getArgs
          lab01 (read p) (read n)

lab01 :: Double -> Integer -> IO ()
lab01 p n = do  print fXis 
                writeFile "data1.dat" $ unlines ("#K\tXi\tPB\tPG":toData1)
                writeFile "data2.dat" $ unlines ("#K\tXi\tPB\tPG":toData2)
                writeFile "result.tex" $ unlines $ intersperse "\\hline" toTex
                writeFile "plot1.gp" $ unlines toGp
                _ <- system "gnuplot plot1.gp && pdflatex report.tex"
                return ()
    where
        q = 1 - p
        rp = approxRational p 0.0000001
        rq = approxRational q 0.0000001
        fn = fromIntegral n
        ks = [0 .. n]
        fks = [0 .. fn]
        xis =  map (\x -> (x - fn*p)/ sqrt(fn*p*q)) fks
        posXis = filter (>0) xis
        xi2s = map (**2) $ filter (>=0) xis
        fG = map (\x -> 1 / (sqrt (2*pi*x)) * exp (-x/2))  xi2s
       -- fPG = map (\n -> fromJust $ quadRes $ quadRomberg defQuad (0.001, n) (\x -> 1 / (sqrt (2*pi*x)) * exp (-x/2)) ) xi2s
       
        pBs = map (\k -> fromRational $ (choose n k % 1) * 
                           rp ^ fromIntegral k * 
                           rq ^ fromIntegral (n-k)
                    ) ks 
        fBs = map (sqrt(fn*p*q)*) pBs
        pXis' = map (\(pb,xi) -> 2* pb) $ filter (\(_,xi) -> xi >= 0) $ zip pBs xis
        pXis = (head pXis' / 2) : (tail pXis')
        
        fXis = map (\(p,xi1,xi2) -> p / (xi2-xi1)) $ zip3 pXis xi2s $ tail xi2s
        fFXis = map sum $ tail $ inits $ tail fXis
        
        fGs = map (\x -> 1 / (sqrt (2*pi*x)) * exp (-x/2 )) xi2s
        
        (_,_,fFGs) = foldl (\(a,s,l) b -> let s1 = fromJust $ quadRes $ quadRomberg defQuad (a,b) (\x -> 1 / (sqrt (2*pi*x)) * exp (-x/2))
                                    in (b,s+s1,l++[s+s1] )) (0.001, 0, []) $ tail xi2s
        
        toData1 = zipWith3 (\xi pB fB -> show xi ++ "\t" ++ show pB ++ "\t" ++ show fB) xis pBs fBs
        toData2 = zipWith (\xi2 pXi-> show xi2 ++ "\t" ++ show pXi) xi2s fXis
        toTex = zipWith5 (\xi2 fXi fG fFXi fFG -> printf "%.2f" xi2 ++ " & " ++
                                                  printf "%.4e" fXi ++ " & " ++
                                                  printf "%.4e" fG ++ " & " ++
                                                  printf "%.4e" fFXi ++ " & " ++
                                                  printf "%.4e" fFG ++ " & " ++
                                                  printf "%.4e" (abs (fFG - fFXi)) ++ " \\\\") xi2s fXis fGs fFXis ((0/0):fFGs)
        toGp = ["set terminal pdf  size 13cm,20cm",
                "set output \"plot.pdf\"",
                "set multiplot layout 2, 1",
                "unset border",                
                "set xzeroaxis lt -1",
                "set yzeroaxis lt -1",
                "set xtics axis #rotate by 90",
                "set ytics rotate by -90 nomirror",
                "set xtics nomirror rotate by -90",
                "set y2zeroaxis lt - 1",
                "set yrange [] ",
                "set xrange [" ++ (show $ minimum xis) ++ ":" ++ (show $ maximum xis) ++ "]"
               ] ++ (map (\(p,xi,i)-> "set arrow " ++ show i++" from " ++ show xi ++ ", " ++ show p)   $ filter (\(_,x,_) -> x>0) $ zip3 pBs xis [0..] )
                 ++ (map (\(xi,k) -> "set arrow " ++ show k ++ " to " ++ show xi ++ ", screen 0.47 nohead" ) $ filter (\(x,_) -> x>0) $ zip xis ks)
                 ++
               ["plot \"data1.dat\" using 1:3 with linespoints notitle pt 3 lw 5 smooth cspline, \"data1.dat\" using 1:2 with impulses notitle lw 10 lc 4,\"data1.dat\" using 1:2 with points notitle pt 1 lw 10 lc 4"]
               ++ (map (\(xi,k) -> "set arrow " ++ show k ++ " to " ++ show xi ++ ", " ++ show (xi*xi) ) $ filter (\(x,_) -> x>0) $ zip xis ks)
               ++ (map (\(xi,k) -> "set arrow " ++ show (k + n) ++ " from " ++ show xi ++ ", " ++ show (xi*xi) ++ " to 0, " ++ show (xi*xi) ) $ filter (\(x,_) -> x>0) $ zip xis ks) ++
                ["unset yrange",
                "set yrange [0:"++ (show $ maximum xi2s) ++"] reverse",
                "set trange [0.001:"++ (show $ maximum xi2s)++"]",
                "unset xtics",
                "set x2tics nomirror rotate by -90 offset 0, graph 0.05",
                "set x2range [-"++ (show $ (maximum fXis))++":"++ (show $ maximum fXis)++"]",
                "set parametric"]
               ++ (zipWith3 (\xi f k -> "set arrow " ++ (show (k + 2*n)) ++ " from 0," ++ (show xi) ++ " to second " ++ (show f)++",  " ++ (show xi) ++ " lt rgb 'blue' lw 10 nohead") xi2s fXis ks) ++
                ["plot  t, t*t with lines notitle, 1/sqrt(2*pi*t)*exp(-t/2), t with lines notitle axes x2y1 lw 10, \"data2.dat\" using 2:1 with points notitle axe x2y1 lw 10"]

               
               
               
               
               
               
