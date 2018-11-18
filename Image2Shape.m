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

function Image2Shape
%%
SetGlobal;
figure(1);

BoundPix=[];
BoundXY=[];

% ConvexingFactor = .8;
% 0 : gives the convex hull, 
% 1 : gives a compact boundary that envelops the points.

% 1 Simple tension test (Square RVE)
% 2 Simple shear test (Square RVE)
% 3 Three-point beam bending test
% 4 Four-point beam bending test
% 5 Semi-circular bending test
% 6 Indirect tension test

% IXDim/BorderLimFactor : max accepted distance that an agg can be nearby the border 
BorderLimFactor = 100;

IXDim = Dim_w; % in meter
IYDim = Dim_h; % in meter
% =========================================================================
% =========================================================================
% =========================================================================   
% PRELIMINARY JOBs
% Read Image
I = imread([MixtureImagePath, MixtureImageName]);
subplot(1,2,1);imshow(I);

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
% REMOVING SMALL PARTICLES -second time - after all adjustments
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
% in case of SCB: remove unneccessary object at top corners
if TestType==5
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
% REMOVE UNNECESSARY VERTICES using reducem
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
% REMOVE UNNECESSARY VERTICES based on area
% remove nodes that their absence would not change particle geometry more
% than areaTol
areaTolFactor = 80;
% areaTol = area/areaTolFactor

for OO = 1:size(BoundXY,1)

    XX = BoundXY{OO,1}(:,1);
    YY = BoundXY{OO,1}(:,2);
    initialObjectArea = polyarea(XX,YY);
    
    % find candidate nodes for deletion
    mustDeleteNodes = [];
    for VV = 2: size(BoundXY{OO,1},1)-1
        XXX = XX;
        XXX(VV)=[];
        
        YYY = YY;
        YYY(VV)=[];

        newObjectArea = polyarea(XXX,YYY);                   
        if abs(newObjectArea - initialObjectArea) <= initialObjectArea/areaTolFactor
            if (isempty(mustDeleteNodes))
                mustDeleteNodes = [mustDeleteNodes; VV];
            elseif (VV ~= mustDeleteNodes(end)+1 )
                mustDeleteNodes = [mustDeleteNodes; VV];
            end
        
        end
    end
        
    % delete candidate nodes
%     disp(initialObjectArea)
%     disp(size(mustDeleteNodes,1))
    if ~isempty(mustDeleteNodes)
        BoundXY{OO,1}(mustDeleteNodes,:) = [];
    end
end
BoundXY = BoundXY(~cellfun(@isempty, BoundXY));
% =========================================================================
% MERGE adjacent nodes to boundary with boundary

for OO = 1:size(BoundXY,1)
    for VV = 1: size(BoundXY{OO,1},1)
        if TestType==1 || TestType==2 || TestType==3 || TestType==4 
            if abs(BoundXY{OO,1}(VV,1) - 0)     <= IXDim/BorderLimFactor;   BoundXY{OO,1}(VV,1) = 0; end
            if abs(BoundXY{OO,1}(VV,1) - IXDim) <= IXDim/BorderLimFactor;   BoundXY{OO,1}(VV,1) = IXDim; end
            if abs(BoundXY{OO,1}(VV,2) - 0)     <= IYDim/BorderLimFactor;   BoundXY{OO,1}(VV,2) = 0; end
            if abs(BoundXY{OO,1}(VV,2) - IYDim) <= IYDim/BorderLimFactor;   BoundXY{OO,1}(VV,2) = IYDim; end
        elseif TestType==5
            if abs(BoundXY{OO,1}(VV,2) - 0)     <= IYDim/BorderLimFactor;   BoundXY{OO,1}(VV,2) = 0; end
        end
    end
end
% =========================================================================
% REMOVING SMALL PARTICLES -second time - after all adjustments
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
cla(subplot(1,2,2))
subplot(1,2,2);
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
