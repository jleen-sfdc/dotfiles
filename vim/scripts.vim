if did_filetype()
    finish
endif
if getline(1) =~ '\c^<%@\s*webservice.\+Language="c#".*%>'
    setfiletype cs
elseif getline(1) =~ '\c^<%@\s*webservice.\+Language="vb".*%>'
    setfiletype vb
elseif getline(1) =~ '.*- Perl -.*'
    setfiletype perl
    echo "foo\nbar"
endif