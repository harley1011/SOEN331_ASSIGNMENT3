%% 1. succeeds by finding a loop edge. 
is_loop(Event, Guard) :- transition(Source, Source, Event, Guard, _).

%% 2. succeeds by returning a set of all loop edges.
all_loops(Set) :- findall((Event, Guard), is_loop(Event, Guard), Set).

%% 3. succeeds by finding an edge.
is_edge(Event, Guard):- transition( _, _, Event, Guard, _).

%% 4. succeeds by returning the size of the entire EFSM (given by the number of its edges).
size(Length) :- findall(_, transition(_, _, _, _, _), L), length(L, Length).

%% 5. succeeds by finding a link edge.
is_link(Event, Guard) :- transition(Source, Destination, Event, Guard, _), Source \= Destination.

%% 6. succeeds by finding all superstates in the EFSM.
all_superstates(Set) :- setof(SuperState,BaseState^(superstate(SuperState,BaseState)),Set).

%% 7. succeeds by returning an ancestor to a given state.
ancestor(Ancestor, Descendant):- superstate(Ancestor, Descendant).
ancestor(Ancestor, DescendantTwo):- superstate(Ancestor, Descendant), ancestor(Descendant, DescendantTwo).

%% 8. succeeds by returning all transitions inherited by a given state.
inheritss_transitions(State, List) :- superstate(State, LowLevelState), findall((LowLevelState, Destination, Event, Guard, Action),  transition(LowLevelState, Destination, Event, Guard, Action), List).

%% 9. succeeds by returning a list of all states.
all_states(L) :- findall(State, state(State), L).

%% 10. succeeds by returning a list of all starting states.
all_init_states(L) :- findall(State, initial_state(State, _), L).

%% 11. succeeds by returning the top-level starting state.
get_starting_state(State) :- initial_state(State, null).

%% 12. succeeds is State is reflexive.
state_is_reflexive(State) :- transition( State, State, _, _, _).

%% 13. succeeds if the entire EFSM is reflexive.
graph_is_reflexive :- state_is_reflexive(State).

%% 14. succeeds by returning a set of all guards.
get_guards(Ret) :- findall(Guard, (transition(_, _, _, Guard, _), Guard \= null), Ret).

%% 15. succeeds by returning a set of all events.
get_events(Ret) :- findall(Event, (transition(_, _, Event, _, _), Event \= null), Ret).

%% 16. succeeds by returning a set of all actions.
get_actions(Ret) :- findall(Action, (transition(_, _, _, _, Action), Action \= null), Ret).

%% 17. succeeds by returning state pairs that are associated by guards only.
get_only_guarded(Ret) :- findall((Source, Destination), ( transition(Source, Destination, null, Guard, null), Guard \= null), Ret).

%% 18. succeeds by returning all legal event-guard pairs.
legal_events_of(State, L) :- findall((Event, Guard), ((transition(State, _, Event, Guard, _); transition(_, State, Event, Guard, _)), (Event \= null, Guard \= null)), L).