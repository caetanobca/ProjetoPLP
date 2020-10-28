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

    buscaImpedimento :: String -> String-> [Impedimento] -> Maybe Impedimento
    buscaImpedimento tipo procurado [] = Nothing
    buscaImpedimento tipo procurado (h:t)
        |tipo == (tipoImpedimento h) && tipo == "MEDICAMENTO" && procurado == funcao h = Just h
        |tipo == (tipoImpedimento h) && tipo == "DOENCA" && procurado == funcao h = Just h
        |otherwise = buscaImpedimento procurado tipo t

    listarImpedimentos:: [Impedimento] -> String
    listarImpedimentos [] = " "
    listarImpedimentos (h:t)
        |tipoImpedimento h == "MEDICAMENTO" = "(Medicamento) >Funcao: "  ++ funcao h  ++ " >Composto: " ++ composto h
                        ++ " >Tempo Supencao: " ++ show (tempoSuspencao h) ++ " Dias\n" ++ listarImpedimentos t
        |tipoImpedimento h == "DOENCA" = "(Doenca) >CID: " ++ cid h ++ " >Tempo Suspencao: " 
                        ++ show (tempoSuspencao h) ++ " Dias\n" ++ listarImpedimentos t

        




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