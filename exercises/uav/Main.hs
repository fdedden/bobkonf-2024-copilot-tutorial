{-# LANGUAGE RebindableSyntax #-}

module Main where

import Language.Copilot
import Copilot.Compile.C99 (compile)

import Voting

-- The time since boot in seconds.
time :: Stream Double
time = extern "uptime" Nothing

-- 3-tuple of altimeter readings as provided by the airplane.
-- For the sake of simplicity, these all provide the elevation in meters above
-- sea-level.
altimeter0, altimeter1, altimeter2 :: Stream Double
altimeter0 = extern "altimeter0" Nothing
altimeter1 = extern "altimeter1" Nothing
altimeter2 = extern "altimeter2" Nothing


-------------------------------------------------------------------------------


-- [Exercise]
-- As we have multiple altimeters, we want to filter the input for outliers to
-- get our real altitude.
-- For this exercise let us rely on just taking the average over the three
-- altimeters.
altitudeAvg :: Stream Double
altitudeAvg = 0


-- The derivative of average altitude over time.
daltitudeAvg_dt :: Stream Double
daltitudeAvg_dt = deriv altitudeAvg time


-- [Exercise]
-- Calculate the derivative of a stream of doubles over another one, i.e:
-- (current x - previous x) / (current y - previous y)
-- Hint: use (++).
deriv :: Stream Double -> Stream Double -> Stream Double
deriv sx sy = 0


-------------------------------------------------------------------------------


-- [Exercise]
-- Define a function for comparing two doubles fuzzily. We should treat them
-- equal when the difference < 0.001.
approx :: Stream Double -> Stream Double -> Stream Bool
approx l r = false


-- In contrast to `altitudeAvg` (which can not deal with erratic behaviour of
-- a faulty sensor properly), we want a reliable way to determine the current
-- altitude.  To achieve this, we will use majority voting:
-- https://en.wikipedia.org/wiki/Boyer-Moore_majority_vote_algorithm
--
-- In the voting library there are two functions:
-- majorityWith
--  => (Stream a -> Stream a -> Stream Bool) -- ^ Comparison function
--  -> [Stream a]                            -- ^ Vote streams
--  -> Stream a                              -- ^ Result: Candidate stream
--
-- aMajorityWith ::
--  => (Stream a -> Stream a -> Stream Bool) -- ^ Comparison function
--  -> [Stream a]                            -- ^ Vote streams
--  -> Stream a                              -- ^ Candidate stream
--  -> Stream Bool                -- ^ Result: True if candidate holds majority
--
--  `majorityWith` finds the most common value, `aMajorityWith` checks if this
--  value holds a majority in the list of values. Both functions take a
--  function to use for comparison.

-- [Exercise]
-- Using majority voting, calculate the most common value of the altimeters.
altitudeVoted :: Stream Double
altitudeVoted = 0

-- [Exercise]
-- Still using majority voting, determine if the value of `altitudeVoted` is
-- trustworthy, i.e. does the selected value (by altitudeVoted) hold for at
-- least 50% of the 3 altimeters (at least 2 out of 3 in this case).
altitudeVoted_trustworthy :: Stream Bool
altitudeVoted_trustworthy = false


-------------------------------------------------------------------------------


-- The derivative of voted altitude over time.
daltitudeVoted_dt :: Stream Double
daltitudeVoted_dt = deriv altitudeVoted time


-- Property that checks if the altitude does not change abruptly. In this case
-- it should stay < 15 m/s^2 in either direction.
isStable :: (Num a, Ord a, Typed a) => Stream a -> Stream Bool
isStable sx = abs sx < 15


spec :: Spec
spec = do
  -- Just trigger that helps us debug things.
  trigger "debug" true
    [ arg time

    , arg altitudeAvg
    , arg daltitudeAvg_dt

    , arg altitudeVoted
    , arg daltitudeVoted_dt
    , arg altitudeVoted_trustworthy
    ]

  -- Some local definitions to make the triggers easier to read.
  let avg_violated   = not (isStable daltitudeAvg_dt)
      voted_violated = not (isStable daltitudeVoted_dt)

  trigger "avg_violated"   avg_violated   [arg daltitudeAvg_dt]
  trigger "voted_violated" voted_violated [arg daltitudeVoted_dt]

  trigger "voted_not_trustworthy" (not altitudeVoted_trustworthy) []


-- Compile the specification to with output name 'uav-monitor'.
main = reify spec >>= compile "uav-monitor"
