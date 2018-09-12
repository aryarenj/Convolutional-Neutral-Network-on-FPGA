
clear all;
close all;
clc;

resizeFactor= 0.2;  
%Preparing Input image block
main_img = imread('doc3.jpg');
main_img_compressed= imresize ( main_img ,resizeFactor);

pattern = imread('a.jpg') ;
pattern_compressed = imresize (pattern , resizeFactor);

matrix_main_img_compressed = pic_to_matrix(main_img_compressed);
matrix_pattern_compressed = pic_to_matrix(pattern_compressed);

fil_r = fopen('main_img_red_matrix.txt' , 'w');
fil_g = fopen('main_img_green_matrix.txt' , 'w');
fil_b = fopen('main_img_blue_matrix.txt' , 'w');
pic_matrix = matrix_main_img_compressed;
[row col ] = size(pic_matrix);

for p=1:row,
    fprintf( fil_r ,  '%x\n' , pic_matrix(p , 1) );
    fprintf( fil_g ,  '%x\n' , pic_matrix(p , 2) );
    fprintf( fil_b ,  '%x\n' , pic_matrix(p , 3) );
end

pic_matrix = matrix_pattern_compressed;
[row col ] = size(pic_matrix);

fil_r = fopen('pattern_red_matrix.txt' , 'w');
fil_g = fopen('pattern_green_matrix.txt' , 'w');
fil_b = fopen('pattern_blue_matrix.txt' , 'w');


for p=1:row,
    fprintf( fil_r ,  '%x\n' , pic_matrix(p , 1) );
    fprintf( fil_g ,  '%x\n' , pic_matrix(p , 2) );
    fprintf( fil_b ,  '%x\n' , pic_matrix( p , 3) );
end


fclose('all') ;

function pic_matrix =  pic_to_matrix(input_mat)
[row col color] = size(input_mat);
%temp_main_img = zeros(row*col,color);

for i=1:row,
    for j=1:col,
        temp_main_img(col*(i-1)+j, 1) = typecast(input_mat(i, j, 1),'uint8');
        temp_main_img(col*(i-1)+j, 2) = typecast(input_mat(i, j, 2),'uint8');
        temp_main_img(col*(i-1)+j, 3) = typecast(input_mat(i, j, 3),'uint8');
    end
end

pic_matrix = temp_main_img;
end


