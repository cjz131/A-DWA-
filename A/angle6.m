function k=angle6(a1,a2,b1,b2,c1,c2)
% a1=1;a2=1;b1=1;b2=2;c1=2;c2=3;
n=[b1-a1, b2-a2 ];
m=[c1-b1, c2-b2];
%c=acosd( dot(a,b)./assista(a)./assista(b));
 c=dot(n,m)/norm(n,2)/norm(m,2);
 du=rad2deg(acos(c));
%  hudu=du*pi/180;

 k=du;