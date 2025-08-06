
% Author: Emilie Saucier

% Last Updated: 2023/11/16

% Title: Plotting of Permeability Grid as surfaces

% Decription: This code as for purpose of ploting the data aquired during
% my August 2023 field work at Chaos Craggs. The data was aquired by taking
% permeability measurments of points along a grid. The code plots those
% permeability measurments using the coordinates of the grid. It does so
% using 3 different method. the first one with the matlab function
% pcolor(), the second with the matlab function surf() and the last one
% using a subsampling mehtod and ploting the new agmented grids as points
% that cover the entire surface.

clear all
close all
clc

loadgrids % load your grid matrices and coordinates

%% Plot pcolor()
Plot_pcolor(LV23_1,LV23_1_X, LV23_1_Y) % Plot the slab LV23_1 using pcolor()
% To see the difference in interpolation direction of pcolor, you need to
% export the figure as a svg file.

%% Plot surf()
Plot_surf(LV23_1,LV23_1_X, LV23_1_Y) % Plot the slab LV23_1 using surf()

%% Plot Perm with Coordinate surf
PlotSubSample(CC23_2_X, CC23_2_Y, CC23_2) % Plot the slab CC23_2 using subsampling
PlotSubSample(LV23_1_X, LV23_1_Y, LV23_1) % Plot the slab LV23_1 using subsampling
PlotSubSample(LV23_2_X, LV23_2_Y, LV23_2) % Plot the slab LV23_2 using subsampling

PlotSubSample(cm_X,cm_Y,cm)

%% Local Functions

function Plot_pcolor(grid,X,Y)
    f = figure; %initiate figure
    grid = log10(grid); %convert the permeability in the grid to log scale
    s = pcolor(X,Y,grid); %plot your grid using pcolor
    s.FaceColor = 'interp'; %interpolate your data on the plot
    set(gca,'YDir','reverse'); %make the y-axis go down to match the picture coordinates
    title([char(inputname(1)) ' pcolor()']) %generate the title of your plot using the input of the function
    c = colorbar; %display the colorbar
    c.Label.String = 'Permeability [log(m^2)]'; %add label to color bar
    axis equal  %make the x and y axis equal to repect aspect ratio of image
end

function Plot_surf(grid,X,Y)
    f = figure; %initiate figure
    grid = log10(grid); %convert the permeability in the grid to log scale
    s = surf(X,Y,grid,'FaceColor','interp'); %plot your grid using surf and interpolate the data
    view(2); %display plot as a 2D view
    set(gca,'YDir','reverse') %make the y-axis go down to match the picture coordinates
    title([char(inputname(1)) ' surf()']) %generate the title of your plot using the input of the function
    c = colorbar; %display the colorbar
    c.Label.String = 'Permeability [log(m^2)]'; %add label to color bar
    axis equal  %make the x and y axis equal to repect aspect ratio of image
end

function PlotSubSample(X,Y,grid)
    measuredX = X; %save the original X values
    measuredY = Y; %save the original Y values
    grid = log10(grid); %convert the permeability in the grid to log scale
    [grid,X,Y] = Add2Grid(grid,X,Y,5); %do 5 rounds of subsampling

    f = figure; %initiate figure
    [s1,s2] = size(grid); %get the size of the permeability grid
    X = reshape(X,[1,(s1*s2)]); %reshape your X coordinate to be one long vector
    Y = reshape(Y,[1,(s1*s2)]); %reshape your Y coordinate to be one long vector
    grid = reshape(grid,[1,(s1*s2)]); %reshape your grid to be one long vector
   
    s = scatter(X,Y,10,grid,'filled'); %plot your reampled and vectorized data
    hold on
    plot(measuredX,measuredY,'k') %plot the vertical grid line of original data
    plot(measuredX',measuredY','k') %plot the horizontal grid line of original data
    set(gca,'YDir','reverse') %make the y-axis go down to match the picture coordinates
    axis equal %make the x and y axis equal to repect aspect ratio of image
    c = colorbar; %display the colorbar
    cmap = crameri('hawaii') ; %load the acton colormap
    colormap(cmap); %use the new colormap
    % clim([-17 -12]) % To uncomment if you want the colorbar scale for all
                      % your plots to be the same
    title(char(inputname(3))) %generate the title of your plot using the input of the function
    c.Label.String = 'Permeability [log(m^2)]'; %add label to color bar
end

function [secondarygrid,secondaryX,secondaryY] = Add2Grid(grid,X,Y,n)
for m = [1:1:n] %run this n times
    % create new grid points
    % get new coordinates and values for center points
    centerX = (X(2:end,2:end)+X(2:end,1:end-1)+X(1:end-1,2:end)+X(1:end-1,1:end-1))/4;
    centerY = (Y(2:end,2:end)+Y(2:end,1:end-1)+Y(1:end-1,2:end)+Y(1:end-1,1:end-1))/4;
    centergrid = (grid(2:end,2:end)+grid(2:end,1:end-1)+grid(1:end-1,2:end)+grid(1:end-1,1:end-1))/4;

    % get new coordinates and values for horizontal points
    horizontalX = (X(:,2:end)+X(:,1:end-1))/2;
    horizontalY = (Y(:,2:end)+Y(:,1:end-1))/2;
    horizontalgrid = (grid(:,2:end)+grid(:,1:end-1))/2;

    % get new coordinates and values for vertical points
    verticalX = (X(2:end,:)+X(1:end-1,:))/2;
    verticalY = (Y(2:end,:)+Y(1:end-1,:))/2;
    verticalgrid = (grid(2:end,:)+grid(1:end-1,:))/2;

    % make into one big ordered matrix like such

    % X11 H11 X12 H12 ...
    % V11 C11 V12 C12 ...
    % X21 H21 X22 H22 ...
    % V21 C21 V22 C22 ...
    % ... ... ... ...

    % make the odd rows for coordinates and their value
    X_XH = [X horizontalX];
    Y_YH = [Y horizontalY];
    grid_gridH = [grid horizontalgrid];

    % make the even rows for coordinates and their value
    X_VC = [verticalX centerX];
    Y_VC = [verticalY centerY];
    grid_VC = [verticalgrid centergrid];

    % combine the rows to create new grid for coordinates and their value
    secondaryX = [X_XH; X_VC];
    secondaryY = [Y_YH; Y_VC];
    secondarygrid = [grid_gridH; grid_VC];

    % sort for X values
    [secondaryX,indexX]=sort(secondaryX,2); %make sure X coordinate are in ascending order
    secondaryY=secondaryY(:,indexX(1,:)); %update the Y-values to change along with the X-values

    % sort for Y values
    [secondaryY,indexY]=sort(secondaryY,1); %make sure Y coordinate are in ascending order
    secondaryX=secondaryX(indexY(:,1),:);  %update the X-values to change along with the Y-values

    % sort the grid
    secondarygrid = secondarygrid(indexY(:,1),indexX(1,:)); %update the grid according to the changes you did for the X and Y coordinates

    grid = secondarygrid; %update the grid to the the new augmented grid
    X = secondaryX; %update the X coordinates to the the new augmented X coordinates
    Y = secondaryY; %update the Y coordinates to the the new augmented Y coordinates
end
end

