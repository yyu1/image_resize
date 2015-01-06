;Resizes input image

;infile - full path name to input file
;outfile - full path name to output file (will be overwritten)

;inxdim - x dimension of input image
;inydim - y dimension of input image
;winsize - window size for resizing, output will be (inxdim / winsize) and (inydim / winsize) , extra pixels at the end will be ignored


Pro resize_image_flt, infile, out_mean_file, out_stdev_file, inxdim, inydim, win_size
	openr, inlun, infile, /get_lun
	openw, out_mean_lun, out_mean_file, /get_lun
	openw, out_stdv_lun, out_stdev_file, /get_lun

	in_block = fltarr(inxdim, win_size)

	out_x_dim = ulong(inxdim/win_size)
	out_y_dim = ulong(inydim/win_size)

	out_mean_line = fltarr(out_x_dim)
	out_stdv_line = fltarr(out_x_dim)

	cur_win = fltarr(win_size, win_size)

	for j = 0ULL, out_y_dim-1 do begin
		readu, inlun, in_block
		for i=0ULL, out_x_dim-1 do begin
			cur_win[*] = in_block[i*win_size:i*win_size+(win_size-1),*]
			result = moment(cur_win, maxmoment=2, sdev=stdev)
			out_mean_line[i] = result[0]
			out_stdv_line[i] = stdev
		endfor

		writeu, out_mean_lun, out_mean_line
		writeu, out_stdv_lun, out_stdv_line
	endfor


	free_lun, inlun, out_mean_lun, out_stdv_lun

End
