:- include('Enfermeiros.pl').
:- include('Recebedores.pl')
:- include('Impedimentos.pl').
:- include('Doador.pl').
:- initialization(main).

menuEnfermeiro(99):-
    tty_clear,
    write("Menu Enfermeiros"),nl,
    write("1. Cadastro de Enfermeiros"), nl,
    write("2. Buscar Enfermeiros"), nl,
    write("3. Listagem de Enfermeiros"), nl,
    write("5. Adicionar escala de Enfermeiros"), nl,
    write("6. Visualizar escala de Enfermeiros"), nl,
    lerNumero(Numero),
    menuEnfermeiro(Numero).
    %menu(99).

menuEnfermeiro(1):-
    listaEnfermeiros(ListaEnfermeiros),    
    write("Você irá cadastrar um Enfermeiro(a): "),
    nl,
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
    write("Enfermeiro(a) cadastrad(a)"),
    menu(99).

menuEnfermeiro(2):-
    listaEnfermeiros(ListaEnfermeiros),
    write("Insira o nome do(a) Enfermeiro(a) que você deseja"),
    lerString(Nome),
    buscaEnfermeiro(Nome,ListaEnfermeiros,Enfermeiro),
    write(Enfermeiro),    
    menu(99).

menuEnfermeiro(3):-
    listaEnfermeiros(ListaEnfermeiros),
    listarEnfermeiros(ListaEnfermeiros),
    lerString(A),
    menu(99).

menuEnfermeiro(4):-
    listaEnfermeiros(ListaEnfermeiros),
    write("Adicionar escala de Enfermeiros"),
    menu(99).

menuEnfermeiro(5):-
    listaEnfermeiros(ListaEnfermeiros),
    write("Visualizar escala de Enfermeiros"),
    menu(99).

menuEnfermeiro(N):-
    tty_clear,    
    write("Opção Inválida"),
    nl,
    menuEnfermeiro(99).

/*-----------------------------------------------------------------*/
menuRecebedor(99):-
    tty_clear,
    write("Menu Recebedores"),nl,
    write("1. Cadastro de Recebedores"), nl,
    write("2. Buscar Recebedores"), nl,
    write("3. Listar Recebedores"), nl,
    lerNumero(Numero),
    menuRecebedor(Numero).
    %menu(99).

menuRecebedor(1):-
    listaRecebedores(ListaRecebedores),    
    write("Você irá cadastrar um Recebedor(a): "),
    nl,
    write("Insira o nome do Recebedor(a): "),
    lerString(Nome),
    write("Insira o endereço do Recebedor(a): "),
    lerString(Endereco),
    write("Insira a idade do Recebedor(a): "),
    lerString(Idade),
    write("Insira o telefone do Recebedor(a): "),
    lerString(Telefone),
    write("Insira o Numero de Bolsas de Sangue requisitadas pelo Recebedor(a): "),
    lerString(Telefone),
    write("Insira a ficha médica do Recebedor(a): "),
    lerString(Telefone),
    constroiRecebedor(Nome,Endereco,Idade,Telefone,NumDeBolsas,FichaMedica,Recebedor),
    salvaRecebedor(Recebedor),
    write("Recebedor(a) cadastrado(a)"),
    menu(99).

menuRecebedor(2):-
    listaRecebedors(ListaRecebedores),
    write("Insira o nome do(a) Recebedor(a) que você deseja procurar"),
    lerString(Nome),
    buscaRecebedor(Nome,ListaRecebedors,Recebedor),
    write(Recebedor),    
    menu(99).

menuRecebedor(3):-
    listaRecebedores(ListaRecebedores),
    listarRecebedores(ListaRecebedores),
    lerString(A),
    menu(99).

/*
menuRecebedor(4):-
    listaRecebedores(ListaRecebedors),
    write("Adicionar escala de Recebedors"),
    menu(99).
*/

menuRecebedor(N):-
    tty_clear,    
    write("Opção Inválida"),
    nl,
    menuRecebedor(99).

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

%Menu de impedimetno para buscar impedimento
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
    lerString(Wait), 
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
    write("Opção Inválida"), nl, nl,
    write("Pressione enter para continuar"), nl,
    lerString(Wait), 
    menuImpedimento(99).


menuDoador(99):-
    tty_clear,
    write("Menu Doador"),nl,
    write("1. Cadastro de Doadores"), nl,
    write("2. Buscar Doadores"), nl,
    write("3. Listagem de Doadores"), nl,
    write("4. Mostrar ficha tecnica do Doador(a)"), nl,
    write("5. Mostrar historico de doação do Doador(a)"), nl,
    lerNumero(Numero),
    menuDoador(Numero).
    %menu(99).

menuDoador(1):-
    listaDoadores(ListaDoadores),    
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
    write("Insira o Impedimento do Doador(a): "),
    lerString(ImpedimentoStr),
    write("Insira o telefone do Doador(a): "),
    lerString(Telefone),
    write("Insira o telefone do Doador(a): "),
    lerString(Telefone),
    constroiDoador(Nome,Endereco,Idade,Telefone,TipSanguineo,ImpedimentoStr,UltimoDiaImpedido,Doacoes,Doador),
    salvaDoador(Doador),
    write("Doador(a) cadastrad(a)"),
    menu(99).

menuDoador(2):-
    listaDoadores(ListaDoadores),
    write("Insira o nome do(a) Doador(a) que você deseja"),
    lerString(Nome),
    buscaDoador(Nome,ListaDoadores,Doador),
    write(Doador),    
    menu(99).

