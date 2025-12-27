function J = ITAE_PID(x)

assignin("base", "Kp", x(1));
assignin("base", "Ti", x(2));
assignin("base", "Td", x(3));

out = sim("ITAEmodPID.slx");
J = out.J_ITAE_PID.Data;
end