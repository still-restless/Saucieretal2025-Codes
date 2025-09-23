clear all
close all
clc

%% Units
% Geometric Volume [cm^3]
% Weight [g]
% Length [mm]
% Diameter [mm]
% Pycno_Volume [cm^3]
% Connected_Porosity [cm^3]



%% Get sample names
load("Weight_and_Size.mat")
ID = Weight_and_Size.sampleId(1:end);

%% Clean Volume data from Pycnometer
load Pycnometer.mat
%{
% Look at the reruns and compare them to the original
figure
title('Enclave b')
hold on
plot(Pycnometer.Enclavb.rawdata,'o-')
plot(Pycnometer.Enclabb.rawdata,'o-')
legend({'original';'rerun'},'Location','northwest')

figure
title('LV23_1')
hold on
plot(Pycnometer.LV23_1c.rawdata,'o-')
plot(Pycnometer.LV231cc.rawdata,'o-')
legend({'original';'rerun'},'Location','northwest')

% Combine the two runs together
Pycnometer.Enclavb.rawdata = [Pycnometer.Enclavb.rawdata;Pycnometer.Enclabb.rawdata];
Pycnometer.LV23_1c.rawdata = [Pycnometer.LV23_1c.rawdata;Pycnometer.LV231cc.rawdata];
%}

% Remove the min and max / or begining of run (look at notebook)
for n = 1:length(ID)
    figure
    plot(Pycnometer.(char(ID(n))).rawdata,'o-')
    title(char(ID(n)))
    pointslist = selectdata;
    % Have a struct array with average of volume
    Pycnometer.(char(ID(n))).avg = mean(Pycnometer.(char(ID(n))).rawdata(pointslist));
    Pycnometer.(char(ID(n))).std = std(Pycnometer.(char(ID(n))).rawdata(pointslist));
end



%% Make a Geometric Volume struct
for n = 1:length(ID)
    Sample.(char(ID(n))).Geometric_Volume = table2array(Weight_and_Size(Weight_and_Size.sampleId==char(ID(n)),"geometricVolumecm3"));
    Sample.(char(ID(n))).Weight = table2array(Weight_and_Size(Weight_and_Size.sampleId==char(ID(n)),"weightg"));
    Sample.(char(ID(n))).Length = table2array(Weight_and_Size(Weight_and_Size.sampleId==char(ID(n)),"lengthmm"));
    Sample.(char(ID(n))).Diameter = table2array(Weight_and_Size(Weight_and_Size.sampleId==char(ID(n)),"diametermm"));
    Sample.(char(ID(n))).Pycno_Volume = Pycnometer.(char(ID(n))).avg;
    % Make a Connected Porosity Struct
    % Connected Porosity = Geometric Volume - Pycnometer Volume
    Sample.(char(ID(n))).Connected_Porosity = 100*(Sample.(char(ID(n))).Geometric_Volume - Sample.(char(ID(n))).Pycno_Volume)./Sample.(char(ID(n))).Geometric_Volume;
end

%% Isolate the Permeability runs (2 - 4 per sample)
load Permeameter.mat

for n = 1:length(ID)
    figure
    title(char(ID(n)))
    hold on
    plot(table2array(Permeameter.(char(ID(n))).rawdata(:,1)),table2array(Permeameter.(char(ID(n))).rawdata(:,2)))
    plot(table2array(Permeameter.(char(ID(n))).rawdata(:,1)),table2array(Permeameter.(char(ID(n))).rawdata(:,3)))
    legend({'2L';'50ml'})
end



Sensor = [3 2 3 2]'
Plateau = [3 3 3 3]'

for n = 1:length(ID)
    for m = 1:Plateau(n)
    figure
    plot(table2array(Permeameter.(char(ID(n))).rawdata(:,1)),table2array(Permeameter.(char(ID(n))).rawdata(:,Sensor(n))),'.')
    title([char(ID(n)) '_run' num2str(m)])
    pointslist = selectdata;
    Permeameter.(char(ID(n))).(['run' num2str(m)]).Flow_Rate = table2array(Permeameter.(char(ID(n))).rawdata(pointslist,Sensor(n)));
    Permeameter.(char(ID(n))).(['run' num2str(m)]).Upstream_Pressure_MPa = table2array(Permeameter.(char(ID(n))).rawdata(pointslist,5));
    Permeameter.(char(ID(n))).(['run' num2str(m)]).Upstream_Pressure_psi = table2array(Permeameter.(char(ID(n))).rawdata(pointslist,7));
    Permeameter.(char(ID(n))).(['run' num2str(m)]).Confining_Pressure_MPa = table2array(Permeameter.(char(ID(n))).rawdata(pointslist,4));
    Permeameter.(char(ID(n))).(['run' num2str(m)]).Confining_Pressure_psi = table2array(Permeameter.(char(ID(n))).rawdata(pointslist,6));
    Permeameter.(char(ID(n))).(['run' num2str(m)]).Time = table2array(Permeameter.(char(ID(n))).rawdata(pointslist,1));
    end
