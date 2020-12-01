module FichaMedica where
    import Data.List
    import Data.Maybe()
    import Data.Map as Map
    import Data.Char
    import System.IO

    data FichaMedica = FichaMedica { sexo :: String, dataNascimento :: String, pai :: String, mae :: String, acompanhamentoMedico :: String, condicaoFisica :: String, alergias :: String } deriving (Show, Eq)

    adicionaFichaMedica :: String -> String -> String -> String -> String -> String -> String -> FichaMedica
    adicionaFichaMedica sexo dataNascimento pai mae acompanhamentoMedico condicaoFisica alergias = (FichaMedica { sexo = sexo, dataNascimento = dataNascimento, pai = pai, mae = mae, acompanhamentoMedico = acompanhamentoMedico, condicaoFisica = condicaoFisica, alergias = alergias})

    imprimeFichaMedica :: FichaMedica -> String
    imprimeFichaMedica ficha = "Sexo: " ++ sexo ficha ++ "\n" ++ "Data de Nascimento: " ++ dataNascimento ficha ++ "\n" ++ "Nome do pai: " ++ pai ficha ++ "\n" ++ "Nome da mãe: " ++ mae ficha ++ "\n" ++ "Necessidades de acompanhamento médico ou psicológico: " ++ acompanhamentoMedico ficha ++ "\n" ++ "Restrição para atividades físicas: " ++ condicaoFisica ficha ++ "\n" ++ "Alergias a medicamentos/alimentos/materiais: " ++ alergias ficha ++ "\n"


    --imprimeFicha :: String
    --imprimeFicha ficha = " Sexo "
