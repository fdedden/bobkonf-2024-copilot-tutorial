{-# LANGUAGE RebindableSyntax #-}

module Voting
  ( majorityWith
  , aMajorityWith
  )
where

import Copilot.Language
import qualified Prelude as P

-- | Majority vote first pass: choosing a candidate.
majorityWith :: (Typed a)
  => (Stream a -> Stream a -> Stream Bool) -- ^ Comparison function
  -> [Stream a] -- ^ Vote streams
  -> Stream a -- ^ Candidate stream
majorityWith f []     = badUsage "majority: empty list not allowed"
majorityWith f (x:xs) = majorityWith' f xs x 1

-- Alternate syntax of local bindings.
majorityWith' :: (Typed a)
   => (Stream a -> Stream a -> Stream Bool)
   -> [Stream a] -> Stream a -> Stream Word32 -> Stream a
majorityWith' f []     can _   = can
majorityWith' f (x:xs) can cnt =
  local (cnt == 0) inZero
  where
  inZero zero    = local (if zero then x else can) inCan
    where
    inCan can' =
        -- We include a special case for when `xs` is empty that immediately
        -- returns `can'`. We could omit this special case without changing the
        -- final result, but this has the downside that `local` would bind a
        -- local variable that would go unused in `inCnt`. (Note that `inCnt`
        -- recursively invokes `majority'`, which doesn't use its last argument
        -- if the list of vote streams is empty.) These unused local variables
        -- would result in C code that triggers compiler warnings.
        case xs of
          [] -> can'
          _  -> local (if zero || x `f` can then cnt+1 else cnt-1) inCnt
      where
      inCnt cnt' = majorityWith' f xs can' cnt'

-- | Majority vote second pass: checking that a candidate indeed has more than
-- half the votes.
aMajorityWith :: (Typed a)
  => (Stream a -> Stream a -> Stream Bool)
  -> [Stream a] -- ^ Vote streams
  -> Stream a -- ^ Candidate stream
  -> Stream Bool -- ^ True if candidate holds majority
aMajorityWith f [] _ = badUsage "aMajority: empty list not allowed"
aMajorityWith f xs can =
  let
    cnt = aMajorityWith' f 0 xs can
  in
    (cnt * 2) > fromIntegral (length xs)

aMajorityWith' :: (Typed a)
  => (Stream a -> Stream a -> Stream Bool)
  -> Stream Word32 -> [Stream a] -> Stream a -> Stream Word32
aMajorityWith' f cnt []     _   = cnt
aMajorityWith' f cnt (x:xs) can =
  local (if x `f` can then cnt+1 else cnt) $ \ cnt' ->
    aMajorityWith' f cnt' xs can
