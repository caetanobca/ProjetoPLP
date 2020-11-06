import qualified Impedimento as Impedimento
import qualified Auxiliar as Auxiliar
import qualified Enfermeiro as Enfermeiro
import qualified Recebedor as Recebedor
import qualified Estoque as Estoque
import qualified Bolsa as Bolsa
import qualified Doador as Doador
import qualified Agenda as Agenda
import qualified FichaMedica as FichaMedica
import Data.Map as Map
import System.IO
import Data.Time
import qualified DatasCriticas as DatasCriticas
import Data.Char

main :: IO ()
main = do    
    Auxiliar.criaArquivos   
    verificaDataCritica 
    menuInicial


opcoes :: String
opcoes = ("BloodLife\n1. Cadastro de Recebedores\n2. Controle de Estoque de Bolsas de Sangue\n" ++
 "3. Cadastro de Doadores\n4. Controle de Enfermeiros\n" ++
 "5. Controle de Impedimentos\n6. Agendar Coleta de sangue\n" ++ 
 "7. Dashboards\n8. Sair\n")


menuInicial :: IO()
menuInicial  = do    
    putStr(opcoes)

    input <- getLine 

    if input == "1" then do
        listaRecebedores <- carregaRecebedores
        cadastroDeRecebedor listaRecebedores
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
        putStrLn ("IMPLEMENTAR DASHBOARD")
    else if input == "8" then do
        putStrLn ("Encerrando")
    else do
       putStrLn("Entrada invalida")
        

doador :: [Doador.Doador] -> IO()
doador listaDoador  = do      
    putStr ("1. Cadastro de Doador\n" ++
            "2. Buscar Doador\n" ++
            "3. Listagem de Doador\n" ++
            "4. Cadastrar impedimento em doador\n" ++
            "5. Visualizar histórico de doações de Doador\n" ++
            "6. Visualizar ficha medica de Doador\n")
    tipo <- getLine
    if(tipo == "1")then do
        putStrLn ("Você irá cadastrar um Doador(a)")
        putStrLn ("Insira o nome do Doador(a)")
        nome <- getLine
        putStrLn ("Insira o tipo sanguíneo do Doador(a)")    
        tipoSanguineo <- getLine
        putStrLn ("Insira o endereço do Doador(a)")
        endereco <- getLine
        putStrLn ("Insira a idade do Doador(a)")
        idade <- getLine
        putStrLn ("Insira o telefone do Doador(a)")
        telefone <- getLine        

        if((elem (toUpperCase tipoSanguineo) tipos) == False) then do
            putStrLn("Tipo Inválido\n")
            else do             
                Auxiliar.escreverDoador(Doador.adicionaDoador nome endereco (read(idade)) telefone (toUpperCase tipoSanguineo))                    
        menuInicial
    else if(tipo == "2") then do
        putStrLn("Insira o nome do(a) Doador(a) que você deseja")
        nome <- getLine          
        if (Doador.doadorCadastrado nome listaDoador) then do
            (putStrLn (Doador.encontraDoadorString nome listaDoador)) 
        else do
            putStrLn ("Doador não encontrado")
        menuInicial
    else if(tipo == "3") then do        
        putStrLn (Doador.todosOsDoadores listaDoador)
        menuInicial
    else if(tipo == "4") then do 
        putStrLn("Insira o nome do(a) Doador(a) que você deseja cadastrar o impedimento")
        nome <- getLine  
        if (Doador.doadorCadastrado nome listaDoador) then do  
            listaImpedimentos <- carregaImpedimentos
            putStrLn ("Atribuir Impedimentos\n" ++
                "1. Atribuir Medicamento\n" ++
                "2. Atribuir Doença" )
            tipoImpedimento <- getLine
            if (tipoImpedimento == "1") then do
                putStrLn("Atribuir Medicamento\n" ++
                    "Composto: ")
                composto <- getLine
                Auxiliar.rescreverDoador(Doador.registraImpedimento nome listaDoador (Impedimento.buscaImpedimento "MEDICAMENTO" composto listaImpedimentos) )
                putStrLn("Medicamento atribuido ao pasciente com sucesso")
                menuInicial
            else if (tipoImpedimento == "2") then do
                putStrLn("Atribuir Doença\n" ++
                    "CID: ")
                cid <- getLine
                Auxiliar.rescreverDoador(Doador.registraImpedimento nome listaDoador (Impedimento.buscaImpedimento "DOENCA" cid listaImpedimentos) )
                putStrLn("Doença atribuida ao pasciente com sucesso")
                menuInicial
            else do
                putStrLn("Entrada Inválida")
                menuInicial
            
        else do
            putStrLn ("Doador não encontrado")
        menuInicial
    else if(tipo == "5") then do
        putStrLn ("Insira o nome do Doador(a)")
        nome <- getLine
        if (Doador.doadorCadastrado nome listaDoador) then do
            (putStrLn (Doador.listarDoacoes nome listaDoador))
        else do
            putStrLn ("Doador não encontrado")
        menuInicial
    else if(tipo == "6") then do
        putStrLn ("Insira o nome do Doador(a)")
        nome <- getLine
        if (Doador.doadorCadastrado nome listaDoador) then do
            putStrLn (Doador.mostraFichaTecnica nome listaDoador)
        else do
            putStrLn ("Doador não encontrado")
        menuInicial
    else do
        putStrLn ("Opção inválida")


