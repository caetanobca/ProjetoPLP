:- include('Enfermeiros.pl').
:- include('Recebedores.pl').
:- include('Impedimentos.pl').
:- include('Estoque.pl').
:- include('Doador.pl').
:- include('Persistencia.pl').
:- include('HistoricoDoEstoque.pl').
:- include('Agenda.pl').
:- initialization(main).


menuEnfermeiro(99):-    
    tty_clear,    
    write("Menu Enfermeiros"),nl,
    write("1. Cadastro de Enfermeiros"), nl,
    write("2. Buscar Enfermeiros"), nl,
    write("3. Listagem de Enfermeiros"), nl,
    write("4. Adicionar escala de Enfermeiros"), nl,
    write("5. Visualizar escala de Enfermeiros"), nl,
    lerNumero(Numero),
    menuEnfermeiro(Numero),
    menu(99).

menuEnfermeiro(1):-
    listaEnfermeiros(ListaEnfermeiros),    
    write("Você irá cadastrar um Enfermeiro(a): "),nl,
    write("Insira o nome do Enfermeiro(a): "),
    lerString(Nome),
    write("Insira o endereço do Enfermeiro(a): "),
    lerString(Endereco),
    write("Insira a idade do Enfermeiro(a): "),
    lerString(Idade),
    write("Insira o telefone do Enfermeiro(a): "),
    lerString(Telefone),
    constroiEnfermeiro(Nome,Endereco,Idade,Telefone,Enfermeiro),
    salvaEnfermeiro(Enfermeiro),
    write("Enfermeiro(a) cadastrad(a)"), nl,       
    write("Pressione enter para continuar."),
    lerString(_),
    menu(99).

menuEnfermeiro(2):-
    listaEnfermeiros(ListaEnfermeiros),
    write("Insira o nome do(a) Enfermeiro(a) que você deseja: "),
    lerString(Nome),
    buscaEnfermeiro(Nome,ListaEnfermeiros,Enfermeiro),
    write(Enfermeiro),    
    menu(99).

menuEnfermeiro(3):-
    listaEnfermeiros(ListaEnfermeiros),
    listarEnfermeiros(ListaEnfermeiros),
    write("Pressione enter para continuar."),
    lerString(_),
    menu(99).

menuEnfermeiro(4):-
    listaEnfermeiros(ListaEnfermeiros),
    write("Insira a Data: "),
    lerString(Data),
    write("Insira o nome do Enfermeiro: "),
    lerString(Nome),    
    listaEnfermeiros(ListaEnfermeiros),       
    buscaEnfermeiro(Nome,ListaEnfermeiros,Enfermeiro), 
    listaEscala(ListaEscala),      
    ((Enfermeiro \= "Enfermeiro não encontrado")-> 
    (adicionaEscala(Data,Enfermeiro,ListaEscala,Result), salvaEscala(Result), write("Enfermeiro escalado"))
    ; write("Enfermeiro não cadastrado")), 

    nl, write("Pressione enter para continuar."),
    lerString(_),
    menu(99).


menuEnfermeiro(5):-
    listaEscala(ListaEscala),   
    write("Visualizar escala de Enfermeiros"), nl,
    write("Insira a data: "), lerString(Data),   
    pegaData(Data, ListaEscala, Result),     
    (Result \= -1 -> visualizaEscalaData(ListaEscala,Data); write("Sem escalas para essa data")),

    nl, write("Pressione enter para continuar."),
    lerString(_),
    menu(99).

menuEnfermeiro(N):-
    tty_clear,    
    write("Opção "), write(N), write(" Inválida"),nl,
    write("Pressione enter para continuar."),
    lerString(_),
    menu(99).

/*-----------------------------------------------------------------*/
menuRecebedor(99):-
    tty_clear,
    write("Menu Recebedores"),nl,
    write("1. Cadastro de Recebedores"), nl,
    write("2. Buscar Recebedores"), nl,
    write("3. Listar Recebedores"), nl,
    lerNumero(Numero),
    menuRecebedor(Numero),
    menu(99).

