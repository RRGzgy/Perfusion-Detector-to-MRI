function mouseScrollWheel (object, eventdata)
%
k = evalin('base','k'); % evalua las variables del workspace que son llamadas
t = evalin( 'base' , 't');
im = evalin( 'base' , 'im');
f2 = evalin ( 'base','f2' );
linea = evalin( 'base' , 'linea');
C = get  ( get ( object,'Children' ) , 'CurrentPoint' ) ;
C = round(C);
%
k = k + eventdata.VerticalScrollCount;
%
k = max(1, min( k,  size(im,3)));
assignin('base','k',k)
%
set(get(get(object,'Children'),'Children'),'CData',im(:,:,k,t));  
title([num2str(C(1,1),'%d') ' ; ' num2str(C(1,2),'%d') ' ; ' num2str(k) ' ; ' num2str(t)])
%
figure(f2)
grid on
plot(squeeze(im(min(end,max(1,C(1,1))),min(end,max(1,C(1,2))), k, :)) ) ;
%
title([num2str(C(1,1),'%d') ' ; ' num2str(C(1,2),'%d') ' ; ' num2str(k)])
xlabel('Tiempo'); % Etiqueta eje X
ylabel('Intensidad de Señal'); % Etiqueta eje Y
delete(linea)
linea = line('XData',[t,t],'YData',...
    [0,max(max(im(min(end,max(1,C(1,1))),min(end,max(1,C(1,2))), k,:)))],'Color',[.8 .8 .8]);
assignin('base','linea',linea)
%
figure(object)
end