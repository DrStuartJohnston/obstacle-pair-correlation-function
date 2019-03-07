%% Script to calculate the obstacle pair correlation function (Eq (18)) for a given domain
% Called by pair_Correlation_Script. Used to generate results from
% Corrected pair correlation functions for domains with obstacles" by
% Johnston and Crampin: https://arxiv.org/abs/1811.07518

holes = find(lattice==2);
hole_Pair_Distances = pw_Pair_Distance;                                     %Pair distances according to Equation (1)

holes_X = ceil(holes/Parameters.length_Y);                                  %Locations of inaccessible sites in x
holes_Y = mod(holes-1,Parameters.length_Y)+1;                               %Locations of inaccessible sites in y

%% Inaccessible-accessible pairs 

for i = 1:numel(holes)
    
    %% Calculate distance to boundary in left, right, up, down directions
    b_L = holes_X(i);
    b_R = Parameters.length_X - b_L + 1;
    b_U = holes_Y(i);
    b_D = Parameters.length_Y - b_U + 1;
    b = [b_L;b_R;b_D;b_U];
    b_Corner = [b_L,b_D;b_L,b_U;b_R,b_D;b_R,b_U];
    
    %% Calculate distance to corners
    c_DL = b_L + b_D;
    c_DR = b_R + b_D;
    c_UL = b_L + b_U;
    c_UR = b_R + b_U;
    c = [c_DL;c_UL;c_DR;c_UR];
    
    alpha = zeros(max_Distance,1);
    A = zeros(max_Distance,1);
    
    %% Calculate inaccessible-accessible pairs as per Equation (7)
    
    for j = 1:max_Distance
        for k = 1:4
            if j >= b(k)
                alpha(j) = alpha(j) + 1;
            end
            if j >= min(b_Corner(k,:)) && j <= max(b_Corner(k,:))
                alpha(j) = alpha(j) + j - min(b_Corner(k,:));
            elseif j > max(b_Corner(k,:)) && j <= c(k)-1
                alpha(j) = alpha(j) + 2*j - c(k);
            elseif j > c(k)-1
                alpha(j) = alpha(j) + j - 1;
            end
        end
        A(j) = 4*j - alpha(j);
    end
    hole_Pair_Distances = hole_Pair_Distances - A;
end

%% Inaccessible-Inaccessible pairs 

double_Count = zeros(max_Distance,1);
holes_Diff = zeros(numel(holes),numel(holes));
for i = 1:numel(holes)
    holes_Diff(i,:) = abs(holes_X(i)-holes_X) + abs(holes_Y(i)-holes_Y);   %Calculate distances between inaccessible sites
    holes_Diff(1:numel(holes)+1:end) = 0;
end

%% Calculate inaccessible-inaccessible pairs as per Equation (8)

for i = 1:max_Distance
    double_Count(i) = sum(sum(tril(holes_Diff==i)));
end

hole_Pair_Distances = hole_Pair_Distances + double_Count;
hole_Pair_part1 = hole_Pair_Distances;

%% Calculate gained and lost pairs associated with rows

for i = 1:Parameters.num_Hole_Rows %Select row
    relevant_Holes_Start = Parameters.hole_Start_X((i-1)*Parameters.num_Hole_Columns+1:i*Parameters.num_Hole_Columns);  %Locations of clusters of inaccessible sites in x (minimum x value)
    relevant_Holes_End = Parameters.hole_End_X((i-1)*Parameters.num_Hole_Columns+1:i*Parameters.num_Hole_Columns);      %Locations of clusters of inaccessible sites in x (maximum x value)
    for j = 1:Parameters.num_Hole_Columns %Loop over columns
        num_Sections = Parameters.num_Hole_Columns-j+1;                                                                 %Calculate number of subsections within the row (see Figure 8 (b)-(c))
        %% Calculate effective subdomain and effective inaccessible cluster length/location
        for k = 1:num_Sections
            if k == 1 && k ~= num_Sections
                domain_Length = relevant_Holes_Start(j+1) - 1;
                shifted_Hole_Start = relevant_Holes_Start(1);
                shifted_Hole_End = relevant_Holes_End(j);
            elseif k ~= 1 && k ~= num_Sections
                domain_Length = relevant_Holes_Start(j+k) - relevant_Holes_End(k-1) - 1;
                shifted_Hole_Start = relevant_Holes_Start(k) - relevant_Holes_End(k-1);
                shifted_Hole_End = relevant_Holes_End(j+k-1) - relevant_Holes_End(k-1);
            elseif k == num_Sections && j ~= Parameters.num_Hole_Columns
                domain_Length = Parameters.length_X - relevant_Holes_End(k-1);
                shifted_Hole_Start = relevant_Holes_Start(k) - relevant_Holes_End(k-1);
                shifted_Hole_End = relevant_Holes_End(j+k-1) - relevant_Holes_End(k-1);
            else
                domain_Length = Parameters.length_X;
                shifted_Hole_Start = relevant_Holes_Start(1);
                shifted_Hole_End = relevant_Holes_End(j);
            end
            b_L = shifted_Hole_Start;
            b_R = domain_Length - shifted_Hole_End + 1;
            b = [b_L;b_R];
            hole_Length = shifted_Hole_End-shifted_Hole_Start+1;
            relevant_Location = (i-1)*Parameters.num_Hole_Columns+1;
            
            %% Calculate gain and loss vector associated with subdomain and influence on pair distances
            
            for l = 1:Parameters.hole_Length_Y(relevant_Location)
                gain_Vector = gain_Component(domain_Length+l-1,hole_Length+l-1,b);
                loss_Vector = loss_Component(domain_Length+l-1,hole_Length+l-1,b);
                if l ~= Parameters.hole_Length_Y(relevant_Location)
                    hole_Pair_Distances(1:length(gain_Vector)) = hole_Pair_Distances(1:length(gain_Vector)) + 2*l*gain_Vector;
                else
                    hole_Pair_Distances(1:length(gain_Vector)) = hole_Pair_Distances(1:length(gain_Vector)) + l*gain_Vector;
                end
                if l ~= 1
                    hole_Pair_Distances(1:length(gain_Vector)) = hole_Pair_Distances(1:length(gain_Vector)) - 2*(Parameters.hole_Length_Y(relevant_Location)-l+1)*loss_Vector;
                else
                    hole_Pair_Distances(1:length(gain_Vector)) = hole_Pair_Distances(1:length(gain_Vector)) - Parameters.hole_Length_Y(relevant_Location)*loss_Vector;
                end
            end
        end
    end
