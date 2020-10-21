data Impedimento = Medicamento{ 
     funcao :: String
    ,composto :: String
    ,tempoSuspencao :: String
} | Doenca{
     cid :: String
    ,tempoSuspencao :: String
} deriving (Show)

cadastraImpedimento :: [Impedimento] -> Impedimento -> [Impedimento]
cadastraImpedimento lista impedimento = lista ++ [impedimento]
