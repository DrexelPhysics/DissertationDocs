%% gain (Gain Spectral Analysis Method to determin the enhancement factor for redueced dimensionality
% with Approximations for simple geometry and variables) 
% Modified for single band transitions and without scattering broadening effect

% Created on 8/25/2014 By Zhihuan Wang (GaAs/AlGaAs core-shell nanowire)
% Modified by 11/4/2016
clc; close all;

J_eV = 1.60217657e-19; %Joules per eV
eV_J = 6.24150934e18; % eV per Joule

%% Photon energy & system input (variables initiate)
E_ph = 1.2:0.01:2;
n = 6e18:3e18:3e19;
p = 6e18:3e18:3e19;  % Hole carrier concentration, Unit [cm^-3]

k = length(E_ph);
len_n = length(n);
abs_coef3D = size(k);
abs_coef2D = size(k);
abs_coef1D = size(k);
k0_3D = size(k);
gain_3D = size(k, len_n);
gain_2D = size(k, len_n);
gain_1D = size(k, len_n);
enhance_abs = size(k);
sp_rate3D = size(k);
sp_rate2D = size(k);
sp_rate1D = size(k);
enhance_sp = size(k);
st_rate3D = size(k);
st_rate2D = size(k);
st_rate1D = size(k);
enhance_st = size(k); 

f_v = size(k, len_n);
f_c = size(k, len_n);
Fc = size(len_n);
Fv = size(len_n);

maxgain_3D = size(len_n);
maxgain_2D = size(len_n);
maxgain_1D = size(len_n);
%% Refractive index without material dispersion 
% Uncommented if need dispersion
n_r = 3.312; % refractive index without material dispersion

%% Parameters in MKS units
H_j = 6.63e-34;%Plancks constant [J.s]
H = 4.14e-15;%Plancks constant [eV.s]
H_rj = 1.05e-34;% Reduced Plancks constant [J.s]
H_r = 6.58e-16;% Reduced Plancks constant [eV.s]
C = 3e10; %speed of light [cm/s]
e = 1.6e-19; %elementary charge [C]
kB = 1.38*10^-23; % Boltzmann's constant [J/K]
T = 300; % room temperature [K]
m0 = 9.11e-31; % Electron rest mass [kg]
Eg=1.424; %Energy bandgap for GaAs at 300K [eV]
m_e = 0.067*m0; %Electron Effective mass for GaAs[unitless /m0]
m_h = 0.47*m0; %Hole Effective mass for GaAs 3D[unitless /m0]
m_h2D = 0.118*m0; %Hole Effective mass for GaAs 2D[unitless /m0]
m_h1D = 0.027*m0; %Hole Effective mass for GaAs 1D[unitless /m0]
m_hh = 0.50*m0; %heavey hole Effective mass for GaAs[unitless /m0]
m_lh = 0.087*m0; %Light hole Effective mass for GaAs[unitless /m0]
m_r = m_e*m_h/(m_e+m_h); % Reduced effective mass
m_r2D = m_e*m_h/(m_e+m_h2D); % Reduced effective mass 2D
m_r1D = m_e*m_h/(m_e+m_h1D); % Reduced effective mass 1D

m0SI = 5.693e-16; %Electron rest mass [kg]
m_eSI = 0.067*m0SI; %Electron Effective mass for GaAs[unitless /m0]
m_hSI = 0.47*m0SI; %Hole Effective mass for GaAs 3D[unitless /m0]
m_rSI = m_eSI*m_hSI/(m_eSI+m_hSI); % Reduced effective mass

m00 = 9.11*10^-28; %Electron rest mass [kg]
m_ee = 0.067*m00; %Electron Effective mass for GaAs[unitless /m0]
m_hh = 0.47*m00; %Hole Effective mass for GaAs 3D[unitless /m0]
m_rr = m_ee*m_hh/(m_ee+m_hh); % Reduced effective mass
m_rr2D = m_e*m_h/(m_e+m_h2D); % Reduced effective mass 2D
m_rr1D = m_e*m_h/(m_e+m_h1D); % Reduced effective mass 1D

