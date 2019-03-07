%% Script for numerically obtaining pair distances via a path-finding algorithm
% Obtains distances between sites via pathfinding algorithms
% Called by pair_Correlation_Script. Used to generate results from
% Corrected pair correlation functions for domains with obstacles" by
% Johnston and Crampin: https://arxiv.org/abs/1811.07518

if strcmpi(timeCheck,'on')
    tic
end
find_Neighbour_Sites                                                        %Calculate cell array of neighbour elements

nElements = length(neighbour_Elements_Structure);
elementAdjacencyMatrix = zeros(nElements);

closest_Centroid = find(lattice==1);                                        %Find locations of agents

for iElement = 1:nElements
    currentRow = neighbour_Elements_Structure{iElement};
    nNeighbours = length(currentRow);
    elementAdjacencyMatrix(iElement,[currentRow(:)]) = ones(1,nNeighbours); %Calculate adjacency matrix
end

neighbourDistanceArray = cell(nElements,1);
nPopulatedElements = length(closest_Centroid);
sparseElementAdjacencyMatrix = sparse(elementAdjacencyMatrix);
shortestPathLength = zeros(nPopulatedElements,nElements);

%% Calculate the shortest path distance between agents

for iElement = 1:nPopulatedElements

    [shortestPathLength(iElement,:),~,~] = graphshortestpath(sparseElementAdjacencyMatrix,closest_Centroid(iElement));

end

if strcmpi(timeCheck,'on')
    tOcc = toc;
end
if strcmpi(timeCheck,'on')
    tic
    notHole = find(lattice~=2);                                             %Find all accessible sites
    timerMatrix = zeros(numel(notHole),nElements);
    for iElement = 1:numel(notHole)
        [timerMatrix(iElement,:),~,~] = graphshortestpath(sparseElementAdjacencyMatrix,notHole(iElement));  %Calculate path distance between all accessible sites
    end
    tPF = toc;
end

%% Calculate number of pairs separated by all pair distances

numerical_Pair_Distances = zeros(max_Distance,1);
for i = 1:max_Distance
    numerical_Pair_Distances(i) = sum(sum(shortestPathLength(:,occupied_Sites)==i))/2;
end

%% Compare analytic and numerical pair distances

expected_Analytic_Sites = (Parameters.number_of_Agents/Parameters.number_of_Sites)*((Parameters.number_of_Agents-1)/(Parameters.number_of_Sites-1))*hole_Pair_Distances;
expected_Numerical_Sites = (Parameters.number_of_Agents/Parameters.number_of_Sites)*((Parameters.number_of_Agents-1)/(Parameters.number_of_Sites-1))*numerical_Pair_Distances;