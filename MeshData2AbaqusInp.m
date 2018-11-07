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

function MeshData2AbaqusInp(Coo, Con)
SetGlobal;

% if isempty(MixtureImagePath)
%     [FilePath,FileName,FileExt] = fileparts([FilePath_1, FileName_1]);
% else
%     [FilePath,FileName,FileExt] = fileparts([MixtureImagePath, MixtureImageName]);
% end
% fileID = fopen( [FilePath, '\', OutputFileName, '_ABAQUS_Output.txt'] ,'w');

fileID = fopen( [OutputFileName, '_ABAQUS.inp'] ,'w');
% =========================================================================
%%
fprintf(fileID,'** \r\n');
fprintf(fileID,'** MIDAS-Pre OUTPUT \r\n');
fprintf(fileID,'** \r\n');
fprintf(fileID,'*Heading \r\n');
%%
fprintf(fileID,'** \r\n');
fprintf(fileID,'** PARTS \r\n');
fprintf(fileID,'** \r\n');
fprintf(fileID,'*Part, name=Part-1 \r\n');

%% Coo_M
fprintf(fileID,'** \r\n');
fprintf(fileID,'** \r\n');
fprintf(fileID,'*Node \r\n');
Node=[Coo(:,1)';Coo(:,2)';Coo(:,3)'];
fprintf(fileID,'%d, %15.8f, %15.8f\r\n',Node);
%% 3-node bulk
fprintf(fileID,'** \r\n');
fprintf(fileID,'** \r\n');
CPE3=[];
fprintf(fileID,'*Element, type=CPE3 \r\n');
CPE3 = [Con(1:NumRegEl,1)';
        Con(1:NumRegEl,2)';
        Con(1:NumRegEl,3)';
        Con(1:NumRegEl,4)'];
fprintf(fileID,'%d, %d, %d, %d\r\n',CPE3);
%% 4-node cohesive
fprintf(fileID,'** \r\n');
fprintf(fileID,'** \r\n');
if size(Con,1) > NumRegEl
    fprintf(fileID,'*Element, type=COH2D4  \r\n');
    COH2D4 = [Con(NumRegEl+1:end,1)';
              Con(NumRegEl+1:end,2)';
              Con(NumRegEl+1:end,3)';
              Con(NumRegEl+1:end,4)';
              Con(NumRegEl+1:end,5)'];
    fprintf(fileID,'%d, %d, %d, %d, %d\r\n',COH2D4);
    if isempty(COH2D4); fprintf(fileID,'\r\n'); end
end
%% VISCOELASTIC
if ~isempty(El_Phase1)
    fprintf(fileID,'*Elset, elset=Phase1 \r\n');
    fprintf(fileID,'%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\r\n',El_Phase1');
    if mod(numel(El_Phase1),16)~=0; fprintf(fileID,'\r\n');end
    if isempty(El_Phase1); fprintf(fileID,'\r\n'); end
end
%% ELASTIC
if ~isempty(El_Phase2)
    fprintf(fileID,'*Elset, elset=Phase2 \r\n');
    fprintf(fileID,'%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\r\n',El_Phase2');
    if mod(numel(El_Phase2),16)~=0; fprintf(fileID,'\r\n');end
    if isempty(El_Phase2); fprintf(fileID,'\r\n'); end
end
%% CZ
if ~isempty(El_CZ)
    fprintf(fileID,'*Elset, elset=CZ \r\n');
    fprintf(fileID,'%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\r\n',El_CZ');
    if mod(numel(El_CZ),16)~=0; fprintf(fileID,'\r\n');end
    if isempty(El_CZ); fprintf(fileID,'\r\n'); end
end
%% ADHESIVE_ELEMS
if size(Con,1) > NumRegEl
    fprintf(fileID,'*Elset, elset=Cohesive Elements \r\n');
    fprintf(fileID,'%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\r\n',CohEl_Phase1');
    if mod(numel(CohEl_Phase1),16)~=0; fprintf(fileID,'\r\n');end
    if isempty(CohEl_Phase1); fprintf(fileID,'\r\n'); end
end
%% COHESIVE_ELEMS
if size(Con,1) > NumRegEl
    fprintf(fileID,'*Elset, elset=Adhesive Elements \r\n');
    fprintf(fileID,'%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\r\n',CohEl_InterPhase12);
    if mod(numel(CohEl_InterPhase12),16)~=0; fprintf(fileID,'\r\n');end
    if isempty(CohEl_InterPhase12); fprintf(fileID,'\r\n'); end
end
%%
fprintf(fileID,'*End Part \r\n');
%%
fprintf(fileID,'** \r\n');
fprintf(fileID,'** ASSEMBLY \r\n');
fprintf(fileID,'** \r\n');
fprintf(fileID,'*Assembly, name=Assembly-1 \r\n');
%%
fprintf(fileID,'*Instance, name=Instance-1, part=Part-1 \r\n');
fprintf(fileID,'*End Instance \r\n');
%% BOUNDARY CONDITION
if     TestType ==1
    BC_Node{1} = TT_T; BC_Txt{1} = 'TT_T'; 
    BC_Node{2} = TT_B; BC_Txt{2} = 'TT_B';
    BC_Node{3} = TT_L; BC_Txt{3} = 'TT_L';
elseif TestType==2
    BC_Node{1} = ST_T; BC_Txt{1} = 'ST_T'; 
    BC_Node{2} = ST_B; BC_Txt{2} = 'ST_B';
elseif TestType==3
    BC_Node{1} = TPBT_LS; BC_Txt{1} = 'TPBT_LS';
    BC_Node{2} = TPBT_RS; BC_Txt{2} = 'TPBT_RS';
    BC_Node{3} = TPBT_LP; BC_Txt{3} = 'TPBT_LP';
elseif TestType==4
    BC_Node{1} = FPBT_LS;  BC_Txt{1} = 'FPBT_LS';
    BC_Node{2} = FPBT_RS;  BC_Txt{2} = 'FPBT_RS';
    BC_Node{3} = FPBT_LLP; BC_Txt{3} = 'FPBT_LLP';
    BC_Node{4} = FPBT_RLP; BC_Txt{4} = 'FPBT_RLP';
elseif TestType==5
    BC_Node{1} = SCBT_LS; BC_Txt{1} = 'SCBT_LS';
    BC_Node{2} = SCBT_RS; BC_Txt{2} = 'SCBT_RS';
    BC_Node{3} = SCBT_LP; BC_Txt{3} = 'SCBT_LP';
elseif TestType==6
    BC_Node{1} = ITT_TLP; BC_Txt{1} = 'ITT_TLP';
    BC_Node{2} = ITT_BS;  BC_Txt{2} = 'ITT_BS';
end

for II=1:numel(BC_Node)
    fprintf(fileID,'*Nset, nset= %s, instance=Instance-1 \r\n', BC_Txt{II});
    fprintf(fileID,'%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\r\n', BC_Node{II});
    if mod(numel(BC_Node{II}),16)~=0; fprintf(fileID,'\r\n');end
    if isempty(BC_Node{II}); fprintf(fileID,'\r\n'); end
end
%%
fprintf(fileID,'*End Assembly \r\n');

%%
fclose(fileID);

end