Lx = 50e-8; % 50 A for length [cm]
Ly = 50e-8;
Lz = 50e-8;
Lz3D = 50e-5; % 50000 A for length [cm]
Lz2D = 50e-10; % 5000 A for length [cm]
Lz1D = 50e-6; % 50 A for length [cm]
Lzm = 100e-10;
a = 100e-10; %nanowire crosssection [m]
b = 100e-10;
p_cv = 2.88*10^-18;
f_cv = 23; %oscillator strength 3D [eV]
f_cv1D = 230; %oscillator strength 1D [eV]
eps_0 = 8.85e-14; % Permittivity of vacuum [F/cm]
Nwr = 1/(Lx*Ly); %nanowire density [cm^-2]
Ep = 25.7; % Energy parameter [eV]
%% quantized energy state for 2D
E_e1 = H_rj^2*pi^2/(2*m_e*Lzm^2)*eV_J;
E_h1 = H_rj^2*pi^2/(2*m_h*Lzm^2)*eV_J;
E_e2 = H_rj^2*pi^2*4/(2*m_e*Lzm^2)*eV_J;
E_h2 = H_rj^2*pi^2*4/(2*m_h*Lzm^2)*eV_J;
E_e3 = H_rj^2*pi^2*9/(2*m_e*Lzm^2)*eV_J;
E_h3 = H_rj^2*pi^2*9/(2*m_h*Lzm^2)*eV_J;

E_e1h1 = Eg+E_e1+E_h1; %E_h should be negative value.
E_e2h2 = Eg+E_e2+E_h2;
E_e3h3 = Eg+E_e3+E_h3;

%% quantized energy state for 1D 
E_11 = Eg+H_rj^2/(2*m_r)*((pi/a)^2+(pi/b)^2)*eV_J;
E_12 = Eg+H_rj^2/(2*m_r)*((pi/a)^2+(pi*2/b)^2)*eV_J;
E_22 = Eg+H_rj^2/(2*m_r)*((pi*2/a)^2+(pi*2/b)^2)*eV_J;
E_23 = Eg+H_rj^2/(2*m_r)*((pi*2/a)^2+(pi*3/b)^2)*eV_J;
E_33 = Eg+H_rj^2/(2*m_r)*((pi*3/a)^2+(pi*3/b)^2)*eV_J;

%% Fermi distribution
Na = 1e11;%acceptor doping concentration
Nd = 1e11;%donor doping concentration
Nc = 2*(2*pi*m_e*kB*T/H_j^2)^1.5*10^-6;
Nv = 2*(2*pi*m_h*kB*T/H_j^2)^1.5*10^-6;
for j=1:len_n
Fc(j)= kB*T*(log(n(j)./Nc) + 1/sqrt(8)*(n(j)./Nc))*eV_J;
Fv(j)= kB*T*(log(p(j)./Nv) + 1/sqrt(8)*(p(j)./Nv))*eV_J;
end

% Check Joyce-Dixon approximation applicable range -1<theta<7
theta = size(len_n);
for j=1:len_n
    theta(j)= log(n(j)/Nc)+2^(-1.5)*(n(j)/Nc);
end

Ec =size(k);
Ev =size(k);
for j=1:len_n
for i=1:k
k0_3D(i) = sqrt(2*m_r*((E_ph(i)-Eg)*J_eV)/H_rj^2);
Ev(i) = -H_rj.^2*k0_3D(i).^2/(2*m_h);
Ec(i) = Eg+H_rj.^2*k0_3D(i).^2/(2*m_e);
f_c(i,j) = (1 + exp((  m_r/m_e*(E_ph(i) - Eg) - Fc(j))/(kB*T*eV_J))).^-1;
f_v(i,j) = (1 + exp(( - m_r/m_h*(Eg - E_ph(i)) + Fv(j))/(kB*T*eV_J))).^-1;
end
end

figure;
plot(E_ph, f_c, E_ph, f_v, E_ph, f_c-f_v);

%% Gain Spectrum: Gain=Absorption Coefficent* fermi distribution (g(hw)=a0(hw)[fv(k0)-fc(k0)])
% Without Linewidth Broadening
fe = size(k,len_n);
for j=1:len_n
for i=1:k
if E_ph(i)< Eg
gain_3D(i,j) = 0;
else
gain_3D(i,j) = (sqrt(2)*m_r^1.5*(e*eV_J)^2*(1.5*m0*Ep*J_eV/6))/(3*pi*n_r*m0*eps_0*C*H_rj^2*E_ph(i))*(E_ph(i)-Eg)^0.5*(f_c(i,j)-f_v(i,j));
end

