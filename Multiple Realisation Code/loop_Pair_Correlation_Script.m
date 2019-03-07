%% Script for generating many realisations of pair correlation functions for the domains specified in parameters_Script
% Calculates the pair correlation function for many domains or many
% iterations of a random walk. Highest level script to generate results from
% Corrected pair correlation functions for domains with obstacles" by
% Johnston and Crampin: https://arxiv.org/abs/1811.07518
close all
clear all

parameters_Script;

%% Initialise measurements for each realisation

num_Repeats = Parameters.num_Repeats;
pair_Distances_Av = zeros(Parameters.length_X+Parameters.length_Y-2,num_Repeats);                       %Pair distances calculated with explicit formulae
numerical_Pair_Distances_Av = zeros(Parameters.length_X+Parameters.length_Y-2,num_Repeats);             %Pair distances calculated numerically
expected_Numerical_Sites_Av = zeros(Parameters.length_X+Parameters.length_Y-2,num_Repeats);             %Expected counts of pairs of sites calculated numerically
expected_Analytic_Sites_Av = zeros(Parameters.length_X+Parameters.length_Y-2,num_Repeats);              %Expected counts of pairs of sites calculated with explicit formulae
pw_Normalisation_Av = zeros(Parameters.length_X+Parameters.length_Y-2,num_Repeats);                     %Normalisation terms
total_Expected_Pair_Distances_Av = zeros(Parameters.length_X+Parameters.length_Y-2,num_Repeats);        %Expected counts using standard PCF
analytic_Time = zeros(1,num_Repeats);                                                                   %Timing for analytical approach
numeric_Time = zeros(1,num_Repeats);                                                                    %Timing for numerical approach 
num_Agents_Av = zeros(1,num_Repeats);                                                                   %Number of agents in each simulation

for nRepeats = 1:num_Repeats                                                %Call pair_Correlation_Script to calculate oPCF for each realisation
    nRepeats
    parameters_Script;
    pair_Correlation_Script;
    pair_Distances_Av(:,nRepeats) = pair_Distances;
    numerical_Pair_Distances_Av(:,nRepeats) = numerical_Pair_Distances;
    expected_Numerical_Sites_Av(:,nRepeats) = expected_Numerical_Sites;
    expected_Analytic_Sites_Av(:,nRepeats) = expected_Analytic_Sites;
    pw_Normalisation_Av(:,nRepeats) = pw_Normalisation;
    total_Expected_Pair_Distances_Av(:,nRepeats) = total_Expected_Pair_Distances;
    num_Agents_Av(:,nRepeats) = Parameters.number_of_Agents;
    if strcmpi(timeCheck,'on')
        analytic_Time(nRepeats) = analytic_Time_i;
        numeric_Time(nRepeats) = numeric_Time_i;
    end
end

%% Plot Results

disp('Plotting results')
plot_Published_Results;