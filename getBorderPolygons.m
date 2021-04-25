function [areaA,areaB,areaC,areaD] = getBorderPolygons(curr_p2, currD, green_func,red_func,blue_func,black_func, point_inter)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here



%DEBUG
if isempty(point_inter)
    disp('no point inter')
    areaA=0; areaB=0; areaC=0; areaD=1;
    return;
end
%


areaA=0; areaB=0; areaC=0; areaD=0;

syms D

if currD>point_inter
    %can only be C or D
    

    global CM_CD
    %DEBUG PATCH FIXING THE GREEN FUNCTION PROBLEM
    %THE GREEN FUNCTION IS ACTUALLY A COMBINATION OF ALL THREE ROOTS AND NOT
    %JUST THE RIGHT FUNC THAT INTERSECTS WITH POINT_INTER
    if class(CM_CD)=="sym"
        cm_cd_func = CM_CD;
    else
        cm_cd_func = CM_CD.p2;
    end
    green_func_patch(D) = cm_cd_func;
    greenVal = vpa(green_func_patch(currD));
    tmp_ind = find(greenVal>0 & greenVal<0.5,1);
    greenVal = greenVal(tmp_ind);

    %
    
       
    %THIS WAS HERE BEFORE THE PATCH
    %greenVal = real(vpa(green_func(currD)));
    if curr_p2>=greenVal
        %D area
        areaD=1;
    else
        %C area
        areaC=1;
    end
else
    %can be A,B,D,C
    blueTop = real(vpa(solve(blue_func==0.5,D)));
    blueTopVal = find(currD<blueTop,1); %this is within the range, because D is in range
    if ~isempty(blueTopVal) %left to the point where blue hits 0.5
        blueBottom = real(vpa(solve(blue_func==0,D)));
        %can be A,B
        blueVal = real(vpa(blue_func(currD)));
        frontSlash = false;
        backSlash = false;
        if ~isempty(find(blueTop(blueTopVal)>blueBottom,1))
            frontSlash = true;
        else
            backSlash = true;
        end
        if curr_p2>=blueVal
            if frontSlash==true
                areaA=1;
            else
                areaB=1;
            end
        else
            if frontSlash==true
                areaB=1;
            else
                areaA=1;
            end
        end
    else %right of the point where blue hits 0.5
        %can be B,D,C
        redVal = real(vpa(red_func(currD)));
        if curr_p2>=redVal
            areaD=1;
        else %B or C
            %the black function can come in weird shapes
            %and not continuous
            %this can be C only if it is below the black function where
            %it is visible (near the point_inter
           blackVal = real(vpa(black_func(currD)));
           if blackVal<=0.5 && blackVal>0
               if curr_p2>=blackVal
                   areaB=1;
               else
                   areaC=1;
               end
           else
               areaB=1;
           end
        end
    end
end



end

