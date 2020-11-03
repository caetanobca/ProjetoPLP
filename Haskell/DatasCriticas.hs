module DatasCriticas where
    import Data.Time
    import qualified Estoque as Estoque
    import qualified Bolsa as Bolsa
    import Data.Map as Map
    import Data.List
    import System.IO.Unsafe(unsafeDupablePerformIO)
    import Data.List.Split ( splitOn )
    import qualified Auxiliar as Auxiliar


    {-
        Verifica se hj eh data critica e atualiza o arquivo que armazena o estoque do mes
    -}
    verificaHoje :: [Bolsa.Bolsa] -> IO()
    verificaHoje estoqueHoje = do
        let estoqueMes = iniciaEstoqueMes

        today <- toGregorian <$> (utctDay <$> getCurrentTime)
        let mes = (show (getMes today))

        let estoqueMes = getEstoqueMes mes iniciaEstoqueMes
        if(estoqueMes /= Nothing) then do
            let mlAnterior = (read (show estoqueMes)) :: Int
            let mlHoje = Estoque.totalSangue estoqueHoje
            salvaEstoqueMes
            if(mlAnterior > mlHoje)then do 
            putStr ("ESTOQUE BAIXO -CHAMAR METODO QUE AVISA DOADORES-")
            else do
            putStr ("ESTOQUE OK -TALVEZ N FAZER NADA-") 

        else do
            let mlAnterior = 0
            let mlHoje = Estoque.totalSangue estoqueHoje
            salvaEstoqueMes
            if(mlAnterior > mlHoje)then do 
            putStr ("ESTOQUE BAIXO -CHAMAR METODO QUE AVISA DOADORES-")
            else do
            putStr ("ESTOQUE OK -TALVEZ N FAZER NADA-")                   

        

    getEstoqueMes :: String -> Map String String -> Maybe String
    getEstoqueMes mes estoqueMes
        |member mes estoqueMes == False = Nothing
        |member mes estoqueMes == True = Map.lookup mes estoqueMes

    salvaEstoqueMes :: IO()
    salvaEstoqueMes = do 
        --today <- toGregorian <$> (utctDay <$> getCurrentTime)
        mes <- passaData
        rescreverEstoqueMes (Estoque.estoqueEmMapa Auxiliar.iniciaEstoque iniciaEstoqueMes mes)
        
        
    
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

    iniciaEstoqueMes :: Map String String
    iniciaEstoqueMes = do
        let arquivo = unsafeDupablePerformIO(readFile "estoqueMes.txt")
        let lista = ((Data.List.map ( splitOn ",") (lines arquivo)))
        let lista_estoqueMes = ((Data.List.map constroiEstoqueMes lista))
        let mapa_escala = Map.fromList lista_estoqueMes
        return mapa_escala!!0

    constroiEstoqueMes:: [String] -> (String,String)
    constroiEstoqueMes  estoqueMes = (estoqueMes!!0, estoqueMes!!1)