end


%% Remove bad data from runs
for n = 1:length(ID)
     runs = {'run1';'run2';'run3'};
     for m = 2:length(runs)
         plot(Permeameter.(char(ID(n))).(char(runs(m))).Time/60,Permeameter.(char(ID(n))).(char(runs(m))).Flow_Rate,'o')
         title([char(ID(n)) '_run' num2str(m)])
    pointslist = selectdata;
    Permeameter.(char(ID(n))).(char(runs(m))).Flow_Rate = Permeameter.(char(ID(n))).(char(runs(m))).Flow_Rate(pointslist);
    Permeameter.(char(ID(n))).(char(runs(m))).Upstream_Pressure_MPa = Permeameter.(char(ID(n))).(char(runs(m))).Upstream_Pressure_MPa(pointslist);
    Permeameter.(char(ID(n))).(char(runs(m))).Upstream_Pressure_psi = Permeameter.(char(ID(n))).(char(runs(m))).Upstream_Pressure_psi(pointslist); 
    Permeameter.(char(ID(n))).(char(runs(m))).Confining_Pressure_MPa = Permeameter.(char(ID(n))).(char(runs(m))).Confining_Pressure_MPa(pointslist);
    Permeameter.(char(ID(n))).(char(runs(m))).Confining_Pressure_psi = Permeameter.(char(ID(n))).(char(runs(m))).Confining_Pressure_psi(pointslist); 
    Permeameter.(char(ID(n))).(char(runs(m))).Time = Permeameter.(char(ID(n))).(char(runs(m))).Time(pointslist);
     end
end

%% Determine if you nedd a Forchheimer correction
% Permeablity = dynamic_viscosity *(flow_rate/((upstream_pressure)/length)) 
for n = 1:length(ID)
     runs = fieldnames(Permeameter.(char(ID(n))));
     figure
     hold on
     xlabel('Flow Rate [ml/min]')
     ylabel('1 / Measured Gas Permeability [m^2]')
     title([char(ID(n))])
     for m = 2:(length(runs)-1)
        eta = 17.82e-6; % [Pa s] Dynamic Viscosity of Nitrogen at 25 degree celcius
        u = (Permeameter.(char(ID(n))).(char(runs(m))).Flow_Rate./(pi*(Sample.(char(ID(n))).Diameter./2).^2))*1e-6*(1/60)*(1/1e-6); % [m^3 s^-1 m^-2] Flow rate from permeameter divided by the cross sectional area of the core
        P = Permeameter.(char(ID(n))).(char(runs(m))).Upstream_Pressure_MPa*1e6; % [Pa]
        l = Sample.(char(ID(n))).Length*0.001; % [m] Length of the sample
        k = eta *(u./((P)./l)); % [m^2]

        qqqqqq = mean(Permeameter.(char(ID(n))).(char(runs(m))).Flow_Rate);
        kkkkkk = mean(1./k);
        yneg = abs(min(1./k)-kkkkkk);
        ypos = abs(max(1./k)-kkkkkk);
        xneg = abs(min(Permeameter.(char(ID(n))).(char(runs(m))).Flow_Rate)-qqqqqq);
        xpos = abs(max(Permeameter.(char(ID(n))).(char(runs(m))).Flow_Rate)-qqqqqq);
        errorbar(qqqqqq,kkkkkk,yneg,ypos,xneg,xpos,'o')
        Permeameter.(char(ID(n))).(char(runs(m))).Permeability = k;
     end
end


