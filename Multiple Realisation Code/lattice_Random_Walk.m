prob_P = Parameters.prob_P;
prob_M = Parameters.prob_M;

occupied_Sites = find(lattice==1);
num_Occupied_Sites = numel(occupied_Sites);

for nStep = 1:Parameters.num_Steps
    for nAgent = 1:num_Occupied_Sites
        attempt = rand;
        if attempt < prob_P
            selected = 0;
            while selected == 0
                agent = ceil(numel(lattice)*rand);
                if lattice(agent) == 1
                    selected = 1;
                end
            end
            direction = ceil(4*rand);
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
    for nAgent = 1:num_Occupied_Sites
        attempt = rand;
        if attempt < prob_M
            selected = 0;
            while selected == 0
                agent = ceil(numel(lattice)*rand);
                if lattice(agent) == 1
                    selected = 1;
                end
            end
            direction = ceil(4*rand);
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
    occupied_Sites = find(lattice==1);
    num_Occupied_Sites = numel(occupied_Sites);
    %     figure(1)
    %     hold off
    %     spy(lattice==1,10,'r')
    %     pause(0.01)
end

if strcmpi(Parameters.truly_Random,'no')
    Parameters.number_of_Agents = num_Occupied_Sites;
    Parameters.agent_Density = Parameters.number_of_Agents/Parameters.number_of_Sites;
end