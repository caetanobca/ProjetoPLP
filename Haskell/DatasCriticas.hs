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
    verificaHoje :: [Bolsa.Bolsa] -> IO()
    verificaHoje estoqueHoje = do
        carregaEstoqueMes <- iniciaHistoricoEstoque

        today <- toGregorian <$> (utctDay <$> getCurrentTime)
        let mes = (show (getMes today))

        let estoqueMes = getHistoricoEstoque mes carregaEstoqueMes
        if(estoqueMes /= 0) then do
            let mlAnterior = (read (show estoqueMes) :: Float)
            let mlHoje = (read (show (Estoque.totalSangue estoqueHoje)) ::Float)
            if ((mlAnterior * 0.50) >= mlHoje) then do
                putStrLn("ESTOQUE EM ESTADO CRITICO SOLICITAR DOACOES")
            else if ((mlAnterior * 0.90) >= mlHoje)then do
                putStrLn ("ESTOQUE ABAIXO DA MEDIA")
            else if((mlAnterior * 1.10) >= mlHoje )then do 
                putStrLn("ESTOQUE NA MEDIA")
            else if((mlAnterior * 1.50) >= mlHoje )then do 
                putStrLn("ESTOQUE ACIMA DA MEDIA")
            else do
                putStrLn("ESTOQUE EM OTIMAS CONDICOES")
        else do
            putStrLn ("SEM HISTORICO DE ESTOQUE")
                   
        today <- hoje
        if((getDia today) == 1) then do
            salvaHistoricoEstoque
        else do
            return()                


    hoje :: IO((Integer, Int, Int))
    hoje = do
        today <- toGregorian <$> (utctDay <$> getCurrentTime)    
        return (today)    
    
    getDia :: (a, b, c) -> c
    getDia (_, _, y) = y
    

    getHistoricoEstoque :: String -> Map String String -> Int
    getHistoricoEstoque mes estoqueMes
        |member mes estoqueMes == False = 0
        |member mes estoqueMes == True = (read (estoqueMes ! mes) :: Int)

    salvaHistoricoEstoque :: IO()
    salvaHistoricoEstoque = do 
        --today <- toGregorian <$> (utctDay <$> getCurrentTime)
        mes <- passaData
        estoque <- Auxiliar.iniciaEstoque
        estoqueMes <- iniciaHistoricoEstoque
        rescreveHistoricoEstoque (Estoque.estoqueEmMapa estoque estoqueMes mes)
        
    
    passaData :: IO(String)
    passaData = do
        today <- toGregorian <$> (utctDay <$> getCurrentTime)
        return (show (getMes today))

    getMes :: (a, b, c) -> b  
    getMes (_, y, _) = y  
    
    escreveHistoricoEstoque :: [(String,String)] -> IO()
    escreveHistoricoEstoque [] = return ()
    escreveHistoricoEstoque (h:t) = do
        let estoqueMesStr = fst h ++ "," ++ snd h ++ "\n" 
        appendFile "estoqueMes.txt" (estoqueMesStr)
        escreveHistoricoEstoque t
        return ()

    rescreveHistoricoEstoque :: [(String,String)] ->IO()
    rescreveHistoricoEstoque estoqueMes = do
        writeFile "estoqueMes.txt" ("")
        escreveHistoricoEstoque estoqueMes
        return()

    iniciaHistoricoEstoque :: IO(Map String String)
    iniciaHistoricoEstoque = do
        arquivo <- Strict.readFile "estoqueMes.txt"
        let lista = ((Data.List.map ( splitOn ",") (lines arquivo)))
        let lista_estoqueMes = ((Data.List.map constroiHistoricoEstoque lista))
        let mapa_escala = Map.fromList lista_estoqueMes
        return mapa_escala

    constroiHistoricoEstoque:: [String] -> (String,String)
    constroiHistoricoEstoque  estoqueMes = (estoqueMes!!0, estoqueMes!!1)

    historicoEstoque :: IO(String)
    historicoEstoque = do
        carregaEstoqueMes <- iniciaHistoricoEstoque
        today <- toGregorian <$> (utctDay <$> getCurrentTime)
        let mes = (show (getMes today))
        return (show (getHistoricoEstoque mes carregaEstoqueMes))


