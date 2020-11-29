verificaEstoque(QtdSangueHoje, Estado):-

    get_time(Stamp),
    stamp_date_time(Stamp, DateTime, local),
    date_time_value(day, DateTime, Dia),
    date_time_value(month, DateTime, Mes),
    write(Dia), write(Mes),
    iniciaHistorico(Dia, Mes, QtdSangueHoje, QtdMlAnoPassado),
    atom_number(QtdMlAnoPassado,MlNumero),
    (MlNumero = -1 -> Estado = "SEM HISTORICO DE ESTOQUE"
    ;getEstado(MlNumero, QtdSangueHoje, Estado)). 

getEstado(QtdMlAnoPassado, QtdSangueHoje, Estado):- QtdMlAnoPassado = QtdSangueHoje, Estado = "ESTOQUE NA MEDIA", !.
getEstado(QtdMlAnoPassado, QtdSangueHoje, Estado):-(QtdMlAnoPassado * 0.50) >= QtdSangueHoje, Estado = "ESTOQUE EM ESTADO CRITICO. SOLICITAR DOACOES!", !.
getEstado(QtdMlAnoPassado, QtdSangueHoje, Estado):-(QtdMlAnoPassado * 0.90) >= QtdSangueHoje, Estado = "ESTOQUE ABAIXO DA MEDIA", !.
getEstado(QtdMlAnoPassado, QtdSangueHoje, Estado):-(QtdMlAnoPassado * 1.10) >= QtdSangueHoje, Estado = "ESTOQUE NA MEDIA", !.
getEstado(QtdMlAnoPassado, QtdSangueHoje, Estado):-(QtdMlAnoPassado * 1.50) >= QtdSangueHoje, Estado = "ESTOQUE ACIMA DA MEDIA", !.
getEstado(_,_,Estado):- Estado = "ESTOQUE EM OTIMAS CONDICOES", !.

iniciaHistorico(Dia, Mes, QtdMl, QtdMlAnoPassado):-
    open('dados/HistoricoEstoque.txt', read, StreamRead),
    read_file(StreamRead,HistoricoEstoqueStr),  
    close(StreamRead),
    open('dados/HistoricoEstoque.txt', write, StreamWrite),
    resgataHisorico(HistoricoEstoqueStr, Dia, Mes, QtdMl, QtdMlAnoPassado, StreamWrite),
    close(StreamWrite).
    
%Metodo que resgata e atualiza o valor do historico do estoque
resgataHisorico([], Dia, Mes, QtdMl, _, StreamWrite):- escreveHistorico(Dia, Mes, QtdMl, String), write(StreamWrite, String).
resgataHisorico([H|T], Dia, Mes, QtdMl, QtdMlAnoPassado, StreamWrite):-    
    nth0(0, H, DiaAntigo),
    nth0(1, H, MesAntigo),
    nth0(2, H, QtdMlAntigo),
    
    string_concat(DiaAntigo, MesAntigo, DataAntiga),
    string_concat(Dia, Mes, Data),
    
    (DataAntiga = Data ->(QtdMlAnoPassado = QtdMlAntigo); 
    (escreveHistorico(DiaAntigo, MesAntigo, QtdMlAntigo, String), write(StreamWrite, String))),
    resgataHisorico(T, Dia, Mes, QtdMl, QtdMlAnoPassado, StreamWrite),
    (var(QtdMlAnoPassado) -> QtdMlAnoPassado = -1; QtdMlAnoPassado = QtdMlAnoPassado).


escreveHistorico(Dia, Mes, QtdMl, Result):-
    string_concat(Dia,",", Parte1), string_concat(Parte1, Mes, Parte2), string_concat(Parte2, ",", Parte3), 
    string_concat(Parte3, QtdMl, Parte4), string_concat(Parte4, "\n", Result).

    /*leitura*/
   
read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_string(Stream, String),
    atomic_list_concat(X,",", String),
    read_file(Stream,L), !.


map(_,[],[]).

map(Predicado,[H|T],[NH|NT]):-
    call(Predicado, H, NH),
    map(Predicado,T,NT).
 
 
 