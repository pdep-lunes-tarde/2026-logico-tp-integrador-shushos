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

estaVivo(Persona, Anio):-
    habitante(Persona, elfo, AnioNacio, _),
    Anio>AnioNacio.
estaVivo(Persona, Anio):-
    habitante(Persona, humano, AnioNacio, _),
    Anio>AnioNacio,
    Diferencia is Anio - AnioNacio,
    Diferencia =< 80.
estaVivo(Persona, Anio):-
    habitante(Persona, enano, AnioNacio, _),
    Anio>AnioNacio,
    Diferencia is Anio - AnioNacio,
    Diferencia =< 350.

%Punto 2
%version, hazania, quien la realizo, donde
versionHazania(unica, rescatarALaHermanaDeWirbel, stark, klares).
versionHazania(unica, rescatarALaHermanaDeWirbel, fern, klares).
versionHazania(versionLawine, destruirAlDemonioAura, frieren, weise).
versionHazania(versionVoll, destruirAlDemonioAura, denken, auberst).
versionHazania(unica, destruirAlReyDemonio, frieren, ende).
versionHazania(unica, destruirAlReyDemonio, himmel, ende).
versionHazania(unica, destruirAlReyDemonio, heiter, ende).
versionHazania(unica, destruirAlReyDemonio, eisen, ende).
versionHazania(unica, recuperarAlGatoPerdido, himmel, weise).
versionHazania(unica, recuperarAlGatoPerdido, frieren, weise).

%Que hazania, que version, quien la conoce, como la conocio y cuando
conoceHazania(rescatarALaHermanaDeWirbel, unica, wirbel, presencio, 1390).
conoceHazania(rescatarALaHermanaDeWirbel, unica, frieren, presencio, 1390).
conoceHazania(destruirAlDemonioAura, versionLawine, lawine, escuchoCancion, 1393).
conoceHazania(destruirAlDemonioAura, versionVoll, voll, leyoLibro(50), 1400).
conoceHazania(destruirAlReyDemonio, unica,serie, leyoLibro(100), 1335).
conoceHazania(recuperarAlGatoPerdido, unica, kane, presencio, 1375).

esRecordadaEnUnAnio(Persona, Anio, Hazania):-
    estaVivo(Persona, Anio),
    conoceHazania(Hazania, _, Persona, presencio, AnioPresencio),
    Anio >= AnioPresencio.
esRecordadaEnUnAnio(Persona, Anio, Hazania):-
    estaVivo(Persona, Anio),
    conoceHazania(Hazania, _, Persona, escuchoCancion, AnioEscucho),
    Anio >= AnioEscucho,
    Anio =< (AnioEscucho + 15).
esRecordadaEnUnAnio(Persona, Anio, Hazania):-
    estaVivo(Persona, Anio),
    conoceHazania(Hazania, _, Persona, leyoLibro(Paginas), AnioLeyo),
    Anio >= AnioLeyo,
    Anio =< (AnioLeyo + Paginas).

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
    

:- end_tests(tpIntegrador).
