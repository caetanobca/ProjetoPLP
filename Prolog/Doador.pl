constroiDoador(Nome,Endereco,Idade,Telefone,TipSanguineo,doador(Nome,Endereco,Idade,Telefone,TipSanguineo,"","12/01/1998")).

%salvaDoador(Doador,Lista,Result):- append(Lista,[Doador],Result).

/*get dados de Doador*/
getDoadorNome(doador(Nome,_,_,_,_,_,_), Nome).
getDoadorEndereco(doador(_,Endereco,_,_,_,_,_), Endereco).
getDoadorIdade(doador(_,_,Idade,_,_,_,_), Idade).
getDoadorTelefone(doador(_,_,_,Telefone,_,_,_), Telefone).
getDoadorTipSanguineo(doador(_,_,_,_,TipSanguineo,_,_), TipSanguineo).
getDoadorImpedimentoStr(doador(_,_,_,_,_,ImpedimentoStr,_), ImpedimentoStr).
getDoadorUltimoDiaImpedido(doador(_,_,_,_,_,_,UltimoDiaImpedido), UltimoDiaImpedido).

%buscando Doadores

buscaDoador(_,[],Result):- Result = "Doador não encontrado".
buscaDoador(NomeDoador,[Head|Tail], Result):- getDoadorNome(Head,Nome), string_upper(Nome, NomeUpper), string_upper(NomeDoador, NomeDoadorUpper),
            (NomeUpper = NomeDoadorUpper -> Result = Head; buscaDoador(NomeDoador,Tail,Result)).

%listar todos os doadores
listarDoadores([]):-nl.
listarDoadores([Head|Tail]):- doadoresToString(Head,DoadoresString), write(DoadoresString), nl, listarDoadores(Tail).

%toString Doadores
doadoresToString(doador(Nome,Endereco,Idade,Telefone, TipSanguineo, ImpedimentoStr, UltimoDiaImpedido), Result):- string_concat("Nome: ", Nome, Parte1), string_concat(Parte1, " Endereço: ", Parte2),
                    string_concat(Parte2, Endereco, Parte3),string_concat(Parte3, " Idade: ", Parte4), string_concat(Parte4, Idade, Parte5), 
                    string_concat(Parte5, " Telefone: ", Parte6), string_concat(Parte6, Telefone, Parte7), string_concat(Parte7, " Tipo Sanguineo: ", Parte8),
                    string_concat(Parte8, TipSanguineo, Parte9), string_concat(Parte9, " Impedimentos: ", Parte10), string_concat(Parte10, ImpedimentoStr, Parte11),
                    string_concat(Parte11, " Ultimo Dia Impedido: ", Parte12), string_concat(Parte12, UltimoDiaImpedido, Result).

existeDoador(Nome,ListaDoador):- buscaDoador(Nome,ListaDoador,Result), \+(Result = "Doador não encontrado").
removerDoador(ListaDoador,Nome,Result):- buscaDoador(Nome,ListaDoador,Doador), delete(ListaDoador,Doador,Result).



%mensagem De Agradecimento Individual 


%mensagem Pedido Doacao 