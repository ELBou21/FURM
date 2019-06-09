function [ A ] = build_matrix(trackerPts, forcingPts, epsilon, mu)
% Create regularized singularity matrix to help calculate the velocity at
% m tracker points from n forcing points in either the free-space or
% semi-infinite solution (that includes regularized image singularities)

% trackerPts is a 3m x 1 vector of tracking point locations
% forcingPts is a 3n x 1 vector of forcing point locations
% epsilon is the spreading parameter (scalar)
% mu is the viscosity (scalar)

% Calculates the number of tracking and forcing points
m = length(trackerPts)/3;
n = length(forcingPts)/3;

%Each z-component becomes negative in the image points
imagePts = forcingPts;
for i = 1:n;
    imagePts(3*i) = -imagePts(3*i);
end

% Choose one option below either free-space or semi-infinite solutions
%--------------------
% % Free-space solution
% A = stokesletMatrix(trackerPts, forcingPts, epsilon, mu); % original regularized Stokeslet
%--------------------
% Semi-infinite solution
A = stokesletMatrix(trackerPts, forcingPts, epsilon, mu) ... % original regularized Stokeslet
    - stokesletMatrix(trackerPts, imagePts, epsilon, mu) ... % image regularized Stokeslet
    - doubletMatrix(trackerPts, imagePts, epsilon, mu) ... % image regularized doublet
    - dipoleMatrix(trackerPts, imagePts, epsilon, mu) ... % image regulartized dipole
    + rotletMatrix(trackerPts, imagePts, epsilon, mu); % image regularized rotlet

end

