% This program reads the yolo VisDrone generated dataset and transforms the
%classes into the corresponding numbers for each model

%given that one of the model only includes 4 of the 6 categories we are
%considering, it will be reduced to this.
positionCOCO = [2,7,0,1,3,5];
positionTFG  = [4,0,1,0,0,5];
previous = cd("datasetVALIDATED");
oldfolder = cd("labels");
files = dir;
cd(oldfolder);
for i=1:(length(files)-2)
    oldfolder = cd("labels");
    name = append(string(i),'.txt');
    dataFrame = table2array(readtable(name));%files(i).('name')));
    dataFrame = modify(dataFrame,positionCOCO);
    cd(oldfolder);
    oldfolder = cd('labelsfull');
    fileID = fopen(name,'w');
    printArray(dataFrame,fileID);
    fclose(fileID);
    cd(oldfolder)
end

function [dataFrame] = modify(dataFrame,position)
    limit = size(dataFrame);
    i=1; done =0; elim =0;
    while (done+elim)<limit(1)
            dataFrame(i,1) = dataFrame(i,1)-1;%position(dataFrame(i,1));
            i = i+1;
            done = done+1;
    end
end

function [] = printArray(table,fileID)
    limit = size(table);
    for i=1:limit(1)
        s = '';
        for j=1:limit(2)
            s = append(s,mat2str(table(i,j)),' ');
        end
        fprintf(fileID,'%s',s);
        fprintf(fileID,'\n');
    end
end
