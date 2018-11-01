function [Coor, Conn]=AddCohEl(Coo, Con, NumRegEl)
%%
SetGlobal
% this program only works with triangular (3_Node) mesh (NOT with mix of 4-node and 3_node )
% input:
% Coo, Con (which includes only 3nodes reg elements)
% output:
% Coor, Conn (which includes 3nodes reg elements + 4nodes coh elements)
% CohEl_Phase1, CohEl_Phase2, CohEl_InterPhase12

Coor = []; 
Conn = [];
% =========================================================================
% Finding Neighbering Elements
T = Con(:,2:4);
P = Coo(:,2:3);

TR = triangulation(T,P);

N = neighbors(TR);
% By convention, N(i,j) is the neighbor opposite the jth vertex of ti(i).
% If a triangle or tetrahedron has one or more boundary facets, the nonexistent neighbors are represented as NaN values in TN.
% V1   V2   V3
% Edge2 Edge3 Edge1
% -------------------------------------------------------------------------
% Make the NeiberEl
% 1      2   
% El1  El2 
NeiberEl = [];
for EE = 1:size(N,1)
    for VV = 1:size(N,2)
        if ~isnan(N(EE,VV))  && ...
            EE < N(EE,VV)    && ...
            (ismember(EE,El_CZ) || ismember(N(EE,VV),El_CZ))
            
            NeiberEl = [NeiberEl;
                        EE, N(EE,VV)];
 
        end
    end
end  
% =========================================================================
% Duplicating Nodes

% Find "inner" CZ Nodes (not nodes shared with elements outside CZ)
Node_CZ=[1:size(Coo,1)]';
for EE = 1:NumRegEl
    if ~ismember(EE,El_CZ)
        Node_CZ = setdiff(Node_CZ,Con(EE,2:4));
    end
end

% Total Number of required nodes
TotNumReqNode = numel(El_CZ)*3; 
% -------------------------------------------------------------------------
% Making Conn which is connectivity matrix after duplicating new nodes
NewNodeStrorage = [Node_CZ; ...
                   [size(Coo,1)+1 : size(Coo,1)+(TotNumReqNode-size(Node_CZ,1))]'];

Conn = Con;
Keyvan=1;
for AA = 1:numel(El_CZ)
    EE = El_CZ(AA);
    Conn(EE,2:4) = NewNodeStrorage(Keyvan:Keyvan+2);
    Keyvan = Keyvan+3;
end 
% -------------------------------------------------------------------------  
% Making Coor which inculdes duplicated new nodes
Coor = Coo;
for AA = 1:numel(El_CZ)
    EE = El_CZ(AA);
    for NN = 2:4
        Coor(Conn(EE,NN),1:3)= [Conn(EE,NN)  Coo(Con(EE,NN),2:3)];
    end
end 
% =========================================================================
CohEl_Phase1       =[];
CohEl_Phase2       =[];
CohEl_InterPhase12 =[];

CohElCounter = NumRegEl;

% tic
for CE = 1:size(NeiberEl,1)
    
%     disp(CE/size(NeiberEl,1));
    
    EE = NeiberEl(CE,1);
    EEE = NeiberEl(CE,2);

    [ El_Cen_A, El_Edge_A, El_EdgeCen_A ] = El_Specs( EE, Coor, Conn );
    [ El_Cen_B, El_Edge_B, El_EdgeCen_B ] = El_Specs( EEE, Coor, Conn );

    [CC,iA,iB] = intersect(El_EdgeCen_A, El_EdgeCen_B,'rows');

    EdgeA = [Coor(El_Edge_A(iA,1) ,2:3);
             Coor(El_Edge_A(iA,2) ,2:3)];

    EdgeB = [Coor(El_Edge_B(iB,1) ,2:3);
             Coor(El_Edge_B(iB,2) ,2:3)];

    [~,iAA,iBB] = intersect(EdgeA,EdgeB,'rows');
    %==========================================================
    % Defining Coh Elements
    A1 = El_Edge_A(iA,iAA(1));% EdgeA_NodeA
    A2 = El_Edge_A(iA,iAA(2));            % A_1 0----0 B_1
                                          %     |    |
    B1 = El_Edge_B(iB,iBB(1));            %     |    |
    B2 = El_Edge_B(iB,iBB(2));            % A_2 0----0 B_2 
    %==========================================================
    % Correct Numbering    
    % A-1  A_2  B_1  B_2
    CACB = El_Cen_B - El_Cen_A;
    A1_A2 = Coor(A2,2:3) - Coor(A1,2:3);
    
    if sum(cross([A1_A2 0],[CACB 0]))<=0
        NewCohEl=[A2 A1 B1 B2];
    end
    if sum(cross([A1_A2 0],[CACB 0]))>=0
        NewCohEl=[A1 A2 B2 B1];
    end
    % ---------------------------------------------------------------------
    A1_A2 = Coor(NewCohEl(2),2:3) - Coor(NewCohEl(1),2:3);
    
    if     A1_A2(1)>=0  && A1_A2(2)>=0; Quadrant=1;
    elseif A1_A2(1)<0   && A1_A2(2)>0;  Quadrant=2;
    elseif A1_A2(1)<=0  && A1_A2(2)<=0; Quadrant=3;
    elseif A1_A2(1)>0   && A1_A2(2)<0;  Quadrant=4;end
    
    if Quadrant==2 || Quadrant==3
        NewCohEl = [NewCohEl(3) NewCohEl(4) NewCohEl(1) NewCohEl(2)];
    end
    % ---------------------------------------------------------------------
    CohElCounter = CohElCounter + 1;
    Conn(CohElCounter, 1:5) = [CohElCounter,  NewCohEl];

    if     ismember(EE,El_Phase1) && ismember(EEE,El_Phase1)
        CohEl_Phase1= [CohEl_Phase1;    CohElCounter];

    elseif ismember(EE,El_Phase2) && ismember(EEE,El_Phase2)
        CohEl_Phase2= [CohEl_Phase2;    CohElCounter];

    elseif (ismember(EE,El_Phase1) && ismember(EEE,El_Phase2)) ||...
           (ismember(EE,El_Phase2) && ismember(EEE,El_Phase1))
        CohEl_InterPhase12= [CohEl_InterPhase12;    CohElCounter];
    end
                                
end
% toc

end






