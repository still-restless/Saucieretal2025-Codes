clear all
close all
clc

import_data

%% Units
% Geometric Volume [cm^3]
% Weight [g]
% Length [mm]
% Diameter [mm]
% Pycno_Volume [cm^3]
% Connected_Porosity [cm^3]



%% Get sample names
ID = Weight_and_Size.sampleId(2:end);

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

%}

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
%{
for n = 1:length(ID)
    figure
    title(char(ID(n)))
    hold on
    plot(table2array(Permeameter.(char(ID(n))).rawdata(:,1)),table2array(Permeameter.(char(ID(n))).rawdata(:,2)))
    plot(table2array(Permeameter.(char(ID(n))).rawdata(:,1)),table2array(Permeameter.(char(ID(n))).rawdata(:,3)))
    legend({'2L';'50ml'})
end
%}
load Permeameter.mat
%{
Sensor = [3 3 3 3 3 3 2 3 3 3 3 3 3 3 ]'
Plateau = [2 2 2 3 3 3 3 2 3 3 4 3 3 3]'

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
     runs = fieldnames(Permeameter.(char(ID(n))));
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
%}

load Permeameter.mat

%% Convert data to permeability
% Permeablity = dynamic_viscosity *(flow_rate/((upstream_pressure)/length)) 
for n = 1:length(ID)
     runs = fieldnames(Permeameter.(char(ID(n))));
     figure
     hold on
     xlabel('1/P_m')
     ylabel('Measured Gas Permeability [m^2]')
     title([char(ID(n))])
     for m = 2:length(runs)
        eta = 17.82e-6; % [Pa s] Dynamic Viscosity of Nitrogen at 25 degree celcius
        u = (Permeameter.(char(ID(n))).(char(runs(m))).Flow_Rate./(pi*(Sample.(char(ID(n))).Diameter./2).^2))*1e-6*(1/60)*(1/1e-6); % [m^3 s^-1 m^-2] Flow rate from permeameter divided by the cross sectional area of the core
        P = Permeameter.(char(ID(n))).(char(runs(m))).Upstream_Pressure_MPa*1e6; % [Pa]
        l = Sample.(char(ID(n))).Length*0.001; % [m] Length of the sample
        k = eta *(u./((P)./l)); % [m^2]
        Mean_P = (P)./2;
        plot(1./Mean_P,k,'o');
        Permeameter.(char(ID(n))).(char(runs(m))).Permeability = k;
% EFFECTIVE MEAN PRESSURE NEEDS FIXING
% WE MEASURE UPSTREAM P RELATIVE TO ATMOSPHERE -> IT IS THE DIFFERENTIAL p
     end
end

%% Determine if you nedd a Klinkenburg correction

%% Aply corretion if necessary

%% Make a table for perm and porosity
Perm = [];
Por = [];

for n = 1:length(ID)
     runs = fieldnames(Permeameter.(char(ID(n))));
     Permeameter.(char(ID(n))).Permeability = [];
     for m = 2:length(runs)
         Permeameter.(char(ID(n))).Permeability = [Permeameter.(char(ID(n))).Permeability; Permeameter.(char(ID(n))).(char(runs(m))).Permeability];   
     end
     Sample.(char(ID(n))).Permeability = mean(Permeameter.(char(ID(n))).Permeability);
     Perm(n) = Sample.(char(ID(n))).Permeability;
     Por(n) = Sample.(char(ID(n))).Connected_Porosity;
end

Data = table(ID,Perm',Por');
Data.Properties.VariableNames{'Var2'} = 'Permeability [m^2]';
Data.Properties.VariableNames{'Var3'} = 'Porosity [%]'

%% Plot permeability vs porosity
cd Heap_2021\
load('CCC.csv');
load('CC10.csv');
load('CC4B.csv');
load('CC4A.csv');
cd ..
load("DataApril25.mat");
DataApril25 = table2array(DataApril25(:,2:3))
% assign colour to samples
f = figure
f.Position = [100 100 1000 600];
subplot(1,2,1)
hold on
% 
% semilogy(CC10(:,1)*100,CC10(:,2),'ks')
% semilogy(CCC(:,1)*100,CCC(:,2),'ko')
% % semilogy(CC4B(:,1)*100,CC4B(:,2),'kv')
% % semilogy(CC4A(:,1)*100,CC4A(:,2),'k^')
sz = 7

plot(mean(CC10(:,1))*100,log10(mean(CC10(:,2))),'kd','MarkerSize',sz,'MarkerFaceColor','k')
plot(mean(CCC(:,1))*100,log10(mean(CCC(:,2))),'ko','MarkerSize',sz,'MarkerFaceColor','k')
plot(mean(CC4B(:,1))*100,log10(mean(CC4B(:,2))),'kv','MarkerSize',sz,'MarkerFaceColor','k')
plot(mean(CC4A(:,1))*100,log10(mean(CC4A(:,2))),'k^','MarkerSize',sz,'MarkerFaceColor','k')

