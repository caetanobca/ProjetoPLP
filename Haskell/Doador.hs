module Doador where
    import Data.List
    import Data.Time
    import Data.Maybe()
    import Data.Map as Map (Map, insertWith, lookup, member)
    import Data.Map as Map()
    import System.IO.Unsafe(unsafeDupablePerformIO)
    import Data.Char
    import Impedimento


    data Doador = Doador{nome :: String, endereco :: String, idade :: Int, telefone :: String, impedimentoStr :: String, ultimoDiaImpedido :: Day ,doacoes :: String
    } deriving (Show,Eq)

    adicionaDoador :: String -> String -> Int -> String -> [Impedimento] -> Doador
    adicionaDoador nome endereco idade telefone impedimento = 
        (Doador {nome = nome, 
        endereco = endereco,
        idade = idade, 
        telefone = telefone, 
        impedimentoStr = Impedimento.listarImpedimentos (impedimento), 
        Doador.ultimoDiaImpedido =  getUltimoDia,
        doacoes = ""})

        where getUltimoDia = unsafeDupablePerformIO(Impedimento.ultimoDiaImpedido impedimento)

--nao sei se ta certo pq n sei se ta adicionando nas doacoes ou so ta salvando a ultima doacao 
    adicionaDoacao :: String -> [Doador] -> String -> Maybe Doador
    adicionaDoacao doador [] doacao = Nothing
    adicionaDoacao doador (h:t) doacao
        |isInfixOf (toUpperCase doador) (toUpperCase (nome h)) == True = Just (Doador {doacoes = doacao}) 
        |otherwise = adicionaDoacao doador t doacao

    
    mostraFichaTecnica :: Doador -> String
    mostraFichaTecnica  doador =   (impedimentoStr doador)

    listarDoacoes :: Doador -> String
    listarDoacoes doador = (doacoes doador)


    mensagemDeAgradecimentoIndividual :: Doador -> String
    mensagemDeAgradecimentoIndividual doador = ("mensagem enviada para " ++ nome doador )

    mensagemPedidoDoacao :: [Doador] -> String
    mensagemPedidoDoacao [] = ""
    mensagemPedidoDoacao (h:t) = ("mensagem enviada para todos os doadores ativos")

--metodos relacionados a achar e mostrar os doadores

    encontraDoadorString :: String -> [Doador] -> String
    encontraDoadorString procurado [] = ""
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
        ++ "Telefone: " ++ telefone h ++ "Impedimentos: " ++ mostraFichaTecnica h    ++ "\n"++ todosOsDoadores t
    
    doadorCadastrado :: String -> [Doador] -> Bool
    doadorCadastrado procurado [] = False
    doadorCadastrado procurado (h:t)
        |isInfixOf (toUpperCase procurado)  (toUpperCase (nome h)) == True = True
        |otherwise = doadorCadastrado procurado t

    getEnderecoDoador :: String -> [Doador] -> String
    getEnderecoDoador procurado []= ""
    getEnderecoDoador procurado (h:t)
        |isInfixOf (toUpperCase procurado)  (toUpperCase (nome h)) == True = endereco h
        |otherwise = getEnderecoDoador procurado t
 
    visualizaDoadores :: [Doador] -> String
    visualizaDoadores [] = ""
    visualizaDoadores (h:t) = nome h ++ " " ++ visualizaDoadores t

    toUpperCase :: String -> String
    toUpperCase entrada = [toUpper x | x <- entrada]