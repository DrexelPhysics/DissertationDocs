%% absrate (Absorption Rate Analysis Method to determin the enhancement factor for redueced dimensionality
% with Approximations for simple geometry and variables) 

% Modified on 8/14/2014 By Zhihuan Wang (GaAs/AlGaAs core-shell nanowire)

clc; close all;
clear all;
J_eV = 1.60217657e-19; %Joules per eV
eV_J = 6.24150934e18; % eV per Joule

%% Photon energy & system input (variables initiate)
E_ph = 1.2:0.01:2;

k = length(E_ph);
abs_coef3D = size(k);
abs_coef2D = size(k);
abs_coef2DD = size(k);
abs_coef1D = size(k);
enhance_abs = size(k);
sp_rate3D = size(k);
sp_rate2D = size(k);
sp_rate1D = size(k);
enhance_sp = size(k);
st_rate3D = size(k);
st_rate2D = size(k);
st_rate1D = size(k);
enhance_st = size(k); 

%% Refractive index without material dispersion 
% Uncommented if need dispersion
n_r = 3.312; % refractive index without material dispersion

%% Parameters in MKS units
% H = 6.63e-34;%Plancks constant [J.s]
% H = 4.14e-15;%Plancks constant [eV.s]
H_rj = 1.05e-34;% Reduced Plancks constant [J.s]
H_r = 6.58e-16;% Reduced Plancks constant [eV.s]
% Lambda = 1550; %wavelength of continuous wave laser (units: nm)
C = 3e10; %speed of light [cm/s]
% % C = 3e5; %speed of light [nm/ps]
% V = 3e8/1550e-9; %frequency of the propagating light [Hz]
e = 1.6e-19; %elementary charge [C]
% % e = 4.8e-10;
q = sqrt(14.399e-10); %elementary charge [sqrt(eV.m)] or sqrt(1.4399)  [sqrt(MeV.fm)] femtometer
m0SI = 9.11e-31; %Electron rest mass [kg]
m0 = 9.11e-28;
% Vt = 0.02585; %Thermal voltage at 300K [eV]
Eg=1.424; %Energy bandgap for GaAs at 300K [eV]
m_eSI = 0.067*m0SI; %Electron Effective mass for GaAs[unitless /m0]
m_hSI = 0.47*m0SI; %Hole Effective mass for GaAs 3D[unitless /m0]
m_h2DSI = 0.118*m0SI; %Hole Effective mass for GaAs 2D[unitless /m0]
m_h1DSI = 0.027*m0SI; %Hole Effective mass for GaAs 1D[unitless /m0]
m_hhSI = 0.50*m0SI; %heavey hole Effective mass for GaAs[unitless /m0]
m_lhSI = 0.087*m0SI; %Light hole Effective mass for GaAs[unitless /m0]
m_rSI = m_eSI*m_hSI/(m_eSI+m_hSI); % Reduced effective mass
m_r2DSI = m_eSI*m_hSI/(m_eSI+m_h2DSI); % Reduced effective mass 2D
m_r1DSI = m_eSI*m_hSI/(m_eSI+m_h1DSI); % Reduced effective mass 1D
m_e = 0.067*m0; %Electron Effective mass for GaAs[unitless /m0]
m_h = 0.47*m0; %Hole Effective mass for GaAs 3D[unitless /m0]
m_h2D = 0.118*m0; %Hole Effective mass for GaAs 2D[unitless /m0]
m_h1D = 0.027*m0; %Hole Effective mass for GaAs 1D[unitless /m0]
m_hh = 0.50*m0; %heavey hole Effective mass for GaAs[unitless /m0]
m_lh = 0.087*m0; %Light hole Effective mass for GaAs[unitless /m0]
m_r = m_e*m_h/(m_e+m_h); % Reduced effective mass
m_r2D = m_e*m_h2D/(m_e+m_h2D); % Reduced effective mass 2D
m_r1D = m_e*m_h1D/(m_e+m_h1D); % Reduced effective mass 1D
Lx = 50e-8; % 50 A for length [cm]
Ly = 50e-8;
Lz = 50e-8;
Lzm = 100e-10;
a = 100e-10; %nanowire crosssection [m]
b = 100e-10;
p_cv=2.88*10^-18;
f_cv = 23; %oscillator strength 3D [eV]
f_cv1D = 230; %oscillator strength 1D [eV]
% eps_0 = 8.85e-12; % Permittivity of vacuum [F/m]
eps_0 = 8.85e-14; % Permittivity of vacuum [F/cm]
Nwr=1/(Lx*Ly); %nanowire density [cm^-2]
Ep=25.7 % Energy parameter [eV]
%% quantized energy state for 2D
E_e1 = H_rj^2*pi^2/(2*m_eSI*Lzm^2)*eV_J;
E_h1 = H_rj^2*pi^2/(2*m_hSI*Lzm^2)*eV_J;
E_e2 = H_rj^2*pi^2*4/(2*m_eSI*Lzm^2)*eV_J;
E_h2 = H_rj^2*pi^2*4/(2*m_hSI*Lzm^2)*eV_J;
E_e3 = H_rj^2*pi^2*9/(2*m_eSI*Lzm^2)*eV_J;
E_h3 = H_rj^2*pi^2*9/(2*m_hSI*Lzm^2)*eV_J;

