
function RRfin=FindTransformMatrix(Xp_abs, Yp_abs, Xt, Yt, ocam_model, RRfin)

ss = ocam_model.ss;
xc = ocam_model.xc;
yc = ocam_model.yc;
ima_proc = 1;
% ima_proc = ocam_model.ima_proc;
% RRfin = ocam_model.RRfin;

Xp=Xp_abs-xc;
Yp=Yp_abs-yc;
M1=[];
M2=[];
M3=[];
Rt=[];
MM=[];
RRdef=[];
for i=ima_proc
    
    Xpt=Xp(:,:,i);
    Ypt=Yp(:,:,i);
    rhot=sqrt(Xpt.^2 + Ypt.^2);
    M1=[ zeros(size(Xt)) , zeros(size(Xt)) , -FUNrho(ss,rhot).*Xt , -FUNrho(ss,rhot).*Yt , ...
         Ypt.*Xt , Ypt.*Yt , zeros(size(Xt)) , -FUNrho(ss,rhot) , Ypt];

    M2=[ FUNrho(ss,rhot).*Xt , FUNrho(ss,rhot).*Yt , zeros(size(Xt)) , zeros(size(Xt)) , ...
         -Xpt.*Xt , -Xpt.*Yt , FUNrho(ss,rhot) , zeros(size(Xt)) , -Xpt];
 
    M3=[ -Ypt.*Xt , -Ypt.*Yt , Xpt.*Xt , Xpt.*Yt , ...
         zeros(size(Xt)) , zeros(size(Xt)) , -Ypt , Xpt , zeros(size(Xt))];
 
    MM=[M1;M2;M3];
    [U,S,V] = svd(MM);
    res=V(:,end);
    Rt=reshape(res(1:6),2,3)'; %find the first 2 rotation vectors: r1 , r2
    scalefact=sqrt(abs(norm(Rt(:,1))*norm(Rt(:,2))));
%    keyboard;
    Rt=[Rt , cross(Rt(:,1),Rt(:,2))]; %find r3 as r3=r1xr2
    [U2,S2,V2] = svd(Rt); %SVD to find the best rotation matrix in the Frobenius sense
    Rt=U2*V2';
    Rt(:,3)=res(7:end)/scalefact;
    Rt=Rt* sign(Rt(1,3)*RRfin(1,3,i));
    RRdef(:,:,i)=Rt;

%pause

end
RRtmp=RRfin;
RRfin=RRdef;