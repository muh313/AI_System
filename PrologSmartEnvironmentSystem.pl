/*Gas levels: 78, 21, 415, 0.2*/
gas(nitrogen, 78).	
gas(oxygen, 21).
gas(co2, 415).
gas(so2, 0.2).

/*Particle levels: 18, 28*/
pm(pm(2.5), 18).
pm(pm(10), 28).												/* all facts (could be changed) */

state(atmosphere, good) :-
gas(nitrogen, N), N > 70, N < 85,				/* must be in between 70 and 85 to be true */
gas(oxygen, O), O < 23.5, O > 19.5,
gas(co2, C), C < 350,
gas(so2, S), S < 1,
pm(pm(2.5), P1), P1 < 35,
pm(pm(10), P2), P2 < 40.

state(atmosphere, moderate) :-
gas(nitrogen, N), N > 70, N < 90,
gas(co2, C), C < 500,
gas(so2, S), S < 380.

state(atmosphere, dangerous) :-
gas(nitrogen, N), N > 90;
gas(co2, C), C > 1200;										/* semi colon to show the strong facts which draw straight conclusion */
gas(so2, S), S > 400;
pm(pm(2.5), P1), P1 > 35,
pm(pm(10), P2), P2 > 40.

commands:-
write('find_gas.'), nl,
write('change_level.'), nl,
write('state(atmosphere, X).'), nl,
write('find_causes.'), nl,
write('find_solutions.'), nl,
write('state(pollution, X).'), nl,
write('result.').

find_gas:-
write('whose level (gas) do you wanna know?'), nl,
read(Input), nl,
gas(Input, X),
write(X), nl, nl,
write('To change level, firstly do this - dynamic(gas(gas name, gas level)).'), nl,
write('Then use change_level(gas(gas name, gas level), gas(gas name, gas new level)). - to modify levels').

change_level(OldFact, NewFact) :-
call(OldFact), !,   % Don't backtrack to find multiple instances of old fact
retract(OldFact),
assertz(NewFact).

find_causes:-
write('travel(mode, airplane)'), nl,
write('travel(mode, is_A(car, non-electric))'), nl,
write('fuel(power_plant, non-renewable)'), nl,
write('action(burn, forest)'), nl,
write('state(agriculture, increase)'), nl, nl,
write('You must use either - assert to add / Use retract to delete a fact from above').

find_solutions:-
write('travel(mode, is_A(car, electric))'), nl,
write('fuel(power_plant, renewable)'), nl,
write('action(increase, forest)'), nl, nl,
write('You must use either - assert to add / Use retract to delete a fact from above.').

state(pollution, increase) :-
travel(mode, airplane),
travel(mode, is_A(car, non-electric)),
fuel(power_plant, non-renewable);
action(burn, forest);
state(agriculture, increase).

state(pollution, decrease) :-
travel(mode, is_A(car, electric)),
fuel(power_plant, renewable),
action(increase, forest).

/*assert to add the fact
retract to remove the fact*/

result:-
humans(X),
write(X).

world(state(atmosphere, good)) :-
state(pollution, decrease);
state(atmosphere, good).

humans(safe) :-
world(state(atmosphere, good)), 
format('The World is in a SAFE zone.').					/* text to draw conclusion */

world(state(atmosphere, dangerous)) :-
state(pollution, increase);
state(atmosphere, dangerous).

humans(vulnerable) :-
world(state(atmosphere, dangerous)),
format('The World is in jeopardy, a global lockdown is imminent.').

world(state(atmosphere, moderate)) :-
travel(mode, airplane),
travel(mode, is_A(car, non-electric)),
travel(mode, is_A(car, electric)),
state(atmosphere, moderate).

humans(surviving) :-
world(state(atmosphere, moderate)),
format('The World is surviving and in some parts living healthy, 
however a threat may be forthcoming.').

/* use trace. to display all the reasoning if query is true */