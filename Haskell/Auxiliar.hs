module Auxiliar where

import qualified Impedimento as Impedimento

--Esse metodo vai carregar os empedimentos que estavam salvos em um arquivo
iniciaImpedimentos :: [Impedimento.Impedimento]
iniciaImpedimentos = [(Impedimento.Doenca "123" "2 meses"), (Impedimento.Medicamento "Funcao1" "Composto1" "25 meses")]

--Implementar metodo q vai salvar a lista de impedimentos
