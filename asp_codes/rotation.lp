% This file contains all the 24 unique rotation matrices 

% Rotate the shape
rotated_shape(ID, Z,-X,-Y)  :- selected_rot(ID, 1), shape(X,Y,Z, ID).
rotated_shape(ID, -X,-Z,-Y) :- selected_rot(ID, 2), shape(X,Y,Z, ID).
rotated_shape(ID, Z,X,Y)    :- selected_rot(ID, 3), shape(X,Y,Z, ID).
rotated_shape(ID, -Y,-X,-Z) :- selected_rot(ID, 4), shape(X,Y,Z, ID).
rotated_shape(ID, -Y,X,Z)   :- selected_rot(ID, 5), shape(X,Y,Z, ID).
rotated_shape(ID, Y,-X,Z)   :- selected_rot(ID, 6), shape(X,Y,Z, ID).
rotated_shape(ID, -Z,-X,Y)  :- selected_rot(ID, 7), shape(X,Y,Z, ID).
rotated_shape(ID, -X,-Y,Z)  :- selected_rot(ID, 8), shape(X,Y,Z, ID).
rotated_shape(ID, -X,Y,-Z)  :- selected_rot(ID, 9), shape(X,Y,Z, ID).
rotated_shape(ID, Y,X,-Z)   :- selected_rot(ID, 10), shape(X,Y,Z, ID).
rotated_shape(ID, -Z,Y,X)   :- selected_rot(ID, 11), shape(X,Y,Z, ID).
rotated_shape(ID, -Y,-Z,X)  :- selected_rot(ID, 12), shape(X,Y,Z, ID).
rotated_shape(ID, X,Y,Z)    :- selected_rot(ID, 13), shape(X,Y,Z, ID).   % IDENTITY ROT
rotated_shape(ID, X,-Z,Y)   :- selected_rot(ID, 14), shape(X,Y,Z, ID).
rotated_shape(ID, -X,Z,Y)   :- selected_rot(ID, 15), shape(X,Y,Z, ID).
rotated_shape(ID, X,-Y,-Z)  :- selected_rot(ID, 16), shape(X,Y,Z, ID).
rotated_shape(ID, -Z,-Y,-X) :- selected_rot(ID, 17), shape(X,Y,Z, ID).
rotated_shape(ID, Z,Y,-X)   :- selected_rot(ID, 18), shape(X,Y,Z, ID).
rotated_shape(ID, Z,-Y,X)   :- selected_rot(ID, 19), shape(X,Y,Z, ID).
rotated_shape(ID, -Z,X,-Y)  :- selected_rot(ID, 20), shape(X,Y,Z, ID).
rotated_shape(ID, Y,-Z,-X)  :- selected_rot(ID, 21), shape(X,Y,Z, ID).
rotated_shape(ID, X,Z,-Y)   :- selected_rot(ID, 22), shape(X,Y,Z, ID).
rotated_shape(ID, -Y,Z,-X)  :- selected_rot(ID, 23), shape(X,Y,Z, ID).
rotated_shape(ID, Y,Z,X)    :- selected_rot(ID, 24), shape(X,Y,Z, ID).
