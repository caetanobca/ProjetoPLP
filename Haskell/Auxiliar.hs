
module Auxiliar where

import qualified Recebedor as Recebedor
import qualified FichaMedica as FichaMedica
--import qualified Doador as Doador
import qualified Impedimento as Impedimento
import qualified Enfermeiro as Enfermeiro
import qualified Recebedor as Recebedor
import qualified Estoque as Estoque
import qualified Bolsa as Bolsa
import qualified Doador as Doador
import Data.Map as Map ( fromList, Map)
import Data.List
import System.IO.Unsafe(unsafeDupablePerformIO)
import Data.List.Split ( splitOn )
import Data.Typeable
import Data.Time.Calendar
import qualified System.IO.Strict as Strict


--Esses metodos vão iniciar os arrays salvos
iniciaImpedimentos :: IO([Impedimento.Impedimento])
iniciaImpedimentos = do
    arquivo <- Strict.readFile "impedimentos.txt"
    let lista = ((Data.List.map ( splitOn ",") (lines arquivo)))
    let lista_impedimentos = ((Data.List.map constroiImpedimento lista))
    return lista_impedimentos

iniciaEnfermeiros :: IO([Enfermeiro.Enfermeiro])
iniciaEnfermeiros = do
    arquivo <- Strict.readFile "enfermeiros.txt"    
    let lista = ((Data.List.map ( splitOn ",") (lines arquivo)))
    let lista_enfermeiros = ((Data.List.map constroiEnfermeiro lista))   
    return lista_enfermeiros

iniciaEscala :: IO(Map Day String)
iniciaEscala = do
    arquivo <- Strict.readFile "escala.txt"
    let lista = ((Data.List.map ( splitOn ",") (lines arquivo)))
    let lista_escala = ((Data.List.map constroiEscala lista))
    let mapa_escala = Map.fromList lista_escala
    return mapa_escala

iniciaAgendaLocal :: IO(Map Day String)
iniciaAgendaLocal = do
    arquivo <- Strict.readFile "agendaLocal.txt"
    let lista = ((Data.List.map ( splitOn ",") (lines arquivo)))
    let lista_agenda = ((Data.List.map constroiAgendaLocal lista))
    let mapa_escala = Map.fromList lista_agenda
    return mapa_escala

iniciaEstoque :: IO([Bolsa.Bolsa])
iniciaEstoque = do
    arquivo <- Strict.readFile "estoque.txt"
    let lista = Data.List.map ( splitOn ",") (lines arquivo)
    let lista_estoque = (Data.List.map constroiEstoque lista)
    return lista_estoque


iniciaRecebedores :: IO([Recebedor.Recebedor])
iniciaRecebedores = do
    arquivo <- Strict.readFile "recebedor.txt"
    let lista = ((Data.List.map ( splitOn ",") (lines arquivo)))
    let lista_recebedor = ((Data.List.map constroiRecebedor lista))
    return lista_recebedor   
    

iniciaDoador :: IO([Doador.Doador])
iniciaDoador = do
    arquivo <- Strict.readFile "doador.txt"
    let lista = ((Data.List.map ( splitOn ",") (lines arquivo)))
    let lista_doador = ((Data.List.map constroiDoador lista))
    return lista_doador


constroiRecebedor :: [String] -> Recebedor.Recebedor
constroiRecebedor lista =
    Recebedor.Recebedor{ 
    Recebedor.nome = lista!!0,
    Recebedor.endereco  = lista !!1,
    Recebedor.idade = read(lista!!2),
    Recebedor.telefone = lista!!3,
    Recebedor.numDeBolsas = read(lista!!4),
    Recebedor.tipoSanguineo = lista!!5,
    Recebedor.hospital = lista!!6,
    Recebedor.fichaMedica = constroiFichaMedica (splitOn "-" (lista!!7))
    }

