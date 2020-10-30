module Doador where
    import Data.List
    import Data.Maybe()
    import Data.Map as Map (Map, insertWith, lookup, member)
    import Data.Map as Map()
    import Data.Char


    data Doador = Doador{nome :: String, endereco :: String, idade :: Int, telefone :: String, doencas :: String, medicamentos :: String, doacoes :: String
    } deriving (Show,Eq)

    adicionaDoador :: String -> String -> Int -> String -> String -> String -> String -> Doador
    adicionaDoador nome endereco idade telefone doencas medicamentos doacoes =
     (Doador {nome = nome, endereco = endereco,idade = idade, telefone = telefone, doencas = doencas, medicamentos = medicamentos})

    adicionaDoacao :: String -> [Doador] -> String -> Bool
    adicionaDoacao doador [] doacao = True
    adicionaDoacao doador (h:t) doacao
        |isInfixOf (toUpperCase doador) (toUpperCase (nome h)) == True = (Doador {doacoes = doacao}) 
        |otherwise = adicionaDoacao doador t doacao


--metodos relacionados a achar e mostrar os doadores

    encontraDoadorString :: String -> [Doador] -> String
    encontraDoadorString procurado [] = "Resultados: \n"
    encontraDoadorString procurado (h:t)
        |isInfixOf (toUpperCase procurado) (toUpperCase (nome h)) == True = show h ++ encontraDoadorString procurado t
        |otherwise = encontraDoadorString procurado t

    encontraDoador :: String -> [Doador] -> Maybe Doador
    encontraDoador procurado [] = Nothing
    encontraDoador procurado (h:t)
        |isInfixOf (toUpperCase procurado)  (toUpperCase (nome h)) == True = Just h
        |otherwise = encontraDoador procurado t

    todosOsDoadores:: [Doador] -> String
    todosOsDoadores [] = " "
    todosOsDoadores (h:t) = "Nome: " ++ nome h 
        ++ " " ++ "Endereço: " ++ endereco h ++ " " ++ "Idade: " ++ show (idade h) ++ " "
        ++ "Telefone: " ++ telefone h ++ "Doencas: " ++ doencas h  ++ "Medicamnetos: " ++ medicamentos h  ++ "\n"++ todosOsDoadores t
    
    doadorCadastrado :: String -> [Doador] -> Bool
    doadorCadastrado procurado [] = False
    doadorCadastrado procurado (h:t)
        |isInfixOf (toUpperCase procurado)  (toUpperCase (nome h)) == True = True
        |otherwise = doadorCadastrado procurado t

 
    visualizaDoadores :: [Doador] -> String
    visualizaDoadores [] = ""
    visualizaDoadores (h:t) = nome h ++ " " ++ visualizaDoadors t

    toUpperCase :: String -> String
    toUpperCase entrada = [toUpper x | x <- entrada]