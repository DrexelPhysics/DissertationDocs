%% Mode_CSNW_FDTD.m A program to solve confinement factor, effective
%% refractive index and mode effective area from the FDTD simulation results
%% Drexel University Zhihuan Wang 08-28-2016

clear;
%% 1. Open refractive index file and get directory
[FileName,PathName] = uigetfile('*.h5','Select the Meep hdf5 structure file',...
'C:\Users\wason\OneDrive\Documents\MATLAB\Laser_threshold');
if isequal(FileName,0)
   disp('User selected Cancel')
else
   f_nr=fullfile(PathName, FileName);
   disp(['User selected ', fullfile(PathName, FileName)])
end
% get info and data for the refractive index hdf5 file
hinfo = hdf5info(f_nr);
dset_nr = hdf5read(hinfo.GroupHierarchy.Datasets(1));
DissStruc=ndims(dset_nr)
SzStruc=size(dset_nr)
struc=squeeze(dset_nr(115,:,:));

%% 2. Open photon wave file and get directory
[FileName,PathName] = uigetfile('*.h5','Select the Meep hdf5 results file',...
'C:\Users\wason\OneDrive\Documents\MATLAB\Laser_threshold');
if isequal(FileName,0)
   disp('User selected Cancel')
else
   f=fullfile(PathName, FileName);
   disp(['User selected ', fullfile(PathName, FileName)])
end
% get info and data for the photon wave hdf5 file
hinfo = hdf5info(f);
dset = hdf5read(hinfo.GroupHierarchy.Datasets(1));
DissA=ndims(dset)
SzA=size(dset)

%% 3. process the data
xx=squeeze(dset(115,:,:));
yy=squeeze(dset(:,33,:));
zz=squeeze(dset(:,:,33));
% get the corners of the domain in which the data occurs.
min_xx = min(min(xx));
min_yy = min(min(yy));
max_xx = max(max(xx));
max_yy = max(max(yy));
min_zz = min(min(zz));
max_zz = max(max(zz));
% the image data you want to show as a plane.
planeimg = abs(xx);

%% 4. plotting the results
% set hold on so we can show multiple plots / surfs in the figure.
figure;
% surf(yy,zz)
surf(xx);
hold on;
% desired z possition of the image plane.
imgzposition=-0.25;
surf([0 67],[0 67],repmat(imgzposition, [2 2]),...
    planeimg,'facecolor','texture')
% surf([min_yy max_yy],[min_zz max_zz],repmat(imgzposition, [2 2]),...
%     planeimg,'facecolor','texture')
% set the view angle.
view(45,30);
colormap hsv
colorbar
% set a colormap for the figure.
colormap(jet);
% title
title('Volumetric Mode')
% labels
xlabel('x');
ylabel('y');
zlabel('z');

%% 4. Calculation of effective refractive index and confinement factor
idx = size (67,67);
for i=1:67
    for j=1:67
        if struc(i,j)> 1
        idx (i,j) = 1;
        else
            idx(i,j) = 0;
        end
    prm = logical(idx);
    end
end
wv = 1.55; %wavelength, unit: um
k0 = 2*pi/wv;

H = sparse(sqrt(struc));
[u, d] = eigs(H,2,'LR');

mode1 = xx; % modal profile of fundamental mode
% mode2 =reshape(u(:,2),Nx,Ny); % modal profile of first order mode
eff_neff1 = sqrt(d(1,1))/k0 % effective index of fundamental mode
% eff_neff2 = sqrt(d(2,2))/k0 % effective index of first order mode

% modal profile of fundamental mode in active area
mode1_active = xx(16:53,16:53);
gamma = norm(mode1_active,2)^2/norm(mode1,2)^2 %confinement factor
