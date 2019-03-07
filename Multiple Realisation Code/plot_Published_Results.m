%% Script for plotting results
% Plots results obtained from pair_Correlation_Script.
% Called by pair_Correlation_Script. Used to generate results from
% Corrected pair correlation functions for domains with obstacles" by
% Johnston and Crampin: https://arxiv.org/abs/1811.07518

%% Plot counts of pair distances as defined by Eq(18) (blue) and Eq(1) (red)
figure(2)
plot(1:max_Distance,hole_Pair_Distances,'linewidth',2)
hold on
plot(1:max_Distance,total_Pair_Distances,'r','linewidth',2)

%% Plot standard PCF (Eq(1) normalisation term, taxicab distance between agents)
figure(3)
plot(1:max_Distance,mean(pair_Distances_Av./pw_Normalisation_Av,2),'linewidth',2)
xlim([1 0.8*max_Distance])

%% Plot new oPCF (Eq(18) normalisation term, pathfinding for distance between agents)
figure(4)
plot(1:max_Distance,mean(numerical_Pair_Distances_Av./expected_Analytic_Sites_Av,2),'linewidth',2)
xlim([1 0.8*max_Distance])
