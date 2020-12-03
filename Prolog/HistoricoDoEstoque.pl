:- style_check(-singleton).
:- style_check(-discontiguous).

:- include('Persistencia.pl').

%Predicado que deve ser chamado no BloodLife que recebe a qtd de sangue atual do estoque e encontra o estado do estoque
verificaEstoque(QtdSangueHoje, Estado, AnoPassado):-
    get_time(Stamp),
    stamp_date_time(Stamp, DateTime, local),
    date_time_value(day, DateTime, Dia),
    date_time_value(month, DateTime, Mes),
    iniciaHistorico(ListaHistorico),  
    pegarHistorico(ListaHistorico, Dia, Mes, QtdMlAnoPassado),
    AnoPassado = QtdMlAnoPassado,
    (QtdMlAnoPassado = -1 -> Estado = "SEM HISTORICO DE ESTOQUE"
    ;getEstado(QtdMlAnoPassado, QtdSangueHoje, Estado)),
    HistoricoDia = [Dia, Mes, QtdSangueHoje],
    alteraHistorico(ListaHistorico, HistoricoDia, QtdMlAnoPassado, HistoricoAtual),
    salvaHistorico(HistoricoAtual). 


alteraHistorico(Historico, HistoricoDia, -1, HistoricoAtual):- append(Historico, [HistoricoDia], HistoricoAtual).
alteraHistorico(Historico, HistoricoDia,QtdMlAnoPassado,HistoricoAtual):-
    nth0(0, HistoricoDia, DiaAntigo),
    nth0(1, HistoricoDia, MesAntigo),
    pegaHistorico(Historico,DiaAntigo,MesAntigo,HistoricoAntigo),
    delete(Historico, HistoricoAntigo, ListaTemp), 
    append(ListaTemp, [HistoricoDia], HistoricoAtual).

pegaHistorico([H|T],Dia,Mes,DataAchada):-
    (nth0(0, H, DiaAntigo), atom_number(DiaAntigo, Dia),
    nth0(1, H, MesAntigo), atom_number(MesAntigo, Mes),
    DataAchada = H); pegaHistorico(T,Dia,Mes,DataAchada). 


getEstado(QtdMlAnoPassado, QtdSangueHoje, Estado):- atom_number(QtdMlAnoPassado, QtdMlAnoPassadoN),QtdMlAnoPassadoN = QtdSangueHoje, Estado = "ESTOQUE NA MEDIA", !.
getEstado(QtdMlAnoPassado, QtdSangueHoje, Estado):- atom_number(QtdMlAnoPassado, QtdMlAnoPassadoN),(QtdMlAnoPassadoN*0.50 >= QtdSangueHoje), Estado = "ESTOQUE EM ESTADO CRITICO. SOLICITAR DOACOES!", !.
getEstado(QtdMlAnoPassado, QtdSangueHoje, Estado):- atom_number(QtdMlAnoPassado, QtdMlAnoPassadoN),(QtdMlAnoPassadoN*0.90 >= QtdSangueHoje), Estado = "ESTOQUE ABAIXO DA MEDIA", !.
getEstado(QtdMlAnoPassado, QtdSangueHoje, Estado):- atom_number(QtdMlAnoPassado, QtdMlAnoPassadoN),(QtdMlAnoPassadoN*1.10 >= QtdSangueHoje), Estado = "ESTOQUE NA MEDIA", !.
getEstado(QtdMlAnoPassado, QtdSangueHoje, Estado):- atom_number(QtdMlAnoPassado, QtdMlAnoPassadoN),(QtdMlAnoPassadoN*1.50 >= QtdSangueHoje), Estado = "ESTOQUE ACIMA DA MEDIA", !.
getEstado(_,_,Estado):- Estado = "ESTOQUE EM OTIMAS CONDICOES", !.

pegarHistorico([],_,_, -1).
pegarHistorico([H|T], Dia, Mes, Historico):-
    nth0(0, H, DiaAntigo),
    nth0(1, H, MesAntigo),
    nth0(2, H, QtdMlAntigo),

    string_concat(DiaAntigo, MesAntigo, DataAntiga),
    string_concat(Dia, Mes, Data),

    (DataAntiga = Data -> Historico = QtdMlAntigo; pegarHistorico(T, Dia, Mes, Historico)).