constroiFichaMedica :: [String] -> FichaMedica.FichaMedica
constroiFichaMedica lista =
    FichaMedica.FichaMedica{
        FichaMedica.sexo = lista!!0,
        FichaMedica.dataNascimento = lista!!1,
        FichaMedica.pai = lista!!2,
        FichaMedica.mae = lista!!3,
        FichaMedica.acompanhamentoMedico = lista!!4,
        FichaMedica.condicaoFisica = lista!!5,
        FichaMedica.alergias = lista!!6        
    }

--Esses métodos irão construir os TypeClasses do sistema
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

constroiEstoque:: [String] -> Bolsa.Bolsa
constroiEstoque lista = 
    Bolsa.Bolsa{
        Bolsa.tipoSanguineo = lista !! 0,
        Bolsa.qtdSangue = read (lista !! 1)
    }

constroiEnfermeiro:: [String] -> Enfermeiro.Enfermeiro
constroiEnfermeiro lista = 
    Enfermeiro.Enfermeiro{
        Enfermeiro.nome = lista !! 0,
        Enfermeiro.endereco = lista !! 1,
        Enfermeiro.idade = read (lista !! 2),
        Enfermeiro.telefone = lista !! 3
    }

constroiDoador :: [String] -> Doador.Doador
constroiDoador lista = 
    Doador.Doador{
        Doador.nome = lista !! 0,
        Doador.endereco = lista !! 1,
        Doador.idade = read (lista !! 2),
        Doador.telefone = lista !! 3,
        Doador.tipSanguineo = lista !! 4,
        Doador.impedimentoStr =  lista !! 5,
        Doador.ultimoDiaImpedido =  (stringEmDataAmericana (lista !! 6)),
        Doador.doacoes = lista !! 7 
        }

constroiEscala:: [String] -> (Day,String)
constroiEscala  diaMesEnfermeiros = ((stringEmDataAmericana (diaMesEnfermeiros!!0)),diaMesEnfermeiros!!1)

constroiAgendaLocal:: [String] -> (Day,String)
constroiAgendaLocal  diaMesAgenda = ((stringEmDataAmericana (diaMesAgenda!!0)),diaMesAgenda!!1)



--esse metodos cria todos txts responsaveis por armazenar os dados do sistema       
criaArquivos :: IO()
criaArquivos = do
    appendFile "impedimentos.txt" ("")
    appendFile "enfermeiros.txt" ("")
    appendFile "estoque.txt" ("")
    appendFile "escala.txt" ("")
    appendFile "doador.txt" ("")
    appendFile "agendaLocal.txt" ("")
    appendFile "estoqueMes.txt" ("")
    appendFile "recebedor.txt" ("")


--metodos q vao salvar as listas 
--esses metodos irão escrever novas informalçoes ou reescrever informações no arquivo de cada tipo   
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

escreverImpedimentos :: [Impedimento.Impedimento] -> IO()
escreverImpedimentos [] = return ()
escreverImpedimentos (h:t) = do
    if(Impedimento.tipoImpedimento h) == "MEDICAMENTO" then do
        let impedimentoStr =  Impedimento.tipoImpedimento h ++ "," ++ Impedimento.funcao h ++ "," ++ Impedimento.composto h ++ "," ++ show (Impedimento.tempoSuspencao h) ++ "\n"
        appendFile "impedimentos.txt" (impedimentoStr)
        escreverImpedimentos t
        return ()  
    else do  
        let impedimentoStr =  Impedimento.tipoImpedimento h ++ "," ++ Impedimento.cid h ++ "," ++ show (Impedimento.tempoSuspencao h) ++ "\n"
        appendFile "impedimentos.txt" (impedimentoStr)
        escreverImpedimentos t
        return ()  

rescreverImpedimento :: [Impedimento.Impedimento] ->IO()
rescreverImpedimento impedimentos = do
    writeFile "impedimentos.txt" ("")
    escreverImpedimentos impedimentos
    return()

escreverEnfermeiros :: Enfermeiro.Enfermeiro -> IO()
escreverEnfermeiros enfermeiro = do
    let enfermeiroStr = Enfermeiro.nome enfermeiro ++ "," ++ Enfermeiro.endereco enfermeiro ++ "," ++ show (Enfermeiro.idade enfermeiro) ++ "," ++ Enfermeiro.telefone enfermeiro ++ "\n"
    appendFile "enfermeiros.txt" (enfermeiroStr)
    return ()

