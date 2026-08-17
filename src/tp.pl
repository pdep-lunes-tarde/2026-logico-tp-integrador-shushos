%Punto 1a
habitante(denken, humano, 1290, auberst).
habitante(voll, enano, 1200, ende).
habitante(serie, elfo, 500, weise).
habitante(fern, humano, 1370, weise).
habitante(stark, humano, 1368, riegel).
habitante(lawine, humano, 1372, auberst).
habitante(kanne, humano, 1365, weise).
habitante(wirbel, humano, 1350, klares).
habitante(lernen, humano, 1315, auberst).
habitante(frieren, elfo, 100, weise).
habitante(eisen, enano, 1150, riegel).

esperanzaDeVida(humano, 80).
esperanzaDeVida(enano, 350).

%Punto 1b
estaVivo(Persona, Anio):-
    habitante(Persona, elfo, AnioNacio, _),
    Anio > AnioNacio.
estaVivo(Persona, Anio):-
    habitante(Persona, Raza, AnioNacio, _),
    Anio > AnioNacio,
    Diferencia is Anio - AnioNacio,
    esperanzaDeVida(Raza, Esperanza),
    Diferencia =< Esperanza.


%Punto 2 
%Que hazania con quien la hizo y donde, quien la conoce, como la conocio y cuando
conoceHazania(hazania(rescatarALaHermanaDeWirbel, [stark, fern], klares), wirbel, presencio, 1390).
conoceHazania(hazania(rescatarALaHermanaDeWirbel, [stark, fern], klares), frieren, presencio, 1390).
conoceHazania(hazania(destruirAlDemonioAura, [frieren], weise), lawine, escuchoCancion, 1393).
conoceHazania(hazania(destruirAlDemonioAura, [denken], auberst), voll, leyoLibro(50), 1400).
conoceHazania(hazania(destruirAlReyDemonio, [frieren, himmel, heiter, eisen], ende),serie, leyoLibro(100), 1335).
conoceHazania(hazania(recuperarAlGatoPerdido, [himmel, frieren], weise), kane, presencio, 1375).

%Del Punto 3
conoceHazania(Hazania, Persona, conmemoracion, Desde):-
    habitante(Persona, _, Nacimiento, Pueblo),
    conmemora(Pueblo, Hazania, Conmemoracion),
    inicioConmemoracion(Conmemoracion, Inicio), maximo(Nacimiento, Inicio, Desde).


%Punto 2a
esRecordadaEnUnAnio(Persona, Anio, Hazania):-
    estaVivo(Persona, Anio),
    conoceHazania(hazania(Hazania, _, _) , Persona, Forma, AnioForma),
    verificaSiRecuerdaPorHazania(Forma, Anio, AnioForma).
esRecordadaEnUnAnio(Persona, Anio, Hazania):-
    estaVivo(Persona, Anio),
    conoceHazania(Hazania, Persona, conmemoracion, Desde),
    Anio >= Desde,
    habitante(Persona, _, _, Pueblo),
    conmemora(Pueblo, Hazania, Conmemoracion),
    conmemoracionVigente(Conmemoracion, Anio).

verificaSiRecuerdaPorHazania(presencio, Anio, AnioForma):-
    Anio >= AnioForma.
verificaSiRecuerdaPorHazania(escuchoCancion, Anio, AnioForma):-
    Anio >= AnioForma,
    Anio =< (AnioForma + 15).
verificaSiRecuerdaPorHazania(leyoLibro(Paginas), Anio, AnioForma):-
    Anio >= AnioForma,
    Anio =< (AnioForma + Paginas).


%Punto 2b
estaCorroborada(Hazania):-
    conoceHazania(hazania(Hazania, _, _), _, _, _),
    not(tieneVersionesDistintas(Hazania)). 

tieneVersionesDistintas(Hazania):-
    conoceHazania(hazania(Hazania, Personas1, _), _, _, _),
    conoceHazania(hazania(Hazania, Personas2, _), _, _, _),
    Personas1 \= Personas2.


tieneVersionesDistintas(Hazania):-
    conoceHazania(hazania(Hazania, _, Lugar1), _, _, _),
    conoceHazania(hazania(Hazania, _, Lugar2), _, _, _),
    Lugar1 \= Lugar2.

%Punto 2c
pasoAlOlvido(Hazania, Anio):-
    conoceHazania(hazania(Hazania, _, _), _, _, _),
    not(esRecordadaEnUnAnio(_, Anio, Hazania)).


%Punto 3

conmemora(weise, destruirAlReyDemonio, diaFestivo(1340)).
conmemora(auberst, destruirAlReyDemonio, estatua("el equipo de heroes", bronce, 1370)).
conmemora(auberst, destruirASchlatElOmnisciente, estatua("el heroe del sur", marmol, 1340)).


mantenimiento("el equipo de heroes", 1400).
mantenimiento("el equipo de heroes", 1450).
mantenimiento("el heroe del sur", 1410).


duracion(bronce, 15).
duracion(marmol, 30).


ventanaValida(FechaInicio, Material, Anio):-
    duracion(Material, Duracion),
    Anio >= FechaInicio,
    Anio =< FechaInicio + Duracion.


inicioConmemoracion(diaFestivo(Inicio), Inicio).
inicioConmemoracion(estatua(_, _, Inicio), Inicio).


conmemoracionVigente(diaFestivo(_), _).
conmemoracionVigente(estatua(_, Material, Construccion), Anio):-
    ventanaValida(Construccion, Material, Anio).
conmemoracionVigente(estatua(Nombre, Material, _), Anio):-
    mantenimiento(Nombre, FechaMantenimiento),
    ventanaValida(FechaMantenimiento, Material, Anio).
   
