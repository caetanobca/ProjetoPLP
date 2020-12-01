module Enfermeiro where
    import Data.List ( isInfixOf )
    import Data.Maybe()
    import Data.Map as Map
    import Data.Char
    import Data.Time
    import Data.List.Split ( splitOn )


    data Enfermeiro = Enfermeiro{nome :: String, endereco :: String, idade :: Int, telefone :: String
    } deriving (Show,Eq)

    adicionaEnfermeiro :: String -> String -> Int -> String -> Enfermeiro
    adicionaEnfermeiro nome endereco idade telefone = (Enfermeiro {nome = nome, endereco = endereco,idade = idade, telefone = telefone})

    enfermeiroToString :: String -> [Enfermeiro] -> String
    enfermeiroToString procurado [] = ""
    enfermeiroToString procurado (h:t)
        |isInfixOf (toUpperCase procurado) (toUpperCase (nome h)) == True = "Nome: " ++ nome h ++ "\n    -Endeço: " ++ endereco h ++
                                                    "\n    -Idade: " ++ show (idade h) ++ "\n    -Telefone: " ++ telefone h ++ "\n"
                                                    ++ enfermeiroToString procurado t
        |otherwise = enfermeiroToString procurado t

    encontraEnfermeiroStringNome :: String -> [Enfermeiro] -> String
    encontraEnfermeiroStringNome procurado [] = ""
    encontraEnfermeiroStringNome procurado (h:t)
        |isInfixOf (toUpperCase procurado) (toUpperCase (nome h)) == True = nome h ++ "--" ++ encontraEnfermeiroStringNome procurado t
        |otherwise = encontraEnfermeiroStringNome procurado t    

    encontraEnfermeiro :: String -> [Enfermeiro] -> Maybe Enfermeiro
    encontraEnfermeiro procurado [] = Nothing
    encontraEnfermeiro procurado (h:t)
        |isInfixOf (toUpperCase procurado)  (toUpperCase (nome h)) == True = Just h
        |otherwise = encontraEnfermeiro procurado t

    todosOsEnfermeiros:: [Enfermeiro] -> String
    todosOsEnfermeiros [] = " "
    todosOsEnfermeiros (h:t) = "Nome: " ++ nome h 
        ++ " " ++ "Endereço: " ++ endereco h ++ " " ++ "Idade: " ++ show (idade h) ++ " "
        ++ "Telefone: " ++ telefone h ++ "\n\n"++ todosOsEnfermeiros t
    
    enfermeiroCadastrado :: String -> [Enfermeiro] -> Bool
    enfermeiroCadastrado procurado [] = False
    enfermeiroCadastrado procurado (h:t)
        |isInfixOf (toUpperCase procurado)  (toUpperCase (nome h)) == True = True
        |otherwise = enfermeiroCadastrado procurado t

    organizaEscala :: Day -> Map Day String -> String -> [Enfermeiro] -> [(Day,String)]
    organizaEscala diaMes escala nome enfermeiros
        |encontraEnfermeiroStringNome nome enfermeiros /= "" = Map.toList(insertWith (++) diaMes novaEscala escala)
        where novaEscala = encontraEnfermeiroStringNome nome enfermeiros

    visualizaEscala :: Day -> Map Day String -> String
    visualizaEscala diaMes escala
        |member diaMes escala == False = "Data não encontrada"
        |member diaMes escala == True = escalaStr
        where escalaStr = "Enfermeiros escalados" ++ "\n" ++(formataEscala (splitOn "--" (escala ! diaMes)))

    formataEscala :: [String] -> String
    formataEscala  [] = ""
    formataEscala (h:t) = h ++ "\n" ++ formataEscala t 
        
    toUpperCase :: String -> String
    toUpperCase entrada = [toUpper x | x <- entrada]