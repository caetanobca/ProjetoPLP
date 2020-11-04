module Estoque where
  import Data.Map as Map
  import Data.Char
  import Data.Maybe
  import Bolsa
  import Data.Map as Map

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

  verificaEstoque:: String -> Int -> [Bolsa.Bolsa] -> Maybe Bolsa.Bolsa
  verificaEstoque " " 0 [] = Nothing
  verificaEstoque tipoProcurado qntBlood bolsas =
    if([ x |x <- bolsas, Bolsa.tipoSanguineo x == tipoProcurado] /= [])
      then if (bolsasValidas /= [])
        then Just (bolsasValidas!!0)
        else Nothing
    else verificaEstoque " " 0 []

    where bolsasValidas = [x | x <- bolsas,verificaMlDaBolsa qntBlood x /= Nothing]

  removeBolsa :: Maybe Bolsa -> [Bolsa] -> [Bolsa]
  removeBolsa _ [] = []
  removeBolsa bolsa_procurada (h:t)
    |bolsa_procurada == Just h = removeBolsa bolsa_procurada t
    |otherwise = (h : removeBolsa bolsa_procurada t)
   
  verificaMlDaBolsa::Int -> Bolsa.Bolsa -> Maybe Bolsa.Bolsa
  verificaMlDaBolsa qntBlood bolsa  
    | Bolsa.qtdSangue bolsa > qntBlood = Just bolsa
    | Bolsa.qtdSangue bolsa == qntBlood = Just bolsa
    | otherwise = Nothing
 

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
  estoqueEmMapa :: [Bolsa.Bolsa] -> Map String String -> String -> [(String, String)]
  estoqueEmMapa estoque mapa mes = Map.toList(insert mes (show (totalSangue estoque)) mapa)
  
  
  {-
    Retorna o total de sangue do banco (em ml)-}
  totalSangue :: [Bolsa.Bolsa] -> Int
  totalSangue [] = 0
  totalSangue (h:t) = qtdSangue h + totalSangue t
