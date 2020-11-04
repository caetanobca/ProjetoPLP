import qualified Impedimento as Impedimento
import qualified Auxiliar as Auxiliar
import qualified Enfermeiro as Enfermeiro
import qualified Recebedor as Recebedor
import qualified Estoque as Estoque
import qualified Bolsa as Bolsa
import qualified Doador as Doador
import qualified Agenda as Agenda
import Data.Map as Map
import System.IO
import Data.Time
import qualified DatasCriticas as DatasCriticas
import Data.Char

main :: IO ()
main = do    
    Auxiliar.criaArquivos        
    menuInicial


opcoes :: String
opcoes = ("BloodLife\n1. Cadastro de Recebedores\n2. Controle de Estoque de Bolsas de Sangue\n" ++
 "3. Cadastro de doadores\n4. Cadastro de Enfermeiros\n" ++
 "5. Cadastro de impedimentos\n6. Agendamento de coleta com doadores\n" ++ 
 "7. Agendamento de coleta com enfermeiros\n8. Dashboards\n9. Sair\n")


menuInicial :: IO()
menuInicial  = do
    putStr(opcoes)

    input <- getLine 

    if input == "1" then do
        cadastroDeRecebedor
        putStrLn (" ")
    else if input == "2" then do        
        listaEstoque <- carregaEstoque
        estoque listaEstoque
    else if input == "3" then do
        listaDoadores <- carregaDoadores
        doador listaDoadores   
    else if input == "4" then do
        listaEnfermeiros <- carregaEnfermeiros
        listaEscala <- carregaEscala       
        enfermeiros listaEnfermeiros listaEscala
    else if input == "5" then do
        listaImpedimentos <- carregaImpedimentos
        impedimentos listaImpedimentos    
    else if input == "6" then do
        listaEnfermeiros <- carregaEnfermeiros 
        listaAgenda <- carregaAgenda     
        listaDoadores <- carregaDoadores
        agendaDoacao listaAgenda listaEnfermeiros listaDoadores
    else if input == "7" then do
        putStrLn ("IMPLEMENTAR AGENDAMENTO DE COLETA COM ENFERMEIRO")
    else if input == "8" then do
        putStrLn ("IMPLEMENTAR DASHBOARD")
    else if input == "9" then do
        putStrLn ("Encerrando")
    else do
       putStrLn("Entrada invalida")
        

doador :: [Doador.Doador] -> IO()
doador listaDoador = do      
    putStr ("1. Cadastro de Doador\n" ++
            "2. Buscar Doador\n" ++
            "3. Listagem de Doador\n" ++
            "4. Listagem de Doador por nome\n" ++
            "5. Visualizar histórico de doações de Doador\n" ++
            "6. Visualizar ficha medica de Doador\n")
    tipo <- getLine
    if(tipo == "1")then do
        putStrLn ("Você irá cadastrar um Doador(a)")
        putStrLn ("Insira o nome do Doador(a)")
        nome <- getLine
        putStrLn ("Insira o endereço do Doador(a)")
        endereco <- getLine
        putStrLn ("Insira a idade do Doador(a)")
        idade <- getLine
        putStrLn ("Insira o telefone do Doador(a)")
        telefone <- getLine        
        putStrLn ("Insira o tipo sanguíneo do Doador(a)")    
        tipoSanguineo <- getLine
        if((elem (toUpperCase tipoSanguineo) tipos) == False) then do
            putStrLn("Tipo Inválido\n")
            else do             
                Auxiliar.escreverDoador(Doador.adicionaDoador nome endereco (read(idade)) telefone tipoSanguineo [])                    
        menuInicial
    else if(tipo == "2") then do
        putStrLn("Insira o nome do(a) Doador(a) que você deseja")
        nome <- getLine          
        putStrLn (Doador.encontraDoadorString nome listaDoador)
        menuInicial
    else if(tipo == "3") then do        
        putStrLn (Doador.todosOsDoadores listaDoador)
        menuInicial
    else if(tipo == "4") then do       
       putStrLn (Doador.visualizaDoadores listaDoador )
       menuInicial
    else if(tipo == "5") then do
        putStrLn ("Insira o nome do Doador(a)")
        nome <- getLine
        putStrLn (Doador.listarDoacoes nome listaDoador)
        menuInicial
    else if(tipo == "6") then do
        putStrLn ("Insira o nome do Doador(a)")
        nome <- getLine
        putStrLn (Doador.mostraFichaTecnica nome listaDoador)
        menuInicial
    else do
        putStrLn ("Opção inválida")


