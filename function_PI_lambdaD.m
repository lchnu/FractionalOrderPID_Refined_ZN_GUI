function [Kp,Ki,Kd,FO] = function_PI_lambdaD(Km,Tm,delay,Wc,PM)
%function_PI_lambdaD: Optimal robust fractional order PIλD controller synthesis for first order plus time delay systems
%   input: tf: transfer function of a first-order inertial system
%          delay: delay
%          Wc: gain crossover frequency
%          PM: phase margin
%  output: C(s) = kp + ki/s^lambda + kd*s
%          Kp,Ki,Kd: kp, ki, kd
%          FO: lambda
%% 获取被控对象数据

opts = simset('SrcWorkspace', 'current');

K = Km;
T = Tm;
s  = tf('s');
L = delay;
omega_c = Wc;
Phi = PM * pi/180;
Gp = K / (T*s + 1);

A = 1;
w_start = eps;
w_delta = 1e-2; 
w_end   = 50; 
W       = w_start:w_delta:w_end;    %设置w循环上限，避免死循环 


kd_start = -abs(T/K);
% kd_start = 6.5;
kd_delta = 1e-2;
% kd_end   = 7;
kd_end   = abs(T/K);
kd_array = kd_start:kd_delta:kd_end ;	 %Kd的范围 

for j = 1:1:length(kd_array) 
    kd = kd_array(j) ;
    v = 1; 
    for lambda = 0.2:0.01:1.9         
        clear kp ki 
        for k = 1:1:length(W) 
            w = W(k); 
            C1 = cos(Phi+w*L); 
            S1 = sin(Phi+w*L); 
            C2 = cos(lambda * pi / 2); 
            S2 = sin(lambda * pi / 2); 
            C3 = cos((lambda+1) * pi / 2); 
            S3 = sin((lambda+1) * pi / 2); 
            B1 = (w^lambda)*C2        -  T*(w^(1+lambda))*S2; 
            B2 = T*(w^(lambda+1))*C2  + (w^lambda)*S2; 
            kp(k) = -(B1*S1+B2*C1)/(A*K*(w^lambda)*S2) - kd*w*S3/S2; 
            ki(k) = (B2-B1*C1*S1-B2*C1*C1)/(A*K*S1)+(B1*S1*C2+B2*C1*C2)/(A*K*S2)+kd*(w^(lambda+1))*S3*C2/S2-kd*(w^(lambda+1))*C3; 
            if ki(k) < 0 
                w_max(j) = W(k-1);    %条件判断成立时，ki已经小于零，系统不稳定，所以最大频率应是条件成立的前一个 
                kp(k) = []; 
                ki (k) = []; 
                break; 
            end 
        end 
        w = omega_c; %%wc 
        [~, k] = min(abs(W-w)); 
        if w < w_max(j) 
            rsc_kp(j,v) = kp(k); 
            rsc_ki(j,v) = ki(k); 
            rsc_lambda(j,v) = lambda; 
            v = v+1; 
        end 
    end 
