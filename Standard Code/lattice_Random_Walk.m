%% Script for performing a lattice-based random walk
% Used to simulate proliferation and motion of agents on the specified domain.
% Called by populate_Grid. Used to generate results from
% Corrected pair correlation functions for domains with obstacles" by
% Johnston and Crampin: https://arxiv.org/abs/1811.07518

prob_P = Parameters.prob_P;
prob_M = Parameters.prob_M;

occupied_Sites = find(lattice==1);
num_Occupied_Sites = numel(occupied_Sites);

%% Perform exclusion-based random walk on a lattice with motion and proliferation

for nStep = 1:Parameters.num_Steps                                          %Loop over time steps
    for nAgent = 1:num_Occupied_Sites                                       %Loop over agents
        attempt = rand;
        if attempt < prob_P                                                 %Proliferation event
            selected = 0;
            while selected == 0                                             %Select agent
                agent = ceil(numel(lattice)*rand);
                if lattice(agent) == 1
                    selected = 1;
                end
            end
            direction = ceil(4*rand);                                       %Select site for proliferation
            if direction == 1 && mod(agent,Parameters.length_Y) ~= 1
                if  lattice(agent-1) == 0
                    lattice(agent-1) = 1;
                end
            elseif direction == 2 && mod(agent,Parameters.length_Y) ~= 0
                if lattice(agent+1) == 0
                    lattice(agent+1) = 1;
                end
            elseif direction == 3 && agent > Parameters.length_Y
                if lattice(agent-Parameters.length_Y) == 0
                    attice(agent-Parameters.length_Y) = 1;
                end
            elseif direction == 4 && agent <= numel(lattice)-Parameters.length_Y
                if lattice(agent+Parameters.length_Y) == 0
                    lattice(agent+Parameters.length_Y) = 1;
                end
            end
        end
    end
    for nAgent = 1:num_Occupied_Sites                                       %Loop over agents
        attempt = rand;
        if attempt < prob_M                                                 %Movement event
            selected = 0;
            while selected == 0                                             %Select agent
                agent = ceil(numel(lattice)*rand);
                if lattice(agent) == 1
                    selected = 1;
                end
            end
            direction = ceil(4*rand);                                       %Select site for movement
            if direction == 1  && mod(agent,Parameters.length_Y) ~= 1
                if lattice(agent-1) == 0
                    lattice(agent-1) = 1;
                    lattice(agent) = 0;
                end
            elseif direction == 2 && mod(agent,Parameters.length_Y) ~= 0
                if lattice(agent+1) == 0
                    lattice(agent+1) = 1;
                    lattice(agent) = 0;
                end
            elseif direction == 3 && agent > Parameters.length_Y
                if lattice(agent-Parameters.length_Y) == 0
                    lattice(agent-Parameters.length_Y) = 1;
                    lattice(agent) = 0;
                end
            elseif direction == 4 && agent <= numel(lattice)-Parameters.length_Y
                if lattice(agent+Parameters.length_Y) == 0
                    lattice(agent+Parameters.length_Y) = 1;
                    lattice(agent) = 0;
                end
            end
        end
    end
    occupied_Sites = find(lattice==1);                                      %New occupied sites
    num_Occupied_Sites = numel(occupied_Sites);
end

if strcmpi(Parameters.truly_Random,'no')                                    %Redefine number of agents and density
    Parameters.number_of_Agents = num_Occupied_Sites;
    Parameters.agent_Density = Parameters.number_of_Agents/Parameters.number_of_Sites;
end