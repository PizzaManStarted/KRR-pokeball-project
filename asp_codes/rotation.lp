% This file contains all the 24 unique rotation matrices 

% Rotate the cuboid
rotated_cuboid(ID, Z,-X,-Y)  :- selected_rot(ID, 1),  cuboid(X,Y,Z, ID).
rotated_cuboid(ID, -X,-Z,-Y) :- selected_rot(ID, 2),  cuboid(X,Y,Z, ID).
rotated_cuboid(ID, Z,X,Y)    :- selected_rot(ID, 3),  cuboid(X,Y,Z, ID).
rotated_cuboid(ID, -Y,-X,-Z) :- selected_rot(ID, 4),  cuboid(X,Y,Z, ID).
rotated_cuboid(ID, -Y,X,Z)   :- selected_rot(ID, 5),  cuboid(X,Y,Z, ID).
rotated_cuboid(ID, Y,-X,Z)   :- selected_rot(ID, 6),  cuboid(X,Y,Z, ID).
rotated_cuboid(ID, -Z,-X,Y)  :- selected_rot(ID, 7),  cuboid(X,Y,Z, ID).
rotated_cuboid(ID, -X,-Y,Z)  :- selected_rot(ID, 8),  cuboid(X,Y,Z, ID).
rotated_cuboid(ID, -X,Y,-Z)  :- selected_rot(ID, 9),  cuboid(X,Y,Z, ID).
rotated_cuboid(ID, Y,X,-Z)   :- selected_rot(ID, 10), cuboid(X,Y,Z, ID).
rotated_cuboid(ID, -Z,Y,X)   :- selected_rot(ID, 11), cuboid(X,Y,Z, ID).
rotated_cuboid(ID, -Y,-Z,X)  :- selected_rot(ID, 12), cuboid(X,Y,Z, ID).
rotated_cuboid(ID, X,Y,Z)    :- selected_rot(ID, 13), cuboid(X,Y,Z, ID).   % IDENTITY ROT
rotated_cuboid(ID, X,-Z,Y)   :- selected_rot(ID, 14), cuboid(X,Y,Z, ID).
rotated_cuboid(ID, -X,Z,Y)   :- selected_rot(ID, 15), cuboid(X,Y,Z, ID).
rotated_cuboid(ID, X,-Y,-Z)  :- selected_rot(ID, 16), cuboid(X,Y,Z, ID).
rotated_cuboid(ID, -Z,-Y,-X) :- selected_rot(ID, 17), cuboid(X,Y,Z, ID).
rotated_cuboid(ID, Z,Y,-X)   :- selected_rot(ID, 18), cuboid(X,Y,Z, ID).
rotated_cuboid(ID, Z,-Y,X)   :- selected_rot(ID, 19), cuboid(X,Y,Z, ID).
rotated_cuboid(ID, -Z,X,-Y)  :- selected_rot(ID, 20), cuboid(X,Y,Z, ID).
rotated_cuboid(ID, Y,-Z,-X)  :- selected_rot(ID, 21), cuboid(X,Y,Z, ID).
rotated_cuboid(ID, X,Z,-Y)   :- selected_rot(ID, 22), cuboid(X,Y,Z, ID).
rotated_cuboid(ID, -Y,Z,-X)  :- selected_rot(ID, 23), cuboid(X,Y,Z, ID).
rotated_cuboid(ID, Y,Z,X)    :- selected_rot(ID, 24), cuboid(X,Y,Z, ID).