menuRecebedor(1):-   
    write("Você irá cadastrar um Recebedor(a): "),nl,
    write("Nome do Paciente: "), lerString(Nome),
    write("Idade do Paciente: "), lerString(Idade),
    write("Endereço do Paciente: "), lerString(Endereco),
    write("Numero de bolsas requisitadas para o Paciente: "), lerNumero(NumDeBolsas),
    write("Tipo sanguíneo do Paciente: "), lerString(TipoSanguineo), validaTipo(TipoSanguineo),
    write("Hospital no qual o paciente esta internado: "), lerString(Hospital),
    constroiRecebedor(Nome, Idade, Endereco, NumDeBolsas, TipoSanguineo, Hospital, Recebedor),
    salvaRecebedor(Recebedor),
    write("Paciente cadastrado(a)."), nl,
    write("Pressione enter para continuar."),
    lerString(_),
    menu(99).

menuRecebedor(2):-
    listaRecebedores(ListaRecebedores), 
    write("Insira o nome do paciente que você deseja procurar: "), lerString(Nome),
    buscaRecebedor(Nome, ListaRecebedores, Recebedor),
    (existeRecebedor(Nome, ListaRecebedores) -> (recebedoreString(Recebedor, RecebedorStr),
    write(RecebedorStr)); write(Recebedor)),nl,
    write("Pressione enter para continuar."),
    lerString(_),    
    menu(99).

menuRecebedor(3):-
    listaRecebedores(ListaRecebedores),
    listarRecebedores(ListaRecebedores), nl,
    write("Pressione enter para continuar."),
    lerString(_),
    menu(99).


menuRecebedor(N):-
    tty_clear,
    write("Opção "), write(N), write(" Inválida"),nl,
    write("Pressione enter para continuar."),
    lerString(_),
    menu(99).

/*-----------------------------------------------------------------*/

%Menu de Impedimentos
menuImpedimento(99):-
    tty_clear,
    write("Menu Impedimentos"),nl,
    write("1. Cadastro de Impedimento"), nl,
    write("2. Buscar Impedimento"), nl,
    write("3. Listagem de Impedimentos"), nl,
    write("4. Deletar Impedimento"), nl,
    lerNumero(Numero),
    tty_clear,
    menuImpedimento(Numero),
    menu(99).
 
%Menu de impedimento para cadastrar impedimento
menuImpedimento(1):-
    write("Cadastro de Impedimentos"), nl,
    write("1. Cadastro de Medicamento"), nl,
    write("2. Cadastro de Doenca"), nl,
    lerNumero(Opcao),
    cadastroImpedimento(Opcao, Impedimento),
    salvaImpedimento(Impedimento),
    menu(99).

%Menu de impedimento para buscar impedimento
menuImpedimento(2):-
    listaImpedimentos(ListaImpedimentos),
    write("Buscar Impedimento"), nl,
    write("Medicamento -> Id = Composto"), nl,
    write("Doenca -> Id = Cid"), nl,
    write("Id: "), lerString(Id), nl,
    buscaImpedimento(Id, ListaImpedimentos, Impedimento),
    write(Impedimento), nl, nl,
    write("Pressione enter para continuar"), nl,
    lerString(Wait),    
    menu(99).

%Menu de impedimento para listar os impedimentos
menuImpedimento(3):-
    listaImpedimentos(ListaImpedimentos),
    write("Listagem de Impedimentos: "), nl,    
    listarImpedimentos(ListaImpedimentos), nl, nl, 
    write("Pressione enter para continuar"), nl,
    lerString(_), 
    menu(99).

%Menu de impedimento para apagar impedimento
menuImpedimento(4):-
    write("Deletar Impedimento"), nl,
    write("Medicamento -> Id = Composto"), nl,
    write("Doenca -> Id = Cid"), nl,
    write("Id: "), lerString(Id), nl,
    removeImpedimento(Id),
    menu(99).

menuImpedimento(N):-
    tty_clear,    
    write("Opção "), write(N), write(" Inválida"),nl,
    write("Pressione enter para continuar."),
    lerString(_),
    menu(99).

%Cadastro de impedimento:
%Cadastro de medicamento
cadastroImpedimento(1, Impedimento):-
    tty_clear,
    write("Cadastro de Medicamento"), nl,
    write("Função: "), lerString(Funcao), nl,
    write("Composto: "), lerString(Composto), nl,
    write("tempo de Suspencao (em dias): "), lerNumero(Tempo), nl,
    constroiMedicamento(Funcao, Composto, Tempo, Impedimento).

%Cadastro doenca
cadastroImpedimento(2, Impedimento):-
    tty_clear,
    write("Cadastro de Doenca"), nl,
    write("Cid: "), lerString(Cid), nl,
    write("tempo de Suspencao (em dias): "), lerNumero(Tempo), nl,
    constroiDoenca(Cid, Tempo, Impedimento).

