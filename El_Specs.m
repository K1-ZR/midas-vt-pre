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

