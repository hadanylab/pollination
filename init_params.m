syms p2 p1 F1 F2 D

global g
global g1
global g2

global Fmax
global Sp
%global c
global Smax
global QTotal
global h
global generation_length_in_seconds
global z_rate 
global Ke %efficiency of probe time on pollination
global seed_exp_power;
global max_pollen_per_visit;
%global C %I change this locally in get_gen/search due to laziness

%global epsilon
%global r


global r1 %basic is 0.5 for both r1,r2 and dissimilarity = 1
global r2
global a1
global a2
global b1
global min_r
min_r = 6;
r1 =min_r+1;
r2 =min_r+1;
%a is in units s/microliter
a1=1; %a*F should be in the same scale as other times in the system
a2=a1; 
b1=2; %CHANGE BACK TO 2, JUST FOR TESTING
h=0.2; %0<=h<=1, negative impact of heterospecific pollen

QTotal = 1; %validated Blaauw, Isaacs 2014

global CM_penalty
CM_penalty = 1;

%r1,r2=5,g=0.005,F=5, C=1.5 works fine


%factor governing the fraction of pollen collected/deposited during the 
%probing/access time
Ke = 0.2; %0<=Ke<=1
%epsilon = 10^-2;

%global DIFF_G
%DIFF_G = true;
%main graph is with g=0.0025, other graph with 0.05, 0.0005
g=0.0005; %microliter/s validated nov 18. stout goulson 2002 //0.0001 
g1=g;
g2=g;


Fmax=10; %microliter. validated nov 18 stout  goulson 2002 // 0.1-5
Sp=0.1; %m/s. validated nov 18, chittka 2007 and others also
%with Sp=1 the flight time is in scale of 0.05-0.5s, with Sp=0.1 it's
%0.5-5s

%c=0.5; %minimum time even if there is no standing crop of nectar ==search time?
%r=c;

z_rate = 40; %grain/second , validated Thostesen 1996 23.5 grain/s


%according to Thostesen, only 0.5%-1% of the collected pollen is deposited
%at all, the rest is lost on the way by grooming
max_pollen_per_visit = 200; %max per visit is the amount that the pollinator carries (without carryover)... snow and roubik 2014
%also Thostesen 1996. 

%from Campbell 1986
%Smax = 5.05; %seeds
%seed_exp_power=0.015;

%from  Waites 2004
Smax = 52.6;
seed_exp_power = 0.0163;

generation_length_in_seconds = 60; %3 minute 


