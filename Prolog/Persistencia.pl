:- include("Enfermeiros.pl").
:- include("Impedimentos.pl").
:- include("Doador.pl").

%Salvar os impedimentos em um arquivo txt.
salvaListaImpedimentos(ListaImpedimentos):-
    open('dados/Impedimento.txt', write, Stream),
    escreveTodosImpedimentos(ListaImpedimentos, String),
    write(String), 
    write(Stream, String),
    close(Stream).

escreveTodosImpedimentos([], Result):- Result = ''.
escreveTodosImpedimentos([Head|Tail], Result):- 
    escreveImpedimento(Head, ImpedimentoStr), escreveTodosImpedimentos(Tail, ResultNovo), 
    string_concat(ImpedimentoStr, '\n', Parte1),  string_concat(Parte1, ResultNovo, Result).

escreveImpedimento(medicamento(Funcao, Composto, TempoSuspencao), Result):- 
    string_concat(Funcao, ',', Parte1), string_concat(Parte1, Composto, Parte2), 
    string_concat(Parte2, ',', Parte3), string_concat(Parte3, TempoSuspencao, Result).
escreveImpedimento(doenca(Cid, TempoSuspencao), Result):- 
    string_concat(Cid, ',', Parte1), string_concat(Parte1, TempoSuspencao, Result).

iniciaImpedimento(ListaImpedimentos):-
    open('dados/Impedimento.txt', read, Stream),
    read_file(Stream,ListaImpedimentosStr),
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


%Salvar Enfermeiros em um txt.
salvaListaEnfermeiros(ListaEnfermeiros):-        
    open('dados/Enfermeiros.txt', write, ArquivoEnfermeiros),    
    escreveTodosEnfermeiros(ListaEnfermeiros,String),   
    write(String),
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


%Salvar Doador em um txt.
salvaListaDoadores(ListaDoadores):-        
    open('dados/Doadores.txt', write, ArquivoDoadores),    
    escreveTodosDoadores(ListaDoadores,String),   
    write(String),
    write(ArquivoDoadores,String),
    close(ArquivoDoadores). 

escreveTodosDoadores([],String):- String = ''.
escreveTodosDoadores([H|T],String):-
    escreveDoador(H,DoadorString),    
    escreveTodosDoadores(T,StringProx),
    string_concat(DoadorString,StringProx,String).


escreveDoador(doador(Nome,Endereco,Idade,Telefone,TipSanguineo,ImpedimentoStr,UltimoDiaImpedido,Doacoes),String):-
    string_concat(Nome, ",", Parte1), string_concat(Parte1, Endereco, Parte2),
    string_concat(Parte2, ",", Parte3),string_concat(Parte3, Idade, Parte4), string_concat(Parte4, ",", Parte5), 
    string_concat(Parte5, Telefone, Parte6), string_concat(Parte6, ",", Parte7), string_concat(Parte7, TipSanguineo, Parte8), 
    string_concat(Parte8, ",", Parte9), string_concat(Parte9, ImpedimentoStr, Parte10), string_concat(Parte10, ",", Parte11),
    string_concat(Parte11, UltimoDiaImpedido, Parte12), string_concat(Parte12, ",", Parte13), string_concat(Parte13, Doacoes, Parte14),
    string_concat(Parte14, ",", Parte15), string_concat(Parte15, "\n", String).

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
    nth0(7, H, Doacoes),
    constroiDoador(Nome,Endereco,Idade,Telefone,TipSanguineo,ImpedimentoStr,UltimoDiaImpedido,Doacoes,doador(Nome,Endereco,Idade,Telefone,TipSanguineo,ImpedimentoStr,UltimoDiaImpedido,Doacoes)),
    resgataDoador(T, ListaNova),
    append([Doador], ListaNova, Lista). 
   
read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_string(Stream, String),
    atomic_list_concat(X,",", String),
    read_file(Stream,L), !.


map(_,[],[]).

map(Predicado,[H|T],[NH|NT]):-
    %Function=..[FunctionName,H,NH],
    call(Predicado, H, NH),
    map(Predicado,T,NT).
 
 
 