function Demo_Test(x);


x = 1;

Par1 = 1; 
Par2 = 2; 

 [Ret1,Ret2]=Fun_Test(Par1,Par2); 
 A = @(x1,x2) Fun_Test(x1,x2);
 
 A(3,4)
 
 
 %%%%%%
 x = -10:0.1:10; %The position to plot  
 
 y= x.^(2);
 figure(1);          %Which figure to plot 
 plot(x,y);           %Plot a figure 
 
 figure(2);          %Which figure to plot 
 bar(x,y);             
 %%%%%%
 
 for i =1:3          %The vector 
     a(i) = i; 
 end
 
  for i =1:3         % The matrix 
      for j = 1:3
          a(i,j) = i; 
      end
 end
 %%%%%%%%% 
 M = [1 0 0; 0 2 0; 0 0 4];
 
 InvM = M^(-1);         % Martix Inverse
 
DetM = det(M);                       %Matrix determinant 
 %%%%%%%%%
 
   
 
 
 
 
 
 
EndTest = 0 ; 