%% Determine if you nedd a Klinkenburg correction
% Permeablity = dynamic_viscosity *(flow_rate/((upstream_pressure)/length)) 
for n = 1:length(ID)
     runs = fieldnames(Permeameter.(char(ID(n))));
     figure
     hold on
     xlabel('1/P_m')
     ylabel('Measured Gas Permeability [m^2]')
     % xlabel('Flow Rate [ml/min]')
     % ylabel('1 / Measured Gas Permeability [m^2]')
     title([char(ID(n))])
     for m = 2:(length(runs)-1)
        eta = 17.82e-6; % [Pa s] Dynamic Viscosity of Nitrogen at 25 degree celcius
        u = (Permeameter.(char(ID(n))).(char(runs(m))).Flow_Rate./(pi*(Sample.(char(ID(n))).Diameter./2).^2))*1e-6*(1/60)*(1/1e-6); % [m^3 s^-1 m^-2] Flow rate from permeameter divided by the cross sectional area of the core
        P = Permeameter.(char(ID(n))).(char(runs(m))).Upstream_Pressure_MPa*1e6; % [Pa]
        l = Sample.(char(ID(n))).Length*0.001; % [m] Length of the sample
        k = eta *(u./((P)./l)); % [m^2]

        Mean_P = (P)./2;
        PPPPPP = mean(1./Mean_P);
        kkkkkk = mean(k);
        yneg = abs(min(k)-kkkkkk);
        ypos = abs(max(k)-kkkkkk);
        xneg = abs(min(1./Mean_P)-PPPPPP);
        xpos = abs(max(1./Mean_P)-PPPPPP);
        % plot(1./Mean_P,k,'o')
        errorbar(PPPPPP,kkkkkk,yneg,ypos,xneg,xpos,'o')
        Permeameter.(char(ID(n))).(char(runs(m))).Permeability = k;
     end
end


%% Aply corretion if necessary

%% Make a table for perm and porosity
Perm = [];
Por = [];

for n = 1:length(ID)
     runs = fieldnames(Permeameter.(char(ID(n))));
     Permeameter.(char(ID(n))).All_Permeability = [];
     Permeameter.(char(ID(n))).Permeability = [];
     for m = 2:(length(runs)-2)
         Permeameter.(char(ID(n))).All_Permeability = [Permeameter.(char(ID(n))).All_Permeability; Permeameter.(char(ID(n))).(char(runs(m))).Permeability];
         Permeameter.(char(ID(n))).Permeability = [Permeameter.(char(ID(n))).Permeability; mean(Permeameter.(char(ID(n))).(char(runs(m))).Permeability)]
     end
     Sample.(char(ID(n))).Permeability = mean(Permeameter.(char(ID(n))).Permeability);
     Perm(n) = log10(Sample.(char(ID(n))).Permeability);
     yneg(n) = abs(min(log10(Permeameter.(char(ID(n))).All_Permeability))-Perm(n));
     ypos(n) = abs(max(log10(Permeameter.(char(ID(n))).All_Permeability))-Perm(n));
     xneg(n) = Pycnometer.(char(ID(n))).std;
     xpos(n) = Pycnometer.(char(ID(n))).std;
     Por(n) = Sample.(char(ID(n))).Connected_Porosity;
end

Data = table(ID,Perm',Por',xpos',xneg',ypos',yneg');
Data.Properties.VariableNames{'Var2'} = 'Permeability [m^2]';
Data.Properties.VariableNames{'Var3'} = 'Porosity [%]'
Data.Properties.VariableNames{'Var4'} = 'xpos'
Data.Properties.VariableNames{'Var5'} = 'xneg'
Data.Properties.VariableNames{'Var6'} = 'ypos'
Data.Properties.VariableNames{'Var7'} = 'yneg'

%% Plot permeability vs porosity


% assign colour to samples
f = figure
f.Position = [100 100 1000 600];
hold on

sz = 7


for n = 1:size(Data)
    s = char(Data.ID(n));
    if s(1:6) == "CC23_2";
        plot(Por(n),log10(Perm(n)),'dk','MarkerSize',sz)
    elseif s(1:6) == "CC23_4";
        plot(Por(n),log10(Perm(n)),'ok','MarkerSize',sz)
    elseif s(1:6) == "LV23_1";
        plot(Por(n),log10(Perm(n)),'^k','MarkerSize',sz)
    elseif s(1:6) == "LV23_2";
        plot(Por(n),log10(Perm(n)),'vk','MarkerSize',sz)
    elseif s(1:6) == "Enclav";
        plot(Por(n),log10(Perm(n)),'sk','MarkerSize',sz)
    end
    
end

    plot(Por,log10(Perm),'+k','MarkerSize',10)
    ylabel('Permeability [m^2]')
    xlabel('Porosity %')
    ylim([-17.5 -12])
    xlim([0 40])

    set(gca, 'YScale', 'log');