impedimentos :: [Impedimento.Impedimento] -> IO()
impedimentos listaImpedimentos = do 
    putStrLn ("\n1. Cadastro de Impedimento\n" ++ 
            "2. Buscar Impedimento\n" ++
            "3. Listar Impedimentos\n" ++
            "4. Deletar Impedimento")
    opcao <- getLine
    if (opcao == "1") then do
        putStrLn ("Cadastro de Impedimentos\n" ++
            "1. Cadastro de Medicamento\n" ++
            "2. Cadastro de Doenca")
        tipo <- getLine
        if (tipo == "1") then do
            putStrLn("Cadastro de Medicamento\n" ++
                    "Funcao: ")
            input <- getLine
            let funcao = input
            putStrLn("Composto: ")
            input <- getLine
            let composto = input
            putStrLn("tempo de Suspencao (em dias): ")
            input <- getLine 
            let tempoSuspencao = read input :: Integer
            Auxiliar.escreverImpedimento (Impedimento.adicionaImpedimento funcao composto tempoSuspencao)
            putStrLn ("Impedimento cadastrado")
            menuInicial
        else if (tipo == "2") then do
            putStrLn("Cadastro de Doenca\n" ++
                    "CID: ")
            input <- getLine
            let cid = input
            putStrLn("tempo de Suspencao (em dias): ")
            input <- getLine
            let tempoSuspencao = read input :: Integer
            Auxiliar.escreverImpedimento (Impedimento.adicionaImpedimento [] cid tempoSuspencao)
            putStrLn ("Impedimento cadastrado")
            menuInicial
        else do
            putStrLn("Entrada Invalida")
            menuInicial
    else if (opcao == "2") then do 
        putStrLn ("Buscar Impedimentos\n" ++
            "1. Buscar Medicamento\n" ++
            "2. Buscar Doenca")
        tipo <- getLine
        if (tipo == "1") then do
            putStrLn("Buscar Medicamento\n" ++
                "Composto: ")
            input <- getLine
            let composto = input
            if ((Impedimento.existeImpedimento "MEDICAMENTO" composto listaImpedimentos)) then do
                putStrLn (Impedimento.buscaImpedimentoStr "MEDICAMENTO" composto listaImpedimentos)
            else do
                putStrLn("Medicamento nao cadastrado")
            menuInicial
        else if (tipo == "2") then do
            putStrLn("Buscar Doenca\n" ++
                    "CID: ")
            input <- getLine
            let cid = input
            if ((Impedimento.existeImpedimento "DOENCA" cid listaImpedimentos)) then do
                putStrLn (Impedimento.buscaImpedimentoStr "DOENCA" cid listaImpedimentos)
            else do
                putStrLn("Doença não cadastrado")
            menuInicial
        else do
            putStrLn("Entrada Invalida")
            menuInicial
    else if (opcao == "3") then do
        putStrLn ("Listar Impedimentos")
        putStrLn(Impedimento.listarImpedimentos listaImpedimentos)
        menuInicial
    else if (opcao == "4") then do
        putStrLn ("Deletar Impedimentos\n" ++
            "1. Deletar Medicamento\n" ++
            "2. Deletar Doenca")
        tipo <- getLine
        if (tipo == "1") then do
            putStrLn("Deletar Medicamento\n" ++
                    "Composto: ")
            input <- getLine
            let composto = input
            if ((Impedimento.existeImpedimento "MEDICAMENTO" composto listaImpedimentos)) then do
                Auxiliar.rescreverImpedimento (Impedimento.removeImpedimetno(Impedimento.buscaImpedimento "MEDICAMENTO" composto listaImpedimentos) listaImpedimentos)
                putStrLn ("Medicamento deletado")
            else do
                putStrLn ("Medicamento não encontrado")
            menuInicial
        else if (tipo == "2") then do
            putStrLn("Deletar Doenca\n" ++
                    "CID: ")
            input <- getLine
            let cid = input
            if ((Impedimento.existeImpedimento "DOENCA" cid listaImpedimentos)) then do            
                Auxiliar.rescreverImpedimento (Impedimento.removeImpedimetno(Impedimento.buscaImpedimento "DOENCA" cid listaImpedimentos) listaImpedimentos)
                putStrLn ("Doença deletado")
            else do
                putStrLn ("Doença não encontrado")
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
            "4. Adicionar escala de Enfermeiros\n" ++
            "5. Visualizar escala de Enfermeiros\n")
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
        if (Enfermeiro.enfermeiroCadastrado nome listaEnfermeiros) then do          
            putStrLn (Enfermeiro.enfermeiroToString nome listaEnfermeiros)
        else do
            putStrLn ("Enfermeiro não encontrado")
        menuInicial
    else if(tipo == "3") then do        
        putStrLn (Enfermeiro.todosOsEnfermeiros listaEnfermeiros)
        menuInicial
    else if(tipo == "4") then do
        putStrLn("Insira a data")
        diaMesAno <- getLine
        if(Auxiliar.verificaDataPassada diaMesAno == False) then do
            putStrLn("Data já ultrapassada")
            menuInicial
        else do
        putStrLn("Insira o nome do Enfermeiro")
        enfermeiro <- getLine 
        if (Enfermeiro.enfermeiroCadastrado enfermeiro listaEnfermeiros) then do             
            Auxiliar.rescreverEscala (Enfermeiro.organizaEscala (Auxiliar.stringEmData diaMesAno) mapaEscala enfermeiro listaEnfermeiros)
            putStrLn("Enfermeiro alocado na escala com sucesso")
        else do 
            putStrLn ("Enfermeiro não encontrado")
        menuInicial
    else if(tipo == "5") then do
        putStrLn("Insira a data")
        diaMesAno <- getLine                
        putStrLn (Enfermeiro.visualizaEscala (Auxiliar.stringEmData diaMesAno) mapaEscala)
        menuInicial   
    else do        
        menuInicial

