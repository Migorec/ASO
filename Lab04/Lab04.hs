module Lab04 where

import Data.Random.Normal
import Control.Monad (replicateM, liftM)
import Data.List (zipWith4)
import Data.Maybe (fromJust)
import Numeric.Tools.Integration
import Statistics.Distribution
import Statistics.Distribution.ChiSquared
import System.Cmd


f1 x = 10*sin x + x

f2 x = 10*x*sin x + x


xi2 :: Int -> [Double] -> (Double, [String])
xi2 n xis = (res, toDat)
    where maxXi = maximum $ map abs xis
          fn = fromIntegral n
          dXi = 2*maxXi / 10
          ints = [-maxXi, dXi - maxXi .. maxXi]
          dXis = zip ints (tail ints)
          hist = map (\(x1,x2) -> fromIntegral $ length $ filter (\d -> (d >=x1) && (d < x2)) xis ) dXis
          pHist = map (\h -> h / fn) hist
          gaus = map (\(x1,x2) -> fromJust $ quadRes $ quadSimpson defQuad (x1, x2) 
                                                            (\x -> 1/(sqrt (2*pi)) * exp (-x*x/2))) dXis
          res = sum $ tail $ zipWith (\ns g -> (ns - fn*g)**2 / fn / g) hist gaus
          toDat = zipWith3 (\x f p -> show x ++ "\t" ++ show f ++ "\t" ++ show p) 
                           (map (\(x1,x2) -> (x1+x2)/2) dXis) 
                           pHist 
                           (map (/dXi) pHist)
           
           

lab04 n f1 f2 b alpha= 
    do let fn = fromIntegral n
           dx = b / (fromIntegral n)
           xs = [0, dx .. b]
           et = map f1 xs
           et2 = map f2 xs
           
       df <- (take n) `liftM` normalsIO' (0,1)
       let et' = zipWith (+) et df
           df2 = zipWith (-) et' et2
           (xi21, toDat1) = xi2 n df
           (xi22, toDat2) = xi2 n df2
           
           q = quantile (chiSquared 10) (1 - alpha)
           
           toDat = zipWith4 (\x f f' f2 -> show x ++ "\t" ++ 
                                           show f ++ "\t" ++ 
                                           show f' ++ "\t" ++ show f2) xs et et' et2

       putStrLn ("Критическое значение: " ++ (show q))
       putStrLn ("Статистика 1: " ++ (show xi21))
       putStrLn ("Статистика 2: " ++ (show xi22))
       
       
       writeFile "test.dat" $ unlines (toDat)
       writeFile "test1.dat" $ unlines (toDat1)
       writeFile "test2.dat" $ unlines (toDat2)
       system "gnuplot plot.gp"
