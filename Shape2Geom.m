function Shape2Geom
%

% BOUNDARIES 2 GEOMETRY (Based on MATLAB definition)
% help: http://www.mathworks.com/help/pde/ug/create-geometry-at-the-command-line.html
SetGlobal;
% =========================================================================
% Making Sketch Geometry
% -------------------------------------------------------------------------
W=Dim_w; H=Dim_h; 
A=Dim_a; B=Dim_b;
CZW=Dim_CZw; CZH=Dim_CZh;
NW=Dim_nw; NL=Dim_nl;

% 1 Direct tension test (Square RVE)
% 2 Direct shear test (Square RVE)
% 3 Three-point beam bending test
% 4 Four-point beam bending test
% 5 Semi-circular bending test
% 6 Indirect tension test

if     TestType == 1 || TestType == 2

    GePhase1_Rec  = [2  4   0	W	W	0   ...
                            0   0   H   H]';
    GeCohZone     = [2  4   0	CZW	 CZW  0   ...
                            0   0    CZH  CZH]';
    GePhase1_Cir  = [1  W/2 ... Big dummy circle to sync formula
                        0	     2*max(H,W)]';
% -------------------------------------------------------------------------
elseif TestType == 3

    GePhase1_Rec  = [2  8   0	A	W/2   W-A	W	W	W/2	0  ...
                            0   0    0     0    0   H   H   H]';
    GeCohZone = [2  6 (W-CZW)/2   W/2  (W+CZW)/2   (W+CZW)/2     W/2  (W-CZW)/2 ...
                       NL         NL     NL         CZH           CZH   CZH]';
    GePhase1_Cir  = [1  W/2 ... Big dummy circle to sync formula
                        0   2*max(H,W)]';
    
    if NW~=0 && NL~=0
        GeNotch   = [2  5   (W-NW)/2	 (W+NW)/2		(W+NW)/2	  W/2    (W-NW)/2 ...
                             0            0              NL           NL      NL]';
    end
    % -------------------------------------------------------------------------
elseif TestType == 4

    GePhase1_Rec  = [2  9   0	A	W/2   W-A	W	W	W-B	B  0  ...
                            0   0    0     0    0   H   H   H  H]';
    GeCohZone = [2  6 (W-CZW)/2   W/2  (W+CZW)/2   (W+CZW)/2     W/2  (W-CZW)/2 ...
                       NL         NL     NL         CZH           CZH   CZH]';
    GePhase1_Cir  = [1  W/2 ... Big dummy circle to sync formula
                        0   2*max(H,W)]';
    
    if NW~=0 && NL~=0
        GeNotch   = [2  5   (W-NW)/2	 (W+NW)/2		(W+NW)/2	  W/2    (W-NW)/2 ...
                             0            0              NL           NL      NL]';
    end
% -------------------------------------------------------------------------
elseif TestType == 5

    GePhase1_Rec  = [2  8   0	A	W/2   W-A	W	W	W/2	0  ...
                            0   0   0     0     0   H   H   H]';
    GeCohZone = [2  6 (W-CZW)/2	W/2     (W+CZW)/2   (W+CZW)/2     W/2  (W-CZW)/2 ...
                       NL        NL      NL          CZH          CZH   CZH]';
    GePhase1_Cir  = [1  W/2 ...
                        0   W/2]';
    
    if NW~=0 && NL~=0
         GeNotch   = [2  5   (W-NW)/2	 (W+NW)/2		(W+NW)/2	  W/2    (W-NW)/2 ...
                              0           0              NL           NL      NL]';
    end
% -------------------------------------------------------------------------
elseif TestType == 6
    GePhase1_Rec  = [2  6   0	W/2	 W	W	W/2	0  ...
                            0   0    0  H   H   H]';
    GeCohZone = [2  6 (W-CZW)/2	W/2     (W+CZW)/2   (W+CZW)/2     W/2  (W-CZW)/2 ...
                       NL        NL      NL          CZH          CZH   CZH]';
    GePhase1_Cir  = [1  W/2 ...
                        W/2   W/2]';
end

% =========================================================================
Geo_MaxRow = 0;
if HeteroIndex==1
    Geo_MaxRow = 2 + 2*  (max(cellfun(@length,BoundXY)) + 1); % 2 initial values+ x & y