estoque ::[Bolsa.Bolsa] -> IO()
estoque listaEstoque = do
    {- Mensagem de Estoque: se tiver menos de 1000 ml por tipo sanguineo é dado um aviso de falta de sangue
                            se tiver mais de 10000 ml por tipo sanguineo é dado um aviso de sobra de sangue
    -}
    putStrLn(Estoque.mensagemDeAviso listaEstoque 0)
    putStr ("1. Adicionar Doação de Sangue\n" ++
            "2. Retirar Bolsa de Sangue\n" ++
            "3. Visão Geral do Estoque\n" ++
            "4. Listar Todas as Bolsas\n" ++
            "5. Listar Bolsas por Tipo\n")
    tipo <- getLine
    
    if(tipo == "1")then do
        putStrLn("Qual o nome do Doador? (digite anon para anônimo)")          
        nomeDoador <- getLine
        if((toUpperCase nomeDoador) /= "ANON") then do
            listaDoadores <- carregaDoadores
            let doador = Doador.encontraDoador nomeDoador listaDoadores 
            -- se nao achar o doador, ele volta um doador com nome vazio:
            if(Doador.nome doador == "") then do 
                putStrLn("Doador não encontrado\n")
                menuInicial
            else do
                diaHoje <- getToday
                if(Doador.isImpedido doador diaHoje) then do
                    putStrLn ("Doador com impedimento!")
                    menuInicial
                else do
                    let tipoSanguineo = Doador.tipSanguineo doador
                    putStrLn("Doador encontrado!")
                    today <- hoje
                    let adicionaDoacao = Doador.adicionaDoacao nomeDoador listaDoadores ("Doação realizada dia " ++ show (getDia today) ++ "/" ++ show(getMes today) ++  "/" ++ show (getAno today))
                    putStrLn("Uma Bolsa de 450 ml do tipo " ++ (Doador.tipSanguineo doador) ++ " foi cadastrada no estoque!\n")
                    Auxiliar.escreverEstoque([Estoque.adicionaBolsa tipoSanguineo 450])       
                    Auxiliar.rescreverDoador(Doador.registraImpedimento (Doador.nome doador) listaDoadores (Impedimento.Doenca "DOENCA" "Realizou doação" 60))       
                    menuInicial
        else do
            putStrLn("Qual o tipo sanguineo do doador anônimo?")
            tipoSanguineo <- getLine
            if((elem (toUpperCase tipoSanguineo) tipos) == False) then do
                putStrLn("Tipo Inválido\n")
                menuInicial
            else do    
                putStrLn("Uma Bolsa de 450 ml do tipo " ++ (toUpperCase tipoSanguineo) ++ " foi cadastrada no estoque!\n")
                Auxiliar.escreverEstoque([Estoque.adicionaBolsa (toUpperCase tipoSanguineo) 450]) 
                menuInicial  

    else if(tipo == "2") then do
        putStrLn("Qual o nome do Recebedor? (digite anon para anônimo)")          
        nomeRecebedor <- getLine
        if((toUpperCase nomeRecebedor) /= "ANON") then do
            listaRecebedores <- carregaRecebedores
            let recebedor = Recebedor.encontraRecebedor nomeRecebedor listaRecebedores
            if(Recebedor.tipoSanguineo recebedor == "") then do
                putStrLn("Recebedor não encontrado\n")
                menuInicial
            else do
                let tipoSanguineo = Recebedor.tipoSanguineo recebedor
                putStrLn("Recebedor encontrado!")
                putStrLn("Quantas bolsas serão necessárias?")
                numBolsas <- getLine
                let bolsasDisponiveis = Estoque.verificaQtdBolsas (read numBolsas) tipoSanguineo listaEstoque
                if((length bolsasDisponiveis) < (read numBolsas)) then do    
                    putStrLn("Não há bolsas suficiente disponíveis")
                    menuInicial                
                else do
                    let bolsasRestantes = Estoque.removeBolsa (bolsasDisponiveis!!0) (read numBolsas) listaEstoque
                    Auxiliar.reescreveEstoque (bolsasRestantes)
                    putStrLn(numBolsas ++ " bolsas do tipo " ++ tipoSanguineo ++ " retiradas com sucesso!")
                    menuInicial
        else do 
            putStrLn("Qual o tipo sanguineo do recebedor anônimo?")
            tipoSanguineo <- getLine
            if((elem (toUpperCase tipoSanguineo) tipos) == False) then do
                putStrLn("Tipo Inválido\n")
                menuInicial
            else do
                putStrLn("Quantas bolsas serão necessárias?")
                numBolsas <- getLine
                let bolsasDisponiveis = Estoque.verificaQtdBolsas (read numBolsas) tipoSanguineo listaEstoque
                if((length bolsasDisponiveis) < (read numBolsas)) then do    
                    putStrLn("Não há bolsas suficiente disponíveis")
                    menuInicial  
                else do    
                let bolsasRestantes = Estoque.removeBolsa (bolsasDisponiveis!!0) (read numBolsas) listaEstoque
                Auxiliar.reescreveEstoque (bolsasRestantes)
                putStrLn(numBolsas ++ " bolsas do tipo " ++ tipoSanguineo ++ " retiradas com sucesso!")
                menuInicial

    else if(tipo == "3") then do
        putStrLn("\nVisão Geral Do Estoque:")
        putStrLn(Estoque.visaoGeralEstoque listaEstoque)
        menuInicial                                
    else if(tipo == "4") then do
        let estoque = Estoque.listaTodasAsBolsas listaEstoque
        putStrLn estoque
        menuInicial
    else if(tipo == "5") then do
        putStrLn("Tipo Sanguineo: ")
        input <- getLine
        let tipoSanguineo = input
        if((elem (toUpperCase tipoSanguineo) tipos) == False) then do
            putStrLn("Tipo Inválido!\n")
            menuInicial
        else do    
            let estoque = Estoque.listaBolsasPorTipo tipoSanguineo listaEstoque
            putStrLn estoque
            menuInicial
    else do
        putStrLn ("Entrada Inválida!\n")
        main


