%% CSNW_Laser.m Core-shell nanowire lasing behavior by pumping power
%% By Zhihuan Wang 10-13-2016
%% Source code adapted from McMaster University Hua Wang.

clear
hold off
format long e
% Some variables through all program
global taur taup q d P0 h f sigmagp n0 tfinal bit_seq N

%% 1. Basic constants
cc = 2.99793e8; % Velocity of light in free space, unit: m/s
q=1.60218e-19; % Unit electron charge, unit: C
eV=1.60218e-19; % Unit electron voltage, unit: J
h=6.6256e-34; % Planck's constant, unit: Js
kB = 1.38054e-23; % Boltzmann's constant, unit: J/K or Ws/K

%% 2. CSNW laser Data input
w = 300.0e-9; % Width of active area, unit:m
d=300.0e-9; % Thickness of active area, unit:m
L=3.0e-6; % Length of active area, unit:m
taur = 1.0e-9; % Time constant or lifetime of carrier(electron and hole),unit:s
tausp = 1.0e-9; % Time constant or lifetime of spontaneous emission, unit: s
sigmag = 3.0e-20; % Gain cross-section coefficient, unit: m^2
nth = 4.5e24; % Threshold carrier density, unit: m^(-3)
alphac = 2000.0; % Cavity loss, unit: m^(-1)
gamma = 0.756; % Confinement factor of laser, unit: none
neff = 2.728; % Effective index, unit: none
ng = 3.5; % Group index, unit: none
p0 = 200.0e-6; % pumping power of laser, unit: W
wv =800e-9; % working wavelength, unit:m

%% 3. Calculation of derived parameters
area_I = w*L; % Area of top section of active area, unit:m^2
area_P = w*d; % Area of cross section of active area, unit:m^2
vg = cc/ng; % Group velocity of light, unit: m/s
taup = 1/(vg*alphac); % Time constant or lifetime of photon, unit: s
sigmagp = sigmag*gamma*vg; % sigmagp = sigmag*gamma*vg
P0 = p0/area_P; % Pumping power density, unit: W/m^2
n0 = nth-1/(sigmagp*taup); % Transparency value of electron density,unit:m^(-3)
f = cc/wv; % The operating frequency, unit: Hz
Pth = h*f*d*nth/taur; % Threshold pumping power density, unit: W/m^2
Power_th = Pth*area_P ; % Threshold pumping power, unit: W
power_analyt = w*h*f*vg*taup*(P0-Pth)/q;% Analytical output power,unit: W

%% 4. Calculation of basic gain coefficient
%4.1 gain with carrier density
nn=0.5e24:0.01e24:10.0e24; gg=sigmag.*(nn-n0);
for i=1:length(nn),if gg(i)<0, gg(i)=0.0; end,end
gg1=sigmag.*sqrt(abs(nn-0.83*n0).^3)*1.0e-12;
for i=1:20,gg1(i)=0.0; end
plot(nn*1.0e-6,gg*1e-2,nn*1.0e-6,gg1*1e-2,'--'); grid;
xlabel('Carrier density n (1/cm^3)');ylabel('Gain coefficient gm (1/cm)');

%4.2 Output power with input pumping power
pp_temp = taup*vg*h*f/q/L;
ii=1.0e-6:0.1e-7:200.0e-6; pp=pp_temp.*(ii-Power_th);
for i=1:length(ii),if pp(i)<0, pp(i)=0.0; end,end
figure,plot(ii*1.0e6,pp*1.0e3); grid;
xlabel('Pumping Power (uW)');ylabel('Output power (mW)');

%% 5. Output power under steady state
tfinal = 0.5e-9; % Final time, unit: s
options = odeset('RelTol',1e-10,'AbsTol',[1e-10 1e-10 ]);
[T,Y] = ode45('rate_eqn_steady',[0 tfinal], [1e-30 1e-30],options);
power = Y(:,1)*h*f*vg*w*d; % Numerical output power,unit: W
figure; plot(T*1e9,power);grid, % Plot steady state optical power
xlabel('Time(ns)');ylabel('The steady state optical power(W)');
gain = sigmagp*(Y(:,2)-n0); % Numerical output gain
for i=1:length(gain),if gain(i)<0, gain(i)=0.0; end,end
figure; plot(T*1e9,gain);grid, % Plot steady state optical gain
xlabel('Time(ns)');ylabel('The steady state gain Gm');

% function of the steady rate equation
function x = rate_eqn_steady(t,y)
global taur taup q d P0 sigmagp n0 h f
Gm = sigmagp*(y(2)-n0);
yp1 = Gm*y(1)-y(1)/taup;
yp2 = -Gm*y(1)-y(2)/taur + P0/(h*f*d);
x = [yp1 yp2]';
