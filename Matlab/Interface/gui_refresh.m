function gui_refresh(handles)
  % refait l'affichage
        
  Y=handles.Y;
  r=handles.rect;
  idx_image=handles.currentimage;
  rt_info=handles.rt_info;
  
  Y1 =imadjust(squeeze( Y(:,:,1,idx_image)));
  Ys1=Y1(r(1)+2:r(1)+r(3)-1-2,r(2)+2:r(2)+r(4)-1-2,:);
  axes(handles.axes1);
  cla;
  if (isequal(rt_info,0))
    imagesc(Y1);
    colormap('gray');
    axis image;
  else
      hold on;
      imagesc(Y1);
      colormap('gray');
      axis image;
      contoursY1=add_RT(handles.info(idx_image),handles.rt_info);
      display_RT(contoursY1);
      hold off;
  end

  axes(handles.axes2);
  cla;
   if (isequal(rt_info,0))
    imagesc(Ys1);
    colormap('gray');
    axis image;
  else
      hold on;
      imagesc(Ys1);
      colormap('gray');
      axis image;
      contoursYs1=add_RT(handles.info(idx_image),handles.rt_info,r(2)+2-1,r(1)+2-1,0);
      display_RT(contoursYs1);
      hold off;
  end

end
