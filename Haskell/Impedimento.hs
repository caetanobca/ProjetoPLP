module Impedimento where
    
data Impedimento = Medicamento{ 
     funcao :: String
    ,composto :: String
    ,tempoSuspencao :: String
} | Doenca{
     cid :: String
    ,tempoSuspencao :: String
} deriving (Show,Eq)