cadastroImpedimento(N, Impedimento):-
    tty_clear,    
    write("Opção "), write(N), write(" Inválida"),nl,
    write("Pressione enter para continuar."),
    lerString(_),
    menu(99).

/*-----------------------------------------------------------------*/

menuDoador(99):-
    tty_clear,
    write("Menu Doador"),nl,
    write("1. Cadastro de Doadores"), nl,
    write("2. Buscar Doadores"), nl,
    write("3. Listagem de Doadores"), nl,
    write("4. Cadastrar impedimento em Doador(a)"), nl,
    write("5. Mostrar ficha tecnica do Doador(a)"), nl,
    lerNumero(Numero),
    menuDoador(Numero),
    menu(99).

menuDoador(1):-
    write("Você irá cadastrar um Doador(a): "),
    nl,
    write("Insira o nome do Doador(a): "),
    lerString(Nome),
    write("Insira o endereço do Doador(a): "),
    lerString(Endereco),
    write("Insira a idade do Doador(a): "),
    lerString(Idade),
    write("Insira o telefone do Doador(a): "),
    lerString(Telefone),
    write("Insira o Tipo Sanguineo do Doador(a): "),
    lerString(TipSanguineo),
    validaTipo(TipSanguineo),
    getOntem(Ontem), 
    constroiDoador(Nome,Endereco,Idade,Telefone,TipSanguineo, "", Ontem,Doador),    
    salvaDoador(Doador),
    write("Doador(a) cadastrad(a)"),
    menu(99).

menuDoador(2):-
    listaDoadores(ListaDoadores),
    write("Insira o nome do(a) Doador(a) que você deseja: "),
    lerString(Nome),
    buscaDoador(Nome,ListaDoadores,Doador),
    write(Doador),    
    menu(99).

menuDoador(3):-
    listaDoadores(ListaDoadores),
    listarDoadores(ListaDoadores),
    write("Pressione enter para continuar."),
    lerString(_),
    menu(99).

menuDoador(4):-
    listaDoadores(ListaDoadores),
    write("Insira o nome do(a) Doador(a) que você deseja adicionar um impedimento na ficha medica: "),
    lerString(Nome),
    buscaDoador(Nome,ListaDoadores,Doador),
    /* falta fazer*/
    menu(99).

menuDoador(5):-
    listaDoadores(ListaDoadores),
    write("Insira o nome do(a) Doador(a) que você deseja ver a ficha medica: "),
    lerString(Nome),
    buscaDoador(Nome,ListaDoadores,Doador),
    getDoadorImpedimentoStr(Doador, ImpedimentoStr),
    write(ImpedimentoStr),

    write("Pressione enter para continuar."),
    lerString(_),
    menu(99).

menuDoador(N):-
    tty_clear,    
    write("Opção "), write(N), write(" Inválida"),nl,
    write("Pressione enter para continuar."),
    lerString(_),
    menu(99).


% Menu de Estoque
menuEstoque(99):-
    write("Menu Estoque"),nl,
    write("1. Registrar Doacao"), nl,
    write("2. Registrar Retirada"), nl,
    write("3. Listar Estoque"), nl,
    lerNumero(Numero),
    menuEstoque(Numero),
    menu(99).


%Menu de Estoque para cadastro de nova doação
menuEstoque(1):-
    write("Qual o nome do doador (digite anon para anonimo)? "),
    lerString(NomeDoador),
    string_upper(NomeDoador, NomeDoadorUpper),
    (NomeDoadorUpper = "ANON" -> menuEstoque(11); menuEstoque(12,NomeDoadorUpper)).

%Menu de Estoque para cadastro de nova doação anonima
menuEstoque(11):-
    listaEstoque(ListaEstoque),
    write("Insira o Tipo Sanguineo do Doador: "),
    lerString(TipoSanguineo),
    string_upper(TipoSanguineo, TipoSanguineoUpper),
    constroiBolsa(TipoSanguineoUpper,450,NovaBolsa),
    salvaEstoque(NovaBolsa),
    write("Bolsa cadastrada"),
    menu(99).

