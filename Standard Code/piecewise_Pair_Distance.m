%% Script to calculate the normalisation and pair distancce terms for all m
% (Appendix A) for a given domain with no obstacles
% Called by pair_Correlation_Script. Used to generate results from
% Corrected pair correlation functions for domains with obstacles" by
% Johnston and Crampin: https://arxiv.org/abs/1811.07518

%% Calculate expected pair distances as per new information in Appendix

max_Distance = numel(pair_Distances);
pw_Pair_Distance = zeros(max_Distance,1);                                   %Combined counts of pair distances (Eq (1))
pw_Normalisation = zeros(max_Distance,1);                                   %Normalised pair distances
gavagnin_Distance = zeros(max_Distance,1);                                  %for m <= min(L_x,L_y)
linear_Distance = zeros(max_Distance,1);                                    %for min(L_x,L_y) < m < max(L_x,L_y)
pure_Distance = zeros(max_Distance,1);                                      %for m >= max(L_x,L_y)

min_Dimension = min(Parameters.length_X,Parameters.length_Y);
max_Dimension = max(Parameters.length_X,Parameters.length_Y);

%% Calculate normalisation as per Equation (1)

for i = 1:numel(pair_Distances)
    if i <= min_Dimension
        pw_Pair_Distance(i) = 2*i*Parameters.length_X*Parameters.length_Y - i^2*(Parameters.length_X+Parameters.length_Y) + (i^3-i)/3; 
    elseif i <= max_Dimension
        pw_Pair_Distance(i) = pw_Pair_Distance(min_Dimension) - min_Dimension^2*(i-min_Dimension);
    else
        k = Parameters.length_X + Parameters.length_Y - 1 - i;
        pw_Pair_Distance(i) = k*(k+1)*(k+2)/3;
    end
    pw_Normalisation(i) = pw_Pair_Distance(i)*(Parameters.number_of_Agents/(Parameters.length_X*Parameters.length_Y))*((Parameters.number_of_Agents-1)/(Parameters.length_X*Parameters.length_Y-1));
end

%% Calculate three separate components of normalisation across all pair distances

for i = 1:numel(pair_Distances)
   gavagnin_Distance(i) = 2*i*Parameters.length_X*Parameters.length_Y - i^2*(Parameters.length_X+Parameters.length_Y) + (i^3-i)/3;
   linear_Distance(i) = pw_Pair_Distance(min_Dimension) - min_Dimension^2*(i-min_Dimension);
   k = Parameters.length_X + Parameters.length_Y - 1 - i;
   pure_Distance(i) = k*(k+1)*(k+2)/3;
end