import qualified Impedimento as Impedimento
import qualified Auxiliar as Auxiliar
import qualified Enfermeiro as Enfermeiro
import qualified Recebedor as Recebedor
import Data.Map as Map

main :: IO ()
main = do
    Auxiliar.criaArquivos
    menuInicial


opcoes :: String
opcoes = ("BloodLife\n1. Cadastro de Recebedores\n2. Controle de estoque de bolsas de sangue\n" ++
 "3. Cadastro de doadores\n4. Cadastro de Enfermeiros\n" ++
 "5. Cadastro de impedimentos\n6. Agendamento de coleta com doadores\n" ++ 
 "7. Agendamento de coleta com enfermeiros\n8. Dashboards\n9. sai\n")


menuInicial :: IO()
menuInicial  = do
    putStr(opcoes)

    input <- getLine 

    if input == "1" then do
        --cadastroDeRecebedor
        putStrLn ("Recebedor cadastrado")
    else if input == "2" then do
        putStrLn ("IMPLEMENTAR CONTROLE DO ESTOQUE DE BOLSAS")
    else if input == "3" then do
        putStrLn ("IMPLEMENTAR CADASTRO DE DOADORES")
    else if input == "4" then do
        enfermeiros
    else if input == "5" then do
        cadastroDeImpedimentos carregaImpedimentos       
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
    putStr ("1. Cadastro de Impedimento\n" ++ 
            "2. Buscar Impedimento\n" ++
            "3. Listar Impedimentos\n")
    opcao <- getLine
    if (opcao == "1") then do
        putStr ("Cadastro de Impedimentos\n" ++
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
            putStr("tempo de Suspencao (em dias): ")
            input <- getLine 
            let tempoSuspencao = read input :: Integer
            Auxiliar.escreverImpedimento (Impedimento.adicionaImpedimento funcao composto tempoSuspencao)
            putStrLn ("Impedimento cadastrado")
            menuInicial
        else if (tipo == "2") then do
            putStr("Cadastro de Doenca\n" ++
                    "CID: ")
            input <- getLine
            let cid = input
            putStr("tempo de Suspencao (em dias): ")
            input <- getLine
            let tempoSuspencao = read input :: Integer
            Auxiliar.escreverImpedimento (Impedimento.adicionaImpedimento [] cid tempoSuspencao)
            putStrLn ("Impedimento cadastrado")
            menuInicial
        else do
            putStrLn("Entrada Invalida")
            menuInicial
    else if (opcao == "2") then do 
        putStrLn("nao implementado")
    else if (opcao == "3") then do
        putStrLn ("Listar Impedimentos")
        putStr(Impedimento.listarImpedimentos listaImpedimentos)
        menuInicial
    else do
        putStrLn("Entrada Invalida")
        menuInicial
        
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

carregaImpedimentos :: [Impedimento.Impedimento]
carregaImpedimentos = Auxiliar.iniciaImpedimentos

{--cadastroDeRecebedor :: IO()
cadastroDeRecebedor = do
    putStr (
        "1. Cadastro de Recebedor\n" ++
        "2. Buscar Recebedor\n" ++
        "3. Listar Recebedores\n" ++
        "4. Visualizar Ficha de Dados do Recebedor\n" ++
        )

    input <- getLine

    if (input == "1") then do
        putStr("Digite o nome do(a) Recebedor(a)")
        nome <- getLine
        putStr("Digite o endereço do(a) Recebedor(a)")
        endereco <- getLine
        putStr("Digite a idade do(a) Recebedor(a)")
        input <- getLine
        idade = read input
        putStr("Digite o telefone do(a) Recebedor(a)")
        telefone <- getLine
        putStr("Digite a quantidade de sangue em ml que o(a) Recebedor(a) precisa")
        input <- getLine
        quantidade = read input
        let recebedor = Recebedor.adicionaRecebedor nome endereco idade telefone quantidade
        putStr recebedor

    else if (input == "2") then do
        putStr("Digite o nome do recebedor: ")
        nome <- getLine
        let recebedor = Recebedor.recebedorCadastrado
        -- se o recebdor já for cadastrado imprime os dados senao cadastra novo

    else if (input == "3") then do
        let listaRecebedores Recebedor.todosRecebedores recebedores
        putStr listaRecebedores

    else if (input == "4") then do
        putStr("Digite o nome do recebedor: ")
        nome <- getLine
        let fichaRecebedor = Recebedor.fichaDeDadosRecebedor nome
--}

