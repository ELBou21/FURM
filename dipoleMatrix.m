function [ A ] = dipoleMatrix(trackerPts, forcingPts, epsilon, mu)
% Create the 3m x 3n regularized dipole matrix to calculate the velocity at m
% tracker points generated by forces at n forcing points

% trackerPts is a 3m x 1 vector of tracking point locations
% forcingPts is a 3n x 1 vector of forcing point locations
% epsilon is the spreading parameter (scalar)
% mu is the viscosity (scalar)

% Calculates the number of tracking and forcing points
m = length(trackerPts)/3;
n = length(forcingPts)/3;

% Initialize the matrix
A = zeros(3*m,3*n);

% loops through each combination of tracking points and forcing points
for p = 1:m
    for q=1:n
        % xhat is the difference between a pair of tracking/forcing pts
        xhat = trackerPts(3*p-2:3*p)-forcingPts(3*q-2:3*q);
        r = norm(xhat);
        R = (r.^2  + epsilon.^2).^(1/2);
        D = zeros(3,3);
        % Building the 3x3 dipole matrix for each pair of tracking/forcing pts
        for i = 1:3
            for j = 1:3
                D(i,j) = (-xhat(3).^2*(1-2*(i==3)))*(-(i==j)/R.^3 + 3*epsilon.^2*(i==j)/R.^5 + 3*xhat(i)*xhat(j)/R.^5);
            end
        end
        % Inserting the 3x3 matrices into the dipole matrix
        A(3*p-2:3*p,3*q-2:3*q) = (1/(4*pi*mu))*D;
    end
end
end
