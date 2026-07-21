CTRL_BASELINE = 0;
CTRL_AFS      = 1;
CTRL_TV       = 2;

Choice = Simulink.VariantExpression( ...
    "controllerMode == CTRL_TV");

Choice_1 = Simulink.VariantExpression( ...
    "controllerMode == CTRL_AFS");

Choice_2 = Simulink.VariantExpression( ...
    "controllerMode == CTRL_BASELINE");

baseline.L = vehicle.a + vehicle.b;
baseline.Ky = 0.02;
baseline.Kpsi = 0.5;
baseline.deltaMax = deg2rad(30);

%% Torque-vectoring controller

% De Novellis et al. (IEEE TVT, 2014), conventional PID case. Keep the
% published 90-km/h values intact so the literature source remains fully
% traceable even though this project uses a different plant and speed.
tv.paper.Kp = 80e3;       % Published P gain [N*m*s/rad]
tv.paper.Ki = 0.004;      % Published I gain [N*m/rad]
tv.paper.Kd = 0.8;        % Published D gain [N*m*s^2/rad]
tv.paper.designSpeed = 90/3.6; % Paper operating speed [m/s]

% Use the published gains as the active literature baseline. The paper
% explicitly says that speed scheduling is needed away from its narrow
% 90-km/h range, but does not provide that schedule. Any later E-Class
% retuning must therefore be stored as a separate, clearly named profile.
tv.Kp = tv.paper.Kp;      % Active P gain [N*m*s/rad]
tv.Ki = tv.paper.Ki;      % Active I gain [N*m/rad]
tv.Kd = tv.paper.Kd;      % Active D gain [N*m*s^2/rad]

% The paper filters its reference yaw rate with a first-order factor.
tv.tauRef = 0.3;      % Reference-filter time constant [s]

% The paper states that anti-windup is present but does not publish its
% realization or tuning. Back-calculation is used here, and its tracking
% time is explicitly recorded as a project-specific implementation choice.
tv.tauAw = 0.1;       % Anti-windup tracking time constant [s]
tv.Kaw = 1/tv.tauAw;  % Back-calculation gain [1/s]

% Fixed yaw-moment authority is a bicycle-model actuator assumption. The
% later VDBS/CarSim adapters should replace it with their feasible limits.
tv.MzMax = 5000;      % Maximum direct yaw moment magnitude [N*m]

% The published P gain creates a fast closed-loop pole (about 24 ms for
% this bicycle plant). A 1-ms top-model maximum step resolves that loop and
% the hard yaw-moment limiter without relying on zero-crossing chatter.
tv.maxSolverStep = 1e-3; % Experiment-harness maximum solver step [s]

% Parameter vector consumed by the analytical quasi-static feedforward
% block: [mass, front CG distance, rear CG distance, front stiffness,
% rear stiffness]. This replaces the paper's unavailable lookup tables.
tv.vehicleParams = [vehicle.m, vehicle.a, vehicle.b, ...
                    vehicle.Caf, vehicle.Car];
