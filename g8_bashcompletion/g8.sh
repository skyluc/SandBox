_g8()
{
        local cur
        COMPREPLY=()

	cur="${COMP_WORDS[COMP_CWORD]}"

        if [ \( $COMP_CWORD -gt 2 \) -o \( \( $COMP_CWORD -eq 2 \) -a \( -z "$cur" \) \) ]
	then
	  return 0
	fi


        opts=$(g8 --list | awk '{print $1}')

	COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

complete -F _g8 g8

