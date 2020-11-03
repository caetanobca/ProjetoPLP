module DatasCriticas where
    import Data.Time
    import qualified Estoque as Estoque
    import qualified Bolsa as Bolsa
    import Data.Map as Map
    import System.IO.Unsafe(unsafeDupablePerformIO)
    import Data.List.Split ( splitOn )


    {-
        Verifica se hj eh data critica e atualiza o arquivo que armazena o estoque do mes
    -}
    verificaHoje :: [Bolsa.Bolsa] -> IO()
    verificaHoje estoqueHoje = do
        let estoqueMes = iniciaEstoqueMes

        today <- toGregorian <$> (utctDay <$> getCurrentTime)
        let mes = (show (getMes today))

        let mlAnterior = read (getEstoqueMes mes estoqueMes) :: Int
        let mlHoje = Estoque.totalSangue estoqueHoje
        
        salvaEstoqueMes (estoqueHoje estoqueMes)

        if(mlAnterior > mlHoje)then do 
            putStr ("ESTOQUE BAIXO -CHAMAR METODO QUE AVISA DOADORES-")
        else do
            putStr ("ESTOQUE OK -TALVEZ N FAZER NADA-")
            

        

    getEstoqueMes :: String -> Map String String -> String
    getEstoqueMes mes estoqueMes
        |member mes escala == False = "0"
        |member mes escala == True = Map.lookup mes estoqueMes

    salvaEstoqueMes :: [Bolsa.Bolsa] -> Map String String -> IO()
    salvaEstoqueMes estoque mapa = do 
        today <- toGregorian <$> (utctDay <$> getCurrentTime)
        let mes = (show (getMes today))
        rescreverEstoqueMes (Estoque.estoqueEmMapa estoque mapa mes)

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

    iniciaEstoqueMes :: Map Day String
    iniciaEstoqueMes = do
        let arquivo = unsafeDupablePerformIO(readFile "estoqueMes.txt")
        let lista = ((Data.List.map ( splitOn ",") (lines arquivo)))
        let lista_estoqueMes = ((Data.List.map constroiEstoqueMes lista))
        let mapa_escala = Map.fromList lista_estoqueMes
        return mapa_escala!!0

    constroiEstoqueMes:: [String] -> (String,String)
    constroiEstoqueMes  estoqueMes = (estoqueMes!!0, estoqueMes!!1)
