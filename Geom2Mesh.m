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

function [Coo, Con] = Geom2Mesh
%%
SetGlobal
% =========================================================================
% strictly between 1 and 2, typically=1.3
% =========================================================================
% Meshing
[p,e,t] = initmesh(dl,'hmax',MaxMeshSize,'Hgrad',MeshGrowthRate);%'MesherVersion','R2013a'
% figure; pdeplot(p,e,t)
% -------------------------------------------------------------------------
% JIGGLING
if isempty(JigglingMaxIter); JigglingMaxIter=0; end
if JigglingMaxIter~=0
    % q = pdetriq(p,t);
    % figure; pdeplot(p,e,t,'xydata',q,'colorbar','on','xystyle','flat')
    p = jigglemesh(p,e,t,'opt','mean','iter',JigglingMaxIter);
    % q = pdetriq(p,t);
    % figure; pdeplot(p,e,t,'xydata',q,'colorbar','on','xystyle','flat')
end
% =========================================================================
% Coo = [N X Y]
Coo = [[1:size(p,2)]'   p'];
disp('Number of nodes=');
disp(size(Coo,1));
% -------------------------------------------------------------------------
% Con [N 1 2 3 4or0] % N is Ascending
Con = [[1:size(t,2)]'   t(1:3,:)' zeros(size(t,2),1)];
disp('Number of nodes=');
disp(size(Con,1));

NumRegEl = size(Con,1);
% =========================================================================
% Find ELEl_CZ, El_Phase1, El_Phase2
El_CZ=[]; El_Phase1=[]; El_Phase2=[];

CZ_Polygon = [(Dim_w - Dim_CZw)/2    Dim_nl;
              (Dim_w + Dim_CZw)/2    Dim_nl;
              (Dim_w + Dim_CZw)/2    Dim_CZh;
              (Dim_w - Dim_CZw)/2    Dim_CZh];
% .........................................................................
El_Cen_XY = [];
for EE = 1 : size(Con,1)
    [ El_Cen, ~, ~ ] = El_Specs( EE, Coo, Con);
    El_Cen_XY = [El_Cen_XY; El_Cen];
end
% -------------------------------------------------------------------------
% El_Phase1=[]; El_CZ=[]; El_Phase2=[];
% 0&1           1         2
El_Zone_Index = zeros(size(Con,1),1);
% find El in agg
for OO = 1:size(BoundXY,1) 
    [in,on] = inpolygon(El_Cen_XY(:,1),El_Cen_XY(:,2),BoundXY{OO,1}(:,1),BoundXY{OO,1}(:,2));
    El_Zone_Index = El_Zone_Index + 2*in;
end
% find El in CZ
in = [];
[in,on] = inpolygon(El_Cen_XY(:,1),El_Cen_XY(:,2),CZ_Polygon(:,1),CZ_Polygon(:,2));
El_Zone_Index = El_Zone_Index + in;
% -------------------------------------------------------------------------
for EE = 1:size(El_Zone_Index,1)
    if     El_Zone_Index(EE,1)==0 || El_Zone_Index(EE,1)==1; El_Phase1 = [El_Phase1; EE];end
    if     El_Zone_Index(EE,1)==1;                           El_CZ = [El_CZ; EE];end
    % >=2 bcuz, it might be in both cz and in a particle
    if     El_Zone_Index(EE,1)>=2;                           El_Phase2 = [El_Phase2 EE];end
end
end

    
    
    
    
    
    
    
    
    
    
