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

function FindBCNode(Coo, Con, numRegEl)
SetGlobal;
%%
Tolerance = 1e-6;

TT_T = [];    TT_B = [];    TT_L = [];    TT_R = [];
ST_T = [];    ST_B = [];    
TPBT_LS = []; TPBT_RS = []; TPBT_LP = [];
FPBT_LS = []; FPBT_RS = []; FPBT_LLP = []; FPBT_RLP = [];
SCBT_LS = []; SCBT_RS = []; SCBT_LP = [];
ITT_BS = [];  ITT_TLP = []; 

for NN = 1:size(Coo,1)
    % =====================================================================
    if     TestType==1
        % top bottom left
        if      abs(Coo(NN,3)-max(Coo(:,3))) < Tolerance
            TT_T= [TT_T; NN];
        elseif  abs(Coo(NN,3)-min(Coo(:,3))) < Tolerance
            TT_B= [TT_B; NN];
        elseif  abs(Coo(NN,2)-min(Coo(:,2))) < Tolerance
            TT_L= [TT_L; NN];
        elseif  abs(Coo(NN,2)-max(Coo(:,2))) < Tolerance
            TT_R= [TT_R; NN];
        end
    % =====================================================================
    elseif     TestType==2
        % top Bottom
        if      abs(Coo(NN,3)-max(Coo(:,3))) < Tolerance
            ST_T= [ST_T; NN];
        elseif  abs(Coo(NN,3)-min(Coo(:,3))) < Tolerance
            ST_B= [ST_B; NN];
        end
    % =====================================================================
    elseif TestType==3
        % BCNode= leftsupport rightsupport  loadingpoint
        if     abs(Coo(NN,2)-(min(Coo(:,2))+Dim_a)) < Tolerance &&...
               abs(Coo(NN,3)-min(Coo(:,3))) < Tolerance
            TPBT_LS= [TPBT_LS; NN];
        elseif abs(Coo(NN,2)-(max(Coo(:,2))-Dim_a)) < Tolerance &&...
               abs(Coo(NN,3)-min(Coo(:,3))) < Tolerance
            TPBT_RS= [TPBT_RS; NN];
        elseif abs(Coo(NN,2)-(max(Coo(:,2))-min(Coo(:,2)))/2) < Tolerance && ...
               abs(Coo(NN,3)-max(Coo(:,3))) < Tolerance
            TPBT_LP= [TPBT_LP; NN];
        end
    % =====================================================================
    elseif TestType==4 % four point
        % BCNode= leftsupport rightsupport  leftloadingpoint rightloadingpoint
        if     abs(Coo(NN,2)-(min(Coo(:,2))+Dim_a)) < Tolerance &&...
               abs(Coo(NN,3)-min(Coo(:,3))) < Tolerance
            FPBT_LS= [FPBT_LS; NN];
        elseif abs(Coo(NN,2)-(max(Coo(:,2))-Dim_a)) < Tolerance &&...
               abs(Coo(NN,3)-min(Coo(:,3))) < Tolerance
            FPBT_RS= [FPBT_RS; NN];
        elseif abs(Coo(NN,2)-(min(Coo(:,2))+Dim_b)) < Tolerance && ...
               abs(Coo(NN,3)-max(Coo(:,3))) < Tolerance
            FPBT_LLP= [FPBT_LLP; NN];
        elseif abs(Coo(NN,2)-(max(Coo(:,2))-Dim_b)) < Tolerance && ...
               abs(Coo(NN,3)-max(Coo(:,3))) < Tolerance
            FPBT_RLP= [FPBT_RLP; NN];
        end
    % =====================================================================
    elseif TestType==5 
        % BCNode= leftsupport rightsupport  loadingpoint
        if     abs(Coo(NN,2)-(min(Coo(:,2))+Dim_a)) < Tolerance &&...
               abs(Coo(NN,3)-min(Coo(:,3))) < Tolerance
            SCBT_LS= [SCBT_LS; NN];
        elseif abs(Coo(NN,2)-(max(Coo(:,2))-Dim_a)) < Tolerance &&...
               abs(Coo(NN,3)-min(Coo(:,3))) < Tolerance
            SCBT_RS= [SCBT_RS; NN];
        elseif abs(Coo(NN,2)-(max(Coo(:,2))-min(Coo(:,2)))/2) < Tolerance && ...
               abs(Coo(NN,3)-max(Coo(:,3))) < Tolerance
            SCBT_LP= [SCBT_LP; NN];
        end
    % =====================================================================
    elseif TestType==6
        % BCNode= leftsupport rightsupport  loadingpoint
        if     abs(Coo(NN,2)-(max(Coo(:,2))-min(Coo(:,2)))/2) < Tolerance &&...
               abs(Coo(NN,3)-max(Coo(:,3))) < Tolerance
            ITT_TLP= [ITT_TLP; NN];
        elseif abs(Coo(NN,2)-(max(Coo(:,2))-min(Coo(:,2)))/2) < Tolerance &&...
               abs(Coo(NN,3)-min(Coo(:,3))) < Tolerance
            ITT_BS= [ITT_BS; NN];
        end
    end
end
end
