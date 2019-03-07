%% Script for populating the domain with obstacles at random
% Populates domain as defined in parameters_Script.
% Called by pair_Correlation_Script. Used to generate results from
% Corrected pair correlation functions for domains with obstacles" by
% Johnston and Crampin: https://arxiv.org/abs/1811.07518

if strcmpi(Parameters.truly_Random,'no')                                                                %Generate domain subject to restrictions on oPCF

max_Number_Holes_Y = min(Parameters.length_Y - Parameters.num_Hole_Rows - 1,Parameters.length_Y);       %Maximum number of rows of clusters of obstacles
max_Number_Holes_X = min(Parameters.length_X - Parameters.num_Hole_Columns - 1,Parameters.length_X);    %Maximum number of columns of clusters of obstacles   
if max_Number_Holes_Y < Parameters.num_Hole_Rows                                                        %Sanity check
    error('Redefine number of rows')
end
if max_Number_Holes_X < Parameters.num_Hole_Columns                                                     %Sanity check
    error('Redefine number of rows')
end

%% Generate random size and location of clusters in y
hole_Size_Vertical = diff(sort(randperm(max_Number_Holes_Y,Parameters.num_Hole_Rows+1)));               
random_Shuffle = randperm(numel(hole_Size_Vertical),numel(hole_Size_Vertical));
hole_Size_Vertical = hole_Size_Vertical(random_Shuffle);                                                %Size of clusters of obstacles in y dimension
remaining_Vertical = Parameters.length_Y - sum(hole_Size_Vertical);
split_tmp = sort(randperm(remaining_Vertical,numel(hole_Size_Vertical)+1));
split_Vertical = diff([split_tmp remaining_Vertical]);
rand_Loc = ceil(numel(split_Vertical));
split_Vertical(rand_Loc) = split_Vertical(rand_Loc) + split_tmp(1);
hole_Start_tmp = split_Vertical;
hole_Start_tmp(2:end-1) = hole_Start_tmp(2:end-1) + hole_Size_Vertical(1:end-1);
hole_Start_Y = cumsum(hole_Start_tmp)+1;
hole_Start_Y = hole_Start_Y(1:end-1);                                                                   %Location of clusters of obstacles in y (minimum y value)
%% Generate random size and location of clusters in x
hole_Size_Horizontal = diff(sort(randperm(max_Number_Holes_X,Parameters.num_Hole_Columns+1)));
random_Shuffle = randperm(numel(hole_Size_Horizontal),numel(hole_Size_Horizontal));
hole_Size_Horizontal = hole_Size_Horizontal(random_Shuffle);                                            %Size of clusters of obstacles in x dimension
remaining_Horizontal = Parameters.length_X - sum(hole_Size_Horizontal);
split_tmp = sort(randperm(remaining_Horizontal,numel(hole_Size_Horizontal)+1));
split_Horizontal = diff([split_tmp remaining_Horizontal]);
rand_Loc = ceil(numel(split_Horizontal));
split_Horizontal(rand_Loc) = split_Horizontal(rand_Loc) + split_tmp(1);
hole_Start_tmp = split_Horizontal;
hole_Start_tmp(2:end-1) = hole_Start_tmp(2:end-1) + hole_Size_Horizontal(1:end-1);
hole_Start_X = cumsum(hole_Start_tmp)+1;
hole_Start_X = hole_Start_X(1:end-1);                                                                   %Location of clusters of obstacles in x (minimum x value)

%% Lineup restriction

hole_Start_X = repmat(hole_Start_X',1,Parameters.num_Hole_Rows);                                        %Vector of obstacle cluster locations in the x dimension (minimum x value)
hole_Size_Horizontal = repmat(hole_Size_Horizontal',1,Parameters.num_Hole_Rows);                        %Vector of obstacle cluster sizes in the x dimension
hole_Start_Y = repmat(hole_Start_Y,Parameters.num_Hole_Columns,1);                                      %Vector of obstacle cluster locations in the y dimension (minimum y value)
hole_Size_Vertical = repmat(hole_Size_Vertical,Parameters.num_Hole_Columns,1);                          %Vector of obstacle cluster sizes in the y dimension

%% Allocate to parameter structure

Parameters.hole_Start_X = hole_Start_X(:)';
Parameters.hole_Start_Y = hole_Start_Y(:)';
Parameters.hole_Length_X = hole_Size_Horizontal(:)';
Parameters.hole_Length_Y = hole_Size_Vertical(:)';
Parameters.hole_End_Y = Parameters.hole_Length_Y+Parameters.hole_Start_Y-1;
Parameters.hole_End_X = Parameters.hole_Length_X+Parameters.hole_Start_X-1;

elseif strcmpi(Parameters.truly_Random,'yes')                                                           %Generate domain with truly random obstacle placement
    site = zeros(Parameters.num_Inaccessible,1);
   for i = 1:Parameters.num_Inaccessible
       site(i) = ceil(Parameters.length_Y*Parameters.length_X*rand);                                    %Populate domain sites with obstacles
   end
end