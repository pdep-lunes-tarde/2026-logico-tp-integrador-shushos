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

    test("Un personaje esta vivo si nacio y esta dentro de los anios de su esperanza de vida", nondet) :-
        estaVivo(kanne, 1370).
    test("Un personaje no esta vivo si no nacio", nondet) :-
        not(estaVivo(kanne, 1300)).
    test("Un personaje no esta vivo si nacio y se termino su esperanza de vida", nondet) :-
        not(estaVivo(kanne, 2000)).
    test("Un personaje esta vivo si nacio y es su ultimo anio de esperanza de vida", nondet) :-
        estaVivo(voll, 1550).
    

    %Punto2
    test("Un personaje no recuerda una hazania si el anio es menor al de cuando la conoce", nondet):-
        not(esRecordadaEnUnAnio(lawine, 1380, destruirAlDemonioAura)).
    test("Un personaje recuerda una hazania una determinada cantidad de tiempo, dependiendo como la conocio", nondet):-
        esRecordadaEnUnAnio(lawine, 1400, destruirAlDemonioAura).
    test("Un personaje ya no recuerda una hazania pasado determinado tiempo, a menos que la haya presenciado", nondet):-
        not(esRecordadaEnUnAnio(lawine, 1450, destruirAlDemonioAura)).
    test("Un personaje ya no recuerda una hazania si no esta vivo", nondet):-
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
    test("Un pueblo recuerda una hazania en un anio si este tiene al menos un habitante que lo haga", nondet):-
        recuerdaHazaniaPueblo(weise, 1400, destruirAlReyDemonio).
    test("Un pueblo no recuerda una hazania en un anio si este no tiene ningun habitante que lo haga", nondet):-
        not(recuerdaHazaniaPueblo(klares, 1395, destruirAlDemonioAura)).
    test("En un pueblo se leyeron en un anio la sumatoria de las paginas leidas por sus habitantes", nondet):-
        paginasLeidasPorPueblo(weise, 1335, 100).
    test("Un pueblo es el mas lector en un anio si la suma de las paginas leidas por sus habitantes es mayor que la de los otros pueblos", nondet):-
        puebloMasLector(ende, 1400).
    test("Un pueblo es musical en un anio si la mayoria de las hazanias recordadas en el mismo se conocieron por canciones", nondet):-
        puebloMusical(auberst, 1395).
    test("Un pueblo no es musical en un anio si la mayoria de las hazanias recordadas en el mismo no se conocieron por canciones", nondet):-
        not(puebloMusical(weise, 1400)).
    test("Un pueblo es chismoso en un anio si ninguna de las hazanias recordadas por sus habitantes no estan corroboradas", nondet):-
        puebloChismoso(ende, 1420).
    test("Un pueblo no es chismoso en un anio si no se cumple que ninguna de las hazanias recordadas por sus habitantes estan corroboradas", nondet):-
        not(puebloChismoso(weise, 1400)).
    test("Una hazania es importante para un pueblo en un anio si todos los habitantes del pueblo que estan vivos la recuerdan tambien", nondet):-
        esImportante(destruirAlReyDemonio, weise, 1400).
    test("Una hazania no es importante para un pueblo en un anio si no se cumple que todos los habitantes del pueblo que estan vivos la recuerdan tambien", nondet):-
        not(esImportante(recuperarAlGatoPerdido, weise, 1400)).
    test("Un pueblo vive tiempos sin precedentes en un anio si todas las hazanias importantes que se recuerdan en un pueblo se recuerdan porque alguien del pueblo las presencio", nondet):-
        viveTiemposSinPrecedentes(klares, 1395).
    test("Un pueblo no vive tiempos sin precedentes en un anio si no se cumple que todas las hazanias importantes que se recuerdan en un pueblo se recuerdan porque alguien del pueblo las presencio", nondet):-
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