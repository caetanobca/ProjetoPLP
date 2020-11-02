import qualified Impedimento as Impedimento
import qualified Auxiliar as Auxiliar
import qualified Enfermeiro as Enfermeiro
import qualified Recebedor as Recebedor
import qualified Estoque as Estoque
import qualified Bolsa as Bolsa
import Data.Map as Map
import System.IO
import Data.Time.Calendar

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
        cadastroDeRecebedor
        putStrLn (" ")
    else if input == "2" then do
        putStrLn ("IMPLEMENTAR CONTROLE DO ESTOQUE DE BOLSAS")
    else if input == "3" then do
        putStrLn ("IMPLEMENTAR CADASTRO DE DOADORES")    
    {-else if input == "4" then do
        enfermeiros carregaEnfermeiros carregaEscala
    else if input == "5" then do
        cadastroDeImpedimentos carregaImpedimentos    
    -}else if input == "6" then do
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
    putStr ("\n1. Cadastro de Impedimento\n" ++ 
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
        
{-
enfermeiros :: [Enfermeiro.Enfermeiro] -> Map Day String -> IO()
enfermeiros listaEnfermeiros mapaEscala = do      
    putStr ("1. Cadastro de Enfermeiros\n" ++
            "2. Buscar Enfermeiro\n" ++
            "3. Listagem de Enfermeiros\n" ++
            "4. Listagem de Enfermeiros por nome\n" ++
            "5. Adicionar escala de Enfermeiros\n" ++
            "6. Visualizar escala de Enfermeiros\n")
    tipo <- getLine
    if(tipo == "1")then do
        putStrLn ("Você irá cadastrar um Enfermeiro(a)")
        putStrLn ("Insira o nome do Enfermeiro(a)")
        nome <- getLine
        putStrLn ("Insira o endereço do Enfermeiro(a)")
        endereco <- getLine
        putStrLn ("Insira a idade do Enfermeiro(a)")
        idade <- getLine
        putStrLn ("Insira o telefone do Enfermeiro(a)")
        telefone <- getLine
        Auxiliar.escreverEnfermeiros(Enfermeiro.adicionaEnfermeiro nome endereco (read(idade)) telefone)                    
        menuInicial
    else if(tipo == "2") then do
        putStrLn("Insira o nome do(a) Enfermeiro(a) que você deseja")
        nome <- getLine          
        putStrLn (Enfermeiro.encontraEnfermeiroString nome listaEnfermeiros)
        menuInicial
    else if(tipo == "3") then do        
        putStrLn (Enfermeiro.todosOsEnfermeiros listaEnfermeiros)
        menuInicial
    else if(tipo == "4") then do       
       putStrLn (Enfermeiro.visualizaEnfermeiros listaEnfermeiros )
       menuInicial
    else if(tipo == "5") then do
        putStrLn("Insira a data")
        diaMesAno <- getLine
        putStrLn("Insira o nome do Enfermeiro")
        enfermeiro <- getLine              
        Auxiliar.rescreverEscala (Enfermeiro.organizaEscala (Auxiliar.stringEmData diaMesAno) mapaEscala enfermeiro listaEnfermeiros)
        menuInicial
    else if(tipo == "6") then do
        putStrLn("Insira a data")
        diaMesAno <- getLine                    
        if((Enfermeiro.visualizaEscala (Auxiliar.stringEmData diaMesAno) mapaEscala) == Nothing) then do 
        putStrLn("Data não encontrada")
        menuInicial
        else do
        putStrLn (show (Enfermeiro.visualizaEscala (Auxiliar.stringEmData diaMesAno) mapaEscala))
        menuInicial    
    else do
        putStrLn ("Ainda não implementado")

carregaEnfermeiros ::  [Enfermeiro.Enfermeiro]
carregaEnfermeiros = Auxiliar.iniciaEnfermeiros

carregaEscala :: Map Day String
carregaEscala = Auxiliar.iniciaEscala

carregaImpedimentos :: [Impedimento.Impedimento]
carregaImpedimentos = Auxiliar.iniciaImpedimentos
-}
carregaRecebedores :: [Recebedor.Recebedor]
carregaRecebedores = Auxiliar.iniciaRecebedores

cadastroDeRecebedor :: IO()
cadastroDeRecebedor = do
    putStr (
        "1. Cadastro de Recebedor\n" ++
        "2. Buscar Recebedor\n" ++
        "3. Listar Recebedores\n" ++
        "4. Visualizar Ficha de Dados do Recebedor\n"
        )

    input <- getLine

    if (input == "1") then do
        Recebedor.cadastrarRecebedor

    else if (input == "2") then do
        nome <- prompt "Digite o nome do recebedor: "
        let recebedor = Recebedor.recebedorCadastrado nome carregaRecebedores
        if (recebedor == True) then do
            verFicha <- prompt "Visualizar:\n(1) Ficha Médica do recebedor\n(2) Ficha de Dados\n(3) Sair"
            putStrLn "\n"
            if (verFicha == "1") then do
                putStrLn "IMPLEMENTAR FICHA MEDICA"
            else --putStr Recebedor.imprimeRecebedor nome carregaRecebedores
                putStr "IMPLEMENTAR RECEBEDOR TO STRING"
            
            else do 
                cadastrarNovo <- prompt "Recebedor não cadastrado\nCadastrar um novo Recebedor(a)?\n(1) SIM\n(2) NÃO\n"
                if (cadastrarNovo == "1") then do Recebedor.cadastrarRecebedor else putStr " "

        -- se o recebedor já for cadastrado imprime os dados senao cadastra novo

    else if (input == "3") then do
        let listaRecebedores = Recebedor.todosOsRecebedores carregaRecebedores
        putStr ("\n" ++ listaRecebedores)


    else putStr ("Entrada Inválida xxxx")
    {-
    else if (input == "4") then do
        putStr("Digite o nome do recebedor: ")
        nome <- getLine
        fichaRecebedor = Recebedor.fichaDeDadosRecebedor nome
    -}

prompt :: String -> IO String
prompt text = do
    putStr text
    hFlush stdout
    getLine

{-
estoque :: IO()
estoque = do
    putStr ("1. Adicionar Bolsa de Sangue\n" ++
            "2. Retirar Bolsa de Sangue\n" ++
            "3. Listar Todas as Bolsas\n" ++
            "4. Listar Bolsas por Tipo\n")
    tipo <- getLine
    if(tipo== "1") then do
        putStr("Tipo Sanguineo(cadastrar): ")
        input <- getLine
        let tipoSanguineo = input
        putStr("Quantidade de sangue (em ml): ")
        input <- getLine 
        let qtdSangue = read input :: Int
        Auxiliar.escreverBolsa(Estoque.adicionaBolsa tipoSanguineo qtdSangue)    
        putStrLn ("Bolsa cadastrada")
    else if(tipo == "2") then do
        putStrLn("Tipo Sanguineo(retirar): ")
        input <- getLine
        let tipo = input
        putStr("Quantidade de sangue (em ml): ")
        input <- getLine 
        let qtdSangue = read input :: Int
        let bolsa = Estoque.removeBolsa tipo qtdSangue carregaEstoque
        if(bolsa /= Nothing) then do
            putStrLn("Sangue retirado com sucesso! ")
            putStrLn(Estoque.bolsaToString bolsa)
            --Auxiliar.removeBolsa bolsa
        else do 
            putStr ("Nao ha bolsas disponiveis :(")
    -- deve ter alguma logica pra remover a bolsa do .txt

    else if(tipo == "3") then do
        let estoque = Estoque.listaTodasAsBolsas carregaEstoque
        putStrLn estoque
    else if(tipo == "4") then do
        putStrLn("Tipo Sanguineo(listar): ")
        input <- getLine
        let tipoSanguineo = input
        let estoque = Estoque.listaBolsasPorTipo tipoSanguineo carregaEstoque
        putStrLn estoque
    else do
        putStrLn ("Ainda não implementado")
-}

carregaEstoque ::  [Bolsa.Bolsa]
carregaEstoque = Auxiliar.iniciaEstoque