function [Gp,GpL,Ga,m,falgGa] = function_Compensator(Ns,Ms,n,L,Ta)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
s  = tf('s');
sys1 = tf(Ns, Ms, 'ioDelay', L);
sys2 = tf(Ns, Ms);
GpL  = sys1 / s^n;
Gp   = sys2 / s^n;

warning off;
order_start = 1;                            % 计算补偿器
order_detla = 1;
order_end   = 10;

[Gm_J,~,~,~] = margin(GpL);
con1 = ((Gm_J>0) && (Gm_J<Inf));
con2 = ((n > 1) || (n < 0));
if (con1 == false) || (con2 == true)
    for order = order_start:order_detla:order_end
        Ga = ((s/Ta+1)^n)/(Ta*s+1)^order;
        GpLa = GpL*Ga;
        [Gm_J,~,~,~] = margin(GpLa);
        con1 = ((Gm_J>0) && (Gm_J<Inf));
        if (order >= n) && (con1 == true)
            break;
        end
    end
    m = order;
    falgGa = true;
else
    Ga = 1;
    m  = 0;
    falgGa = false;
end

end