E_e1h1 = Eg+E_e1+E_h1; %E_h should be negative value.
E_e2h2 = Eg+E_e2+E_h2;                                                                                                                                                                                                                                                                                                                                                                                                                           
E_e3h3 = Eg+E_e3+E_h3;

%% quantized energy state for 1D 
E_11 = Eg+H_rj^2/(2*m_rSI)*((pi/a)^2+(pi/b)^2)*eV_J;
E_12 = Eg+H_rj^2/(2*m_rSI)*((pi/a)^2+(pi*2/b)^2)*eV_J;
E_22 = Eg+H_rj^2/(2*m_rSI)*((pi*2/a)^2+(pi*2/b)^2)*eV_J;
E_23 = Eg+H_rj^2/(2*m_rSI)*((pi*2/a)^2+(pi*3/b)^2)*eV_J;
E_33 = Eg+H_rj^2/(2*m_rSI)*((pi*3/a)^2+(pi*3/b)^2)*eV_J;
%% Joint Optical Density of States Calculation

% DOS_3D = (1/(2*pi^2))*((2*m_r/H_r^2)^1.5).* ((E_ph-Eg).^0.5);
% DOS_2D = m_r/(pi*H_r^2*Lz);
% DOS_1D = (m_r^1.5/(pi*H_r*m_e*Lx*Ly)).* (1/((E_ph-Eg).^0.5));
%% Absorption Coefficent
% C0 = pi*e^2/(n_r*eps_0*C*m0^2*omega);  %Absorption C0 coefficent
check = (e^2*(m0SI^0.5))/(4*pi*H_rj^2*eps_0*C)
check2 = (4.8*10^-10)^2*m0^0.5/(H_rj^2*C)
check3 = 4.8*10^-10*(sqrt(4*pi*eps_0))
check4 = 1/(4*pi*10^-9*C^2)

C1 = (q^2*m0^0.5)/(4*pi*H_r^2*n_r*eps_0*C)  %Absorption C1 coefficent
coef=2.64*10^5;
for i=1:k
if E_ph(i)< Eg
    abs_coef3D(i) = 0;
else
%     abs_coef(i)=5.6*10^4*(E_ph(i)-Eg)^0.5/E_ph(i);
    abs_coef3D(i) = (e^2*pi)/(n_r*eps_0*C*m0SI^2*E_ph(i)/H_r)*(m0SI*Ep*J_eV/6)*(2*m_rSI/H_rj^2)^1.5*(2*pi^2)^-1*((E_ph(i)-Eg)*J_eV)^0.5;
% abs_coef2D(i) = (e^2*pi)/(n_r*eps_0*C*m0SI^2*(E_ph(i)/H_r))*(1.5*m0SI*25.7*J_eV/6)*(2*m_rSI/H_rj^2)^1.5*(2*pi^2)^-1*((E_ph(i)-Eg)*J_eV)^0.5;
end

if E_ph(i)< E_e1h1
    abs_coef2D(i) = 0; 
elseif E_e1h1<= E_ph(i)&& E_ph(i)< E_e2h2
    abs_coef2D(i) = (e^2*pi*2)/(n_r*eps_0*C*m0SI^2*E_ph(i)/H_r)*(1.5*m0SI*Ep*J_eV/6)*m_r2DSI/(H_rj^2*pi*Lzm);
elseif E_e2h2<= E_ph(i)&& E_ph(i)< E_e3h3
    abs_coef2D(i) = (e^2*pi*3)/(n_r*eps_0*C*m0SI^2*E_ph(i)/H_r)*(1.5*m0SI*Ep*J_eV/6)*m_r2DSI/(H_rj^2*pi*Lzm); 
else
    abs_coef2D(i) = (e^2*pi*4)/(n_r*eps_0*C*m0SI^2*E_ph(i)/H_r)*(1.5*m0SI*Ep*J_eV/6)*m_r2DSI/(H_rj^2*pi*Lzm);
end

if E_ph(i)< E_11
    abs_coef1D(i) = 0; 
