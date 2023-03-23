
function [z_r,z_w,z_u,z_v]=roms_compZrZw(theta_s,theta_b,Tcline,N,h,zeta)
%
% Retrun depth of vertical grid at rho and w points in meters.
% (-1 , -5 , -10 ecc...)
%
% For CalCOFI application use as follows:
% [z_r,z_w]=roms_compZrZw(5.0,0.4,200,20,h,zeta)

 format long e

% CalCOFI application parameters are listed here for your info
%  N=20;
% theta_s=5.0;
% theta_b=0.4;
% Tcline=200;

 hc=min(min(h));
 cff1=1./sinh(theta_s);
 cff2=0.5/tanh(0.5*theta_s);
 sc_w0=-1.0;
 Cs_w0=-1.0;
 ds=1/N;

 for k=1:N

    % S-coordinate stretching curves at RHO-points (C_r) and  at W-points (C_w)
    % S-coordinate at RHO-points (sc_r) and at W-points (sc_w)
      sc_w(k)=ds*(k-N);
      Cs_w(k)=(1.-theta_b)*cff1*sinh(theta_s*sc_w(k)) +theta_b*(cff2*tanh(theta_s*(sc_w(k)+0.5))-0.5);

      sc_r(k)=ds*((k-N)-0.5);
      Cs_r(k)=(1.-theta_b)*cff1*sinh(theta_s*sc_r(k))  +theta_b*(cff2*tanh(theta_s*(sc_r(k)+0.5))-0.5);
  end

  z_w=-h;
  hinv=1./h;
  for k=1:N
    cff_w=hc*(sc_w(k)-Cs_w(k));
    cff1_w=Cs_w(k);
    cff2_w=sc_w(k)+1.;

    cff_r=hc*(sc_r(k)-Cs_r(k));
    cff1_r=Cs_r(k);
    cff2_r=sc_r(k)+1.;

  % Depth of sigma coordinate at W-points
    z_w0=cff_w+cff1_w*h;
    z_w(:,:,k)=z_w0+zeta.*(1.+z_w0.*hinv);

  % Depth of sigma coordinate at RHO-points
    z_r0=cff_r+cff1_r*h;
    z_r(k,:,:)=z_r0+zeta.*(1.+z_r0.*hinv);
  end
  z_w=permute(z_w,[3,1,2]);

% compute z_u, z_v
 [K,J,I]=size(z_r);
 
 z_v1 =(z_r(:,1:J-1,:)+ z_r(:,2:J,:))/2;
 z_u1 =(z_r(:,:,1:I-1)+ z_r(:,:,2:I))/2;
 z_v=permute(z_u1,[1 3 2]);
 z_u=permute(z_v1,[1 3 2]);