%      disp(['Now we handle loop ' num2str(j),', kd = ',num2str(kd,'%1.2f'), ' flat phase point, size of rsc_kp is ', num2str(size(rsc_kp,1)), ' x ', num2str(size(rsc_kp,2))]);
    if w < w_max(j) 
        for k = 1:1:size(rsc_kp,2) 
            lambda = rsc_lambda(j,k); 
            C1 = cos(Phi+w*L);  %注：以前平坦相位约束时没有重新根据$$\lambda$$计算C1等参数，导致计算得到的结果对增益变化还是比较敏感。可能李创的博士论文中的代码也有同样的问题。@卢传范 @唐鸣政             
            S1 = sin(Phi+w*L); 
            C2 = cos(lambda * pi / 2); 
            S2 = sin(lambda * pi / 2); 
            C3 = cos((lambda+1) * pi / 2); 
            S3 = sin((lambda+1) * pi / 2);             
            B1 = (w^lambda)*C2        -  T*(w^(1+lambda))*S2; 
            B2 = T*(w^(lambda+1))*C2  + (w^lambda)*S2; 
            E = rsc_kp(j,k)*(w^lambda)*C2 + rsc_ki(j,k) + kd*(w^(1+lambda))*C3; 
            F = rsc_kp(j,k)*(w^lambda)*S2 + kd*(w^(1+lambda))*S3; 
            Ed = lambda*rsc_kp(j,k)*(w^(lambda-1))*C2 + (lambda+1)*kd*(w^lambda)*C3; 
            Fd = lambda*rsc_kp(j,k)*(w^(lambda-1))*S2 + (lambda+1)*kd*(w^lambda)*S3; 
            B1d =  lambda*(w^(lambda-1)) * C2 - (1+lambda)*T * (w^lambda)*S2; 
            B2d = (lambda+1)*T*(w^lambda)*C2 + lambda*(w^(lambda-1))*S2; 
            dif_Phi_wc(k) = ( (B1^2+B2^2)*(E*Fd-Ed*F) + (B1d*B2-B1*B2d)*(E^2+F^2)  ) / ( (B1*E+B2*F)^2 + (B1*F-B2*E)^2 ) - L; 
            %dif_Phi_wc(k) = ((B1d*F+B1*Fd-B2d*E-B2*E)*(B1*E+B2*F) - (B1*F-B2*E)*(B1d*E+B1*Ed+B2d*F+B2*Fd))/ ( (B1*E+B2*F)^2 + (B1*F-B2*E)^2 ) - L; 
        end 
        [min_dif_Phi_wc,index] = min(abs(dif_Phi_wc));      %kd每取一个值，得到一个满足平坦相位约束的点 
        if index > 1
            index = index - 1;   %减1才能得到和陈老师论文一样的结果。我的结果偏移了1。
        end
        fpp_kp(j) = rsc_kp(j,index) ;
        fpp_ki(j) = rsc_ki(j,index) ;
        fpp_kd(j) = kd_array(j);
        fpp_diff_phi(j) = min_dif_Phi_wc ;
        fpp_ro(j) = rsc_lambda(j,index);
        
        disp(['kp = ', num2str(roundn(fpp_kp(j), -4)), ', ki = ', num2str(roundn(fpp_ki(j), -4)),...
            ', kd = ', num2str(roundn(fpp_kd(j), -4)), ', lambda = ', num2str(roundn(fpp_ro(j), -4)),...
            ', dphi/dw = ', num2str(roundn(fpp_diff_phi(j), -4))]);
    end 
end 


%% 寻找最优的ITAE
open_system('Model_PI_lambdaD_FOPDT','loadonly');
Gp.iodelay = 0;
gain = 1;
sim_time = 50;
disturb_step_time = sim_time*2;
disturb_step_value = 0.5;
T_s = 1/2000;
for j = 1 : 1 : length(fpp_kp)
    warning off
    kpo = fpp_kp(j);
    kio = fpp_ki(j);
    ro = fpp_ro(j);
    kdo = fpp_kd(j);
    if (ro >= 1)
        dfod = irid_fod(-ro+1, T_s, 5);
    else
        dfod = irid_fod(-ro, T_s, 5);
    end
    sim('Model_PI_lambdaD_FOPDT.mdl',sim_time, opts);
    
    J_ITAE(j) = ITAE(end);
    disp(['wmax = ', num2str(roundn(w_max(j), -4)),', wc = ',num2str(roundn(omega_c, -4)),...
        ', kp = ',num2str(roundn(kpo, -4)),', ki=',num2str(roundn(kio, -4)),', kd = ',num2str(kdo),...
        ', ro = ',num2str(roundn(ro, -4)),', ITAE = ', num2str(roundn(ITAE(end), -4))]);
end
close_system('Model_PI_lambdaD_FOPDT',0);

[~, j] = min(J_ITAE);
Kp = fpp_kp(j);
Ki = fpp_ki(j);
FO = fpp_ro(j);
Kd = fpp_kd(j);

end
 