end
if Geo_MaxRow < size(GePhase1_Rec,1);   Geo_MaxRow = size(GePhase1_Rec,1);  end
% .........................................................................
% Combine Geometries: CZ + Phase1 + Phase2 s
GePhase1_Rec = [GePhase1_Rec; zeros(Geo_MaxRow - size(GePhase1_Rec,1),1)];
GeCohZone    = [GeCohZone;    zeros(Geo_MaxRow - size(GeCohZone,1),1)];
GePhase1_Cir = [GePhase1_Cir; zeros(Geo_MaxRow - size(GePhase1_Cir,1),1)];
% -------------------------------------------------------------------------
% W/ CZ vs W/O CZ
if isempty(CZH) || isempty(CZW); CZH=0;CZW=0;end 
if CZH ==0 || CZW == 0
    gd = [GePhase1_Rec];
    ns = char('GePhase1_Rec');
    sf = '( GePhase1_Rec )';
else
    gd = [GePhase1_Rec, GeCohZone];
    ns = char('GePhase1_Rec', 'GeCohZone');
    sf = '( GePhase1_Rec + GeCohZone )';
end
% .........................................................................
BoundXY_BeforeUnique = BoundXY;
for OO = 1:size(BoundXY,1)
    GeAgg = [2;
             size(BoundXY{OO,1},1);
             BoundXY{OO,1}(:,1);
             BoundXY{OO,1}(:,2)];

    GeAgg = [GeAgg; zeros(Geo_MaxRow-size(GeAgg,1),1)];

    gd = [gd GeAgg];
    ns = char(ns,sprintf('GeAgg%d',OO));
    sf = [sf,sprintf('+GeAgg%d',OO)];
end
% .........................................................................
gd = [gd, GePhase1_Cir];
ns = char(ns, 'GePhase1_Cir');
sf = ['(' sf ')' '* GePhase1_Cir' ];
% .........................................................................
% if there is a notch

CZZoneIndex = 1; % shows zone of cz (based on experience: 1 when no notch, 3 when there is a notch)
if TestType==3 || TestType==4 || TestType==5
    if NW~=0 && NL~=0
        GeNotch      = [GeNotch;      zeros(Geo_MaxRow - size(GeNotch,1),1)];
        gd = [gd, GeNotch];
        ns = char(ns, 'GeNotch');
        sf = ['(' sf ')' '-GeNotch'];
        
        CZZoneIndex = 3;
    end
end

nonCZZoneIndex = 2; % shows non-CZ zone (based on experience: 2 when no notch, 1&2 when there is a notch)
% ---------------------------------------------------------------------
% Check validity of Geometry Description matrix
% 0 : that the polygon is closed and does not intersect itself
% 1 : an open and non-self-intersecting polygon
% 2 : a closed and self-intersecting polygon
% 3 : an open and self-intersecting polygon.
gstat = csgchk(gd);
if sum(gstat)~=0
    BadObjects= find(gstat);
    PlotObject(BoundXY_BeforeUnique, W, H, 'Correct red particles', BadObjects);

    msgbox({'Connected particles detcted:',...
            'Step 1. Treat image in paint (use "Redo" button)',...
            'Step 2. Redo segmentation'});          
end
% ---------------------------------------------------------------------
% making assembled geometry
[dl,bt] = decsg(gd,sf,ns');
% ---------------------------------------------------------------------
% if FAM: adding a middle line
if TestType == 3 || TestType == 4 || TestType == 5 || TestType == 6
    if HeteroIndex==0
        if CZH == H
            MiddleLine= [2  W/2    W/2    ...
                            NL     H    CZZoneIndex   CZZoneIndex   0   0   0]';
            dl= [dl MiddleLine];
        elseif CZH < H
            MiddleLine_1= [2  W/2    W/2    ...
                              NL     CZH    CZZoneIndex   CZZoneIndex   0   0   0]';
            MiddleLine_2= [2  W/2    W/2    ...
                              CZH     H     nonCZZoneIndex   nonCZZoneIndex   0   0   0]';
            dl= [dl MiddleLine_1 MiddleLine_2];
        end
    end
end
% =========================================================================
figure(1)
pdegplot(dl) % ,'SubdomainLabels','on','EdgeLabels','on','SubdomainLabels','on'
% pdegplot(dl ,'SubdomainLabels','on','EdgeLabels','on','SubdomainLabels','on')
axis equal
axis([0,W,0,H])
title('Model geometry')
end

%%
function PlotObject(BoundObj, XAxisLim, YAxisLim, Title, BadObjects)
close (figure(2))
figure(2);
hold on

for OO=1:size(BoundObj,1)
    plot(BoundObj{OO,1}(:,1),...
         BoundObj{OO,1}(:,2),...
         '.-', 'Color', 'k');
     
    if ismember(OO,BadObjects)
        fill(BoundObj{OO,1}(:,1),...
             BoundObj{OO,1}(:,2),...
             'r');
        
         % rectangle('Position',[1 2 5 6],'EdgeColor','r')
    end
    
end

title(Title)
axis equal
axis([0,XAxisLim,0,YAxisLim])

end
