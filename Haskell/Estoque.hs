module Estoque where
  import Data.Map as Map
  import Data.Char
  import Data.Maybe
  import Bolsa
  import Data.Map as Map
  import Data.Time

  adicionaBolsa:: String -> Int -> Bolsa.Bolsa
  adicionaBolsa tipoSanguineo qtdSangue = (Bolsa.Bolsa (toUpperCase tipoSanguineo) qtdSangue)

  listaTodasAsBolsas:: [Bolsa.Bolsa] -> String
  listaTodasAsBolsas [] = " " 
  listaTodasAsBolsas (h:t) = (imprimeBolsa (Bolsa.tipoSanguineo h) (Bolsa.qtdSangue h)) ++ listaTodasAsBolsas t 

  listaBolsasPorTipo::  String -> [Bolsa.Bolsa] -> String
  listaBolsasPorTipo _ [] = "Não há bolsas desse tipo\n"
  listaBolsasPorTipo tipoProcurado bolsas
   | elem (toUpperCase tipoProcurado) tipos = listaTodasAsBolsas [ x |x <- bolsas,Bolsa.tipoSanguineo x == (toUpperCase tipoProcurado)]
   | otherwise = listaBolsasPorTipo " " []
   where tipos = ["O-","O+","A-","A+","B+","B-","AB+","AB-"]

  
  verificaQtdBolsas:: Int -> String -> [Bolsa] -> [Bolsa]
  verificaQtdBolsas 0 _ [] = []
  verificaQtdBolsas _ _ [] = []
  verificaQtdBolsas qtdBolsas tipoProcurado (h:t)
    |tipoProcurado == tipoSanguineo h = [h] ++ verificaQtdBolsas (qtdBolsas - 1) tipoProcurado t
    |otherwise = verificaQtdBolsas qtdBolsas tipoProcurado t

  removeBolsa :: Bolsa -> Int -> [Bolsa] -> [Bolsa]
  removeBolsa _ _ [] = []
  removeBolsa _ 0 estoque = estoque
  removeBolsa bolsa_procurada num_bolsas (h:t)
    |bolsa_procurada == h = removeBolsa bolsa_procurada (num_bolsas - 1) t
    |otherwise = (h : removeBolsa bolsa_procurada num_bolsas t)
   
  avisaRemocao :: Bolsa -> String
  avisaRemocao bolsa_removida = "Bolsa com " ++ show (qtdSangue bolsa_removida) ++ " ml de sangue do tipo " ++
              tipoSanguineo bolsa_removida ++ " retirada com sucesso!"

  toUpperCase :: String -> String
  toUpperCase entrada = [toUpper x | x <- entrada]


  imprimeBolsa:: String -> Int -> String
  imprimeBolsa tipo qtd = "(Bolsa): >Tipo: " ++ tipo ++ " >Quantidade(em ml): " ++ show qtd ++ "\n"

  bolsaRetiradaToString:: Maybe Bolsa -> Int -> String
  bolsaRetiradaToString (Just bolsa) 0 = "[RETIRADA TOTAL] " ++ imprimeBolsa (tipoSanguineo bolsa) (qtdSangue bolsa)
  bolsaRetiradaToString (Just bolsa) qtdRetirada = "[RETIRADA PARCIAL] " ++ imprimeBolsa (tipoSanguineo bolsa) qtdRetirada

  buscaBolsa:: String -> Int -> [Bolsa] -> Maybe Bolsa
  buscaBolsa tipo_procurado qtd_procurada [] = Nothing
  buscaBolsa tipo_procurado qtd_procurada (h:t)
   |tipo_procurado == (tipoSanguineo h) && qtd_procurada == (qtdSangue h) = Just h
   |otherwise = buscaBolsa tipo_procurado qtd_procurada t


  totalSanguePorTipo:: String -> [Bolsa] -> Int
  totalSanguePorTipo tipo [] = 0
  totalSanguePorTipo tipo (h:t)
   | tipo == tipoSanguineo h = qtdSangue h + totalSanguePorTipo tipo t
   | otherwise = totalSanguePorTipo tipo t

  visaoGeralEstoque:: [Bolsa] -> String
  visaoGeralEstoque listaEstoque = "O-:" ++ show (totalSanguePorTipo("O-") listaEstoque) ++ " ml" ++ "\n" ++
        "O+:" ++ show (totalSanguePorTipo("O+") listaEstoque)++ " ml" ++ "\n" ++
        "A-:" ++ show (totalSanguePorTipo("A-") listaEstoque)++ " ml"++ "\n" ++
        "A+:" ++ show (totalSanguePorTipo("A+") listaEstoque)++ " ml"++ "\n" ++
        "B-:" ++ show (totalSanguePorTipo("B-") listaEstoque)++ " ml"++ "\n" ++      
        "B+:" ++ show (totalSanguePorTipo("B+") listaEstoque)++ " ml"++ "\n" ++
        "AB-:" ++ show (totalSanguePorTipo("AB-") listaEstoque)++ " ml"++ "\n" ++    
        "AB+:" ++ show (totalSanguePorTipo("AB+") listaEstoque)++ " ml"++ "\n\n"


  mensagemDeAviso:: [Bolsa] -> Int -> String
  mensagemDeAviso _ 8 = "\n"
  mensagemDeAviso estoque i
   |(totalSanguePorTipo (tipos !! i) estoque < 1000 ) = "Está faltando sangue do tipo " ++ (tipos !! i) ++ "! " ++
    "(" ++ show (totalSanguePorTipo (tipos !! i) estoque) ++ " ml restantes)" ++ "\n" ++ mensagemDeAviso estoque (i+1)
   |(totalSanguePorTipo (tipos !! i) estoque > 10000 ) = "Está sobrando sangue do tipo " ++ (tipos !! i) ++ 
    "Há " ++ show (totalSanguePorTipo (tipos !! i) estoque) ++ " ml, é uma boa ideia doar para outra instutuição que precise!" ++"\n" ++  mensagemDeAviso estoque (i+1)
   |otherwise = mensagemDeAviso estoque (i+1)
   where tipos = ["O-","O+","A-","A+","B+","B-","AB+","AB-"]
  
  
  {-
    pega uma lista de tuplas onde o primeiro elemento eh o mes e o segundo a qtd de sangue no estoque-}
  estoqueEmMapa :: [Bolsa.Bolsa] -> Map String String -> Day -> [(String, String)]
  estoqueEmMapa estoque mapa dia = Map.toList(insert diaMes (show (totalSangue estoque)) mapa)
    where diaMes = (getDiaMes (toGregorian dia))
  
  getDiaMes :: (a, Int, Int) -> String
  getDiaMes (_, x, y) = (show y ++ "-" ++ show x)
    
  
  {-
    Retorna o total de sangue do banco (em ml)-}
  totalSangue :: [Bolsa.Bolsa] -> Int
  totalSangue [] = 0
  totalSangue (h:t) = qtdSangue h + totalSangue t
