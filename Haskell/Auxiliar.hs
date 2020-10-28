module Auxiliar where

import qualified Impedimento as Impedimento
import qualified Enfermeiro as Enfermeiro
import Data.Map as Map
import Data.List
import Data.List.Split
import System.IO.Unsafe(unsafeDupablePerformIO)

--Esse metodo vai carregar os empedimentos que estavam salvos em um arquivo
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
        
criaArquivos :: IO()
criaArquivos = do
    appendFile "impedimentos.txt" ("")

iniciaEnfermeiros :: [Enfermeiro.Enfermeiro]
iniciaEnfermeiros = [(Enfermeiro.Enfermeiro "Caio Davi" "Rua Marechal" 21 "33224455"), (Enfermeiro.Enfermeiro "Mateus" "Rua General" 23 "33224455")]

iniciaEscala :: Map String String
iniciaEscala = Map.fromList [("16/10", "José"), ("17/10","Pedro")]

--Implementar metodo q vai salvar a lista de impedimentos
