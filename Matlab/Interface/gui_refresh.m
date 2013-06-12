function gui_refresh(Y1,dcm_info,rt_info)
  % refait l'affichage

  if (isequal(rt_info,0))
    imagesc(Y1);
    colormap('gray');
    axis image;
  else
      hold on;
      imagesc(Y1);
      colormap('gray');
      axis image;
      contoursY1=add_RT(dcm_info,rt_info);
      display_RT(Y1,contoursY1);
      hold off;
    end


end
