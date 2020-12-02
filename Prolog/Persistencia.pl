:- include("Enfermeiros.pl").
:- include("Impedimentos.pl").
:- include("Doador.pl").
:- include("Estoque.pl").
:- include("Recebedores.pl").


/*Persistência de impedimento*/

%Salvar os impedimentos em um arquivo txt.
salvaListaImpedimentos(ListaImpedimentos):-
    open('dados/Impedimento.txt', write, Stream),
    escreveTodosImpedimentos(ListaImpedimentos, String),
    write(Stream, String),
    close(Stream).

escreveTodosImpedimentos([], Result):- Result = ''.
escreveTodosImpedimentos([Head|Tail], Result):- 
    escreveImpedimento(Head, ImpedimentoStr), escreveTodosImpedimentos(Tail, ResultNovo), 
    string_concat(ImpedimentoStr, "\n", Parte1),  string_concat(Parte1, ResultNovo, Result).

escreveImpedimento(medicamento(Funcao, Composto, TempoSuspencao), Result):- 
    string_concat(Funcao, ",", Parte1), string_concat(Parte1, Composto, Parte2), 
    string_concat(Parte2, ",", Parte3), string_concat(Parte3, TempoSuspencao, Result).
escreveImpedimento(doenca(Cid, TempoSuspencao), Result):- 
    string_concat(Cid, ",", Parte1), string_concat(Parte1, TempoSuspencao, Result).

iniciaImpedimento(ListaImpedimentos):-
    open('dados/Impedimento.txt', read, Stream),
    read_file(Stream,ListaImpedimentosStr), !,
    resgataImpedimento(ListaImpedimentosStr, ListaImpedimentos),   
    close(Stream).

resgataImpedimento([],_).
resgataImpedimento([H|T], Lista) :-
    length(H, 2) ->( nth0(0, H, Cid),
    nth0(1, H, TempoSuspencao),
    constroiDoenca(Cid, TempoSuspencao, Impedimento),
    resgataImpedimento(T, ListaNova),
    append([Impedimento], ListaNova, Lista)); 
    (nth0(0, H, Funcao),
    nth0(1, H, Composto),
    nth0(2, H, TempoSuspencao),
    constroiMedicamento(Funcao, Composto, TempoSuspencao, Impedimento),
    resgataImpedimento(T, ListaNova),
    append([Impedimento], ListaNova, Lista)).
    

/*Persistência de estoque*/

%Salvar Estoque em um txt.    
salvaListaEstoque(ListaEstoque):-
    open('dados/Estoque.txt', write, ArquivoEstoque),    
    escreveTodoEstoque(ListaEstoque,String),   
    write(ArquivoEstoque,String),
    close(ArquivoEstoque). 

escreveTodoEstoque([],String):- String = ''.
escreveTodoEstoque([H|T],String):-
    escreveBolsa(H,BolsaStr),    
    escreveTodoEstoque(T,StringProx),
    string_concat(BolsaStr,StringProx,String).

escreveBolsa(bolsa(TipoSanguineo,QtdSangue),Result):- 
    string_concat(TipoSanguineo, ",", Parte1),
    string_concat(Parte1,QtdSangue, Parte2), 
    string_concat(Parte2, "\n", Result).


iniciaEstoque(ListaEstoque) :-
    open('dados/Estoque.txt', read, Stream),
    read_file(Stream,ListaEstoqueStr),    
    resgataEstoque(ListaEstoqueStr, ListaEstoque),     
    close(Stream).    

resgataEstoque([],_).
resgataEstoque([H|T], Lista):-    
    nth0(0, H, TipoSanguineo),
    nth0(1, H, QtdSangue),
    constroiBolsa(TipoSanguineo,QtdSangue,Bolsa),
    resgataEstoque(T, ListaNova),
    append([Bolsa], ListaNova, Lista). 


/*Persistência de enfermeiros*/

%Salvar Enfermeiros em um txt.
salvaListaEnfermeiros(ListaEnfermeiros):-        
    open('dados/Enfermeiros.txt', write, ArquivoEnfermeiros),    
    escreveTodosEnfermeiros(ListaEnfermeiros,String),   
    write(ArquivoEnfermeiros,String),
    close(ArquivoEnfermeiros). 

escreveTodosEnfermeiros([],String):- String = ''.
escreveTodosEnfermeiros([H|T],String):-
    escreveEnfermeiro(H,EnfermeiroString),    
    escreveTodosEnfermeiros(T,StringProx),
    string_concat(EnfermeiroString,StringProx,String).


escreveEnfermeiro(enfermeiro(Nome,Endereco,Idade,Telefone),String):-
    string_concat(Nome, ",", Parte1), string_concat(Parte1, Endereco, Parte2),
    string_concat(Parte2, ",", Parte3),string_concat(Parte3, Idade, Parte4), string_concat(Parte4, ",", Parte5), 
    string_concat(Parte5, Telefone, Parte6), string_concat(Parte6, "\n", String).

