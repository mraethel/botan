{-# LANGUAGE OverloadedStrings #-}

module Test.Botan.Low.XOF (tests) where

import           Botan.Low.XOF
import           Control.Monad
import           Data.ByteString
import           Test.Hspec
import           Test.Tasty
import           Test.Tasty.Hspec
import           Test.Util.ByteString
import           Test.Util.Hspec

tests :: IO TestTree
tests = do
    specs <- testSpec "spec_xof" spec_xof
    pure $ testGroup "Test.Botan.Low.XOF" [
        specs
      ]

message :: ByteString
message = "Fee fi fo fum! I smell the blood of an Englishman!"

spec_xof :: Spec
spec_xof = testSuite allXOFs chars $ \ h -> do
    it "can initialize a XOF context" $ do
        _ctx <- xofInit h
        pass
    it "can copy the internal state" $ do
        ctx <- xofInit h
        -- TODO: Populate with state and actually prove
        _ctx' <- xofCopyState ctx
        pass
    it "has a name" $ do
        ctx <- xofInit h
        _name <- xofName ctx
        pass
    it "can clear all internal state" $ do
        ctx <- xofInit h
        -- TODO: Populate with state and actually prove
        xofClear ctx
        pass
    it "can update the internal state with a single message block" $ do
        ctx <- xofInit h
        xofUpdate ctx message
        pass
    it "can update the internal state with multiple message blocks" $ do
        ctx <- xofInit h
        forM_ (splitBlocks 4 message) $ xofUpdate ctx
        pass
    it "can output a single digest block" $ do
        ctx <- xofInit h
        xofUpdate ctx message
        _d <- xofFinal ctx
        pass
    it "can output a multiple digest blocks" $ do
        ctx <- xofInit h
        xofUpdate ctx message
        _d <- xofFinal ctx
        pass
