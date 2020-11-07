module DatasCriticas where
    import Data.Time
    import qualified Estoque as Estoque
    import qualified Bolsa as Bolsa
    import Data.Map as Map
    import Data.List
    import System.IO.Unsafe(unsafeDupablePerformIO)
    import Data.List.Split ( splitOn )
    import qualified Auxiliar as Auxiliar
    import qualified System.IO.Strict as Strict


    {-
        Verifica se hj eh data critica e atualiza o arquivo que armazena o estoque do mes
    -}
    verificaHoje :: [Bolsa.Bolsa] -> IO(String)
    verificaHoje estoqueHoje = do
        carregaEstoqueMes <- iniciaHistoricoEstoque

        today <- (utctDay <$> getCurrentTime)
        

        let estoqueMes = getHistoricoEstoque today carregaEstoqueMes
        if(estoqueMes /= 0) then do
            let mlAnterior = (read (show estoqueMes) :: Float)
            let mlHoje = (read (show (Estoque.totalSangue estoqueHoje)) ::Float)
            if ((mlAnterior * 0.50) >= mlHoje) then do
                salvaHistoricoEstoque
                return ("ESTOQUE EM ESTADO CRITICO SOLICITAR DOACOES")
            else if ((mlAnterior * 0.90) >= mlHoje)then do
                salvaHistoricoEstoque
                return ("ESTOQUE ABAIXO DA MEDIA")
            else if((mlAnterior * 1.10) >= mlHoje )then do 
                salvaHistoricoEstoque
                return ("ESTOQUE NA MEDIA")
            else if((mlAnterior * 1.50) >= mlHoje )then do 
                salvaHistoricoEstoque
                return ("ESTOQUE ACIMA DA MEDIA")
            else do
                salvaHistoricoEstoque
                return ("ESTOQUE EM OTIMAS CONDICOES")
        else do
            salvaHistoricoEstoque
            return ("SEM HISTORICO DE ESTOQUE")
              


    hoje :: IO((Integer, Int, Int))
    hoje = do
        today <- toGregorian <$> (utctDay <$> getCurrentTime)    
        return (today)    
    
    getDia :: (a, b, c) -> c
    getDia (_, _, y) = y
    

    getHistoricoEstoque :: Day -> Map Day String -> Int
    getHistoricoEstoque today historicoEstoque
        |member today historicoEstoque == False = 0
        |member today historicoEstoque == True = (read (historicoEstoque ! today) :: Int)

    salvaHistoricoEstoque :: IO()
    salvaHistoricoEstoque = do 
        today <- (utctDay <$> getCurrentTime)
        estoque <- Auxiliar.iniciaEstoque
        estoqueAntigo <- iniciaHistoricoEstoque
        rescreveHistoricoEstoque (Estoque.estoqueEmMapa estoque estoqueAntigo today)
    
    escreveHistoricoEstoque :: [(Day,String)] -> IO()
    escreveHistoricoEstoque [] = return ()
    escreveHistoricoEstoque (h:t) = do
        let estoqueMesStr = (show (fst h)) ++ "," ++ snd h ++ "\n" 
        appendFile "estoqueMes.txt" (estoqueMesStr)
        escreveHistoricoEstoque t
        return ()

    rescreveHistoricoEstoque :: [(Day,String)] ->IO()
    rescreveHistoricoEstoque estoque = do
        writeFile "estoqueMes.txt" ("")
        escreveHistoricoEstoque estoque
        return()

    iniciaHistoricoEstoque :: IO(Map Day String)
    iniciaHistoricoEstoque = do
        arquivo <- Strict.readFile "estoqueMes.txt"
        let lista = ((Data.List.map ( splitOn ",") (lines arquivo)))
        let lista_estoqueMes = ((Data.List.map constroiHistoricoEstoque lista))
        let mapa_escala = Map.fromList lista_estoqueMes
        return mapa_escala

    constroiHistoricoEstoque:: [String] -> (Day,String)
    constroiHistoricoEstoque  estoqueMes = ((stringEmDataAmericana (estoqueMes!!0)), estoqueMes!!1)

    historicoEstoque :: IO(String)
    historicoEstoque = do
        carregaEstoqueMes <- iniciaHistoricoEstoque
        today <- (utctDay <$> getCurrentTime)
        return (show (getHistoricoEstoque today carregaEstoqueMes))

    getMes :: (a, b, c) -> b  
    getMes (_, y, _) = y  


    stringEmDataAmericana :: String -> Day
    stringEmDataAmericana dados = fromGregorian (read (datas!!0)) (read (datas!!1)) (read (datas!!2))
        where datas = splitOn ("-") dados