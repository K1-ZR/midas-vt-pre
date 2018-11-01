function Image2Shape
%%
SetGlobal;
figure(1);

BoundPix=[];
BoundXY=[];

% ConvexingFactor = .8;
% 0 : gives the convex hull, 
% 1 : gives a compact boundary that envelops the points.

BorderLimFactor = 200;
ParticleAreaThresholdFactor = 50;
ParticleDiagThresholdFactor = 20;
% IXDim/BorderLimFactor : max accepted distance that an agg can be nearby the border 

IXDim = Dim_w; % in meter
IYDim = Dim_h; % in meter
% =========================================================================
% =========================================================================
% =========================================================================   
% PRELIMINARY JOBs
% Read Image
I = imread([MixtureImagePath, MixtureImageName]);
subplot(2,1,1);imshow(I);

% I size in pixel 
% YPixel:Pixels along Y axis 
% XPixel:Pixels along X axis
[YPixel, XPixel, ZZ]=size(I);
% -------------------------------------------------------------------------
% to Grayscale
I = rgb2gray(I);
% figure;imshow(I);
% -------------------------------------------------------------------------
% to Binary
%     Level = graythresh(I);   
I=im2bw(I,SegmentationThreshold);
% figure;imshow(I);
% -------------------------------------------------------------------------
% fill holes
I=imfill(I,'holes');
% figure;imshow(I);
% =========================================================================
% BINARY IMAGE 2 AGG BOUNDARIES in PIXELS 
% (BoundPix: Agg boundry defined by pixels)
[BoundPix] = bwboundaries(I);

for OO = 1:size(BoundPix,1)
    Keyvan1 = BoundPix{OO,1}(:,2);
    Keyvan2 = YPixel - BoundPix{OO,1}(:,1);

    BoundPix{OO,1}(:,1)= Keyvan1;
    BoundPix{OO,1}(:,2)= Keyvan2;
end
% PlotObject(BoundPix, XPixel, YPixel, ' boundry Pixel ',0)
% =========================================================================
% PIXEL 2 XY (meter)
for OO=1:size(BoundPix,1)
    BoundXY{OO,1}(:,1)=  (IXDim/XPixel) * BoundPix{OO,1}(:,1);
    BoundXY{OO,1}(:,2)=  (IYDim/YPixel) * BoundPix{OO,1}(:,2);
end
% PlotObject(BoundXY, IXDim, IYDim, ' Pixel 2 XY ',0)
% =========================================================================
% CONVEXING: BOUNDARY POINTS of OBJECT
% to remove object self-intersection
for OO=1:size(BoundXY,1)
    [k v]= boundary(BoundXY{OO,1}(:,1),BoundXY{OO,1}(:,2),ConvexingFactor);
    XX = BoundXY{OO,1}(k,1);
    YY = BoundXY{OO,1}(k,2);
    BoundXY{OO,1} = [XX YY];
end
% . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
% due to convexing, when the particles are small we will have []
% objects. following command reve [] objects
BoundXY = BoundXY(~cellfun(@isempty, BoundXY));
%     PlotObject(BoundXY, IXDim, IYDim, ' after convexing ',0)
% =========================================================================
% in case of SCB: remove two triangular unneccessary object
if TestType==3
    for OO = 1:size(BoundXY,1)
        ObiCenter = 0;
        for VV = 1: size(BoundXY{OO,1},1)
            ObiCenter = ObiCenter + BoundXY{OO,1}(VV,1:2);
        end
        ObjCenter = ObiCenter/size(BoundXY{OO,1},1);
        
        if ((ObjCenter(1) - IYDim)^2 + (ObjCenter(2) - 0)^2) >= IYDim^2
            BoundXY{OO,1} = [];
        end
    end
end
% . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
BoundXY = BoundXY(~cellfun(@isempty, BoundXY));
% =========================================================================
% REMOVE UNNECESSARY VERTICES
% [Xout,Yout,cerr,tol]= reducem(X,Y,tol)
% reduces the number of vertices in a polygon.
% tol : can be provided or automatically computed
%       The units of the tolerance are degrees of arc on the surface of a sphere
for OO=1:size(BoundXY,1)
    % remove neighbor
    [XOut, YOut, cerr,tol] =  reducem(BoundXY{OO,1}(:,1),BoundXY{OO,1}(:,2));
    BoundXY{OO,1} = [XOut, YOut];
end
BoundXY = BoundXY(~cellfun(@isempty, BoundXY));
% =========================================================================
% MERGE adjacent nodes to boundary with boundary