iniciaEnfermeiros(ListaEnfermeiros) :-
    open('dados/Enfermeiros.txt', read, Stream),
    read_file(Stream,ListaEnfermeirosStr),    
    resgataEnfermeiro(ListaEnfermeirosStr, ListaEnfermeiros),     
    close(Stream).

resgataEnfermeiro([],_).
resgataEnfermeiro([H|T], Lista):-    
    nth0(0, H, Nome),
    nth0(1, H, Endereco),
    nth0(2, H, Idade),
    nth0(3, H, Telefone),
    constroiEnfermeiro(Nome,Endereco,Idade,Telefone,Enfermeiro),
    resgataEnfermeiro(T, ListaNova),
    append([Enfermeiro], ListaNova, Lista). 


/*Persistência de doador*/

%Salvar Doador em um txt.
salvaListaDoadores(ListaDoadores):-        
    open('dados/Doadores.txt', write, ArquivoDoadores),    
    escreveTodosDoadores(ListaDoadores,String),   
    write(ArquivoDoadores,String),
    close(ArquivoDoadores). 

escreveTodosDoadores([],String):- String = ''.
escreveTodosDoadores([H|T],String):-
    escreveDoador(H,DoadorString),    
    escreveTodosDoadores(T,StringProx),
    string_concat(DoadorString,StringProx,String).


escreveDoador(doador(Nome,Endereco,Idade,Telefone,TipSanguineo,ImpedimentoStr,UltimoDiaImpedido),String):-
    string_concat(Nome, ",", Parte1), 
    string_concat(Parte1, Endereco, Parte2),
    string_concat(Parte2, ",", Parte3),
    string_concat(Parte3, Idade, Parte4), 
    string_concat(Parte4, ",", Parte5), 
    string_concat(Parte5, Telefone, Parte6), 
    string_concat(Parte6, ",", Parte7), 
    string_concat(Parte7, TipSanguineo, Parte8), 
    string_concat(Parte8, ",", Parte9), 
    string_concat(Parte9, ImpedimentoStr, Parte10), 
    string_concat(Parte10, ",", Parte11),
    string_concat(Parte11, UltimoDiaImpedido, Parte12),
    string_concat(Parte12, "\n", String).

iniciaDoadores(ListaDoadores) :-
    open('dados/Doadores.txt', read, Stream),
    read_file(Stream,ListaDoadoresStr),    
    resgataDoador(ListaDoadoresStr, ListaDoadores),     
    close(Stream).

resgataDoador([],_).
resgataDoador([H|T], Lista):-    
    nth0(0, H, Nome),
    nth0(1, H, Endereco),
    nth0(2, H, Idade),
    nth0(3, H, Telefone),
    nth0(4, H, TipSanguineo),
    nth0(5, H, ImpedimentoStr),
    nth0(6, H, UltimoDiaImpedido),
    constroiDoador(Nome,Endereco,Idade,Telefone,TipSanguineo,ImpedimentoStr,UltimoDiaImpedido,Doador),
    resgataDoador(T, ListaNova),
    append([Doador], ListaNova, Lista). 

    /*Persistência de recebedor*/

%Salvar Recebedor em um txt.
salvaListaRecebedores(ListaRecebedores):-        
    open('dados/Recebedores.txt', write, ArquivoRecebedores),    
    escreveTodosRecebedores(ListaRecebedores,String),   
    write(ArquivoRecebedores,String),
    close(ArquivoRecebedores). 

escreveTodosRecebedores([],String):- String = ''.
escreveTodosRecebedores([H|T],String):-
    escreveRecebedor(H,RecebedorString),    
    escreveTodosRecebedores(T,StringProx),
    string_concat(RecebedorString,StringProx,String).


escreveRecebedor(recebedor(Nome,Idade,Endereco,NumDeBolsas,TipoSanguineo,Hospital), Result):-
    string_concat(Nome,",", Parte1), string_concat(Parte1, Idade, Parte2), string_concat(Parte2, ",", Parte3), 
    string_concat(Parte3, Endereco, Parte4), string_concat(Parte4, ",", Parte5), 
    string_concat(Parte5, NumDeBolsas, Parte6),string_concat(Parte6, ",", Parte7),
    string_concat(Parte7, TipoSanguineo, Parte8), string_concat(Parte8, ",", Parte9),
    string_concat(Parte9, Hospital, Parte10), string_concat(Parte10, "\n", Result).


iniciaRecebedores(ListaRecebedores):-
    open('dados/Recebedores.txt', read, Stream),
    read_file(Stream,ListaRecebedoresStr),    
    resgataRecebedor(ListaRecebedoresStr, ListaRecebedores),     
    close(Stream).