%Menu de Estoque para cadastro de nova doação com Doador ja cadastrado
%TODO IMPEDIMENTOS! TODO Testar quando Doador tiver pronto!
menuEstoque(12,NomeDoador):-
    tty_clear,  
    listaEstoque(ListaEstoque),
    listaDoadores(ListaDoadores),
    (existeDoador(NomeDoador, ListaDoadores) -> true; write("Doador nao encontrado"), menu(99)),
    buscaDoador(NomeDoador,ListaDoadores,Doador),
    getDoadorTipSanguineo(Doador, TipSanguineo),
    constroiBolsa(TipSanguineo,450,NovaBolsa),
    salvaEstoque(NovaBolsa),
    write("Bolsa cadastrada"),
    menu(99).
  
%Menu de Estoque para cadastro de retirada de bolsa
menuEstoque(2):-
    tty_clear, 
    write("Qual o nome do recebedor (digite anon para anonimo)? "),
    lerString(NomeRecebedor),
    string_upper(NomeRecebedor, NomeRecebedorUpper),
    (NomeRecebedorUpper = "ANON" -> menuEstoque(21); write("ainda nao implementado")), %TODO
    menu(99).

%Menu de Estoque para cadastro de retirada de bolsa para anonimo
menuEstoque(21):-
    tty_clear,
    listaEstoque(ListaEstoque),
    write("Insira o Tipo Sanguineo do Recebedor anonimo: "),
    lerString(TipoSanguineo),
    string_upper(TipoSanguineo, TipoSanguineoUpper),
    validaTipo(TipoSanguineoUpper),
    write("Quantas bolsas serao necessarias? "),
    lerNumero(NumBolsas),
    verificaQtdBolsas(ListaEstoque,NumBolsas,TipoSanguineoUpper,Result),
    (Result = -1 ->  write("Não há bolsas suficientes disponíveis!"),nl, menu(99); true), 
    removeEstoque(TipoSanguineoUpper,NumBolsas),
    write("Bolsas Retiradas com sucesso!"),
    menu(99).


%Menu de Estoque para cadastro de retirada de bolsa para recebedor ja cadastrado
menuEstoque(22,NomeRecebedor):-
    tty_clear,
    listaEstoque(ListaEstoque),
    listaRecebedores(ListaRecebedores),
    (existeRecebedor(NomeRecebedor, ListaRecebedores) -> true; write("Recebedor nao encontrado"), menu(99)),
    buscaRecebedor(NomeRecebedor,ListaRecebedores,Recebedor),
    getRecebedorTipoSanguineo(Recebedor,TipoSanguineo),
    write("Quantas bolsas serão necessarias? "),
    lerNumero(NumBolsas),
    (Result = -1 ->  write("Não há bolsas suficientes disponíveis!"),nl, menu(99); true), 
    removeEstoque(TipoSanguineoUpper,NumBolsas),
    write("Bolsas Retiradas com sucesso!"),
    menu(99).

%Imprime a visao geral do Estoque disponivel
menuEstoque(3):-
    tty_clear, 
    listaEstoque(ListaEstoque),
    listaVisaoGeralEstoque(ListaEstoque,0),
    menu(99).    

%Se o usuario digitar uma opcao invalida, ele sera informado e voltara para o menu principal
menuAgenda(99):-    
    tty_clear,    
    write("Menu Agendamento"),nl,
    write("1. Agendar coleta no Hemocentro"), nl,
    write("2. Agendar coleta em domicílio"), nl,
    write("3. Visualizar agenda de doações"), nl,
    lerNumero(Numero),
    menuAgenda(Numero),
    menu(99).

menuAgenda(1):-
    listaEnfermeiros(ListaEnfermeiros),
    listaDoadores(ListaDoadores),
    listaAgenda(ListaAgenda),

    write("Agendar coleta no Hemocentro"),nl,
    write("Insira a data: "), lerString(Data),
    write("Insira o nome do Doador(a): "), lerString(DoadorNome),
    write("Insira o nome do Enfermeiro(a): "), lerString(EnfermeiroNome),
   
    buscaEnfermeiro(EnfermeiroNome,ListaEnfermeiros,Enfermeiro), 
    buscaDoador(DoadorNome,ListaDoadores,Doador),
    ((Enfermeiro \= "Enfermeiro não encontrado")->(
    (Doador \= "Doador não encontrado")-> (adicionaAgendaHemocentro(Data, Doador, Enfermeiro, ListaAgenda, AgendaNova))
    ; write("Doador não cadastrado")); write("Enfermeiro não cadastrado")), 
    salvaAgenda(AgendaNova),
    
    nl, write("Pressione enter para continuar."),
    lerString(_),
    menu(99).

