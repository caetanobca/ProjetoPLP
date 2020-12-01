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
        carregaEstoqueMes <- iniciaEstoqueMes

        today <- toGregorian <$> (utctDay <$> getCurrentTime)
        let mes = (show (getMes today))

        let estoqueMes = getEstoqueMes mes carregaEstoqueMes
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
            salvaEstoqueMes
        else do
            return()                


    hoje :: IO((Integer, Int, Int))
    hoje = do
        today <- toGregorian <$> (utctDay <$> getCurrentTime)    
        return (today)    
    
    getDia :: (a, b, c) -> c
    getDia (_, _, y) = y
    

    getEstoqueMes :: String -> Map String String -> Int
    getEstoqueMes mes estoqueMes
        |member mes estoqueMes == False = 0
        |member mes estoqueMes == True = (read (estoqueMes ! mes) :: Int)

    salvaEstoqueMes :: IO()
    salvaEstoqueMes = do 
        --today <- toGregorian <$> (utctDay <$> getCurrentTime)
        mes <- passaData
        estoque <- Auxiliar.iniciaEstoque
        estoqueMes <- iniciaEstoqueMes
        rescreverEstoqueMes (Estoque.estoqueEmMapa estoque estoqueMes mes)
        
        
    
    passaData :: IO(String)
    passaData = do
        today <- toGregorian <$> (utctDay <$> getCurrentTime)
        return (show (getMes today))

    getMes :: (a, b, c) -> b  
    getMes (_, y, _) = y  
    
    escreverEstoqueMes :: [(String,String)] -> IO()
    escreverEstoqueMes [] = return ()
    escreverEstoqueMes (h:t) = do
        let estoqueMesStr = fst h ++ "," ++ snd h ++ "\n" 
        appendFile "estoqueMes.txt" (estoqueMesStr)
        escreverEstoqueMes t
        return ()

    rescreverEstoqueMes :: [(String,String)] ->IO()
    rescreverEstoqueMes estoqueMes = do
        writeFile "estoqueMes.txt" ("")
        escreverEstoqueMes estoqueMes
        return()

    iniciaEstoqueMes :: IO(Map String String)
    iniciaEstoqueMes = do
        arquivo <- Strict.readFile "estoqueMes.txt"
        let lista = ((Data.List.map ( splitOn ",") (lines arquivo)))
        let lista_estoqueMes = ((Data.List.map constroiEstoqueMes lista))
        let mapa_escala = Map.fromList lista_estoqueMes
        return mapa_escala

    constroiEstoqueMes:: [String] -> (String,String)
    constroiEstoqueMes  estoqueMes = (estoqueMes!!0, estoqueMes!!1)
