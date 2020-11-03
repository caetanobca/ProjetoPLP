
module Auxiliar where

import qualified Recebedor as Recebedor
--import qualified Doador as Doador
import qualified Impedimento as Impedimento
import qualified Enfermeiro as Enfermeiro
import qualified Recebedor as Recebedor
import qualified Estoque as Estoque
import qualified Bolsa as Bolsa
import Data.Map as Map
import Data.List
import System.IO.Unsafe(unsafeDupablePerformIO)
import Data.List.Split ( splitOn )
import Data.Typeable
import Data.Time.Calendar

--Esses metodos vai carregar os empedimentos que estavam salvos em um arquivo
iniciaImpedimentos :: [Impedimento.Impedimento]
iniciaImpedimentos = do
    let arquivo = unsafeDupablePerformIO(readFile "impedimentos.txt")
    let lista = ((Data.List.map ( splitOn ",") (lines arquivo)))
    let lista_impedimentos = ((Data.List.map constroiImpedimento lista))
    return lista_impedimentos !! 0

constroiImpedimento ::[String] -> Impedimento.Impedimento
constroiImpedimento lista = 
    if((lista!! 0) == "MEDICAMENTO") then Impedimento.Medicamento{
        Impedimento.tipoImpedimento = lista !! 0,
        Impedimento.funcao = lista !! 1,
        Impedimento.composto = lista !! 2,
        Impedimento.tempoSuspencao = read (lista !! 3)}
    else
        Impedimento.Doenca{
        Impedimento.tipoImpedimento = lista !! 0,
        Impedimento.cid = lista !! 1,
        Impedimento.tempoSuspencao = read (lista !! 2)}

iniciaEnfermeiros :: [Enfermeiro.Enfermeiro]
iniciaEnfermeiros = do
    let arquivo = unsafeDupablePerformIO(readFile "enfermeiros.txt")
    let lista = ((Data.List.map ( splitOn ",") (lines arquivo)))
    let lista_enfermeiros = ((Data.List.map constroiEnfermeiro lista))
    return lista_enfermeiros !! 0

constroiEnfermeiro:: [String] -> Enfermeiro.Enfermeiro
constroiEnfermeiro lista = 
    Enfermeiro.Enfermeiro{
        Enfermeiro.nome = lista !! 0,
        Enfermeiro.endereco = lista !! 1,
        Enfermeiro.idade = read (lista !! 2),
        Enfermeiro.telefone = lista !! 3
    }

escreverBolsa:: Bolsa.Bolsa -> IO()
escreverBolsa bolsa = do
    let bolsaStr = Bolsa.tipoSanguineo bolsa ++ ","++ show (Bolsa.qtdSangue bolsa) ++ "\n"
    appendFile "estoque.txt" (bolsaStr)
    return ()

iniciaEscala :: Map Day String
iniciaEscala = do
    let arquivo = unsafeDupablePerformIO(readFile "escala.txt")
    let lista = ((Data.List.map ( splitOn ",") (lines arquivo)))
    let lista_enfermeiros = ((Data.List.map constroiEscala lista))
    let mapa_escala = Map.fromList lista_enfermeiros
    return mapa_escala!!0

constroiEscala:: [String] -> (Day,String)
constroiEscala  diaMesEnfermeiros = ((stringEmDataAmericana (diaMesEnfermeiros!!0)),diaMesEnfermeiros!!1)


iniciaAgendaLocal :: Map Day String
iniciaAgendaLocal = do
    let arquivo = unsafeDupablePerformIO(readFile "agendaLocal.txt")
    let lista = ((Data.List.map ( splitOn ",") (lines arquivo)))
    let lista_agenda = ((Data.List.map constroiAgendaLocal lista))
    let mapa_escala = Map.fromList lista_agenda
    return mapa_escala!!0
    
constroiAgendaLocal:: [String] -> (Day,String)
constroiAgendaLocal  diaMesAgenda = ((stringEmDataAmericana (diaMesAgenda!!0)),diaMesAgenda!!1)

iniciaEstoque :: [Bolsa.Bolsa]
iniciaEstoque = [(Bolsa.Bolsa "A+" 450), (Bolsa.Bolsa "O-" 400)]
    
--iniciaEscala :: Map String String
--iniciaEscala = Map.fromList [("16/10", "José"), ("17/10","Pedro")]

--esses metodos criam txts responsaveis por armazenar os dados do sistema       
criaArquivos :: IO()
criaArquivos = do
    appendFile "impedimentos.txt" ("")
    appendFile "enfermeiros.txt" ("")
    appendFile "estoque.txt" ("")
    appendFile "escala.txt" ("")
    appendFile "doador.txt" ("")
    appendFile "agendaLocal.txt" ("")
    appendFile "agendaDomicilio.txt" ("")


