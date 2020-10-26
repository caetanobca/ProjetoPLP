module Auxiliar where

import qualified Impedimento as Impedimento
import qualified Enfermeiro as Enfermeiro
import Data.Map as Map

--Esse metodo vai carregar os empedimentos que estavam salvos em um arquivo
iniciaImpedimentos :: [Impedimento.Impedimento]
iniciaImpedimentos = [(Impedimento.Doenca "123" "2 meses"), (Impedimento.Medicamento "Funcao1" "Composto1" "25 meses")]

iniciaEnfermeiros :: [Enfermeiro.Enfermeiro]
iniciaEnfermeiros = [(Enfermeiro.Enfermeiro "Caio Davi" "Rua Marechal" 21 "33224455"), (Enfermeiro.Enfermeiro "Mateus" "Rua General" 23 "33224455")]

iniciaEscala :: Map String String
iniciaEscala = Map.fromList [("16/10", "José"), ("17/10","Pedro")]

--Implementar metodo q vai salvar a lista de impedimentos
