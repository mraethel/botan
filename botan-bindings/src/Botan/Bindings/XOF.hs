{-|
Module      : Botan.Bindings.XOF
Description : TODO
Copyright   : (c) 2023-2024, Apotheca Labs
              (c) 2024-2025, Haskell Foundation
License     : BSD-3-Clause
Maintainer  : joris@well-typed.com, leo@apotheca.io
Stability   : experimental
Portability : POSIX

TODO
-}

{-# LANGUAGE CApiFFI           #-}
{-# LANGUAGE OverloadedStrings #-}

module Botan.Bindings.XOF (
    BotanXOFStruct
  , BotanXOF (..)
  , pattern BOTAN_XOF_AES_CRYSTALS
  , pattern BOTAN_XOF_ASCON_XOF128
  , pattern BOTAN_XOF_CSHAKE_128
  , pattern BOTAN_XOF_CSHAKE_256
  , pattern BOTAN_XOF_SHAKE_128
  , pattern BOTAN_XOF_SHAKE_256
  , botan_xof_init
  , botan_xof_copy_state
  , botan_xof_block_size
  , botan_xof_name
  , botan_xof_accepts_input
  , botan_xof_clear
  , botan_xof_update
  , botan_xof_output
  , botan_xof_destroy
  ) where

import Botan.Bindings.ConstPtr
import Data.String
import Data.Word
import Foreign.C.Types
import Foreign.ForeignPtr
import Foreign.Ptr
import Foreign.Storable

-- | Opaque XOF struct
data {-# CTYPE "botan/ffi.h" "struct botan_xof_struct" #-} BotanXOFStruct

-- | Botan XOF object
newtype {-# CTYPE "botan/ffi.h" "botan_xof_t" #-} BotanXOF
    = MkBotanXOF { ptr :: Ptr BotanXOFStruct }
        deriving newtype (Eq, Ord, Storable)

-- | Initialize an XOF
foreign import capi safe "botan/ffi.h botan_xof_init"
    botan_xof_init
        :: Ptr BotanXOF
        -> ConstPtr CChar
        -> Word32
        -> IO CInt

-- | Copy the state of an XOF
foreign import capi safe "botan/ffi.h botan_xof_copy_state"
    botan_xof_copy_state
        :: Ptr BotanXOF
        -> BotanXOF
        -> IO CInt

-- | Writes the block size of the XOF to *block_size
foreign import capi safe "botan/ffi.h botan_xof_block_size"
    botan_xof_block_size
        :: BotanXOF
        -> Ptr CSize
        -> IO CInt

-- | Get the name of this XOF
foreign import capi safe "botan/ffi.h botan_xof_name"
    botan_xof_name
        :: BotanXOF
        -> Ptr CChar
        -> Ptr CSize
        -> IO CInt

-- | Get the input/output state of this XOF. Typically, XOFs don't accept input as soon as the first output bytes were requested.
foreign import capi safe "botan/ffi.h botan_xof_accepts_input"
    botan_xof_accepts_input
        :: BotanXOF
        -> IO CInt

-- | Reinitializes the state of the XOF
foreign import capi safe "botan/ffi.h botan_xof_clear"
    botan_xof_clear
        :: BotanXOF
        -> IO CInt

-- | Send more input to the XOF
foreign import capi safe "botan/ffi.h botan_xof_update"
    botan_xof_update
        :: BotanXOF
        -> ConstPtr Word8
        -> CSize
        -> IO CInt

-- | Generate output bytes from the XOF
foreign import capi safe "botan/ffi.h botan_xof_output"
    botan_xof_output
        :: BotanXOF
        -> Ptr Word8
        -> CSize
        -> IO CInt

-- | Frees all resources of the XOF object
foreign import capi safe "botan/ffi.h &botan_xof_destroy"
    botan_xof_destroy
        :: FinalizerPtr BotanXOFStruct

pattern BOTAN_XOF_AES_CRYSTALS
    ,   BOTAN_XOF_ASCON_XOF128
    ,   BOTAN_XOF_CSHAKE_128
    ,   BOTAN_XOF_CSHAKE_256
    ,   BOTAN_XOF_SHAKE_128
    ,   BOTAN_XOF_SHAKE_256
    ::  (Eq a, IsString a) => a
pattern BOTAN_XOF_AES_CRYSTALS = "AES-CRYSTALS"
pattern BOTAN_XOF_ASCON_XOF128 = "ASCON-XOF128"
pattern BOTAN_XOF_CSHAKE_128 = "CSHAKE-128"
pattern BOTAN_XOF_CSHAKE_256 = "CSHAKE-256"
pattern BOTAN_XOF_SHAKE_128 = "SHAKE-XOF128"
pattern BOTAN_XOF_SHAKE_256 = "SHAKE-XOF256"
