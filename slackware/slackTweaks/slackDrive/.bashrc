alias slu='slackpkg update && slackpkg install-new && slackpkg upgrade-all && slackpkg clean-system'
##alias slu32="cd && lftp -c 'open http://slackware.com/~alien/multilib/ ; mirror current' && cd current && upgradepkg --reinstall --install-new *.t?z && cd slackware64-compat32 && upgradepkg --install-new *-compat32/*.t?z && cd"

export PS1='<\u@\h>:\w$ '

echo '
                                                                 #####
                                                                #######
                   #                                            ##O#O##
  ######          ###                                           #VVVVV#
    ##             #                                          ##  VVV  ##
    ##         ###    ### ####   ###    ###  ##### #####     #          ##
    ##        #  ##    ###    ##  ##     ##    ##   ##      #            ##
    ##       #   ##    ##     ##  ##     ##      ###        #            ###
    ##          ###    ##     ##  ##     ##      ###       QQ#           ##Q
    ##       # ###     ##     ##  ##     ##     ## ##    QQQQQQ#       #QQQQQQ
    ##      ## ### #   ##     ##  ###   ###    ##   ##   QQQQQQQ#     #QQQQQQQ
  ############  ###   ####   ####   #### ### ##### #####   QQQQQ#######QQQQQQ
'

/usr/games/fortune

echo ' '
