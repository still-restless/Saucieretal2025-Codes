close all
clear all
clc

%% To do
% Update the enclave number so that it does no exceed 20% of the volume be
% carfull here of distinguidhing the volume of the enclave vs the volume of
% the pockets around it.

%% Size of Gas pockets
% Assuming the geometry of a high permeability pocket can be aproximated by
% the shape of an ellipsoid with side a and b = c, where b is the diameter
% of an enclave, and a is the furtherst point of increase permeability from
% the center of the enclave, as observed in the Chaos Craggs and Lassen
% Peak Permeability Maps.
% The smallest and largest enclave + pressure shadow pairs were measured
% and averaged (source image j of CC_E)
a = [0.366,0.079]; % [m] 
b = [0.147,0.060]./2; % [m] divide by 2 to get radius
c = b;
volume_of_elipse = mean((4/3).*pi.*a.*b.*c); %[m^3]
% The volume of this ellipse comprises both the pore spaces as well as the
% rock portions. To get the pore space volume, we will then use the
% porosity of the sample.
porosity = 0.15*2; % (doubled pycnometer data of CC_E which was a non-pressure shaow sample)
porosity = 0.2*1 + 0.8*porosity; % visual estimate + lab meaurments (void space = 20% of ellipsoid)
pocket_pore_volume = volume_of_elipse*porosity % [m^3]

volume_of_enclave = mean((4/3).*pi.*b.*b.*c); %[m^3]
enclav_per_m3 = [50:25:125];
Enclave_percent = volume_of_enclave.*enclav_per_m3.*100
%% Compressed Volume of Gas in average ash and gas venting explosion at Santiaguito
% First we need to find the mass of major volatile species (H2O,CO2,SO2)
T_SO2_2008_09 = 385*1000; %[g] additional SO2 during eruption compared to backroug degassing Holland et al., 2011
% gas ratio for Pacaya Volcano, Guatemala: We find in-plume H2O/SO2 and
% CO2/SO2 ratios of 2-20 and 0.6-10.5 (Battaglia et al., 2018)
% for Santiaguito, assume H2O/SO2 = 10 and CO2/SO2 = 5
T_H2O = T_SO2_2008_09*10; %[g]
T_CO2 = T_SO2_2008_09*5; %[g]

% Next we need to find their compressed volumes using the ideal gas law
rho = 2700; % [kg/m^3]
g = 9.81; % [m/s^2]
h = [100:10:1600]; %[m]
P = rho*g.*h; % [Pa]
Temperature = [900:100:1200]; % [K] temperature from Poas volcano (max that I've found for andesitic continental arc volcanoes)
R = 8.314;
fig = figure
colororder({'k','c'})
yyaxis left
hold on
%%%%%% Plot gas volume in pocket vs depth 
% dpeth of fracture network could be from 80m to 1km (evidence from Mont St- Helens whaleback Freedlander )
for n = [4 3 2 1]
    T = Temperature(n)
mol_mass_SO2 = 64.7; %[g/mol]
n_SO2 = T_SO2_2008_09/mol_mass_SO2;
V_SO2 = n_SO2*R*T./P; %[m3]

mol_mass_CO2 = 44.01; %[g/mol]
n_CO2 = T_CO2/mol_mass_CO2;
V_CO2 = n_CO2*R*T./P; %[m3]

mol_mass_H2O = 18.02; %[g/mol]
n_H2O = T_H2O/mol_mass_H2O;
V_H2O = n_H2O*R*T./P; %[m3]

Volume_of_puff_compressed = V_H2O + V_CO2 + V_SO2; %[m3

plot(h,Volume_of_puff_compressed,'k','LineWidth',2)
end
xlabel('Depth [m]')
ylabel('Compressed Volume of Gas [m^3]')
ax = gca;
ax.YAxis(1).Color = 'k';
%set(gca, 'YDir','reverse')

T = 1200;
mol_mass_SO2 = 64.7; %[g/mol]
n_SO2 = T_SO2_2008_09/mol_mass_SO2;
V_SO2 = n_SO2*R*T./P; %[m3]

mol_mass_CO2 = 44.01; %[g/mol]
n_CO2 = T_CO2/mol_mass_CO2;
V_CO2 = n_CO2*R*T./P; %[m3]

mol_mass_H2O = 18.02; %[g/mol]
n_H2O = T_H2O/mol_mass_H2O;
V_H2O = n_H2O*R*T./P; %[m3]

Volume_of_puff_compressed = V_H2O + V_CO2 + V_SO2; %[m3

%% How many pockets
nb_pockets = Volume_of_puff_compressed./pocket_pore_volume;


%% How big would that be in the conduit?
circumference_conduit = 2*pi*9; %[m]
length_of_conduit = 1500; %[m]
thickness_of_shear_zone = 1; %[m]
aspectratio = 100;

yyaxis right

hold on

ylabel('Volume of Sheared Enclave Bearing Lava')
for n = [1:length(enclav_per_m3)]
    plot(h(36:end),nb_pockets(36:end)/enclav_per_m3(n),'LineWidth',2)
end 
legend({'1200K';'1100K';'1000K';'900K';'50 enclave/m^3';'75 enclave/m^3';'100 enclave/m^3';'125 enclave/m^3'})

%%
for m=[3] 
    for n=[51]
        h = h(n)
        enclav_per_m3 = enclav_per_m3(m)
        x = 4
        y = (nb_pockets(n)/enclav_per_m3)/x
    end
end


