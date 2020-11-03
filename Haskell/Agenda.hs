module Agenda where
    
    import qualified Doador as Doador
    import qualified Enfermeiro as Enfermeiro
    import qualified Auxiliar as Auxiliar
    import Data.Map as Map ( Map, insertWith, toList )
    import Data.Time    

    
    agendaDoacaoLocal :: Day -> Map Day String -> String -> String -> [(Day,String)]
    agendaDoacaoLocal diaMes agenda doador enfermeiro = Map.toList(insertWith (++) diaMes novaDoacao agenda)
        where novaDoacao = "Doador: " ++ doador ++ "--" ++ "Enfermeiro :" ++ enfermeiro ++ ""
    
    agendaDoacaoDomicilio :: Day -> Map Day String -> String -> String -> [(Day,String)]
    agendaDoacaoDomicilio diaMes agenda doador enfermeiro = Map.toList(insertWith (++) diaMes novaDoacao agenda)
        where novaDoacao = "Doador: " ++ doador ++ "--" ++ "Enfermeiro :" ++ enfermeiro ++ ""

    

    