impedimentos :: [Impedimento.Impedimento] -> IO()
impedimentos listaImpedimentos = do 
    putStr ("\n1. Cadastro de Impedimento\n" ++ 
            "2. Buscar Impedimento\n" ++
            "3. Listar Impedimentos\n" ++
            "4. Deletar Impedimento\n")
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
        putStr ("Buscar Impedimentos\n" ++
            "1. Buscar Medicamento\n" ++
            "2. Buscar Doenca\n")
        tipo <- getLine
        if (tipo == "1") then do
            putStr("Buscar Medicamento\n" ++
                "Composto: ")
            input <- getLine
            let composto = input
            putStrLn (show (Impedimento.buscaImpedimentoStr "MEDICAMENTO" composto listaImpedimentos))
            menuInicial
        else if (tipo == "2") then do
            putStr("Buscar Doenca\n" ++
                    "CID: ")
            input <- getLine
            let cid = input
            putStrLn (show (Impedimento.buscaImpedimentoStr "DOENCA" cid listaImpedimentos))
            menuInicial
        else do
            putStrLn("Entrada Invalida")
            menuInicial
    else if (opcao == "3") then do
        putStrLn ("Listar Impedimentos")
        putStr(Impedimento.listarImpedimentos listaImpedimentos)
        menuInicial
    else if (opcao == "4") then do
        putStr ("Deletar Impedimentos\n" ++
            "1. Deletar Medicamento\n" ++
            "2. Deletar Doenca\n")
        tipo <- getLine
        if (tipo == "1") then do
            putStr("Deletar Medicamento\n" ++
                    "Composto: ")
            input <- getLine
            let composto = input            
            Auxiliar.rescreverImpedimento (Impedimento.removeImpedimetno(Impedimento.buscaImpedimento "MEDICAMENTO" composto listaImpedimentos) listaImpedimentos)
            putStrLn ("Impedimento deletado")
            menuInicial
        else if (tipo == "2") then do
            putStr("Deletar Doenca\n" ++
                    "CID: ")
            input <- getLine
            let cid = input            
            Auxiliar.rescreverImpedimento (Impedimento.removeImpedimetno(Impedimento.buscaImpedimento "DOENCA" cid listaImpedimentos) listaImpedimentos)
            putStrLn ("Impedimento deletado")
            menuInicial
        else do
            putStrLn("Entrada Invalida")
            menuInicial
    else do
        putStrLn("Entrada Invalida")
        menuInicial
        

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
        main
    else if(tipo == "2") then do
        putStrLn("Insira o nome do(a) Enfermeiro(a) que você deseja")
        nome <- getLine          
        putStrLn (Enfermeiro.encontraEnfermeiroString nome listaEnfermeiros)
        main
    else if(tipo == "3") then do        
        putStrLn (Enfermeiro.todosOsEnfermeiros listaEnfermeiros)
        main
    else if(tipo == "4") then do       
       putStrLn (Enfermeiro.visualizaEnfermeiros listaEnfermeiros )
       main
    else if(tipo == "5") then do
        putStrLn("Insira a data")
        diaMesAno <- getLine
        putStrLn("Insira o nome do Enfermeiro")
        enfermeiro <- getLine              
        Auxiliar.rescreverEscala (Enfermeiro.organizaEscala (Auxiliar.stringEmData diaMesAno) mapaEscala enfermeiro listaEnfermeiros)
        main
    else if(tipo == "6") then do
        putStrLn("Insira a data")
        diaMesAno <- getLine                    
        if((Enfermeiro.visualizaEscala (Auxiliar.stringEmData diaMesAno) mapaEscala) == Nothing) then do 
        putStrLn("Data não encontrada")
        main
        else do
        putStrLn (show (Enfermeiro.visualizaEscala (Auxiliar.stringEmData diaMesAno) mapaEscala))
        main   
    else do
        putStrLn ("Ainda não implementado")

