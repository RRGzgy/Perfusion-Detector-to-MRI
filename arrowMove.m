function arrowMove (object, eventdata)
keyPressed = eventdata.Key;
%
im = evalin( 'base' , 'im'); % evalua las variables del workspace que son llamadas
t = evalin( 'base' , 't');
k = evalin('base','k');
f2 = evalin ( 'base','f2');
linea = evalin( 'base' , 'linea');
C = get  ( get ( object,'Children' ) , 'CurrentPoint' ) ; % Toma posicion del ratón 
C = round(C);
%
if strcmp(keyPressed, 'rightarrow') %Compara si has apretado la flecha derecha
    t = t + 1; 
    t = min(t,size(im,4));
elseif strcmp(keyPressed, 'leftarrow')%Compara si has apretado la flecha izquierda
    t = t - 1;
    t = max(t,1); 
else
    return
end
%
figure(object)
imagesc(im(:,:,k,t));
title([num2str(C(1,1),'%d') ' ; ' num2str(C(1,2),'%d') ' ; ' num2str(k) ' ; ' num2str(t)])
assignin('base','t',t);
%
figure(f2) % Actualiza linea en la figura 2 segun tiempo en el que esta
delete(linea) %Borra linea
linea = line('XData',[t,t],'YData',...
    [0,max(max(im(min(end,max(1,C(1,1))),min(end,max(1,C(1,2))), k,:)))],'Color',[.8 .8 .8]);
assignin('base','linea',linea) % Actualiza linea y pasa a memoria
%
figure(object)
end