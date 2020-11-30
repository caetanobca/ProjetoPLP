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
enfermeirosToString(enfermeiro(Nome,Endereco,Idade,Telefone), Result):- string_concat("Nome: ", Nome, Parte1), string_concat(Parte1, " - Endereço: ", Parte2),
                    string_concat(Parte2, Endereco, Parte3),string_concat(Parte3, " - Idade: ", Parte4), string_concat(Parte4, Idade, Parte5), 
                    string_concat(Parte5, " - Telefone: ", Parte6), string_concat(Parte6, Telefone, Result).

existeEnfermeiro(Nome,ListaEnfermeiro):- buscaEnfermeiro(Nome,ListaEnfermeiro,Result), (Result \= "Enfermeiro não encontrado").

removerEnfermeiro(ListaEnfermeiro,Nome,Result):- buscaEnfermeiro(Nome,ListaEnfermeiro,Enfermeiro), delete(ListaEnfermeiro,Enfermeiro,Result).


adicionaEscala(DiaMes,Enfermeiro,Escala,DataNome):-    
    pegaData(DiaMes,Escala,Result),
    ((Result \= -1) -> (write("Data existe"), indiceData(Escala, Result, Indice), 
    nth0(Indice, Escala, EscalaDiaMes), nth0(1, EscalaDiaMes, EnfermeirosEscalados),
    getEnfermeiroNome(Enfermeiro, Nome), string_concat(Nome, " -- ", NomeAdd), 
    string_concat(EnfermeirosEscalados, NomeAdd, EscalaFinal)) 
    ;write("Data não existe"), getEnfermeiroNome(Enfermeiro, Nome), string_concat(Nome, " -- ", EscalaFinal)),    
    DataNome = [DiaMes,EscalaFinal].

pegaData(_,[],Result):- Result = -1.
pegaData(DiaMes,[Head|Tail],Result):-
    nth0(0,Head,Data), 
    (Data = DiaMes -> Result = Data; pegaData(DiaMes,Tail,Result)).

indiceData([Head|_], Data, 0):- nth0(0,Head,Data), !.
indiceData([_|Tail], Data, Indice):-
    indiceData(Tail, Data, Indice1), !,
    Indice is Indice1+1.

removerEscala(DiaEnfermeiro,ListaEscala,Result):-
    nth0(0, DiaEnfermeiro, DiaMes), 
    pegaData(DiaMes,ListaEscala,ExisteData),
    ((ExisteData \= -1) -> (pegaEscala(DiaMes, ListaEscala, EscalaRemove), 
    delete(ListaEscala,EscalaRemove,Result)); Result = ListaEscala).

pegaEscala(DiaMes,[Head|Tail],Result):-
    nth0(0,Head,Data), 
    (Data = DiaMes -> Result = Head; pegaData(DiaMes,Tail,Result)).

listarEscala([]):-nl.
listarEscalaData(DiaMes,Escala,Result):- 
    pegaData(DiaMes,Escala,Result).
    