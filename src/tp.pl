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

esperanzaDeVida(elfo, infinita).
esperanzaDeVida(humano, 80).
esperanzaDeVida(enano, 350).

%Punto 1b
estaVivo(Persona, Anio):-
    habitante(Persona, Raza, AnioNacio, _),
    nacio(Anio,AnioNacio),
    Diferencia is Anio - AnioNacio,
    esperanzaDeVida(Raza, Esperanza),
    sigueVivo(Esperanza, Diferencia).
    
nacio(Anio,AnioNacio):-
    Anio > AnioNacio.

sigueVivo(infinita, _).
sigueVivo(Esperanza, Diferencia):-
    Diferencia =< Esperanza.


%Punto 2
%version, hazania, quien la realizo, donde
versionHazania(rescatarALaHermanaDeWirbel, stark, klares).
versionHazania(rescatarALaHermanaDeWirbel, fern, klares).
versionHazania(version(destruirAlDemonioAura, lawine), frieren, weise).
versionHazania(version(destruirAlDemonioAura, voll), denken, auberst).
versionHazania(destruirAlReyDemonio, frieren, ende).
versionHazania(destruirAlReyDemonio, himmel, ende).
versionHazania(destruirAlReyDemonio, heiter, ende).
versionHazania(destruirAlReyDemonio, eisen, ende).
versionHazania(recuperarAlGatoPerdido, himmel, weise).
versionHazania(recuperarAlGatoPerdido, frieren, weise).

%Que hazania, que version, quien la conoce, como la conocio y cuando
conoceHazania(rescatarALaHermanaDeWirbel, wirbel, presencio, 1390).
conoceHazania(rescatarALaHermanaDeWirbel, frieren, presencio, 1390).
conoceHazania(destruirAlDemonioAura, lawine, escuchoCancion, 1393).
conoceHazania(destruirAlDemonioAura, voll, leyoLibro(50), 1400).
conoceHazania(destruirAlReyDemonio,serie, leyoLibro(100), 1335).
conoceHazania(recuperarAlGatoPerdido, kane, presencio, 1375).

%Punto 2a
esRecordadaEnUnAnio(Persona, Anio, Hazania):-
    estaVivo(Persona, Anio),
    conoceHazania(Hazania, Persona, presencio, AnioPresencio),
    Anio >= AnioPresencio.
esRecordadaEnUnAnio(Persona, Anio, Hazania):-
    estaVivo(Persona, Anio),
    conoceHazania(Hazania, Persona, escuchoCancion, AnioEscucho),
    Anio >= AnioEscucho,
    Anio =< (AnioEscucho + 15).
esRecordadaEnUnAnio(Persona, Anio, Hazania):-
    estaVivo(Persona, Anio),
    conoceHazania(Hazania, Persona, leyoLibro(Paginas), AnioLeyo),
    Anio >= AnioLeyo,
    Anio =< (AnioLeyo + Paginas).
esRecordadaEnUnAnio(Persona,Anio,Hazania):-
    estaVivo(Persona,Anio),
    conocePorDiaFestivo(Persona,Hazania,Desde),
    Anio >= Desde.
esRecordadaEnUnAnio(Persona,Anio,Hazania):-
    estaVivo(Persona,Anio),
    conocePorEstatua(Persona,Hazania,Desde,Pueblo),
    Anio >= Desde,
    estatuaVigente(Pueblo,Hazania,Anio).

%Punto 2b
estaCorroborada(Hazania):-
    not(tieneVersionesDistintas(Hazania)). 

tieneVersionesDistintas(Hazania):-
    conoceHazania(Hazania, QuienLaConoce1, _, _),
    conoceHazania(Hazania, QuienLaConoce2, _, _),
    QuienLaConoce1 \= QuienLaConoce2,
    versionHazania(version(Hazania, QuienLaConoce1), Quien1, _),
    versionHazania(version(Hazania, QuienLaConoce2), Quien2, _),
    Quien1 \= Quien2.

tieneVersionesDistintas(Hazania):-
    conoceHazania(Hazania, QuienLaConoce1, _, _),
    conoceHazania(Hazania, QuienLaConoce2, _, _),
    QuienLaConoce1 \= QuienLaConoce2,
    versionHazania(version(Hazania, QuienLaConoce1), _, Donde1),
    versionHazania(version(Hazania, QuienLaConoce2), _, Donde2),
    Donde1 \= Donde2.

%Punto 2c
pasoAlOlvido(Hazania, Anio):-
    conoceHazania(Hazania, _, _, _),
    not(esRecordadaEnUnAnio(_, Anio, Hazania)).

%Punto3

diaFestivo(weise, destruirAlReyDemonio, 1340).

estatua(auberst, "el equipo de heroes", bronce, destruirAlReyDemonio, 1370).
estatua(auberst,"el heroe del sur", marmol,destruirASchlatElOmnisciente,1340). 
    
mantenimiento("el equipo de heroes",1400).
mantenimiento("el equipo de heroes",1450).
mantenimiento("el heroe del sur",1410).

duracion(bronce,15).
duracion(marmol,30).

ventanaValida(FechaInicio, Material, Anio):-
    duracion(Material, Duracion),
    Anio >= FechaInicio,
    Anio =< FechaInicio + Duracion.

estatuaVigente(Pueblo,Hazania,Anio):-
    estatua(Pueblo,Nombre,Material,Hazania,Construccion),
    ventanaValida(Construccion,Material,Anio).
estatuaVigente(Pueblo,Hazania,Anio):-
    estatua(Pueblo,Nombre,Material,Hazania,_),
    mantenimiento(Nombre,FechaMantenimiento),
    ventanaValida(FechaMantenimiento,Material,Anio).   

conocePorEstatua(Persona,Hazania,Desde,Pueblo):-
    habitante(Persona,_,Nacimiento,Pueblo),
    estatua(Pueblo,_,_,Hazania,Inicio),
    maximo(Nacimiento,Inicio,Desde).  
    
conocePorDiaFestivo(Persona,Hazania,Desde):-
    habitante(Persona,_,Nacimiento,Pueblo),
    diaFestivo(Pueblo,Hazania,Inicio),
    maximo(Nacimiento,Inicio,Desde).    
    

maximo(X,Y,X):-
    X >= Y.

maximo(X,Y,Y):-
    Y > X.    
   



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