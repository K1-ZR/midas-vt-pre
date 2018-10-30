function [Coor, Conn] = RCM(Coo, Con, NumRegEl)
%%
SetGlobal;
% this program reorder numbering based on reverse cuthill mckee algorithem
% input:
% Coo, Con (which includes only 3nodes reg elements or 3nodes reg elements + 4nodes coh elements)
% output:
% Coor, Conn (which includes only 3nodes reg elements or 3nodes reg elements + 4nodes coh elements)
% CohEl_Phase1, CohEl_Phase2, CohEl_InterPhase12

Coor = []; 
Conn = [];
%% =========================================================================
% Make Adjacency Matrix
AllNode = 1:size(Coo,1);
AdjMat= sparse(size(Coo,1),size(Coo,1));

% Regular elements
for EE = 1: NumRegEl
    ElNode = Con(EE,2:4); % +1 to skip the first column
    Adjacency = ismember(AllNode,ElNode);
    AdjMat(Adjacency,Adjacency)= 1;
end
% if there is Int El
if size(Con,1) > NumRegEl
    for EE = NumRegEl+1 : size(Con,1)
        ElNode = [Con(EE,2)   Con(EE,5)]; % corresponding nodes
        Adjacency = ismember(AllNode,ElNode); % 1-4 & 2-3
        AdjMat(Adjacency,Adjacency)= 1;
        
        ElNode = [Con(EE,3)   Con(EE,4)];
        Adjacency = ismember(AllNode,ElNode);
        AdjMat(Adjacency,Adjacency)= 1;
    end
end
% -------------------------------------------------------------------------
% % AdjMat
% disp('BandWidth Before RCM=');
% [i,j] = find(AdjMat);
% NodeAdjWidth = max(i-j) + 1;
% BandWidth = (NodeAdjWidth + 1)*2;
% disp(BandWidth);
% =========================================================================
% RCM
p = symrcm(AdjMat);

NewLabel = AllNode;
OldLabel = p;
% -------------------------------------------------------------------------
AdjMat = AdjMat(p,p);
% disp('BandWidth After RCM=');
[i,j] = find(AdjMat);
NodeAdjWidth = max(i-j) + 1;
BandWidth = (NodeAdjWidth + 1)*2;
% disp(BandWidth);
% =========================================================================
% Update Coo & Con
Coor = [NewLabel' Coo(OldLabel,2:3)];
% -------------------------------------------------------------------------
% if there is Int El
if size(Con,1) > NumRegEl
    MaxNPerEl=4+1;
else
    MaxNPerEl=3+1;
end

for EE = 1: size(Con,1)
    Conn(EE, 1)= Con(EE,1);
    
    for NN = 2: MaxNPerEl
        if Con(EE,NN)~=0
            Conn(EE, NN)= find(OldLabel==Con(EE,NN));
        elseif Con(EE,NN)==0
            Conn(EE, NN)= 0;
        end
    end
end
end







