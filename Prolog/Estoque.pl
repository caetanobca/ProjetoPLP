constroiBolsa(TipoSanguineo,QtdSangue,bolsa(TipoSanguineo,QtdSangue)).

%retorna os dados da bolsa
getBolsaTipo(bolsa(TipoSanguineo,_), TipoSanguineo).
getBolsaQtdSangue(bolsa(_,QtdSangue), QtdSangue).

%retorna uma visao geral do estoque
listaVisaoGeralEstoque(_,8):-nl.
listaVisaoGeralEstoque(ListaBolsas, Index):-
                    tipos(Tipos),
                    nth0(Index,Tipos,Tipo),
                    buscaBolsasPorTipo(Tipo,ListaBolsas,0,QtdSomada),
                    bolsasToMl(QtdSomada,QtdSomadaMl),
                    atom_number(QtdSomadaAtom, QtdSomadaMl),
                    bolsaToString(Tipo,QtdSomadaAtom,EstoqueStr), 
                    write(EstoqueStr),
                    nl, 
                    succ(Index,NewIndex),
                    listaVisaoGeralEstoque(ListaBolsas, NewIndex).

%retorna uma representacao visual das bolsas de determinado tipo
bolsaToString(TipoSanguineo,QtdSangue,Result):- string_concat(TipoSanguineo, ": ", Parte1),
                    string_concat(Parte1,QtdSangue, Parte2), 
                    string_concat(Parte2, " ml", Result).

%busca a quantidade de bolsas por tipo
buscaBolsasPorTipo(_,[],QtdAteEntao,QtdSomada):-QtdSomada is QtdAteEntao.
buscaBolsasPorTipo(TipoProcurado,[H|T],QtdAteEntao, QtdSomada):- 
                    getBolsaTipo(H,TipoSanguineo), 
                    string_upper(TipoSanguineo, TipoSanguineoUpper), 
                    string_upper(TipoProcurado, TipoProcuradoUpper),
                    (TipoSanguineoUpper = TipoProcuradoUpper -> succ(QtdAteEntao,NewQtdBolsas), buscaBolsasPorTipo(TipoProcurado,T,NewQtdBolsas, QtdSomada); buscaBolsasPorTipo(TipoProcurado,T, QtdAteEntao, QtdSomada)).

%verifica se ha bolsas suficientes para retirada
verificaQtdBolsas([],_,_):- false.
verificaQtdBolsas(_,0,_).
verificaQtdBolsas([H|T],QtdNecessaria, TipoProcurado):-
                    getBolsaTipo(H,TipoSanguineo), 
                    string_upper(TipoSanguineo, TipoSanguineoUpper), 
                    (TipoSanguineoUpper = TipoProcurado -> AttQtd is QtdNecessaria - 1, verificaQtdBolsas(T,AttQtd, TipoProcurado); verificaQtdBolsas(T,QtdNecessaria, TipoProcuradoUpper)).


%retorna os tipos validos
tipos(["O-","O+","A-","A+","B-","B+","AB-","AB+"]).

%multiplica a quantidade de bolsas pelo volume padrao (450 ml)
bolsasToMl(QtdSomada,QtdSomadaMl):- QtdSomadaMl is QtdSomada*450.

%remove uma (ou algumas) bolsa(s) do estoque de determinado tipo
removeBolsa(_,Lista,0,Result):- clone(List,Result).
removeBolsa(TipoProcurado,[Head|Tail],QtdBolsas,Result):- 
                getBolsaTipo(Head,TipoSanguineo), 
                (TipoSanguineoUpper = TipoProcuradoUpper -> delete_one(Lista, Bolsa, NovaLista), 
                NewQtd is QtdBolsas-1, removeBolsa(TipoProcurado,NovaLista,NewQtd, Result);
                removeBolsa(TipoProcurado,Tail,QtdBolsas,Result)).


%remove apenas o primeiro elemento igual encontrado
delete_one(X,[X|T],T):-!.
delete_one(X,[Y|T],[Y|T1]):-delete_one(X,T,T1).

%copia a lista
clone([],[]).
clone([H|T],[H|Z]):- clone(T,Z).