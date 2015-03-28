%% 1. succeeds by finding a loop edge. 
%% Not sure if it should be 
is_loop(Event, Guard) :- transition(Source, Source, Event, Guard, _).
%% But the above doesn't match any facts in our EFSM because we deemed it was never indicated that a state can transitions to itself from the assignment specifications
%% We interpreted this where a state can transition to another state and then back to the same state it just trnasitioned from
%% is_loop(Event, Guard) :- transition(Source, Destinaton, Event, Guard, _), transition(Destinaton, Source, _, _, _).
%% is_loop(Event, Guard) :- transition(Destinaton, Source, Event, Guard, _), transition(Source, Destinaton, _, _, _).

%% 2. succeeds by returning a set of all loop edges.
all_loops(Set) :- findall((Event, Guard), is_loop(Event, Guard), Set).

%% 3. succeeds by finding an edge.
is_edge(Event, Guard):- transition( _, _, Event, Guard, _).

%% 4.
size(Length) :- findall(_, transition(_, _, _, _, _), L), length(L, Length).

%% 5.
is_link(Event, Guard) :- transition(Source, Destination, Event, Guard, _), Source \= Destination.

%% 6.
all_superstates(Set) :- setof(SuperState,BaseState^(superstate(SuperState,BaseState)),Set).


%% 7. Only really applicable to where states can't transition to previous states, as how can a state like dormant have any ancestors?
ancestor(Ancestor, Descendant):- superstate(Ancestor, Descendant).
ancestor(Ancestor, DescendantTwo):- superstate(Ancestor, Descendant), ancestor(Descendant, DescendantTwo).

%% 8.
%% inheritss_transitions(State, List) :- findall((LowLevelState, Destination, Event, Guard, Action), superstate(State, LowLevelState); transition(LowLevelState, Destination, Event, Guard, Action), List).
inheritss_transitions(State, List) :- superstate(State, LowLevelState), findall((LowLevelState, Destination, Event, Guard, Action),  transition(LowLevelState, Destination, Event, Guard, Action), List).
%% 9.
all_states(L) :- findall(State, state(State), L).

%% 10.
all_init_states(L) :- findall(State, initial_state(State, _), L).

%% 11.
get_starting_state(State) :- initial_state(State, null).

%% 12.
state_is_reflexive(State) :- transition( State, State, _, _, _).

%% 13.
graph_is_reflexive :- state_is_reflexive(State).

%% 14.
get_guards(Ret) :- findall(Guard, (transition(_, _, _, Guard, _), Guard \= null), Ret).

%% 15
get_events(Ret) :- findall(Event, (transition(_, _, Event, _, _), Event \= null), Ret).

%% 16
get_actions(Ret) :- findall(Action, (transition(_, _, _, _, Action), Action \= null), Ret).

%% 17
get_only_guarded(Ret) :- findall((Source, Destination), ( transition(Source, Destination, null, Guard, null), Guard \= null), Ret).

%% 18
legal_events_of(State, L) :- findall((Event, Guard), ((transition(State, _, Event, Guard, _); transition(_, State, Event, Guard, _)), (Event \= null, Guard \= null)), L).