estoque ::[Bolsa.Bolsa] -> IO()
estoque listaEstoque = do
    {- Mensagem de Estoque: se tiver menos de 1000 ml por tipo sanguineo é dado um aviso de falta de sangue
                            se tiver mais de 10000 ml por tipo sanguineo é dado um aviso de sobra de sangue
    -}
    putStrLn(Estoque.mensagemDeAviso listaEstoque 0)
    putStr ("1. Adicionar Bolsa de Sangue\n" ++
            "2. Retirar Bolsa de Sangue\n" ++
            "3. Visão Geral do Estoque\n" ++
            "4. Listar Todas as Bolsas\n" ++
            "5. Listar Bolsas por Tipo\n")
    tipo <- getLine
    if(tipo == "1")then do
        putStrLn("Tipo Sanguineo: ")          
        typeSanguineo <- getLine
        let tipoSanguineo = typeSanguineo
        if((elem (toUpperCase tipoSanguineo) tipos) == False) then do
            putStrLn("Tipo Inválido\n")
        else do   
            putStrLn("Quantidade de sangue (em ml): ")
            input <- getLine 
            let qtdSangue = read input :: Int
            if(qtdSangue > 450) then do
                putStrLn("Não há como doar mais que 450 ml por pessoa!\n")
            else do    
                Auxiliar.escreverEstoque([Estoque.adicionaBolsa tipoSanguineo qtdSangue])    
                putStrLn("Bolsa cadastrada!\n")
        main
    else if(tipo == "2") then do
        putStrLn("Tipo Sanguineo:: ")
        input <- getLine
        let tipo = input
        putStrLn("Quantidade de sangue: ")
        input <- getLine 
        let qtdSangue = read input :: Int
        let bolsaComSangueDisponivel = Estoque.verificaEstoque tipo qtdSangue listaEstoque
        if(bolsaComSangueDisponivel /= Nothing) then do
            putStrLn("Sangue retirado com sucesso! ")
            Auxiliar.reescreveEstoque(Estoque.removeBolsa bolsaComSangueDisponivel listaEstoque)
 --           if(qtdSangue < Bolsa.qtdSangue bolsaComSangueDisponivel) then do
 --               let qtdSangueRestante = ((Bolsa.qtdSangue bolsaComSangueDisponivel) - qtdSangue )
 --               Auxiliar.escreverEstoque([Estoque.adicionaBolsa (Bolsa.tipoSanguineo bolsaComSangueDisponivel) qtdSangueRestante ])             
 --               putStrLn(Estoque.bolsaRetiradaToString bolsaComSangueDisponivel qtdSangue)
 --           else do
            putStrLn(Estoque.bolsaRetiradaToString bolsaComSangueDisponivel 0)
            main
        else do 
            putStr ("Não há bolsas disponiveis :(\n")
        main
    else if(tipo == "3") then do
        putStrLn("\nVisão Geral Do Estoque:")
        putStrLn(Estoque.visaoGeralEstoque listaEstoque)
        main                                
    else if(tipo == "4") then do
        let estoque = Estoque.listaTodasAsBolsas listaEstoque
        putStrLn estoque
        main
    else if(tipo == "5") then do
        putStrLn("Tipo Sanguineo: ")
        input <- getLine
        let tipoSanguineo = input
        if((elem (toUpperCase tipoSanguineo) tipos) == False) then do
            putStrLn("Tipo Inválido!\n")
            main
        else do    
            let estoque = Estoque.listaBolsasPorTipo tipoSanguineo listaEstoque
            putStrLn estoque
            main
    else do
        putStrLn ("Entrada Inválida!\n")
        main


tipos :: [String]
tipos = ["O-","O+","A-","A+","B+","B-","AB+","AB-"]    

agendaDoacao :: Map Day String -> [Enfermeiro.Enfermeiro] -> [Doador.Doador] -> IO()
agendaDoacao agenda listaEnfermeiros listaDoadores = do
    putStr ("\n1. Agendar coleta no Hemocentro\n" ++ "2. Agendar coleta em domicílio\n")
    tipo <- getLine
    if(tipo == "1")then do
        putStrLn("Insira a data")
        diaMesAno <- getLine
        putStrLn("Insira o nome do Doador")
        doador <- getLine
        putStrLn("Insira o nome do Enfermeiro")
        enfermeiro <- getLine
        if((Doador.encontraDoadorString doador listaDoadores) == "") then do
            putStrLn ("Doador não cadastrado")
            menuInicial
        else if(Enfermeiro.encontraEnfermeiroString enfermeiro listaEnfermeiros == "") then do
            putStrLn ("Enfermeiro não cadastrado")
            menuInicial
        else do
            Auxiliar.rescreverAgendaLocal (Agenda.agendaDoacaoLocal (Auxiliar.stringEmData diaMesAno) agenda doador enfermeiro "Hemocentro")
            menuInicial
    else do
        putStrLn("Insira a data")
        diaMesAno <- getLine
        putStrLn("Insira o nome do Doador")
        doador <- getLine
        putStrLn("Insira o nome do Enfermeiro")
        enfermeiro <- getLine
        if((Doador.encontraDoadorString doador listaDoadores) == "") then do
            putStrLn ("Doador não cadastrado")
            menuInicial
        else if(Enfermeiro.encontraEnfermeiroString enfermeiro listaEnfermeiros == "") then do
            putStrLn ("Enfermeiro não cadastrado")
            menuInicial
        else do
            let doadorEndereco = Doador.getEnderecoDoador doador listaDoadores
            Auxiliar.rescreverAgendaLocal (Agenda.agendaDoacaoLocal (Auxiliar.stringEmData diaMesAno) agenda doador enfermeiro doadorEndereco)
            menuInicial
                   
carregaAgenda :: IO(Map Day String)
carregaAgenda = Auxiliar.iniciaAgendaLocal

carregaEnfermeiros ::  IO([Enfermeiro.Enfermeiro])
carregaEnfermeiros = Auxiliar.iniciaEnfermeiros

