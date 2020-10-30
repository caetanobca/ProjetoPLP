
module Auxiliar where

import qualified Recebedor as Recebedor
import qualified Impedimento as Impedimento
import qualified Enfermeiro as Enfermeiro
import qualified Recebedor as Recebedor
import qualified Estoque as Estoque
import qualified Bolsa as Bolsa
import Data.Map as Map
import Data.List
import System.IO.Unsafe(unsafeDupablePerformIO)
import Data.List.Split
import Data.Typeable

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

iniciaEscala :: Map String String
iniciaEscala = do
    let arquivo = unsafeDupablePerformIO(readFile "escala.txt")
    let lista = ((Data.List.map ( splitOn ",") (lines arquivo)))
    let lista_enfermeiros = ((Data.List.map constroiEscala lista))
    let mapa_escala = Map.fromList lista_enfermeiros
    return mapa_escala !! 0

constroiEscala:: [String] -> (String,String)
constroiEscala  diaMesEnfermeiros = (diaMesEnfermeiros!!0,diaMesEnfermeiros!!1)
    

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

escreverEscala :: (String,String) -> IO()
escreverEscala (diaMes,enfermeiro) = do
    let escalaStr = diaMes ++ "," ++ enfermeiro ++ "\n" 
    appendFile "escala.txt" (escalaStr)
    return ()

iniciaRecebedores :: [Recebedor.Recebedor]
iniciaRecebedores = [(Recebedor.Recebedor "Lukas Nascimento" "Rua Princesa Isabel" 21 "33442211" 1250), (Recebedor.Recebedor "Maria Oliveira" "Rua Manoel Tavares" 64 "33123322" 1000)]


--Implementar metodo q vai salvar a lista de impedimentos


