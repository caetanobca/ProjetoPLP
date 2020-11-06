module Impedimento where
    import Data.List
    import Data.Typeable ()
    import Data.Char
    import Data.Time
    import System.IO.Unsafe(unsafeDupablePerformIO)


        
    data Impedimento = Medicamento{
        tipoImpedimento :: String 
        ,funcao :: String
        ,composto :: String
        ,tempoSuspencao :: Integer
    } | Doenca{
        tipoImpedimento :: String
        ,cid :: String
        ,tempoSuspencao :: Integer
    } deriving (Show,Eq)


    adicionaImpedimento :: String -> String -> Integer -> Impedimento
    adicionaImpedimento  [] cid  tempoSuspencao  = (Doenca "DOENCA" cid tempoSuspencao)
    adicionaImpedimento  funcao composto tempoSuspencao = (Medicamento "MEDICAMENTO" funcao composto tempoSuspencao)
        
    listarImpedimentos:: [Impedimento] -> String
    listarImpedimentos [] = " "
    listarImpedimentos (h:t)
        |tipoImpedimento h == "MEDICAMENTO" = impedimentoToString h ++ listarImpedimentos t
        |tipoImpedimento h == "DOENCA" = impedimentoToString h ++ listarImpedimentos t

        
    impedimentoToString :: Impedimento -> String
    impedimentoToString impedimento
        |tipoImpedimento impedimento == "MEDICAMENTO" = "Medicamento" ++ "\n  >Composto: " ++ composto impedimento ++"\n  >Funcao: "  
                        ++ funcao impedimento  ++ " \n  >Tempo Supencao: " ++ show (tempoSuspencao impedimento) ++ " Dias\n"
        |tipoImpedimento impedimento == "DOENCA" = "Doenca\n  >CID: " ++ cid impedimento ++ " \n  >Tempo Suspencao: " 
                        ++ show (tempoSuspencao impedimento) ++ " Dias\n" 

    impedimentoImprime :: Impedimento -> String
    impedimentoImprime impedimento
        |tipoImpedimento impedimento == "MEDICAMENTO" = "Impedimento:" ++ " Composto: " ++ composto impedimento ++" Funcao: "  
                        ++ funcao impedimento  ++ " Tempo Supencao: " ++ show (tempoSuspencao impedimento) ++ " Dias / "
        |tipoImpedimento impedimento == "DOENCA" = "Impedimento: " ++ cid impedimento ++ " Tempo Suspencao: " 
                        ++ show (tempoSuspencao impedimento) ++ " Dias / " 



    buscaImpedimentoStr :: String -> String -> [Impedimento] -> String
    buscaImpedimentoStr _ _ [] = ""
    buscaImpedimentoStr "MEDICAMENTO" procurado (h:t)
        |(tipoImpedimento h) == "MEDICAMENTO" = if (isInfixOf (toUpperCaseStr procurado)  (toUpperCaseStr (composto h))) then impedimentoToString h
        else buscaImpedimentoStr "MEDICAMENTO" procurado t
        |otherwise = buscaImpedimentoStr "MEDICAMENTO" procurado t
    buscaImpedimentoStr "DOENCA" procurado (h:t)
        |(tipoImpedimento h) == "DOENCA" = if (isInfixOf (toUpperCaseStr procurado)  (toUpperCaseStr (cid h))) then impedimentoToString h
        else buscaImpedimentoStr "DOENCA" procurado t
        |otherwise = buscaImpedimentoStr "DOENCA" procurado t

    buscaImpedimento :: String -> String-> [Impedimento] -> Impedimento
    buscaImpedimento _ _ [] = (Medicamento "MEDICAMENTO" " 0dias de suspencao" "Nenhum composto" 0)
    buscaImpedimento "MEDICAMENTO" procurado (h:t)
        |(tipoImpedimento h) == "MEDICAMENTO" = if (isInfixOf (toUpperCaseStr procurado)  (toUpperCaseStr (composto h))) then  h
        else buscaImpedimento "MEDICAMENTO" procurado  t
        |otherwise = buscaImpedimento "MEDICAMENTO" procurado  t
    buscaImpedimento "DOENCA" procurado (h:t) 
        |(tipoImpedimento h) == "DOENCA" = if (isInfixOf (toUpperCaseStr procurado)  (toUpperCaseStr (cid h))) then h
        else buscaImpedimento "DOENCA" procurado  t
        |otherwise = buscaImpedimento "DOENCA" procurado  t

    existeImpedimento :: String -> String-> [Impedimento] -> Bool
    existeImpedimento _ _ [] = False
    existeImpedimento "MEDICAMENTO" procurado (h:t)
        |(tipoImpedimento h) == "MEDICAMENTO" = if (isInfixOf (toUpperCaseStr procurado)  (toUpperCaseStr (composto h))) then True
        else existeImpedimento "MEDICAMENTO" procurado  t
        |otherwise = existeImpedimento "MEDICAMENTO" procurado  t
    existeImpedimento "DOENCA" procurado (h:t)        
        |(tipoImpedimento h) == "DOENCA" = if (isInfixOf (toUpperCaseStr procurado)  (toUpperCaseStr (cid h))) then True
        else existeImpedimento "DOENCA" procurado  t
        |otherwise = existeImpedimento "DOENCA" procurado  t
        
    removeImpedimetno :: Impedimento -> [Impedimento] -> [Impedimento]
    removeImpedimetno _ [] = []
    removeImpedimetno impedimento (h:t) 
        |impedimento == h = removeImpedimetno impedimento t
        |otherwise = (h : removeImpedimetno impedimento t)

    ultimoDiaImpedido :: Impedimento -> Day -> Day
    ultimoDiaImpedido impedimentos diaAtual
        |diaAtual > diaNovo = diaAtual
        |diaAtual < diaNovo = diaNovo
        where diaNovo =  unsafeDupablePerformIO(addDays (tempoSuspencao (impedimentos)) <$> getHoje)

    getHoje :: IO(Day)
    getHoje = do
        a <- utctDay <$> getCurrentTime
        return a
    
    toUpperCaseStr :: String -> String
    toUpperCaseStr entrada = [toUpper x | x <- entrada]