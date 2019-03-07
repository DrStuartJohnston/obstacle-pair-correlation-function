%% Script for generating pair correlation functions for the domains specified in parameters_Script
% Calculates the pair correlation function for a single domain or single
% iteration of a random walk. Called by loop_Pair_Correlation_Script
% Corrected pair correlation functions for domains with obstacles" by
% Johnston and Crampin: https://arxiv.org/abs/1811.07518

if strcmpi(Parameters.random_Generation,'yes')
    disp('Generating random holes')
	random_Grid_Holes;
end

disp('Generating grid')
generate_Grid;

disp('Populating grid')
populate_Grid;

disp('Calculating standard pair correlation function')
standard_PCF;

disp('Calculating analytic standard pair correlation function')
piecewise_Pair_Distance;
if strcmpi(timeCheck,'on')
    tic
end

disp('Calculating new analytic pair correlation function')
n_Hole_PCF;
if strcmpi(timeCheck,'on')
    tnH = toc;
end

disp('Calculating shortest paths')
calculate_Hole_Agent_Pair_Distances;
if strcmpi(timeCheck,'on')
    analytic_Time_i = tnH+tOcc;
    numeric_Time_i = tOcc+tPF;
end