plot(DataApril25([1,3],2),log10(DataApril25([1,3],1)),'ok','MarkerSize',sz)
plot(DataApril25([2,4],2),log10(DataApril25([2,4],1)),'vr','MarkerSize',sz)

for n = 1:size(Data)
    s = char(Data.ID(n));
    if s(1:7) == "CC23_2a";
        plot(Por(n),log10(Perm(n)),'dr','MarkerSize',sz)
    elseif s(1:6) == "CC23_2";
        plot(Por(n),log10(Perm(n)),'dk','MarkerSize',sz)
    elseif s(1:6) == "CC23_4";
        plot(Por(n),log10(Perm(n)),'or','MarkerSize',sz)
    elseif s(1:6) == "LV23_1";
        plot(Por(n),log10(Perm(n)),'vk','MarkerSize',sz)
    elseif s(1:6) == "LV23_2";
        plot(Por(n),log10(Perm(n)),'^k','MarkerSize',sz)
    elseif s(1:6) == "Enclav";
        plot(Por(n),log10(Perm(n)),'sk','MarkerSize',sz)
    end
    
end

    % p = semilogy(Por,Perm,'+k','MarkerFaceColor',colors,'MarkerSize',10)
    % FN = strrep(ID, '_', ' ');
    % row1 = dataTipTextRow('ID',FN);
    % p.DataTipTemplate.DataTipRows(1) = row1; %maybe check this one
    % row2 = dataTipTextRow('Perm',Perm);
    % p.DataTipTemplate.DataTipRows(2) = row2; %maybe check this one
    % row3 = dataTipTextRow('Por',Por);
    % p.DataTipTemplate.DataTipRows(3) = row3; %maybe check this one
    ylabel('Permeability [m^2]')
    xlabel('Porosity %')
    ylim([-17.5 -12])

    set(gca, 'YScale', 'log');


%% Boxplot
cd ..
cd TinyPerm_Grid_Matlab\
loadgrids
cd ..
cd Sample_Characterisation\

x = [];
g = [];
Detail = struct();
Detail.CC23_2.Perm = CC23_2(:);
Detail.CC23_4.Perm = CC23_4(:);
Detail.LV23_2.Perm = LV23_2(:);
Detail.LV23_1.Perm = LV23_1(:);

subplot(1,2,2)
hold on
% plot([0 5],Perm(12)*ones(1,2),'k');
% plot([0 5],Perm(13)*ones(1,2),'k');
% plot([0 5],Perm(14)*ones(1,2),'k');

fieldss = fieldnames(Detail);
for n = 1:length(fieldss)
    Name = char(fieldss(n));
    x1 = Detail.(Name).Perm;
    x = [x; x1]; %permeability of each sample for plot
    g = [g; repmat(Name, length(x1), 1)];
end

% boxplot(x,g,'Color',[0.7 0.7 0.7]);


% overlay the scatter plots
fieldss
corr = 1;
for n=1:length(fieldss)
    Name = char(fieldss(n));
    hs = scatter(ones(size(Detail.(Name).Perm)) + n-corr,  log10(Detail.(Name).Perm),"filled",'MarkerFaceColor',[0.1 0.1 0.1],'jitter','on','JitterAmount',0.1,'MarkerFaceAlpha', 0.2);
end

% overlay the lab permeability data
YY = Perm'
YY = YY(1:11)
scatter([1 1 1], log10(YY(1:3)),'dk','jitter','on','JitterAmount',0.1);
scatter([2 2 2], log10(YY(4:6)),'ok','jitter','on','JitterAmount',0.1);
scatter([4 4 4], log10(YY(7:9)),'vk','jitter','on','JitterAmount',0.1);
scatter([3 3], log10(YY(10:11)),'^k','jitter','on','JitterAmount',0.1);

scatter([2],log10([mean(CC10(:,2))]),'kd','MarkerFaceColor','k','jitter','on','JitterAmount',0.1);
scatter([2],log10([mean(CCC(:,2))]),'ko','MarkerFaceColor','k','jitter','on','JitterAmount',0.1);
scatter([2],log10([mean(CC4B(:,2))]),'kv','MarkerFaceColor','k','jitter','on','JitterAmount',0.1);
scatter([2],log10([mean(CC4A(:,2))]),'k^','MarkerFaceColor','k','jitter','on','JitterAmount',0.1);

ylabel('Permeability [m^2]')
xlim([0 5])
ylim([-17.5 -12])
xlabel('name')

