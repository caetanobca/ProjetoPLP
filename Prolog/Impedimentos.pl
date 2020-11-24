%Cria um termo composto do tipo doenca ou medicamento, que representa um impedimento
constroiDoenca(Cid, TempoSuspencao, doenca(Cid, TempoSuspencao)).
constroiMedicamento(Funcao, Composto, TempoSuspencao, medicamento(Funcao, Composto, TempoSuspencao)).

%Retorna o Id do impedimento, caso seja uma doenca o id eh o cid e caso seja um medicamento o id eh o composto
getImpedimentoId(doenca(Cid,_), Cid).
getImpedimentoId(medicamento(_,Composto,_), Composto).

%Retorna os valores dos impedimentos
getTempoSuspencao(doenca(_,TempoSuspencao), TempoSuspencao).
getTempoSuspencao(medicamento(_,_,TempoSuspencao), TempoSuspencao).
getFuncao(medicamento(Funcao,_,_), Funcao).

%Retorna a qtd de dias que determinado impedimento deixa um doador impossibilitado de doar
getDiasImpedidos(doenca(_,TempoSuspencao), TempoSuspencao).
getDiasImpedidos(medicamento(_,_,TempoSuspencao), TempoSuspencao).

%Busca um impedimento e caso nao ache retorna a string "Nao encontrado"
buscaImpedimento(IdImpedimento,[], Result):- Result = "Não encontrado".
buscaImpedimento(IdImpedimento, [Head|Tail], Result):- getImpedimentoId(Head, Id), string_upper(Id, IdUpper), string_upper(IdImpedimento, IdImpedimentoUpper), 
                    (IdUpper = IdImpedimentoUpper -> Result = Head; buscaImpedimento(IdImpedimento, Tail, Result)).  


%Lista todos os impedimentos cadastrados no sistema
listarImpedimentos([]):- nl.
listarImpedimentos([Head|Tail]):- impedimentoToString(Head, ImpedimentoStr), write(ImpedimentoStr), nl, listarImpedimentos(Tail).


%Retorna uma lista sem um determinado impedimento que estava cadastrasdo
removerImpedimento(IdImpedimento, Lista, Result):- buscaImpedimento(IdImpedimento, Lista, Impedimento), delete(Lista, Impedimento, Result).

%Verifica se um impedimento foi cadastrado
existeImpedimento(IdImpedimento, Lista):- buscaImpedimento(IdImpedimento, Lista, BuscaDeImpedimento), \+(BuscaDeImpedimento = "Não encontrado").

/*Gera a representação textual de um Impedimento*/
impedimentoToString(doenca(Cid, TempoSuspencao), Result):- string_concat("Doença \n   >Cid: ", Cid, Parte1), 
                    string_concat(Parte1, "\n   >Tempo de Suspenção: ", Parte2), string_concat(Parte2, TempoSuspencao, Parte3),
                    string_concat(Parte3, " dia(s)\n", Result).
impedimentoToString(medicamento(Funcao, Composto, TempoSuspencao), Result):- string_concat("Medicamento\n   >Função: ", Funcao, Parte1), 
                    string_concat(Parte1, "\n   >Composto: ", Parte2), string_concat(Parte2, Composto, Parte3), string_concat(Parte3, "\n   >Tempo de Suspenção: ", Parte4), 
                    string_concat(Parte4, TempoSuspencao, Parte5), string_concat(Parte5, " dia(s)\n", Result).

/*Gera uma representação textual simples e em uma linha*/
impedimentoToStringSimples(doenca(Cid, TempoSuspencao), Result):- string_concat("Doença >Cid: ", Cid, Parte1), 
                string_concat(Parte1, " >Tempo de Suspenção: ", Parte2), string_concat(Parte2, TempoSuspencao, Parte3),
                string_concat(Parte3, " dia(s)", Result).
impedimentoToStringSimples(medicamento(Funcao, Composto, TempoSuspencao), Result):- string_concat("Medicamento: >Função: ", Funcao, Parte1), 
                string_concat(Parte1, " >Composto: ", Parte2), string_concat(Parte2, Composto, Parte3), string_concat(Parte3, " >Tempo de Suspenção: ", Parte4), 
                string_concat(Parte4, TempoSuspencao, Parte5), string_concat(Parte5, " dia(s)", Result).

%Gera uma representação textual dos impedimentos que sera usada para a persistencia de dados
impedimentoSalvaLista([], Result):- Result = ''. 
impedimentoSalvaLista([Head|Tail], Result):- impedimentoSalva(Head, ImpedimentoStr), impedimentoSalvaLista(Tail, ResultNovo), append(ImpedimentoStr, ResultNovo, Result).

impedimentoSalva(doenca(Cid, TempoSuspencao), Result):- string_concat(Cid, ' ', Parte1), string_concat(Parte1, TempoSuspencao, Result).
impedimentoSalva(medicamento(Funcao, Composto, TempoSuspencao), Result):- string_concat(Funcao, ' ', Parte1), string_concat(Parte1, Composto, Parte2), 
                string_concat(Parte2, ' ', Parte3), string_concat(Parte3, TempoSuspencao, Result).



/*Retorna o tipo date, com as informações do dia gerado pela soma de dias o impedimento com a data de hoje*/
getUltimoDiaImpedido(Impedimento, Data):- getDiasImpedidos(Impedimento, UltimoDia),
                    get_time(Stamp),
                    StampFinal is Stamp + (UltimoDia*86400),
                    stamp_date_time(StampFinal, DateTime, local),
                    date_time_value(date, DateTime, DataFinal),
                    Data = DataFinal.

