% Inputs:
% sphere/3, sphere_len/1 (from sphere_gen.lp's output)

% "Returned values":
#show output_cuboid/4.

% Default values:
#const nb_pieces = 4.
#const additional_piece = 0.
#const ring = 0.
#const realistic = 0.
#const min_size = 1.

% Protections:
:- nb_pieces <= 0.

% Creates the cuboids id.
cuboid_id(ID) :- ID=1..nb_pieces.

% Select for each cuboid, a maximum size.
{ cuboid_len(ID, LEN): LEN=min_size..L } = 1 :- cuboid_id(ID), sphere_len(L).

% Assign a cuboid to each block of the sphere.
{ cuboid(X, Y, Z, ID) : cuboid_id(ID) } = 1 :- sphere(X, Y, Z).

% The number of selected blocks of the sphere 
% for each cuboid must be its expected size.
{ cuboid(X,Y,Z,ID): sphere(X,Y,Z) } = LEN :- cuboid_len(ID, LEN), ID != black_ring.

% Cuboids cannot overlap when placed on the sphere: 
:- cuboid(X, Y, Z, ID1), cuboid(X, Y, Z, ID2), ID1 != ID2.

% Two blocks of the same cuboid (same ID) are 
% adjacent if their coordinates differ by 1 on one of the axis.
has_neighbor(ID, X, Y, Z, X2, Y, Z) :- cuboid(X,Y,Z, ID), cuboid(X2,Y, Z,ID), 
                                       X2 = X+Offset, Offset=-1..1, Offset != 0.
has_neighbor(ID, X, Y, Z, X, Y2, Z) :- cuboid(X,Y,Z, ID), cuboid(X,Y2, Z,ID), 
                                       Y2 = Y+Offset, Offset=-1..1, Offset != 0.
has_neighbor(ID, X, Y, Z, X, Y, Z2) :- cuboid(X,Y,Z, ID), cuboid(X,Y, Z2,ID), 
                                       Z2 = Z+Offset, Offset=-1..1, Offset != 0.

% The goal here is to find, for each cuboid, a unique piece that can act as a root.
min_shape_x(ID, MinX) :-  cuboid_id(ID),
                    MinX = #min { X : cuboid(X,Y,Z,ID) }, 
                    MinX != #sup.

min_shape_y(ID, MinY) :-  cuboid_id(ID),
                    min_shape_x(ID, X),
                    MinY = #min { Y : cuboid(X,Y,Z,ID), X = X }, 
                    MinY != #sup.

min_shape_z(ID, MinZ) :-  cuboid_id(ID),
                    min_shape_x(ID, X), 
                    min_shape_y(ID, Y),
                    MinZ = #min { Z : cuboid(X,Y,Z,ID), X = X, Y = Y }, 
                    MinZ != #sup.

min_cuboid(ID, X, Y, Z) :- min_shape_x(ID, X), min_shape_y(ID, Y), min_shape_z(ID, Z).

root(ID,X,Y,Z) :- min_cuboid(ID,X,Y,Z).

% A part of the cuboid can reach the root if it is the root.
is_reachable(ID,X,Y,Z) :- root(ID,X,Y,Z).
% Or if it has a neighor that can reach it. 
is_reachable(ID,X2,Y2,Z2) :- is_reachable(ID,X,Y,Z),
                             has_neighbor(ID,X,Y,Z,X2,Y2,Z2).

% A part of a cuboid is not reachable if there exist no path to the root:
:- cuboid(X,Y,Z,ID), not is_reachable(ID,X,Y,Z).



% Select a random rotation for the cuboid between the 24 possibility (see rotation.lp file):
{ selected_rot(ID, ROT) : ROT=1..24 } = 1 :- cuboid_id(ID).

% /!\ The cuboid gets rotated by rule of the file `rotation.lp` which gets us `rotated_cuboid/4` rules.

% Normalize after applying rotation:
rot_min_x(ID, MinX) :- MinX = #min { X : rotated_cuboid(ID,X,Y,Z) }, cuboid_id(ID), MinX != #sup.
rot_min_y(ID, MinY) :- MinY = #min { Y : rotated_cuboid(ID,X,Y,Z) }, cuboid_id(ID), MinY != #sup.
rot_min_z(ID, MinZ) :- MinZ = #min { Z : rotated_cuboid(ID,X,Y,Z) }, cuboid_id(ID), MinZ != #sup.
% (The outputed cuboid is simply the normalized rotated cuboid)
output_cuboid(ID, X - MinX, Y - MinY, Z - MinZ) :-
    rotated_cuboid(ID, X, Y, Z),
    rot_min_x(ID, MinX),
    rot_min_y(ID, MinY),
    rot_min_z(ID, MinZ).

% ___________________________________ POKEBALL ___________________________________
% Each rule here is determined by the constant "ring", if it is equal to 1.

% Place a new cuboid called "ring" every tile for which Z = 0:
cuboid_id(black_ring) :- ring = 1.
cuboid(X, Y, 0, black_ring) :- sphere(X, Y, 0), ring = 1.
% Additional check making sure that the ring cuboid is not placed somewhere else.
:- cuboid(X, Y, Z, black_ring), Z!=0, ring = 1.

% ___________________________________ OPTIMISATION PROBLEM ___________________________________

% Adds optional pieces to spice up the problem:
output_cuboid(nb_pieces + P, 0, 0, 0) :- additional_piece > 0, P=1..additional_piece.

% ___________________________________ REALISTIC ___________________________________

% With realistic: Forces the pieces to be placed from the bottom up.

% To do this, we can try to guess a topological ordering of the cuboids:
{ build_step(ID, T) : T = 0..nb_pieces } = 1 :- cuboid_id(ID), realistic = 1.

% A cuboid ID1 is said to be on top of a cuboid ID2 if there exist a piece of ID1 that is on top of a piece of ID2:
on_top_of(ID, X,Y,Z, ID2) :-
    cuboid(X,Y,Z, ID),
    sphere(X,Y,Z-1),
    cuboid(X,Y,Z-1, ID2),
    ID != ID2, realistic = 1.

%  This check that the topological ordering if valid.
:- build_step(ID, T),
   on_top_of(ID, X,Y,Z, ID2),
   build_step(ID2, T2),
   T2 >= T, realistic = 1.