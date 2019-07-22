%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   MRI Perfusión                       %
%                                                       %
%                 Roberto Rueda Galindo                 %
%                 6 de Febrero de 2017                  %
%                Universidad de Zaragoza                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
clear all; % Vaciamos el area de trabajo de variables
close all; % Cerramos cualquier figura
clc; % Vaciamos la ventana de comandos
%
%%% Cargamos el archivo que contiene las imagenes
fprintf('\n -------------- INTRODUCIR DATOS    ');
file = input('Nombre del archivo: ', 's');
load(file);
% load 107_perf.mat
%
fprintf('\n -------------- INTRODUCIR DATOS    ');
var1 = 'Nombre variable 3D anatómica: ';
T1 = input(var1);
% T1=T1_107;
%
fprintf('\n -------------- INTRODUCIR DATOS    ');
var2 = 'Nombre variable 4D perfusión: ';
perf = input(var2);
% perf=perf_107;
%
%%%%%%%%%%%%% ANALISIS ANATOMICO %%%%%%%%%%%%%
%
% Barrido del Cerebro en Eje Axial, Sagital y Coronal
figure (1); % Nueva Fig. 1
T_im = 1+ int16((double(T1) / double(max(T1(:))) *63)) ; % Paso la imagen anatomica a escala de grises de 1 a 64 
colormap gray
imshow3Dfull(T_im,[20 100]); % Utilizamos la función imshow3Dfull para hacer un barrido de toda la cabeza
%
%%%%%%%%%%%%% ANALISIS PERFUSION  %%%%%%%%%%%%%
%
% Matrices de inicio
im = 1+ int16((double(perf) / double(max(perf(:))) *63)) ; % Paso la imagen de perfusion a escala de grises de 1 a 64 
im_perf = zeros(size(T1,1),size(T1,2),3, size(T1,3)); % Inicio Matriz de imagenes de perfusión con ceros (RGB)
CBV = zeros(size(T1)); % Inicio Matriz de imagenes de CBV con ceros
%
f = figure(2); % Nueva Fig. 2
colormap gray; % Color escala de grises    
k =60; % Imagen inicial que muestro en Eje Axial
set(f,'WindowScrollWheelFcn',@mouseScrollWheel); %Cambio de imagen con la ruleta del ratón
t = 1; % Imagen que muestro en Eje Temporal (imagen t=1)
%
image(squeeze(im(:,:,k))); % Imagen
axis equal; % Establece igual relación entre ejes
axis tight; % Establece los límites del eje en el rango de datos
%
f2 = figure(3); % Nueva Fig. 3
set (f, 'WindowButtonMotionFcn', @mouseMove); % Muestra cambio en concentración en la imagen con movimiento del ratón
%
set (f, 'WindowKeyPressFcn', @arrowMove); % Cambio en el tiempo con flechas (Raya tiempos)
linea=line('XData',[t,t],'YData',[0,40],'Color',[.8 .8 .8]); % Variable linea para movernos en el tiempo
%
%%% Calculo Perfusion
%
Tmap_threshold = 1; % Umbral para deteccion de perfusion 
opacity = 0.4; % Muestra transparencia de la imagen
%
%Almacena valores RGB
T_im_RGB = zeros(size(T_im,1), size(T_im,2), 3); % Inicio Matriz T-im_RGB (Valores Anatomicos en grises en RGB)                  
CBV_RGB = zeros(size(CBV,1), size(CBV,2), 3); % Inicio Matriz CBV_RGB (Valores Perfusion en RGB)
compound_RGB = zeros(size(T_im,1), size(T_im,2), 3); % Inicio Matriz Compuesta RGB 
compound_total=zeros(size(perf,1),size(perf,2),3,size(perf,3)); % Inicio matriz de composición total (todas las imagenes van aqui)
%
% Calculo de tiempos
t1_total=35; % Contador t1_total
t2_total=0; % Contador  t2_total
i1_total=35; % Contador  11_total
i2_total=0; % Contador  i2_total
for tr=0:256 % Inicio bucle para buscar a lo lago de I
    for tp=0:256 % Inicio bucle para buscar a lo lago de T
    senal = squeeze(im(min(end,max(1,tr)),min(end,max(1,tp)), k, :)); % Utilizo la señal I-T
