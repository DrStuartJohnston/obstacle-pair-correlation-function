function loss_Vector = loss_Component(length,hole_Width,b)

%% Calculate lost pairs for a given subdomain length, cluster size, and distance to boundary

loss_Vector = zeros(length+1,1);
min_Edge_Length = min(b-1);

for i = hole_Width+1:numel(loss_Vector)-2
    max_Pairs = -1*abs(i-0.5*(hole_Width+length))+0.5*(-hole_Width+length);
    loss_Vector(i) = min(max_Pairs,min_Edge_Length);
end