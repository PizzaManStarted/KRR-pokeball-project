#show placed_on_grid/4.
#show build_step/2.
#show origin_sphere/4.

#const gravity = 0.

% Gather all cuboid id's
all_cuboid_id(ID) :- output_shape(ID, _,_,_).
% Choose the cuboids to try to make a sphere with.
{ shape_id(ID) } :- all_cuboid_id(ID).

% If this piece is present then always take it.
shape_id(black_ring) :- all_cuboid_id(black_ring).
% The ring has to be placed at the center if given.
% :- placed_on_grid(black_ring, X, Y, Z), Z != 0.
origin_sphere(black_ring, -R, -R, 0) :- shape_id(black_ring), radius(R).
placed_on_grid(black_ring, X, Y, 0) :- shape_id(black_ring), sphere(X,Y,0).

% Gets the size of the choosen cuboids.
shape_len(ID, L) :- L = #count { X,Y,Z : output_shape(ID, X, Y, Z) }, shape_id(ID).


% Select a rotation for each cuboid between the 24 possible rot
{ selected_rot(ID, ROT) : ROT=1..24 } = 1 :- shape_id(ID), ID != black_ring.


% -> If a shape as a size of 1, no need to choose a rotation for it.
selected_rot(ID, 13) :- shape_len(ID, 1).


shape(X, Y, Z, ID) :- output_shape(ID, X, Y, Z).


nb_pieces(L) :- L= #max { ID : shape_id(ID) }, L != #sup.


% Place origin of a cuboid ID:
{ origin_sphere(ID, X,Y,Z) : grid(X,Y,Z) } = 1 :- shape_id(ID).

% Place the entire piece onto the sphere
placed_on_grid(ID, X + X_off, Y + Y_off, Z + Z_off) :-  origin_sphere(ID, X, Y, Z),
                                                        rotated_shape(ID, X_off, Y_off, Z_off).


:- placed_on_grid(ID, X, Y, Z), not sphere(X,Y,Z).
:- placed_on_grid(ID1, X, Y, Z), placed_on_grid(ID2, X, Y, Z),  ID1 != ID2.

% Implicit if no additional pieces exists and it also saves time during execution for some reasons.
occupied(X,Y,Z) :- placed_on_grid(ID, X,Y,Z).
:- sphere(X,Y,Z), not occupied(X,Y,Z).

% Evaluate the cost of this solution:
solution_cost(L) :- L = #count { ID : shape_id(ID) }.



% Choose a build order:
{ build_step(ID, T) : T = 0..8 } = 1 :- shape_id(ID), gravity = 1.

% Cuboid with ID1 on top of cuboid with ID2.
on_top_of(ID, X,Y,Z, ID2) :-
    placed_on_grid(ID, X,Y,Z),
    sphere(X,Y,Z-1),
    placed_on_grid(ID2, X,Y,Z-1),
    ID != ID2, gravity = 1.


%  If a piece is on top of another one, then the build order should add the bottom one first then the top one.
:- build_step(ID, T),
   on_top_of(ID, X,Y,Z, ID2),
   build_step(ID2, T2),
   T2 >= T, gravity = 1.

% This is actually a topological sort.

% #minimize { L : solution_cost(L) }.
