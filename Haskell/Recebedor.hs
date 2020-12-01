module Recebedor where 
    import Data.List
    import Data.Maybe()
    import Data.Map as Map
    import Data.Char
    import System.IO
    import FichaMedica as FichaMedica

    data Recebedor = Recebedor { nome :: String, endereco :: String, idade :: Int, telefone :: String, numDeBolsas :: Int, tipoSanguineo :: String, hospital :: String, fichaMedica :: FichaMedica} deriving (Show, Eq)

    adicionaRecebedor :: String -> String -> Int -> String -> Int -> String -> String -> FichaMedica -> Recebedor
    adicionaRecebedor nome endereco idade telefone numDeBolsas tipoSanguineo hospital fichaMedica = (Recebedor {nome = nome, endereco = endereco, idade = idade, telefone = telefone, numDeBolsas = numDeBolsas, tipoSanguineo = tipoSanguineo, hospital = hospital, fichaMedica = fichaMedica})

    encontraRecebedorString :: String -> [Recebedor] -> String
    encontraRecebedorString procurado [] = ""
    encontraRecebedorString procurado (h:t)
        |isInfixOf (toUpperCase procurado) (toUpperCase (nome h)) == True = show h ++ encontraRecebedorString procurado t
        |otherwise = encontraRecebedorString procurado t

    {-
    encontraRecebedor :: String -> [Recebedor] -> Maybe Recebedor
    encontraRecebedor procurado [] = Nothing
    encontraRecebedor procurado (h:t)
        |isInfixOf (toUpperCase procurado) (toUpperCase (nome h)) == True = Just h
        |otherwise = encontraRecebedor procurado t
    -}
    {-
    imprimeRecebedor :: String -> [Recebedor] -> String
    imprimeRecebedor procurado [] = "Nome " ++ nome procurado ++ " " ++ "Endereco" ++ endereco procurado ++ " " ++ "Idade: " ++ show (idade procurado) ++ " "
        ++ "Telefone: " ++ telefone procurado ++ " " ++ "Quantidade de Bolsas de Sangue Necessária: " ++ show (numDeBolsas procurado ) ++ "Tipo Sanguineo: " ++ tipoSanguineo procurado ++ "Hospital: " ++ hospital procurado ++ "\n"
        where procurado = Recebedor.encontraRecebedor procurado []
    -}
    todosOsRecebedores :: [Recebedor] -> String
    todosOsRecebedores [] = ""
    todosOsRecebedores (h:t) = "Nome " ++ nome h ++ " " ++ "Endereco" ++ endereco h ++ " " ++ "Idade: " ++ show (idade h) ++ " "
        ++ "Telefone: " ++ telefone h ++ " " ++ "Quantidade de Bolsas de Sangue Necessárias: " ++ show (numDeBolsas h) ++ " " ++ "Tipo Sanguineo: " ++ tipoSanguineo h ++ " " ++ "Hospital: " ++ hospital h ++ "\n" ++ todosOsRecebedores t

    recebedorCadastrado :: String -> [Recebedor] -> Bool
    recebedorCadastrado procurado [] = False
    recebedorCadastrado procurado (h:t)
        |isInfixOf (toUpperCase procurado) (toUpperCase (nome h)) == True = True
        |otherwise = recebedorCadastrado procurado t

    recebedorFichaMedicaString :: String -> [Recebedor.Recebedor]-> String
    recebedorFichaMedicaString procurado [] = ""
    recebedorFichaMedicaString procurado (h:t)
        |procurado == nome h = "Ficha médica de " ++ procurado ++ "\n" ++ FichaMedica.imprimeFichaMedica (fichaMedica h)
        |otherwise = recebedorFichaMedicaString procurado t        

    recebedorToString :: String -> [Recebedor.Recebedor] -> String
    recebedorToString procurado [] = ""
    recebedorToString procurado (h:t)
        |procurado == nome h = "Nome: " ++ nome h ++ "\n" ++ "Endereço: " ++  endereco h ++ "\n" ++ "Idade: " ++ show (idade h) ++ "\n" ++ "Telefone: " ++ telefone h ++ "\n" ++ "Número de Bolsas: " ++ (show (numDeBolsas h)) ++ "\n" ++ "Tipo Sanguíneo: " ++  tipoSanguineo h ++ "\n"
        |otherwise = recebedorToString procurado t 
    
    
    toUpperCase :: String -> String
    toUpperCase entrada = [toUpper x | x <- entrada]

    prompt :: String -> IO String
    prompt text = do
        putStr text
        hFlush stdout
        getLine

    {- Função que retorna o recebedor se ele tiver cadastrado. Se não, retorna um Recebedor com atributos vazios
    -}
    encontraRecebedor :: String -> [Recebedor] ->  Recebedor
    encontraRecebedor procurado [] = (Recebedor "" "" 0 "" 0 "" "" (FichaMedica "" "" "" "" "" "" ""))
    encontraRecebedor procurado (h:t)
        |isInfixOf (toUpperCase procurado)  (toUpperCase (nome h)) == True = h
        |otherwise = encontraRecebedor procurado t

    -- Ainda falta implementar Ficha de Dados Medicos, estou pensando em fazer um outro objeto Ficha para usar aqui será que é uma boa

    -- fazer um toString do recebedor individual para imprimir a ficha de dados
    -- fazer um toString da fichaMedica do recebedor individual