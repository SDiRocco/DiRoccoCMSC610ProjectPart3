% DiRocco CMSC 601 Project Part 3 Setup
% Shawn DiRocco

% File Path of Images
InputfilePath = 'C:\Users\mail9\Desktop\DiRoccoCMSC601Project\Input Images\Cancerous cell smears\*.bmp';

% Output Path of Images
OutputfilePath = 'C:\Users\mail9\Desktop\DiRoccoCMSC601Project\Output\';

% Amount of Each Type of Cell
cyl = 50; %50
inter = 50; %50
let = 100; %100
modc = 100; %100
para = 50; %50
super = 50; %50
svar = 100; %100

% Grayscale Weights
cR = 0.299;
cG = 0.587;
cB = 0.114;

% Clear Output Folder
% To Clear Input 'Yes'
% Else Input Anything Else
Clear = 'Yes';

% Copy Input Images to Output
% To Copy Input 'Yes'
% Else Input Anything Else
Copy = 'Yes';

% Perform K-NN Classification
% To Perform K-NN Classification Input 'Yes'
% Else Input Anything Else
KNN = 'Yes';

% k value for K-NN Classification
k = 1;

% Threshold of Edge Detection
EdgeThreshold = 10;