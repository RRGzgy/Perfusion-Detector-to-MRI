function mouseMove (object, eventdata)
%
f2 = evalin ( 'base','f2'); % evalua las variables del workspace que son llamadas 
linea = evalin( 'base' , 'linea');
k = evalin('base','k');
t = evalin( 'base' , 't');
im = evalin( 'base' , 'im');
C = get  ( get ( object,'Children' ) , 'CurrentPoint' ) ; % Obtenemos propiedades para figura object
C = round(C); % Redondeamos valor C
%
figure(object); % Abrimos Nueva Figura object
title([num2str(C(1,1),'%d') ' ; ' num2str(C(1,2),'%d') ' ; ' num2str(k) ' ; ' num2str(t)]); % Titulo
%
figure(f2); % Abrimos figura f2
grid on
%
plot(squeeze(im(min(end,max(1,C(1,1))),min(end,max(1,C(1,2))), k, :)) ) ;
%
title([num2str(C(1,1),'%d') ' ; ' num2str(C(1,2),'%d') ' ; ' num2str(k)])
xlabel('Tiempo'); % Etiqueta eje X
ylabel('Intensidad de Señal'); % Etiqueta eje Y
delete(linea)
linea = line('XData',[t,t],'YData',...
    [0,max(max(im(min(end,max(1,C(1,1))),min(end,max(1,C(1,2))), k,:)))],'Color',[.8 .8 .8]); % Definimos la linea para que señale el tiempo
assignin('base','linea',linea)
%
figure(object)
end

