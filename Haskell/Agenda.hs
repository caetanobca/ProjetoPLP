module Agenda where
    
    import qualified Doador as Doador
    import qualified Enfermeiro as Enfermeiro
    import qualified Auxiliar as Auxiliar
    import Data.Map as Map ( Map, insertWith, toList )
    import Data.Time    

    
    agendaDoacaoLocal :: Day -> Map Day String -> String -> String -> String -> [(Day,String)]
    agendaDoacaoLocal diaMes agenda doador enfermeiro local = Map.toList(insertWith (++) diaMes novaDoacao agenda)
        where novaDoacao = "Doador: " ++ doador ++ "--" ++ "Enfermeiro :" ++ enfermeiro ++ "Local:" ++ local
    
    
    

    