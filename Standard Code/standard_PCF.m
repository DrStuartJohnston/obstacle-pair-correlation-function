%% Calculate the standard pair correlation function as per Gavagnin et al.
% Called by pair_Correlation_Script as part of the code generate results
% from "Corrected pair correlation functions for domains with obstacles" by
% Johnston and Crampin: https://arxiv.org/abs/1811.07518

lattice_Locations = find(lattice==1);

lattice_X_Values = ceil(lattice_Locations/Parameters.length_Y);             %Locations of agents in x
lattice_Y_Values = mod(lattice_Locations-1,Parameters.length_Y)+1;          %Locations of agents in y

pair_Distances = zeros(Parameters.length_X+Parameters.length_Y-2,1);
expected_Pair_Distances = zeros(numel(pair_Distances),1);
distance_Matrix = zeros(Parameters.number_of_Agents);


%% Calculate matrix of distances between all agents
for i = 1:Parameters.number_of_Agents
    for j = 1:Parameters.number_of_Agents
        distance_Matrix(i,j) = abs(lattice_X_Values(i)-lattice_X_Values(j)) + abs(lattice_Y_Values(i)-lattice_Y_Values(j));
    end
end

total_Lattice_Locations = find(lattice~=2);                                     %Location of accessible sites
total_Lattice_X_Values = ceil(total_Lattice_Locations/Parameters.length_Y);     %Location of accessible sites in x
total_Lattice_Y_Values = mod(total_Lattice_Locations-1,Parameters.length_Y)+1;  %Location of accessible sites in y
total_Distance_Matrix = zeros(numel(total_Lattice_Locations));

%% Calculate matrix of distances between all accessible lattice sites
for i = 1:numel(total_Lattice_Locations)
    for j = 1:numel(total_Lattice_Locations)
        total_Distance_Matrix(i,j) = abs(total_Lattice_X_Values(i)-total_Lattice_X_Values(j)) + abs(total_Lattice_Y_Values(i)-total_Lattice_Y_Values(j));
    end
end

total_Pair_Distances = zeros(numel(pair_Distances),1);
total_Expected_Pair_Distances = zeros(numel(pair_Distances),1);

%% Calculate number of pairs of agents/accessible sites separated by all possible distances
for i = 1:numel(pair_Distances)
    pair_Distances(i) = sum(sum(tril(distance_Matrix==i)));
    total_Pair_Distances(i) = sum(sum(tril(total_Distance_Matrix==i)));
    expected_Pair_Distances(i) = (Parameters.number_of_Agents/Parameters.number_of_Sites)*((Parameters.number_of_Agents-1)/(Parameters.number_of_Sites-1)) .* ...
        (2*i*Parameters.length_X*Parameters.length_Y - i^2*(Parameters.length_X+Parameters.length_Y) + (i^3-i)/3); %Expected number of pair distances between agents as per Gavagnin et al.
    total_Expected_Pair_Distances(i) = (Parameters.number_of_Agents/Parameters.number_of_Sites)*((Parameters.number_of_Agents-1)/(Parameters.number_of_Sites-1))*total_Pair_Distances(i); %Expected number of pair distances between accessible sites as per Gavagnin et al.
end
