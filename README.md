# Storage Optimal Control under Net Metering Policies
Code repo for our 2019 paper: Storage Optimal Control under Net Metering Policies

Authors: Md Umar Hashmi, Arpan Mukhopadhyay, Ana Bu\v{s}i\'c, and Jocelyne Elias

INRIA, DI ENS, Ecole Normale Sup\'erieure, CNRS, PSL Research University, Paris, France

Contact: umar.hashmi123@gmail.com

## Introduction
We formulate the optimal control problem for an end user energy storage device in
presence of net metering. We propose a computationally efficient algorithm, with worst case run time complexity of O(N^2), that computes the optimal energy ramping rates in a time horizon. The proposed algorithm exploits the problem’s piecewise linear structure and convexity properties for the discretization of optimal Lagrange multipliers. The solution has a threshold-based structure in which optimal control decisions are independent of past or
future price as well as of net load values beyond a certain time horizon, defined as a sub-horizon. Numerical results show the effectiveness of the proposed model and algorithm.

In this formulation we consider: (a) net-metering compensation (with selling price at best equal to buying price) i.e. $\kappa_i \in [0,1]$, (b) inelastic load, (c) consumer renewable generation, (d) storage charging and discharging losses, (e) storage ramping constraint and (f) storage capacity constraint. 


![alt text](https://github.com/umar-hashmi/linearprogrammingarbitrage/blob/master/lpcost.jpg)


Variables:
(i) p_b(i) Buying price at time instant i
(ii) p_s(i) Selling price at time instant i
(iii) z_i denotes net-load without storage output; it includes inelastic consumer load and consumer renewable generation
(iv) \kappa_i  is the ratio of selling price and buying price at time i
(v) \eta_{dis}, \eta_{ch}  charging and discharging efficiency of the battery
(vi) x_i denotes change in battery charge level at time instant i
(vii) s_i denotes battery output in time instant i



## Code Dependencies
All code are implemented in MATLAB.

