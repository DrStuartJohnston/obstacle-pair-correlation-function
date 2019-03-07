%% Script for finding neighbouring sites
% Determines connectivity of lattice sites in order to use pathfinding
% algorithms to find the distance between sites.
% Called by calculate_Hole_Agent_Pair_Distances. Used to generate results from
% Corrected pair correlation functions for domains with obstacles" by
% Johnston and Crampin: https://arxiv.org/abs/1811.07518

accessible_Sites = find(lattice~=2);                                                    %Locations of accessible sites
holes = find(lattice==2);                                                               %Locations of inaccesible sites
neighbour_Elements_Structure = cell(Parameters.length_X*Parameters.length_Y,1);         %Cell array of neighbouring sites for a particular site

column_Lattice = lattice(:);
element_Lattice = 1:numel(column_Lattice);

for i = 1:Parameters.length_X*Parameters.length_Y
    if column_Lattice(i) ~= 2
        neighbour_Sites_Y = find(abs(element_Lattice-element_Lattice(i))==1&ceil(element_Lattice/Parameters.length_Y)==ceil(element_Lattice(i)/Parameters.length_Y));
        neighbour_Sites_X = find(abs(element_Lattice-element_Lattice(i))==Parameters.length_Y);
        neighbour_Elements_Structure{i} = element_Lattice(setdiff([neighbour_Sites_X,neighbour_Sites_Y],holes));
    end
end