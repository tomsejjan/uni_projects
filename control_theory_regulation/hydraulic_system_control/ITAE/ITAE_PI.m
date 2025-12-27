
function [J] = ITAE_PI(x)
        assignin('base', 'Kp', x(1))
        assignin('base', 'Ti', x(2))

        out = sim('ITAEmodPI.slx');
        J = out.J_ITAE_PI.Data;
end