% Limpieza de pantalla
clear all
close all
clc

% 1. Definimos las variables físicas de tu robot (5 Motores)
L1 = 5; L2 = 4;
theta1 = 45; theta2 = 30; theta3 = -20; theta4 = 15; theta5 = 10; 

% 2. Calculamos las matrices de transformación homogénea
H0 = SE3; % Matriz identidad (Origen S0 en el techo)

% Trama 1: Motor 1 rotando en Z0
H1 = SE3.Rz(deg2rad(theta1));

% Trama 2: Rotación de -90° sobre X (alineación) y Motor 2 en Z
H2 = SE3.Rx(deg2rad(-90)) * SE3.Rz(deg2rad(theta2));

% Trama 3: Traslación hacia abajo (L1 en X) y Motor 3 en Z
H3 = SE3(L1, 0, 0) * SE3.Rz(deg2rad(theta3));

% Trama 4: Traslación (L2 en X), Rotación de 90° en Z y Motor 4
H4 = SE3(L2, 0, 0) * SE3.Rz(deg2rad(90)) * SE3.Rz(deg2rad(theta4));

% Trama 5: Efector Final. Rotación de 90° en X para apuntar al suelo y Motor 5
H5 = SE3.Rx(deg2rad(90)) * SE3.Rz(deg2rad(theta5));

% Transformaciones globales acumuladas
H0_1 = H0 * H1;
H1_2 = H0_1 * H2;
H2_3 = H1_2 * H3;
H3_4 = H2_3 * H4; 
H4_5 = H3_4 * H5; % Matriz final de S5 respecto a S0

% 3. Coordenadas de la estructura (Extracción automática)
p0 = H0.t; p1 = H0_1.t; p2 = H1_2.t; p3 = H2_3.t; p4 = H3_4.t; p5 = H4_5.t;

x = [p0(1) p1(1) p2(1) p3(1) p4(1) p5(1)];
y = [p0(2) p1(2) p2(2) p3(2) p4(2) p5(2)];
z = [p0(3) p1(3) p2(3) p3(3) p4(3) p5(3)];

% 4. Graficamos la estructura estática
figure; 
plot3(x, y, z, '-o', 'LineWidth', 1.5, 'MarkerSize', 5); 
axis([-10 10 -10 10 -10 10]); grid on; hold on;
xlabel('X'); ylabel('Y'); zlabel('Z');

% Graficamos la trama absoluta o global 
trplot(H0, 'rgb', 'axis', [-10 10 -10 10 -10 10], 'frame', '0')

% 5. Animaciones trama por trama
disp('Presiona Enter para ver la animación...');
pause; tranimate(H0, H0_1, 'rgb', 'axis', [-10 10 -10 10 -10 10])
pause; tranimate(H0_1, H1_2, 'rgb', 'axis', [-10 10 -10 10 -10 10])
pause; tranimate(H1_2, H2_3, 'rgb', 'axis', [-10 10 -10 10 -10 10])
pause; tranimate(H2_3, H3_4, 'rgb', 'axis', [-10 10 -10 10 -10 10])
pause; tranimate(H3_4, H4_5, 'rgb', 'axis', [-10 10 -10 10 -10 10])

disp('Matriz de transformación homogenea global final (S5 a S0):')
disp(H4_5)