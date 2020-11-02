module Enfermeiro where
    import Data.List ( isInfixOf )
    import Data.Maybe()
    import Data.Map as Map
    import Data.Char
    import Data.Time


    data Enfermeiro = Enfermeiro{nome :: String, endereco :: String, idade :: Int, telefone :: String
    } deriving (Show,Eq)

    adicionaEnfermeiro :: String -> String -> Int -> String -> Enfermeiro
    adicionaEnfermeiro nome endereco idade telefone = (Enfermeiro {nome = nome, endereco = endereco,idade = idade, telefone = telefone})

    encontraEnfermeiroString :: String -> [Enfermeiro] -> String
    encontraEnfermeiroString procurado [] = ""
    encontraEnfermeiroString procurado (h:t)
        |isInfixOf (toUpperCase procurado) (toUpperCase (nome h)) == True = show h ++ encontraEnfermeiroString procurado t
        |otherwise = encontraEnfermeiroString procurado t

    encontraEnfermeiroStringNome :: String -> [Enfermeiro] -> String
    encontraEnfermeiroStringNome procurado [] = ""
    encontraEnfermeiroStringNome procurado (h:t)
        |isInfixOf (toUpperCase procurado) (toUpperCase (nome h)) == True = nome h ++ encontraEnfermeiroString procurado t
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

    organizaEscala :: Day -> Map Day String -> String -> [Enfermeiro] -> [(Day,String)]
    organizaEscala diaMes escala nome enfermeiros
        |encontraEnfermeiroStringNome nome enfermeiros /= "" = Map.toList(insertWith (++) diaMes novaEscala escala)
        where novaEscala = encontraEnfermeiroStringNome nome enfermeiros

    visualizaEscala :: Day -> Map Day String -> Maybe String
    visualizaEscala diaMes escala
        |member diaMes escala == False = Nothing
        |member diaMes escala == True = Map.lookup diaMes escala

    visualizaEnfermeiros :: [Enfermeiro] -> String
    visualizaEnfermeiros [] = ""
    visualizaEnfermeiros (h:t) = nome h ++ " " ++ visualizaEnfermeiros t

    toUpperCase :: String -> String
    toUpperCase entrada = [toUpper x | x <- entrada]