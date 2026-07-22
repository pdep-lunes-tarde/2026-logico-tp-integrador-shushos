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

:- end_tests(tpIntegrador).
