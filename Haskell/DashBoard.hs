{-# LANGUAGE CPP #-}
{-# LANGUAGE OverloadedStrings #-}
module DashBoard where

#if !MIN_VERSION_base(4,8,0)
import Control.Applicative ((<$>))
#endif

#if !(MIN_VERSION_base(4,11,0))
import Data.Monoid ((<>))
#endif

import qualified Data.Text as T
import qualified Graphics.Vty as V

import qualified Brick.Main as M
import Brick.Util (fg, on)
import qualified Brick.AttrMap as A
import Brick.Types
    ( Widget
    )
import Brick.Widgets.Core
    ( (<=>)
    , (<+>)
    , withAttr
    , vLimit
    , hLimit
    , hBox
    , updateAttrMap
    , withBorderStyle
    , txt
    , str
    )
import qualified Brick.Widgets.Center as C
import qualified Brick.Widgets.Border as B
import qualified Brick.Widgets.Border.Style as BS



titleAttr :: A.AttrName
titleAttr = "DASHBOARD"

borderMappings :: [(A.AttrName, V.Attr)]
borderMappings =
    [ (B.borderAttr,         V.yellow `on` V.black)
    , (titleAttr,            V.blue `on` V.white)
    ]

caixaFixa :: String -> String -> Widget ()
caixaFixa representacao string =
    updateAttrMap (A.applyAttrMappings borderMappings) $
    B.borderWithLabel (withAttr titleAttr $ str representacao) $
    hLimit 20 $
    vLimit 8 $
    C.center $
    str string

caixaTamVariado :: Int-> Int-> String -> String -> Widget ()
caixaTamVariado h v representacao string =
    updateAttrMap (A.applyAttrMappings borderMappings) $
    B.borderWithLabel (withAttr titleAttr $ str representacao) $
    hLimit h $
    vLimit v $
    C.center $
    str string


ui :: String -> String -> String -> String -> String -> Widget ()
ui estoque doador recebedor enfermeiros impedimentos =
    hBox [(caixaFixa "Estoque" estoque)
        ,(caixaFixa "Doadores" doador)
        ,(caixaFixa "Recebedores" recebedor)]
    <=> hBox [(caixaFixa "Enfermeiros" enfermeiros)
        ,(caixaFixa "Impedimentos" impedimentos)]



criarDashBoard :: String -> String -> String -> String  -> String -> IO ()
criarDashBoard estoque doador recebedor enfermeiros impedimentos  = M.simpleMain (ui estoque doador recebedor enfermeiros impedimentos)

