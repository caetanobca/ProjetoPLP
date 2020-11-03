module Impedimento where

    import Data.Typeable ()
    import Data.Char
    import Data.Time


        
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

    buscaImpedimentoStr :: String -> String-> [Impedimento] -> String
    buscaImpedimentoStr tipo procurado [] = ""
    buscaImpedimentoStr tipo procurado (h:t)
        |tipo == (tipoImpedimento h) && tipo == "MEDICAMENTO" && procurado == composto h = impedimentoToString h
        |tipo == (tipoImpedimento h) && tipo == "DOENCA" && procurado == cid h = impedimentoToString h
        |otherwise = buscaImpedimentoStr procurado tipo t
        
    listarImpedimentos:: [Impedimento] -> String
    listarImpedimentos [] = " "
    listarImpedimentos (h:t)
        |tipoImpedimento h == "MEDICAMENTO" = "(Medicamento) >Funcao: "  ++ funcao h  ++ " >Composto: " ++ composto h
                        ++ " >Tempo Supencao: " ++ show (tempoSuspencao h) ++ " Dias\n" ++ listarImpedimentos t
        |tipoImpedimento h == "DOENCA" = "(Doenca) >CID: " ++ cid h ++ " >Tempo Suspencao: " 
                        ++ show (tempoSuspencao h) ++ " Dias\n" ++ listarImpedimentos t

        
    impedimentoToString :: Impedimento -> String
    impedimentoToString impedimento
        |tipoImpedimento impedimento == "MEDICAMENTO" = "(Medicamento) >Funcao: "  ++ funcao impedimento  ++
                        " >Composto: " ++ composto impedimento ++ " >Tempo Supencao: " ++ show (tempoSuspencao impedimento) ++ " Dias\n"
        |tipoImpedimento impedimento == "DOENCA" = "(Doenca) >CID: " ++ cid impedimento ++ " >Tempo Suspencao: " 
                        ++ show (tempoSuspencao impedimento) ++ " Dias\n" 

    buscaImpedimento :: String -> String-> [Impedimento] -> Maybe Impedimento
    buscaImpedimento tipo procurado [] = Nothing
    buscaImpedimento tipo procurado (h:t)
        |tipo == (tipoImpedimento h) && tipo == "MEDICAMENTO" && procurado == composto h = Just h
        |tipo == (tipoImpedimento h) && tipo == "DOENCA" && procurado == cid h = Just h
        |otherwise = buscaImpedimento procurado tipo t

    removeImpedimetno :: Impedimento -> [Impedimento] -> [Impedimento]
    removeImpedimetno _ [] = []
    removeImpedimetno impedimento (h:t) 
        | impedimento == h = removeImpedimetno impedimento t
        | otherwise = (h : removeImpedimetno impedimento t)


    ultimoDiaImpedido :: [Impedimento] -> IO(Day)
    ultimoDiaImpedido impedimentos = addDays (tempoSuspencao (impedimentoMaisLongo impedimentos)) <$> getHoje

  
    impedimentoMaisLongo :: [Impedimento] -> Impedimento
    impedimentoMaisLongo [] = (Medicamento "MEDICAMENTO" " 0dias de suspencao" "Nenhum composto" 0)
    impedimentoMaisLongo (h:t)
        | (tempoSuspencao h) > (tempoSuspencao (impedimentoMaisLongo t)) = h
        | (tempoSuspencao h) < (tempoSuspencao (impedimentoMaisLongo t)) = impedimentoMaisLongo t
        | otherwise = h

    getHoje :: IO(Day)
    getHoje = do
        a <- utctDay <$> getCurrentTime

        return a