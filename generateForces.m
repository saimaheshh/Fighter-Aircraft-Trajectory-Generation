function forces = generateForces(num_steps, dur)
    % Generate forces for simulation steps
    f = linspace(-1, 1, num_steps);
    i = num_steps / 2;
    forces = zeros(3,num_steps);
    
    for dim = 1:3
        dim_forces = 0;        
        while length(dim_forces) < num_steps +1
            r = randi(dur);
            if (randi([0, 1]))
                f_sub = f(i:i + r);
            else
                f_sub = ones(1, r) * dim_forces(end);
            end
            dim_forces = [dim_forces  f_sub];
            if (i > r) 
                i = i - r;
            else
                i = abs(i + r);
            end
        end

        forces(dim,:) = dim_forces(1:num_steps);
    end
end