Parameters.length_X = 49;                                                                                                                   %Size of domain in the x dimension
Parameters.length_Y = 49;                                                                                                                   %Size of domain in the y dimension
Parameters.num_Hole_Rows = 24;                                                                                                               %Number of rows of holes/obstacles
Parameters.num_Hole_Columns = 24;                                                                                                            %Number of columns of holes/obstacles
Parameters.num_Holes = Parameters.num_Hole_Rows*Parameters.num_Hole_Columns;                                                                %Total number of clusters of holes/obstacles
Parameters.random_Generation = 'no';                                                                                                       %Is the domain randomly generated ('yes') or specified ('no')
hole_Start_X = [2:2:48];                                                                                                                          %Location of columns with holes/obstacles
hole_Start_Y = [2:2:48];                                                                                                                           %Location of rows with holes/obstacles       
hole_Length_X = ones(size(hole_Start_X));                                                                                                          %Size of obstacle clusters in x (same length as hole_Start_X variable)    
hole_Length_Y = ones(size(hole_Start_Y));                                                                                                          %Size of obstacle clusters in y (same length as hole_Start_Y variable)        

if strcmpi(Parameters.random_Generation,'no')
    Parameters.hole_Length_X = repmat(hole_Length_X,1,Parameters.num_Hole_Rows).*ones(1,Parameters.num_Hole_Rows*Parameters.num_Hole_Columns);     %Vector of sizes of clusters of obstacles in the x dimension
    Parameters.hole_Length_Y = repmat(hole_Length_Y,1,Parameters.num_Hole_Columns).*ones(1,Parameters.num_Hole_Rows*Parameters.num_Hole_Columns);        %Vector of sizes of clusters of obstacles in the y dimension
    Parameters.hole_Start_X = repmat(hole_Start_X,1,Parameters.num_Hole_Rows);                                                                    %Vector of obstacle cluster locations in the x dimension (minimum x value)
    Parameters.hole_Start_Y =reshape(repmat(hole_Start_Y,Parameters.num_Hole_Columns,1),1,Parameters.num_Hole_Rows*Parameters.num_Hole_Columns);  %Vector of obstacle cluster locations in the y dimension (minimum y value)
    Parameters.hole_End_Y = Parameters.hole_Length_Y+Parameters.hole_Start_Y-1;                                                               %Vector of obstacle cluster locations in the y dimension (maximum y value)
    Parameters.hole_End_X = Parameters.hole_Length_X+Parameters.hole_Start_X-1;                                                               %Vector of obstacle cluster locations in the x dimension (maximum x value)
end

Parameters.agent_Density = 0.2;                                                                                                               %Initial density of agents in random walk simulation
Parameters.agent_Density_Original = Parameters.agent_Density;                                                                               %Initial density of agents in random walk simulation
Parameters.num_Steps = 0;                                                                                                                   %Number of time steps in random walk simulation
Parameters.num_Hole_Steps = 0;
Parameters.prob_P = 0.1;                                                                                                                    %Proliferation probability in random walk simulation
Parameters.prob_M = 0.1;                                                                                                                    %Motility probability in random walk simulation
Parameters.num_Repeats = 20;                                                                                                                %Number of repeats of the random walk simulation
timeCheck = 'off';                                                                                                                          %Enable timing 'on' or 'off'

Parameters.truly_Random = 'no';                                                                                                             %Generate truly random domain (no restrictions) 'yes' or random subject to restrictions 'no'
Parameters.num_Inaccessible = 500;                                                                                                          %Number of obstacles, only used if truly random