module Estoque where
  import Data.Map as Map
  import Data.Char
  import Data.Maybe
  import Bolsa
  import Data.Map as Map

  adicionaBolsa:: String -> Int -> Bolsa.Bolsa
  adicionaBolsa tipoSanguineo qtdSangue = (Bolsa.Bolsa (toUpperCase tipoSanguineo) qtdSangue)
  -- tem que escrever em um arquivo pra conseguir saber quais bolsas estao cadastradas

  listaTodasAsBolsas:: [Bolsa.Bolsa] -> String
  listaTodasAsBolsas [] = " " 
  listaTodasAsBolsas (h:t) = (imprimeBolsa (Bolsa.tipoSanguineo h) (Bolsa.qtdSangue h)) ++ listaTodasAsBolsas t 

  listaBolsasPorTipo::  String -> [Bolsa.Bolsa] -> String
  listaBolsasPorTipo _ [] = " "
  listaBolsasPorTipo tipoProcurado bolsas
    | toUpperCase tipoProcurado == "O-" = listaTodasAsBolsas [ x |x <- bolsas,Bolsa.tipoSanguineo x == "O-"]
    | toUpperCase tipoProcurado == "O+" = listaTodasAsBolsas [ x |x <- bolsas, Bolsa.tipoSanguineo x == "O+"]
    | toUpperCase tipoProcurado == "A-" = listaTodasAsBolsas [ x |x <- bolsas, Bolsa.tipoSanguineo x == "A-"]  
    | toUpperCase tipoProcurado == "A+" = listaTodasAsBolsas [ x |x <- bolsas, Bolsa.tipoSanguineo x == "A+"]
    | toUpperCase tipoProcurado == "B-" = listaTodasAsBolsas [ x |x <- bolsas, Bolsa.tipoSanguineo x == "B-"]  
    | toUpperCase tipoProcurado == "B+" = listaTodasAsBolsas [ x |x <- bolsas, Bolsa.tipoSanguineo x == "B+"]
    | toUpperCase tipoProcurado == "AB-" = listaTodasAsBolsas [ x |x <- bolsas, Bolsa.tipoSanguineo x == "AB-"]
    | toUpperCase tipoProcurado == "AB+" = listaTodasAsBolsas [ x |x <- bolsas, Bolsa.tipoSanguineo x == "AB+"]
    | otherwise = listaBolsasPorTipo " " []

  --tem que apagar as bolsas quando forem removidas
  removeBolsa:: String -> Int -> [Bolsa.Bolsa] -> Maybe Bolsa.Bolsa
  removeBolsa " " 0 [] = Nothing
  removeBolsa tipoProcurado qntBlood bolsas =
    if([ x |x <- bolsas, Bolsa.tipoSanguineo x == tipoProcurado] /= [])
      then if (bolsasValidas /= [])
        then Just (bolsasValidas!!0)
        else Nothing
    else removeBolsa " " 0 []

    where bolsasValidas = [x | x <- bolsas,verificaMlDaBolsa qntBlood x /= Nothing]

   
  verificaMlDaBolsa::Int -> Bolsa.Bolsa -> Maybe Bolsa.Bolsa
  verificaMlDaBolsa qntBlood bolsa  
    | Bolsa.qtdSangue bolsa > qntBlood =  Just bolsa
    | Bolsa.qtdSangue bolsa == qntBlood = Just bolsa
    | otherwise = Nothing


  toUpperCase :: String -> String
  toUpperCase entrada = [toUpper x | x <- entrada]


  imprimeBolsa:: String -> Int -> String
  imprimeBolsa tipo qtd = "(Bolsa): >Tipo: " ++ tipo ++ " >Quantidade(em ml) " ++ show qtd ++ "\n"

  bolsaToString:: Maybe Bolsa -> String
  bolsaToString (Just bolsa) = "[RETIRADA] " ++ imprimeBolsa (tipoSanguineo bolsa) (qtdSangue bolsa)

  -- retornaTodasBolsas :: [Bolsa.Bolsa]
  --  retornaTodasBolsas (h:t) = Bolsa h ++ [Bolsa t]

  {-
    pega uma lista de tupas onde o primeiro elemento eh o mes e o segundo a qtd de sangue no estoque-}
  estoqueEmMapa :: [Bolsa.Bolsa] -> Map String String -> String -> [(String, String)]
  estoqueEmMapa estoque mapa mes = Map.toList(insert mes (show (totalSangue estoque)) mapa)
  {-
    Retorna o total de sangue do banco (em ml)-}
  totalSangue :: [Bolsa.Bolsa] -> Int
  totalSangue [] = 0
  totalSangue (h:t) = qtdSangue h + totalSangue t