maximo(X,Y,X):-
    X >= Y.
maximo(X,Y,Y):-
    Y > X.


%Punto 4
recuerdaHazaniaPueblo(Pueblo, Anio, Hazania):-
    habitante(Persona, _, _, Pueblo),
    esRecordadaEnUnAnio(Persona, Anio, Hazania).

paginasLeidasPorPueblo(Pueblo, Anio, PaginasLeidas):-
    habitante(_, _, _, Pueblo),
    findall(Pagina,
        (
            habitante(Persona, _, _, Pueblo), 
            conoceHazania(_, Persona, leyoLibro(Pagina), Anio)
        ), 
        Paginas
    ),
    sum_list(Paginas, PaginasLeidas).

puebloMasLector(Pueblo, Anio):-
    habitante(_, _, _, Pueblo),
    paginasLeidasPorPueblo(Pueblo, Anio, PaginasLeidas),
    forall(
        (habitante(_, _, _, OtroPueblo), Pueblo \= OtroPueblo), 
        (paginasLeidasPorPueblo(OtroPueblo, Anio, OtrasPaginasLeidas), OtrasPaginasLeidas < PaginasLeidas)
        ).

%esta mal, lo de recuerdosMusical si sirve, pero esto no
puebloMusical(Pueblo, Anio):-
    habitante(_, _, _, Pueblo),
    findall(Forma, (habitante(Persona, _, _, Pueblo), conoceHazania(_, _, Forma, Anio)), Formas),
    recuerdosMusical(Formas, ContadorMusical),
    length(Formas, ContadorRecuerdos),
    ContadorMusical >= ContadorRecuerdos/2. 

recuerdosMusical([], 0).
recuerdosMusical([Forma|Formas], ContadorMusical):-
    Forma == escuchoCancion,
    recuerdosMusical(Formas, Contador),
    ContadorMusical is Contador + 1.
recuerdosMusical([Forma|Formas], ContadorMusical):-
    Forma \= escuchoCancion,
    recuerdosMusical(Formas, ContadorMusical).

:- begin_tests(tpIntegrador, []).

    test(kanne_esta_viva_en_el_anio_1370, nondet) :-
        estaVivo(kanne, 1370).
    test(kanne_no_esta_viva_en_el_anio_1300, nondet) :-
        not(estaVivo(kanne, 1300)).
    test(kanne_no_esta_viva_en_el_anio_2000, nondet) :-
        not(estaVivo(kanne, 2000)).
    test(voll_esta_vivio_en_el_anio_1550, nondet) :-
        estaVivo(voll, 1550).
    test(voll_no_esta_vivio_en_el_anio_1551, nondet) :-
        not(estaVivo(voll, 1551)).
    test(serie_esta_vivia_en_el_anio_5000, nondet) :-
        estaVivo(serie, 5000).
    

    %Punto2
    test(lawine_no_recuerda_destruirAlDemonioAura_en_1380_porque_no_escucho_la_cancion, nondet):-
        not(esRecordadaEnUnAnio(lawine, 1380, destruirAlDemonioAura)).
    test(lawine_recuerda_detruirAlDemonioAura_en_1400, nondet):-
        esRecordadaEnUnAnio(lawine, 1400, destruirAlDemonioAura).
    test(lawine_ya_no_recuerda_destruirAlDemonioAura_en_1450, nondet):-
        not(esRecordadaEnUnAnio(lawine, 1450, destruirAlDemonioAura)).
    test(voll_recuerda_destruirAlDemonioAura_en_1450, nondet):-
        esRecordadaEnUnAnio(voll, 1450, destruirAlDemonioAura).
    test(voll_no_recuerda_destruirAlDemonioAura_en_1460, nondet):-
        not(esRecordadaEnUnAnio(voll, 1460, destruirAlDemonioAura)).
    test(wirbel_recuerda_rescatarALaHermanaDeWirbel_en_1430, nondet):-
        esRecordadaEnUnAnio(wirbel, 1430, rescatarALaHermanaDeWirbel).
    test(wirbel_no_recuerda_rescatarALaHermanaDeWirbel_en_1440_porque_ya_no_esta_vivo, nondet):-
        not(esRecordadaEnUnAnio(wirbel, 1440, rescatarALaHermanaDeWirbel)).
    test(rescatar_a_la_hermana_de_Wirbel_es_una_hazania_corroborada, nondet):-
        estaCorroborada(rescatarALaHermanaDeWirbel).
    test(destruir_al_demonio_aura_no_es_hazania_corroborada, nondet):-
        not(estaCorroborada(destruirAlDemonioAura)).
    test(destruir_al_demonio_aura_paso_al_olvido_en_1460, nondet):-
        pasoAlOlvido(destruirAlDemonioAura, 1460).
    test(destruir_al_demonio_aura_no_paso_al_olvido_en_1440):-
        not(pasoAlOlvido(destruirAlDemonioAura, 1440)).
    

    %punto 3
    test(lawine_recuerda_destruir_al_rey_demonio_por_estatua_en_1400, nondet):-
        esRecordadaEnUnAnio(lawine, 1400, destruirAlReyDemonio).
    test(lawine_no_recuerda_destruir_al_rey_demonio_en_1390_por_estatua, nondet):-
        not(esRecordadaEnUnAnio(lawine, 1390, destruirAlReyDemonio)).
    test(fern_recuerda_destruir_al_rey_demonio_por_dia_festivo_en_1400, nondet):-
        esRecordadaEnUnAnio(fern, 1400, destruirAlReyDemonio).

    :- end_tests(tpIntegrador).