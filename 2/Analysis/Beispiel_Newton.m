function Beispiel_Newton()
  clear all
close all
%
% Funktion, deren Nullstelle wir suchen und ihre Ableitung
% mögliche Beispiele:
%              Schnittstelle von Kosinus mit Winkelhalbierender
%              Maximales Volumen einer Pralinenschachtel
%              Was Sie sonst noch für Ideen haben, Baywatch vielleicht
f = @(x) 12*x.^2 - 104*x + 100; % Beispielfunktion
 df = @(x) 24*x - 104; % f'(x)

% Startwert uns Toleranz festlegen
x0 = pi/4;
TOL = 1.0e-08;

% Newton-Algorithmus starten
% flag=1 gibt Zwischeninformationen aus
x=MyNewton(f,df,x0,TOL,1);

% Ausgabe des Ergebnisses
fprintf("Die Nullstelle lautet: %.2f mit Residuum: %.2e\n",x,f(x));

% Wenn gewünscht eine Graphik des Ergebnisses samt Kurve

 h=figure(1);
 xx = linspace(x-1,x+1,100);
hold on
grid on
plot(xx,f(xx));
plot(x,f(x),'ro')
 set(gca,'XAxisLocation','origin','YAxisLocation','origin')
 %daspect([1 1 1])
 xlabel('x')
ylabel('y')
legend('f','Nullstelle','Location','southeast');
print(h,'-dpng','PicName.png')

end

function x=MyNewton(f,df,x0,TOL,flag)
%
% x=MyNewton(f,df,x0,TOL,flag)
%

iter = 0;
x = x0;
while abs(f(x))>TOL & iter<10
    iter = iter+1;
     if abs(df(x))<eps
         fprintf("Error in MyNewton\n");
         break
     else

        x = x - f(x)/df(x);

        if flag
            fprintf("iter = %010d: x = %10.2e, res = %10.2e\n",iter,x,abs(f(x)));
        end
     end
end


end