end

%% Vertical Adjustment

for i = 1:Parameters.num_Hole_Columns %Select column
    relevant_Holes_Start = Parameters.hole_Start_Y(i:Parameters.num_Hole_Columns:(Parameters.num_Hole_Rows-1)*Parameters.num_Hole_Columns+i);   %Locations of clusters of inaccessible sites in y (minimum y value)
    relevant_Holes_End = Parameters.hole_End_Y(i:Parameters.num_Hole_Columns:(Parameters.num_Hole_Rows-1)*Parameters.num_Hole_Columns+i);       %Locations of clusters of inaccessible sites in y (maximum y value)
    for j = 1:Parameters.num_Hole_Rows      %Loop over rows
        num_Sections = Parameters.num_Hole_Rows-j+1;
        %% Calculate effective subdomain and effective inaccessible cluster length/location
        for k = 1:num_Sections
            if k == 1 && k ~= num_Sections
                domain_Length = relevant_Holes_Start(j+1) - 1;
                shifted_Hole_Start = relevant_Holes_Start(1);
                shifted_Hole_End = relevant_Holes_End(j);
            elseif k ~= 1 && k ~= num_Sections
                domain_Length = relevant_Holes_Start(j+k) - relevant_Holes_End(k-1) - 1;
                shifted_Hole_Start = relevant_Holes_Start(k) - relevant_Holes_End(k-1);
                shifted_Hole_End = relevant_Holes_End(j+k-1) - relevant_Holes_End(k-1);
            elseif k == num_Sections && j ~= Parameters.num_Hole_Rows
                domain_Length = Parameters.length_Y - relevant_Holes_End(k-1);
                shifted_Hole_Start = relevant_Holes_Start(k) - relevant_Holes_End(k-1);
                shifted_Hole_End = relevant_Holes_End(j+k-1) - relevant_Holes_End(k-1);
            else
                domain_Length = Parameters.length_Y;
                shifted_Hole_Start = relevant_Holes_Start(1);
                shifted_Hole_End = relevant_Holes_End(j);
            end
            b_U = shifted_Hole_Start;
            b_D = domain_Length - shifted_Hole_End + 1;
            b = [b_U;b_D];
            hole_Length = shifted_Hole_End-shifted_Hole_Start+1;
            
            %% Calculate gain and loss vector associated with subdomain and influence on pair distances
            
            for l = 1:Parameters.hole_Length_X(i)
                gain_Vector = gain_Component(domain_Length+l-1,hole_Length+l-1,b);
                loss_Vector = loss_Component(domain_Length+l-1,hole_Length+l-1,b);
                if l ~= Parameters.hole_Length_X(i)
                    hole_Pair_Distances(1:length(gain_Vector)) = hole_Pair_Distances(1:length(gain_Vector)) + 2*l*gain_Vector;
                else
                    hole_Pair_Distances(1:length(gain_Vector)) = hole_Pair_Distances(1:length(gain_Vector)) + l*gain_Vector;
                end
                if l ~= 1
                    hole_Pair_Distances(1:length(gain_Vector)) = hole_Pair_Distances(1:length(gain_Vector)) - 2*(Parameters.hole_Length_X(i)-l+1)*loss_Vector;
                else
                    hole_Pair_Distances(1:length(gain_Vector)) = hole_Pair_Distances(1:length(gain_Vector)) - Parameters.hole_Length_X(i)*loss_Vector;
                end
            end
        end
    end
end

