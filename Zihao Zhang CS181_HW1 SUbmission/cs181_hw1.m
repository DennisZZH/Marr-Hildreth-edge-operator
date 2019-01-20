%Author: Zihao Zhang
%Date: 1.17.2019

inputImg = input("Input the picture name: ", 's');
name = inputImg(1:end-4);
format = '.bmp';

myImg = imread(inputImg);

if size(myImg,3) == 3
    myImg = rgb2gray(myImg);
end

myLaplacian = [0,1,0; 1,-4,1; 0,1,0];

imgCount = 0;

for sigma = [3, 6, 12, 24, 48]

    myKernal = 4 * ceil(2 * sigma) + 1;

    myGaussian = gaussian(myKernal,sigma);

    LoG = conv2(myGaussian, myLaplacian);

    myEdge = conv2(myImg, LoG);

    imgEdge = myEdge;

    for x = 1 : size(myEdge,1) - 1
        for y = 1 : size(myEdge,2) - 1
            if myEdge(x,y) * myEdge(x+1,y) < 0 || myEdge(x,y) * myEdge(x,y+1) < 0
                imgEdge(x,y) = 1;
            else
                imgEdge(x,y) = 0;
            end
        end
    end
   
% figure('name',strcat(inputImg,num2str(imgCount)));
% imshow(imgEdge);

imwrite(imgEdge, strcat(name, '_', int2str(imgCount), format));
imgCount = imgCount + 1;

end

function f = gaussian(N,S)
    size = -floor(N/2) : floor(N/2);
    [x,y] = meshgrid(size, size);
    f = exp(-(x.^2 + y.^2) / (2 * S^2));
    f = f / sum(f(:));
end