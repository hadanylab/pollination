function [output] = check_solve(func,var,expected)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here,
    if abs(subs(func,var)-expected)<10^-3
        output = true;
    else
        output=false;
end

