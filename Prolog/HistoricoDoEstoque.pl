:- include('Persistencia.pl').
%Predicado que deve ser chamado no BloodLife que recebe a qtd de sangue atual do estoque e encontra o estado do estoque
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