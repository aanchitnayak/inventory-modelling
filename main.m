%% 
clc
clear all
close all

%% Defining the model 
Lm = 15;
T = 365-52;
S = 100;
s = 25;
storageCosts = 2;
rate = 2.5;

pdDemand = makedist('Normal',20,5);
pdLeadTime = makedist('Normal',2,0.75);

figure
plot(-50:50,pdf(pdDemand,-50:50),'Linewidth',2.5)
hold on
histogram(random(pdDemand,10000,1),'Normalization','pdf')
xlim([-10,50])
ylim([0,0.1])
grid on
title('Probability Distribution for Demand')
xlabel('Order Quantity')
ylabel('Probability')

figure
plot(-2:0.025:6,pdf(pdLeadTime,-2:0.025:6),'Linewidth',2.5)
hold on
histogram(random(pdLeadTime,5000,1),'Normalization','pdf')
% xlim([-10,50])
% ylim([0,0.1])
grid on
title('Probability Distribution for Lead Time')
xlabel('Time Taken')
ylabel('Probability')

%% One Year, Single Trajectory
output = ClassicSsModel(rate,storageCosts,S,s,Lm,T,pdDemand,pdLeadTime);

% Analysis and Plots based on Single Year and Single Trajector Simulation
ModelAnalysisPlotter(output)
clear ans
clc

%% Monte Carlo Simulation - Simulating Multiple Trajectories
% T = 365-52+1;
MCLength = 150;
MCX = zeros(T+1,MCLength);
MCCh = zeros(T+1,MCLength);
MCCo = zeros(T+1,MCLength);
MCR = zeros(T+1,MCLength);
MCI = zeros(T+1,MCLength);
for k = 1:MCLength
    output = ClassicSsModel(rate,storageCosts,S,s,Lm,T,pdDemand,pdLeadTime);
    MCX(:,k) = output(:,1);
    MCCh(:,k) = output(:,2);
    MCCo(:,k) = output(:,3);
    MCR(:,k) = output(:,4);
    MCI(:,k) = output(:,5);
end 
T = 365-52+1;
figure
subplot(331)
stairs(MCR)
xlim([0,T])
grid on
xlabel('Time')
title('Revenue Generated')
subplot(333)
stairs(MCCo)
xlim([0,T])
grid on
xlabel('Time')
title('Cost of Re-Supplying Inventory')
subplot(335)
stairs(MCX)
title('Net Profit')
xlim([0,T])
grid on
xlabel('Time')
subplot(337)
stairs(MCCh)
xlim([0,T])
grid on
xlabel('Time')
title('Cost of Storage')
subplot(339)
stairs(MCI)
xlim([0,T])
grid on
xlabel('Time')
title('Inventory Level')
clc

%% Manual Sensitivity Tests - Poisson Rate Lambda
LmTest = [6;15;s;0.5*S;S;2*S];
for i = 1:length(LmTest)
   output = ClassicSsModel(rate,storageCosts,S,s,LmTest(i),T,pdDemand,pdLeadTime);
   LmTestX(:,i) = output(:,1);
   LmTestCh(:,i) = output(:,2);
   LmTestCo(:,i) = output(:,3);
   LmTestR(:,i) = output(:,4);
   LmTestI(:,i) = output(:,5);
end

%At Lambda = 1, the profit diverges negatively. Try to explain this
%behaviour. This type of decrease continues till Lambda = 5. Post this, the
%revenue increases as lambda increases
%% Plotting Output Variable as they change with Lm
figure
stairs(LmTestX)
title('Variation in Net Profit as \lambda changes')
xlabel('Time')
ylabel('X_t')
grid on
xlim([0,T])
legend('\lambda = 6','\lambda = 15','\lambda = s','\lambda = S/2','\lambda = S','\lambda = 2S','Location','northwest')
figure
stairs(LmTestCh)
title('Variation in Storage Costs as \lambda changes')
xlabel('Time')
ylabel('Ch_t')
grid on
xlim([0,T])
legend('\lambda = 6','\lambda = 15','\lambda = s','\lambda = S/2','\lambda = S','\lambda = 2S','Location','northwest')
figure
stairs(LmTestCo)
title('Variation in Re-Supply Cost as \lambda changes')
xlabel('Time')
ylabel('Co_t')
grid on
xlim([0,T])
legend('\lambda = 6','\lambda = 15','\lambda = s','\lambda = S/2','\lambda = S','\lambda = 2S','Location','northwest')
figure
stairs(LmTestR)
title('Variation in Net Revenue as \lambda changes')
xlabel('Time')
ylabel('R_t')
grid on
xlim([0,T])
legend('\lambda = 6','\lambda = 15','\lambda = s','\lambda = S/2','\lambda = S','\lambda = 2S','Location','northwest')
figure
stairs(LmTestI)
title('Variation in Inventory Level as \lambda changes')
xlabel('Time')
ylabel('I_t')
grid on
xlim([0,T])
legend('\lambda = 6','\lambda = 15','\lambda = s','\lambda = S/2','\lambda = S','\lambda = 2S','Location','northwest')

