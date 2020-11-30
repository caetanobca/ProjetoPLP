constroiEnfermeiro(Nome,Endereco,Idade,Telefone,enfermeiro(Nome,Endereco,Idade,Telefone)).


%salvaEnfermeiro(Enfermeiro,Lista,Result):- append(Lista,[Enfermeiro],Result).


/*get dados de enfermeiro*/
getEnfermeiroNome(enfermeiro(Nome,_,_,_), Nome).
getEnfermeiroEndereco(enfermeiro(_,Endereco,_,_), Endereco).
getEnfermeiroIdade(enfermeiro(_,_,Idade,_), Idade).
getEnfermeiroTelefone(enfermeiro(_,_,_,Telefone), Telefone).

%buscando enfermeiros

buscaEnfermeiro(NomeEnfermeiro,[],Result):- Result = "Enfermeiro não encontrado".
buscaEnfermeiro(NomeEnfermeiro,[Head|Tail], Result):-
    getEnfermeiroNome(Head,Nome), string_upper(Nome, NomeUpper), string_upper(NomeEnfermeiro, NomeEnfermeiroUpper),
    (NomeUpper = NomeEnfermeiroUpper -> Result = Head; buscaEnfermeiro(NomeEnfermeiro,Tail,Result)).

%listar todos os enfermeiros
listarEnfermeiros([]):-nl.
listarEnfermeiros([Head|Tail]):- enfermeirosToString(Head,EnfermeirosString), write(EnfermeirosString), nl, listarEnfermeiros(Tail).

%toString Enfermeiros
enfermeirosToString(enfermeiro(Nome,Endereco,Idade,Telefone), Result):- string_concat("Nome: ", Nome, Parte1), string_concat(Parte1, " Endereço: ", Parte2),
                    string_concat(Parte2, Endereco, Parte3),string_concat(Parte3, " Idade: ", Parte4), string_concat(Parte4, Idade, Parte5), 
                    string_concat(Parte5, " Telefone: ", Parte6), string_concat(Parte6, Telefone, Result).

existeEnfermeiro(Nome,ListaEnfermeiro):- buscaEnfermeiro(Nome,ListaEnfermeiro,Result), (Result \= "Enfermeiro não encontrado").

removerEnfermeiro(ListaEnfermeiro,Nome,Result):- buscaEnfermeiro(Nome,ListaEnfermeiro,Enfermeiro), delete(ListaEnfermeiro,Enfermeiro,Result).


adicionaEscala(DiaMes,Enfermeiro,Escala,DataNome):-    
    pegaData(DiaMes,Escala,Result),
    ((Result \= -1) -> write("Data existe");write("Data não existe")),    
    enfermeirosToString(Enfermeiro,Nome),
    DataNome = [DiaMes,Nome].

pegaData(DiaMes,[],Result):-  Result is -1.
pegaData(DiaMes,[Head|Tail],Result):-
    nth0(0,Head,Data), 
    (Data = DiaMes -> Result = Data; pegaData(DiaMes,Tail,ResultNovo), Result is ResultNovo + 1).

removerEscala(ListaEscala,DiaEnfermeiro,Result):- delete(ListaEscala,DiaEnfermeiro,Result).

listarEscala([]):-nl.
listarEscalaData(DiaMes,Escala,Result):- 
    pegaData(DiaMes,Escala,Result).
    