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

function DispMesh(Coo, Con, NumRegEl)
%%
SetGlobal
DetailPlotIndex = 0;
CohEl_LineWidth = 0.25;
Support_MarkerSize = 5;
Support_LineWidth = 0.75;
% =========================================================================
close(figure(1))
close(figure(2))
figure(1);
title('Finite Element Mesh')
axis equal
hold on
if DetailPlotIndex==0
    % ---------------------------------------------------------------------
    % Plot Reg El
    for EE = 1:NumRegEl
        if ismember(EE,El_Phase1); ColorIndex=[102 178 255]/256; end
        if ismember(EE,El_Phase2); ColorIndex=[160 160 160]/256; end
        XX = Coo(Con(EE,2:4),2);
        YY = Coo(Con(EE,2:4),3);
        fill(XX,YY, ColorIndex,'FaceAlpha', 0.6)   
    end
    % ---------------------------------------------------------------------
    % Disp Coh Elemetns
    if size(Con,1) > NumRegEl
        for EE = NumRegEl+1:size(Con,1)
            if ismember(EE,CohEl_InterPhase12); ColorIndex=[0 102 51]/256; end
            if ismember(EE,CohEl_Phase1);       ColorIndex=[0 0 204]/256; end
            if ismember(EE,CohEl_Phase2);       ColorIndex=[64 64 64]/256; end
            XX = Coo(Con(EE,2:3),2);
            YY = Coo(Con(EE,2:3),3);
            plot(XX, YY,'Color', ColorIndex, 'LineWidth',CohEl_LineWidth);
        end
    end
    % ---------------------------------------------------------------------

    sampleHight = abs( min(Coo(:,3)) - max(Coo(:,3)) );

    % disp boundary condition
    if     TestType==1
        % plot loading point
        % quiver(x,y,u,v)
        quiverU = ones(size(TT_T,1),1) * 0.0;
        quiverV = ones(size(TT_T,1),1) * sampleHight/15;
        quiver(Coo(TT_T,2),Coo(TT_T,3),quiverU,quiverV,'k','MaxHeadSize',1,'LineWidth',Support_LineWidth)
        % plot support
    	plot(Coo(TT_B,2),Coo(TT_B,3),'Color','none','Marker','^','MarkerSize',Support_MarkerSize,'LineWidth', Support_LineWidth,'MarkerEdgeColor','k','MarkerFaceColor','k');
    elseif TestType==2
        % plot loading point
        % quiver(x,y,u,v)
        quiverU = ones(size(ST_T,1),1) * sampleHight/15;
        quiverV = ones(size(ST_T,1),1) * 0.0;
        quiver(Coo(ST_T,2),Coo(ST_T,3),quiverU,quiverV,'k','MaxHeadSize',1,'LineWidth',Support_LineWidth)
        % plot support
    	plot(Coo(ST_B,2),Coo(ST_B,3),'Color','none','Marker','^','MarkerSize',Support_MarkerSize,'LineWidth', Support_LineWidth,'MarkerEdgeColor','k','MarkerFaceColor','k');
    elseif TestType==3        
        % plot loading point
        % quiver(x,y,u,v)
        quiverU = ones(size(TPBT_LP,1),1) * 0.0;
        quiverV = ones(size(TPBT_LP,1),1) * -sampleHight/15;
        quiver(Coo(TPBT_LP,2),Coo(TPBT_LP,3),quiverU,quiverV,'k','MaxHeadSize',1,'LineWidth',Support_LineWidth)
        % plot support
        plot(Coo(TPBT_LS,2),Coo(TPBT_LS,3),'Color','none','Marker','o','MarkerSize',Support_MarkerSize,'LineWidth', Support_LineWidth,'MarkerEdgeColor','k','MarkerFaceColor','k');
        plot(Coo(TPBT_RS,2),Coo(TPBT_RS,3),'Color','none','Marker','o','MarkerSize',Support_MarkerSize,'LineWidth', Support_LineWidth,'MarkerEdgeColor','k','MarkerFaceColor','k');
    elseif TestType==4
        % plot loading point
        % quiver(x,y,u,v)
        quiverU = ones(size(FPBT_LLP,1),1) * 0.0;
        quiverV = ones(size(FPBT_LLP,1),1) * -sampleHight/15;
        quiver(Coo(FPBT_LLP,2),Coo(FPBT_LLP,3),quiverU,quiverV,'k','MaxHeadSize',1,'LineWidth',Support_LineWidth)
        
        quiverU = ones(size(FPBT_RLP,1),1) * 0.0;
        quiverV = ones(size(FPBT_RLP,1),1) * -sampleHight/15;
        quiver(Coo(FPBT_RLP,2),Coo(FPBT_RLP,3),quiverU,quiverV,'k','MaxHeadSize',1,'LineWidth',Support_LineWidth)
        
        % plot support
        plot(Coo(FPBT_LS,2),Coo(FPBT_LS,3),'Color','none','Marker','o','MarkerSize',Support_MarkerSize,'LineWidth', Support_LineWidth,'MarkerEdgeColor','k','MarkerFaceColor','k');
        plot(Coo(FPBT_RS,2),Coo(FPBT_RS,3),'Color','none','Marker','o','MarkerSize',Support_MarkerSize,'LineWidth', Support_LineWidth,'MarkerEdgeColor','k','MarkerFaceColor','k');
    elseif TestType==5
        % plot loading point
        % quiver(x,y,u,v)
        quiverU = ones(size(SCBT_LP,1),1) * 0.0;
        quiverV = ones(size(SCBT_LP,1),1) * -sampleHight/15;
        quiver(Coo(SCBT_LP,2),Coo(SCBT_LP,3),quiverU,quiverV,'k','MaxHeadSize',1,'LineWidth',Support_LineWidth)
        % plot support
        plot(Coo(SCBT_LS,2),Coo(SCBT_LS,3),'Color','none','Marker','o','MarkerSize',Support_MarkerSize,'LineWidth', Support_LineWidth,'MarkerEdgeColor','k','MarkerFaceColor','k');
        plot(Coo(SCBT_RS,2),Coo(SCBT_RS,3),'Color','none','Marker','o','MarkerSize',Support_MarkerSize,'LineWidth', Support_LineWidth,'MarkerEdgeColor','k','MarkerFaceColor','k');
    elseif TestType==6
        % plot loading point
        % quiver(x,y,u,v)
        quiverU = ones(size(ITT_TLP,1),1) * 0.0;
        quiverV = ones(size(ITT_TLP,1),1) * -sampleHight/15;
        quiver(Coo(ITT_TLP,2),Coo(ITT_TLP,3),quiverU,quiverV,'k','MaxHeadSize',1,'LineWidth',Support_LineWidth)
        % plot support
        plot(Coo(ITT_BS,2),Coo(ITT_BS,3),'Color','none','Marker','o','MarkerSize',Support_MarkerSize,'LineWidth', Support_LineWidth,'MarkerEdgeColor','k','MarkerFaceColor','k');
    end
 
