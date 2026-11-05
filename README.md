# horizon_ws

ROS 2 Lyrical workspace for the Horizon robot. Everything runs in Docker so the laptop and the Pi use identical setups.

| | Laptop | Pi |
|---|---|---|
| `robot` container | yes (for testing) | yes |
| `sim` container (Gazebo, RViz) | yes | never |

## Quick commands

```bash
./scripts/sim.sh        # laptop: shell in the sim container
./scripts/robot.sh      # laptop or Pi: shell in the robot container
rbuild                  # inside a container: install deps + colcon build
docker compose down     # stop containers
docker compose build    # rebuild images after editing docker/Dockerfile
```

Robot code goes in `src/robot/`. Sim-only code goes in `src/sim/`.
