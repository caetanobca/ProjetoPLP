constroiRecebedor(Nome,Idade,Endereco,NumDeBolsas,TipoSanguineo,Hospital, recebedor(Nome,Idade,Endereco,NumDeBolsas,TipoSanguineo,Hospital)).
salvaRecebedor(Recebedor,Lista,Result):- append(Lista,[Recebedor], Result).

/*get dados de Recebedor*/
getRecebedorNome(recebedor(Nome,_,_,_,_,_), Nome).
getRecebedorIdade(recebedor(_,Idade,_,_,_,_), Idade).
getRecebedorEndereco(recebedor(_,_,Endereco,_,_,_), Endereco).
getRecebedorNumDeBolsas(recebedor(_,_,_,NumDeBolsas,_,_), NumDeBolsas).
getRecebedorTipoSanguineo(recebedor(_,_,_,_,TipoSanguineo,_), TipoSanguineo).
getRecebedorHospital(recebedor(_,_,_,_,_,Hospital), Hospital).

%buscando recebedores 
buscaRecebedor(_,[],Result):- Result = "Paciente não encontrado".
buscaRecebedor(NomeRecebedor,[Head|Tail], Result):- getRecebedorNome(Head,Nome), string_upper(Nome, NomeUpper), string_upper(NomeRecebedor, NomeRecebedorUpper),
            (NomeUpper = NomeRecebedorUpper -> Result = Head; buscaRecebedor(NomeRecebedor,Tail,Result)).

%listar todos os Recebedores
listarRecebedores([]):-nl.
listarRecebedores([Head|Tail]):- recebedoresToString(Head,RecebedoresString), write(RecebedoresString), nl, listarRecebedores(Tail).

%toString Recebedores
recebedoresToString(recebedor(Nome,Idade,Endereco,NumDeBolsas,TipoSanguineo,Hospital), Result):- 
    string_concat("Nome: ", Nome, Parte1), string_concat(Parte1, " Idade: ", Parte2), string_concat(Parte2, Idade, Parte3), 
    string_concat(Parte3, " Endereço: ", Parte4), string_concat(Parte4, Endereco, Parte5), 
    string_concat(Parte5, " Numero de bolsas requisitadas: ", Parte6),string_concat(Parte6, NumDeBolsas, Parte7),
    string_concat(Parte7, " Tipo sanguíneo: ", Parte8), string_concat(Parte8, TipoSanguineo, Parte9),
    string_concat(Parte9, " Hospital onde está internado: ", Parte10), string_concat(Parte10, Hospital, Result).

%toString de recebedor detalhado
recebedoreString(recebedor(Nome,Idade,Endereco,NumDeBolsas,TipoSanguineo,Hospital), Result):- 
    string_concat("Nome: ", Nome, Parte1), string_concat(Parte1, "\nIdade: ", Parte2), string_concat(Parte2, Idade, Parte3), 
    string_concat(Parte3, "\nEndereço: ", Parte4), string_concat(Parte4, Endereco, Parte5), 
    string_concat(Parte5, "\nNumero de bolsas requisitadas: ", Parte6),string_concat(Parte6, NumDeBolsas, Parte7),
    string_concat(Parte7, "\nTipo sanguíneo: ", Parte8), string_concat(Parte8, TipoSanguineo, Parte9),
    string_concat(Parte9, "\nHospital onde está internado: ", Parte10), string_concat(Parte10, Hospital, Result).

existeRecebedor(Nome,ListaRecebedor):- buscaRecebedor(Nome,ListaRecebedor,Result), (Result \= "Paciente não encontrado").