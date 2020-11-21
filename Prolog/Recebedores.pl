constroiRecebedor(Nome,Endereco,Idade,Telefone,NumDeBolsas,FichaMedica,recebedor(Nome,Endereco,Idade,Telefone,NumDeBolsas,FichaMedica)).

salvaRecebedor(Recebedor,Lista,Result):- append(Lista,[Recebedor], Result).

/*get dados de Recebedor*/
getRecebedorNome(recebedor(Nome,_,_,_), Nome).
getRecebedorEndereco(recebedor(_,Endereco,_,_), Endereco).
getRecebedorIdade(recebedor(_,_,Idade,_), Idade).
getRecebedorTelefone(recebedor(_,_,_,Telefone), Telefone).
getRecebedorNumDeBolsas(recebedor(_,_,_,NumDeBolsas), NumDeBolsas).
getRecebedorFichaMedica(recebedor(_,_,_,FichaMedica), FichaMedica).

%buscando recebedores
buscaRecebedor(NomeRecebedor,[],Result):- Result = "Não encontrado".
buscaRecebedor(NomeRecebedor,[Head|Tail], Result):- getRecebedorNome(Head,Nome), string_upper(Nome, NomeUpper), string_upper(NomeRecebedor, NomeRecebedorUpper),
            (NomeUpper = NomeRecebedorUpper -> Result = Head; buscaRecebedor(NomeRecebedor,Tail,Result)).

%listar todos os Recebedores
listarRecebedores([]):-nl.
listarRecebedores([Head|Tail]):- recebedoresToString(Head,RecebedoresString), write(RecebedoresString), nl, listarRecebedores(Tail).

%toString Recebedores
recebedoresToString(recebedor(Nome, Endereco, Idade, Telefone, NumDeBolsas, FichaMedica), Result):- string_concat("Nome: ", Nome, Parte1), string_concat(Parte1, " Endereço: ", Parte2),
                    string_concat(Parte2, Endereco, Parte3),string_concat(Parte3, " Idade: ", Parte4), string_concat(Parte4, Idade, Parte5), 
                    string_concat(Parte5, " Telefone: ", Parte6), string_concat(Parte6, Telefone, Parte7), string_concat(Parte7, " Numero de bolsas de sangue requisitadas: ", Parte8),
                    string_concat(Parte8, NumDeBolsas, Result).

existeRecebedor(Nome,ListaRecebedor):- buscaRecebedor(Nome,ListaRecebedor,Result), \+(Result = "Não encontrado").
removeRecebedor(Nome,ListaRecebedor,Result):- buscaRecebedor(Nome,ListaRecebedor,Recebedor), delete(ListaRecebedor,Recebedor,Result).
