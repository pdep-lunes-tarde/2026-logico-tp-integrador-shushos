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
    habitante(Persona, Raza, AnioNacio, _),
    not(esperanzaDeVida(Raza, _)),
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
conoceHazania(Hazania, Persona, Conmemoracion, Desde):-
    habitante(Persona, _, Nacimiento, Pueblo),
    conmemora(Pueblo, Hazania, Conmemoracion),
    inicioConmemoracion(Conmemoracion, Inicio), maximo(Nacimiento, Inicio, Desde).


%Punto 2a
esRecordadaEnUnAnio(Persona, Anio, Hazania):-
    estaVivo(Persona, Anio),
    conoceHazania(hazania(Hazania, _, _) , Persona, Forma, AnioForma),
    Anio >= AnioForma,
    verificaSiRecuerdaPorHazania(Forma, Anio, AnioForma).

verificaSiRecuerdaPorHazania(presencio, _, _).
verificaSiRecuerdaPorHazania(escuchoCancion, Anio, AnioForma):-
    Anio =< (AnioForma + 15).
verificaSiRecuerdaPorHazania(leyoLibro(Paginas), Anio, AnioForma):-
    Anio =< (AnioForma + Paginas).
verificaSiRecuerdaPorHazania(diaFestivo(_), _, _).
verificaSiRecuerdaPorHazania(estatua(Nombre, Material, Construccion), Anio, _):-
    conmemoracionVigente(estatua(Nombre, Material, Construccion), Anio).


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


% Punto 3

conmemora( weise,hazania(destruirAlReyDemonio,[frieren, himmel, heiter, eisen],ende ), diaFestivo(1340)).
conmemora(auberst, hazania(destruirAlReyDemonio, [frieren, himmel, heiter, eisen],ende),estatua("el equipo de heroes", bronce, 1370)).
conmemora(auberst, hazania(destruirASchlatElOmnisciente, [elHeroeDelSur],ende), estatua("el heroe del sur", marmol, 1340)).

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

maximo(X, Y, X):-
    X >= Y.

maximo(X, Y, Y):-
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
    paginasLeidasPorPueblo(Pueblo, Anio, PaginasLeidas),
    forall(
        (habitante(_, _, _, OtroPueblo), Pueblo \= OtroPueblo), 
        (paginasLeidasPorPueblo(OtroPueblo, Anio, OtrasPaginasLeidas), OtrasPaginasLeidas < PaginasLeidas)
        ).


puebloMusical(Pueblo, Anio):-
    habitante(_, _, _, Pueblo),
    findall(Hazania, (habitante(Persona, _, _, Pueblo), esRecordadaEnUnAnio(Persona, Anio, Hazania)), Hazanias),
    sinRepetidos(Hazanias, HazaniasSinRepetir),
    recuerdosMusical(HazaniasSinRepetir, ContadorMusical),
    length(HazaniasSinRepetir, ContadorHazanias),
    ContadorMusical > ContadorHazanias/2.

sinRepetidos([], []).
sinRepetidos([H|Cola], Resultado):-
    member(H, Cola),
    sinRepetidos(Cola, Resultado).
sinRepetidos([H|Cola], [H|Resultado]):-
    not(member(H, Cola)),
    sinRepetidos(Cola, Resultado).

recuerdosMusical([], 0).
recuerdosMusical([Hazania|Hazanias], ContadorMusical):-
    conoceHazania(hazania(Hazania, _, _), _, escuchoCancion, _),
    recuerdosMusical(Hazanias, Contador),
    ContadorMusical is Contador + 1.
recuerdosMusical([Hazania|Hazanias], ContadorMusical):-
    not(conoceHazania(hazania(Hazania, _, _), _, escuchoCancion, _)),
    recuerdosMusical(Hazanias, ContadorMusical).


puebloChismoso(Pueblo, Anio):-
    habitante(_, _, _, Pueblo),
    forall(
            (
                recuerdaHazaniaPueblo(Pueblo, Anio, Hazania)
            ), 
            not(estaCorroborada(Hazania))
          ).


