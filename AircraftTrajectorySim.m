% Fighter Aircraft Trajectory Simulation
% Author: A Sai Mahesh
% Date: August 10, 2023
% Explanation: This script simulates the trajectory of an Fighter aircraft based on
% the provided parameters and generated forces.



% Aircraft parameters
mass = 5000; % kg
g = 9.8;
moments_of_inertia = [5000; 10000; 20000]; % kg*m^2
initial_position = [0; 0; 0]; % [x; y; z] meters
initial_velocity = [0; 0; 0]; % [u; v; w] m/s
initial_orientation = [0; 0; 0]; % [phi; theta; psi] radians

% Time settings
total_time = 60; % seconds
time_step = 0.05; % seconds
num_steps = total_time / time_step;

position = zeros(3, num_steps);
velocity = zeros(3, num_steps);
orientation = zeros(3, num_steps);

% Initial conditions
position(:, 1) = initial_position;
velocity(:, 1) = initial_velocity;
orientation(:, 1) = initial_orientation;

% Generate forces for x, y, and z dimensions using the new function
dur = [-25, 25]; % Range for force duration
forces = mass * g * generateForces(num_steps, dur);

% Simulation loop
for step = 2:num_steps
    force = forces(:,step);
    
    % Calculate acceleration
    acceleration = force / mass;
    
    velocity(:, step) = velocity(:, step-1) + acceleration * time_step;
    
    position(:, step) = position(:, step-1) + velocity(:, step) * time_step;
    
    % Calculate angular acceleration
    moment = force .* (position(:, step) - position(:, step-1));
    angular_acceleration = moment ./ moments_of_inertia;
    
    % Update orientation
    orientation(:, step) = orientation(:, step-1) + angular_acceleration * time_step* time_step;
    
    % Correct orientation after crossing 2*pi radians
    for i = 1:3
        while orientation(i, step) >= 2*pi
            orientation(i, step) = orientation(i, step) - 2*pi;
        end
    end
    
    % Apply orientation to position update 
    phi = orientation(1, step);
    theta = orientation(2, step);
    psi = orientation(3, step);
    
    %compute directional cosines
    R = [cos(theta)*cos(psi), cos(theta)*sin(psi), -sin(theta);
         sin(phi)*sin(theta)*cos(psi)-cos(phi)*sin(psi), sin(phi)*sin(theta)*sin(psi)+cos(phi)*cos(psi), sin(phi)*cos(theta);
         cos(phi)*sin(theta)*cos(psi)+sin(phi)*sin(psi), cos(phi)*sin(theta)*sin(psi)-sin(phi)*cos(psi), cos(phi)*cos(theta)];
    %Apply to position 
    position(:, step) = position(:, step) + R * velocity(:, step) * time_step;
end

% Plot trajectory
figure;
plot3(position(1, :), position(2, :), position(3, :));
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
title('Aircraft Trajectory');
grid on;