% =========================================================================
% =========================================================================    
elseif DetailPlotIndex==1
    drawArrow = @(x,y) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0 );    

    figure(100);
    hold on
    % =====================================================================
    % Plot Reg El
    for EE=1:NumRegEl
        [ El_Cen_EE, El_Edge_EE, El_EdgeCen_EE ] = El_Specs( EE,Coo,Con );
        % ---------------------------------------------------------------------
        % make shrinked Coo
        for NN= 2:4
            AA = Coo(Con(EE,NN),2:3);
            AA = AA+0.3*(El_Cen_EE-AA);
            Coo_Shrinked(Con(EE,NN),1:2)= AA;
        end
        % ---------------------------------------------------------------------
        % Disp regular Mesh
        for ED = 1:3

            AA=[Coo_Shrinked(El_Edge_EE(ED,1),1) Coo_Shrinked(El_Edge_EE(ED,1),2)];
            BB=[Coo_Shrinked(El_Edge_EE(ED,2),1) Coo_Shrinked(El_Edge_EE(ED,2),2)];

            drawArrow([AA(1) BB(1)] , [AA(2) BB(2)]);
        end 
        % ---------------------------------------------------------------------
        % Disp element number
        Str = {num2str(EE)};
        text(El_Cen_EE(1), El_Cen_EE(2), Str, 'color','r');
        % ---------------------------------------------------------------------
        % Disp Node Numbers
        for NN = 2:4
            AA = Coo(Con(EE,NN),2:3);
            AA = AA+0.45*(El_Cen_EE-AA);
            Str = {num2str(Con(EE,NN))};
            text(AA(1),AA(2), Str);
        end        

    end
    % =========================================================================
    % Disp Coh Elemetns

    for EE = NumRegEl+1:size(Con,1)

        AA = Coo_Shrinked(Con(EE,2),:);
        BB = Coo_Shrinked(Con(EE,3),:);
        CC = Coo_Shrinked(Con(EE,4),:);
        DD = Coo_Shrinked(Con(EE,5),:);

        IntElCen= (AA+BB+CC+DD)/4;

        AA_Expanded = AA+0.4*(IntElCen-AA);
        BB_Expanded = BB+0.4*(IntElCen-BB);
        CC_Expanded = CC+0.4*(IntElCen-CC);
        DD_Expanded = DD+0.4*(IntElCen-DD);

        drawArrow([AA_Expanded(1) BB_Expanded(1)] , [AA_Expanded(2) BB_Expanded(2)]);
        drawArrow([BB_Expanded(1) CC_Expanded(1)] , [BB_Expanded(2) CC_Expanded(2)]);
        drawArrow([CC_Expanded(1) DD_Expanded(1)] , [CC_Expanded(2) DD_Expanded(2)]);
        % ---------------------------------------------------------------------
        % Disp Coh element number
        Str = {num2str(Con(EE,1))};
        text(IntElCen(1), IntElCen(2),...
             Str, ...
             'color','k');
    end
end



end









