clear, close all; clc;

fs = 1e6;
fn = 200e3;
fb = 50e3;
omega0T =fn/(fs/2)*pi;
deltaT = fb/(fs/2)*pi;
a2 = (1-tan(deltaT/2))./(1+tan(deltaT/2));
a1 = (1+a2).*cos(omega0T);
B = [1 -a1 a2];
A = [a2 -a1 1];
[H1 W1] = freqz(B,A,1024,'whole');
[H2 W2] = freqz(1,1,1024,'whole');
H3 = (H1+H2)/2;
h = figure(1);
subplot(2,1,1);
plot([-512:511]/1024*fs/1e6,20*log10(fftshift(abs(H3))),'b-','LineWidth',4);
grid on;
ylabel('amplitude£¬ dB');
title('notch filter£¬ fs=1MHz£¬ fn=200kHz£¬ fb=50kHz');
axis([-0.5 0.5 -50 10]);
subplot(2,1,2);
plot([-512:511]/1024*fs/1e6,(fftshift(angle(H3)*180/pi)),'m-','LineWidth',4);
grid on; 
xlabel('freq£¬ MHz');
ylabel('angle£¬ deg');
title('phase response');
axis([-0.5 0.5 -180 180]);
% x = -10:0.01:10;
% W = 1;
% y = 1/(2*W+1)^2*1.*(x>-W&x<W)-1/(4*W+1)^2*1.*(x>-2*W&x<2*W);
% 
% y1 = fft(y);
% y2 = fft(W);
% plot(real(y1),imag(y1),'b*');
% hold on
% plot(real(y2),imag(y2),'go');


% W = 20;
% X = zeros(200,200);
% GM = X;
% for i = 100-W:100+W
%     for j = 100-W:100+W
%         GM(i,j) = 1;
%     end
% end
% G2M = X;
% for i = 100-2*W:100+2*W
%     for j = 100-2*W:100+2*W
%         G2M(i,j) = 1;
%     end
% end
% H1 = 1/(2*W+1)^2*GM-1/(4*W+1)^2*G2M;
% H2 = GM-G2M;
% figure
% imagesc(GM);
% figure
% imagesc(G2M);
% figure
% imagesc(H1);
% F1 = fft2(H1);
% figure
% imshow(abs(fftshift(F1)));
% figure
% surf(GM(1),GM(2));



% X = zeros(200,200);
% X1 = X;
% X1(:,101:end)=1; 
% X2 = X;
% for i = 1:200
%     for j =1:200
%     if mod(j,2) == 0
%         X2(:,j) =1;
%     end
%     end
% end
% X3 =X;
% for i = 1:200
%     for j =1:200
%         if mod(j,8) == 2
%             X3(:,j:j+3) =1;
%         end
%     end
% end
% XX1 = fft2(X1); XX1 = fftshift(XX1); 
% XX2 = fft2(X2); XX2 = fftshift(XX2); 
% XX3 = fft2(X3); XX3 = fftshift(XX3);
% 
% figure;
% subplot(2,3,1); imagesc(X1);
% subplot(2,3,2); imagesc(X2);
% subplot(2,3,3); imagesc(X3);
% subplot(2,3,4); imshow(abs(XX1));
% subplot(2,3,5); imshow(abs(XX2));
% subplot(2,3,6); imshow(abs(XX3));
