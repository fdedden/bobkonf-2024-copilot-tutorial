{-# LANGUAGE RebindableSyntax #-}

module Main where

import Language.Copilot

-------------------------------------------------------------------------------

-- [Exercise]
-- Define a stream that starts at `True` and alternates between `False` and
-- `True` after that, e.g.:
-- trueFalse ~> {T, F, T, F, T, F, ...}
trueFalse :: Stream Bool
trueFalse = [True, False] ++ trueFalse

-- Alternative implementation.
trueFalse' = [True] ++ not trueFalse'

-------------------------------------------------------------------------------

-- A specification that just shows the value of `trueFalse` while using the
-- interpreter.
spec :: Spec
spec = observer "trueFalse" trueFalse

-- Run the specification for 30 iterations.
main = interpret 30 spec
