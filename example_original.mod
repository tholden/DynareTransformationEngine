var Y, C, R, PI, W, L, PI_STAR, NU, MC, AUX1, AUX2, A, G, beta, M, Sg;
varexo epsilon_a, epsilon_m, epsilon_g, epsilon_b;
parameters beta_STEADY, psi, A_STEADY, Sg_STEADY, PI_STEADY, vartheta, sigma, varepsilon, theta, phi_pi, phi_y, rho_a, rho_r, rho_b, rho_g, sigma_g, sigma_b, sigma_a, sigma_m;

beta_STEADY = 0.994;
Sg_STEADY = 0.2;
A_STEADY = 1;
PI_STEADY = 1.005;
psi = 2;
vartheta = 1;
theta = 0.75;
varepsilon = 6;
sigma = 1;
phi_pi = 1.5;
phi_y = 0.25;
rho_r = 0;
rho_a = 0.9;
rho_g = 0.8;
rho_b = 0.8;
sigma_a = 0.0025;
sigma_g = 0.0025;
sigma_m = 0.0025;
sigma_b = 0.0025;

model;
	1 = R * beta(+1) * ( C / C(+1) ) / PI(+1);
	psi * L^vartheta*C = W;
	MC = W/A;
	varepsilon * AUX1 = (varepsilon - 1) * AUX2;
	AUX1 = MC * (Y/C) + theta * beta(+1) * PI(+1)^(varepsilon) * AUX1(+1);
	AUX2 = PI_STAR * ((Y/C) + theta * beta(+1) * ((PI(+1)^(varepsilon-1))/PI_STAR(+1)) * AUX2(+1));
	R = max(1,( PI_STEADY / beta_STEADY )^(1 - rho_r) * R(-1)^rho_r * ( ((PI/STEADY_STATE(PI))^phi_pi) * ((Y/STEADY_STATE(Y))^phi_y) )^(1 - rho_r) * M);
	G = Sg*Y;
	1 = theta * (PI^(varepsilon-1)) + (1 - theta) * PI_STAR^(1 - varepsilon);
	NU = theta * (PI^varepsilon) * NU(-1) + (1 - theta) * PI_STAR^(-varepsilon);
	Y = C + G;
	Y = (A/NU) * L;
	
	A = A_STEADY^(1 - rho_a) * A(-1) ^(rho_a) * exp(sigma_a * epsilon_a);
	M = exp(-sigma_m * epsilon_m);
	beta = beta_STEADY^(1 - rho_b) * (beta(-1)^rho_b) * exp(sigma_b*epsilon_b);
	Sg = Sg_STEADY^(1 - rho_g) * Sg(-1)^rho_g * exp(-sigma_g*epsilon_g);
end;

steady_state_model;
	A = A_STEADY;
	Sg = Sg_STEADY;
	beta = beta_STEADY;
	M = 1;
	PI = PI_STEADY;
	PI_STAR = ( (1 - theta * (1 / PI)^(1 - varepsilon) ) / (1 - theta) )^(1/(1 - varepsilon));
	NU = ( ( 1 - theta) / (1 - theta * PI ^varepsilon) ) * PI_STAR ^(-varepsilon);
	W = PI_STAR * ((varepsilon - 1) / varepsilon) * ( (1 - theta * beta * PI ^varepsilon)/(1 - theta * beta * PI ^(varepsilon-1)));
	C = (W /(psi * ((1/(1 - Sg)) * NU)^vartheta))^(1/(1 + vartheta));
	Y = (1 / (1 - Sg)) * C;
	G = Sg * Y;
	L = Y *NU;
	MC = W;
	R = PI / beta;
	AUX1 = W * (Y /C)/(1 - theta * beta * PI ^varepsilon);
	AUX2 = PI_STAR * (Y /C)/(1 - theta * beta * PI ^(varepsilon-1));
end;

shocks;
	var epsilon_a = 1;
	var epsilon_g = 1;
	var epsilon_b = 1;
	var epsilon_m = 1;
end;

steady;
check;

stoch_simul( order = 3, irf = 40, periods = 1100, irf_shocks = ( epsilon_b ), replic = 50 );