elseif E_11<= E_ph(i)&& E_ph(i)<= E_12
    abs_coef1D(i) = (e^2*Nwr)/(n_r*eps_0*C*m0SI^2*E_ph(i)/H_r)*(m0SI*Ep*10*J_eV/6)*(2*m_r1DSI/H_rj^2)^0.5*((E_ph(i)-E_11)*J_eV)^-0.5*10^4;
elseif E_12<= E_ph(i)&& E_ph(i)<= E_22
    abs_coef1D(i) = (e^2*Nwr*2)/(n_r*eps_0*C*m0SI^2*E_ph(i)/H_r)*(m0SI*Ep*10*J_eV/6)*(2*m_r1DSI/H_rj^2)^0.5*((E_ph(i)-E_12)*J_eV)^-0.5*10^4;
else
    abs_coef1D(i) = (e^2*Nwr)/(n_r*eps_0*C*m0SI^2*E_ph(i)/H_r)*(m0SI*Ep*10*J_eV/6)*(2*m_r1DSI/H_rj^2)^0.5*((E_ph(i)-E_22)*J_eV)^-0.5*10^4;
end


enhance_abs(i) = abs_coef2D(i)/abs_coef3D(i);
end
q = trapz(abs_coef3D')
q2D = trapz(abs_coef2D')
q1D = trapz(abs_coef1D')
enhance_factor=q2D/q
enhance_factor2=q1D/q

%% Plotting the results
subplot(3,1,1);
plot (E_ph, abs_coef3D)
title('Absorption coefficient versus photon energy for GaAs Bulk')
ylabel ('Absorption coefficient (/cm)')
xlabel ('photon energy (eV)')
grid on,

subplot(3,1,2);
plot (E_ph, abs_coef2D)
title('Absorption coefficient versus photon energy for Quantum Well')
ylabel ('Absorption coefficient (/cm)')
xlabel ('photon energy (eV)')
grid on,

subplot(3,1,3);
plot (E_ph, abs_coef1D)
title('Absorption coefficient versus photon energy for nanowire')
ylabel ('Absorption coefficient (/cm)')
xlabel ('photon energy (eV)')
grid on,

% subplot(2,2,4);
% plot (E_ph,enhance_abs)
% title(sprintf('Enhancement factor= %4.5f %4.5f', enhance_factor, enhance_factor2))
% ylabel ('Absorption coefficient (/cm)')
% xlabel ('photon energy (eV)')
% grid on,

figure;
ax1 = gca;
get(ax1,'Position')
set(ax1,'XColor','k',...
    'YColor','b');
line(E_ph,abs_coef3D, 'Color', 'b', 'LineStyle', '-', 'Marker', '.', 'Parent', ax1, 'DisplayName', '3D')
legend show
ax2 = axes('Position',get(ax1,'Position'),...
           'XAxisLocation','bottom',...
           'YAxisLocation','left',...
           'Color','none',...
           'YLim',[0,10*10^6],...
           'YTick',[1*10^6, 3*10^6, 5*10^6, 7*10^6, 9*10^6],...
           'XColor','k',...
           'YColor','r',...
           'XTick',[],'XTickLabel',[]);
       YTL = get(gca,'yticklabel');
% set(gca,'yticklabel',[YTL,repmat('  ',size(YTL,1),1)])
%         ytickh = get(gca,'YTick');
%         set(ytickh,'Position',get(ytickh,'Position') - [0 .2 0])
        ylabel ('Absorption coefficient (/cm)')
line(E_ph,abs_coef2D, 'Color', 'r', 'LineStyle', '-', 'Marker', '.', 'Parent', ax2,'DisplayName', '2D')
legend show
ax3 = axes('Position',get(ax1,'Position'),...
           'XAxisLocation','bottom',...
           'YAxisLocation','right',...
           'Color','none',...
           'XColor','k',...
           'YColor','g',...
           'XTick',[],'XTickLabel',[]);
line(E_ph,abs_coef1D, 'Color', 'g', 'LineStyle', '-', 'Marker', '.', 'Parent', ax3,'DisplayName', '1D')
legend show
% plot (E_ph,abs_coef3D,'b',E_ph,abs_coef2D,'ro',E_ph,abs_coef1D,'--k')
title(sprintf('Absorption coefficient versus photon energy for 1D 2D and 3D \n the Enhancement factor for 2D and 1D= %4.5f %4.5f', enhance_factor, enhance_factor2))
ylabel ('Absorption coefficient (/cm)')
xlabh = get(gca,'XLabel');
set(xlabh,'Position',get(xlabh,'Position') - [0 .2 0])
xlabel ('photon energy (eV)')
% legend('3D','2D','1D')
grid on,