esImportante(Hazania, Pueblo, Anio):-
    habitante(_, _, _, Pueblo),
    esRecordadaEnUnAnio(_, Anio, Hazania),
    forall(
            (
                habitante(Persona, _, _, Pueblo),
                estaVivo(Persona, Anio)
            ),
            esRecordadaEnUnAnio(Persona, Anio, Hazania)
          ).


viveTiemposSinPrecedentes(Pueblo, Anio):-
    habitante(_, _, _, Pueblo),
    forall(
            esImportante(Hazania, Pueblo, Anio),
            (
                habitante(Persona, _, _, Pueblo),
                esRecordadaEnUnAnio(Persona, Anio, Hazania),
                conoceHazania(hazania(Hazania, _, _), Persona, presencio, AnioPresencio),
                Anio >= AnioPresencio
            )
          ).


%Parte 5
%a
esHeroe(Persona):-
    conoceHazania(hazania(_,Participantes, _), _, _, _),
    member(Persona, Participantes).

%b
inspiroAUnHeroe(Inspirador, Inspirado):-
    esHeroe(Inspirado),
    conoceHazania(hazania(_, Heroes, _), Inspirado, _, _),
    member(Inspirador, Heroes),
    Inspirador \= Inspirado.

%c
cadenaDeInspiracion([HeroeInicial , SegundoHeroe | Resto]):- 
    inspiroAUnHeroe(HeroeInicial, SegundoHeroe),
    armarCadena(SegundoHeroe, [SegundoHeroe, HeroeInicial], [SegundoHeroe | Resto]).

armarCadena(HeroeActual, _, [HeroeActual]).

armarCadena(HeroeActual, Visitados, [HeroeActual | Resto]):-
    inspiroAUnHeroe(HeroeActual, SiguienteHeroe),
    not(member(SiguienteHeroe, Visitados)),
    armarCadena(SiguienteHeroe, [SiguienteHeroe | Visitados], Resto).


%Punto 6
elDreamTeam(Lider, DreamTeam):-
    esHeroe(Lider),
    cadenaDeInspiracion(Cadena),
    member(Lider,Cadena),
    esAntecesor(Lider, Cadena, Antecesores),
    antecesoresElegidos(Antecesores, Elegidos),
    Elegidos \= [],
    permutation([Lider | Elegidos], DreamTeam).

esAntecesor(Lider, Cadena, Antecesores):-
    append(Antecesores, [Lider], Cadena). %Recorre la cadena hasta el lider y se queda con eso 

antecesoresElegidos([Antecesor | Resto], [Antecesor | MasElegidos]):-
    opcionalementeElegir(Resto, MasElegidos).
antecesoresElegidos([_ | Resto], MasElegidos):-
    opcionalementeElegir(Resto, MasElegidos).

opcionalementeElegir([],[]).
opcionalementeElegir([Antecesor|Resto], [Antecesor|MasElegidos]):-
    opcionalementeElegir(Resto, MasElegidos).  