if E_ph(i)< E_e1h1
    gain_2D(i,j) = 0; 
elseif E_e1h1<= E_ph(i)
    gain_2D(i,j) = (e^2*pi*H_r*(1.5*m0*Ep*J_eV/6)*2)/(3*n_r*eps_0*C*m0^2*E_ph(i))*m_r2D/(H_rj^2*pi*Lz)*(f_c(i,j)-f_v(i,j));
end

if E_ph(i)< E_11
   gain_1D(i,j) = 0; 
elseif E_11<= E_ph(i)
   gain_1D(i,j) = (e^2*pi*H_r*Nwr)/(3*n_r*eps_0*C*m0^2*E_ph(i))*(m0*Ep*10*J_eV/6)*(m_r1D^1.5/(pi*H_rj*m_e*Lx*Ly))*((E_ph(i)-E_11))^-0.5*(f_c(i,j)-f_v(i,j));
end

maxgain_3D(j)= max(gain_3D(:,j));
maxgain_2D(j)= max(gain_2D(:,j));
maxgain_1D(j)= max(gain_1D(:,j));
enhance_abs(i,j) = gain_2D(i,j)/gain_3D(i,j);

end
end

%% Plotting the results
figure;
subplot(2,2,1);
plot (E_ph, gain_3D,'LineWidth',4)
title('Gain coefficient versus photon energy for 3D')
ylabel ('Gain coefficient (/cm)')
xlabel ('photon energy (eV)')
grid on,

subplot(2,2,2);
plot (E_ph, gain_2D,'LineWidth',4)
title('Gain coefficient versus photon energy for 2D')
ylabel ('Gain coefficient (/cm)')
xlabel ('photon energy (eV)')
grid on,

subplot(2,2,3);
plot (E_ph, gain_1D,'LineWidth',4)
title('Gain coefficient versus photon energy for 1D')
ylabel ('Gain coefficient (/cm)')
xlabel ('photon energy (eV)')
grid on,

subplot(2,2,4);
plot (n, maxgain_2D,'LineWidth',4)
title('Maximum gain versus carrier density')
ylabel ('Gain coefficient (/cm)')
xlabel ('Carrier density (1/cm^2)')
grid on,
%% Curve fitting in order to find the threshold carrier density 
% which is nth = 4.533*10^18 (1/cm^3)

nth = 4.533*10^18; % Unit (1/cm^3)
% nth = Ntr*exp(gth/g0)

%% Fermi distribution for threshold carrier density
Fc_th= kB*T*(log(nth/Nc) + 1/sqrt(8)*(nth/Nc))*eV_J;
Fv_th= kB*T*(log(nth/Nv) + 1/sqrt(8)*(nth/Nv))*eV_J;   

f_vth = size(k);
f_cth = size(k);
for i=1:k
f_vth(i) = (1 + exp(( - m_r/m_h*(E_ph(i) - Eg) + Fv_th)/(kB*T*eV_J))).^-1;
f_cth(i) = (1 + exp((  m_r/m_e*(E_ph(i) - Eg) - Fc_th)/(kB*T*eV_J))).^-1;
end

%% Calculating rsp and Rsp based on the threshold carrier density
% Spontaneous Emission Spectrum: sp_rate = Emission Probability * Density of States * fermi distribution 
% (sp_rate(hw)=Pem*Nj(hw)*[fv(k0)-fc(k0)])

for i=1:k
if E_ph(i)< Eg
sp_rate3D(i) = 0;
else
sp_rate3D(i) = (n_r*e^2*E_ph(i)*Ep*J_eV/6)/(pi*m0^2*eps_0*C^3*H_r^2)*((2*m_r)^1.5)/(2*pi^2*H_r^3)*((E_ph(i)-Eg)*J_eV)^0.5*(f_cth(i)*(1-f_vth(i)));
end

if E_ph(i)< E_e1h1
    sp_rate2D(i) = 0; 
elseif E_e1h1<= E_ph(i)
sp_rate2D(i) = (n_r*e^2*E_ph(i)*J_eV*Ep*J_eV/6)/(pi*m0^2*eps_0*C^3*H_r^2)*(m_r2D*2)/(pi*H_r^2*Lz2D)*(f_cth(i)*(1-f_vth(i)));
end

if E_ph(i)< E_11
   sp_rate1D(i) = 0; 