tipos :: [String]
tipos = ["O-","O+","A-","A+","B+","B-","AB+","AB-"]    

agendaDoacao :: Map Day String -> [Enfermeiro.Enfermeiro] -> [Doador.Doador] -> IO()
agendaDoacao agenda listaEnfermeiros listaDoadores = do
    putStrLn ("\n1. Agendar coleta no Hemocentro\n" ++ "2. Agendar coleta em domicílio\n" ++ "3. Visualizar agenda de doações")
    tipo <- getLine
    if(tipo == "1")then do
        putStrLn("Insira a data")
        diaMesAno <- getLine
        if(Auxiliar.verificaDataPassada diaMesAno == False) then do
            putStrLn("Data passada")
            menuInicial
        else do
        putStrLn("Insira o nome do Doador")
        doador <- getLine
        putStrLn("Insira o nome do Enfermeiro")
        enfermeiro <- getLine
        if((Doador.doadorCadastrado doador listaDoadores) == False) then do
            putStrLn ("Doador não cadastrado")
            menuInicial
        else if(Enfermeiro.enfermeiroCadastrado enfermeiro listaEnfermeiros == False) then do
            putStrLn ("Enfermeiro não cadastrado")
            menuInicial
        else if (Doador.isImpedido (Doador.encontraDoador doador listaDoadores) (Auxiliar.stringEmData diaMesAno)) then do
            putStrLn ("Doador impedido até dia " ++ (dayParaString(Doador.ultimoDiaImpedido (Doador.encontraDoador doador listaDoadores))))
            menuInicial
        else do
            Auxiliar.rescreverAgendaLocal (Agenda.agendaDoacaoLocal (Auxiliar.stringEmData diaMesAno) agenda doador enfermeiro "Hemocentro")
            putStrLn ("Doação Agendada")
            menuInicial
    else if(tipo == "2") then do
        putStrLn("Insira a data")
        diaMesAno <- getLine
        if(Auxiliar.verificaDataPassada diaMesAno == False) then do
            putStrLn("Data passada")
            menuInicial
        else do
        putStrLn("Insira o nome do Doador")
        doador <- getLine
        putStrLn("Insira o nome do Enfermeiro")
        enfermeiro <- getLine
        if((Doador.doadorCadastrado doador listaDoadores) == False) then do
            putStrLn ("Doador não cadastrado")
            menuInicial
        else if(Enfermeiro.enfermeiroCadastrado enfermeiro listaEnfermeiros == False) then do
            putStrLn ("Enfermeiro não cadastrado")
            menuInicial
        else if (Doador.isImpedido (Doador.encontraDoador doador listaDoadores) (Auxiliar.stringEmData diaMesAno)) then do
            putStrLn ("Doador impedido até dia " ++ (dayParaString(Doador.ultimoDiaImpedido (Doador.encontraDoador doador listaDoadores))))
            menuInicial
        else do
            let doadorEndereco = Doador.getEnderecoDoador doador listaDoadores
            Auxiliar.rescreverAgendaLocal (Agenda.agendaDoacaoLocal (Auxiliar.stringEmData diaMesAno) agenda doador enfermeiro doadorEndereco)
            putStrLn ("Doação Agendada")
            menuInicial
    else if(tipo == "3") then do
        putStrLn("Insira a data")
        diaMesAno <- getLine
        putStrLn (Agenda.agendaDoacaoImprime agenda (Auxiliar.stringEmData diaMesAno))
        menuInicial
    else do
        menuInicial
        

