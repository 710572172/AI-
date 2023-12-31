%   基于Retinex理论的对比度保持灰度化黑白试卷打印方法_邢潇雨
%   2023.10.05
%   指导老师 王娟


function  img  = RtGrayA(im)
im = im2double(im);
%%  Proprocessing 
[n,m,ch] = size(im); 
sigma = 0.05;
W = wei();
 
 
%%  Global and Local Contrast Computing
ims = imresize(im, round(64/sqrt(n*m)*[n,m]),'nearest');
R = ims(:,:,1);G = ims(:,:,2);B = ims(:,:,3);
imV = [R(:),G(:),B(:)];
defaultStream = RandStream.getGlobalStream; savedState = defaultStream.State;
t1 = randperm(size(imV,1));
Pg = [imV - imV(t1,:)];

ims = imresize(ims, 0.5 ,'nearest');
Rx = ims(:,1:end-1,1) - ims(:,2:end,1);
Gx = ims(:,1:end-1,2) - ims(:,2:end,2);
Bx = ims(:,1:end-1,3) - ims(:,2:end,3);

Ry = ims(1:end-1,:,1) - ims(2:end,:,1);
Gy = ims(1:end-1,:,2) - ims(2:end,:,2);
By = ims(1:end-1,:,3) - ims(2:end,:,3);
Pl = [[Rx(:),Gx(:),Bx(:)];[Ry(:),Gy(:),By(:)]];

P = [Pg;Pl ]; 
 
det = sqrt(sum(P.^2,2))/1.41  ;
 
P( (det < 0.05),:) = []; det( (det < 0.05)) = [];
detM =  repmat(det,[1,size(W,1)]); L = P*W'; 
 
%% Energy optimization
 
U = log(exp(- (L + detM ).^2/sigma.^2) + exp(- (L- detM).^2/sigma.^2));
Es = mean(U); 
 
%  R1=R(find(R>0));
%  G1=G(find(G>0));
%  B1=B(find(B>0));
  R1=R;
 G1=G;
 B1=B;
 
 Rsum=sum(R1(:));
 Gsum=sum(G1(:));
 Bsum=sum(B1(:));
 
 
 wR=Rsum/(Rsum+Gsum+Bsum);
 wG=Gsum/(Rsum+Gsum+Bsum);
 wB=Bsum/(Rsum+Gsum+Bsum);
 
   
 
 
%% Output
[NULLval,bw] = max(Es); 

WR=W(:,1).*wR;
WG=W(:,2).*wG;
WB=W(:,3).*wB;


 WWR=WR./(WR+WG+WB);
 WWG=WG./(WR+WG+WB);
 WWB=WB./(WR+WG+WB);
 WW(:,1)=WWR;
 WW(:,2)=WWG;
 WW(:,3)=WWB;
% WW=cat(3,WWR,WWG,WWB);
 
img = imlincomb(WW(bw,1),im(:,:,1),WW(bw,2),im(:,:,2),WW(bw,3),im(:,:,3));
img = uint8(img*255);
end

function W = wei()
W = [    0         0    1.0000
         0    0.1000    0.9000
         0    0.2000    0.8000
         0    0.3000    0.7000
         0    0.4000    0.6000
         0    0.5000    0.5000
         0    0.6000    0.4000
         0    0.7000    0.3000
         0    0.8000    0.2000
         0    0.9000    0.1000
         0    1.0000         0
    0.1000         0    0.9000
    0.1000    0.1000    0.8000
    0.1000    0.2000    0.7000
    0.1000    0.3000    0.6000
    0.1000    0.4000    0.5000
    0.1000    0.5000    0.4000
    0.1000    0.6000    0.3000
    0.1000    0.7000    0.2000
    0.1000    0.8000    0.1000
    0.1000    0.9000         0
    0.2000         0    0.8000
    0.2000    0.1000    0.7000
    0.2000    0.2000    0.6000
    0.2000    0.3000    0.5000
    0.2000    0.4000    0.4000
    0.2000    0.5000    0.3000
    0.2000    0.6000    0.2000
    0.2000    0.7000    0.1000
    0.2000    0.8000         0
    0.3000         0    0.7000
    0.3000    0.1000    0.6000
    0.3000    0.2000    0.5000
    0.3000    0.3000    0.4000
    0.3000    0.4000    0.3000
    0.3000    0.5000    0.2000
    0.3000    0.6000    0.1000
    0.3000    0.7000    0.0000
    0.4000         0    0.6000
    0.4000    0.1000    0.5000
    0.4000    0.2000    0.4000
    0.4000    0.3000    0.3000
    0.4000    0.4000    0.2000
    0.4000    0.5000    0.1000
    0.4000    0.6000    0.0000
    0.5000         0    0.5000
    0.5000    0.1000    0.4000
    0.5000    0.2000    0.3000
    0.5000    0.3000    0.2000
    0.5000    0.4000    0.1000
    0.5000    0.5000         0
    0.6000         0    0.4000
    0.6000    0.1000    0.3000
    0.6000    0.2000    0.2000
    0.6000    0.3000    0.1000
    0.6000    0.4000    0.0000
    0.7000         0    0.3000
    0.7000    0.1000    0.2000
    0.7000    0.2000    0.1000
    0.7000    0.3000    0.0000
    0.8000         0    0.2000
    0.8000    0.1000    0.1000
    0.8000    0.2000    0.0000
    0.9000         0    0.1000
    0.9000    0.1000    0.0000
    1.0000         0         0];
end 