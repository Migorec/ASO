module Main (choose, awfulMult, main,lab01)where


import Math.Combinatorics.Exact.Binomial
import Numeric.Tools.Integration
import Data.Maybe (fromJust)
import Data.List (zipWith5, zipWith7, intersperse)
import Text.Printf
import System.Cmd
import System.Environment
import Data.Number.BigFloat
import Data.Ratio

main = do [p, n] <- getArgs
          lab01 (read p) (read n)


toBigFloat :: Double -> BigFloat Prec10
toBigFloat x = let (a,b) = decodeFloat x in (fromIntegral a)*(2** (fromIntegral b))

fromBigFloat :: BigFloat Prec10 -> Double
fromBigFloat x = let (a,b) = decodeFloat x in (fromIntegral a)*(10**(fromIntegral b))


awfulMult :: (Integral a, RealFloat b) => a -> b -> b
awfulMult x b | (not.isInfinite) fx = fx*b
              | otherwise = awfulMult (x `div` 10) (b*10) 
    where fx = fromIntegral x

--pBer :: (Integral a, Floating b) => a -> a -> b -> b -> b
pBer n k p q = m * (foldl (\a x -> a/x*(fromIntegral n-x+1)*p*q) 1.0 [fromIntegral z,fromIntegral z-1 .. 1])
    where z = min k (n - k) 
          m = if k > (n-k) then p ^ (k - (n -k)) else q^(n-k-k)

lab01 :: Double -> Integer -> IO ()
lab01 p n = do 
               writeFile "test.dat" $ unlines ("#K\tXi\tPB\tPG":toFile)
               writeFile "result.tex" $ unlines $ intersperse "\\hline" toTex
               _ <- system  $ "(echo 'set x2tics' && echo 'set xrange [0:" ++ (show n) ++"]' && echo 'set x2range [  " ++ show (-fn*p/sqrt(fn*p*q))++":" ++ show ((fn-fn*p)/sqrt(fn*p*q))++ "]' && echo 'set label \"p=" ++ show p ++ "\\\\nq="++show q++"\\\\nn="++show n ++"\" at screen 0.2,0.7' && cat plot.gp) | gnuplot && ps2pdf -dEPSCrop plot.eps plot.pdf && pdflatex report.tex"       
               return ()
    where q = 1 - p
          rp = approxRational p 0.0000001
          rq = approxRational q 0.0000001
          bp = toBigFloat p
          bq = toBigFloat q
          fn = fromIntegral n
          ks = [0 .. n]
          fks = [0 .. fn]
          pBs = map (\k -> fromRational $ (choose n k % 1) * (rp ^ fromIntegral k * rq ^ fromIntegral (n-k))) ks 
--          pBs = map fromBigFloat bpBs :: [Double]
          xis =  map (\x -> (x - fn*p)/ sqrt(fn*p*q)) fks
          dxi = 1 / 2 / sqrt (fn * p * q)
          pGs = map (\xi -> fromJust $ quadRes $ quadSimpson defQuad (xi - dxi, xi + dxi) (\x -> exp (-x*x/2)/sqrt(2*pi))) xis
          dPs = zipWith (\pB pG -> abs $ pB - pG) pBs pGs
          fBs = map (sqrt(fn*p*q)*) pBs
          fGs = map (\x -> exp(-x*x/2)/sqrt(2*pi)) xis
          toFile = zipWith5 (\k xi pB fB fG -> show k ++ "\t" ++ 
                                               show xi ++ "\t" ++
                                               show pB ++ "\t" ++
                                               show fB ++ "\t" ++
                                               show fG) ks xis pBs fBs fGs
          toTex = zipWith7 (\k xi pB pG dP fB fG -> show k ++ " & " ++
                                                    printf "%.2f" xi ++ " & " ++
                                                    printf "%.4e" pB ++ " & " ++
                                                    printf "%.4e" pG ++ " & " ++
                                                    printf "%.4e" dP ++ " & " ++
                                                    printf "%.4e" fB ++ " & " ++
                                                    printf "%.4e" fG ++ " \\\\") ks xis pBs pGs dPs fBs fGs