resgataRecebedor([],_).
resgataRecebedor([H|T], Lista):-    
    nth0(0, H, Nome),
    nth0(1, H, Idade),
    nth0(2, H, Endereco),
    nth0(3, H, NumDeBolsas),
    nth0(4, H, TipoSanguineo),
    nth0(5, H, Hospital),
    constroiRecebedor(Nome,Idade,Endereco,NumDeBolsas,TipoSanguineo,Hospital, Recebedor),
    resgataRecebedor(T, ListaNova),
    append([Recebedor], ListaNova, Lista). 

/*Persistência de estoque*/

%Metodo que inicializa o historico de estoque
iniciaHistorico(HistoricoEstoque):-
    open('dados/HistoricoEstoque.txt', read, StreamRead),    
    read_file(StreamRead,HistoricoEstoqueStr), !,   
    resgataHistorico(HistoricoEstoqueStr, HistoricoEstoque), 
    close(StreamRead).

resgataHistorico([],[]).
resgataHistorico([H|T],Lista):-
    nth0(0,H,Dia),nth0(1,H,Mes),nth0(2,H,Estoque),
    resgataHistorico(T,ListaNova),
    EstoqueData = [Dia,Mes,Estoque],
    append([EstoqueData],ListaNova,Lista).

salvaHistorico(HistoricoEstoque):-
    open('dados/HistoricoEstoque.txt', write, StreamWrite),   
    escreveTodosHistoricos(HistoricoEstoque, String),  
    write(StreamWrite, String),    
    close(StreamWrite).

escreveTodosHistoricos([],String):- String = ''.
escreveTodosHistoricos([H|T],String):-
    escreveHistorico(H,HistoricoString),
    escreveTodosHistoricos(T,StringProx),
    string_concat(HistoricoString,StringProx,String).


%constroi a string do historico do estoque de uma forma simples para salvar no txt
escreveHistorico(Historico, Result):-
    nth0(0, Historico, Dia),
    nth0(1, Historico, Mes),
    nth0(2, Historico, QtdMl),
    string_concat(Dia,",", Parte1), string_concat(Parte1, Mes, Parte2), string_concat(Parte2, ",", Parte3), 
    string_concat(Parte3, QtdMl, Parte4), string_concat(Parte4, "\n", Result).

salvaListaEscala(ListaEscala):-
    open('dados/Escala.txt',write,Stream),
    escreveTodasEscalas(ListaEscala,String),
    write(Stream,String),
    close(Stream).

escreveTodasEscalas([],Result):- Result = ''.
escreveTodasEscalas([Head|Tail],Result):-
    escreveEscala(Head,String),
    escreveTodasEscalas(Tail,ResultNovo),    
    string_concat(String,ResultNovo,Result).

escreveEscala(Escala,String):-
    nth0(0,Escala,Data),nth0(1,Escala,Enfermeiros),
    string_concat(Data,",",Parte1), string_concat(Parte1,Enfermeiros,Parte2), 
    string_concat(Parte2, "\n", String).

iniciaEscala(ListaEscala):-
    open('dados/Escala.txt',read,Stream),
    read_file(Stream,ListaEscalaStr),
    resgataEscala(ListaEscalaStr,ListaEscala),    
    close(Stream).

resgataEscala([],_).
resgataEscala([H|T],Lista):-
    nth0(0,H,Data),
    nth0(1,H,Enfermeiros),
    resgataEscala(T,ListaNova),
    DataEnfermeiros = [Data,Enfermeiros],
    append([DataEnfermeiros],ListaNova,Lista).


salvaListaAgenda(ListaAgenda):-
    open('dados/AgendaLocal.txt',write,Stream),
    escreveTodosAgendamentos(ListaAgenda,String),
    write(Stream,String),
    close(Stream).

escreveTodosAgendamentos([],Result):- Result = ''.
escreveTodosAgendamentos([Head|Tail],Result):-
    escreveAgenda(Head,String),
    escreveTodosAgendamentos(Tail,ResultNovo),
    string_concat(String,ResultNovo,Result).

escreveAgenda(Agenda,String):-
    nth0(0,Agenda,Data),nth0(1,Agenda,Doadores),
    string_concat(Data,",",Parte1), string_concat(Parte1,Doadores,Parte2), 
    string_concat(Parte2, "\n", String).


iniciaAgenda(ListaAgenda):-
    open('dados/AgendaLocal.txt',read,Stream),
    read_file(Stream,ListaAgendaStr),
    resgataAgenda(ListaAgendaStr,ListaAgenda),
    close(Stream).


resgataAgenda([],_).
resgataAgenda([H|T],Lista):-
    nth0(0,H,Data),
    nth0(1,H,Doadores),
    resgataAgenda(T,ListaNova),
    DataDoadores = [Data,Doadores],
    append([DataDoadores],ListaNova,Lista).

    /*leitura*/
   
read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_string(Stream, String),
    atomic_list_concat(X,",", String),
    read_file(Stream,L),!.


map(_,[],[]).

map(Predicado,[H|T],[NH|NT]):-
    call(Predicado, H, NH),
    map(Predicado,T,NT).