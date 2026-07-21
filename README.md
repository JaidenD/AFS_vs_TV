# AFS vs. Torque Vectoring

ME 780 vehicle-system-dynamics project comparing a baseline controller,
active front steering (AFS), and torque vectoring (TV) using a common
experiment harness and vehicle-state interface.

The current repository contains the E-Class parameter set, curved-lane
scenario, linear bicycle plant, controller interfaces, and the shared
Simulink experiment harness. The AFS and TV control laws are under
development.

## Requirements

- MATLAB and Simulink (developed with R2025b)
- Vehicle Dynamics Blockset for the future higher-fidelity plant
- CarSim for the future CarSim plant comparison

The current bicycle-model simulation only requires MATLAB and Simulink.

## Clone the repository

```bash
git clone https://github.com/JaidenD/AFS_vs_TV.git
cd AFS_vs_TV
```

Open MATLAB and set the current folder to the repository root. On macOS,
MATLAB R2025b can also be started from the repository root with:

```bash
/Applications/MATLAB_R2025b.app/bin/matlab -sd "$PWD"
```

## Initialize the project

Run the following once after starting MATLAB:

```matlab
setupProject
```

This command:

- adds the configuration, controller, harness, and plant folders to the path;
- creates `VehicleStateBus` and `ReferenceBus`;
- loads the E-Class vehicle parameters;
- defines the controller-selection constants; and
- loads the curved-lane scenario.

## Select a controller

After running `setupProject`, select one controller in the MATLAB Command
Window:

```matlab
controllerMode = CTRL_BASELINE;
% controllerMode = CTRL_AFS;
% controllerMode = CTRL_TV;
```

Only one assignment should be active. The controller modes are:

| Mode | Steering addition | Direct yaw moment |
| --- | --- | --- |
| Baseline | `delta_add = 0` | `Mz = 0` |
| AFS | `delta_add = delta_AFS` | `Mz = 0` |
| TV | `delta_add = 0` | `Mz = Mz_TV` |

## Open and run the experiment

From the MATLAB Command Window:

```matlab
open_system("experimentHarness")
set_param("experimentHarness", "SimulationCommand", "update")
simOut = sim("experimentHarness");
```

Alternatively, after opening the model, press **Ctrl+D** to update it and
click **Run** in Simulink.

The default curved-lane experiment uses:

- speed: 60 km/h;
- road-friction coefficient: 0.9;
- curve radius: 100 m; and
- curve start time: 2 s.

These values are defined in `config/scenarios/curvedLaneParams.m`.

## Model interfaces

Every controller augmentation uses the same interface:

```text
Inputs:  delta_base, Ref, VehicleState
Outputs: delta_add, Mz
```

The plant interface is:

```text
Inputs:  delta_f, Mz, Vx
Output:  VehicleState
```

The common vehicle-state bus contains:

```text
X, Y, psi, Vx, Vy, r, beta, ay
```

## Troubleshooting

### Undefined bus, scenario, or vehicle variables

Make sure the MATLAB current folder is the repository root and rerun:

```matlab
setupProject
```

### Controller model cannot be found

Rerun `setupProject`. It adds `models/controllers` to the MATLAB path.

### Variant-control error

The Variant Subsystem must use these control expressions:

```text
Baseline: controllerMode == CTRL_BASELINE
AFS:      controllerMode == CTRL_AFS
TV:       controllerMode == CTRL_TV
```

After changing `controllerMode`, press **Ctrl+D** or update the model before
starting the simulation.

## Planned comparison

The completed test matrix will compare:

- controllers: Baseline, AFS, and TV;
- plants: bicycle model, Vehicle Dynamics Blockset, and CarSim; and
- maneuvers: curved-lane tracking and double-lane change.
