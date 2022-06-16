% This code is to compute the lower and upper bounds of the amount
% of change made at the VisDrone dataset, to evaluate if there
% is a real need to validate the data.

lengths = [269 58 118 501 181 84 217 97 361 361 516 1255 398 412 213 256 261 307 348 679 677 330 500 210 180 414 100 369 90 150 181];
validateFrame = ones(1,2);
finished = false;
totalchangesend = 0;
totalchangesbegin = 0;
numberelements= 0;
imageHeight = 1071;
imageWidth = 1904;
frameModified = 1;
lengthindex = 1;
frameOriginal = 1;
experiment = 10000;
historyMax = zeros(1,experiment);
historyLowEnd = zeros(1,experiment);
historyLowBegin = zeros(1,experiment);
while(frameModified<experiment) 
    [dataModified,frameModified]=getDataFrameModified(frameModified);
    [dataOriginal,frameOriginal,lengthindex]=getDataFrameOriginal(frameOriginal,lengthindex,lengths,frameModified);
    [numberelements,totalchangesbegin,totalchangesend] = check(dataOriginal,dataModified,numberelements,totalchangesend,totalchangesbegin);
    historyMax(frameModified) = (totalchangesend+totalchangesbegin)*100/numberelements;
    historyLowEnd(frameModified) = totalchangesend*100/numberelements;
    historyLowBegin(frameModified) = totalchangesbegin*100/numberelements;

end

disp('Total changes made in the modified that do not appear in the original')
totalchangesend
disp('Total in the original that do not appear in the modified')
totalchangesbegin
disp('Total number of ROI of original')
numberelements
disp('minimum change in modified')
totalchangesend*100/numberelements
disp('maximum change in modified')
(totalchangesend+totalchangesbegin)*100/numberelements
figure
plot(historyMax)
hold on
plot(historyLowBegin)
hold on
plot(historyLowEnd)
xlabel('Number of cumulative frames')
ylabel('%Change with respect to original ROI')
%totalchangesend: ROI that appear in the modified version but not in the
%original, due to either missed objects or misclassified ones

%totalchanesend: ROI that appear in the original version but not in the
%modified, due to either non existent objects or misclassfied ones

function [numberelements,totalchangesbegin,totalchangesend] = check(dataOriginal,dataModified,numberelements,totalchangesend,totalchangesbegin)
    for i=1:length(dataOriginal(:,1))
        if(isempty(find(ismembertol(round(dataModified,3),round(dataOriginal(i,:),3),0.001,'ByRows',true), 1)))
            totalchangesbegin = totalchangesbegin+1;
        end
    end
    for i=1:length(dataModified(:,1))
        if(isempty(find(ismembertol(round(dataOriginal,3),round(dataModified(i,:),3),0.001,'ByRows',true), 1)))
            totalchangesend = totalchangesend+1;
        end
    end
    numberelements = numberelements + length(dataOriginal);
end

%Function that get the data from the modified version of the current frame
function [dataFrame,frame] = getDataFrameModified(frame)
    oldfolder = cd('datasetVALIDATED/labels');
    dataFrame = table2array(readtable(append(string(frame),'.txt')));
    frame = frame+1;
    cd(oldfolder);
end

%Function that get the data from the original version of the current frame
function [dataFrame,validateFrame,lengthindex] = getDataFrameOriginal(validateFrame,lengthindex,lengths,frameModified)
    imageWidth = [1344 1344 1344 1344 1904 1904 1904 1904 1904 1904 1344 1344 2688 2688 2688 2688 2688 2688 2688 1344 1344 1904 1904 1904 1904 1904 1904 1904 1904 1344 1904];
    imageHeight= [756 756 756 756 1071 1071 1071 1071 1071 1071 756 756 1512 1512 1512 1512 1512 1512 1512 756 756 1071 1071 1071 1071 1071 1071 1071 1071 756 1071];
    if((frameModified-1)>sum(lengths(1:lengthindex)))
        lengthindex = lengthindex +1;
        validateFrame = 1;
    end

    oldfolder = cd('validateDataset');
    cd('annotations');
    A = dir;
    namecurrent = A(2+lengthindex).('name');
    Datafile = table2array(readtable(namecurrent));
    limit = size(Datafile);
    j=1;
    for i=1:limit(1)
        if(Datafile(i,1)==validateFrame && Datafile(i,8) ~= 0 && Datafile(i,8) ~= 11 && Datafile(i,10) ~= 2)
            typeObject = Datafile(i,8);
            if(typeObject==1 || typeObject==2)
                typeObject='3';
            elseif(typeObject==3)  
                typeObject='4';
            elseif(typeObject==4 || typeObject==5 || typeObject==11)
                typeObject='1';
            elseif(typeObject==6)
                typeObject='2';
            elseif(typeObject==9)
                typeObject='6';
            elseif(typeObject==7 || typeObject==8 || typeObject == 10) 
                typeObject='5';
            end
            dataFrame(j,1) = str2double(typeObject); %Type object
            dataFrame(j,2) = (Datafile(i,3)+Datafile(i,5)/2)/imageWidth(lengthindex); %x 
            dataFrame(j,3) = (Datafile(i,4)+Datafile(i,6)/2)/imageHeight(lengthindex); %y
            dataFrame(j,4) = Datafile(i,5)/imageWidth(lengthindex); %width
            dataFrame(j,5) = Datafile(i,6)/imageHeight(lengthindex); %height
            j = j+1;
        end
    end
    cd(oldfolder);
    validateFrame = validateFrame + 1;
end