for i=1:29 % Inicio bucle 
    rep(i)=(senal(i+3)-senal(i))/((i+3)-(i)); % Realizo la derivada  de la señal I-T
end
[i1,t1]=min(rep); % Busco i1 t1 para los minimos valores
if i1<i1_total % Bucle para buscar nuevo valor t1_total
    t1_total=t1;
    i1_total=i1;
end
[i2,t2]=max(rep); % Busco i2 t2 para los maximos valores
if i2>i2_total  % Bucle para buscar nuevo valor t2_total
    t2_total=t2+3;
    i2_total=i2;  
end
    end
end
t1=t1_total; % Valor t1
t2=t2_total; % Valor t2
%
fprintf('\n RESULTADOS: \n');
T1_time = [' T1= ',num2str(t1),' segundos']; % Salida pantalla resultados de t1
T2_time = [' T2= ',num2str(t2),' segundos']; %  Salida pantalla  resultados de t2
%
% Calculo de MTT 
MTT=t2-t1; % Tiempo de transito
MTT_time = [' MTT= ',num2str(MTT),' segundos']; %  Salida pantalla  resultados de MTT
disp(MTT_time) % Muestro resultados en pantalla MTT
disp(T1_time) % Muestro resultados en pantalla t1
disp(T2_time) % Muestro resultados en pantalla t2
%
% Calculo de TTP 
[I,TTPi]=min(senal(t1:t2)); % Calculo TTP entre t1-t2 de mi señal I-T
TTP=TTPi+t1; % Valor TTP
TTP_time = [' TTP= ',num2str(TTP),' segundos']; %  Salida pantalla  resultados de TTP
disp(TTP_time) % Muestro resultados en pantalla TTP
[cpeaks,map_TTP]=max(im(:,:,:,t1:t2),[],4); % Mapa de Maxima concentración de gadolinio
%
% Calculo del resto de parametros
% Calculo de S0
s0=mean(im(:,:,:,2:t1),4); %Nivel de señal antes del contraste en la media del tiempo
%
%Calculo de C(t)
ct = -log(double(im)./repmat(s0,[1 1 1 size(im,4)]));% Concentración de contraste en cada instante de tiempo
%
%Integral volumen sanguineo
CBV=trapz(ct(:,:,:,t1:t2),4);% Calculo de volumen sanguineo entre t1 y t2
%
for ivalor=1:size(T_im,3) % Inicio Bucle para sacar todas las imagenes de perfusion
%
aux_CBV = squeeze(CBV(:,:,ivalor)); % Toma valor imagen de CBV
im_aux_T_im = squeeze(T_im(:,:,ivalor)); % Toma valor imagen anatomica
%
thresholded_Tmap = ( aux_CBV > Tmap_threshold ) .* aux_CBV; % Valoramos imagen de CBV respecto el umbral fijado
%
im_aux_CBV = thresholded_Tmap ./ max(max(thresholded_Tmap)); % Obtenemos CBV ya umbralizado
%
im_aux_CBV = 1+ int16((double(im_aux_CBV) / double(max(im_aux_CBV(:))) *63)) ; % Pasamos imagen anterior a grises
%
%Obtención imágen en gris
colormap gray; 
gray_cmap = colormap; 
%
%Obtención imágen en jet
colormap jet; 
jet_cmap = colormap; 
%
%Montado de imagenes en RGB
for RGB_dim = 1:3  %%% Bucle para colocar colores sobre la imagen (Grises para la Anatomica & RGB para el CBV)
    T_im_RGB(:,:,RGB_dim) = reshape( gray_cmap(im_aux_T_im, RGB_dim), size(im_aux_T_im)); % Seleccion Colores para T_im (anatomica)
    CBV_RGB(:,:,RGB_dim) = reshape( jet_cmap(im_aux_CBV, RGB_dim), size(im_aux_CBV)); % Seleccion Colores para CBV
