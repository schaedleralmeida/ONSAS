%md# A Linear Beam Element Analysis Example
%md
%md## Previous definitions
close all, clear all;
addpath( genpath( [ pwd '/../../src' ] ) ) ; % add ONSAS directory to path
%md
%md scalar auxiliar parameters
E = 210e6 ; L = 5 ; nu = 0.3 ;
b = 0.3 ; % cross-section svgwidth
P = 5  ; % applied nodal load
%md
%md## MEBI parameters: Material-Element-BoundaryConditions-InitialConditions
%md
%md### Materials
materials.hyperElasModel = 'linearElastic' ;
materials.hyperElasParams = [ E, nu] ;
%md### Elements
elements(1).elemType  = 'node'  ;
elements(2).elemType  = 'frame' ;
elements(2).elemTypeGeometry = [2, b, b] ;
elements(2).elemTypeParams   =  1 ;
%md### BoundaryConditions
% Supports
boundaryConds(1).imposDispDofs = [ 1 2 3 4 5 6 ] ;
boundaryConds(1).imposDispVals = [ 0 0 0 0 0 0 ] ;
% Loads
boundaryConds(2).loadsCoordSys = 'global' ;
boundaryConds(2).loadsBaseVals = [ 0 0 0 0 -P 0] ;
%md### InitialConditions
%md empty struct
initialConds = struct() ;
%md
%md## Mesh
%md Mesh nodes
mesh.nodesCoords = ...
					[ 0 		0	 0		; ...
						L   	0  0 	; ...
						2*L   0  0 	; ...
						2*L   0  L 	] ;
%md Conec Cell
mesh.conecCell = { } ;
%md Node elements. It is important to observe that only nodes with a boundary condition assigned are required to be included in the connectivity cell
mesh.conecCell{1,1} = [ 0 1 1 0 1 ] ;
mesh.conecCell{2,1} = [ 0 1 2 0 4 ] ;
%md Frame elements
mesh.conecCell{3,1} = [ 1 2 0 0   1 2 ] ;
mesh.conecCell{4,1} = [ 1 2 0 0   2 3 ] ;
mesh.conecCell{5,1} = [ 1 2 0 0   3 4 ] ;

% Analysis settings
analysisSettings = struct() ;

otherParams.problemName = 'linearBeamElement' ;
%otherParams.plotsFormat = 'vtk' ;

[matUs, loadFactorsMat] = ONSAS( materials, elements, boundaryConds, initialConds, mesh, analysisSettings, otherParams ) ;

%md## Verification
A = b^2 ;  I = b^4/12 ;
axial = E*A/L *2;  bending = E*I/L^3 *4*L^2*2 ;

flechaTeo = P*(2*L)^3 / (3*E*I) ;
flechaNum = -matUs( 2*6+5, 2 ) ;
verifBoolean = abs( flechaTeo - flechaNum  ) < ( 1e-4 * abs( flechaTeo ) )

nodesx = mesh.nodesCoords( :, 1 ) ;
nodesz = mesh.nodesCoords( :, 3 ) ;

scalefac = 1e2;
nodesxdef = nodesx + scalefac * matUs(1:6:end,2) ;
nodeszdef = nodesz + scalefac * matUs(5:6:end,2) ;

figure, hold on
plot( nodesx, nodesz, 'b-o' )
grid on
plot( nodesxdef, nodeszdef, 'r-s' )
axis equal