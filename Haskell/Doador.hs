module Doador where
    import Data.List
    import Data.Time
    import Data.Maybe()
    import Data.Map as Map (Map, insertWith, lookup, member)
    import Data.Map as Map()
    import System.IO.Unsafe(unsafeDupablePerformIO)
    import Data.Char
    import Impedimento
    import System.IO.Unsafe(unsafeDupablePerformIO)

    data Doador = Doador{nome :: String, endereco :: String, idade :: Int, telefone :: String, tipSanguineo :: String, impedimentoStr :: String, ultimoDiaImpedido :: Day ,doacoes :: String
    } deriving (Show,Eq)

    adicionaDoador :: String -> String -> Int -> String -> String  -> Doador
    adicionaDoador nome endereco idade telefone tipoSanguineo = 
        (Doador {nome = nome, 
        endereco = endereco,
        idade = idade, 
        telefone = telefone, 
        tipSanguineo = (toUpperCase tipoSanguineo), 
        impedimentoStr = "",
        Doador.ultimoDiaImpedido =  getUltimoDia,
        doacoes = ""})

        where getUltimoDia = unsafeDupablePerformIO(getHoje)
    
    mostraFichaTecnica :: String -> [Doador] -> String
    mostraFichaTecnica  nome doador = impedimentoStr (Doador.encontraDoador nome doador)
    

    listarDoacoes :: String -> [Doador] -> String
    listarDoacoes nome doador = (doacoes (Doador.encontraDoador nome doador))


    mensagemDeAgradecimentoIndividual :: Doador -> String
    mensagemDeAgradecimentoIndividual doador = ("mensagem enviada para " ++ nome doador )

    mensagemPedidoDoacao :: [Doador] -> String
    mensagemPedidoDoacao [] = ""
    mensagemPedidoDoacao (h:t) = ("mensagem enviada para todos os doadores ativos")

--metodos relacionados a achar e mostrar os doadores

    encontraDoadorString :: String -> [Doador] -> String
    encontraDoadorString procurado [] = ""
    encontraDoadorString procurado (h:t)
        |((isInfixOf (toUpperCase procurado) (toUpperCase (nome h)) == True) && (estaImpedido)) = "Nome: " ++ nome h ++ "\n       Endereço " ++ endereco h ++
                                    "\n       Idade: " ++ (show (idade h)) ++ "\n       Telefone: " ++ telefone h ++ 
                                    "\n       Tipo Sanguineo: " ++ tipSanguineo h ++ "\n       Impedimentos registrados: " ++ impedimentoStr h ++
                                    "\n       Doações: " ++ doacoes h ++ "\n       Impedido de doar até " ++ (show (Doador.ultimoDiaImpedido h)) ++ "\n\n" ++ encontraDoadorString procurado t
        |isInfixOf (toUpperCase procurado) (toUpperCase (nome h)) == True = "Nome: " ++ nome h ++ "\n       Endereço " ++ endereco h ++
                                    "\n       Idade: " ++ (show (idade h)) ++ "\n       Telefone: " ++ telefone h ++ 
                                    "\n       Tipo Sanguineo: " ++ tipSanguineo h ++ "\n       Impedimento: " ++ impedimentoStr h ++
                                    "\n       Doações: " ++ doacoes h ++ "\n       Doador não está impedido de doar " ++ "\n\n" ++ encontraDoadorString procurado t
        |otherwise = encontraDoadorString procurado t
        where estaImpedido = isImpedido h (unsafeDupablePerformIO(Impedimento.getHoje))    
    
    encontraDoador :: String -> [Doador] ->  Doador
    encontraDoador procurado [] = (Doador "" "" 5 "" "" "" (fromGregorian 1888 12 25) "")
    encontraDoador procurado (h:t)
        |isInfixOf (toUpperCase procurado)  (toUpperCase (nome h)) == True = h
        |otherwise = encontraDoador procurado t

    todosOsDoadores:: [Doador] -> String
    todosOsDoadores [] = " "
    todosOsDoadores (h:t) = "Nome: " ++ nome h ++ " Tipo Sanguineo: " ++ tipSanguineo h ++
        " " ++ "Endereço: " ++ endereco h ++ " " ++ "Idade: " ++ show (idade h) ++ " "
        ++ "Telefone: " ++ telefone h ++ " Impedimentos: " ++ impedimentoStr h     ++ "\n"++ todosOsDoadores t
    
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
 
    toUpperCase :: String -> String
    toUpperCase entrada = [toUpper x | x <- entrada]

    registraImpedimento :: String -> [Doador] -> Impedimento.Impedimento -> [Doador] 
    registraImpedimento doador [] impedimento = []
    registraImpedimento doador (h:t) impedimento
        |isInfixOf (toUpperCase doador) (toUpperCase (nome h)) == True = ((Doador(nome h) (endereco h) (idade h) (telefone h) (tipSanguineo h) (impedimentoStr h ++ "--" ++ impedimentoAsString) (Impedimento.ultimoDiaImpedido impedimento (Doador.ultimoDiaImpedido h) ) (doacoes h)) : t ) 
        |otherwise = (h: registraImpedimento doador t impedimento)
        where impedimentoAsString = Impedimento.impedimentoImprime impedimento

    adicionaDoacao :: String -> [Doador] -> String -> [Doador]
    adicionaDoacao doador [] doacao = []
    adicionaDoacao doador (h:t) doacao
        |isInfixOf (toUpperCase doador) (toUpperCase (nome h)) == True = ((Doador(nome h) (endereco h) (idade h) (telefone h) (tipSanguineo h) (impedimentoStr h) (Doador.ultimoDiaImpedido h) (doacoes h ++ "--" ++doacao)) : t ) 
        |otherwise = (h: adicionaDoacao doador t doacao)

    isImpedido :: Doador -> Day -> Bool
    isImpedido doador diaDoacao  
        |(Doador.ultimoDiaImpedido doador) > diaDoacao = True
        |otherwise = False