--metodos q vao salvar as listas 
--esses metodos irão escrever novas informações no arquivo de cada tipo   
escreverImpedimento:: Impedimento.Impedimento -> IO ()
escreverImpedimento impedimento = do
    if(Impedimento.tipoImpedimento impedimento) == "MEDICAMENTO" then do
        let impedimentoStr =  Impedimento.tipoImpedimento impedimento ++ "," ++ Impedimento.funcao impedimento ++ "," ++ Impedimento.composto impedimento ++ "," ++ show (Impedimento.tempoSuspencao impedimento) ++ "\n"
        appendFile "impedimentos.txt" (impedimentoStr)
        return ()  
    else do  
        let impedimentoStr =  Impedimento.tipoImpedimento impedimento ++ "," ++ Impedimento.cid impedimento ++ "," ++ show (Impedimento.tempoSuspencao impedimento) ++ "\n"
        appendFile "impedimentos.txt" (impedimentoStr)
        return ()   

escreverEnfermeiros :: Enfermeiro.Enfermeiro -> IO()
escreverEnfermeiros enfermeiro = do
    let enfermeiroStr = Enfermeiro.nome enfermeiro ++ "," ++ Enfermeiro.endereco enfermeiro ++ "," ++ show (Enfermeiro.idade enfermeiro) ++ "," ++ Enfermeiro.telefone enfermeiro ++ "\n"
    appendFile "enfermeiros.txt" (enfermeiroStr)
    return ()

escreverEscala :: [(Day,String)] -> IO()
escreverEscala [] = return ()
escreverEscala (h:t) = do
    let escalaStr = (show (fst h)) ++ "," ++ snd h ++ "\n" 
    appendFile "escala.txt" (escalaStr)
    escreverEscala t
    return ()

rescreverEscala :: [(Day,String)] ->IO()
rescreverEscala escala = do
    writeFile "escala.txt" ("")
    escreverEscala escala
    return()

escreverAgendaLocal :: [(Day,String)] -> IO()
escreverAgendaLocal [] = return ()
escreverAgendaLocal (h:t) = do
    let agendaStr = (show (fst h)) ++ "," ++ snd h ++ "\n" 
    appendFile "agendaLocal.txt" (agendaStr)
    escreverAgendaLocal t
    return ()

rescreverAgendaLocal :: [(Day,String)] ->IO()
rescreverAgendaLocal agendaLocal = do
    writeFile "agendaLocal.txt" ("")
    escreverAgendaLocal agendaLocal
    return()

stringEmData :: String -> Day
stringEmData dados = fromGregorian (read (datas!!2)) (read (datas!!1)) (read (datas!!0))
    where datas = splitOn ("/") dados

stringEmDataAmericana :: String -> Day
stringEmDataAmericana dados = fromGregorian (read (datas!!0)) (read (datas!!1)) (read (datas!!2))
    where datas = splitOn ("-") dados
    
iniciaRecebedores :: [Recebedor.Recebedor]
iniciaRecebedores = [(Recebedor.Recebedor "Lukas Nascimento" "Rua Princesa Isabel" 21 "33442211" 1250), (Recebedor.Recebedor "Maria Oliveira" "Rua Manoel Tavares" 64 "33123322" 1000)]



{--
iniciaDoador :: [Doador.Doador]
iniciaDoador = do
    let arquivo = unsafeDupablePerformIO(readFile "doador.txt")
    let lista = ((Data.List.map ( splitOn ",") (lines arquivo)))
    let lista_doador = ((Data.List.map constroiDoador lista))
    return lista_doador !! 0

constroiDoador :: [String] -> Doador.Doador
constroiDoador lista = 
    Doador.Doador{
        Doador.nome = lista !! 0,
        Doador.endereco = lista !! 1,
        Doador.idade = read (lista !! 2),
        Doador.telefone = lista !! 3,
        Doador.impedimentoStr =  lista !! 4,
        Doador.ultimoDiaImpedido =  lista !! 5,
        Doador.doacoes = lista !! 6
--}

{--
escreverDoador :: Doador.Doador -> IO()
escreverDoador doador = do
    let doadorStr = Doador.nome doador ++ "," ++ Doador.endereco doador ++ "," ++ show (Doador.idade doador) ++ "," ++ Doador.telefone doador ++ "," ++ Doador.impedimento doador ++ "," ++ Doador.ultimoDiaImpedido doador ++ "," ++ Doador.doacoes doador ++  "\n"
    appendFile "doador.txt" (doadorStr)
    return ()


rescreverDoador :: [(Day,String)] ->IO()
rescreverDoador doador = do
    writeFile "doador.txt" ("")
    escreverDoador doador
    return()

--}

--Implementar metodo q vai salvar a lista de impedimentos


