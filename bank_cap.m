function [Bank_P,Bank_N]=bank_cap(u_Cu,S_Cu,N,sample)
%    col=2^N;
%    Bank_P=normrnd(u_Cu,S_Cu,sample,col);
%    Bank_N=normrnd(u_Cu,S_Cu,sample,col);
%    Gr_P=zeros(sample,N+1);
%    Gr_N=zeros(sample,N+1);
%     for f=1:sample
%     Gr_P (f,1)=M_cap_P(f,1);
%     Gr_N (f,1)=M_cap_N(f,1);
%     for c=2:N+1
%         Gr_P(f,c)=sum(M_cap_P((2^(c-2))+1 : 2^(c-1)));
%         Gr_N(f,c)=sum(M_cap_N((2^(c-2))+1 : 2^(c-1)));
%         c=c+1;
%     end
%     f=f+1;
%     end
% Cambiamos a esta forma de almacenamiento por la versatilidad para
% trabajar con las agrupaciones de 2^N capacitores
format long
Bank_N = zeros (sample,N+1);
Bank_P = zeros (sample,N+1);
for i=1:sample
    for j=N:-1:1
        Bank_P(i,N+1-j)=sum(normrnd(u_Cu,S_Cu,1,2^(j-1)));
        Bank_N(i,N+1-j)=sum(normrnd(u_Cu,S_Cu,1,2^(j-1)));
        
        %ESTA SECCION SE HIZO PARA COMPROBAR EL FUNCIOANMIENTO DE
        %PROGRAMA... AGRUPAR DESDE 2^N-1 HASTA 2^0
        %Bank_P(i,N+1-j)=sum(2^(j-1));
        %Bank_N(i,N+1-j)=sum(2^(j-1));
    end
    %se agrega la capacitancia unitaria al final del arreglo
    Bank_P(i,end)=normrnd(u_Cu,S_Cu); 
    Bank_N(i,end)=normrnd(u_Cu,S_Cu);    
end