for OO = 1:size(BoundXY,1)
    MustDeleteNodes = []; 
    for VV = 1: size(BoundXY{OO,1},1)
        if TestType==1 || TestType==2
            if abs(BoundXY{OO,1}(VV,1) - 0) <= IXDim/BorderLimFactor;   BoundXY{OO,1}(VV,1) = 0;    end
            if abs(BoundXY{OO,1}(VV,1) - IXDim) <= IXDim/BorderLimFactor;   BoundXY{OO,1}(VV,1) = IXDim;    end
            if abs(BoundXY{OO,1}(VV,2) - 0) <= IYDim/BorderLimFactor;   BoundXY{OO,1}(VV,2) = 0;    end
            if abs(BoundXY{OO,1}(VV,2) - IYDim) <= IYDim/BorderLimFactor;   BoundXY{OO,1}(VV,2) = IYDim;    end
        elseif TestType==3
            if abs(BoundXY{OO,1}(VV,2) - 0) <= IXDim/BorderLimFactor;   BoundXY{OO,1}(VV,2) = 0;    end
            if abs((BoundXY{OO,1}(VV,1) - IXDim/2)^2 + (BoundXY{OO,1}(VV,2) - 0)^2 - (IXDim/2)^2) <= (IXDim/(1*BorderLimFactor))^2
                %BoundXY{OO,1}(VV,:) = sqrt((IXDim/2)^2 - (BoundXY{OO,1}(VV,1) - IXDim/2)^2);
                MustDeleteNodes = [MustDeleteNodes; VV];
            end
        end
    end
    if ~isempty(MustDeleteNodes)
        BoundXY{OO,1}(MustDeleteNodes,:) = [];
    end
end
% =========================================================================
% remove close nodes
% remove nodes that their absence would not change particle geometry more
% than areaTol

% ParticleAreaThresholdFactor = 100;
% ParticleDiagThresholdFactor = 100;


for OO = 1:size(BoundXY,1)
    % find area
    XX = BoundXY{OO,1}(:,1);
    YY = BoundXY{OO,1}(:,2);
    InitialObjectArea = polyarea(XX,YY);
    
    % roughly find max diagonal
    InitialObjectMaxDiag = max([max(XX)-min(XX), max(YY)-min(YY)]);
    
    % find candidate nodes for deletion
    MightDeleteNodes = [];
    for VV = 1: size(BoundXY{OO,1},1)-1
        AdjacentVerticeDistance= ( (BoundXY{OO,1}(VV,1)-BoundXY{OO,1}(VV+1,1))^2 +...
                                   (BoundXY{OO,1}(VV,2)-BoundXY{OO,1}(VV+1,2))^2 )^0.5;
                               
        if AdjacentVerticeDistance <= (InitialObjectMaxDiag/ParticleDiagThresholdFactor)
        	
            MightDeleteNodes = [MightDeleteNodes; VV];
        
        end
    end
    
    % revise candidate nodes
    MustDeleteNodes = MightDeleteNodes;
%     for II = 1: size(MightDeleteNodes, 1)
%         XX(MustDeleteNodes(II)) = [];
%         YY(MustDeleteNodes(II)) = [];
%         
%         CurrentObjectArea = polyarea(XX,YY);
%         
%         if abs(InitialObjectArea - CurrentObjectArea) >= (InitialObjectArea/ParticleAreaThresholdFactor)
%         	
%             MustDeleteNodes(MustDeletenodes == MightDeleteNodes(II)) = [];
%         end 
%     end
    
    % delete candidate nodes
    if ~isempty(MustDeleteNodes)
        BoundXY{OO,1}(MustDeleteNodes,:) = [];
    end
end
% =========================================================================
% REMOVING SMALL PARTICLES
for OO=1:size(BoundXY,1)
    XX = BoundXY{OO,1}(:,1);
    YY = BoundXY{OO,1}(:,2);
    ObjectArea = polyarea(XX,YY);
    if (size(BoundXY{OO,1},1) <= 2)||(ObjectArea <= MinFineParticleSize^2)
        BoundXY{OO,1} = [];
    end
end
BoundXY = BoundXY(~cellfun(@isempty, BoundXY));
% =========================================================================
% Remove duplicates(including remove duplicated first and last point)
for OO=1:size(BoundXY,1)
    BoundXY{OO,1} = unique(BoundXY{OO,1},'rows','stable');
end
% PlotObject(BoundXY, IXDim, IYDim, ' Microstructure ',0)
% =========================================================================
PlotObject(BoundXY, IXDim, IYDim, ' Microstructure ',0)
end


%%
function PlotObject(BoundObj, XAxisLim, YAxisLim, Title, DuplicatedNodeIndex)
cla(subplot(2,1,2))
subplot(2,1,2);
hold on

if DuplicatedNodeIndex==0
    for OO=1:size(BoundObj,1)
        plot([BoundObj{OO,1}(:,1); BoundObj{OO,1}(1,1)],...
             [BoundObj{OO,1}(:,2); BoundObj{OO,1}(1,2)],...
             '.-', 'Color', 'k');
    end
elseif DuplicatedNodeIndex==1
    for OO=1:size(BoundObj,1)
        plot(BoundObj{OO,1}(:,1),...
             BoundObj{OO,1}(:,2),...
             '.-', 'Color', 'k');
    end
end

title(Title)
axis equal
axis([0,XAxisLim,0,YAxisLim])

end