opcionalementeElegir([_ | Resto], MasElegidos):-
    opcionalementeElegir(Resto, MasElegidos).


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
    test('Si una hazania es conocida con una unica version, esta corroborada', nondet):-
        estaCorroborada(rescatarALaHermanaDeWirbel).
    test('Una hazania que tiene varias versiones, no esta corroborada', nondet):-
        not(estaCorroborada(destruirAlDemonioAura)).
    test('Una hazania paso al olvido si no es recordada en ese anio', nondet):-
        pasoAlOlvido(destruirAlDemonioAura, 1460).
    test('Una hazania no paso al olvido si todavia la recuerdan', nondet):-
        not(pasoAlOlvido(destruirAlDemonioAura, 1440)).
    

    
    %punto 3
    test('Un personaje recordara una hazana si en su pueblo en ese ano hay una estatuta en buenas condiciones que conmermore la hazana', nondet):-
        esRecordadaEnUnAnio(lawine, 1400, destruirAlReyDemonio).
    test('Un personaje no recordara una hazana si en su pueblo en ese ano no hay una estatuta en buenas condiciones que conmermore la hazana', nondet):-
        not(esRecordadaEnUnAnio(lawine, 1390, destruirAlReyDemonio)).
    test('Un personaje recordara una hazana si su pueblo tiene un dia festivo del mismo', nondet):-
        esRecordadaEnUnAnio(fern, 1400, destruirAlReyDemonio).


    %Punto 4
    test(en_weise_se_recuerda_destruir_al_demonio_aura_en_1400, nondet):-
        recuerdaHazaniaPueblo(weise, 1400, destruirAlReyDemonio).
    test(en_klares_se_recuerda_rescatar_a_la_hermana_de_wirbel_en_1395, nondet):-
        recuerdaHazaniaPueblo(klares, 1395, rescatarALaHermanaDeWirbel).
    test(en_klares_no_se_recuerda_destruir_al_demonio_aura_en_1395, nondet):-
        not(recuerdaHazaniaPueblo(klares, 1395, destruirAlDemonioAura)).
    test(en_weise_se_leyeron_100_paginas_en_1335, nondet):-
        paginasLeidasPorPueblo(weise, 1335, 100).
    test(en_weise_se_leyeron_0_paginas_en_1336, nondet):-
        paginasLeidasPorPueblo(weise, 1336, 0).
    test(ende_es_el_pueblo_mas_lector_en_1400, nondet):-
        puebloMasLector(ende, 1400).
    test(auberst_es_musical_en_1395, nondet):-
        puebloMusical(auberst, 1395).
    test(weise_no_es_musical_en_1400, nondet):-
        not(puebloMusical(weise, 1400)).
    test(ende_es_chismoso_en_1420, nondet):-
        puebloChismoso(ende, 1420).
    test(weise_no_es_chismoso_en_1400, nondet):-
        not(puebloChismoso(weise, 1400)).
    test(destruir_al_rey_demonio_es_importante_para_weise_en_1400, nondet):-
        esImportante(destruirAlReyDemonio, weise, 1400).
    test(recuperar_al_gato_perdido_no_es_importante_para_weise_en_1400, nondet):-
        not(esImportante(recuperarAlGatoPerdido, weise, 1400)).
    test(klares_vive_tiempos_sin_precedentes_en_1395, nondet):-
        viveTiemposSinPrecedentes(klares, 1395).
    test(weise_no_vive_tiempos_sin_precedentes_en_1400, nondet):-
        not(viveTiemposSinPrecedentes(weise, 1400)).

    %Punto 5
    test('Si alguien participo en una hazania que es conocida por otros, es un heroe', nondet):-
        esHeroe(frieren).
    test('Si alguien no participo en una hazania conocida, no es un heroe', nondet):-
        not(esHeroe(wirbel)).
    test('Si un heroe conoce una hazania en que otro heroe participo, se inspiro de ese', nondet):-
        inspiroAUnHeroe(fern, frieren).
    test('Si un heroe conoce una hazania de la que otro participo, este ultimo inspiro al primero', nondet):-
        inspiroAUnHeroe(stark, frieren).
    test('Si un heroe no conoce ninguna hazania, no puede ser inspirado', nondet):-
        not(inspiroAUnHeroe(_, eisen)).
    test('Si los personajes inspiran a otros distintos recursivamente la cadena es valida', nondet):-
        cadenaDeInspiracion([himmel, fern, frieren, denken]).
    test('Si un personaje no inspiro a otro la cadena no es valida', nondet):-
        not(cadenaDeInspiracion([denken, frieren])).
    test('Una cadena ciclica no es valida', nondet):-
        not(cadenaDeInspiracion([frieren, fern, frieren])).

    %Punto 6
    test("Para un heroe, el mismo y un antecesor directo forman un dream team", nondet):-
        elDreamTeam(fern, [fern, himmel]).
    test("Un dream siempre es valido sin importar el orden de los heroes en el dream team", nondet):-
        elDreamTeam(fern, [fern, himmel]).
    test("El heroe individualmenre no es un dream team valido", nondet):-
        not(elDreamTeam(fern, [fern])).
    test("El dream team no es valido si no incluye al heroe", nondet):-
        not(elDreamTeam(fern, [frieren])).

:- end_tests(tpIntegrador).