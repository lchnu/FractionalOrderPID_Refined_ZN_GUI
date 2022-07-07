function [alpha,beta,gamma] = function_FOPID_para(selectPoint,r1,r2,mu,Kc,Tc)
%function_FOPID 论文中所提方法计算的 FOPID 控制器
%   输入： selectPoint：fixed-point
%         r1, r2, mu：两个壁纸参数和微分参数
%         Kc,Tc：振荡条件，临界增益和临界周期
%   输出：控制器表达式 C(s) = Kp(1 + 1/(Ti*s^lambda) + Td*s^mu)

if selectPoint
    rp = 0.5;
    p = 0.5*Kc;
    q = 0.5*Kc*(-1/(2*pi*0.5)+0.125*2*pi);
else
    rp = 0.6;
    p = 0.6*Kc;
    q = 0.6*Kc*(-1/(2*pi*0.5)+0.125*2*pi);
end
lambda = mu * r2;
Wc = 2*pi / Tc;

B  = r1^(lambda);
E  = q / p;
C1 = cos(lambda*pi/2);             S1 = sin(lambda*pi/2);
C2 = cos(mu*pi/2);                 S2 = sin(mu*pi/2);
a  = B*E*C2 - B*S2;
b  = B*E;
c  = E*C1 + S1;

syms x;
equ = a*x^(1+r2) + b*x^r2 + c;                              % 解方程
x = double(vpasolve(equ, x));                               
num_solu = 0;
for num = 1:1:length(x)
    if (imag(x(num)) == 0) && (real(x(num))>0)
        num_solu = num_solu + 1;
        solu(num_solu) = x(num);
    end
end
if num_solu > 1
    error('num_solu > 1');
elseif num_solu == 0
    error('num_solu = 0');
end
X = solu(1);

alpha = (rp*B*X^r2)/(B*C2*X^(1+r2)+B*X^r2+C1);
beta  = (r1/(2*pi))^(r2*mu)*X^r2;
gamma = X/((2*pi)^mu);

end

