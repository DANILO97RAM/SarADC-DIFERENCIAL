clear all
clc
%ESTA FUNCION MODELA UN SAR-ADC, esquema de switching basado en Vcm
format long
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%Valores de entrada%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=10; u_Cu=35.6e-15; S_Cu=0.157e-15; sample=200; Vrefp=1.8; Vrefn=0; 
Vin=-0.5;
% Generacion de Capacitancias con 200 muestras y agrupacion de 2n
[Bank_P,Bank_N] = bank_cap(u_Cu,S_Cu,N,sample);

Vfs = Vrefp-Vrefn;
Vcm =Vfs/2;
Vinp=  Vin/2 + Vcm; 
Vinn= -Vin/2 + Vcm; 

w_bits = zeros(sample,N+1);

Ct_n = sum(Bank_N');
Ct_p = sum(Bank_P');

for j=1:sample
    Cvref_p=0; Cvcm_p =0; Cgnd_p =0; 
    Cvref_n=0; Cvcm_n =0; Cgnd_n =0;
    if Vinp>=Vinn
        w_bits(j,1)=1;
        %bit de signo
        Vo1 = Vinp;
        Vo2 = Vinn;
        %si es positivo Vo1 es Vinp y Vo2 Vinn
    else
        %sino, debemos invertir las entradas
        Vo1=Vinn;
        Vo2=Vinp;  
    end
    for i=1:N+1 %POR QUE HAY UN BIT DE SIGNO 
        if Vo1>=Vo2
          %Banco de capacitores P
          Cvref_p=Cvref_p+Bank_P(j,i);
          %Banco de Capacitores N
          Cvref_n=Cvref_n+Bank_N(j,i);
          w_bits(j,i)=1;
        elseif Vo1<Vo2
          %Banco de capacitores P
          Cgnd_p=Cgnd_p+Bank_P(j,i);
          %Banco de Capacitores N
          Cgnd_n=Cgnd_n+Bank_N(j,i);
          w_bits(j,i)=0;
        end
        Cvcm_p = Ct_p(1,j) - Cvref_p - Cgnd_p;  %+ Cvref_n
        Cvcm_n = Ct_n(1,j) - Cvref_n - Cgnd_n; %+ Cvref_p
        %Luego hay que cambiar los vinn y vinp por los valores de salida
        Vo1 = (Vinp-Vcm) + Vrefp*(Cvref_p/Ct_p(1,j)) + Vcm*(Cvcm_p/Ct_p(1,j));
        Vo2 = (Vinn-Vcm) + Vrefn*(Cvref_n/Ct_n(1,j)) + Vcm*(Cvcm_n/Ct_n(1,j));
        w_bits(j,:);
    end
end