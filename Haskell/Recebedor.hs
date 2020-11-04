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
    encontraRecebedorString procurado [] = "Recebedores: \n"
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
    todosOsRecebedores [] = " "
    todosOsRecebedores (h:t) = "Nome " ++ nome h ++ " " ++ "Endereco" ++ endereco h ++ " " ++ "Idade: " ++ show (idade h) ++ " "
        ++ "Telefone: " ++ telefone h ++ " " ++ "Quantidade de Bolsas de Sangue Necessárias: " ++ show (numDeBolsas h) ++ " " ++ "Tipo Sanguineo: " ++ tipoSanguineo h ++ " " ++ "Hospital: " ++ hospital h ++ "\n" ++ todosOsRecebedores t

    recebedorCadastrado :: String -> [Recebedor] -> Bool
    recebedorCadastrado procurado [] = False
    recebedorCadastrado procurado (h:t)
        |isInfixOf (toUpperCase procurado) (toUpperCase (nome h)) == True = True
        |otherwise = recebedorCadastrado procurado t


    toUpperCase :: String -> String
    toUpperCase entrada = [toUpper x | x <- entrada]

{-
    cadastrarRecebedor :: IO()
    cadastrarRecebedor = do
        nome <- prompt "Digite o nome do(a) Recebedor(a) "
        endereco <- prompt "Digite o endereço do(a) Recebedor(a) "
        input <- prompt "Digite a idade do(a) Recebedor(a) "
        let idade = read input
        telefone <- prompt "Digite o telefone do(a) Recebedor(a) "
        input <- prompt "Digite a quantidade de bolsas de sangue que o(a) Recebedor(a) precisa "
        let quantidade = read input
        tipo <- prompt "Tipo Sanguineo: "
        hospital <- prompt "Hospital internado: "
        --------------------------------------------------------------------------------------------
        -- cadastrar ficha medica 
        
        sexo <- prompt "Sexo Feminino (1) Masculino (2) "
        dataNascimento <- prompt "Data de nascimento: "
        pai <- prompt "Nome do pai: "
        mae <- prompt "Nome da mãe: "
        acompanhamentoMedico <- prompt "Tem acompanhamento médico ou psicológico? NAO (1) Sim (2) "
        let acompanhamentoMedicoBool = False
        
        if (acompanhamentoMedico == "1") then do 
            let acompanhamentoMedicoBool = False 
            putStr "" 
            else if (acompanhamentoMedico == "2") then do 
                let acompanhamentoMedicoBool = True 
                putStr ""
                else do 
                    let acompanhamentoMedicoBool = False 
                    putStr ""
        
        condicaoFisica <- prompt "Tem alguma condição que exige atenção especial ou restrição a atividade física? NAO (1) Sim (2) "
        let condicaoFisicaBool = False
        if (condicaoFisica == "1") then do 
            let condicaoFisicaBool = False 
            putStr "" 
            else if (condicaoFisica == "2") then do 
                let condicaoFisicaBool = True 
                putStr "" 
                else do 
                    let condicaoFisicaBool = False
                    putStr " " 

        alergias <- prompt "Tem alergia a algum medicamento/alimento/material? "
        let ficha = adicionaFichaMedica sexo dataNascimento pai mae acompanhamentoMedicoBool condicaoFisicaBool alergias
        ---------------------------------------------------------------------------------------------
        let recebedor = adicionaRecebedor nome endereco idade telefone quantidade tipo hospital ficha
        putStr "Recebedor Cadastrado"
-}


    prompt :: String -> IO String
    prompt text = do
        putStr text
        hFlush stdout
        getLine

    -- Ainda falta implementar Ficha de Dados Medicos, estou pensando em fazer um outro objeto Ficha para usar aqui será que é uma boa

    -- fazer um toString do recebedor individual para imprimir a ficha de dados
    -- fazer um toString da fichaMedica do recebedor individual