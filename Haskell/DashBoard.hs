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

import Brick
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
titleAttr = "titulo"

corpoAttr :: A.AttrName
corpoAttr = "corpo"

borderMappings :: [(A.AttrName, V.Attr)]
borderMappings =
    [ (B.borderAttr,         fg V.white)
    , (titleAttr,            fg V.white)
    , (corpoAttr,            fg V.white)
    ]

estoqueWdgt :: String -> Widget ()
estoqueWdgt string = (withAttr corpoAttr $ str string) 



caixaEstoque :: String -> String -> Widget ()
caixaEstoque representacao string =
    updateAttrMap (A.applyAttrMappings borderMappings) $
    B.borderWithLabel (withAttr titleAttr $ str representacao) $
    vLimit 10 $
    C.center $
    estoqueWdgt string
   
caixaFixa :: String -> String -> Widget ()
caixaFixa representacao string =
    updateAttrMap (A.applyAttrMappings borderMappings) $
    B.borderWithLabel (withAttr titleAttr $ str representacao) $
    vLimit 8 $
    C.center $
    ((withAttr corpoAttr $ str string))


caixaQtd :: String -> String -> Widget ()
caixaQtd representacao string =
    updateAttrMap (A.applyAttrMappings borderMappings) $
    B.borderWithLabel (withAttr titleAttr $ str representacao) $
    vLimit 3 $
    C.center $
    (withAttr corpoAttr $ str (string ++ " " ++ representacao ++ " Cadastrado(s)"))


caixaLateral :: String -> (String, String) -> Widget ()
caixaLateral representacao texto =
    updateAttrMap (A.applyAttrMappings borderMappings) $
    B.borderWithLabel (withAttr titleAttr $ str representacao) $
    vLimit 4 $
    C.center $
    (withAttr corpoAttr $ str ("\nEstoque no ano passado: "  ++ fst texto  ++ " mililitros (ml)\nEstoque atual: " ++ snd texto ++ " mililitros (ml)"))
 

letreiroWidget :: Widget ()
letreiroWidget  =
    updateAttrMap (A.applyAttrMappings borderMappings) $
    B.borderWithLabel (withAttr titleAttr $ str "") $
    vLimit 4 $
    C.center $
    (withAttr corpoAttr $ str letreiroStr)

letreiroStr :: String
letreiroStr = (
    " _                       _   \n" ++    
    "|_) |  _   _   _| |  o _|_ _    \n" ++
    "|_) | (_) (_) (_| |_ |  | (/_   \n"  )


ui :: String -> String -> String -> String -> String -> String -> String -> (String, String) -> Widget ()
ui estoque doador recebedor enfermeiros impedimentos escala agenda historicoEstoque =
    updateAttrMap (A.applyAttrMappings borderMappings) $
    B.borderWithLabel (withAttr titleAttr $ str "DASHBOARD") $
    (vBox [hBox [vBox [ letreiroWidget
                ,(caixaLateral " Historico de Estoque "  historicoEstoque)]
           ,(caixaEstoque " Estoque " ("\n" ++ estoque))]
           ,(caixaFixa " Agenda para hoje " agenda)
           ,(caixaFixa " Escala de enfermeiros para hoje " escala)
           ,hBox [(caixaQtd " Enfermeiro(s) " enfermeiros)
            ,(caixaQtd " Impedimento(s) " impedimentos)
            ,(caixaQtd " Doadore(s) " doador)
            ,(caixaQtd " Recebedore(s) " recebedor)]])
    

criarDashBoard :: String -> String -> String -> String  -> String -> String -> String -> (String, String) -> IO ()
criarDashBoard estoque doador recebedor enfermeiros impedimentos escala agenda historicoEstoque =
    M.simpleMain (ui estoque doador recebedor enfermeiros impedimentos escala agenda historicoEstoque)

