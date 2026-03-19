{-|
Module      : Botan.Low.XOF
Description : TODO
Copyright   : (c) 2023-2024, Apotheca Labs
              (c) 2024-2025, Haskell Foundation
License     : BSD-3-Clause
Maintainer  : joris@well-typed.com, leo@apotheca.io
Stability   : experimental
Portability : POSIX

TODO
-}

module Botan.Low.XOF (
    XOF(..)
  , XOFName
  , XOFDigest
  , pattern AES_CRYSTALS
  , pattern ASCON_XOF128
  , pattern CSHAKE128   
  , pattern CSHAKE256   
  , pattern SHAKE128    
  , pattern SHAKE256    
  , withXOF
  , xofInit
  , xofCopyState
  , xofBlockSize
  , xofName
  , xofAcceptsInput
  , xofClear
  , xofUpdate
  , xofOutput
  , xofDestroy
  ) where

import           Botan.Bindings.XOF
import           Botan.Low.Error.Internal
import           Botan.Low.Internal.ByteString
import           Botan.Low.Internal.String
import           Botan.Low.Make
import           Botan.Low.Remake
import           Data.ByteString
import           Data.Word (Word8)
import           Foreign.C.Types
import           Foreign.ForeignPtr
import           Foreign.Ptr

newtype XOF = MkXOF { foreignPtr :: ForeignPtr BotanXOFStruct }

withXOF :: XOF -> (BotanXOF -> IO a) -> IO a
xofDestroy :: XOF -> IO ()
createXOF :: (Ptr BotanXOF -> IO CInt) -> IO XOF
(withXOF, xofDestroy, createXOF)
    = mkBindings
        MkBotanXOF (.ptr)
        MkXOF (.foreignPtr)
        botan_xof_destroy

type XOFName = ByteString

type XOFDigest = ByteString

xofInit
    :: XOFName
    -> IO XOF
xofInit = mkCreateObjectCString createXOF $ \ out name -> 
    botan_xof_init out name 0

xofCopyState
    :: XOF
    -> IO XOF
xofCopyState source = withXOF source $ \ sourcePtr -> do
    createXOF $ \ dest -> botan_xof_copy_state dest sourcePtr

xofBlockSize
    :: XOF
    -> IO Int
xofBlockSize = mkGetSize withXOF botan_xof_block_size

xofName
    :: XOF
    -> IO XOFDigest
xofName = mkGetCString withXOF botan_xof_name

xofAcceptsInput
    :: XOF
    -> IO Bool
xofAcceptsInput = mkGetBoolCode withXOF botan_xof_accepts_input

xofClear
    :: XOF
    -> IO ()
xofClear = mkAction withXOF botan_xof_clear

xofUpdate
    :: XOF
    -> ByteString
    -> IO ()
xofUpdate = mkWithObjectSetterCBytesLen withXOF botan_xof_update

xofOutput
    :: XOF
    -> Int
    -> IO XOFDigest
xofOutput xof sz = withXOF xof $ \ xofPtr -> do
    allocBytes sz $ \ digestPtr -> do
        throwBotanIfNegative_ $ botan_xof_output xofPtr digestPtr $ fromIntegral sz

pattern AES_CRYSTALS
    ,   ASCON_XOF128
    ,   CSHAKE128
    ,   CSHAKE256
    ,   SHAKE128
    ,   SHAKE256
    :: XOFName
pattern AES_CRYSTALS = BOTAN_XOF_AES_CRYSTALS
pattern ASCON_XOF128 = BOTAN_XOF_ASCON_XOF128
pattern CSHAKE128    = BOTAN_XOF_CSHAKE_256
pattern CSHAKE256    = BOTAN_XOF_CSHAKE_256
pattern SHAKE128     = BOTAN_XOF_SHAKE_256
pattern SHAKE256     = BOTAN_XOF_SHAKE_256

allXOFs :: [XOFName]
allXOFs =
    [ AES_CRYSTALS
    , ASCON_XOF128
    , CSHAKE128
    , CSHAKE256
    , SHAKE128
    , SHAKE256
    ]