cadastroDeRecebedor :: [Recebedor.Recebedor] -> IO()
cadastroDeRecebedor listaRecebedores = do
    putStr (
        "1. Cadastro de Recebedor\n" ++
        "2. Buscar Recebedor\n" ++
        "3. Listar Recebedores\n"     
        )

    input <- getLine

    if (input == "1") then do
        nome <- prompt "Digite o nome do(a) Recebedor(a) "
        endereco <- prompt "Digite o endereço do(a) Recebedor(a) "
        age <- prompt "Digite a idade do(a) Recebedor(a): "
        let idade = read age
        telefone <- prompt "Digite o telefone do(a) Recebedor(a): "
        qtd <- prompt "Digite a quantidade de bolsas de sangue que o(a) Recebedor(a) precisa: "
        let quantidade = read qtd
        tipo <- prompt "Tipo Sanguíneo: "
        if((elem (toUpperCase tipo) tipos) == False) then do
            putStrLn("Tipo Inválido\n")
            cadastroDeRecebedor listaRecebedores
        else do
        hospital <- prompt "Hospital internado: "
        --------------------------------------------------------------------------------------------
        -- cadastrar ficha medica 
        
        sexo <- prompt "Sexo Feminino (f) Masculino (m): "
        dataNascimento <- prompt "Data de nascimento: "
        pai <- prompt "Nome do pai: "
        mae <- prompt "Nome da mãe: "
        acompanhamentoMedico <- prompt "Tem acompanhamento médico ou psicológico? Não (n) Sim (s): "
        condicaoFisica <- prompt "Tem alguma condição que exige atenção especial ou restrição a atividade física? Não (n) Sim (s): "
        alergias <- prompt "Tem alergia a algum medicamento/alimento/material?"
        let ficha = FichaMedica.adicionaFichaMedica sexo dataNascimento pai mae acompanhamentoMedico condicaoFisica alergias
        ---------------------------------------------------------------------------------------------
        Auxiliar.escreverRecebedores(Recebedor.adicionaRecebedor nome endereco idade telefone quantidade tipo hospital ficha)
        putStr "Recebedor Cadastrado"
        menuInicial

    else if (input == "2") then do
        nome <- prompt "Digite o nome do recebedor: "
        let recebedor = Recebedor.recebedorCadastrado nome listaRecebedores
        if (recebedor == True) then do
            verFicha <- prompt "Visualizar:\n(1) Ficha Médica do recebedor\n(2) Ficha de Dados\n(3) Sair \n"
            putStrLn "\n"
            if (verFicha == "1") then do
                let fichaMedica = Recebedor.recebedorFichaMedicaString nome listaRecebedores 
                putStr fichaMedica 

            else do
                let recebe = Recebedor.recebedorToString nome listaRecebedores
                putStr recebe
            
        else do 
            putStr "Recebedor não cadastrado\n"
            menuInicial

        menuInicial
        

    else if (input == "3") then do
        let showListaRecebedores = Recebedor.todosOsRecebedores listaRecebedores
        putStr ("\n" ++ showListaRecebedores)
        menuInicial
      
    else putStr ("Entrada Inválida")

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
    listaEstoque <- carregaEstoque   
    DatasCriticas.verificaHoje listaEstoque
    
dayParaString :: Day -> String
dayParaString dia = show (getDia diaMesAno) ++ "/" ++ show (getMes diaMesAno) ++ "/" ++ show (getAno diaMesAno)
    where diaMesAno = toGregorian dia
    
getAno :: (a, b, c) -> a
getAno (y, _, _) = y
getMes :: (a, b, c) -> b
getMes (_, y, _) = y
getDia :: (a, b, c) -> c
getDia (_, _, y) = y

getToday :: IO(Day)
getToday = do
    today <- (utctDay <$> getCurrentTime)    
    return (today)

hoje :: IO((Integer, Int, Int))
hoje = do
    today <- toGregorian <$> (utctDay <$> getCurrentTime)    
    return (today)


toUpperCase :: String -> String
toUpperCase entrada = [toUpper x | x <- entrada]

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

carregaRecebedores :: IO([Recebedor.Recebedor])
carregaRecebedores = Auxiliar.iniciaRecebedores

carregaDoadores :: IO([Doador.Doador])
carregaDoadores = Auxiliar.iniciaDoador


