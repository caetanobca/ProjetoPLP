constroiRecebedor(Nome,Idade,NumDeBolsas,TipoSanguineo,recebedor(Nome,Idade,NumDeBolsas,TipoSanguineo)).

salvaRecebedor(Recebedor,Lista,Result):- append(Lista,[Recebedor], Result).

/*get dados de Recebedor*/
getRecebedorNome(recebedor(Nome,_,_,_), Nome).
getRecebedorIdade(recebedor(_,_,Idade,_), Idade).
getRecebedorNumDeBolsas(recebedor(_,_,_,NumDeBolsas), NumDeBolsas).
getRecebedorTipoSanguineo(recebedor(_,_,_,TipoSanguineo), TipoSanguineo).

%buscando recebedores 
buscaRecebedor(NomeRecebedor,[],Result):- "Não encontrado".
buscaRecebedor(NomeRecebedor,[Head|Tail], Result):- getRecebedorNome(Head,Nome), string_upper(Nome, NomeUpper), string_upper(NomeRecebedor, NomeRecebedorUpper),
            (NomeUpper = NomeRecebedorUpper -> Result = Head; buscaRecebedor(NomeRecebedor,Tail,Result)).

%listar todos os Recebedores
listarRecebedores([]):-nl.
listarRecebedores([Head|Tail]):- recebedoresToString(Head,RecebedoresString), write(RecebedoresString), nl, listarRecebedores(Tail).

%toString Recebedores
recebedoresToString(recebedor(Nome, Idade, NumDeBolsas, TipoSanguineo), Result):- string_concat("Nome: ", Nome, Parte1),
                    string_concat(Parte1, " Idade: ", Parte2), string_concat(Parte2, Idade, Parte3), 
                    string_concat(Parte3, " Bolsas Requisitadas: ", Parte4),
                    string_concat(Parte5, NumDeBolsas, Result), 
                    string_concat(Parte6, "Tipo Sanguineo: ", Parte7),
                    string_concat(Parte7, TipoSanguineo, Result).


existeRecebedor(Nome,ListaRecebedor):- buscaRecebedor(Nome,ListaRecebedor,Result), \+(Result = "Não encontrado").