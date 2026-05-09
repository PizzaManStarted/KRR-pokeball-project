% Inputs: 
% sphere/3, radius/1, grid/3, sphere_len/1 (from sphere_gen.lp's output)
% output_cuboid/4 (from generator.lp's output)

% Outputs:
#show placed_on_grid/4.
#show build_step/2.
% #show origin_sphere/4.

% Constants:
#const realistic = 0.

% Gather all provided cuboid id's:
all_cuboid_id(ID) :- output_cuboid(ID, _,_,_).
% Choose the cuboids to try to make a sphere with:
{ cuboid_id(ID) } :- all_cuboid_id(ID).

% Gets the size of the choosen cuboids:
shape_len(ID, L) :- L = #count { X,Y,Z : output_cuboid(ID, X, Y, Z) }, cuboid_id(ID).

% Select a rotation for each cuboid between the 24 possible rot:
{ selected_rot(ID, ROT) : ROT=1..24 } = 1 :- cuboid_id(ID), ID != black_ring.

% /!\ The cuboid gets rotated by rule of the file `rotation.lp` which gets us `rotated_cuboid/4` rules.

% If a shape as a size of 1, no need to choose a rotation for it:
selected_rot(ID, 13) :- shape_len(ID, 1).

% Renaming the "output_cuboid" rule into cuboid in order to use it in "rotation.lp":
cuboid(X, Y, Z, ID) :- output_cuboid(ID, X, Y, Z).

% Place origin of a cuboid ID on the sphere:
{ origin_sphere(ID, X,Y,Z) : grid(X,Y,Z) } = 1 :- cuboid_id(ID).

% Place the entire piece onto the sphere:
placed_on_grid(ID, X + X_off, Y + Y_off, Z + Z_off) :-  origin_sphere(ID, X, Y, Z),
                                                        rotated_cuboid(ID, X_off, Y_off, Z_off).

% Each placement of the cuboid has to be placed on the sphere:
:- placed_on_grid(ID, X, Y, Z), not sphere(X,Y,Z).
% Two cuboids cannot occupy the same space:
:- placed_on_grid(ID1, X, Y, Z), placed_on_grid(ID2, X, Y, Z),  ID1 != ID2.

% Every space of the cuboid has to be occupied:
occupied(X,Y,Z) :- placed_on_grid(ID, X,Y,Z).
:- sphere(X,Y,Z), not occupied(X,Y,Z).

% Evaluate the cost of this solution:
solution_cost(L) :- L = #count { ID : cuboid_id(ID) }.

% ___________________________________ POKEBALL ___________________________________

% If this piece is present then always take it:
cuboid_id(black_ring) :- all_cuboid_id(black_ring).
% The ring has to be placed at the center if given:
origin_sphere(black_ring, -R, -R, 0) :- cuboid_id(black_ring), radius(R).
placed_on_grid(black_ring, X, Y, 0) :- cuboid_id(black_ring), sphere(X,Y,0).

% ___________________________________ OPTIMISATION PROBLEM ___________________________________

% Tries to minimize the cost of the solution:
% #minimize { L : solution_cost(L) }.

% ___________________________________ REALISTIC ___________________________________

% With realistic: Forces the pieces to be placed from the bottom up.

% To do this, we can try to guess a topological ordering of the cuboids:
{ build_step(ID, T) : T = 0..8 } = 1 :- cuboid_id(ID), realistic = 1.

% A cuboid ID1 is said to be on top of a cuboid ID2 if there exist a piece of ID1 that is on top of a piece of ID2:
on_top_of(ID, X,Y,Z, ID2) :-
    placed_on_grid(ID, X,Y,Z),
    sphere(X,Y,Z-1),
    placed_on_grid(ID2, X,Y,Z-1),
    ID != ID2, realistic = 1.

%  This check that the topological ordering if valid.
:- build_step(ID, T),
   on_top_of(ID, X,Y,Z, ID2),
   build_step(ID2, T2),
   T2 >= T, realistic = 1.