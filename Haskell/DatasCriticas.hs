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
                return ("ESTOQUE EM ESTADO CRITICO SOLICITAR DOACOES")
            else if ((mlAnterior * 0.90) >= mlHoje)then do
                return ("ESTOQUE ABAIXO DA MEDIA")
            else if((mlAnterior * 1.10) >= mlHoje )then do 
                return ("ESTOQUE NA MEDIA")
            else if((mlAnterior * 1.50) >= mlHoje )then do 
                return ("ESTOQUE ACIMA DA MEDIA")
            else do
                return ("ESTOQUE EM OTIMAS CONDICOES")
        else do
            return ("SEM HISTORICO DE ESTOQUE")
              


    hoje :: IO((Integer, Int, Int))
    hoje = do
        today <- toGregorian <$> (utctDay <$> getCurrentTime)    
        return (today)    
    
    getDiaMes :: (a, Int, Int) -> String
    getDiaMes (_, x, y) = (show y ++ "-" ++ show x)
    

    getHistoricoEstoque :: Day -> Map String String -> Int
    getHistoricoEstoque today historicoEstoque
        |member diaMes historicoEstoque == False = 0
        |member diaMes historicoEstoque == True = (read (historicoEstoque ! diaMes) :: Int)
        where diaMes = (getDiaMes (toGregorian today))

    salvaHistoricoEstoque :: IO()
    salvaHistoricoEstoque = do 
        today <- (utctDay <$> getCurrentTime)
        estoque <- Auxiliar.iniciaEstoque
        estoqueAntigo <- iniciaHistoricoEstoque
        rescreveHistoricoEstoque (Estoque.estoqueEmMapa estoque estoqueAntigo today)
    
    escreveHistoricoEstoque :: [(String,String)] -> IO()
    escreveHistoricoEstoque [] = return ()
    escreveHistoricoEstoque (h:t) = do
        let estoqueMesStr = (fst h) ++ "," ++ snd h ++ "\n" 
        appendFile "dados/historicoEstoque.txt" (estoqueMesStr)
        escreveHistoricoEstoque t
        return ()

    rescreveHistoricoEstoque :: [(String,String)] ->IO()
    rescreveHistoricoEstoque estoque = do
        writeFile "dados/historicoEstoque.txt" ("")
        escreveHistoricoEstoque estoque
        return()

    iniciaHistoricoEstoque :: IO(Map String String)
    iniciaHistoricoEstoque = do
        arquivo <- Strict.readFile "dados/historicoEstoque.txt"
        let lista = ((Data.List.map ( splitOn ",") (lines arquivo)))
        let lista_estoqueMes = ((Data.List.map constroiHistoricoEstoque lista))
        let mapa_escala = Map.fromList lista_estoqueMes
        return mapa_escala

    constroiHistoricoEstoque:: [String] -> (String,String)
    constroiHistoricoEstoque  estoqueMes = (estoqueMes!!0, estoqueMes!!1)

    historicoEstoque :: IO(String)
    historicoEstoque = do
        carregaEstoqueMes <- iniciaHistoricoEstoque
        today <- (utctDay <$> getCurrentTime)
        return (show (getHistoricoEstoque today carregaEstoqueMes))

    stringEmDataAmericana :: String -> Day
    stringEmDataAmericana dados = fromGregorian (read (datas!!0)) (read (datas!!1)) (read (datas!!2))
        where datas = splitOn ("-") dados