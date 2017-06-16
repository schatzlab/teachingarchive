% I always start out my Matlab scripts like this. 
clear all            % Clears all variables I might have set
close all            % Closes all plots

%% Making and maniuplating matrices

% Create a 5x3 matrix of random numbers (from 0 to 1)!
A = rand(5,3)

% Look at rows and columns of A
A(1,3)   % An element of A
A(:,3)   % Third column of A
A(1,:)   % First row of A
A(:)     % View A as a vector

%Look at A!
A
imagesc(A)
colorbar()

% Matrix opperations vs. array operations
A + A'
A*A
A.*A
A./A
A/A

B = A        % Make a COPY of A (changes to B won't affect A now)
B(1,:) = []  % Delete the first row of B
size(B)      % Now they don't have the same sizes 
size(A)      

C = rand(6,3) % New matrix, same # columns, different # rows
D = [A;C]     % Concatenate matrices

% You can create matrices by hand, if you're so inclined
E = [1 2 3; 4 5 6]
E'    % Transpose a matrix (flip rows and columns)

% Other ways to create matrices
Z = zeros(2,4)
O = ones(3,3)
R = randn(4,4)

% Creating data arrays
n = (0:9)';
pows = [n  n.^2  2.^n]

x = (1:0.1:2)';
logs = [x log10(x)]

D = [ 72          134          3.2
      81          201          3.5
      69          156          7.1
      82          148          2.4
      75          170          1.2 ]
  
% Summary statistics
mu = mean(D), sigma = std(D)

% Indexing
x = [2.1 1.7 1.6 1.5 NaN 1.9 1.8 1.5 5.1 1.8 1.4 2.2 1.6 1.8];
x = x(isfinite(x))
x = x(abs(x-mean(x)) <= 3*std(x))

A = magic(4)
k = find(isprime(A))'
A(k) = NaN

% Hiding output
A = magic(10)
A = magic(100);

% Entering long statements
s = 1 -1/2 + 1/3 -1/4 + 1/5 - 1/6 + 1/7 ...
      - 1/8 + 1/9 - 1/10 + 1/11 - 1/12;

%% Graphics

% Plot a sine function
x = 0:pi/100:2*pi;
y = sin(x);
plot(x,y)

% Try plotting additional functions
y2 = sin(x-.25);
y3 = sin(x-.5);
plot(x,y2)   % Erases what you already have
plot(x,y3)   % Erases what you already have

cla
plot(x,y,'r:')
hold on
plot(x,y2, 'g--')
plot(x,y3, 'b-')
legend('one', 'two', 'three')

% Create a histogram
data = randn(10000,1);
hist(data,100);
[y, x] = hist(data,100);
barh(x,y,1,'facecolor', 'g', 'edgecolor', 'none')

% Create 4 3D plots
figure('windowstyle', 'docked')
t = 0:pi/10:2*pi;
[X,Y,Z] = cylinder(4*cos(t));
subplot(2,2,1); mesh(X)
subplot(2,2,2); mesh(Y)
subplot(2,2,3); mesh(Z)
subplot(2,2,4); mesh(X,Y,Z)

% Draw a neat-looking 3D shape
figure('windowstyle', 'docked')
[X,Y] = meshgrid(-8:.5:8); 
R = sqrt(X.^2 + Y.^2) + eps;
Z = sin(R)./R;
mesh(X,Y,Z,'EdgeColor','black')

% Come on, make it look FANCY!
surf(X,Y,Z)
colormap hsv
colorbar
alpha(.4)

% View an image/matrix
clear all
close all

load durer
image(X)
colormap(map)
axis image
colormap(hot)

% Make a pretty plot and save it
figure('position', [48   130   856   334], 'paperpositionmode', 'auto')
x = 0:pi/100:2*pi;
y = sin(x);
plot(x,y, 'linewidth', 2)
set(gca, 'fontsize', 14, 'box', 'on', 'linewidth', 2)
xlabel('x = 0:2\pi')
ylabel('Sine of x')
title('Plot of the Sine Function','FontSize',18)
legend('sin function')
axis equal
set(gca, 'xlim', [min(x) max(x)])
print -dpng my_figure_1.png


%% Flow control

% Sum all the numbers divisible by 3 that are less than 10 million
N = 1E7

% If we know the formula
M = floor(N/3)
s = 3*M*(M+1)/2

% Using flow control
s = 0;
tic
for n=1:N
    if mod(n,3) == 0 
        s = s+n;
    end
end
toc

% Using vectorized operations
tic
x = 1:N;
indices = mod(x,3) == 0;
s = sum(x(indices))
toc

% At what point does this sum pass 1E10?
s = 0;
n = 0;
while s <= 1E10
    n = n+1;
    if mod(n,3) == 0 
        s = s+n;
    end
end
disp(['Loopy answer: ' num2str(n)])

% Using vectorized operators
x = (1:N)';
indices = mod(x,3) == 0;
y = x(indices);
z = cumsum(y);
i = find(z > 1E10, 1);
n = y(i);
disp(['Vectorized answer: ' num2str(n)])

%% Strings, cell arrays, and structures
x = 'Mickey'
y = 'Justin'
z = 'Mike'

A = [x, y]
B = [x; y]
C = [x; y; z]  % Won't work

D = {x; y; z}
class(D)
class(D(1))
class(D{1})
D(1:2)
D{1:2}

sum(x)
double(x)
char(double(x))

% Creating sturctures
clear fish
fish.one = 'red';
fish.two = 'blue';
fish.num_stripes = 15;
fishies = repmat(fish,5,1)
fishies(3).one = 'yellow';
fishies.one
fishies(4).three = 'black';
fishies(end+1) = fish
fish.three = 'white'
fishies(end+1) = fish

% Saving and loading data
save mystuff.mat A B D fishies
clear all
who
load mystuff.mat
who