close all
clear
clc
arrayPositionsDev = [1526 1886; 4829 5041;6214 6892;8400 8609;...
8610 8789;9673 9762;9763 9912;9913 10093;];
limit2 = 0;
for i=1:length(arrayPositionsDev)
    limit2 = limit2 + (arrayPositionsDev(i,2)-arrayPositionsDev(i,1)+1);
end
nofinal = true;
j=1;
i = arrayPositionsDev(j,1);

% These are the parameters to modify to select the lower and upper value of the contrast
lowerBound = 50;
upperBound = 150; 


while nofinal
    old = cd('images');
    % Reading the image
    A = imread(string(i)+'.jpg');
    maximum = max(max(A,[],[1 2])); 
    minimum = min(min(A,[],[1 2]));
    
    % Modification of the colour histogram
    B = lowerBound+(A-minimum).*(upperBound/(double(maximum)-double(minimum)));
    
    % Saving up the new image
    cd(old);
    old = cd('imagesContrast');
    imwrite(B,string(i)+'.jpg')
    cd(old);
    i = i+1
    if(i>arrayPositionsDev(j,2))
        j = j+1;
        if(j>length(arrayPositionsDev))
            nofinal=false;
        else
            i = arrayPositionsDev(j,1);
        end
    end
end