menuAgenda(2):-
    listaEnfermeiros(ListaEnfermeiros),
    listaDoadores(ListaDoadores),
    listaAgenda(ListaAgenda),

    write("Agendar coleta em domicílio"),nl,
    write("Insira a data: "), lerString(Data),
    write("Insira o nome do Doador(a): "), lerString(DoadorNome),
    write("Insira o nome do Enfermeiro(a): "), lerString(EnfermeiroNome),
   
    buscaEnfermeiro(EnfermeiroNome,ListaEnfermeiros,Enfermeiro), 
    buscaDoador(DoadorNome,ListaDoadores,Doador),
    ((Enfermeiro \= "Enfermeiro não encontrado")->(
    (Doador \= "Doador não encontrado")-> (adicionaAgendaDomicilio(Data, Doador, Enfermeiro, ListaAgenda, AgendaNova))
    ; write("Doador não cadastrado")); write("Enfermeiro não cadastrado")), 
    salvaAgenda(AgendaNova),

    nl, write("Pressione enter para continuar."),
    lerString(_),
    menu(99).

menuAgenda(3):-
    listaAgenda(ListaAgenda),

    write("Visualizar agenda de doação"),nl,
    write("Insira a data: "), lerString(Data),    
    pegaData(Data, ListaAgenda, Result),
    (Result \= -1 -> visualizaAgenda(ListaAgenda,Data); write("Sem agendamentos para essa data")),

    nl, write("Pressione enter para continuar."),
    lerString(_),
    menu(99).

menuAgenda(N):-
    tty_clear,    
    write("Opção "), write(N), write(" Inválida"),nl,
    write("Pressione enter para continuar."),
    lerString(_),
    menu(99).


%Main
main:-
    carregaEnfermeiros(), 
    carregaImpedimentos(), 
    carregaEstoque(),
    carregaDoadores(),  
    carregaRecebedores(),
    carregaEscala(),
    carregaAgenda(),
    letreiroInicial,
    lerString(_),
    menu(99),
    halt.


%Menu(1) Invoca o Controle de Recebedores
menu(1):- 
    tty_clear,
    menuRecebedor(99),
    menu(99).

%Menu(2) Invoca o Controle de Estoque de Bolsas de Sangue 
menu(2):-    
    tty_clear, 
    write("Controle de Estoque de Bolsas de Sangue"),
    menuEstoque(99),
    nl,
    menu(99).

%Menu(3) Invoca o Controle de Doadores  
menu(3):-
    tty_clear,
    menuDoador(99),
    nl,    
    menu(99).

%Menu(4) Invoca o Controle de Enfermeiros
menu(4):-
    tty_clear,
    write("Controle de Enfermeiros"),       
    menuEnfermeiro(99),
    nl,
    menu(99).

%Menu(5) Invoca o Controle de Impedimentos
menu(5):-
    tty_clear,
    menuImpedimento(99),
    menu(99).

%Menu(6) Invoca o Controle de Agenda de Coleta de Sangue
menu(6):-
    tty_clear,
    menuAgenda(99),
    nl,
    menu(99).

%Menu(7) Invoca o Dashboard
menu(7):-
    tty_clear,
    write("Dashboard"),    
    lerString(A),
    nl,
    menu(99).

%Menu(8) Salva os dados 
menu(8):-
    salvarDados(),
    tty_clear,
    write("Dados Salvos!"), nl,
    write("Pressione enter para continuar."), 
    lerString(_),
    menu(99).   

%Menu(9) Encerra o programa
menu(9):-
    tty_clear,
    salvarDados(),
    write("Encerrando."),
    halt.
    

%Menu(99) Menu Inicial
menu(99):-    
    %tty_clear,    
    ttyflush,
    nl,        
    write("Escolha a opção:"), nl,
    write("1. Controle de Recebedores"), nl,
    write("2. Controle de Estoque de Bolsas de Sangue"), nl,
    write("3. Controle de Doadores"), nl,
    write("4. Controle de Enfermeiros"), nl,
    write("5. Controle de Impedimentos"), nl,
    write("6. Agendar Coleta de sangue"), nl,
    write("7. Dashboard"), nl,    
    write("8. Salvar Dados"), nl,    
    write("9. Sair"), nl,   
    lerNumero(Numero),
    menu(Numero).

