# Defined in /var/folders/95/n5y8gx7s32zf699qn8x45zfw0000gn/T//fish.UEUB6t/__fish_describe_command.fish @ line 2
function __fish_describe_command --description 'Command used to find descriptions for commands'
	
    # TODO: stop interpolating argv into regex, and remove this hack.
    # string match --quiet --regex '^[a-zA-Z0-9_ ]+$' -- "$argv"
    # or return
    # type -q apropos; or return
    # apropos $argv 2>/dev/null | awk -v FS=" +- +" '{
		# split($1, names, ", ");
		# for (name in names)
			# if (names[name] ~ /^'"$argv"'.* *\([18]\)/ ) {
				# sub( "( |\t)*\\\([18]\\\)", "", names[name] );
				# sub( " \\\[.*\\\]", "", names[name] );
				# print names[name] "\t" $2;
			# }
	# }'
end
