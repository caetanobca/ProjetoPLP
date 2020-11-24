

%Salvar os impedimentos em um arquivo txt.
cadastrarImpedimento([]).
cadastrarImpedimento([Head|Tail]):-
    open('dados/Impedimento.txt', append, Stream),
    impedimentoSalva(Head, ImpedimentoStr), 
    write(Stream, ImpedimentoStr), nl(Stream),
    close(Stream),
    cadastrarImpedimento(Tail).

impedimentoSalva(doenca(Cid, TempoSuspencao), Result):- string_concat(Cid, ' ', Parte1), string_concat(Parte1, TempoSuspencao, Result).
impedimentoSalva(medicamento(Funcao, Composto, TempoSuspencao), Result):- string_concat(Funcao, ' ', Parte1), string_concat(Parte1, Composto, Parte2), 
                string_concat(Parte2, ' ', Parte3), string_concat(Parte3, TempoSuspencao, Result).

/*cadastrarImpedimento(Impedimentos) :-
    open('dados/Impedimento.txt', append, Stream),
    impedimentoSalvaLista(Impedimentos, String),
    write("opa"),
    write(Stream, "oi meu nome é Caetano"),  nl(Stream),
    close(Stream).*/

iniciaImpedimento(Impedimento) :-
    open('Impedimento.txt', read, Stream),
    read_file(Stream,Impedimentos),
    write(Impedimentos),
    close(Stream).

read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_string(Stream, String),
    atomic_list_concat(X,' ', String),
    read_file(Stream,L), !.