%% Manual Sensitivity Tests - Selling Price Variation
rTest = [1;rate;5;10];
for i = 1:length(rTest)
   output = ClassicSsModel(rTest(i),storageCosts,S,s,Lm,T,pdDemand,pdLeadTime);
   rTestX(:,i) = output(:,1);
   rTestCh(:,i) = output(:,2);
   rTestCo(:,i) = output(:,3);
   rTestR(:,i) = output(:,4);
   rTestI(:,i) = output(:,5);
end

%% Plotting Variations of Output Variables with r
figure
stairs(rTestX)
title('Variation in Net Profit as r changes')
xlabel('Time')
ylabel('X_t')
grid on
xlim([0,T])
legend('r = 1','r = 2.5','r = 5','r = 10','Location','northwest')
figure
stairs(rTestCh)
title('Variation in Storage Costs as r changes')
xlabel('Time')
ylabel('Ch_t')
grid on
xlim([0,T])
legend('r = 1','r = 2.5','r = 5','r = 10','Location','northwest')
figure
stairs(rTestCo)
title('Variation in Re-Supply Cost as r changes')
xlabel('Time')
ylabel('Co_t')
grid on
xlim([0,T])
legend('r = 1','r = 2.5','r = 5','r = 10','Location','northwest')
figure
stairs(rTestR)
title('Variation in Net Revenue as r changes')
xlabel('Time')
ylabel('R_t')
grid on
xlim([0,T])
legend('r = 1','r = 2.5','r = 5','r = 10','Location','northwest')
figure
stairs(rTestI)
title('Variation in Inventory Level as r changes')
xlabel('Time')
ylabel('I_t')
grid on
xlim([0,T])
legend('r = 1','r = 2.5','r = 5','r = 10','Location','northwest')
%Make Observations and add them post plots in the Live Script

%% Sensitivity Analysis - Storage Costs
h = storageCosts;
hTest = [1;0.5*h;h;2*h;3*h];
for i = 1:length(hTest)
   output = ClassicSsModel(rate,hTest(i),S,s,Lm,T,pdDemand,pdLeadTime);
   hTestX(:,i) = output(:,1);
   hTestCh(:,i) = output(:,2);
   hTestCo(:,i) = output(:,3);
   hTestR(:,i) = output(:,4);
   hTestI(:,i) = output(:,5);
end
%%

figure
stairs(hTestX)
legend('h=1','h = 0.5H','h = H','h = 2H','3H','Location','northwest');
title('Variation in Profit with change in Storage Cost h (H = 2)')
xlabel('Time')
ylabel('X_t')
grid on

figure
stairs(hTestCh)
legend('h=1','h = 0.5H','h = H','h = 2H','3H','Location','northwest');
title('Variation in Net Storage Costs with change in Storage Cost h (H = 2)')
xlabel('Time')
ylabel('C_{ht}')
grid on

figure
stairs(hTestCo)
legend('h=1','h = 0.5H','h = H','h = 2H','3H','Location','northwest');
title('Variation in Re-Supply Costs with change in Storage Cost h (H = 2)')
xlabel('Time')
ylabel('C_{ot}')
grid on

figure
stairs(hTestR)
legend('h=1','h = 0.5H','h = H','h = 2H','3H','Location','northwest');
title('Variation in Net Revenue with change in Storage Cost h (H = 2)')
xlabel('Time')
ylabel('R_t')
grid on

figure
stairs(hTestI)
legend('h=1','h = 0.5H','h = H','h = 2H','3H','Location','northwest');
title('Variation in Inventory Level with change in Storage Cost h (H = 2)')
xlabel('Time')
ylabel('I_t')
grid on
% Make Observations and include in final report

%% Sensitivity Analysis - S - Parameter
STest = 1:100;

%% Graphs

%% Sensitivity Analysis - s - Parameter
sTest = 1:100;

%% Graphs