%Menu(N) Quando o usuario passa uma entrada invalida, chama novamente o menu inicial 
menu(N):-
    tty_clear,
    write("Opção "), write(N), write(" Inválida"),nl,
    write("Pressione enter para continuar."),
    lerString(_),
    menu(99).

% Le uma String e converte em atomo  
lerString(X):- read_line_to_codes(user_input, E), atom_string(E,X).

% Le um numero e converte em atomo +
lerNumero(Numero):- read_line_to_codes(user_input, E), atom_string(E,X), atom_number(X,Numero).

%Exibe o letreiro inicial
letreiroInicial:-
    tty_clear,
    write(
"    _                       _   
   |_) |  _   _   _| |  o _|_ _ 
   |_) | (_) (_) (_| |_ |  | (/_"  ).



/*--------------------------------------------------------------------------
    Predicados responsaveis por lidar com as listas de forma dinamicas
---------------------------------------------------------------------------*/

%salva um enfermeiro na nova lista de enfermeiros
salvaEnfermeiro(Enfermeiro):-
    retract(listaEnfermeiros(Lista)),
    append(Lista,[Enfermeiro],NovaLista),
    assert(listaEnfermeiros(NovaLista)).

%cria a lista dinamica de enfermeiro
listaEnfermeiros([]).
:-dynamic listaEnfermeiros/1.

%carrega a lista salva com a persistencia de arquivo
carregaEnfermeiros():-
    iniciaEnfermeiros(ListaEnfermeiros),
    retract(listaEnfermeiros(Lista)),
    append(Lista,ListaEnfermeiros,NovaLista),
    assert(listaEnfermeiros(NovaLista)).

%--------------------------------------------------
%salva a escala de enfermeiros
salvaEscala(DiaEnfermeiro):-
    retract(listaEscala(Lista)),
    removerEscala(DiaEnfermeiro,Lista,ListaTemp),
    append(ListaTemp,[DiaEnfermeiro],NovaLista),
    assert(listaEscala(NovaLista)).

%cria a lista dinamica de escala
listaEscala([]).
:-dynamic listaEscala/1.

%carrega a lista salva com a persistencia de arquivo
carregaEscala():-
    iniciaEscala(ListaEscala),
    retract(listaEscala(Lista)),
    append(Lista,ListaEscala,NovaLista),
    assert(listaEscala(NovaLista)).


/*-----------------------------------------------------------------*/

%salva um recebedor na nova lista de recebedores
salvaRecebedor(Recebedor):-
    retract(listaRecebedores(Lista)),
    append(Lista,[Recebedor],NovaLista),
    assert(listaRecebedores(NovaLista)).

%remove um recebedor e faz a nova lista sem o recebedor que foi removido
/* TODO remover a funcao se nao for usar
removeRecebedor(Recebedor):-
    retract(listaRecebedores(Lista)),
    removerRecebedor(Lista,Recebedor,NovaLista),
    assert(listaRecebedores(NovaLista)).
*/


%cria a lista dinamica de recebedor
listaRecebedores([]).
:-dynamic listaRecebedores/1.
/*-----------------------------------------------------------------*/

%salva um doador na nova lista de doadores
salvaDoador(Doador):-
    retract(listaDoadores(Lista)),
    append(Lista,[Doador],NovaLista),
    assert(listaDoadores(NovaLista)).

%remove um doador e faz a nova lista sem o doador que foi removido
removeDoador(Doador):-
    retract(listaDoadores(Lista)),
    removerDoador(Lista,Doador,NovaLista),
    assert(listaDoadores(NovaLista)).

%cria a lista dinamica de doador
listaDoadores([]).
:-dynamic listaDoadores/1.

%carrega a lista salva com a persistencia de arquivo
carregaDoadores():-
    iniciaDoadores(ListaDoadores),
    retract(listaDoadores(Lista)),
    append(Lista,ListaDoadores,NovaLista),
    assert(listaDoadores(NovaLista)).
/*-----------------------------------------------------------------*/

%salva um impedimento na nova lista de impedimentos
salvaImpedimento(Impedimento):-
    retract(listaImpedimentos(Lista)),
    append(Lista,[Impedimento],NovaLista),
    assert(listaImpedimentos(NovaLista)).

%remove um impedimento e faz a nova lista sem o impedimento que foi removido
removeImpedimento(Impedimento):-
    retract(listaImpedimentos(Lista)),
    removerImpedimento(Impedimento,Lista,NovaLista),
    assert(listaImpedimentos(NovaLista)).

%cria a lista dinamica de impedimentos
listaImpedimentos([]).
:-dynamic listaImpedimentos/1.

carregaImpedimentos():-
    iniciaImpedimento(ListaImpedimentos),
    retract(listaImpedimentos(Lista)),
    append(Lista,ListaImpedimentos,NovaLista),
    assert(listaImpedimentos(NovaLista)).


carregaRecebedores():-
    iniciaRecebedores(ListaRecebedores),
    retract(listaRecebedores(Lista)),
    append(Lista,ListaRecebedores,NovaLista),
    assert(listaRecebedores(NovaLista)).


carregaEstoque():-
    iniciaEstoque(ListaEstoque),
    retract(listaEstoque(Lista)),
    append(Lista,ListaEstoque,NovaLista),
    assert(listaEstoque(NovaLista)).


%salva uma nova bolsa na lista de estoque
salvaEstoque(Bolsa):-
    retract(listaEstoque(Lista)),
    append(Lista,[Bolsa],NovaLista),
    assert(listaEstoque(NovaLista)).

%remove um certo numero de bolsas no estoque
removeEstoque(TipoSanguineo,Qtd):-
    retract(listaEstoque(Lista)),
    removeBolsa(TipoSanguineo,Lista,Qtd,NovaLista),
    assert(listaEstoque(NovaLista)).    


%cria a lista dinamica do estoque
listaEstoque([]).
:-dynamic listaEstoque/1.

%-------------------------------------------------------------------------------------

%HistoricoDoEstoque
historico(Estado):-
    %PegarQuantidadeDeSangue
    verificaEstoque(QtdSangue, Estado). 



%-------------------------------------------------------------------------------------


%salva a Agenda de doações
salvaAgenda(AgendaDia):-
    retract(listaAgenda(Lista)),
    removerAgenda(AgendaDia,Lista,ListaTemp),
    append(ListaTemp,[AgendaDia],NovaLista),
    assert(listaAgenda(NovaLista)).

%cria a lista dinamica de Agenda
listaAgenda([]).
:-dynamic listaAgenda/1.

%carrega a lista salva com a persistencia de arquivo
carregaAgenda():-
    iniciaAgenda(ListaAgenda),
    retract(listaAgenda(Lista)),
    append(Lista,ListaAgenda,NovaLista),
    assert(listaAgenda(NovaLista)).

%-------------------------------------------------------------------------------------

%verifica se o tipo sanguineo eh valido, se nao for, informa o usuario e volta ao menu 
%TODO ver se nao tem uma forma melhor de fazer isso! 
validaTipo(Tipo):- (member(Tipo,["O-","O+","A-","A+","B-","B+","AB-","AB+"]) -> true; write("Tipo invalido"), menu(99)).

/*%verifica se o data passada eh valido, se nao for, informa o usuario e volta ao menu 
%TODO ver se nao tem uma forma melhor de fazer isso! 
validaData(Data):- (get_time(Stamp), StampTotal is Stamp + (UltimoDia*86400), ())  -> true; write("Data invalida"), menu(99)).

getUltimoDiaImpedido(Impedimento, StampAtual, NovoStamp):- 
    getDiasImpedidos(Impedimento, UltimoDia),
    get_time(Stamp),
    StampTotal is Stamp + (UltimoDia*86400),
    (StampTotal > StampAtual -> NovoStamp = StampTotal; NovoStamp = StampAtual).


dataString(Stamp, Data):-
    stamp_date_time(Stamp, DataTempo, local),
    date_time_value(date, DataTempo, DataFinal),
    Data = DataFinal.




*/

salvarDados():-
    listaEnfermeiros(ListaEnfermeiros),
    listaImpedimentos(ListaImpedimentos),
    listaEstoque(ListaEstoque),
    listaRecebedores(ListaRecebedores),
    listaDoadores(ListaDoadores),
    listaEscala(ListaEscala),
    listaAgenda(ListaAgenda),
    salvaListaImpedimentos(ListaImpedimentos),
    salvaListaEnfermeiros(ListaEnfermeiros),
    salvaListaEstoque(ListaEstoque),
    salvaListaDoadores(ListaDoadores),
    salvaListaRecebedores(ListaRecebedores),
    salvaListaEscala(ListaEscala),
    salvaListaAgenda(ListaAgenda).