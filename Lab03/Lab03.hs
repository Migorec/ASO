module Lab03 where


import Data.Array
import Data.Ratio
import Math.Combinatorics.Exact.Binomial
import Numeric.Tools.Integration
import Data.List (inits)
import Data.Maybe (fromJust)
import System.Cmd
import Data.List (zipWith7, intersperse)
import Text.Printf

backIntegral :: (Double -> Double) -> Double -> Double -> Double ->  Double
backIntegral f x dx eps = backIntegral' 0 f x dx eps
    where
        backIntegral' a f x dx eps | s < eps = a + s
                                   | otherwise = backIntegral' (a+s) f (x-dx) dx eps 
            where s = (f x + f (x -dx)) / 2 * dx

lab03 :: Double -> Integer -> IO ()
lab03 p n = do writeFile "table.tex" $ unlines $ intersperse "\\hline" toTex
               writeFile "plot1.gp" $ unlines toGp
               _ <- system "gnuplot plot1.gp && pdflatex report.tex"
               --print fFg0
               print xis
               print pBhs
               --print his
               --print fB
               --print fG
               return ()
    where fn = fromIntegral n
          q = 1 - p
          rp = approxRational p 0.0000001
          rq = approxRational q 0.0000001
          ks = [0 .. n]
          fks = [0 .. fn]
          xis =  map (\x -> (x - fn*p)/ sqrt(fn*p*q)) fks
          dxi = ((head $ tail xis) - (head xis))
          his = map (\x ->(x - fn*p)/ sqrt(fn*p*q)*2 )  [0,0.5..fn]
          dHi = (head $ tail his) - (head his)
          pBs = array (0,n) $ map (\k -> (k,fromRational $ (choose n k % 1) * 
                                            rp ^ fromIntegral k * 
                                            rq ^ fromIntegral (n-k)
                                         )
                                  ) ks 
          
          pBhs = map (\hi -> sum $ map (\i -> pBs ! i * pBs ! (hi-i)) [max (hi - n) 0 .. min hi n]) [0..2*n]
          fFb = map (sum) $ tail $ inits pBhs
          fB = map (/dHi) pBhs
          fG = map (\u -> exp (-u*u/4) / sqrt (4*pi)) his
          fFg0 = backIntegral (\x -> exp (-x*x/4) / sqrt(4*pi)) (head his) 0.01 0.000001
          (fFg, _,_) =  foldl (\(l,a, x0) x-> 
                                 let r = fromJust $ quadRes $ 
                                         quadSimpson defQuad (x0, x) (\x -> exp (-x*x/4)/sqrt(4*pi))
                                 in (l++[r+a], r+a, x)
                              ) ([fFg0], fFg0, head his) $ tail his
          dFs = zipWith (\a b  -> abs (a-b)) fB fG
          dfFs = zipWith (\a b  -> abs (a-b)) fFb fFg
          toTex = zipWith7 (\hi fB fG df fFb fFg dF ->  printf "%.2f" hi ++ " & " ++
                                                        printf "%.4e" fB ++ " & " ++
                                                        printf "%.4e" fG ++ " & " ++
                                                        printf "%.4e" df ++ " & " ++
                                                        printf "%.4e" fFb ++ " & " ++
                                                        printf "%.4e" fFg ++ " & " ++
                                                        printf "%.4e" dF ++ " \\\\") his fB fG dFs fFb fFg dfFs
          toGp = ["set terminal pngcairo size 500, 500 ",-- size 13cm,13cm",
                  "set output \"plot.png\"",
                  "set xrange [" ++ (printf "%.2f" $ head xis) ++":" ++ (printf "%.2f" $ last xis)++"]",
                  "set yrange [" ++ (printf "%.2f" $ head xis) ++":" ++ (printf "%.2f" $ last xis)++"]",
--                  "set xtics " ++ (printf "%.3f" $ head xis) ++ ", " ++ (printf "%.2f" dxi)++ ", "++ (printf "%.2f" $ last xis) ++ " nomirror offset -2, -2 rotate by 45",
                  "set xtics (" ++ (concat $ intersperse ", " $ map (printf "%.2f") xis)++") nomirror offset -2, -2 rotate by 45",
                  "set ytics (" ++ (concat $ intersperse ", " $ map (printf "%.2f") xis)++") nomirror rotate by 45",
                  "set border 3",
                  "set grid",
                  "plot x notitle with lines lc rgb \"black\""
                 ]
