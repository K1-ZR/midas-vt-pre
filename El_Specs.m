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

function [ El_Cen, El_Edge, El_EdgeCen ] = El_Specs( CC, Coor, Conn )
%%
    
El_Cen = [sum(Coor(Conn(CC,2:4),2))/3 ...
          sum(Coor(Conn(CC,2:4),3))/3];

El_Edge = [Conn(CC,2) Conn(CC,3);
           Conn(CC,3) Conn(CC,4);
           Conn(CC,4) Conn(CC,2)];

El_EdgeCen = [(Coor(El_Edge(1,1),2)+Coor(El_Edge(1,2),2))/2 (Coor(El_Edge(1,1),3)+Coor(El_Edge(1,2),3))/2;
              (Coor(El_Edge(2,1),2)+Coor(El_Edge(2,2),2))/2 (Coor(El_Edge(2,1),3)+Coor(El_Edge(2,2),3))/2;
              (Coor(El_Edge(3,1),2)+Coor(El_Edge(3,2),2))/2 (Coor(El_Edge(3,1),3)+Coor(El_Edge(3,2),3))/2];


end

