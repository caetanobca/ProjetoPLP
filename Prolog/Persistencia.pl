:- include("Enfermeiros.pl").
:- include("Impedimentos.pl").

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
 
 
 