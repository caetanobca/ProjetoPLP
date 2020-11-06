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
        |tipoImpedimento impedimento == "MEDICAMENTO" = "Medicamento" ++ "\n    >Composto: " ++ composto impedimento ++"\n    >Funcao: "  
                        ++ funcao impedimento  ++ " \n    >Tempo Supencao: " ++ show (tempoSuspencao impedimento) ++ " Dias\n"
        |tipoImpedimento impedimento == "DOENCA" = "Doenca\n  >CID: " ++ cid impedimento ++ " \n  >Tempo Suspencao: " 
                        ++ show (tempoSuspencao impedimento) ++ " Dias\n" 

    impedimentoImprime :: Impedimento -> String
    impedimentoImprime impedimento
        |tipoImpedimento impedimento == "MEDICAMENTO" = "Impedimento:" ++ " Composto: " ++ composto impedimento ++" Funcao: "  
                        ++ funcao impedimento  ++ " Tempo Supencao: " ++ show (tempoSuspencao impedimento) ++ " Dias / "
        |tipoImpedimento impedimento == "DOENCA" = "Impedimento: " ++ cid impedimento ++ " Tempo Suspencao: " 
                        ++ show (tempoSuspencao impedimento) ++ " Dias / " 



    buscaImpedimentoStr :: String -> String -> [Impedimento] -> String
    buscaImpedimentoStr tipo procurado [] = ""
    buscaImpedimentoStr tipo procurado (h:t)
        |tipo == (tipoImpedimento h) && tipo == "MEDICAMENTO" &&(isInfixOf (toUpperCaseStr procurado)  (toUpperCaseStr (composto h))) == True = impedimentoToString h
        |tipo == (tipoImpedimento h) && tipo == "DOENCA" && isInfixOf (toUpperCaseStr procurado)  (toUpperCaseStr (cid h)) == True = impedimentoToString h
        |otherwise = buscaImpedimentoStr tipo procurado t

    buscaImpedimento :: String -> String-> [Impedimento] -> Impedimento
    buscaImpedimento tipo procurado [] = (Medicamento "MEDICAMENTO" " 0dias de suspencao" "Nenhum composto" 0)
    buscaImpedimento tipo procurado (h:t)
        |tipo == (tipoImpedimento h) && tipo == "MEDICAMENTO" && (isInfixOf (toUpperCaseStr procurado)  (toUpperCaseStr (composto h))) == True = h
        |tipo == (tipoImpedimento h) && tipo == "DOENCA" && isInfixOf (toUpperCaseStr procurado)  (toUpperCaseStr (cid h)) == True = h
        |otherwise = buscaImpedimento procurado tipo t

    existeImpedimento :: String -> String-> [Impedimento] -> Bool
    existeImpedimento tipo procurado [] = False
    existeImpedimento tipo procurado (h:t)
        |tipo == (tipoImpedimento h) && tipo == "MEDICAMENTO" && (isInfixOf (toUpperCaseStr procurado)  (toUpperCaseStr (composto h))) == True = True
        |tipo == (tipoImpedimento h) && tipo == "DOENCA" && isInfixOf (toUpperCaseStr procurado)  (toUpperCaseStr (cid h)) == True = True
        |otherwise = existeImpedimento procurado tipo t
        
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
{-    
    ultimoDiaImpedido :: [Impedimento] -> IO(Day)
    ultimoDiaImpedido impedimentos = addDays (tempoSuspencao (impedimentoMaisLongo impedimentos)) <$> getHoje

  
    impedimentoMaisLongo :: [Impedimento] -> Impedimento
    impedimentoMaisLongo [] = (Medicamento "MEDICAMENTO" " 0dias de suspencao" "Nenhum composto" 0)
    impedimentoMaisLongo (h:t)
        | (tempoSuspencao h) > (tempoSuspencao (impedimentoMaisLongo t)) = h
        | (tempoSuspencao h) < (tempoSuspencao (impedimentoMaisLongo t)) = impedimentoMaisLongo t
        | otherwise = h

  -}
    getHoje :: IO(Day)
    getHoje = do
        a <- utctDay <$> getCurrentTime
        return a
    
    toUpperCaseStr :: String -> String
    toUpperCaseStr entrada = [toUpper x | x <- entrada]