function [ result,func1_id,func2_id,func3_id ] = find_borders_intersect(func1,func2,func3,high_accuracy)


if nargin<4
    high_accuracy = false;
end


func1_id = 0;
func2_id = 0;
func3_id = 0;
%D_set=[10 50:25:10000];


%DEBUG FIX TO 3
D_set=logspace(0,3,100);
%D_set=[10^-5:10^-5:10^-3 10^-3:10^-3:10^-1 10^-1:0.1:1 1:1:10];
if high_accuracy == true
    epsilon1 = 0.005;
    epsilon2 = 0.002;
else
    epsilon1 = 0.05;
    epsilon2 = 0.02;
end

result=[];
cand=[];
cand2=[];


try
    %initial sampling to find relevant range
    func_val1 = func1(D_set); %symbolic arrays
    func_val2 = func2(D_set);
    
    cand_mat = []; %func1_idx,func2_idx,func3_idx, func1_val, func2_val, D_val
    
    for i =1:size(func_val1,1)
        for j=1:size(func_val2,1)
            func1_curr_val = real(vpa(func_val1(i)));
            func2_curr_val = real(vpa(func_val2(j)));
            [min_val,min_idx] = min(abs(func1_curr_val-func2_curr_val));
            if min_val<epsilon1
                cand_mat = [cand_mat; [i,j,0,func1_curr_val(min_idx),func2_curr_val(min_idx),vpa(D_set(min_idx))]];
            end
        end
    end
    %
    
    %if two functions intersect, check the third function
    if ~isempty(func3)
        cand_mat2 = [];
        for i=1:size(cand_mat,1)
            curr_row = cand_mat(i,:);
            val3 = real(vpa(func3(curr_row(end))));
            %TODO: below, this can be more than one func3
            %we are neglecting it
            %curr_row(4) == func1_curr_val
            find3 = find(abs(val3-curr_row(4))<epsilon1,1);
            if find3
                func3_id = find3;
                cand_mat2 = [cand_mat2; [cand_mat(i,1:2),find3,cand_mat(i,end)]];
            end
            %
        end
        %func1_idx,func2_idx,func3_idx, D_val
        cand_mat = cand_mat2;
    end
    
    
    
    
    %found the general vicinity of the intersect, now need to find the intersect with
    %better accuracy
    cand_mat2 = cand_mat;
    for i=1:size(cand_mat,1)
        curr_row = cand_mat(i,:);
        
        cand = curr_row(end); %4
        func1_id = curr_row(1);
        func2_id = curr_row(2);
        
        cand_range= logspace(floor(log10(cand)), max(ceil(log10(cand)),2),100);
        
        func1_vals = func1(cand_range);
        func2_vals = func2(cand_range);
        
        func1_vals = real(vpa(func1_vals(func1_id)));
        func2_vals = real(vpa(func2_vals(func2_id)));
        
        [min_val,min_idx] = min(abs(func1_vals-func2_vals));
        
        
        %check for third function
        if isempty(func3)
            min_val3 = 0;
        else
            func3_id = curr_row(3);
            func3_vals = func3(cand_range(min_idx));
            func3_vals = real(vpa(func3_vals(func3_id)));
            
            min_val3 = abs(func1_vals(min_idx)-func3_vals);
            
        end
        %
        
        if min_val<epsilon2 && min_val3<epsilon2
            cand2 = cand_range(min_idx);
            cand_mat2(i,5) = cand2;
        else
            cand_mat2(i,5)=-1;
        end
    end
    cand_mat = cand_mat2;
    
    
    
    
    
    %WHAT IF THERE'S MORE THAN ONE VALID ANSWER??
    %THERE COULD BE MORE THAN ONE ANSWER
    if ~isempty(cand_mat)
        res = find(cand_mat(:,end)~=-1,1); %FIRST VALID ROW
        if ~isempty(res)
            func1_id = cand_mat(res,1); %red
            func2_id = cand_mat(res,2); %green
            func3_id = cand_mat(res,3); %black
            result = vpa(cand_mat(res,5));
        end
    end
    
    
    
    
catch
    disp('EXCEPTION THROWN DURING FIND_BORDERS_INTERSECT');
    
    
    
end