elseif E_11<= E_ph(i)
sp_rate1D(i) = (n_r*e^2*E_ph(i)*J_eV*Ep*J_eV/6)/(pi*m0^2*eps_0*C^3*H_r^2)*(m_r1D^1.5/(pi*H_r*m_e*Lz1D*Lz1D))*(E_ph(i)-E_11)^-0.5*(f_cth(i)*(1-f_vth(i)));
end


end

Rst_3D = trapz(sp_rate3D');
Rst_2D = trapz(sp_rate2D');
Rst_1D = trapz(sp_rate1D');

%% Threshold current calculation

Jth_3D = e*Lz*Rst_3D;
Jth_2D = e*Lz*Rst_2D;
Jth_1D = e*Lz*Rst_1D;

%% Optical Outpul Power

P_3D = (Eg+0.0257/2)*Lz*Rst_3D;
P_2D = (Eg+0.0257/2)*Lz*Rst_2D;
P_1D = (Eg+0.0257/2)*Lz*Rst_1D;
enhance_2D = P_2D/P_3D
enhance_1D = P_1D/P_3D

%% Plotting the results
figure;
subplot(2,2,1);
plot (E_ph, sp_rate3D)
title('Spontaneous Emission Rate versus photon energy for 3D')
ylabel ('Spontaneous Emission Rate (/cm)')
xlabel ('photon energy (eV)')
grid on,

subplot(2,2,2);
plot (E_ph, sp_rate2D)
title('Spontaneous Emission Rate versus photon energy for 2D')
ylabel ('Spontaneous Emission Rate (/cm)')
xlabel ('photon energy (eV)')
grid on,

subplot(2,2,3);
plot (E_ph, sp_rate1D)
title('Spontaneous Emission Rate versus photon energy for 1D')
ylabel ('Spontaneous Emission Rate (/cm)')
xlabel ('photon energy (eV)')
grid on,

subplot(2,2,4);
barx = [1 2 3];
bary = [Jth_3D, Jth_2D, Jth_1D];
bar (barx,bary);
set(gca,'YScale','log');
set(gca,'XTickLabel',{'3D', '2D', '1D'});
for i1=1:numel(bary)
    text(barx(i1),bary(i1),num2str(bary(i1),'%2.2E'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom')
end
title('Threshold Current density for different dimensionality')
ylabel ('Threshold Current Density (A/cm^2)')
xlabel ('Dimensions')
grid on,


%% Additional overlapping Plot
figure;
ax1 = gca;
get(ax1,'Position');
set(ax1,'XColor','k',...
    'YColor','b');
line(E_ph,sp_rate1D, 'Color', 'b', 'LineStyle', '-', 'Marker', '.', 'Parent', ax1, 'DisplayName', '1D','LineWidth',4)
legend show
ax2 = axes('Position',get(ax1,'Position'),...
           'XAxisLocation','bottom',...
           'YAxisLocation','left',...
           'Color','none',...
           'YLim',[0,10*10^4],...
           'YTick',[1*10^4, 3*10^4, 5*10^4, 7*10^4, 9*10^4],...
           'XColor','k',...
           'YColor','r',...
           'XTick',[],'XTickLabel',[]);
       set(gca, 'YTickLabel', num2str(reshape(get(gca, 'YTick'),[],1),'%.d') );
       ylabel ('Spontaneous Emission Rate (/cm.s)')
line(E_ph,sp_rate2D, 'Color', 'r', 'LineStyle', '-', 'Marker', '.', 'Parent', ax2,'DisplayName', '2D','LineWidth',4)
legend show
ax3 = axes('Position',get(ax1,'Position'),...
           'XAxisLocation','bottom',...
           'YAxisLocation','right',...
           'Color','none',...
           'YLim',[0,10*10^3],...
           'YTick',[1*10^3, 3*10^3, 5*10^3, 7*10^3, 9*10^3],...
           'XColor','k',...
           'YColor','g',...
           'XTick',[],'XTickLabel',[]);
line(E_ph,sp_rate3D, 'Color', 'g', 'LineStyle', '-', 'Marker', '.', 'Parent', ax3,'DisplayName', '3D','LineWidth',4)
legend show
ylabel ('Spontaneous Emission Rate (/cm.s)')
xlabel ('Photon energy (eV)')
xlabh = get(gca,'XLabel');
set(xlabh,'Position',[get(xlabh,'Position') - [0 0.2 0]]);
grid on,
