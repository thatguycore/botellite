;The Botellite v1 c3 ts3
;Created by ThatGuyCore
;https://github.com/thatguycore/botellite

;even that triggers when script is loaded. sets boss variable, creates and writes line to twitch_msg.txt, opens file in notepad.exe
on 1:load:{
  if (!%tw_boss) {
    twitch_boss
  }
  if (!%tw_timer) {
    twitch_time
  }
  if (!$isfile(twitch_msg.txt)) { 
    write twitch_msg.txt Add each line you want the bot to say in this file one after another. Remove this line!
    run notepad.exe twitch_msg.txt 
  }

}

;sets variable that tells script who the boss is
alias twitch_boss { set %tw_boss $input(What is your Twitch username?, e, Twitch Username, Username) }
alias twitch_time { set %tw_timer $input(How often in seconds do you want messages to play?, e, SECONDS, 600) }
alias twitch_rand { 
  set %tw_rand $input(Do you want messages to be random?, y, Random?) 
  if (%tw_rand == $false) { set %tw_msgn 1  }
}

;alias used to open file used to store messages with notepad.exe
alias twmsg_open { run notepad.exe twitch_msg.txt }

;alias used to read file to send message
alias twmsg_send { 
  if (%tw_rand == $true) {
    var %tw_r_s %tw_msgn
    :redo
    set %tw_msgn $rand(1,$lines(twitch_msg.txt))
    if (%tw_msgn == %tw_r_s) { goto redo } 
    else { return $read(twitch_msg.txt,%tw_msgn) }
  }
  else {
    if (!%tw_msgn) { 
      set %tw_msgn 1
      var %tw_msg_lo $read(twitch_msg.txt,%tw_msgn)
      return %tw_msg_lo
    }
    if (%tw_msgn < $lines(twitch_msg.txt)) {
      var %tw_msg_lo $read(twitch_msg.txt,%tw_msgn)
      inc %tw_msgn 1
      return %tw_msg_lo
    } 
    if (%tw_msgn == $lines(twitch_msg.txt)) { 
      var %tw_msg_lo $read(twitch_msg.txt,%tw_msgn)
      set %tw_msgn 1
      return %tw_msg_lo 
  } }
}

;/tw_act_time activates timer
alias tw_act_time { .timertwm 0 %tw_timer msg $+($chr(35),%tw_boss) $!twmsg_send }

;/tw_stp_time disables timer
alias tw_stp_time { .timertwm off }



on 1:join:#:{
  if (($chan == $+($chr(35),%tw_boss)) && ($nick == $me)) { tw_act_time }
}

on 1:part:#:{
  if (($chan == $+($chr(35),%tw_boss)) && ($nick == $me)) { tw_stp_time }
}

on 1:text:*:#:{
  ;checks to see if message is sent in your twitch channe
  if ($chan == $+($chr(35),%tw_boss)) { 
    ;checks to see if message is sent by you
    if ($nick == %tw_boss) {
      if ($1 == !addmsg) {
        write twitch_msg.txt $2- | msg $chan Added message!
} } } }

menu channel {
  Botellite
  .Enable and Disable
  ..Enable:tw_act_time | echo * Bot enabled 
  ..Disable:tw_stp_time | echo * Bot Disabled
  .Config
  ..Set Bot Master:twitch_boss
  ..Set Message Timer:twitch_time
  ..Set Random:twitch_rand
  ..Open Message File:run notepad.exe twitch_msg.txt 
}