end
%
for RGB_dim = 1:3,  % Bucle para componer la imagen con las dos figuras evaluando opacidad y umbral
    compound_RGB(:,:,RGB_dim) =(thresholded_Tmap==0) .* ... % Si Tmap=0 muestro imagen anatomica
        T_im_RGB(:,:,RGB_dim) + (thresholded_Tmap>0).* ... % Si Tmap>0 muestro CBV sobre imagen anatomica
        ( (1-opacity) * T_im_RGB(:,:,RGB_dim) + opacity * CBV_RGB(:,:,RGB_dim) );                    
end
%
compound_total(:,:,:,ivalor)=compound_RGB; % Cargo todas mis imagenes en mi matriz
%
end
figure (4) % Nueva Fig. 4
re=permute(compound_total,[1,2,4,3]); % Las ordeno para mostrar correctamente mi composicion de imagenes
imshow3Dfull(re)% Utilizo la funcion imshow3Dfull para mostrar la perfusion
%
%
for ivalor=1:size(T_im,3) % Inicio Bucle para sacar todas las imagenes TTP
%
aux_map_TTP = squeeze(map_TTP(:,:,ivalor)); % Toma valor imagen de TTP
im_aux_T_im = squeeze(T_im(:,:,ivalor)); % Toma valor imagen anatomica
%
thresholded_Tmap = ( aux_map_TTP > Tmap_threshold ) .* aux_map_TTP; % Valoramos imagen de CBV respecto el umbral fijado
%
im_aux_map_TTP = thresholded_Tmap ./ max(max(thresholded_Tmap)); % Obtenemos TTP ya umbralizado
%
im_aux_map_TTP = 1+ int16((double(im_aux_map_TTP) / double(max(im_aux_map_TTP(:))) *63)) ; % Pasamos imagen anterior a grises
%
%Obtención imágen en gris
colormap gray; 
gray_cmap = colormap; 
%
%Obtención imágen en prism
colormap prism; 
prism_cmap = colormap; 
%
%Montado de imagenes en RGB
for RGB_dim = 1:3  %%% Bucle para colocar colores sobre la imagen (Grises para la Anatomica & RGB para el TTP)
    T_im_RGB(:,:,RGB_dim) = reshape( gray_cmap(im_aux_T_im, RGB_dim), size(im_aux_T_im)); % Seleccion Colores para T_im (anatomica)
    map_TTP_RGB(:,:,RGB_dim) = reshape( prism_cmap(im_aux_map_TTP, RGB_dim), size(im_aux_map_TTP)); % Seleccion Colores para TTP
end
%
for RGB_dim = 1:3,  % Bucle para componer la imagen con las dos figuras evaluando opacidad y umbral
    compound_RGB(:,:,RGB_dim) =(thresholded_Tmap==0) .* ... % Si Tmap=0 muestro imagen anatomica
        T_im_RGB(:,:,RGB_dim) + (thresholded_Tmap>0).* ... % Si Tmap>0 muestro TTP sobre imagen anatomica
        ( (1-opacity) * T_im_RGB(:,:,RGB_dim) + opacity * map_TTP_RGB(:,:,RGB_dim) );                    
end
%
compound_total(:,:,:,ivalor)=compound_RGB; % Cargo todas mis imagenes en mi matriz
%
end
figure (5) % Nueva Fig. 5
re=permute(compound_total,[1,2,4,3]); % Las ordeno para mostrar correctamente mi composicion de imagenes
imshow3Dfull(re)% Utilizo la funcion imshow3Dfull para mostrar TTP sobre imagen anatomica



