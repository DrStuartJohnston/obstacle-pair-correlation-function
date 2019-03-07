%% Script for generating the domains specified in parameters_Script
% Script is called using pair_Correlation_Script.
% Generates and visualies the domain specified in parameters_Script. 
% Used to generate results from
% Corrected pair correlation functions for domains with obstacles" by
% Johnston and Crampin: https://arxiv.org/abs/1811.07518

lattice = zeros(Parameters.length_Y,Parameters.length_X);                                                                                               %Define grid of accessible/inaccessible sites

%% Visualise domain

figure(1)
close(1)
figure(1)
line(0.5:Parameters.length_X+0.5,0.5*ones(1,Parameters.length_X+1),'col','k','linewidth',2)
hold on
line(0.5*ones(1,Parameters.length_Y+1),0.5:Parameters.length_Y+0.5,'col','k','linewidth',2)
line(0.5:Parameters.length_X+0.5,(Parameters.length_Y+0.5)*ones(1,Parameters.length_X+1),'col','k','linewidth',2)
line((Parameters.length_X+0.5)*ones(1,Parameters.length_Y+1),0.5:Parameters.length_Y+0.5,'col','k','linewidth',2)
axis([0 Parameters.length_X+1 0 Parameters.length_Y+1])
box on

%% Generate and populate domain

if strcmpi(Parameters.truly_Random,'no')
    for i = 1:Parameters.num_Holes
        hole_Locations_Y = Parameters.hole_Start_Y(i):Parameters.hole_End_Y(i);                                                                         %Locations of inaccessible sites in y dimension
        hole_Locations_X = Parameters.hole_Start_X(i):Parameters.hole_End_X(i);                                                                         %Locations of inaccessible sites in x dimension    
        lattice(hole_Locations_Y,hole_Locations_X) = 2;                                                                                                 %Set inaccessible sites in domain to 2                              
        
        %% Visualise obstacles on domain
        
        hole_Corners_Y = [Parameters.hole_Start_Y(i)-0.5,Parameters.hole_End_Y(i)+0.5,Parameters.hole_End_Y(i)+0.5,Parameters.hole_Start_Y(i)-0.5];
        hole_Corners_X = [Parameters.hole_Start_X(i)-0.5,Parameters.hole_Start_X(i)-0.5,Parameters.hole_End_X(i)+0.5,Parameters.hole_End_X(i)+0.5];
        fill(hole_Corners_X,hole_Corners_Y,'k')
    end
elseif strcmpi(Parameters.truly_Random,'yes') %Generate domain under no restrictions
    lattice(site) = 1;
    tmp = Parameters.num_Steps;
    Parameters.num_Steps = Parameters.num_Hole_Steps;
    lattice_Random_Walk;                      %Allow obstacles to undergo random walk to obtain randomly clustered groups ob stacles                                                                                                                              %Allows the obstacles to be clustered via proliferative random walk, unnecessary              
    Parameters.num_Steps = tmp;
    lattice(lattice==1) = 2;
    Parameters.num_Inaccessible = sum(sum(lattice==2));                                                                                                 %Calculate number of inaccessible sites
    site = find(lattice==2);
    site_X = ceil(site/Parameters.length_Y);                                                                                                            %Locations of inaccessible sites in y dimension 
    site_Y = mod(site-1,Parameters.length_Y)+1;                                                                                                         %Locations of inaccessible sites in x dimension             
    for i = 1:Parameters.num_Inaccessible %Visualise obstacles on domain
        hole_Corners_Y = [site_Y(i)-0.5,site_Y(i)+0.5,site_Y(i)+0.5,site_Y(i)-0.5];
        hole_Corners_X = [site_X(i)-0.5,site_X(i)-0.5,site_X(i)+0.5,site_X(i)+0.5];
        fill(hole_Corners_X,hole_Corners_Y,'k')
    end
end


