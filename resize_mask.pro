;Resizes a mask file (0 and 1) using majority rule.


Pro resize_mask, infile, outfile, inxdim, inydim, win_size

	openr, inlun, infile, /get_lun
	openw, outlun, outfile, /get_lun

	in_block = bytarr(inxdim, win_size)

	out_x_dim = ulong(inxdim/win_size)
  out_y_dim = ulong(inydim/win_size)

	out_line = bytarr(out_x_dim)
	cur_win = bytarr(win_size,win_size)

	for j=0ULL, out_y_dim-1 do begin

		readu, inlun, in_block
		for i=0ULL, out_x_dim-1 do begin
			cur_win[*] = in_block[i*win_size:i*winsize+(win_size-1),*]
			index = where(cur_win eq 0, count)
			if (count lt win_size*win_size/2) then out_line[i]=1 else out_line[i] = 0
		endfor
		writeu, outlun, out_line

	endfor

	free_lun, inlun, outlun

End
