module Agenda where
    
    import qualified Doador as Doador
    import qualified Enfermeiro as Enfermeiro
    import qualified Auxiliar as Auxiliar
    import Data.Map as Map
    import Data.List.Split ( splitOn )
    import Data.Time    

    
    agendaDoacaoLocal :: Day -> Map Day String -> String -> String -> String -> [(Day,String)]
    agendaDoacaoLocal diaMes agenda doador enfermeiro local = Map.toList(insertWith (++) diaMes novaDoacao agenda)
        where novaDoacao = "Doador: " ++ doador ++ " -- " ++ "Enfermeiro: " ++ enfermeiro ++ " -- " ++ "Local: " ++ local ++ "//"
    
    
    agendaDoacaoImprime :: Map Day String -> Day -> String
    agendaDoacaoImprime mapaAgenda dia 
        |member dia mapaAgenda == False = "Nenhum agendamento para esta data"
        |member dia mapaAgenda == True =  "Doações Agendadas" ++ "\n" ++ (formataDiaAgenda (splitOn "//" (mapaAgenda ! dia)))

    formataDiaAgenda :: [String] -> String
    formataDiaAgenda [] = ""
    formataDiaAgenda (h:t) = h ++ "\n" ++ formataDiaAgenda t