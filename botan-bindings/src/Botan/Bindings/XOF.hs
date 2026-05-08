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
  , botan_xof_init
  , botan_xof_copy_state
  , botan_xof_block_size
  , botan_xof_name
  , botan_xof_accepts_input
  , botan_xof_clear
  , botan_xof_update
  , botan_xof_output
  , botan_xof_destroy
  , pattern BOTAN_XOF_ASCON_XOF128
  , pattern BOTAN_XOF_SHAKE_128_XOF
  , pattern BOTAN_XOF_SHAKE_256_XOF
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

-- | Frees all resources of the XOF object
foreign import capi safe "botan/ffi.h &botan_xof_destroy"
    botan_xof_destroy
        :: FinalizerPtr BotanXOFStruct

-- | Initialize an XOF
foreign import capi safe "botan/ffi.h botan_xof_init"
    botan_xof_init
        :: Ptr BotanXOF   -- ^ __xof__
        -> ConstPtr CChar -- ^ __xof_name__
        -> Word32         -- ^ __flags__
        -> IO CInt

-- | Copy the state of an XOF
foreign import capi safe "botan/ffi.h botan_xof_copy_state"
    botan_xof_copy_state
        :: Ptr BotanXOF -- ^ __dest__
        -> BotanXOF     -- ^ __source__
        -> IO CInt

-- | Writes the block size of the XOF to *block_size
foreign import capi safe "botan/ffi.h botan_xof_block_size"
    botan_xof_block_size
        :: BotanXOF  -- ^ __xof__
        -> Ptr CSize -- ^ __block_size__
        -> IO CInt

-- | Get the name of this XOF
foreign import capi safe "botan/ffi.h botan_xof_name"
    botan_xof_name
        :: BotanXOF  -- ^ __xof__
        -> Ptr CChar -- ^ __name__
        -> Ptr CSize -- ^ __name_len__
        -> IO CInt

-- | Get the input/output state of this XOF. Typically, XOFs don't accept input as soon as the first output bytes were requested.
foreign import capi safe "botan/ffi.h botan_xof_accepts_input"
    botan_xof_accepts_input
        :: BotanXOF -- ^ __xof__
        -> IO CInt

-- | Reinitializes the state of the XOF
foreign import capi safe "botan/ffi.h botan_xof_clear"
    botan_xof_clear
        :: BotanXOF -- ^ __xof__
        -> IO CInt

-- | Send more input to the XOF
foreign import capi safe "botan/ffi.h botan_xof_update"
    botan_xof_update
        :: BotanXOF       -- ^ __xof__
        -> ConstPtr Word8 -- ^ __in__
        -> CSize          -- ^ __in_len__
        -> IO CInt

-- | Generate output bytes from the XOF
foreign import capi safe "botan/ffi.h botan_xof_output"
    botan_xof_output
        :: BotanXOF  -- ^ __xof__
        -> Ptr Word8 -- ^ __out__
        -> CSize     -- ^ __out_len__
        -> IO CInt

pattern BOTAN_XOF_ASCON_XOF128
    ,   BOTAN_XOF_SHAKE_128_XOF
    ,   BOTAN_XOF_SHAKE_256_XOF
    ::  (Eq a, IsString a) => a
pattern BOTAN_XOF_ASCON_XOF128 = "Ascon-XOF128"
pattern BOTAN_XOF_SHAKE_128_XOF = "SHAKE-128"
pattern BOTAN_XOF_SHAKE_256_XOF = "SHAKE-256"
