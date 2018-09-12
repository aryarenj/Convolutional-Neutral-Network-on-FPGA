


fid2 = fopen('out_detection.txt');

matrix = zeros(41,31,1)
A = fscanf( fid2 , '%d');

for i=1:41,
    for j=1:31,
         matrix(i,j,1) = A( (i-1)*31 + j); 
         
    end
end

figure('Name','Verilog Image');

imshow(uint8(matrix));

fclose(fid2);











% fid = fopen('extracted_main.txt');
% 
% temp = zeros(148044,1);
% matrix = zeros(438,338,1)
% A = fscanf( fid , '%d');
% 
% for i=1:428,
%     for j=1:338,
%          matrix(i,j,1) = A( (i-1)*338 + j); 
%          
%     end
% end
% 
% 
% figure('Name','Verilog BW Image');
% 
% imshow(uint8(matrix));
% 
% fclose(fid);
% 
% 
% fid1 = fopen('extracted_pattern.txt');
% 
% temp = zeros(810,1);
% matrix = zeros(28,25,1)
% A = fscanf( fid1 , '%d');
% 
% for i=1:28,
%     for j=1:25,
%          matrix(i,j,1) = A( (i-1)*25 + j); 
%          
%     end
% end
% 
% 
% figure('Name','Verilog BW Image');
% 
% imshow(uint8(matrix));
% fclose(fid1);
% 


% fid2 = fopen('out_inter_conv.txt');
% 
% temp = zeros(129054,1);
% matrix = zeros(411,314,1)
% A = fscanf( fid2 , '%d');
% 
% for i=1:411,
%     for j=1:314,
%          matrix(i,j,1) = A( (i-1)*314 + j); 
%          
%     end
% end
% 
% figure('Name','Verilog BW Image');
% 
% imshow(uint8(matrix));
% 
% fclose(fid2);
% 
% 
% 
% fid2 = fopen('out_maxpool.txt');
% 
% temp = zeros(1271,1);
% matrix = zeros(41,31,1)
% A = fscanf( fid2 , '%d');
% 
% for i=1:41,
%     for j=1:31,
%          matrix(i,j,1) = A((i-1)*31 + j); 
%          
%     end
% end
% 
% 
% imshow(uint8(matrix));
%  
% fclose(fid2);
% 
% disp(max(max(matrix)));
% threshold = 0.75 * max(max(matrix));
% [m n] = size(matrix);
% for i = 1: m
%     for j= 1:n
%         if matrix(i,j)> threshold
%             out1(i,j) = 0;
%             count1 = count1 + 1;
%         else
%             out1(i,j) = 255;
%         end
%     end
% end
% figure;
% imshow(out1);
% toc




