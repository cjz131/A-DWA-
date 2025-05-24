function a=myangle(a1,a2,b1,b2)
n=[a1,a2];
m=[b1,b2];
%c=acosd( dot(a,b). /assista(a)./assista(b));
 c=dot(n,m)/norm(n,2)/norm(m,2);
 a=rad2deg(acos(c));