
clear all;
clc

%% controlled plant

s  = tf('s');

n = 0;
L = 0.2;
T = 20;
Q_s  = 1;
P_s  = (T*s+1);
Dy_s = exp(-L*s);
GpL  = Dy_s*(Q_s)/(P_s*s^n);
Gp   = (Q_s)/(P_s*s^n);

%% paramaters

Ga = 1;
Gp.iodelay = 0;

step_value = 1;
sim_time   = 80;
disturb_step_time  = sim_time/2;
disturb_step_value = 0.5;

%% ZN-PI^\lambda D^\mu 1
kpo = 51.4369;
kio = 76.4505;
kdo = 11.2315;
mu  = 0.78;
r2  = 0.9;
lambda = mu*r2;

ifo = ousta_fod(-lambda,10,1e-5,1e+5);               % integral
dfo = ousta_fod(mu,10,1e-5,1e+5);                    % differential

warning off;
sim('Model_ZN_FOPID.mdl',sim_time);
close_system('Model_ZN_FOPID', 0);


timeFOPID1 = time;                                                  % 仿真结果, 传递全局变量
outFOPID1  = FOPID_out;

%% ZNZN-PI^\lambda D^\mu 2

clear kpo kio kdo mu r2 lambda ifo dfo time FOPID_out

kpo = 70.5120;
kio = 135.137;
kdo = 7.8174;
mu  = 1;
r2  = 0.8;
lambda = mu*r2;


ifo = ousta_fod(-lambda,10,1e-5,1e+5);               % integral
dfo = ousta_fod(mu,10,1e-5,1e+5);                    % differential

sim('Model_ZN_FOPID.mdl',sim_time);
close_system('Model_ZN_FOPID', 0);

timeFOPID2 = time;                                                  % 仿真结果, 传递全局变量
outFOPID2  = FOPID_out;

%% FO-PID 1
clear kpo kio kdo mu r2 lambda ifo dfo time FOPID_out

kpo = 0.0109;
kio = 6.1492;
kdo = 2.3956;
mu  = 0.5494;
lambda  = 0.6363;

ifo = ousta_fod(-lambda,10,1e-5,1e+5);               % integral
dfo = ousta_fod(mu,10,1e-5,1e+5);                    % differential

sim('Model_ZN_FOPID.mdl',sim_time);
close_system('Model_ZN_FOPID', 0);


timeFO_PID1 = time;                                                  % 仿真结果, 传递全局变量
outFO_PID1  = FOPID_out;

%% FO-PID 2
clear kpo kio kdo mu lambda ifo dfo time FOPID_out

kpo = 0.3835;
kio = 14.7942;
kdo = 3.6466;
mu  = 0.3835;
lambda  = 0.7480;


ifo = ousta_fod(-lambda,10,1e-5,1e+5);               % integral
dfo = ousta_fod(mu,10,1e-5,1e+5);                    % differential

sim('Model_ZN_FOPID.mdl',sim_time);
close_system('Model_ZN_FOPID', 0);

timeFO_PID2 = time;                                                  % 仿真结果, 传递全局变量
outFO_PID2  = FOPID_out;

%% PI^lambda D
clear kpo kio kdo mu lambda ifo dfo time FOPID_out

kp = 97.7464;
ki = 230.216;
kd = 6.82;
lambda  = 1.49;

T_s = 1/2000;
if (lambda >= 1)
    dfod = irid_fod(-lambda+1, T_s, 5);
else
    dfod = irid_fod(-lambda, T_s, 5);
end

sim('Model_PI_lambdaD.mdl',sim_time);
close_system('Model_PI_lambdaD', 0);

timePILamD = time;                                                  % 仿真结果, 传递全局变量
outPILamD  = PILamD_out;

%% plot
figure;
hold on;
xlabel('Time (s)',     'FontName','Times New Roman','FontSize',15);
ylabel('Step response','FontName','Times New Roman','FontSize',15);

plot(time,Input,'--k', 'LineWidth',2, 'DisplayName','Input');
plot(timeFO_PID1,outFO_PID1,'Color',[0.13 0.55 0.13], 'LineWidth',2, 'DisplayName','FO-PID1: \lambda = 0.6363, \mu = 0.5494');
plot(timeFO_PID2,outFO_PID2, 'Color',[1    0.65 0   ], 'LineWidth',2, 'DisplayName','FO-PID2: \lambda = 0.7480, \mu = 0.3835');
plot(timePILamD,outPILamD,'Color',[0.58 0    0.83], 'LineWidth',2,'DisplayName','PI^{\lambda}D: \lambda = 1.49');
plot(timeFOPID1,outFOPID1,'-r','LineWidth',2,'DisplayName','ZN-PI^{\lambda}D^{\mu}1: new ZN-point and r2 = 0.9, \mu = 0.78');
plot(timeFOPID2,outFOPID2,'-b','LineWidth',2,'DisplayName','ZN-PI^{\lambda}D^{\mu}2: new ZN-point and r2 = 0.8, \mu = 1.0');
hold off;
legend;

axes('Position',[0.18,0.17,0.32,0.38]);
hold on;
box on;
plot(time,Input,'--k', 'LineWidth',2, 'DisplayName','Input');
plot(timeFO_PID1,outFO_PID1,'Color',[0.13 0.55 0.13], 'LineWidth',2, 'DisplayName','FO-PID1: \lambda = 0.6363, \mu = 0.5494');
plot(timeFO_PID2,outFO_PID2, 'Color',[1    0.65 0   ], 'LineWidth',2, 'DisplayName','FO-PID2: \lambda = 0.7480, \mu = 0.3835');
plot(timePILamD,outPILamD,'Color',[0.58 0    0.83], 'LineWidth',2,'DisplayName','PI^{\lambda}D: \lambda = 1.49');
plot(timeFOPID1,outFOPID1,'-r','LineWidth',2,'DisplayName','ZN-PI^{\lambda}D^{\mu}1: new ZN-point and r2 = 0.9, \mu = 0.78');
plot(timeFOPID2,outFOPID2,'-b','LineWidth',2,'DisplayName','ZN-PI^{\lambda}D^{\mu}2: new ZN-point and r2 = 0.8, \mu = 1.0');
axis([0 11 0.6 1.5]);
hold off;

axes('Position',[0.56,0.17,0.32,0.38]);
hold on;
box on;
plot(time,Input,'--k', 'LineWidth',2, 'DisplayName','Input');
plot(timeFO_PID1,outFO_PID1,'Color',[0.13 0.55 0.13], 'LineWidth',2, 'DisplayName','FO-PID1: \lambda = 0.6363, \mu = 0.5494');
plot(timeFO_PID2,outFO_PID2, 'Color',[1    0.65 0   ], 'LineWidth',2, 'DisplayName','FO-PID2: \lambda = 0.7480, \mu = 0.3835');
plot(timePILamD,outPILamD,'Color',[0.58 0    0.83], 'LineWidth',2,'DisplayName','PI^{\lambda}D: \lambda = 1.49');
plot(timeFOPID1,outFOPID1,'-r','LineWidth',2,'DisplayName','ZN-PI^{\lambda}D^{\mu}1: new ZN-point and r2 = 0.9, \mu = 0.78');
plot(timeFOPID2,outFOPID2,'-b','LineWidth',2,'DisplayName','ZN-PI^{\lambda}D^{\mu}2: new ZN-point and r2 = 0.8, \mu = 1.0');
axis([39.5 49 0.6 1.3]);
hold off;