menuDoador(3):-
    listaDoadores(ListaDoadores),
    listarDoadores(ListaDoadores),
    lerString(A),
    menu(99).

menuDoador(4):-
    listaDoadores(ListaDoadores),
    write("Insira o nome do(a) Doador(a) que você deseja ver a ficha medica"),
    lerString(Nome),
    buscaDoador(Nome,ListaDoadores,Doador),
    getDoadorImpedimentoStr(Doador, ImpedimentoStr),
    write(ImpedimentoStr),
    menu(99).

menuDoador(5):-
    listaDoadores(ListaDoadores),
    write("Insira o nome do(a) Doador(a) que você deseja ver o historico de doeções"),
    lerString(Nome),
    buscaDoador(Nome,ListaDoadores,Doador),
    getDoadorDoacoes(Doador, Doacoes),
    write(Doacoes),
    menu(99).

menuDoador(N):-
    tty_clear,    
    write("Opção Inválida"),
    nl,
    menuDoador(99).


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
    write("Opção Inválida"),
    nl,
    menuImpedimento(99).

%Main
main:-
    letreiroInicial,
    lerString(A),  
    menu(99),
    halt.

%Menu(1) Invoca o Controle de Recebedores
menu(1):- 
    tty_clear,
    write("Controle de Recebedores"),
    nl,   
    menu(99).

%Menu(2) Invoca o Controle de Estoque de Bolsas de Sangue
menu(2):-    
    tty_clear,
    write("Controle de Estoque de Bolsas de Sangue"),
    nl,
    menu(99).

%Menu(3) Invoca o Controle de Doadores  
menu(3):-
    tty_clear,
    write("Controle de Doadores"),
    nl,    
    menu(99).

%Menu(4) Invoca o Controle de Enfermeiros
menu(4):-
    tty_clear,    
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
    write("Agendar Coleta de sangue"),
    nl,
    menu(99).

%Menu(7) Invoca o Dashboard
menu(7):-
    tty_clear,
    write("Dashboard"),    
    lerString(A),
    nl,
    menu(99).

%Menu(8) Encerra o programa
menu(8):-
    tty_clear,
    write("Encerrando."),
    halt.

%Menu(99) Menu Inicial
menu(99):-
    tty_clear,
    nl,        
    write("Escolha a opção:"), nl,
    write("1. Controle de Recebedores"), nl,
    write("2. Controle de Estoque de Bolsas de Sangue"), nl,
    write("3. Controle de Doadores"), nl,
    write("4. Controle de Enfermeiros"), nl,
    write("5. Controle de Impedimentos"), nl,
    write("6. Agendar Coleta de sangue"), nl,
    write("7. Dashboard"), nl,    
    write("8. Sair"),nl,
    lerNumero(Numero),
    menu(Numero).

%Menu(N) Quando o usuario passa uma entrada invalida, chama novamente o menu inicial 
menu(N):-
    tty_clear,    
    write("Opção Inválida"),
    nl,
    menu(99).
    
% Le uma String e converte em atomo  
lerString(X):- read_line_to_codes(user_input, E), atom_string(E,X).

% Le um numero e converte em atomo 
lerNumero(Numero):- read_line_to_codes(user_input, E), atom_string(E,X), atom_number(X,Numero).

%Exibe o letreiro inicial
letreiroInicial:-
    tty_clear,
    write(
"   _                       _   
   |_) |  _   _   _| |  o _|_ _ 
   |_) | (_) (_) (_| |_ |  | (/_"  ).


%salva um enfermeiro na nova lista de enfermeiros
salvaEnfermeiro(Enfermeiro):-
    retract(listaEnfermeiros(Lista)),
    append(Lista,[Enfermeiro],NovaLista),
    assert(listaEnfermeiros(NovaLista)).

%remove um enfermeiro e faz a nova lista sem o enfermeiro que foi removido
removeEnfermeiro(Enfermeiro):-
    retract(listaEnfermeiros(Lista)),
    removerEnfermeiro(Lista,Enfermeiro,NovaLista),
    assert(listaEnfermeiros(NovaLista)).

%cria a lista dinamica de enfermeiro
listaEnfermeiros([]).
:-dynamic listaEnfermeiros/1.


/*-----------------------------------------------------------------*/
%salva um recebedor na nova lista de recebedores
salvaRecebedor(Recebedor):-
    retract(listaRecebedores(Lista)),
    append(Lista,[Recebedor],NovaLista),
    assert(listaRecebedores(NovaLista)).

%remove um recebedor e faz a nova lista sem o recebedor que foi removido
removeRecebedor(Recebedor):-
    retract(listaRecebedores(Lista)),
    removerRecebedor(Lista,Recebedor,NovaLista),
    assert(listaRecebedores(NovaLista)).

%cria a lista dinamica de recebedor
listaRecebedors([]).
:-dynamic listaRecebedores/1.
/*-----------------------------------------------------------------*/

%salva um impedimento na nova lista de impedimentos
salvaImpedimento(Impedimento):-
    retract(listaImpedimentos(Lista)),
    append(Lista,[Impedimento],NovaLista),
    assert(listaImpedimentos(NovaLista)).

%remove um impedimento e faz a nova lista sem o impedimento que foi removido
removeImpedimento(Impedimento):-
    retract(listaImpedimentos(Lista)),
    removerImpedimento(Lista,Impedimento,NovaLista),
    assert(listaImpedimentos(NovaLista)).

%cria a lista dinamica de impedimentos
listaImpedimentos([]).
:-dynamic listaImpedimentos/1.

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