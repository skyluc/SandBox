_g8()
{
        local cur
        COMPREPLY=()

	cur="${COMP_WORDS[COMP_CWORD]}"

        if [ \( $COMP_CWORD -gt 2 \) -o \( \( $COMP_CWORD -eq 2 \) -a \( -z "$cur" \) \) ]
	then
	  return 0
	fi

	( _g8_fetch & )

	opts="test test2"

	COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )

	echo $COMPREPLY > /tmp/g8_bashcompletion_result

        COMPREPLY=( "g8 completion caching in progress." "please wait." )
}

_g8_fetch()
{
	g8 --list | awk '{print $1}' > /tmp/g8_bashcompletion_list_cache &
}

complete -F _g8 g8

