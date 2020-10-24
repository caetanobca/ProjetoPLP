import qualified Impedimento as Impedimento
import qualified Auxiliar as Auxiliar

main :: IO ()
main = do
    menuInicial Auxiliar.iniciaImpedimentos


opcoes :: String
opcoes = ("BloodLife\n1. Cadastro de Recebedores\n2. Controle de estoque de bolsas de sangue\n" ++
 "3. Cadastro de doadores\n4. Cadastro de Enfermeiros\n" ++
 "5. Cadastro de impedimentos\n6. Agendamento de coleta com doadores\n" ++ 
 "7. Agendamento de coleta com enfermeiros\n8. Dashboards\n9. sai\n")


menuInicial :: [Impedimento.Impedimento] -> IO()
menuInicial listaImpedimentos = do
    putStr(opcoes)

    input <- getLine 

    if input == "1" then do
        putStrLn ("IMPLEMENTAR CADASTRO DE RECEBEDORES")
    else if input == "2" then do
        putStrLn ("IMPLEMENTAR CONTROLE DO ESTOQUE DE BOLSAS")
    else if input == "3" then do
        putStrLn ("IMPLEMENTAR CADASTRO DE DOADORES")
    else if input == "4" then do
        putStrLn ("IMPLEMENTAR CADASTRO DE ENFERMEIROS")
    else if input == "5" then do
        cadastroDeImpedimentos listaImpedimentos
        putStrLn ("Impedimento cadastrado")
    else if input == "6" then do
        putStrLn ("IMPLEMENTAR AGENDAMENTO DE COLETA COM DOADOR")
    else if input == "7" then do
        putStrLn ("IMPLEMENTAR AGENDAMENTO DE COLETA COM ENFERMEIRO")
    else if input == "8" then do
        putStrLn ("IMPLEMENTAR DASHBOARD")
    else if input == "9" then do
        putStrLn ("Encerrando")
    else do
       putStrLn("Entrada invalida")
        

    


cadastroDeImpedimentos :: [Impedimento.Impedimento] -> IO()
cadastroDeImpedimentos listaImpedimentos = do 
    putStr ("Cadastro de impedimentos\n" ++
            "1. Cadastro de Medicamento\n" ++
            "2. Cadastro de Doenca\n")
    tipo <- getLine
    if (tipo == "1") then do
        putStr("Cadastro de Medicamento\n" ++
                "Funcao: ")
        input <- getLine
        let funcao = input
        putStr("Composto: ")
        input <- getLine
        let composto = input
        putStr("tempo de Suspencao: ")
        input <- getLine
        let tempoSuspencao = input
        menuInicial (listaImpedimentos ++ [(Impedimento.Medicamento funcao composto tempoSuspencao)])
    else if (tipo == "2") then do
        putStr("Cadastro de Doenca\n" ++
                "CID: ")
        input <- getLine
        let cid = input
        putStr("tempo de Suspencao: ")
        input <- getLine
        let tempoSuspencao = input
        menuInicial (listaImpedimentos ++ [(Impedimento.Doenca cid tempoSuspencao)])
    else do
        putStrLn("Entrada Invalida")
        menuInicial listaImpedimentos