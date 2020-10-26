import qualified Impedimento as Impedimento
import qualified Auxiliar as Auxiliar
import qualified Enfermeiro as Enfermeiro
import Data.Map as Map

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
        enfermeiros
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

enfermeiros :: IO()
enfermeiros = do
    putStr ("1. Cadastro de Enfermeiros\n" ++
            "2. Buscar Enfermeiro\n" ++
            "3. Listagem de Enfermeiros\n" ++
            "4. Listagem de Enfermeiros por nome\n" ++
            "5. Adicionar escala de Enfermeiros\n" ++
            "6. Visualizar escala de Enfermeiros\n")
    tipo <- getLine
    if(tipo == "2") then do
        putStrLn("Insira o nome do(a) Enfermeiro(a) que você deseja")
        nome <- getLine 
        let enfermeiro = Enfermeiro.encontraEnfermeiroString nome carregaEnfermeiros
        putStrLn enfermeiro
    else if(tipo == "3") then do
        let enfermeiros = Enfermeiro.todosOsEnfermeiros carregaEnfermeiros
        putStrLn enfermeiros
    else if(tipo == "4") then do
       let enfermeiros = Enfermeiro.visualizaEnfermeiros carregaEnfermeiros 
       putStrLn enfermeiros
    else if(tipo == "5") then do
        putStrLn("Insira a data")
        diaMes <- getLine
        putStrLn("Insira o nome do Enfermeio")
        enfermeiro <- getLine
        let escala = Enfermeiro.organizaEscala diaMes carregaEscala enfermeiro carregaEnfermeiros 
        putStrLn (show escala)
    else if(tipo == "6") then do
        putStrLn("Insira a data")
        diaMes <- getLine
        let escala = Enfermeiro.visualizaEscala diaMes carregaEscala
        if(escala == Nothing) then do 
        putStrLn("Data não encontrada")
        else do
        putStrLn (show escala)    
    else do
        putStrLn ("Ainda não implementado")

carregaEnfermeiros ::  [Enfermeiro.Enfermeiro]
carregaEnfermeiros = Auxiliar.iniciaEnfermeiros

carregaEscala :: Map String String
carregaEscala = Auxiliar.iniciaEscala 
     
      