carregaEscala :: IO(Map Day String)
carregaEscala = Auxiliar.iniciaEscala

carregaEstoque ::  IO([Bolsa.Bolsa])
carregaEstoque = Auxiliar.iniciaEstoque

carregaImpedimentos :: IO([Impedimento.Impedimento])
carregaImpedimentos = Auxiliar.iniciaImpedimentos

carregaRecebedores :: [Recebedor.Recebedor]
carregaRecebedores = Auxiliar.iniciaRecebedores

carregaDoadores :: IO([Doador.Doador])
carregaDoadores = Auxiliar.iniciaDoador

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
        nome <- prompt "Digite o nome do(a) Recebedor(a) "
        endereco <- prompt "Digite o endereço do(a) Recebedor(a) "
        age <- prompt "Digite a idade do(a) Recebedor(a) "
        let idade = read age
        telefone <- prompt "Digite o telefone do(a) Recebedor(a) "
        qtd <- prompt "Digite a quantidade de bolsas de sangue que o(a) Recebedor(a) precisa "
        let quantidade = read qtd
        tipo <- prompt "Tipo Sanguineo: "
        hospital <- prompt "Hospital internado: "
        --------------------------------------------------------------------------------------------
        -- cadastrar ficha medica 
        
        sexo <- prompt "Sexo Feminino (f) Masculino (m) "
        dataNascimento <- prompt "Data de nascimento: "
        pai <- prompt "Nome do pai: "
        mae <- prompt "Nome da mãe: "
        acompanhamentoMedico <- prompt "Tem acompanhamento médico ou psicológico? NAO (n) Sim (s) "
        
        {-
        let acompanhamentoMedicoBool = False
        
        if (acompanhamentoMedico == "1") then do 
            let acompanhamentoMedicoBool = False 
            putStr "" 
            else if (acompanhamentoMedico == "2") then do 
                let acompanhamentoMedicoBool = True 
                putStr ""
                else do 
                    let acompanhamentoMedicoBool = False 
                    putStr ""
        -}
        condicaoFisica <- prompt "Tem alguma condição que exige atenção especial ou restrição a atividade física? NAO (n) Sim (s) "
        alergias <- prompt "Tem alergia a algum medicamento/alimento/material? "
        let ficha = adicionaFichaMedica sexo dataNascimento pai mae acompanhamentoMedicoBool condicaoFisicaBool alergias
        ---------------------------------------------------------------------------------------------
        let recebedor = adicionaRecebedor nome endereco idade telefone quantidade tipo hospital ficha
        putStr "Recebedor Cadastrado"


    else if (input == "2") then do
        nome <- prompt "Digite o nome do recebedor: "
        let recebedor = Recebedor.recebedorCadastrado nome carregaRecebedores
        if (recebedor == True) then do
            verFicha <- prompt "Visualizar:\n(1) Ficha Médica do recebedor\n(2) Ficha de Dados\n(3) Sair \n"
            putStrLn "\n"
            if (verFicha == "1") then do
                putStrLn "IMPLEMENTAR FICHA MEDICA toString"
            else do --putStr Recebedor.imprimeRecebedor nome carregaRecebedores
                putStr "IMPLEMENTAR RECEBEDOR TO STRING"
            
        else do 
            cadastrarNovo <- prompt "Recebedor não cadastrado\nCadastrar um novo Recebedor(a)?\n(1) SIM\n(2) NÃO\n"
            if (cadastrarNovo == "1") then do menuInicial else do putStr ""

        -- se o recebedor já for cadastrado imprime os dados senao cadastra novo

    else if (input == "3") then do
        let listaRecebedores = Recebedor.todosOsRecebedores carregaRecebedores
        putStr ("\n" ++ listaRecebedores)

{-
    else if (input == "4") then do
        putStr("Digite o nome do recebedor: ")
        nome <- getLine
        fichaRecebedor = Recebedor.fichaDeDadosRecebedor nome
    
-}
    else putStr ("Entrada Inválida xxxx")

prompt :: String -> IO String
prompt text = do
    putStr text
    hFlush stdout
    getLine


{-
    Caso hoje seja dia primeiro, compara o estoque com o do ano passado 
-}
verificaDataCritica :: IO()
verificaDataCritica = do
    today <- hoje
    listaEstoque <- carregaEstoque
    if((today) == 1) then do
        DatasCriticas.verificaHoje listaEstoque
    else do
        return()       
    

getDia :: (a, b, c) -> c
getDia (_, _, y) = y

hoje :: IO(Int)
hoje = do
    today <- toGregorian <$> (utctDay <$> getCurrentTime)
    return (getDia today)


toUpperCase :: String -> String
toUpperCase entrada = [toUpper x | x <- entrada]    