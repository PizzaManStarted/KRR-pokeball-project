% Returned values:
#show sphere/3.
#show radius/1.
#show grid/3.
#show sphere_len/1.

% Constants:
#const radius = 2.

% Safeguards:
:- radius <= 0.

% Rule simply used to get the radius used for the solver.
radius(R) :- R=radius.


% Generates a grid with the given radius:
grid(X, Y, Z) :- X=-radius..radius, Y=-radius..radius, Z=-radius..radius.

% Checks if a corner is outside the radius of sphere:
has_negative_corner(X,Y,Z) :- grid(X, Y, Z),  (X*10+5*SignX)**2 
                                            + (Y*10+5*SignY)**2 
                                            + (Z*10+5*SignZ)**2 
                                            - (radius*10)**2 >= 0, 
                              SignX= -1..1, SignX != 0, 
                              SignY= -1..1, SignY != 0,
                              SignZ= -1..1, SignZ != 0.
% or inside of the sphere:
has_positive_corner(X,Y,Z) :- grid(X, Y, Z),  (X*10+5*SignX)**2 
                                            + (Y*10+5*SignY)**2 
                                            + (Z*10+5*SignZ)**2 
                                            - (radius*10)**2 < 0,
                              SignX= -1..1, SignX != 0, 
                              SignY= -1..1, SignY != 0,
                              SignZ= -1..1, SignZ != 0.

%   A grid slot is part of the sphere if it 
% has a corner inside and outside the sphere:
sphere(X ,Y, Z) :- grid(X, Y, Z), has_negative_corner(X,Y,Z), 
                                  has_positive_corner(X,Y,Z).
   
% Gets the number of squares making up the sphere:
sphere_len(L) :- L = #count { X,Y,Z : sphere(X, Y, Z) }.

% Generates a grid with a given radius:
grid(X, Y, Z) :- X=-radius..radius, Y=-radius..radius, Z=-radius..radius.
