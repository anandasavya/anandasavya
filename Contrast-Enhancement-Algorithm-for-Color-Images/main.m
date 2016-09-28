%%%%%%%% Name of the developer: Savya Ananda %%%%%%%%%%
%%%%%%%% Last Date Of Modification: 4/27/2016 %%%%%%%%%
%%%%%%%% Input: Low contrast low resolution dark image %%%%%%%%%
close all;
clc
[f,p]=uigetfile('.jpg');%%%% Input image of the type jpg%%%%
I=strcat(p,f);
X=imread(I);%%%% Reading the input image %%%%
HSV=rgb2hsv(X);%%%%%%%%%%%%%conversion from RGB to HSV Colour Space%%%%%%%%%%%%%%
H=HSV(:,:,1);%calculate new h component%
S=HSV(:,:,2);% calculate new s component%
V=HSV(:,:,3);% calculate new v component%
figure,subplot(2,2,1),imshow(H),title(' HUE image');% plot the HUE image%
subplot(2,2,2), imshow(S),title(' saturation image');% plot the saturation image%
subplot(2,2,3), imshow(V),title(' Value image');% plot the Value image%
subplot(2,2,4), imshow(X),title(' original RGB  image');% plot the original RGB image%
%%%%%%%%%%%%%%%%%%%%%%applying CLAHE for Enhancing Luminance%%%%%%%%%%%%%%%%%%%%
Clahe_V=adapthisteq(V,'ClipLimit',0.03,'Distribution','rayleigh');
% figure,imshow(Clahe_V);
%%%%%%%%%%%%%%%%%%%%%%
ai=S;
[ai,aih,aiv,aid]=dwt2(double(ai),'haar');
s2=size(ai);           
figure,subplot(2,2,1); imshow(ai,[]);
subplot(2,2,2); imshow(aih,[]);
subplot(2,2,3); imshow(aiv,[]);
subplot(2,2,4); imshow(aid,[]);
%Mapping operator
 r=1;                                                       
 j=1;
 aim=ai;
 aivm=aiv;
 aidm=aid;
 aihm=aih;
 for n=1:s2(2)
 for m=1:s2(1)                    
 aim(m,n)=((sinh(4.6248*((ai(m,n)/(255*(2^j))))-2.3124)+5)/10).^r;%%%%% Scaling up the approximate coefficient%%%%
 aivm(m,n)=((sinh(4.6248*((aiv(m,n)/(255*(2^j))))-2.3124)+5)/10).^r;%%%%% Scaling up the approximate coefficient%%%%
 aihm(m,n)=((sinh(4.6248*((aih(m,n)/(255*(2^j))))-2.3124)+5)/10).^r;%%%%% Scaling up the approximate coefficient%%%%
 aidm(m,n)=((sinh(4.6248*((aid(m,n)/(255*(2^j))))-2.3124)+5)/10).^r;%%%%% Scaling up the approximate coefficient%%%%
  end
  end
 aimd = histeq(aim);
 ai=ai+0.000001;%%%%%%%%%%to avoid divided by zero%%%%%%%%%%
 aivmd=imadjust(aivm);
        avn=(aimd./ai).*aivm;
 aidmd=imadjust(aidm);
        adn=(aimd./ai).*aidm;
 aihmd=imadjust(aihm);
        ahn=(aimd./ai).*aihm;
a=double(S);
aId=idwt2(aimd,avn,ahn,adn,'haar'); %%%%%%% Applying Discrete Wavelet Transform%%%%%%%%%%%               
I=double(S);
B=3;
s1=size(S);
for n=1:s1(2)
for m=1:s1(1)
Ai=((a(m,n,:))./max(a(m,n,:))).^B;
I(m,n,:)=Ai.*aId(m,n).*2.5;                          
end
end
figure,imshow(uint8(I));
hsv=cat(3,H,I,Clahe_V);
figure,imshow(hsv);
final=hsv2rgb(hsv);%%%%%%%%%%%%%% Conversion from HSV to RGB Volour Space%%%%%%%%%%%%%%%%%%%%%
figure,imshow(final);
%%%%%%%%%%%%%%%%%%%%%%%%%HE method%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1=histeq(X(:,:,1));
f2=histeq(X(:,:,2));
f3=histeq(X(:,:,3));
he_image=cat(3,f1,f2,f3);
%%%%%%%%%%%%%%%%%%%%%CLAHE method&&&&&&&&
C1=adapthisteq(X(:,:,1),'ClipLimit',0.03,'Distribution','rayleigh');
C2=adapthisteq(X(:,:,2),'ClipLimit',0.03,'Distribution','rayleigh');
C3=adapthisteq(X(:,:,3),'ClipLimit',0.03,'Distribution','rayleigh');
clahe_me=cat(3,C1,C2,C3);
%%%%%%%%%%%%%%%outputs%%%%%%%%%%%%%%%%%%%%%%
figure,subplot(221),imshow(X),title('original image');%%%%% plots the original image%%%%%
subplot(223),imshow(he_image),title('he image');%%%%% plots the HE image%%%%%
subplot(222),imshow(final),title('output of proposed method');%%%%% plots the output of the proposed method%%%%%
subplot(224),imshow(clahe_me),title('clahe image');%%%%% plots the CLAHE image%%%%%
%%%%%%%%%%%%%%%%end%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


