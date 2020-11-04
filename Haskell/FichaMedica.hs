module FichaMedica where
    import Data.List
    import Data.Maybe()
    import Data.Map as Map
    import Data.Char
    import System.IO

    data FichaMedica = FichaMedica { sexo :: String, dataNascimento :: String, pai :: String, mae :: String, acompanhamentoMedico :: Bool, condicaoFisica :: Bool, alergias :: String } deriving (Show, Eq)

    adicionaFichaMedica :: String -> String -> String -> String -> Bool -> Bool -> String -> FichaMedica
    adicionaFichaMedica sexo dataNascimento pai mae acompanhamentoMedico condicaoFisica alergias = (FichaMedica { sexo = sexo, dataNascimento = dataNascimento, pai = pai, mae = mae, acompanhamentoMedico = acompanhamentoMedico, condicaoFisica = condicaoFisica, alergias = alergias})

    --imprimeFicha :: String
    --imprimeFicha ficha = " Sexo "
