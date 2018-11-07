%    MIDAS-VT-Pre Copyright (C) 2018  Keyvan Zare-Rami
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <https://www.gnu.org/licenses/>.

function MeshData2MIDASLibrary(Coo, Con)
%%
SetGlobal;
% =========================================================================
NF = 0;                                                         
% =========================================================================
if     TestType == 1
        
    NDBC  = length(TT_T) + 2*length(TT_B) ;
    NDISP = NDBC;      
    % degree of freedom
    NDOF = [ 2*TT_B'-1   ... 
             2*TT_B'   ...                        
             2*TT_T'];  

    DINC = [zeros(1,length(TT_B))  ...
            zeros(1,length(TT_B))  ...
             ones(1,length(TT_T))];
elseif     TestType == 2
        
    NDBC  = 2*length(ST_B) + 2*length(ST_T) ;
    NDISP = NDBC;      
    % degree of freedom
    NDOF = [2*ST_B'-1 ...
            2*ST_B'   ...                        
            2*ST_T'-1 ...
            2*ST_T'];  

    DINC = [zeros(1,length(ST_B))  ...
            zeros(1,length(ST_B))  ...
             ones(1,length(ST_T)) ...
            zeros(1,length(ST_T))];
        
elseif TestType == 3
    NDBC  = size(TPBT_LS,1) + size(TPBT_RS,1) + 2*size(TPBT_LP,1);
    NDISP = NDBC;      
    % degree of freedom
    NDOF = [2*TPBT_LS'   ...                        
            2*TPBT_RS'   ... 
            2*TPBT_LP'-1 ...
            2*TPBT_LP'];  

    DINC = [zeros(1,size(TPBT_LS,1))  ...
            zeros(1,size(TPBT_RS,1))  ...
            zeros(1,size(TPBT_LP,1))  ...
            -ones(1,size(TPBT_LP,1))];
elseif TestType == 4 %4point
    NDBC  = size(FPBT_LS,1) + size(FPBT_RS,1) + 2*size(FPBT_LLP,1) + 2*size(FPBT_RLP,1);
    NDISP = NDBC;      
    % degree of freedom
    NDOF = [2*FPBT_LS'   ...                        
            2*FPBT_RS'   ... 
            2*FPBT_LLP'-1 ...
            2*FPBT_LLP' ...
            2*FPBT_RLP'-1 ...
            2*FPBT_RLP'];  

    DINC = [zeros(1,size(FPBT_LS,1))  ...
            zeros(1,size(FPBT_RS,1))  ...
            zeros(1,size(FPBT_LLP,1))  ...
            -ones(1,size(FPBT_LLP,1)) ...
            zeros(1,size(FPBT_RLP,1))  ...
            -ones(1,size(FPBT_RLP,1))];
        
elseif TestType == 5
    NDBC  = size(SCBT_LS,1) + size(SCBT_RS,1) + 2*size(SCBT_LP,1);
    NDISP = NDBC;      
    % degree of freedom
    NDOF = [2*SCBT_LS'   ...                        
            2*SCBT_RS'   ... 
            2*SCBT_LP'-1 ...
            2*SCBT_LP'];  

    DINC = [zeros(1,size(SCBT_LS,1))  ...
            zeros(1,size(SCBT_RS,1))  ...
            zeros(1,size(SCBT_LP,1))  ...
            -ones(1,size(SCBT_LP,1))];
elseif TestType == 6 %ITT
    NDBC  = 2*size(ITT_BS,1) + 2*size(ITT_TLP,1);
    NDISP = NDBC;      
    % degree of freedom
    NDOF = [2*ITT_BS'-1  ...                        
            2*ITT_BS'   ... 
            2*ITT_TLP'-1 ...
            2*ITT_TLP'];  

    DINC = [zeros(1,size(ITT_BS,1))  ...
            zeros(1,size(ITT_BS,1))  ...
            zeros(1,size(ITT_TLP,1))  ...
            -ones(1,size(ITT_TLP,1))];
end
%==========================================================================
% Coo_C_RCM : NODE NO.    A1      A2
Coo = Coo;
% =========================================================================
% Con_C_RCM : ELEMENT NO.   NODE 1  NODE 2  NODE 3  [NODE 4]
% Con :       ELEMENT NO.	NODE 1	NODE 2	NODE 3	MATSET	MTYPE	THETA
for EE = 1:NumRegEl % only bulk El
    if ismember( Con(EE,1) , El_Phase1 )
        BulElType = 1;
    elseif ismember( Con(EE,1) , El_Phase2 )
        BulElType = 2;
    end
    Con(EE,5:7)=[BulElType  BulElType  0];
end

% =========================================================================
% Con_C_RCM : ELEMENT NO.   NODE 1  NODE 2  NODE 3  [NODE 4]
% IntEl :     NODE 1    NODE 2   MAT NO.   WIDTH     PHIAV
%             NODE 3    NODE 4   MAT NO.   WIDTH     PHIAV
IntEl = [];
IntElCounter = 0;
if size(Con,1) > NumRegEl
    for EE = NumRegEl+1 : size(Con,1)
        
        if     ismember( EE , CohEl_Phase1 )
            IntElType=1;
        elseif ismember( EE , CohEl_Phase2 )
            IntElType=3;
        elseif ismember( EE , CohEl_InterPhase12 )
            IntElType=2;
        end
        
        X1 = Coo( Con(EE,2) , 2 );
        Y1 = Coo( Con(EE,2) , 3 );
        
        X2 = Coo( Con(EE,3) , 2 );
        Y2 = Coo( Con(EE,3) , 3 );
        
        Width = ( (X1-X2)^2 + (Y1-Y2 )^2 )^0.5;
        
        Alpha= atan((Y2-Y1)/(X2-X1));
        
        IntElCounter = IntElCounter+1;
        IntEl(2*IntElCounter-1 , :) = [ Con(EE,5)     Con(EE,2)   IntElType    Width     Alpha ];
        IntEl(2*IntElCounter   , :) = [ Con(EE,4)     Con(EE,3)   IntElType    Width     Alpha ];
    end
    
end
% =========================================================================
% SAVE INTO 
save([OutputFileName '_MIDASLibrary.mat'],...
    'NF', 'NDBC', 'Coo', 'Con', 'NDISP', 'NDOF', 'DINC', 'IntEl',...
    'BandWidth', 'TestType', 'HeteroIndex',...
    'NumRegEl', 'El_Phase1', 'El_Phase2', 'El_CZ',...
    'CohEl_Phase1', 'CohEl_Phase2', 'CohEl_InterPhase12',...
    'TT_T', 'TT_B', 'TT_L',...
    'ST_T', 'ST_B',...
    'TPBT_LS', 'TPBT_RS', 'TPBT_LP',...
    'FPBT_LS', 'FPBT_RS', 'FPBT_LLP', 'FPBT_RLP',...
    'SCBT_LS', 'SCBT_RS', 'SCBT_LP',...
    'ITT_BS', 'ITT_TLP');%, '-append'

end

