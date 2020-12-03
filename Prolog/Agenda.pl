:- style_check(-singleton).
:- style_check(-discontiguous).

:- include("Enfermeiros.pl").
:- include("Doador.pl").


adicionaAgendaHemocentro(DiaMes,Doador,Enfermeiro,Agenda,DataNome):-    
    pegaData(DiaMes,Agenda,Result),
    ((Result \= -1) -> (indiceData(Agenda, Result, Indice), 
    nth0(Indice, Agenda, AgendaDiaMes), nth0(1, AgendaDiaMes, DoadoresAgendados),
    constroiAgendamentoHemocentro(Doador,Enfermeiro,Agendamento),
    string_concat(DoadoresAgendados, Agendamento, AgendaFinal)) 
    ;constroiAgendamentoHemocentro(Doador,Enfermeiro,AgendaFinal)),    
    DataNome = [DiaMes,AgendaFinal].

constroiAgendamentoHemocentro(Doador,Enfermeiro,Result):-
    getDoadorNome(Doador, Nome), string_concat("Doador: ", Nome, NomeAdd), string_concat(NomeAdd,"; Enfermeiro: ", NomeAdd2),
    getEnfermeiroNome(Enfermeiro,NomeEnfermeiro), string_concat(NomeAdd2, NomeEnfermeiro, NomeAdd3), string_concat(NomeAdd3, "; Local: Hemocentro//", Result).


adicionaAgendaDomicilio(DiaMes,Doador,Enfermeiro,Agenda,DataNome):-    
    pegaData(DiaMes,Agenda,Result),
    ((Result \= -1) -> (indiceData(Agenda, Result, Indice), 
    nth0(Indice, Agenda, AgendaDiaMes), nth0(1, AgendaDiaMes, DoadoresAgendados),
    constroiAgendamentoDomicilio(Doador,Enfermeiro,Agendamento),
    string_concat(DoadoresAgendados, Agendamento, AgendaFinal)) 
    ;constroiAgendamentoDomicilio(Doador,Enfermeiro,AgendaFinal)),    
    DataNome = [DiaMes,AgendaFinal].

constroiAgendamentoDomicilio(Doador,Enfermeiro,Result):-
    getDoadorNome(Doador, Nome), string_concat("Doador: ", Nome, NomeAdd), string_concat(NomeAdd,"; Enfermeiro: ", NomeAdd2),
    getEnfermeiroNome(Enfermeiro,NomeEnfermeiro), string_concat(NomeAdd2, NomeEnfermeiro, NomeAdd3), string_concat(NomeAdd3, "; Local: ", NomeAdd4),
    getDoadorEndereco(Doador,Endereco), string_concat(NomeAdd4, Endereco,NomeAdd5),  string_concat(NomeAdd5, "//", Result).  


removerAgenda(DiaAgendamento,Agenda,Result):-
    nth0(0, DiaAgendamento, DiaMes), 
    pegaData(DiaMes,Agenda,ExisteData),
    ((ExisteData \= -1) -> (pegaAgenda(DiaMes, Agenda, AgendaRemove), 
    delete(Agenda,AgendaRemove,Result)); Result = Agenda).

pegaAgenda(DiaMes,[Head|Tail],Result):- 
    nth0(0, Head, Data), string_upper(Data, DataStr), string_upper(DiaMes, DiaMesStr),
    (DataStr = DiaMesStr -> Result = Head; pegaAgenda(DiaMes, Tail, Result)).


visualizaAgenda(ListaAgenda,Data,Result):-
    pegaAgenda(Data, ListaAgenda, DoacoesAgendadas),   
    nth0(1,DoacoesAgendadas,DoadoresAgendados),       
    atomic_list_concat(ListaDoadores,"//", DoadoresAgendados),    
    listarAgendaData(ListaDoadores,Result).

listarAgendaData([], String):- String = "".
listarAgendaData([Head|Tail],String):-  listarAgendaData(Tail,StringNovo),string_concat(Head, "\n", Parte1),
    string_concat(Parte1, StringNovo, String). 




