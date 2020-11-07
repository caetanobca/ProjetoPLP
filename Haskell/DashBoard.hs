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
    , fill
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
    [ (B.borderAttr,         V.black `on` V.brightBlack)
    , (titleAttr,            V.white `on` V.brightBlack)
    , (corpoAttr,            V.white `on` V.brightBlack)
    ]

estoqueWdgt :: String -> Widget ()
estoqueWdgt string = hBox[(withAttr corpoAttr $ fill ' ')
                    ,(withAttr corpoAttr $ str string) 
                    ,(withAttr corpoAttr $ fill ' ')]


caixaFixa :: String -> String -> Widget ()
caixaFixa representacao string =
    updateAttrMap (A.applyAttrMappings borderMappings) $
    B.borderWithLabel (withAttr titleAttr $ str representacao) $
    vLimit 10 $
    C.center $
    if (representacao == "Estoque") then estoqueWdgt string
    else (  ((withAttr corpoAttr $ str string
            <+> (withAttr corpoAttr $ fill ' '))
            <=> (withAttr corpoAttr $ fill ' '))
            <+> (withAttr corpoAttr $ fill ' '))
   
    

caixaQtd :: String -> String -> Widget ()
caixaQtd representacao string =
    updateAttrMap (A.applyAttrMappings borderMappings) $
    B.borderWithLabel (withAttr titleAttr $ str representacao) $
    vLimit 3 $
    C.center $
    hBox[(withAttr corpoAttr $ str (string ++ " " ++ representacao ++ " Cadastrado(s)"))
          ,(withAttr corpoAttr $ fill ' ')]


caixaLateral :: String -> (String, String) -> Widget ()
caixaLateral representacao texto =
    updateAttrMap (A.applyAttrMappings borderMappings) $
    B.borderWithLabel (withAttr titleAttr $ str representacao) $
    vLimit 4 $
    C.center $
    hBox[((withAttr corpoAttr $ str ("Estoque no ano passado: "  ++ snd texto  ++ " mililitros (ml)\nEstoque atual: " ++ fst texto ++ " mililitros (ml)"))
        <=> (withAttr corpoAttr $ fill ' '))
        ,(withAttr corpoAttr $ fill ' ')]
    


ui :: String -> String -> String -> String -> String -> String -> String -> (String, String) -> Widget ()
ui estoque doador recebedor enfermeiros impedimentos escala agenda historicoEstoque =
    updateAttrMap (A.applyAttrMappings borderMappings) $
    B.borderWithLabel (withAttr titleAttr $ str "DASHBOARD") $
    (vBox [hBox [(caixaFixa "Estoque" ("\n" ++ estoque))
           ,vBox [(caixaLateral "Historico de Estoque" historicoEstoque)
           ,(caixaLateral "Estoque" historicoEstoque)]]
           ,(caixaFixa "Agenda" agenda)
           ,(caixaFixa "Escala de enfermeiros" escala)
           ,hBox [(caixaQtd "Enfermeiro(s)" enfermeiros)
            ,(caixaQtd "Impedimento(s)" impedimentos)
            ,(caixaQtd "Doadore(s)" doador)
            ,(caixaQtd "Recebedore(s)" recebedor)]])
    
    

criarDashBoard :: String -> String -> String -> String  -> String -> String -> String -> (String, String) -> IO ()
criarDashBoard estoque doador recebedor enfermeiros impedimentos escala agenda historicoEstoque =
    M.simpleMain (ui estoque doador recebedor enfermeiros impedimentos escala agenda historicoEstoque)

