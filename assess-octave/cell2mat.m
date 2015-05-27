function [m] = cell2mat(c)

  ## check argument
  if nargin != 1
    error("cell2mat: you must supply one arguments\n");
  endif
  if !iscell(c)
    error("cell2mat: c has to be a cell\n");
  endif
  
  ## number of elements
  nb = numel(c);

  ## some trivial cases
  if nb == 0
    m = [];
    return
  elseif nb == 1
    if isnumeric(c{1}) || ischar(c{1}) || islogical(c{1})
      m = c{1};
    elseif iscell(c{1})
      m = cell2mat(c{1})
    else
      error("cell2mat: type %s is not handled properly\n", typeinfo(c{1}));
    endif
    return
  endif

  ## n dimensions case
  for k=ndims(c):-1:2,
    sz = size (c);
    sz (end) = 1;
    c1 = cell (sz);
    for i=1:prod(sz),
      c1{i} = cat (k, c{i:prod(sz):end});
    endfor
    c = c1;
  endfor
  m = cat(1, c1{:});

endfunction
