# fsr_final_project

## Project Overview  
This repository contains the implementation and simulation of a robot navigation algorithm based on the Dynamic Window Approach (DWA).  

## Folder Structure  

- **`utils/`**  
  Contains utility functions required for running the simulations.  

- **`materials/`**  
  Stores images and videos included in the report and PowerPoint presentation, as well as saved workspace files (`.mat`) for loading precomputed simulations.  

- **Root Directory**  
  Contains the main scripts for running and visualizing the simulations.  

## Running the Simulations  

### Visualizing Precomputed Simulations  
To visualize previously saved simulations from one of the `.mat` files in `materials/`, use the following scripts:  

- **For Map 1 and Map 2**: Run `visualize.m`  
- **For Map 3**: Run `sequence_visualize.m`  

### Running New Simulations  
To start a new simulation, follow these steps:  

#### **For Map 1 and Map 2**  
1. Open the Simulink file: `dwa_obstacle_avoidance.slx`  
2. Run `dynamic_window_init.m`  

#### **For Map 3**  
1. Open the Simulink file: `sequence_dwa_obstacle_avoidance.slx`  
2. Run `sequence_dynamic_window_init.m`  

These scripts initialize the simulation parameters and allow you to observe the robot's behavior in different environments.  
