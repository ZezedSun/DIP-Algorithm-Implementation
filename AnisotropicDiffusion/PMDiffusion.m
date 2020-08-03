function [Iend,Ipoll] = PMDiffusion(I0,dt,Tend,Tpoll,K)
% Perona Malik diffusion equation
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Inputs: 
%   I0: Initial image 
%   dt: time step
%   Tend: end time
%   Tpoll: times at which to poll
%   K: edge strength threshold
% 
% Output: Solution of the PM diffusion equation

  [m,n] = size(I0);
  Ipoll = zeros(m,n,numel(Tpoll));

  % NEED TO COMPLETE CODE  
  u = I0;
  ctr = 1;
  for t = 0:dt:Tend
      [du,~] = imgradient(u,'central');
      g = exp(-K.^(-2).*du.^2);
      g_iplush = (g+g(:,[1,1:n-1]))/2;
      g_iminush = (g+g(:,[2:n,n]))/2;
      g_jplush = (g+g([2:m,m],:))/2;
      g_jminush = (g+g([1,1:m-1],:))/2;      
      
      u = u + dt*(g_iplush.*(u(:,[1,1:n-1])-u) - g_iminush.*(u-u(:,[2:n,n])) +...
          g_jplush.*(u([2:m,m],:)-u) - g_jminush.*(u-u([1,1:m-1],:)));
      
%       u = u + dt*(g_iplush.*u(:,[1,1:n-1]) - g_iminush.*u(:,[2:n,n]) +...
%           g_jplush.*u([2:m,m],:) - g_jminush.*u(:,[1,1:m-1]) -...
%           (g_iplush + g_iminush + g_jplush + g_jminush).*u);



      if abs(t-Tpoll(ctr)) < 1e-8
      Ipoll(:,:,ctr) = u;
      ctr = ctr + 1;
      end
      
      
  end
  Iend = u;
  
end

