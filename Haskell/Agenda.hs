module Agenda where
    
    import qualified Doador as Doador
    import qualified Enfermeiro as Enfermeiro
    import qualified Auxiliar as Auxiliar
    import System.IO.Unsafe(unsafeDupablePerformIO)
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

    agendaLocalToString :: [(Day,String)] -> String
    agendaLocalToString [] = ""
    agendaLocalToString (h:t)
        |verificaDataValida (fst h) == True = (dayParaString (fst h)) ++ " " ++ snd h ++ "\n" ++  agendaLocalToString t
        |otherwise =  agendaLocalToString t

    verificaDataValida :: Day -> Bool
    verificaDataValida dia
        |hoje > dia = False
        |otherwise = True
        where hoje = unsafeDupablePerformIO((utctDay <$> getCurrentTime))

    dayParaString :: Day -> String
    dayParaString dia = show (getDia diaMesAno) ++ "/" ++ show (getMes diaMesAno) ++ "/" ++ show (getAno diaMesAno)
        where diaMesAno = toGregorian dia
    
    getAno :: (a, b, c) -> a
    getAno (y, _, _) = y
    getMes :: (a, b, c) -> b
    getMes (_, y, _) = y
    getDia :: (a, b, c) -> c
    getDia (_, _, y) = y
