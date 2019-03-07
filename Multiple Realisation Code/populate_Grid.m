%% Script for populating the domain with agents
% Populates grid as defined in parameters_Script.
% Called by pair_Correlation_Script. Used to generate results from
% Corrected pair correlation functions for domains with obstacles" by
% Johnston and Crampin: https://arxiv.org/abs/1811.07518

if strcmpi(Parameters.truly_Random,'yes') % Calculate number of accessible sites in the domain
    Parameters.number_of_Sites = Parameters.length_X*Parameters.length_Y-sum(sum(lattice==2));
else
    Parameters.number_of_Sites = Parameters.length_X*Parameters.length_Y-sum(Parameters.hole_Length_X.*Parameters.hole_Length_Y);
end
Parameters.number_of_Agents_Original = ceil(Parameters.agent_Density_Original*Parameters.number_of_Sites);  %Calculate number of agents to place on domain

empty_Sites = find(lattice==0);                                                                             %Find accessible site locations

Parameters.number_of_Agents_Original = min(Parameters.number_of_Agents_Original,numel(empty_Sites));        %Sanity check

for i = 1:Parameters.number_of_Agents_Original %Place agents on accessible sites at random
    selected_Site = empty_Sites(ceil(numel(empty_Sites)*rand(1,1)));
    lattice(selected_Site) = 1;
    empty_Sites = setdiff(empty_Sites,selected_Site);
end

lattice_Random_Walk                                                                                         %Allow agents to undergo random walk

Parameters.number_of_Agents = sum(sum(lattice==1));                                                         %Calculate number of agents after the random walk
Parameters.agent_Density = Parameters.number_of_Agents/Parameters.number_of_Sites;                          %Calculate new agent density

figure(1) %Visualise domain with agents
spy(lattice==1,10,'r')
pause(0.01)