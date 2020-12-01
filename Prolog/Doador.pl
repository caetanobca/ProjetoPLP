:- include('Impedimentos.pl').

constroiDoador(Nome,Endereco,Idade,Telefone,TipSanguineo,ImpedimentoStr,UltimoDiaImpedido,doador(Nome,Endereco,Idade,Telefone,TipSanguineo,ImpedimentoStr,UltimoDiaImpedido)).

getOntemString(DataString):- 
    get_time(Stamp),
    Ontem is (Stamp - 86400),
    dataParaString(Ontem,DataString).


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
doadoresToString(doador(Nome,Endereco,Idade,Telefone, TipSanguineo, ImpedimentoStr, UltimoDiaImpedido), Result):- 
    string_concat("Nome: ", Nome, Parte1), string_concat(Parte1, " Endereço: ", Parte2),
    string_concat(Parte2, Endereco, Parte3),string_concat(Parte3, " - Idade: ", Parte4), string_concat(Parte4, Idade, Parte5), 
    string_concat(Parte5, " - Telefone: ", Parte6), string_concat(Parte6, Telefone, Parte7), string_concat(Parte7, " - Tipo Sanguineo: ", Parte8),
    string_concat(Parte8, TipSanguineo, Parte9), string_concat(Parte9, " - Impedimentos: ", Parte10), string_concat(Parte10, ImpedimentoStr, Parte11),
    string_concat(Parte11, " - Ultimo Dia Impedido: ", Parte12),string_concat(Parte12,UltimoDiaImpedido,Result).

existeDoador(Nome,ListaDoador):- buscaDoador(Nome,ListaDoador,Result), \+(Result = "Doador não encontrado").
removerDoador(ListaDoador,Nome,Result):- buscaDoador(Nome,ListaDoador,Doador), delete(ListaDoador,Doador,Result).

%Metodo que vai Adiciona o ultimo dia impedido
adicionaImpedimento(Doador, NovoImpedimento, Result):- 
    getDoadorImpedimentoStr(Doador, ImpedimentoStr), getDoadorNome(Doador, Nome),
    getDoadorEndereco(Doador, Endereco), getDoadorIdade(Doador, Idade), getDoadorTelefone(Doador, Telefone),
    getDoadorTipSanguineo(Doador, TipSanguineo), 
    getDoadorUltimoDiaImpedido(Doador, UltimoDiaImpedido), stringParaData(UltimoDiaImpedido,Stamp),
    string_concat(ImpedimentoStr, "// ", Parte1), impedimentoToStringSimples(NovoImpedimento,ImpedimentoStrNovo) ,
    string_concat(Parte1, ImpedimentoStrNovo, Final), 
    getUltimoDiaImpedido(NovoImpedimento, Stamp, NovoStamp), dataParaString(NovoStamp, NovaData),
    constroiDoador(Nome,Endereco,Idade,Telefone,TipSanguineo,Final,NovaData,Result).

%Metodo que verifica se o doador está impedido de doar
estaImpedido(Doador, DiaDoacao) :- 
    getDoadorUltimoDiaImpedido(Doador,UltimoDiaImpedido), 
    stringParaData(DiaDoacao, DiaDoacaoStamp),
    stringParaData(UltimoDiaImpedido, UltimoDiaImpedidoStamp),
    %nl,write("->"),write(DiaDoacaoStamp),
    %nl,write("->"),write(UltimoDiaImpedidoStamp),
    DiaDoacaoStamp < UltimoDiaImpedidoStamp.


dataParaString(Stamp,StringData):-
    stamp_date_time(Stamp, DataString, 'UTC'), 
    date_time_value(year, DataString, Value3), 
    date_time_value(month, DataString, Value2), 
    date_time_value(day, DataString, Value1),
    string_concat(Value1, "/", Part1), 
    string_concat(Part1, Value2, Part2),
    string_concat(Part2, "/", Part3),
    string_concat(Part3, Value3, StringData).

stringParaData(StringData,Stamp):-
    atomic_list_concat(DiaMesAno,"/", StringData),
    nth0(0, DiaMesAno, DiaAtom), atom_number(DiaAtom, Dia),
    nth0(1, DiaMesAno, MesAtom), atom_number(MesAtom, Mes),
    nth0(2, DiaMesAno, AnoAtom), atom_number(AnoAtom, Ano),
    date_time_stamp(date(Ano,Mes,Dia,0,0,0,0,_,_), Stamp).