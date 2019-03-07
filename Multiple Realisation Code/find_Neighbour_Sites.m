accessible_Sites = find(lattice~=2);
holes = find(lattice==2);
neighbour_Elements_Structure = cell(Parameters.length_X*Parameters.length_Y,1);

column_Lattice = lattice(:);
element_Lattice = 1:numel(column_Lattice);

for i = 1:Parameters.length_X*Parameters.length_Y
    if column_Lattice(i) ~= 2
        neighbour_Sites_Y = find(abs(element_Lattice-element_Lattice(i))==1&ceil(element_Lattice/Parameters.length_Y)==ceil(element_Lattice(i)/Parameters.length_Y));
        neighbour_Sites_X = find(abs(element_Lattice-element_Lattice(i))==Parameters.length_Y);
        neighbour_Elements_Structure{i} = element_Lattice(setdiff([neighbour_Sites_X,neighbour_Sites_Y],holes));
    end
end