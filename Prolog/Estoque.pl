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

%calcula a quantidade de bolsas por tipo (QtdSomada em num de bolsas)
buscaBolsasPorTipo(_,[],QtdAteEntao,QtdSomada):-QtdSomada is QtdAteEntao.
buscaBolsasPorTipo(TipoProcurado,[H|T],QtdAteEntao, QtdSomada):- 
                    getBolsaTipo(H,TipoSanguineo), 
                    string_upper(TipoSanguineo, TipoSanguineoUpper), 
                    string_upper(TipoProcurado, TipoProcuradoUpper),
                    (TipoSanguineoUpper = TipoProcuradoUpper -> succ(QtdAteEntao,NewQtdBolsas), buscaBolsasPorTipo(TipoProcurado,T,NewQtdBolsas, QtdSomada); buscaBolsasPorTipo(TipoProcurado,T, QtdAteEntao, QtdSomada)).

%verifica se ha bolsas suficientes para retirada
verificaQtdBolsas([],X,_,Result):-dif(X,0),Result is -1.
verificaQtdBolsas(_,0,_,Result):-Result is 1.
verificaQtdBolsas([H|T],QtdNecessaria,TipoProcurado,Result):-
                    getBolsaTipo(H,TipoSanguineo), 
                    string_upper(TipoSanguineo, TipoSanguineoUpper), 
                    string_upper(TipoProcurado, TipoProcuradoUpper),
                    (TipoSanguineoUpper = TipoProcuradoUpper -> NewQtd is QtdNecessaria - 1, 
                    verificaQtdBolsas(T,NewQtd,TipoProcurado,Result);
                    verificaQtdBolsas(T,QtdNecessaria,TipoProcurado,Result)).


%retorna os tipos validos
tipos(["O-","O+","A-","A+","B-","B+","AB-","AB+"]).

%multiplica a quantidade de bolsas pelo volume padrao (450 ml)
bolsasToMl(QtdSomada,QtdSomadaMl):- QtdSomadaMl is QtdSomada*450.



removeBolsa(TipoProcurado, Lista,1, Result):- 
                  buscaBolsa(TipoProcurado, Lista, Bolsa), 
                  delete_one(Bolsa,Lista, Result).
removeBolsa(TipoProcurado, Lista,Qtd, Result):- 
                  buscaBolsa(TipoProcurado, Lista, Bolsa), 
                  delete_one(Bolsa,Lista, NewLista),
                  NewQtd is Qtd-1, 
                  nl,
                  removeBolsa(TipoProcurado,NewLista,NewQtd,Result).


%Busca a primeira bolsa equivalente na lista TODO cuidado com esse false Result is False
buscaBolsa(_,[], _).
buscaBolsa(TipoProcurado, [Head|Tail], Result):- getBolsaTipo(Head, Tipo), 
                    string_upper(Tipo, TipoSanguineoUpper), 
                    string_upper(TipoProcurado, TipoProcuradoUpper), 
                    (TipoSanguineoUpper = TipoProcuradoUpper -> Result = Head; buscaBolsa(TipoProcurado, Tail, Result)).  


%deleta somenta a primeira ocorrrencia do elemento na lista
delete_one(_, [], []).
delete_one(Term, [Term|Tail], Tail).
delete_one(Term, [Head|Tail], [Head|Result]) :-
  delete_one(Term, Tail, Result).


%retorna a quantidade total de ml do estoque
qtdMlTotal(_,8,0).
qtdMlTotal(ListaBolsas, Index, Total):-
  tipos(Tipos),
  nth0(Index,Tipos,Tipo),
  buscaBolsasPorTipo(Tipo,ListaBolsas,0,QtdSomada),
  bolsasToMl(QtdSomada,QtdSomadaMl),
  succ(Index,NewIndex),
  qtdMlTotal(ListaBolsas, NewIndex, QtdProx),
  Total is QtdProx + QtdSomadaMl.




mensagemEstoque(_,8):-nl.
mensagemEstoque(Lista, Index):- 
  tipos(Tipos),
  nth0(Index,Tipos,Tipo),
  buscaBolsasPorTipo(Tipo,Lista,0,QtdSomada),
  bolsasToMl(QtdSomada,QtdSomadaMl),
  (QtdSomadaMl > 5000 -> write("Está sobrando sangue do tipo sanguíneo "), 
  write(Tipo), 
  write("! Há "), 
  write(QtdSomadaMl),
  write(" ml, é uma boa ideia doar para outra instituição que precise!")
  ; QtdSomadaMl < 1000 -> write("Está faltando sangue do tipo "),
  write(Tipo),
  write("! Há somente "), 
  write(QtdSomadaMl),
  write(" ml restantes"); true).
  succ(Index,NewIndex),
  mensagemEstoque(Lista, NewIndex).