escreverRecebedores :: Recebedor.Recebedor -> IO()
escreverRecebedores recebedor = do
    let recebedorStr = Recebedor.nome recebedor ++ "," ++ Recebedor.endereco recebedor ++ "," ++ show(Recebedor.idade recebedor) ++ "," ++ Recebedor.telefone recebedor ++ "," ++ show(Recebedor.numDeBolsas recebedor) ++ "," ++ Recebedor.tipoSanguineo recebedor ++ "," ++ Recebedor.hospital recebedor ++ "," ++ escreveFichaMedica (Recebedor.fichaMedica recebedor) ++ "\n" 
    appendFile "recebedor.txt" (recebedorStr)
    return ()

escreveFichaMedica :: FichaMedica.FichaMedica -> String
escreveFichaMedica ficha = FichaMedica.sexo ficha ++ "-" ++ FichaMedica.dataNascimento ficha ++ "-" ++ FichaMedica.pai ficha ++ "-" ++ FichaMedica.mae ficha ++ "-" ++ FichaMedica.acompanhamentoMedico ficha ++ "-" ++ FichaMedica.condicaoFisica ficha ++ "-" ++ FichaMedica.alergias ficha
     

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

escreverEstoque:: [Bolsa.Bolsa] -> IO()
escreverEstoque [] = return ()
escreverEstoque (h:t) = do
    let bolsaStr = Bolsa.tipoSanguineo h ++ ","++ show (Bolsa.qtdSangue h) ++ "\n"
    appendFile "estoque.txt" (bolsaStr)
    escreverEstoque t
    return ()

reescreveEstoque :: [Bolsa.Bolsa] ->IO()
reescreveEstoque estoque = do
    writeFile "estoque.txt" ("")
    escreverEstoque estoque
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

escreverDoador :: Doador.Doador -> IO()
escreverDoador doador = do
    let doadorStr = Doador.nome doador ++ "," ++ Doador.endereco doador ++ "," ++ (show (Doador.idade doador)) ++ "," ++ Doador.telefone doador ++ "," ++ Doador.tipSanguineo doador ++ "," ++ Doador.impedimentoStr doador ++ "," ++ (show (Doador.ultimoDiaImpedido doador)) ++ "," ++ Doador.doacoes doador ++  "\n" 
    appendFile "doador.txt" (doadorStr) 
    return ()

escreverDoadores :: [Doador.Doador] -> IO()
escreverDoadores [] = return ()
escreverDoadores (h:t) = do
    let doadorStr = Doador.nome h ++ "," ++ Doador.endereco h ++ "," ++ (show (Doador.idade h)) ++ "," ++ Doador.telefone h ++ "," ++ Doador.tipSanguineo h ++ "," ++ Doador.impedimentoStr h ++ "," ++ (show (Doador.ultimoDiaImpedido h)) ++ "," ++ Doador.doacoes h ++  "\n" 
    appendFile "doador.txt" (doadorStr)
    escreverDoadores t
    return ()

rescreverDoador :: [Doador.Doador] ->IO()
rescreverDoador doador = do
    writeFile "doador.txt" ("")
    escreverDoadores doador
    return()

--metodos auxiliares de formatação
stringEmData :: String -> Day
stringEmData dados = fromGregorian (read (datas!!2)) (read (datas!!1)) (read (datas!!0))
    where datas = splitOn ("/") dados

stringEmDataAmericana :: String -> Day
stringEmDataAmericana dados = fromGregorian (read (datas!!0)) (read (datas!!1)) (read (datas!!2))
    where datas = splitOn ("-") dados

verificaDataPassada :: String -> Bool
verificaDataPassada dia
    |hoje > stringEmData dia = False
    |otherwise = True
    where hoje = unsafeDupablePerformIO(Impedimento.getHoje)

