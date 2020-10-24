
module Enfermeiro where
    import Data.List
    import Data.Maybe()
    import Data.Map as Map


    data Enfermeiro = Enfermeiro{nome :: String, endereco :: String, idade :: Int, telefone :: String
    } deriving (Show,Eq)

    adicionaEnfermeiro :: String -> String -> Int -> String -> Enfermeiro
    adicionaEnfermeiro nome endereco idade telefone = (Enfermeiro {nome = nome, endereco = endereco,idade = idade, telefone = telefone})

    encontraEnfermeiroString :: String -> [Enfermeiro] -> String
    encontraEnfermeiroString procurado [] = "Não encontrado(a)"
    encontraEnfermeiroString procurado (h:t)
        |isInfixOf procurado (nome h) == True = show h
        |otherwise = encontraEnfermeiroString procurado t

    encontraEnfermeiro :: String -> [Enfermeiro] -> Maybe Enfermeiro
    encontraEnfermeiro procurado [] = Nothing
    encontraEnfermeiro procurado (h:t)
        |isInfixOf procurado (nome h) == True = Just h
        |otherwise = encontraEnfermeiro procurado t

    todosOsEnfermeiros:: String -> String
    todosOsEnfermeiros [] = ""
    todosOsEnfermeiros (h:t) =  [h] ++ todosOsEnfermeiros t
    
    enfermeiroCadastrado :: String -> [Enfermeiro] -> Bool
    enfermeiroCadastrado procurado [] = False
    enfermeiroCadastrado procurado (h:t)
        |isInfixOf procurado (nome h) == True = True
        |otherwise = enfermeiroCadastrado procurado t

    organizaEscala :: String -> Map String String -> String -> [Enfermeiro] -> Map String String
    organizaEscala diaMes escala nome enfermeiros
        |enfermeiroCadastrado nome enfermeiros == True = insertWith (++) diaMes novaEscala escala
        where novaEscala = encontraEnfermeiroString nome enfermeiros

    visualizaEscala :: String -> Map String String -> Maybe String
    visualizaEscala diaMes escala = Map.lookup diaMes escala
    
    visualizaEnfermeiros :: [Enfermeiro] -> String
    visualizaEnfermeiros [] = ""
    visualizaEnfermeiros (h:t) = nome h ++ visualizaEnfermeiros t 