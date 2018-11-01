function [ Coo_O, Con_O, El_Phase1, El_Phase2, El_CZ] =...
            ReadInputForPreprocessorCase1(FilePathFileName, Delimiter) 
%%
% this program will read the data from .txt
% =========================================================================
% Phase1: matrix
% Phase2: Particles
% =========================================================================
% THE MAIN WHILE, READ THE TEXT FILE LINE BY LINE                              
FileID = fopen( FilePathFileName , 'r'); 
MeshDataInput = textscan(FileID, '%s','delimiter', '\n');
MeshDataInput  = MeshDataInput{1,1};
%remove empty lines
 MeshDataInput=MeshDataInput(~cellfun('isempty',MeshDataInput));
% =========================================================================
% READING
% =========================================================================
LineIndex = {}; 
LineIndexCounter = 1;
for LL = 1 : size(MeshDataInput,1)
    if ~isempty( strfind( MeshDataInput{LL,1},'*' ) )
        LineIndex(LineIndexCounter,1:2) = {LL, MeshDataInput{LL,1}};
        LineIndexCounter = LineIndexCounter + 1;
    end
end
LineIndex(LineIndexCounter,1:2) = {size(MeshDataInput,1)+1, []};
% ========================================================================= 
Coo_O = [];
Con_O = [];
El_Phase1 = [];
El_Phase2 = [];
El_CZ = [];

for II = 1 : size(LineIndex,1)
    if ~isempty( strfind( LineIndex{II,2},'*Node' ) )
        for LL = LineIndex{II,1}+1 : LineIndex{II+1,1}-1
            OneNodeCoo_O = textscan(MeshDataInput{LL,1}, '%f','delimiter', Delimiter);
            Coo_O = vertcat(Coo_O, OneNodeCoo_O{1,1}');
        end
    end
    
    if ~isempty( strfind( LineIndex{II,2},'*Element' ) )
        for LL = LineIndex{II,1}+1 : LineIndex{II+1,1}-1
            OneElCon_O = textscan(MeshDataInput{LL,1}, '%f','delimiter', Delimiter);
            Con_O = vertcat(Con_O, OneElCon_O{1,1}');
        end
    end
    
    if ~isempty( strfind( LineIndex{II,2},'Phase1' ) )
        for LL = LineIndex{II,1}+1 : LineIndex{II+1,1}-1
            OneLineEl_Phase1 = textscan(MeshDataInput{LL,1}, '%f','delimiter', Delimiter);
            El_Phase1 = vertcat(El_Phase1, OneLineEl_Phase1{1,1});
        end
    end
    
    if ~isempty( strfind( LineIndex{II,2},'Phase2' ) )
        for LL = LineIndex{II,1}+1 : LineIndex{II+1,1}-1
            OneLineEl_Phase2 = textscan(MeshDataInput{LL,1}, '%f','delimiter', Delimiter);
            El_Phase2 = vertcat(El_Phase2, OneLineEl_Phase2{1,1});
        end
    end
    
    if ~isempty( strfind( LineIndex{II,2},'CZ' ) )
        for LL = LineIndex{II,1}+1 : LineIndex{II+1,1}-1
            OneLineEl_CZ = textscan(MeshDataInput{LL,1}, '%f','delimiter', Delimiter);
            El_CZ = vertcat(El_CZ, OneLineEl_CZ{1,1});
        end
    end
end

% =========================================================================
NumRegEl = size(Con_O,1);
Con_O = [Con_O zeros(NumRegEl,1)];

El_Phase1(find(isnan(El_Phase1)))=0;
El_Phase1 = setdiff(El_Phase1,0);

El_Phase2(find(isnan(El_Phase2)))=0;
El_Phase2 = setdiff(El_Phase2,0);

El_CZ(find(isnan(El_CZ)))=0;
El_CZ = setdiff(El_CZ,0);

fclose('all'); 
end






















