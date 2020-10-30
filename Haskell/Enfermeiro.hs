module Enfermeiro where
    import Data.List ( isInfixOf )
    import Data.Maybe()
    import Data.Map as Map
    import Data.Char


    data Enfermeiro = Enfermeiro{nome :: String, endereco :: String, idade :: Int, telefone :: String
    } deriving (Show,Eq)

    adicionaEnfermeiro :: String -> String -> Int -> String -> Enfermeiro
    adicionaEnfermeiro nome endereco idade telefone = (Enfermeiro {nome = nome, endereco = endereco,idade = idade, telefone = telefone})

    encontraEnfermeiroString :: String -> [Enfermeiro] -> String
    encontraEnfermeiroString procurado [] = "Resultados: \n"
    encontraEnfermeiroString procurado (h:t)
        |isInfixOf (toUpperCase procurado) (toUpperCase (nome h)) == True = show h ++ encontraEnfermeiroString procurado t
        |otherwise = encontraEnfermeiroString procurado t

    encontraEnfermeiro :: String -> [Enfermeiro] -> Maybe Enfermeiro
    encontraEnfermeiro procurado [] = Nothing
    encontraEnfermeiro procurado (h:t)
        |isInfixOf (toUpperCase procurado)  (toUpperCase (nome h)) == True = Just h
        |otherwise = encontraEnfermeiro procurado t

    todosOsEnfermeiros:: [Enfermeiro] -> String
    todosOsEnfermeiros [] = " "
    todosOsEnfermeiros (h:t) = "Nome: " ++ nome h 
        ++ " " ++ "Endereço: " ++ endereco h ++ " " ++ "Idade: " ++ show (idade h) ++ " "
        ++ "Telefone: " ++ telefone h ++ "\n"++ todosOsEnfermeiros t
    
    enfermeiroCadastrado :: String -> [Enfermeiro] -> Bool
    enfermeiroCadastrado procurado [] = False
    enfermeiroCadastrado procurado (h:t)
        |isInfixOf (toUpperCase procurado)  (toUpperCase (nome h)) == True = True
        |otherwise = enfermeiroCadastrado procurado t

    organizaEscala :: String -> Map String String -> String -> [Enfermeiro] -> Map String String
    organizaEscala diaMes escala nome enfermeiros
        |encontraEnfermeiroString nome enfermeiros /= "Resultados: \n" = insertWith (++) diaMes novaEscala escala
        where novaEscala = encontraEnfermeiroString nome enfermeiros

    visualizaEscala :: String -> Map String String -> Maybe String
    visualizaEscala diaMes escala
        |member diaMes escala == False = Nothing
        |member diaMes escala == True = Map.lookup diaMes escala

    visualizaEnfermeiros :: [Enfermeiro] -> String
    visualizaEnfermeiros [] = ""
    visualizaEnfermeiros (h:t) = nome h ++ " " ++ visualizaEnfermeiros t

    toUpperCase :: String -> String
    toUpperCase entrada = [toUpper x | x <- entrada]