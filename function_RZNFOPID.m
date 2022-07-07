function [RZN_Kp,RZN_Ti,RZN_Td] = function_RZNFOPID(RZN_lambda,Kc,Tc)
%function_RZNFOPID: Calculate the PI^lambda D^lambda (Revisiting Ziegler¨CNichols.
%A fractional order approach) controller parameters.
%   RZNFOPID Controller: C(s) = RZN_Kp(1 + 1/(RZN_Ti*s^lambda) + RZN_Td*s^lambda)
%   RZN_lambda   lambda
%   Kc           critical gain
%   Tc           critical period
R = 4^RZN_lambda;
Wc = 2*pi / Tc; 
C = cos(RZN_lambda*pi/2);       S = sin(RZN_lambda*pi/2);

RZN_X1 = (-(0.467*R)+sqrt((-0.467*R)^2-4*(0.467*C-S)*(0.467*C*R+S*R))) / (2*(0.467*C-S));
RZN_X2 = (-(0.467*R)-sqrt((-0.467*R)^2-4*(0.467*C-S)*(0.467*C*R+S*R))) / (2*(0.467*C-S));
if (RZN_X1>0) && (RZN_X2<0)
    RZN_X = RZN_X1;
elseif (RZN_X1<0) && (RZN_X2>0)
    RZN_X = RZN_X2;
elseif (RZN_X1<0) && (RZN_X2<0)
    RZN_X = RZN_X1;
    error(['RZN_X < 0 !  RZN_X1 = ', num2str(RZN_X1),',  RZN_X2 = ', num2str(RZN_X2), ', RZN_X = ',num2str(RZN_X)]);
elseif (RZN_X1>0) && (RZN_X2>0)
    RZN_X = RZN_X1;
    error(['RZN_X > 0 !  RZN_X1 = ', num2str(RZN_X1),',  RZN_X2 = ', num2str(RZN_X2), ', RZN_X = ',num2str(RZN_X)]);
else
    error(['RZN_X1 = ', num2str(RZN_X1),',  RZN_2 = ', num2str(RZN_X2)]);
end

RZN_Kp = (0.6*Kc) / (1+C*(RZN_X/R+1/RZN_X));
RZN_Ti = RZN_X/(Wc^RZN_lambda);
RZN_Td = RZN_Ti/R;
end

