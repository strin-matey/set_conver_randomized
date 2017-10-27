clear;
% Numero set
n = 300;
% Cardinalita' dell'universo
m = 50;

A = rand(m, n);
for i = 1:m
    for j = 1:n
         if A(i, j) < 0.2
             A(i, j) = 1;
         else
             A(i, j) = 0;
         end
    end
end  

% Creo vettori di supporto per il PL
% Negativo per corrispondere al segno
b = -ones(m, 1);
w = zeros(n, 1);

for i = 1:n
    for j = 1:m
         w(i) = w(i) + A(j, i);
    end
end 

% Negativo per corrispondere al segno
A = -A;
% Non abbiamo equazioni 
Aeq = [];
beq = [];
% Limiti inferiori e superiori
lb = zeros(n, 1);
ub = ones(n, 1);
% Risolvi il problema
x = linprog(w, A, b, Aeq, beq, lb, ub);

% Randomized algorithm
% Riporto in forma classica
A = -A;

% Parameters
T_start = 1;
T_max = 10;
number_iterations = 100;

% Vettore di risultati
results = zeros(T_max, 2);

for T_iter = T_start:T_max 
    % Ciclo per ottenere un valore medio e quindi un comportamento della
    % curva piu' uniforme
    for a = 1:number_iterations
        % Vettore per soluzione intera
        x_selected = zeros(n, 1);
        found = false;
        contatore = 1;
        while found == false | w.' * x_selected  > 4 * T_iter * w.' * x
            x_selected = zeros(n, 1);
            for i = 1:T_iter
                for j = 1:n
                    if(rand <= x(j))
                        x_selected(j) = 1;
                    end
                end
            end
            C = A * x_selected;
            found = true;
            for i = 1:m
                if C(i) < 1
                    found = false;
                end
            end
            contatore = contatore + 1;
        end
        results(T_iter, 1) = results(T_iter, 1) + w.' * x_selected;
        results(T_iter, 2) = results(T_iter, 2) + contatore;
    end
end

results = results ./ number_iterations;
X = 1:1:T_max;
x_theorem = log(4*m);
maxValues = max(results);
maxValue = max(maxValues);

result_lin_prog = w.' * x;
figure;
h = plot(X, results, 'linewidth', 2);
xlabel('Numero di flip coins (T)', 'Fontsize', 22, 'FontName', 'High Tower Text');
ylabel('');
title('Analisi parametrica', 'Fontsize', 22, 'FontName', 'High Tower Text');
disp(results);
hold all;
plot([x_theorem x_theorem], [0 maxValue]);
plot([1 T_max], [result_lin_prog result_lin_prog]);
legend({'Funzione costo', 'Numero di iterazioni', 'Barriera ln(4m)', 'Costo soluzione PL'}, 'EdgeColor', 'white', 'FontName', 'High Tower Text', 'FontSize', 24);