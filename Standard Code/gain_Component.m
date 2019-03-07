%% Function to calculate gained pairs for a given subdomain
% Called by n_Hole_PCF. Used to generate results from
% Corrected pair correlation functions for domains with obstacles" by
% Johnston and Crampin: https://arxiv.org/abs/1811.07518

function gain_Vector = gain_Component(length,hole_Width,b)

%% Calculate gained pairs for a given subdomain length, cluster size, and distance to boundary

gain_Vector = zeros(length+1,1);
min_Edge_Length = min(b-1);

for i = hole_Width+1:numel(gain_Vector)-2
    max_Pairs = -1*abs(i-0.5*(hole_Width+length))+0.5*(-hole_Width+length);
    gain_Vector(i+2) = min(max_Pairs,min_Edge_Length);
end